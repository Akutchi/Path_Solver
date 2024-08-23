------------------------------------------------------------------------------
--                                                                          --
-- Gtk.RGBA and Image_IO do not have the same way of handling RGB colors.   --
-- The first use float (Gdouble) between 0.0 and 1.0 and the second integer --
-- between 0 and 255.                                                       --
--                                                                          --
-- In general this package is about all manipulations that are used during  --
-- the map generation.                                                      --
--                                                                          --
------------------------------------------------------------------------------

with Interfaces;

with Glib;     use Glib;
with Gdk.RGBA; use Gdk.RGBA;

with Image_IO; use Image_IO;

with Random_Position; use Random_Position;

package RGBA is

   Image_Destination      : constant String := "../layer_templates/";
   Pixel_Type             : constant String := "../layer_templates/res.txt";
   Relative_Path_From_Bin : constant String := "../src/image_manipulation/";
   No_Pixel               : constant String := "none";

   type Precision is digits 3 range 0.0 .. 1.0;

   type Array_Gdouble is array (Natural range 0 .. 2) of Gdouble;

   function "=" (Lossy_Color : Gdk_RGBA; To : Gdk_RGBA) return Boolean;

   procedure Create_Image (Name : String; Zoom : Positive);

   function UInt8_To_Gdouble (c : Interfaces.Unsigned_8) return Gdouble;

   function Gdouble_To_UInt8 (x : Gdouble) return Interfaces.Unsigned_8;

   function Color_Info_To_GdkRGBA (Color : Color_Info) return Gdk_RGBA;
   --  In the (R,G,B) float format

   function GdkRGBA_To_Color_Info (Color : Gdk_RGBA) return Color_Info;
   --  In the (R,G,B) integer format

   function Flatten (c : Gdk_RGBA) return Gdk_RGBA;
   --  truncate color components to their first decimal (e.g 0.29 -> 0.2)

   procedure Put_Pixel
     (Data : in out Image_Data; X, Y : Pos; Color : Gdk_RGBA);

   function Get_Pixel_Color (Data : Image_Data; X, Y : Pos) return Color_Info;
   --  In the (R,G,B) integer format

private

   function Almost_Equal (x, y : Gdouble; epsilon : Precision) return Boolean;

end RGBA;
