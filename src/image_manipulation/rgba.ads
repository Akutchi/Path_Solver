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

   type Array_Gdouble is array (Natural range 0 .. 2) of Gdouble;

   procedure Create_Image (Name : String; Zoom : Positive);

   procedure Put_Pixel (Name : String; X, Y : Integer; Color : Gdk_RGBA);

   function Get_Pixel_Color (Source : String; X, Y : Integer) return String;

   function Convert_GdkRGBA_To_String (Color : Gdk_RGBA) return String;

   function Convert_String_To_GdkRGBA (Color_Str : String) return Gdk_RGBA;

private

   function Float_To_Int_RGB (x : Gdouble) return Integer;

   function Integer_To_String_RGB (n : Integer) return String;

   function Strip_Space (S : String) return String;
   --  Thanks to s. wright for their solution :
   --  https://stackoverflow.com/a/29356929

end RGBA;
