with Glib;     use Glib;
with Gdk.RGBA; use Gdk.RGBA;

package Constants is

   type Window_Configuration is record

      Width  : Gint := 680;
      Height : Gint := 680;

   end record;

   type Canvas_Configuration is record

      Width  : Gint := 640;
      Height : Gint := 640;

      Case_Width  : Gint := 128;
      Case_Height : Gint := 128;

   end record;

   Rocks         : constant Gdk_RGBA := (0.50, 0.50, 0.50, 1.0); --  Grey
   General_Hills : constant Gdk_RGBA := (0.70, 0.70, 0.70, 1.0); -- Darker grey
   Plain         : constant Gdk_RGBA := (0.13, 0.71, 0.40, 1.0); -- green
   Moutain       : constant Gdk_RGBA := (0.71, 0.44, 0.13, 1.0); -- maroon
   Water         : constant Gdk_RGBA := (0.06, 0.68, 0.87, 1.0); -- blue
   Ocean         : constant Gdk_RGBA := (0.06, 0.44, 0.87, 1.0); -- deep blue

end Constants;
