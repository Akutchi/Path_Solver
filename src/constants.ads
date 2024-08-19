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

   Ocean      : constant Gdk_RGBA := (0.06, 0.44, 0.87, 1.0);
   Deep_Ocean : constant Gdk_RGBA := (0.06, 0.40, 0.60, 1.0);

   --  The following colors are taken from minecraft pictures

   --  Temperature Type                               --  Aparition percentage

   --  Warm
   Desert       : constant Gdk_RGBA := (1.0, 0.77, 0.37, 1.0);       --  50%
   Desert_Hills : constant Gdk_RGBA := (0.75, 0.44, 0.13, 1.0);

   Savana : constant Gdk_RGBA := (0.40, 0.38, 0.16, 1.0);            --  33%

   Mesa       : constant Gdk_RGBA := (0.78, 0.42, 0.15, 1.0);        --  17%
   Mesa_Hills : constant Gdk_RGBA := (0.50, 0.26, 0.11, 1.0);

   --  Equatorial
   Rainforest       : constant Gdk_RGBA := (0.36, 0.51, 0.09, 1.0);  --  70%
   Rainforest_Hills : constant Gdk_RGBA := (0.22, 0.27, 0.18, 1.0);

   Jungle      : constant Gdk_RGBA := (0.14, 0.38, 0.09, 1.0);       --  30%
   Jungle_Tree : constant Gdk_RGBA := (0.08, 0.24, 0.03, 1.0);

   --  Temperate
   Forest       : constant Gdk_RGBA := (0.30, 0.45, 0.22, 1.0);      --  50%
   Forest_Trees : constant Gdk_RGBA := (0.20, 0.25, 0.14, 1.0);

   Rocks       : constant Gdk_RGBA := (0.50, 0.50, 0.50, 1.0);       --  33%
   Rocky_Hills : constant Gdk_RGBA := (0.30, 0.30, 0.30, 1.0);

   Mushroom      : constant Gdk_RGBA := (0.42, 0.37, 0.38, 1.0);     --  17%
   Mushroom_Tree : constant Gdk_RGBA := (0.47, 0.35, 0.26, 1.0);

   --  Cold

   SnowyTaiga      : constant Gdk_RGBA := (0.26, 0.34, 0.21, 1.0);   --  50%
   SnowyTaiga_Snow : constant Gdk_RGBA := (0.95, 0.95, 0.95, 1.0);

   Snowy       : constant Gdk_RGBA := (0.95, 0.95, 0.95, 1.0);       --  33%
   Snowy_Hills : constant Gdk_RGBA := (0.70, 0.70, 0.70, 1.0);

   SnowyBeach      : constant Gdk_RGBA := (0.84, 0.80, 0.63, 1.0);   --  17%
   SnowyBeach_Snow : constant Gdk_RGBA := (0.95, 0.95, 0.95, 1.0);

   --  Freezing
   Ice       : constant Gdk_RGBA := (0.50, 0.61, 0.82, 1.0);         --  70%
   Ice_Hills : constant Gdk_RGBA := (0.00, 0.63, 0.90, 1.0);

   SnowIce        : constant Gdk_RGBA := (0.95, 0.95, 0.95, 1.0);    --  30%
   SnowyIce_Hills : constant Gdk_RGBA := (0.50, 0.61, 0.82, 1.0);

   type BiomeGroup is array (Natural range 0 .. 2) of Gdk_RGBA;

   Warm_Group       : BiomeGroup := (Desert, Savana, Mesa);
   Equatorial_Group : BiomeGroup := (Rainforest, Jungle, Rocks); -- Rockschange
   Temperate_Group  : BiomeGroup := (Forest, Mushroom, Rocks);
   Cold_Group       : BiomeGroup := (SnowyTaiga, Snowy, SnowyBeach);
   Freezing_Group   : BiomeGroup := (Ice, SnowIce, Rocks); -- Rocks change

   --  test gradient

   Dark_Red  : constant Gdk_RGBA := (1.0, 0.0, 0.0, 1.0);
   Red       : constant Gdk_RGBA := (1.0, 0.31, 0.31, 1.0);
   White     : constant Gdk_RGBA := (1.0, 1.0, 1.0, 1.0);
   Blue      : constant Gdk_RGBA := (0.50, 0.50, 1.0, 1.0);
   Dark_Blue : constant Gdk_RGBA := (0.0, 0.0, 1.0, 1.0);

end Constants;
