package body Random_Biome is

   function Draw_Random_Base_Biome return Land_Or_Ocean is
   begin

      Reset (G);
      return Random (G);
   end Draw_Random_Base_Biome;

end Random_Biome;
