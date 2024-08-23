------------------------------------------------------------------------------
--                                                                          --
--  This package is about math operations on vectors that are used for the  --
--  creation of the temperature map using perlin noise.                     --
--                                                                          --
--  Perlin noise algorithm can be found here [1], but in short,             --
--  in our case :                                                           --
--                                                                          --
--  Step 1 : Cut your image into a grid of KxK boxes (I will call it the    --
--  sub grid) and create a grid of (K+1)x(K+1) boxes to represent each of   --
--  said grid intersections (let's call it the over grid). Then, initialize --
--  a random gradient vector in each over grid's box.                       --
--                                                                          --
--  Step 2 : Calculate four offset vectors for each pixel in a sub grid box --
--  and dot product it with the four gradients that makes up each sub grid  --
--  box corners.                                                            --
--                                                                          --
--  Step 3 : With those four new values, you can now interpolate both       --
--  horizontally and vertically to get your pixel value.                    --
--
--  [1] Algorithm description here :                                        --
--                                                                          --
--  FR : https://fr.wikipedia.org/wiki/Bruit_de_Perlin                      --
--  EN : https://en.wikipedia.org/wiki/Perlin_noise                         --
--                                                                          --
------------------------------------------------------------------------------

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

   type Perlin_Row is range 0 .. 5;
   type Perlin_Col is range 0 .. 5;

   Perlin_Shift : Positive := 16;

   type Perlin_Map is array (Perlin_Row, Perlin_Col) of Perlin_Info;

   function "-" (u : Vector; v : Vector) return Vector;

   subtype Precision is Float range 0.0 .. 1.0;

   epsilon : constant Precision := 0.1;

   function "=" (u : Vector; x : Float) return Boolean;
   --  Holds only with respect to the null vector
   --  (here represented by its norm)

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
   --  I return an integer because I only want values in [|1; 5|] for the
   --  temperature map.

   subtype Interpolate_Value is Float range -1.0 .. 1.0;

   type Interpolation_Row is range 0 .. 4;
   type Interpolation_Col is range 0 .. 4;

   type Interpolation_Map is
     array (Interpolation_Row, Interpolation_Col) of Interpolate_Value;

   Mask_Gx : Interpolation_Map :=
     ((1.0, 0.0, 0.0, 0.0, -1.0), (1.0, 0.0, 0.0, 0.0, -1.0),
      (1.0, 0.0, 0.0, 0.0, -1.0), (1.0, 0.0, 0.0, 0.0, -1.0),
      (1.0, 0.0, 0.0, 0.0, -1.0));

   Mask_Gy : Interpolation_Map :=
     ((1.0, 1.0, 1.0, 1.0, 1.0), (0.0, 0.0, 0.0, 0.0, 0.0),
      (0.0, 0.0, 0.0, 0.0, 0.0), (0.0, 0.0, 0.0, 0.0, 0.0),
      (-1.0, -1.0, -1.0, -1.0, -1.0));

   function "*" (A, B : Interpolation_Map) return Float;

   function Scale_To_Interploate (y : Float) return Float;
   --  [|1; 5|] => [-1; 1]

   function Kx (Local_Inverse : Interpolation_Map) return Float;

   function Ky (Local_Inverse : Interpolation_Map) return Float;

   procedure Print_Vector (u : Vector);

private

   function Create_Offset
     (x, y : Float; xi : Perlin_Row; yi : Perlin_Col) return Vector;

   function Scale_To_Temperature (x : Float) return Float;
   --  [-1; 1] => [|1; 5|]

   function Calculate_Value
     (Over_Grid : Perlin_Map; x, y : Float; xi : Perlin_Row; yi : Perlin_Col)
      return Float;

end Math_Operations;
