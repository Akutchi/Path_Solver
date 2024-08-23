with Image_IO.Holders;    use Image_IO.Holders;
with Image_IO.Operations; use Image_IO.Operations;

package body RGBA is

   ------------------
   -- Almost_Equal --
   ------------------

   function Almost_Equal (x, y : Gdouble; epsilon : Precision) return Boolean
   is
   begin

      return Precision (abs (x - y)) < epsilon;

   end Almost_Equal;

   -------
   -- = --
   -------

   function "=" (Lossy_Color : Gdk_RGBA; To : Gdk_RGBA) return Boolean is

      epsilon : constant Precision := 0.01;

   begin

      return
        Almost_Equal (Lossy_Color.Red, To.Red, epsilon)
        and then Almost_Equal (Lossy_Color.Green, To.Green, epsilon)
        and then Almost_Equal (Lossy_Color.Blue, To.Blue, epsilon);

   end "=";

   ------------------
   -- Create_Image --
   ------------------

   procedure Create_Image (Name : String; Zoom : Positive) is

      Image : Handle;

   begin

      Create (Image, Zoom, Zoom);

      declare
         Data : constant Image_Data := Image.Value;
      begin
         Write_PNG (Image_Destination & Name, Data);
      end;

   end Create_Image;

   ----------------------
   -- UInt8_To_Gdouble --
   ----------------------

   function UInt8_To_Gdouble (c : Interfaces.Unsigned_8) return Gdouble is
   begin

      return Gdouble (Float (c) / 255.0);
   end UInt8_To_Gdouble;

   ----------------------
   -- Gdouble_To_UInt8 --
   ----------------------

   function Gdouble_To_UInt8 (x : Gdouble) return Interfaces.Unsigned_8 is
   begin
      return Interfaces.Unsigned_8 (Float'Rounding (Float (x) * 255.0));
   end Gdouble_To_UInt8;

   ---------------------------
   -- GdkRGBA_To_Color_Info --
   ---------------------------

   function GdkRGBA_To_Color_Info (Color : Gdk_RGBA) return Color_Info is

      Color_I : Color_Info;

   begin

      Color_I.Red   := Gdouble_To_UInt8 (Color.Red);
      Color_I.Green := Gdouble_To_UInt8 (Color.Green);
      Color_I.Blue  := Gdouble_To_UInt8 (Color.Blue);

      return Color_I;

   end GdkRGBA_To_Color_Info;

   ---------------------------
   -- Color_Info_To_GdkRGBA --
   ---------------------------

   function Color_Info_To_GdkRGBA (Color : Color_Info) return Gdk_RGBA is

      Color_Gdk : Gdk_RGBA;

   begin

      Color_Gdk.Red   := UInt8_To_Gdouble (Color.Red);
      Color_Gdk.Green := UInt8_To_Gdouble (Color.Green);
      Color_Gdk.Blue  := UInt8_To_Gdouble (Color.Blue);
      Color_Gdk.Alpha := 1.0;

      return Color_Gdk;

   end Color_Info_To_GdkRGBA;

   -------------
   -- Flatten --
   -------------

   function Flatten (c : Gdk_RGBA) return Gdk_RGBA is

      function trunc (x : Gdouble) return Gdouble;

      function trunc (x : Gdouble) return Gdouble is
      begin

         return Gdouble (0.1 * Float'Floor (10.0 * Float (x)));

      end trunc;

   begin
      return (trunc (c.Red), trunc (c.Green), trunc (c.Blue), c.Alpha);
   end Flatten;

   ---------------
   -- Put_Pixel --
   ---------------

   procedure Put_Pixel (Data : in out Image_Data; X, Y : Pos; Color : Gdk_RGBA)
   is

   begin

      Data (Natural (X), Natural (Y)) := GdkRGBA_To_Color_Info (Color);

   end Put_Pixel;

   ---------------------
   -- Get_Pixel_Color --
   ---------------------

   function Get_Pixel_Color (Data : Image_Data; X, Y : Pos) return Color_Info
   is
   begin
      return Data (Natural (X), Natural (Y));

   end Get_Pixel_Color;

end RGBA;
