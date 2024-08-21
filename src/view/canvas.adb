with Image_IO;            use Image_IO;
with Image_IO.Holders;    use Image_IO.Holders;
with Image_IO.Operations; use Image_IO.Operations;

with RGBA;            use RGBA;
with Random_Position; use Random_Position;

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
      Color  : Gdk_RGBA := Rocks)
   is

      Can_Config : Canvas_Configuration;

   begin

      Item.Canvas := Interactive_Canvas (Canvas);
      Item.Color  := Color;
      Item.W      := Can_Config.Case_Width;
      Item.H      := Can_Config.Case_Height;

      Set_Screen_Size (Item, Item.W, Item.H);

   end Initialize;

   -------------------
   -- Initial_Setup --
   -------------------

   procedure Initial_Setup (Canvas : access Interactive_Canvas_Record'Class) is

      Can_Config : Canvas_Configuration;
      Width_Nb   : constant Gint := Can_Config.Width / Can_Config.Case_Width;
      Height_Nb  : constant Gint := Can_Config.Height / Can_Config.Case_Height;

      Max_Item : constant Gint := Width_Nb * Height_Nb - 1;

      Image : Handle;

   begin

      Read (Map_Destination, Image);

      declare

         Data : constant Image_Data := Image.Value;

      begin

         for k in 0 .. Max_Item loop

            declare
               Item_k : constant Display_Item := new Display_Item_Record;

               I : constant Gint := k / Width_Nb;
               J : constant Gint := k mod Height_Nb;
               X : constant Gint := I * Can_Config.Case_Width;
               Y : constant Gint := J * Can_Config.Case_Height;

               Color : constant Gdk_RGBA :=
                 Color_Info_To_GdkRGBA
                   (Get_Pixel_Color (Data, Pos (J), Pos (I)));

            begin

               Initialize (Item_k, Canvas, Color);
               Put (Canvas, Item_k, X, Y);
            end;

         end loop;

      end;

   end Initial_Setup;

end Canvas;
