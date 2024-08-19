with Ada.Text_IO; use Ada.Text_IO;

with Image_IO;            use Image_IO;
with Image_IO.Holders;    use Image_IO.Holders;
with Image_IO.Operations; use Image_IO.Operations;

with RGBA;            use RGBA;
with Math_Operations; use Math_Operations;
with Random_Position; use Random_Position;
with Constants;       use Constants;

package body Temperature_Map is

   -----------------------------
   -- Init_Temperature_Map_Z5 --
   -----------------------------

   procedure Init_Temperature_Map_Z5 (Temperature_Map : out Temperature_Map_Z5)
   is

      Over_Grid : Perlin_Map;

      dx, dy : constant Float := 0.01;

      x, y : Float := 0.0;

      I : Row_Z5 := 0;
      J : Col_Z5 := 0;

   begin

      Init_Perlin_Map (Over_Grid);
      Temperature_Map := (others => (others => 1));

      loop

         exit when J >= Col_Z5'Last - 1;

         x := 0.0;
         I := 0;

         loop
            exit when I >= Row_Z5'Last - 1;

            Temperature_Map (I, J) :=
              Temperature_Type (Perlin_Noise (Over_Grid, x, y));

            x := x + dx;
            I := I + 1;

         end loop;

         y := y + dy;
         J := J + 1;

      end loop;

   end Init_Temperature_Map_Z5;

   -----------------------------
   -- Calculate_Local_Inverse --
   -----------------------------

   function Calculate_Local_Inverse
     (Temperature_Map : Temperature_Map_Z5; I : Row_Z5; J : Col_Z5)
      return Interpolation_Map
   is

      Local_Inverse : Interpolation_Map;
   begin

      for K in Interpolation_Row'Range loop
         for L in Interpolation_Col'Range loop
            Local_Inverse (K, L) :=
              Scale_To_Interploate
                (Float
                   (Temperature_Map (I + Row_Z5 (K) - 1, J + Col_Z5 (L) - 1)));
         end loop;
      end loop;

      return Local_Inverse;

   end Calculate_Local_Inverse;

   ----------------------
   -- Replace_By_White --
   ----------------------

   procedure Apply_Correction
     (Temp_Map : out Temperature_Map_Z5; I : Row_Z5; J : Col_Z5; G : Vector)
   is
   begin
      if G.X > 0.0 and then G.Y < 0.0 then

         Temp_Map (I + 1, J - 2) := Temperate;
         Temp_Map (I + 1, J - 1) := Temperate;
         Temp_Map (I + 2, J - 1) := Temperate;

         Temp_Map (I - 1, J + 2) := Temperate;
         Temp_Map (I - 1, J + 1) := Temperate;
         Temp_Map (I - 2, J + 1) := Temperate;

      elsif G.X < 0.0 and then G.Y > 0.0 then

         Temp_Map (I - 1, J - 2) := Temperate;
         Temp_Map (I - 1, J - 1) := Temperate;
         Temp_Map (I - 2, J - 1) := Temperate;

         Temp_Map (I + 2, J + 1) := Temperate;
         Temp_Map (I + 1, J + 1) := Temperate;
         Temp_Map (I + 1, J + 2) := Temperate;

      elsif G.X = 0.0 and then G.Y /= 0.0 then

         Temp_Map (I - 1, J - 1) := Temperate;
         Temp_Map (I + 1, J - 1) := Temperate;
         Temp_Map (I - 1, J + 1) := Temperate;
         Temp_Map (I + 1, J + 1) := Temperate;

         Temp_Map (I, J - 1) := Temperate;
         Temp_Map (I, J + 1) := Temperate;

      elsif G.X /= 0.0 and then G.Y = 0.0 then

         Temp_Map (I - 1, J - 1) := Temperate;
         Temp_Map (I + 1, J - 1) := Temperate;
         Temp_Map (I - 1, J + 1) := Temperate;
         Temp_Map (I + 1, J + 1) := Temperate;

         Temp_Map (I, J - 1) := Temperate;
         Temp_Map (I, J + 1) := Temperate;

      end if;
   end Apply_Correction;

   ------------------------
   -- Smooth_Temperature --
   ------------------------

   procedure Smooth_Temperature (Temperature_Map : out Temperature_Map_Z5) is

      Smooth_Temperature : Temperature_Type;

   begin

      for I in 1 .. Perlin_Row'Last - 1 loop
         for J in 1 .. Perlin_Col'Last - 1 loop

            declare

               I_R : constant Row_Z5 := Row_Z5 (Positive (I) * Perlin_Shift);
               J_R : constant Col_Z5 := Col_Z5 (Positive (J) * Perlin_Shift);

               Pixel : constant Temperature_Type := Temperature_Map (I_R, J_R);

               Local_Inverse_Map : Interpolation_Map;
               G                 : Vector;
               Gp                : Vector;

            begin

               if Pixel = Temperate then --  Is white in the model

                  Local_Inverse_Map :=
                    Calculate_Local_Inverse (Temperature_Map, I_R, J_R);
                  G                 :=
                    Normalize
                      ((Kx (Local_Inverse_Map), Ky (Local_Inverse_Map), 0.0));

                  if not (G = 0.0) then

                     Gp := (-G.Y, G.X, G.Z);
                     Apply_Correction (Temperature_Map, I_R, J_R, Gp);

                  end if;
               end if;
            end;
         end loop;
      end loop;

   end Smooth_Temperature;

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

   ----------------------------
   -- Show_Temperature_Model --
   ----------------------------

   procedure Show_Temperature_Model
     (Temp_Map : Temperature_Map_Z5; Current_Zoom : Positive)
   is

      Image : Handle;
   begin

      Create_Image (Image_Destination & Model_Name, Current_Zoom);
      Read (Image_Destination & Model_Name, Image);

      declare

         Data_Model : Image_Data := Image.Value;

      begin

         for i_index in 0 .. Row_Z5'Last loop
            for j_index in 0 .. Col_Z5'Last loop

               declare
                  T : constant Temperature_Type := Temp_Map (i_index, j_index);
                  I : constant Pos              := Pos (i_index);
                  J : constant Pos              := Pos (j_index);

               begin

                  case T is
                     when Warm =>
                        Put_Pixel (Data_Model, I, J, Dark_Red);
                     when Equatorial =>
                        Put_Pixel (Data_Model, I, J, Red);
                     when Temperate =>
                        Put_Pixel (Data_Model, I, J, White);
                     when Cold =>
                        Put_Pixel (Data_Model, I, J, Blue);
                     when Freezing =>
                        Put_Pixel (Data_Model, I, J, Dark_Blue);
                  end case;

               end;
            end loop;
         end loop;

         Write_PNG (Image_Destination & Model_Name, Data_Model);
      end;

   end Show_Temperature_Model;

end Temperature_Map;
