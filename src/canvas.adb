with Ada.Text_IO; use Ada.Text_IO;

package body Canvas is

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Canvas : out Image_Canvas) is
   begin

      Canvas := new Image_Canvas_Record;
      Initialize (Canvas);

   end Gtk_New;

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
      Canvas : access Interactive_Canvas_Record'Class;
      Color  : Gdk_RGBA := Plain)
   is

      Can_Config : Canvas_Configuration;

   begin

      Item.Canvas := Interactive_Canvas (Canvas);
      Item.Color  := Color;
      Item.W      := Can_Config.Case_Width;
      Item.H      := Can_Config.Case_Height;

      Set_Screen_Size (Item, Item.W, Item.H);

   end Initialize;

   procedure Update
     (Canvas : access Interactive_Canvas_Record'Class; Color : Gdk_RGBA;
      I, J   : Gint)
   is

      Can_Config : Canvas_Configuration;
      X          : constant Gint := I * Can_Config.Case_Width;
      Y          : constant Gint := J * Can_Config.Case_Height;

      Old_Item : constant Canvas_Item  := Item_At_Coordinates (Canvas, X, Y);
      Item     : constant Display_Item := new Display_Item_Record;

   begin

      Remove (Canvas, Old_Item);
      Initialize (Item, Canvas, Color);
      Put (Canvas, Item, X, Y);
      Refresh (Canvas);
      Show_Item (Canvas, Item);

   end Update;

   -------------------
   -- Initial_Setup --
   -------------------

   procedure Initial_Setup (Canvas : access Interactive_Canvas_Record'Class) is

      Can_Config : Canvas_Configuration;
      Max_Item   : constant Integer := Case_Number;

   begin

      for k in 0 .. Max_Item loop

         declare
            Item_k : constant Display_Item := new Display_Item_Record;

            I : constant Gint := Gint (k) / Can_Config.Case_Width;
            J : constant Gint := Gint (k) mod Can_Config.Case_Height;
            X : constant Gint := I * Can_Config.Case_Width;
            Y : constant Gint := J * Can_Config.Case_Height;

         begin
            Initialize (Item_k, Canvas);
            Put (Canvas, Item_k, X, Y);
         end;

      end loop;

   end Initial_Setup;

end Canvas;
