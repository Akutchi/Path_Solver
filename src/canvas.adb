with Constants; use Constants;

with Ada.Text_IO; use Ada.Text_IO;

package body Canvas is

   ----------
   -- Draw --
   ----------

   overriding procedure Draw
     (Item : access Display_Item_Record; Cr : Cairo_Context)
   is
   begin
      Set_Source_RGBA
        (Cr, Item.Color.Red, Item.Color.Green, Item.Color.Blue,
         Item.Color.Alpha);
      Cairo.Rectangle (Cr, 0.5, 0.5, Gdouble (Item.W), Gdouble (Item.H));
      Cairo.Fill (Cr);

   end Draw;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Item   : access Display_Item_Record'Class;
      Canvas : access Interactive_Canvas_Record'Class)
   is

      Can_Config : Canvas_Configuration;

   begin

      Item.Canvas := Interactive_Canvas (Canvas);
      Item.Color  := Plain;
      Item.W      := Can_Config.Case_Width;
      Item.H      := Can_Config.Case_Height;

      Set_Screen_Size (Item, Item.W, Item.H);

   end Initialize;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Canvas : out Image_Canvas) is
   begin

      Canvas := new Image_Canvas_Record;
      Initialize (Canvas);

   end Gtk_New;

   -------------------
   -- Initial_Setup --
   -------------------

   procedure Initial_Setup (Canvas : access Interactive_Canvas_Record'Class) is

      Win_Config : Window_Configuration;
      Can_Config : Canvas_Configuration;

      Width_Nb    : constant Gint := Can_Config.Width / Can_Config.Case_Width;
      Height_Nb : constant Gint := Can_Config.Height / Can_Config.Case_Height;
      Case_Number : constant Gint := Width_Nb * Height_Nb;

   begin

      Put_Line (Gint'Image (Case_Number));

      for N in 0 .. Case_Number loop

         declare
            Item_n : constant Display_Item := new Display_Item_Record;
            I      : constant Gint         := N / Can_Config.Case_Width;
            J      : constant Gint         := N mod Can_Config.Case_Height;
         begin
            Initialize (Item_n, Canvas);
            Put
              (Canvas, Item_n, I * Can_Config.Case_Width,
               J * Can_Config.Case_Height);

            Put_Line (Gint'Image (I) & " " & Gint'Image (J));
         end;

      end loop;

   end Initial_Setup;

end Canvas;
