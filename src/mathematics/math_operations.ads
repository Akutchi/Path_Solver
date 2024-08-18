with Image_IO; use Image_IO;

package Math_Operations is

   type Vector is record

      X : Float;
      Y : Float;
      Z : Float;

   end record;

   type Perlin_Info is record

      Gradient : Vector;
      Value    : Float;
   end record;

   type Perlin_Row is range 0 .. 10;
   type Perlin_Col is range 0 .. 10;

   type Perlin_Map is array (Perlin_Row, Perlin_Col) of Perlin_Info;

   function "-" (u : Vector; v : Vector) return Vector;

   function Data_To_Vector (Data : Image_Data; I, J : Integer) return Vector;

   function Gradient_x (Data : Image_Data; I, J : Integer) return Vector;

   function Gradient_y (Data : Image_Data; I, J : Integer) return Vector;

   function norm (Point : Vector) return Float;

   function Normalize (u : Vector) return Vector;

   function Random_2D_Unit_Gradient return Vector;

   function dot (u : Vector; v : Vector) return Float;

   function Smoothstep (w : Float) return Float;

   function Interpolate (a0, a1 : Float; w : Float) return Float;

   procedure Init_Perlin_Map (Over_Grid : out Perlin_Map);

   function Perlin_Noise (Over_Grid : Perlin_Map; x, y : Float) return Integer;
   --  I return an integer because I only want values in [|1; 4|] for the
   --  temperature map. Algorithm description here :
   --
   --  FR : https://fr.wikipedia.org/wiki/Bruit_de_Perlin
   --  EN : https://en.wikipedia.org/wiki/Perlin_noise

   procedure Print_Vector (u : Vector);

private

   function Create_Offset
     (x, y : Float; xi : Perlin_Row; yi : Perlin_Col) return Vector;

   function Scale (x : Float) return Float;
   --  [-1; 1] => [1; 5]

   function Calculate_Value
     (Over_Grid : Perlin_Map; x, y : Float; xi : Perlin_Row; yi : Perlin_Col)
      return Float;

end Math_Operations;
