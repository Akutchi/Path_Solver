with Glib;     use Glib;
with Gdk.RGBA; use Gdk.RGBA;

package Constants is

   type Window_Configuration is record

      Width       : Gint := 600;
      Height      : Gint := 600;
      Case_Width  : Gint := 25;
      Case_Height : Gint := 25;

   end record;

   Green : constant Gdk_RGBA := (1.0, 0.0, 0.0, 1.0);

end Constants;
