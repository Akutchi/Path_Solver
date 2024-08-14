package body Generation.Random_Biome is

   function Draw_Random_Base_Biome return Land_Or_Ocean is
   begin

      Reset (G);
      return Random (G);
   end Draw_Random_Base_Biome;

end Generation.Random_Biome;
