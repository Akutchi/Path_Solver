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

   -----------------------------
   -- Random_2D_Unit_Gradient --
   -----------------------------

   function Random_2D_Unit_Gradient return Vector is

      Gradient : Vector;
      G        : Generator;

      function Scale (x : Float) return Float;
      --  [0; 1] => [-1; 1] (for full unit circle)

      function Scale (x : Float) return Float is
      begin
         return 2.0 * x - 1.0;
      end Scale;

   begin

      Reset (G);
      Gradient.X := Scale (Float (Random (G)));
      Gradient.Y := Scale (Float (Random (G)));
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

   -----------
   -- Scale --
   -----------

   function Scale (x : Float) return Float is
   begin
      return 1.5 * x + 2.5;
   end Scale;

   ------------------
   -- Perlin_Noise --
   ------------------

   function Perlin_Noise (Over_Grid : Perlin_Map; x, y : Float) return Integer
   is

      x0 : constant Perlin_Row := Perlin_Row (Integer (x));
      y0 : constant Perlin_Col := Perlin_Col (Integer (y));

      x1 : constant Perlin_Row := x0 + 1;
      y1 : constant Perlin_Col := y0 + 1;

      sx : constant Float := x - Float (x0);
      sy : constant Float := y - Float (y0);

      offset1 : constant Vector := Normalize (Create_Offset (x, y, x0, y0));
      offset2 : constant Vector := Normalize (Create_Offset (x, y, x1, y0));
      offset3 : constant Vector := Normalize (Create_Offset (x, y, x0, y1));
      offset4 : constant Vector := Normalize (Create_Offset (x, y, x1, y1));

      a0, a1, a2, a3 : Float;
      mean1, mean2   : Float;

   begin

      a0 := dot (Over_Grid (x0, y0).Gradient, offset1);
      a1 := dot (Over_Grid (x1, y0).Gradient, offset2);

      mean1 := Interpolate (a0, a1, sx);

      a2 := dot (Over_Grid (x0, y1).Gradient, offset3);
      a3 := dot (Over_Grid (x1, y1).Gradient, offset4);

      mean2 := Interpolate (a2, a3, sy);

      return
        Integer (Float'Rounding (Scale ((Interpolate (mean1, mean2, sy)))));

   end Perlin_Noise;

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