with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

with Ada.Text_IO; use Ada.Text_IO;

package body Math_Operations is

   package Float_Calculations is new Ada.Numerics.Generic_Elementary_Functions
     (Float_Type => Float);

   use Float_Calculations;

   --------------------
   -- Data_To_Vector --
   --------------------

   function Data_To_Vector (Data : Image_Data; I, J : Integer) return Vector is

      Color : constant Color_Info := Data (Natural (I), Natural (J));
   begin

      return (Float (Color.Red), Float (Color.Green), Float (Color.Blue));

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

   function Gradient_x (Data : Image_Data; I, J : Integer) return Vector is

      u : constant Vector := Data_To_Vector (Data, I - 1, J);
      v : constant Vector := Data_To_Vector (Data, I + 1, J);
   begin

      return v - u;

   end Gradient_x;

   ----------------
   -- Gradient_y --
   ----------------

   function Gradient_y (Data : Image_Data; I, J : Integer) return Vector is

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

      return Sqrt (Point.X**2 + Point.Y**2 + Point.Z**2);
   end norm;

   ---------------
   -- Normalize --
   ---------------

   function Normalize (u : Vector) return Vector is

      u_n : Float;
      v   : Vector := (0.0, 0.0, 0.0);

   begin

      u_n := norm (u);

      if u_n >= 0.01 then

         v.X := u.X / u_n;
         v.Y := u.Y / u_n;
         v.Z := u.Z / u_n;

         return v;

      else
         return (0.0, 0.0, 0.0);
      end if;

   end Normalize;

   --------------------------
   -- Random_Unit_Gradient --
   --------------------------

   function Random_Unit_Gradient return Vector is

      Gradient : Vector;
      G        : Generator;

   begin

      Reset (G);
      Gradient.X := Float (Random (G));
      Gradient.Y := Float (Random (G));
      Gradient.Z := Float (Random (G));

      return Normalize (Gradient);

   end Random_Unit_Gradient;

   ---------
   -- dot --
   ---------

   function dot (u : Vector; v : Vector) return Float is
   begin

      return u.X * v.X + u.Y * v.Y + u.Z * v.Z;

   end dot;

   ----------------
   -- Smoothstep --
   ----------------

   function Smoothstep (w : Float) return Float is
   begin

      if w >= 1.0 then
         return 1.0;

      elsif w <= 0.0 then
         return 0.0;

      else
         return (w**2) * (3.0 - 2.0 * w);
      end if;

   end Smoothstep;

   -----------------
   -- Interpolate --
   -----------------

   function Interpolate (a0, a1 : Float; w : Float) return Float is
   begin

      return (a1 - a0) * Smoothstep (w) + a0;

   end Interpolate;

   procedure Print_Vector (u : Vector) is
   begin

      Put_Line
        ("(" & Float'Image (u.X) & ", " & Float'Image (u.Y) & ", " &
         Float'Image (u.Z) & ")");

   end Print_Vector;

end Math_Operations;
