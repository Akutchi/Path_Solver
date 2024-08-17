with Image_IO; use Image_IO;

package Math_Operations is

   type Vector is record

      X : Float;
      Y : Float;
      Z : Float;

   end record;

   function "-" (u : Vector; v : Vector) return Vector;

   function Data_To_Vector (Data : Image_Data; I, J : Integer) return Vector;

   function Gradient_x (Data : Image_Data; I, J : Integer) return Vector;

   function Gradient_y (Data : Image_Data; I, J : Integer) return Vector;

   function norm (Point : Vector) return Float;

   function Normalize (u : Vector) return Vector;

   function Random_Unit_Gradient return Vector;

   function dot (u : Vector; v : Vector) return Float;

   function Smoothstep (w : Float) return Float;

   function Interpolate (a0, a1 : Float; w : Float) return Float;

   procedure Print_Vector (u : Vector);

end Math_Operations;
