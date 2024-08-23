with Ada.Text_IO; use Ada.Text_IO;

with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Numerics.Float_Random;

package body Math_Operations is

   package Float_Calculations is new Ada.Numerics.Generic_Elementary_Functions
     (Float_Type => Float);

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

   -----------
   -- " = " --
   -----------

   function "=" (u : Vector; x : Float) return Boolean is

      u_n : constant Float := norm (u);
   begin
      return u_n > x - epsilon and then u_n < x + epsilon;
   end "=";

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

      return Float_Calculations.Sqrt (Point.X**2 + Point.Y**2 + Point.Z**2);
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

   -----------------------------
   -- Random_2D_Unit_Gradient --
   -----------------------------

   function Random_2D_Unit_Gradient return Vector is

      Gradient : Vector;
      G        : Ada.Numerics.Float_Random.Generator;

      function Scale (x : Float) return Float;
      --  [0; 1] => [-1; 1] (for full unit circle)

      function Scale (x : Float) return Float is
      begin
         return 2.0 * x - 1.0;
      end Scale;

   begin

      Ada.Numerics.Float_Random.Reset (G);
      Gradient.X := Scale (Float (Ada.Numerics.Float_Random.Random (G)));
      Gradient.Y := Scale (Float (Ada.Numerics.Float_Random.Random (G)));
      Gradient.Z := 0.0;

      return Normalize (Gradient);

   end Random_2D_Unit_Gradient;

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

   ---------------------
   -- Init_Perlin_Map --
   ---------------------

   procedure Init_Perlin_Map (Over_Grid : out Perlin_Map) is
   begin

      for I in Perlin_Row'Range loop
         for J in Perlin_Col'Range loop

            declare

               Element : Perlin_Info;
            begin

               Element.Gradient   := Random_2D_Unit_Gradient;
               Element.Value      := 0.0;
               Element.Gradient.Z := 0.0;

               Over_Grid (I, J) := Element;
            end;
         end loop;
      end loop;

   end Init_Perlin_Map;

   -------------------
   -- Create_Offset --
   -------------------

   function Create_Offset
     (x, y : Float; xi : Perlin_Row; yi : Perlin_Col) return Vector
   is
      o : Vector;
   begin
      o.X := x - Float (xi);
      o.Y := y - Float (yi);
      o.Z := 0.0;

      return o;
   end Create_Offset;

   --------------------------
   -- Scale_To_Temperature --
   --------------------------

   function Scale_To_Temperature (x : Float) return Float is
   begin
      return 2.0 * x + 3.0;
   end Scale_To_Temperature;

   ---------------------
   -- Calculate_Value --
   ---------------------

   function Calculate_Value
     (Over_Grid : Perlin_Map; x, y : Float; xi : Perlin_Row; yi : Perlin_Col)
      return Float
   is
      offset : constant Vector := Normalize (Create_Offset (x, y, xi, yi));

   begin
      return dot (offset, Over_Grid (xi, yi).Gradient);
   end Calculate_Value;

   ------------------
   -- Perlin_Noise --
   ------------------

   function Perlin_Noise (Over_Grid : Perlin_Map; x, y : Float) return Integer
   is

      x0 : constant Perlin_Row := Perlin_Row (Integer (Float'Floor (x)));
      y0 : constant Perlin_Col := Perlin_Col (Integer (Float'Floor (y)));

      x1 : constant Perlin_Row := x0 + 1;
      y1 : constant Perlin_Col := y0 + 1;

      sx : constant Float := x - Float (x0);
      sy : constant Float := y - Float (y0);

      a0, a1, a2, a3 : Float;
      mean1, mean2   : Float;

   begin

      a0 := Calculate_Value (Over_Grid, x, y, x0, y0);
      a1 := Calculate_Value (Over_Grid, x, y, x1, y0);

      mean1 := Interpolate (a0, a1, sx);

      a2 := Calculate_Value (Over_Grid, x, y, x0, y1);
      a3 := Calculate_Value (Over_Grid, x, y, x1, y1);

      mean2 := Interpolate (a2, a3, sx);

      return
        Integer
          (Float'Rounding
             (Scale_To_Temperature ((Interpolate (mean1, mean2, sy)))));

   end Perlin_Noise;

   function "*" (A, B : Interpolation_Map) return Float is

      value : Float := 0.0;
   begin

      for I in Interpolation_Row'Range loop
         for J in Interpolation_Col'Range loop
            value := value + (A (I, J) * B (I, J));
         end loop;
      end loop;

      return value;

   end "*";

   --------------------------
   -- Scale_To_Interploate --
   --------------------------

   function Scale_To_Interploate (y : Float) return Float is
   begin
      return (y - 3.0) / 2.0;
   end Scale_To_Interploate;

   --------
   -- Kx --
   --------

   function Kx (Local_Inverse : Interpolation_Map) return Float is
   begin

      return Local_Inverse * Mask_Gx;

   end Kx;

   --------
   -- Ky --
   --------

   function Ky (Local_Inverse : Interpolation_Map) return Float is
   begin

      return Local_Inverse * Mask_Gy;

   end Ky;

   ------------------
   -- Print_Vector --
   ------------------

   procedure Print_Vector (u : Vector) is
   begin

      Put_Line
        ("(" & Float'Image (u.X) & ", " & Float'Image (u.Y) & ", " &
         Float'Image (u.Z) & ")");

   end Print_Vector;

end Math_Operations;
