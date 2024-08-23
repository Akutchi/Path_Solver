with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Float_Random;

package Temperature_Map is

   Model_Name : constant String := "Temperature_Map.png";

   type Temperature_Type is range 1 .. 5;

   Warm       : constant Temperature_Type := 1;
   Equatorial : constant Temperature_Type := 2;
   Temperate  : constant Temperature_Type := 3;
   Cold       : constant Temperature_Type := 4;
   Freezing   : constant Temperature_Type := 5;

   package Random_Temperature is new Ada.Numerics.Discrete_Random
     (Temperature_Type);

   G_T : Random_Temperature.Generator;
   Gf  : Ada.Numerics.Float_Random.Generator;

   type Lign_Type is new Natural;

   subtype Row_Z5 is Lign_Type range 0 .. 79;
   subtype Col_Z5 is Lign_Type range 0 .. 79;

   subtype Not_Border_Row is
     Lign_Type range Row_Z5'First + 1 .. Row_Z5'Last - 1;

   subtype Not_Border_Col is
     Lign_Type range Col_Z5'First + 1 .. Col_Z5'Last - 1;

   type Temperature_Map_Z5 is array (Row_Z5, Col_Z5) of Temperature_Type;

   procedure Init_Temperature_Map_Z5
     (Temperature_Map : out Temperature_Map_Z5);

   procedure Smooth_Temperature (Temperature_Map : out Temperature_Map_Z5);
   --  Because of perlin noise's caracteristic at grid point, there is a null
   --  gradient resulting in a singularity, which feels off when plotted at the
   --  biome layer.

   procedure Print_Map_Z5 (T_M : Temperature_Map_Z5);

   procedure Show_Temperature_Model
     (Temp_Map : Temperature_Map_Z5; Current_Zoom : Positive);

end Temperature_Map;
