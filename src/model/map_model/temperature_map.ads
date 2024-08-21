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
   --  Two temperature need smoothing if they are two extreme for one another.
   --
   --  With the current cnfiguration, that means if :
   --  Warm (int 1) is close to Cold (3) or Freezing (4) Or
   --  Freezing (int 4) is close to Temperate (2) or Warm (1).
   --
   --  Thus it is possible to check if the difference is greater than 2.
   --  And it is possible to check for a neighbourhood by checking if the
   --  difference is greater than 4 in non Border case, 2 otherwise.

   procedure Print_Map_Z5 (T_M : Temperature_Map_Z5);

   procedure Show_Temperature_Model
     (Temp_Map : Temperature_Map_Z5; Current_Zoom : Positive);

end Temperature_Map;
