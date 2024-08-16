with Ada.Text_IO; use Ada.Text_IO;

package body Temperature_Map is

   -----------------------------
   -- Inverse_Temperature_CDF --
   -----------------------------

   function Inverse_Temperature_CDF return Temperature_Type is

      Rnd_Type : Ada.Numerics.Float_Random.Uniformly_Distributed;
      Rnd_Cold : Ada.Numerics.Float_Random.Uniformly_Distributed;
   begin

      Ada.Numerics.Float_Random.Reset (Gf);

      Rnd_Type := Ada.Numerics.Float_Random.Random (Gf);
      if Rnd_Type < 0.3 then

         return Warm;

      elsif Rnd_Type >= 0.3 and then Rnd_Type < 0.7 then

         return Temperate;

      else

         Rnd_Cold := Ada.Numerics.Float_Random.Random (Gf);
         if Rnd_Cold > 0.5 then

            return Cold;
         end if;

         return Freezing;

      end if;

   end Inverse_Temperature_CDF;

   -----------------------------
   -- Init_Temperature_Map_Z2 --
   -----------------------------

   procedure Init_Temperature_Map_Z2 (Temperature_Map : out Temperature_Map_Z2)
   is

      Rnd_Temp : Temperature_Type;
   begin

      Random_Temperature.Reset (G_T);

      for I in Row_Z2'Range loop
         for J in Col_Z2'Range loop

            --  loop
            Rnd_Temp := Inverse_Temperature_CDF;
            --     exit when Rnd_Temp /= 2;
            --  end loop;

            Temperature_Map (I, J) := Rnd_Temp;
         end loop;
      end loop;

   end Init_Temperature_Map_Z2;

   --------------------------------
   -- Border_Case_Need_Smoothing --
   --------------------------------

   function Border_Case_Need_Smoothing
     (T_M : Temperature_Map_Z2; I, J : Lign_Type; Ci, Cj : Lign_Type)
      return Boolean
   is
      Two_Way    : Natural;
      Balanced_2 : constant Natural := 2;

      function f (x : Lign_Type) return Lign_Type;
      --  f(0) = 1, f(Width) = Width - 1, f(Height) = Height - 1
      --  Allow to handle general border case substraction
      --  (Cf Smooth_Temperature's doc)

      function f (x : Lign_Type) return Lign_Type is
      begin

         return (if x = 0 then 1 else x - 1);

      end f;

   begin

      if I = Ci and then J = Cj then

         Two_Way :=
           abs
           (2 * Integer (T_M (Ci, Cj)) - Integer (T_M (I, f (Ci))) -
            Integer (T_M (f (Cj), J)));
         return Two_Way > Balanced_2;

      end if;

      if I = Ci and then J in Not_Border_Col then

         Two_Way :=
           abs
           (2 * Integer (T_M (Ci, J)) - Integer (T_M (Ci, J + 1)) -
            Integer (T_M (Ci, J - 1)));
         return Two_Way > Balanced_2;

      end if;

      if I in Not_Border_Row and then J = Cj then

         Two_Way :=
           abs
           (2 * Integer (T_M (I, Cj)) - Integer (T_M (I + 1, Cj)) -
            Integer (T_M (I - 1, Cj)));
         return Two_Way > Balanced_2;

      end if;

      return False;

   end Border_Case_Need_Smoothing;

   --------------------
   -- Need_Smoothing --
   --------------------

   function Need_Smoothing
     (T_M : Temperature_Map_Z2; I, J : Lign_Type) return Boolean
   is

      Balanced_4 : constant Positive := 4;
      Four_Way   : Natural;

   begin

      if Border_Case_Need_Smoothing (T_M, I, J, 0, 0)
        or else Border_Case_Need_Smoothing
          (T_M, I, J, Row_Z2'Last, Col_Z2'Last)
      then
         return True;
      end if;

      --  If the case has a 0 or is at an edge and does not need smoothing, it
      --  will still return false and continue leading to index check failed.
      if (I = 0 or else J = 0)
        or else (I = Row_Z2'Last or else J = Col_Z2'Last)
      then
         return False;
      end if;

      Four_Way :=
        abs
        (4 * Integer (T_M (I, J)) - Integer (T_M (I + 1, J)) -
         Integer (T_M (I - 1, J)) - Integer (T_M (I, J + 1)) -
         Integer (T_M (I, J - 1)));

      return Four_Way > Balanced_4;

   end Need_Smoothing;

   ------------------------
   -- Smooth_Temperature --
   ------------------------

   procedure Smooth_Temperature (Temperature_Map : out Temperature_Map_Z2) is
   begin

      for I in Row_Z2'Range loop
         for J in Col_Z2'Range loop

            if Need_Smoothing (Temperature_Map, I, J) then

               if Temperature_Map (I, J) = Warm then
                  Temperature_Map (I, J) := Temperate;

               elsif Temperature_Map (I, J) = Freezing then
                  Temperature_Map (I, J) := Cold;
               end if;

            end if;

         end loop;
      end loop;

   end Smooth_Temperature;

   -------------------
   -- Scale_Map --
   -------------------

   procedure Scale_Map (From : Temperature_Map_Z2; To : out Temperature_Map_Z5)
   is
      I, J : Lign_Type := 0; --  Base coords
      K, L : Lign_Type := 0; --  Zoomed Coords

      Scaling_Factor : constant Positive :=
        Positive ((Row_Z5'Last + 1) / (Row_Z2'Last + 1));

      Scaling_Factor_LT : constant Lign_Type := Lign_Type (Scaling_Factor);

   begin

      To := (others => (others => 1));
      --  without it, invalid data when printing
      --  must be missing some values without realizing it.

      loop

         exit when L > Col_Z5'Last - (Scaling_Factor_LT - 1);

         I := 0;
         K := 0;

         loop

            exit when K > Row_Z5'Last - (Scaling_Factor_LT - 1);

            declare

               Value : constant Temperature_Type := From (I, J);

            begin

               for M in 0 .. Scaling_Factor_LT - 1 loop
                  for N in 0 .. Scaling_Factor_LT - 1 loop

                     To (K + M, L + N) := Value;
                  end loop;
               end loop;

            end;

            I := I + 1;
            K := K + Scaling_Factor_LT;

         end loop;

         J := J + 1;
         L := L + Scaling_Factor_LT;

      end loop;
   end Scale_Map;

   ------------------
   -- Print_Map_Z2 --
   ------------------

   procedure Print_Map_Z2 (T_M : Temperature_Map_Z2) is
   begin

      for I in Row_Z2'Range loop
         for J in Col_Z2'Range loop
            Put (Temperature_Type'Image (T_M (I, J)) & " ");
         end loop;
         Put_Line ("");
      end loop;

   end Print_Map_Z2;

   ------------------
   -- Print_Map_Z5 --
   ------------------

   procedure Print_Map_Z5 (T_M : Temperature_Map_Z5) is
   begin

      for I in Row_Z5'Range loop
         for J in Col_Z5'Range loop
            Put (Temperature_Type'Image (T_M (I, J)) & "");
         end loop;
         Put_Line ("");
      end loop;

   end Print_Map_Z5;

end Temperature_Map;
