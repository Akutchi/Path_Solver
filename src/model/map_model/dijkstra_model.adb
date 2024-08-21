with Constants; use Constants;

package body Dijkstra_Model is

   procedure Init_Costs (C_Hash : out Map) is

      function T (x : Float) return Float;
      function S (x : Float) return Float;
      function f (x, y : Float) return Float;

      function T (x : Float) return Float is
      begin
         return x**2 + 1.0;
      end T;

      function S (x : Float) return Float is
      begin
         return x;
      end S;

      function f (x, y : Float) return Float is

         a : constant Float := 1.0;
         b : constant Float := 0.5;
      begin
         return a * T (x) + b * S (y);

      end f;

      Desert_Cost     : constant Float := f (2.0, 2.0);
      Mesa_Cost       : constant Float := f (1.8, 2.0);
      Jungle_Cost     : constant Float := f (1.7, 5.0);
      Rainforest_Cost : constant Float := f (1.6, 1.5);
      Forest_Cost     : constant Float := f (1.0, 1.3);
      Rocks_Cost      : constant Float := f (0.0, 0.0);
      Snowy_Cost      : constant Float := f (-1.3, 1.0);
      SnowyTaiga_Cost : constant Float := f (-1.5, 1.6);
      Ice_Cost        : constant Float := f (-2.0, 1.3);
      SnowIce_Cost    : constant Float := f (-2.0, 1.5);

      df : constant Float := 0.5;

   begin

      C_Hash.Include (Desert, Desert_Cost);
      C_Hash.Include (Mesa, Mesa_Cost);
      C_Hash.Include (Jungle, Jungle_Cost);
      C_Hash.Include (Rainforest, Rainforest_Cost);
      C_Hash.Include (Forest, Forest_Cost);
      C_Hash.Include (Rocks, Rocks_Cost);
      C_Hash.Include (Snowy, Snowy_Cost);
      C_Hash.Include (SnowyTaiga, SnowyTaiga_Cost);
      C_Hash.Include (Ice, Ice_Cost);
      C_Hash.Include (SnowIce, SnowIce_Cost);

      C_Hash.Include (Mesa_Hills, Mesa_Cost + df);
      C_Hash.Include (Rainforest_Hills, Rainforest_Cost + df);
      C_Hash.Include (Jungle_Tree, Jungle_Cost + df);
      C_Hash.Include (Forest_Trees, Forest_Cost + df);
      C_Hash.Include (Rocky_Hills, Rocks_Cost + df);
      C_Hash.Include (Snowy_Hills, Snowy_Cost + df);
      C_Hash.Include (SnowyTaiga_Snow, SnowyTaiga_Cost + df);
      C_Hash.Include (Ice_Hills, Ice_Cost + df);
      C_Hash.Include (SnowyIce_Hills, SnowIce_Cost + df);

   end Init_Costs;

   procedure Init_Dijsktra (C_Map : out Cost_Map) is
   begin

      Init_Costs (C_Map.Costs);

   end Init_Dijsktra;

end Dijkstra_Model;
