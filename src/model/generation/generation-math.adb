with Ada.Numerics.Generic_Elementary_Functions;

with Ada.Text_IO; use Ada.Text_IO;

package body Generation.Math is

   package Float_Calculations is new Ada.Numerics.Generic_Elementary_Functions
     (Float_Type => Float);

   use Float_Calculations;

   --------------------
   -- Data_To_Vector --
   --------------------

   function Data_To_Vector (Data : Image_Data; I, J : Pos) return Vector is

      Color : constant Color_Info := Data (Natural (I), Natural (J));
   begin

      return
        (Integer (Color.Red), Integer (Color.Green), Integer (Color.Blue));

   end Data_To_Vector;

   -----------
   -- " - " --
   -----------

   function "-" (u : Vector; v : Vector) return Vector is
   begin
      return (u.X - v.X, u.Y - v.Y, u.Z - v.Z);
   end "-";

   ----------------
   -- Gradient_x --
   ----------------

   function Gradient_x (Data : Image_Data; I, J : Pos) return Vector is

      u : constant Vector := Data_To_Vector (Data, I - 1, J);
      v : constant Vector := Data_To_Vector (Data, I + 1, J);
   begin

      return v - u;

   end Gradient_x;

   ----------------
   -- Gradient_y --
   ----------------

   function Gradient_y (Data : Image_Data; I, J : Pos) return Vector is

      u : constant Vector := Data_To_Vector (Data, I, J - 1);
      v : constant Vector := Data_To_Vector (Data, I, J + 1);
   begin

      return v - u;

   end Gradient_y;

   ----------
   -- norm --
   ----------

   function norm (Point : Vector) return Float is
   begin

      return
        Sqrt (Float (Point.X)**2 + Float (Point.Y)**2 + Float (Point.Z)**2);
   end norm;

end Generation.Math;
