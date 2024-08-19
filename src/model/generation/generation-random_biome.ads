with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Float_Random;

package Generation.Random_Biome is

   subtype Land_Or_Ocean is Positive range 1 .. 10;
   package Random_Base_Biome is new Ada.Numerics.Discrete_Random
     (Land_Or_Ocean);

   use Random_Base_Biome;

   G  : Generator;
   Gb : Ada.Numerics.Float_Random.Generator;

   function Draw_Random_Base_Biome return Land_Or_Ocean;

end Generation.Random_Biome;
