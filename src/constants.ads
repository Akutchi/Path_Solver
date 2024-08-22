with Glib;     use Glib;
with Gdk.RGBA; use Gdk.RGBA;

package Constants is

   Map_Destination : constant String := "../layer_templates/Layer_6.png";

   type Window_Configuration is record

      Width  : Gint := 680;
      Height : Gint := 680;

   end record;

   type Canvas_Configuration is record

      Width  : Gint := 640;
      Height : Gint := 640;

      Case_Width  : Gint := 4;
      Case_Height : Gint := 4;

   end record;

   --  When changed here, also have to change values in
   --   - random_position.ads
   --   - temperature_map.ads
   --   - cost_map.ads

   Z1 : constant Positive := 5;
   Z2 : constant Positive := 10;
   Z3 : constant Positive := 20;
   Z4 : constant Positive := 40;
   Z5 : constant Positive := 80;
   Z6 : constant Positive := 160;
   Z7 : constant Positive := 320;

   Ocean      : constant Gdk_RGBA := (0.06, 0.44, 0.87, 1.0);
   Deep_Ocean : constant Gdk_RGBA := (0.06, 0.40, 0.60, 1.0);

   --  Don't change colors. Hash Map in Dijsktra_Model.adb depends on them.

   --  Temperature Type                               --  Aparition percentage

   --  Warm
   Desert : constant Gdk_RGBA := (0.94, 0.88, 0.61, 1.0);            --  80%

   Mesa       : constant Gdk_RGBA := (0.92, 0.57, 0.31, 1.0);        --  20%
   Mesa_Hills : constant Gdk_RGBA := (0.78, 0.43, 0.25, 1.0);

   --  Equatorial
   Rainforest       : constant Gdk_RGBA := (0.36, 0.51, 0.09, 1.0);
   Rainforest_Hills : constant Gdk_RGBA := (0.28, 0.43, 0.08, 1.0);

   Jungle      : constant Gdk_RGBA := (0.14, 0.38, 0.09, 1.0);
   Jungle_Tree : constant Gdk_RGBA := (0.14, 0.34, 0.12, 1.0);

   --  Temperate
   Forest       : constant Gdk_RGBA := (0.30, 0.45, 0.22, 1.0);
   Forest_Trees : constant Gdk_RGBA := (0.24, 0.39, 0.18, 1.0);

   Rocks       : constant Gdk_RGBA := (0.50, 0.50, 0.50, 1.0);
   Rocky_Hills : constant Gdk_RGBA := (0.41, 0.41, 0.40, 1.0);

   --  Cold
   SnowyTaiga      : constant Gdk_RGBA := (0.28, 0.51, 0.26, 1.0);
   SnowyTaiga_Snow : constant Gdk_RGBA := (0.95, 0.97, 0.94, 1.0);

   Snowy       : constant Gdk_RGBA := (1.0, 1.0, 1.0, 1.0);
   Snowy_Hills : constant Gdk_RGBA := (0.71, 0.71, 0.70, 1.0);

   --  Freezing
   Ice       : constant Gdk_RGBA := (0.60, 0.80, 1.0, 1.0);
   Ice_Hills : constant Gdk_RGBA := (0.46, 0.69, 0.92, 1.0);

   SnowIce        : constant Gdk_RGBA := (0.98, 0.98, 0.98, 1.0);
   SnowyIce_Hills : constant Gdk_RGBA := (0.57, 0.82, 0.98, 1.0);

   type BiomeGroup is array (Natural range 0 .. 1) of Gdk_RGBA;

   Warm_Group       : BiomeGroup := (Desert, Mesa);
   Equatorial_Group : BiomeGroup := (Rainforest, Jungle);
   Temperate_Group  : BiomeGroup := (Forest, Rocks);
   Cold_Group       : BiomeGroup := (SnowyTaiga, Snowy);
   Freezing_Group   : BiomeGroup := (Ice, SnowIce);

   --  test gradient

   Dark_Red  : constant Gdk_RGBA := (1.0, 0.0, 0.0, 1.0);
   Red       : constant Gdk_RGBA := (1.0, 0.31, 0.31, 1.0);
   White     : constant Gdk_RGBA := (1.0, 1.0, 1.0, 1.0);
   Blue      : constant Gdk_RGBA := (0.50, 0.50, 1.0, 1.0);
   Dark_Blue : constant Gdk_RGBA := (0.0, 0.0, 1.0, 1.0);

end Constants;
