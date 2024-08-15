------------------------------------------------------------------------------
--                                                                          --
--                                                                          --
-- Gtk.RGBA and PIL do not have the same way to handle RGB colors.          --
-- The first use float (Gdouble) between 0.0 and 1.0 and the second integer --
-- between 0 and 255.                                                       --
--                                                                          --
-- Moreover, in order for the python bindings to work, one must be          --
-- able to transform those value in strings.                                --
--                                                                          --
-- In general this package is about all manipulations that are used during  --
-- the map generation.                                                      --
--                                                                          --
------------------------------------------------------------------------------

with Interfaces.C;

with Glib;     use Glib;
with Gdk.RGBA; use Gdk.RGBA;

with Generation.Random_Position; use Generation.Random_Position;

package RGBA is

   package C renames Interfaces.C;
   use type C.int;

   function system (command : C.char_array) return C.int with
     Import, Convention => C;

   result : C.int;

   Image_Destination      : constant String := "../layer_templates/";
   Pixel_Type             : constant String := "../layer_templates/res.txt";
   Relative_Path_From_Bin : constant String := "../src/image_manipulation/";
   No_Pixel               : constant String := "none";

   type Precision is digits 3 range 0.0 .. 1.0;

   type Array_Gdouble is array (Natural range 0 .. 2) of Gdouble;

   function "=" (Lossy_Color : Gdk_RGBA; To : Gdk_RGBA) return Boolean;

   procedure Create_Image (Name : String; Zoom : Positive);

   procedure Put_Pixel (Name : String; X, Y : Pos; Color : Gdk_RGBA);

   function Get_Pixel_Color (Source : String; X, Y : Pos) return String;
   --  In the (R,G,B) integer format

   function Convert_GdkRGBA_To_String (Color : Gdk_RGBA) return String;
   --  In the "R,G,B" format

   function Convert_String_To_GdkRGBA (Color_Str : String) return Gdk_RGBA;

private

   function Almost_Equal (x, y : Gdouble; epsilon : Precision) return Boolean;

   function Float_To_Int_RGB (x : Gdouble) return Integer;

   function Integer_To_String_RGB (n : Integer) return String;

end RGBA;
