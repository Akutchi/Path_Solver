with Ada.Containers.Indefinite_Hashed_Maps;

with Gdk.RGBA; use Gdk.RGBA;

with Math_Hash;       use Math_Hash;
with Random_Position; use Random_Position;

package Dijkstra_Model is

   package Cost_Hash is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => Gdk_RGBA, Element_Type => Float, Hash => hash,
      Equivalent_Keys => Gdk.RGBA.Equal);

   use Cost_Hash;

   type Cost_Row is range 0 .. 159;
   type Cost_Col is range 0 .. 159;

   type Cost_Map is record

      Costs       : Map;
      Start_Point : Point;
      End_Point   : Point;
   end record;

   procedure Init_Costs (C_Hash : out Map);
   procedure Init_Dijsktra (C_Map : out Cost_Map);

end Dijkstra_Model;
