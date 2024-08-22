with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Indefinite_Vectors;

with Gdk.RGBA; use Gdk.RGBA;

with Image_IO; use Image_IO;

with Math_Hash;       use Math_Hash;
with Random_Position; use Random_Position;
with Constants;       use Constants;

package Dijkstra_Model is

   package Cost_Hash is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => Gdk_RGBA, Element_Type => Float, Hash => hash,
      Equivalent_Keys => Gdk.RGBA.Equal);

   package Neighbours is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Positive, Element_Type => Integer);

   use Cost_Hash;
   use Neighbours;

   INFINITY : Float   := 1_000.0;
   Image_Z6 : Natural := Z6 - 1;

   type Dist_Array is array (Natural range 0 .. Image_Z6 * Image_Z6) of Float;
   type Prev_Array is
     array (Natural range 0 .. Image_Z6 * Image_Z6) of Integer;
   type Queue is array (Natural range 0 .. Image_Z6 * Image_Z6 + 1) of Integer;

   type Cost_Map is record

      Costs       : Map;
      Start_Point : Point;
      End_Point   : Point;
   end record;

   procedure Init_Dijsktra (C_Map : out Cost_Map);
   function Calculate_Shortest_Path (D_Map : Cost_Map) return Prev_Array;

private

   procedure Init_Costs (C_Hash : out Map);
   procedure Init_Points (Data : Image_Data; C_Map : out Cost_Map);
   procedure Init_Queue (Data : Image_Data; Q : out Queue);

   function Get_Min (Q : out Queue; Dist : Dist_Array) return Natural;
   function Get_Neighbours (Q : Queue; u : Natural) return Vector;

end Dijkstra_Model;
