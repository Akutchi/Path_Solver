with Ada.Numerics.Discrete_Random;

package Temperature_Map is

   type Temperature_Type is range 1 .. 4;

   package Random_Temperature is new Ada.Numerics.Discrete_Random
     (Temperature_Type);

   use Random_Temperature;

   G_T : Generator;

   Warm      : constant Temperature_Type := 1;
   Temperate : constant Temperature_Type := 2;
   Cold      : constant Temperature_Type := 3;
   Freezing  : constant Temperature_Type := 4;

   type Lign_Type is new Natural;

   subtype Row_20 is Lign_Type range 0 .. 19;
   subtype Col_20 is Lign_Type range 0 .. 19;

   subtype Not_Border_Row is
     Lign_Type range Row_20'First + 1 .. Row_20'Last - 1;

   subtype Not_Border_Col is
     Lign_Type range Col_20'First + 1 .. Col_20'Last - 1;

   type Temperature_Map_20 is array (Row_20, Col_20) of Temperature_Type;

   type Row_80 is range 0 .. 79;
   type Col_80 is range 0 .. 79;

   type Temperature_Map_80 is array (Row_80, Col_80) of Temperature_Type;

   procedure Init_Temperature_Map_20
     (Temperature_Map : out Temperature_Map_20);

   procedure Smooth_Temperature (Temperature_Map : out Temperature_Map_20);
   --  Two temperature need smoothing if they are two extreme for one another.
   --
   --  With the current cnfiguration, that means if :
   --  Warm (int 1) is close to Cold (3) or Freezing (4) Or
   --  Freezing (int 4) is close to Temperate (2) or Warm (1).
   --
   --  Thus it is possible to check if the difference is greater than 2.
   --  And it is possible to check for a neighbourhood by checking if the
   --  difference is greater than 4 in non Border case, 2 otherwise.

   procedure Quadruple_Map
     (From : Temperature_Map_20; To : out Temperature_Map_80);

   procedure Print_Map_20 (T_M : Temperature_Map_20);

private

   function f (x : Lign_Type) return Lign_Type;
   --  f(0) = 1, f(Width) = Width - 1, f(Height) = Height - 1
   --  Allow to handle general border case substraction (Cf Smooth_Temperature)

   function Border_Case_Need_Smoothing
     (T_M : Temperature_Map_20; I, J : Lign_Type; Ci, Cj : Lign_Type)
      return Boolean;

   function Need_Smoothing
     (T_M : Temperature_Map_20; I, J : Lign_Type) return Boolean;

end Temperature_Map;
