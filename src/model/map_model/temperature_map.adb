with Ada.Text_IO; use Ada.Text_IO;

package body Temperature_Map is

   -----------------------------
   -- Init_Temperature_Map_20 --
   -----------------------------

   procedure Init_Temperature_Map_20 (Temperature_Map : out Temperature_Map_20)
   is

      Rnd_Temp : Temperature_Type;
   begin

      Random_Temperature.Reset (G_T);

      for I in Row_20'Range loop
         for J in Col_20'Range loop

            loop
               Rnd_Temp := Random_Temperature.Random (G_T);
               exit when Rnd_Temp /= 2;
            end loop;

            Temperature_Map (I, J) := Rnd_Temp;
         end loop;
      end loop;

   end Init_Temperature_Map_20;

   --------------------------------
   -- Border_Case_Need_Smoothing --
   --------------------------------

   function Border_Case_Need_Smoothing
     (T_M : Temperature_Map_20; I, J : Lign_Type; Ci, Cj : Lign_Type)
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
     (T_M : Temperature_Map_20; I, J : Lign_Type) return Boolean
   is

      Balanced_4 : constant Positive := 4;
      Four_Way   : Natural;

   begin

      if Border_Case_Need_Smoothing (T_M, I, J, 0, 0)
        or else Border_Case_Need_Smoothing
          (T_M, I, J, Row_20'Last, Col_20'Last)
      then
         return True;
      end if;

      --  If does not need smoothing, will still return false and continue
      --  leading to index check failed.
      if (I = 0 or else J = 0)
        or else (I = Row_20'Last or else J = Col_20'Last)
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

   procedure Smooth_Temperature (Temperature_Map : out Temperature_Map_20) is
   begin

      for I in Row_20'Range loop
         for J in Col_20'Range loop

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

   procedure Quadruple_Map
     (From : Temperature_Map_20; To : out Temperature_Map_80)
   is
      I, J : Lign_Type := 0; --  Base coords
      K, L : Lign_Type := 0; --  Zoomed Coords
   begin

      loop

         exit when L > Col_80'Last - 4;

         I := 0;
         K := 0;

         loop

            exit when K > Row_80'Last - 4;

            declare

               Value : constant Temperature_Type := From (I, J);

            begin

               To (K + 1, L)     := Value;
               To (K, L + 1)     := Value;
               To (K + 1, L + 1) := Value;

               To (K + 2, L)     := Value;
               To (K, L + 2)     := Value;
               To (K + 2, L + 1) := Value;
               To (K + 1, L + 2) := Value;
               To (K + 2, L + 2) := Value;

               To (K + 3, L)     := Value;
               To (K, L + 3)     := Value;
               To (K + 2, L + 3) := Value;
               To (K + 3, L + 2) := Value;
               To (K + 3, L + 1) := Value;
               To (K + 1, L + 3) := Value;
               To (K + 3, L + 3) := Value;

               To (K + 4, L) := Value;
               To (K, L + 4) := Value;

               To (K + 4, L + 1) := Value;
               To (K + 1, L + 4) := Value;

               To (K + 3, L + 1) := Value;
               To (K + 1, L + 3) := Value;
               To (K + 3, L + 3) := Value;
               To (K + 3, L + 3) := Value;
               To (K + 3, L + 3) := Value;

            end;

            I := I + 1;
            K := K + 4;

         end loop;

         J := J + 1;
         L := L + 4;

      end loop;
   end Quadruple_Map;

   ------------------
   -- Print_Map_20 --
   ------------------

   procedure Print_Map_20 (T_M : Temperature_Map_20) is
   begin

      for I in Row_20'Range loop
         for J in Col_20'Range loop
            Put (Temperature_Type'Image (T_M (I, J)) & " ");
         end loop;
         Put_Line ("");
      end loop;

   end Print_Map_20;

   ------------------
   -- Print_Map_80 --
   ------------------

   procedure Print_Map_80 (T_M : Temperature_Map_80) is
   begin

      for I in Row_80'Range loop
         for J in Col_80'Range loop
            Put (Temperature_Type'Image (T_M (I, J)) & "");
         end loop;
         Put_Line ("");
      end loop;

   end Print_Map_80;

end Temperature_Map;
