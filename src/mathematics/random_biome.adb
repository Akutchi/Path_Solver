package body Random_Biome is

   function Draw_Random_Base_Biome return Land_Or_Ocean is
   begin

      Random_Base_Biome.Reset (G);
      return Random_Base_Biome.Random (G);

   end Draw_Random_Base_Biome;

   function Choose_Zone_Biome
      return Ada.Numerics.Float_Random.Uniformly_Distributed
   is
   begin

      Ada.Numerics.Float_Random.Reset (Gb);
      return Ada.Numerics.Float_Random.Random (Gb);

   end Choose_Zone_Biome;

end Random_Biome;
