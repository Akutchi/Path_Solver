with Constants; use Constants;

package body Canvas is

   procedure Initialize
     (Item   : access Display_Item_Record'Class;
      Canvas : access Interactive_Canvas_Record'Class)
   is

      Win_Config : Window_Configuration;

   begin

      Item.Canvas := Interactive_Canvas (Canvas);
      Item.Color  := Green;
      Item.W      := Win_Config.Case_Width;
      Item.H      := Win_Config.Case_Height;

      Set_Screen_Size (Item, Item.W, Item.H);

   end Initialize;

   procedure Gtk_New (Canvas : out Image_Canvas) is
   begin

      Canvas := new Image_Canvas_Record;
      Initialize (Canvas);

   end Gtk_New;

   procedure Initial_Setup (Canvas : access Interactive_Canvas_Record'Class) is

      Win_Config  : Window_Configuration;
      Case_Number : constant Gint :=
        (Win_Config.Width / Win_Config.Case_Width) *
        (Win_Config.Height / Win_Config.Case_Height);
   begin

      for I in 1 .. Case_Number loop

         declare
            Item_n : constant Display_Item := new Display_Item_Record;
            Row    : constant Gint         := Case_Number / Win_Config.Width;
            Col    : constant Gint := Case_Number mod Win_Config.Height;

         begin
            Initialize (Item_n, Canvas);
            Put (Canvas, Item_n, Row, Col);
         end;

      end loop;

   end Initial_Setup;

   overriding procedure Draw
     (Item : access Display_Item_Record; Cr : Cairo_Context)
   is
   begin
      Set_Source_RGBA
        (Cr, Item.Color.Red, Item.Color.Green, Item.Color.Blue,
         Item.Color.Alpha);
      Cairo.Rectangle
        (Cr, 0.5, 0.5, Gdouble (Item.W) - 1.0, Gdouble (Item.H) - 1.0);
      Cairo.Fill (Cr);

   end Draw;

end Canvas;
