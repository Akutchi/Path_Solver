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

   --  When changed here, also have to change values in
   --   - generation-random_position.ads
   --   - temperature_map.ads

   Z1 : constant Positive := 25;
   Z2 : constant Positive := 50;
   Z3 : constant Positive := 100;
   Z4 : constant Positive := 200;
   Z5 : constant Positive := 400;
   Z6 : constant Positive := 800;
   Z7 : constant Positive := 1_600;

   --  Generation
   Rocks       : constant Gdk_RGBA := (0.50, 0.50, 0.50, 1.0);
   Rocky_Hills : constant Gdk_RGBA := (0.30, 0.30, 0.30, 1.0);

   Ocean      : constant Gdk_RGBA := (0.06, 0.44, 0.87, 1.0);
   Deep_Ocean : constant Gdk_RGBA := (0.06, 0.40, 0.60, 1.0);

   --  Warm
   Desert       : constant Gdk_RGBA := (1.0, 0.77, 0.37, 1.0);
   Desert_Hills : constant Gdk_RGBA := (0.75, 0.44, 0.13, 1.0);

   -- Equatorial
   Rainforest       : constant Gdk_RGBA := (0.36, 0.51, 0.09, 1.0);
   Rainforest_Hills : constant Gdk_RGBA := (0.22, 0.27, 0.18, 1.0);

   --  Temperate
   Plain       : constant Gdk_RGBA := (0.58, 0.72, 0.41, 1.0);
   Plain_Hills : constant Gdk_RGBA := (0.15, 0.32, 0.07, 1.0);

   --  Cold
   Snowy       : constant Gdk_RGBA := (0.95, 0.95, 0.95, 1.0);
   Snowy_Hills : constant Gdk_RGBA := (0.70, 0.70, 0.70, 1.0);

   --  Freezing
   Ice       : constant Gdk_RGBA := (0.58, 1.0, 0.99, 1.0);
   Ice_Hills : constant Gdk_RGBA := (0.00, 0.63, 0.90, 1.0);

   --  test gradient

   Dark_Red  : constant Gdk_RGBA := (1.0, 0.0, 0.0, 1.0);
   Red       : constant Gdk_RGBA := (1.0, 0.31, 0.31, 1.0);
   White     : constant Gdk_RGBA := (1.0, 1.0, 1.0, 1.0);
   Blue      : constant Gdk_RGBA := (0.50, 0.50, 1.0, 1.0);
   Dark_Blue : constant Gdk_RGBA := (0.0, 0.0, 1.0, 1.0);

end Constants;
