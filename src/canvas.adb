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
      Cairo.Rectangle (Cr, 0.0, 0.0, Gdouble (Item.W), Gdouble (Item.H));
      Cairo.Fill (Cr);

   end Draw;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
     (Item   : access Display_Item_Record'Class;
      Canvas : access Interactive_Canvas_Record'Class)
   is

      Win_Config : Window_Configuration;

   begin

      Item.Canvas := Interactive_Canvas (Canvas);
      Item.Color  := Plain;
      Item.W      := Win_Config.Case_Width;
      Item.H      := Win_Config.Case_Height;

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

      Win_Config    : Window_Configuration;
      Width_Number  : Gint := Win_Config.Width / Win_Config.Case_Width;
      Height_Number : Gint := Win_Config.Height / Win_Config.Case_Height;
      Case_Number   : Gint := Width_Number * Height_Number - 2; -- why Idfk

   begin

      for N in 0 .. Case_Number loop

         declare
            Item_n : constant Display_Item := new Display_Item_Record;
            I      : Gint                  := N / Win_Config.Case_Width;
            J      : Gint                  := N mod Win_Config.Case_Height;
         begin
            Initialize (Item_n, Canvas);
            Put
              (Canvas, Item_n, I * Win_Config.Case_Width,
               J * Win_Config.Case_Height);
         end;

      end loop;

   end Initial_Setup;

end Canvas;
