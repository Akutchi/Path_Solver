------------------------------------------------------------------------------
--                                                                          --
--                                                                          --
-- Gtk.RGBA and ImageMagick do not have the same way to handle RGB colors.  --
-- The first use float (Gdouble) between 0.0 and 1.0 and the second integer --
-- between 0 and 255.                                                       --
--                                                                          --
-- Moreover, in order for the ImageMagick bindings to work, one must be     --
-- able to transform those value in strings.                                --
--                                                                          --
------------------------------------------------------------------------------

with Glib; use Glib;

package Generation.gtkRGBA_To_IMRGBA is

   function Convert_GdkRGBA_To_String (Color : Gdk_RGBA) return String;

private

   function Float_To_Int_RGB (x : Gdouble) return Integer;

   function Integer_To_String_RGB (n : Integer) return String;

end Generation.gtkRGBA_To_IMRGBA;
