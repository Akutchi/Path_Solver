-------------------------------------------------------------------------------
--                                                                           --
--  This file is about the implementation of the dijkstra's algorithm.       --
--                                                                           --
--  For storing each pixel's cost, I created a hash map instead of a matrix. --
--                                                                           --
--  The hash function, however, had to be redefined. Ada provide a Standard  --
--  hashing for Strings in Ada.Strings.Hash. However, I worked with the      --
--  (R, G, B) format, which this hash is not adequate for. Thus, the hasing  --
--  function I used was : (Red) + (Green * 2^8) + (Blue * 2^16).             --
--                                                                           --
--  Moreover, I could not hash raw (R, G, B) values. Indeed, GtkAda use      --
--  floats in the range [0, 1] while Image_IO - which I used for the Image   --
--  manipulation - use integer in the range [0, 255]. Thus, when converting  --
--  from one to the other, there is loss of information which could result   --
--  in a "key not in map error". Consequently, to compensate for this, I     --
--  had to create a Flatten [1] function that would truncate a float x to    --
--  its first decimal.                                                       --
--  Thus, if some color was represented as (0.xy, 0.ab, 0.uv) in the GtkAda  --
--  format and (0.xy', 0.ab', 0.uv') in the Image_IO format [2], then the    --
--  Flatten function would cause both colors to be represented as            --
--  (0.x, x.a, 0.u) which could then be hashed properly from both sides.     --
--                                                                           --
--  [1] See src/rgba.adb                                                     --
--  [1] After converting UInt8 to Float.                                     --
--                                                                           --
-------------------------------------------------------------------------------

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

   package Shortest_Path is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Positive, Element_Type => Point);

   INFINITY : Float   := 1_000.0;
   Image_Z6 : Natural := Z6 - 1;

   type Dist_Array is array (Natural range 0 .. Image_Z6 * Image_Z6) of Float;
   type Prev_Array is
     array (Natural range 0 .. Image_Z6 * Image_Z6) of Integer;
   type Queue is array (Natural range 0 .. Image_Z6 * Image_Z6 + 1) of Integer;

   type Cost_Map is record

      Costs       : Cost_Hash.Map;
      Start_Point : Point;
      End_Point   : Point;
   end record;

   procedure Init_Dijsktra (C_Map : out Cost_Map);

   function Calculate_Shortest_Path
     (Dijkstra_Info : Cost_Map) return Prev_Array;

   function Salmon_Swim
     (Prev : Prev_Array; Dijkstra_Info : Cost_Map) return Shortest_Path.Vector;
   --  Because, yk, salmon swim up rivers currents...

   procedure Draw_On_Map
     (Path : Shortest_Path.Vector; Dijkstra_Info : Cost_Map);

private

   procedure Init_Costs (C_Hash : out Cost_Hash.Map);
   procedure Init_Points (Data : Image_Data; C_Map : out Cost_Map);
   procedure Init_Queue (Data : Image_Data; Q : out Queue);

   function Get_Min (Q : out Queue; Dist : Dist_Array) return Natural;
   function Get_Neighbours (Q : Queue; u : Natural) return Neighbours.Vector;

end Dijkstra_Model;
