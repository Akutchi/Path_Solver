with Image_IO; use Image_IO;

with Generation.Random_Position; use Generation.Random_Position;

package Generation.Math is

   type Vector is record

      X : Integer;
      Y : Integer;
      Z : Integer;

   end record;

   function "-" (u : Vector; v : Vector) return Vector;

   function Data_To_Vector (Data : Image_Data; I, J : Pos) return Vector;

   function Gradient_x (Data : Image_Data; I, J : Pos) return Vector;

   function Gradient_y (Data : Image_Data; I, J : Pos) return Vector;

   function norm (Point : Vector) return Float;

end Generation.Math;
