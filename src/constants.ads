with Glib;     use Glib;
with Gdk.RGBA; use Gdk.RGBA;

package Constants is

   type Window_Configuration is record

      Width  : Gint := 660;
      Height : Gint := 660;

   end record;

   type Canvas_Configuration is record

      Width  : Gint := 660;
      Height : Gint := 600;

      Case_Width  : Gint := 25;
      Case_Height : Gint := 25;

   end record;

   Plain   : constant Gdk_RGBA := (0.13, 0.71, 0.40, 1.0); -- green
   Moutain : constant Gdk_RGBA := (0.71, 0.44, 0.13, 1.0); -- maroon
   Water   : constant Gdk_RGBA := (0.06, 0.68, 0.87, 1.0); -- blue
   Ocean   : constant Gdk_RGBA := (0.06, 0.44, 0.87, 1.0); -- deep blue

end Constants;
