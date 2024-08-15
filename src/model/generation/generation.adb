with Ada.Numerics.Generic_Elementary_Functions;

with Gdk.RGBA; use Gdk.RGBA;

with Image_IO;            use Image_IO;
with Image_IO.Holders;    use Image_IO.Holders;
with Image_IO.Operations; use Image_IO.Operations;

with RGBA;                       use RGBA;
with Generation.Random_Biome;    use Generation.Random_Biome;
with Generation.Random_Position; use Generation.Random_Position;

package body Generation is

   package Float_Calculations is new Ada.Numerics.Generic_Elementary_Functions
     (Float_Type => Float);

   use Float_Calculations;

   ------------
   -- Island --
   ------------

   procedure Island (Source : String) is

      Case_Until_End : constant Natural := Zoom_Levels (0) * Zoom_Levels (0);

      Choice : Land_Or_Ocean;

      Image : Handle;
      Color : Gdk_RGBA;

   begin

      Create_Image (Source, Zoom_Levels (0));
      Read (Image_Destination & Source, Image);

      declare

         Data : Image_Data := Image.Value;

      begin

         for k in 0 .. Case_Until_End - 1 loop

            declare

               I : constant Pos := Pos (k / Zoom_Levels (0));
               J : constant Pos := Pos (k mod Zoom_Levels (0));

            begin

               Choice := Draw_Random_Base_Biome;

               if Choice > 3 then
                  Color := Ocean;
               else
                  Color := Rocks;
               end if;
               Put_Pixel (Data, I, J, Color);

            end;
         end loop;

         Write_PNG (Image_Destination & Source, Data);
      end;

   end Island;

   ----------
   -- Zoom --
   ----------

   procedure Zoom (Source : String; Multiply : Positive; Destination : String)
   is

      I, J : Pos := 0; --  Base coords
      K, L : Pos := 0; --  Zoomed Coords

      Image_Src  : Handle;
      Image_Dest : Handle;

   begin

      Create_Image (Destination, Multiply * 2);

      Read (Image_Destination & Source, Image_Src);
      Read (Image_Destination & Destination, Image_Dest);

      declare

         Data_Src  : constant Image_Data := Image_Src.Value;
         Data_Dest : Image_Data          := Image_Dest.Value;

      begin

         loop

            exit when Natural (L) > Multiply * 2 - 1;

            I := 0;
            K := 0;

            loop

               exit when Natural (K) > Multiply * 2 - 1;

               declare
                  Color : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA (Get_Pixel_Color (Data_Src, I, J));

               begin

                  Put_Pixel (Data_Dest, K, L, Color);
                  Put_Pixel (Data_Dest, K + 1, L, Color);
                  Put_Pixel (Data_Dest, K, L + 1, Color);
                  Put_Pixel (Data_Dest, K + 1, L + 1, Color);

               end;

               I := I + 1;
               K := K + 2;

            end loop;

            J := J + 1;
            L := L + 2;

         end loop;

         Write_PNG (Image_Destination & Destination, Data_Dest);
      end;

   end Zoom;

   -----------------
   -- Add_Islands --
   -----------------

   procedure Add_Islands
     (Source : String; Current_Zoom : Positive; Multiplier : Integer := 1)
   is

      N                : constant Float    := Float (Current_Zoom);
      Stochastic_Tries : constant Positive :=
        Positive (N * Log (N, Ada.Numerics.e)) * Multiplier;

      Image : Handle;

   begin

      Read (Image_Destination & Source, Image);

      declare

         Data : Image_Data := Image.Value;

      begin

         for I in 1 .. Stochastic_Tries loop

            declare

               Coords : constant Point := Draw_Random_Position (Current_Zoom);
               Lossy_Color : constant Gdk_RGBA :=
                 Color_Info_To_GdkRGBA
                   (Get_Pixel_Color (Data, Coords.X, Coords.Y));

            begin

               if RGBA."=" (Lossy_Color, Ocean) then

                  Put_Pixel (Data, Coords.X, Coords.Y, Rocks);

               end if;

            end;

         end loop;

         Write_PNG (Image_Destination & Source, Data);
      end;

   end Add_Islands;

   -----------------
   -- Place_Hills --
   -----------------

   procedure Place_Hills
     (Source : String; Current_Zoom : Positive; Multiplier : Integer)
   is

      N                : constant Float    := Float (Current_Zoom);
      Stochastic_Tries : constant Positive :=
        Positive (N * Log (N, Ada.Numerics.e)) * Multiplier;

      Image : Handle;

   begin

      Read (Image_Destination & Source, Image);

      declare
         Data : Image_Data := Image.Value;
      begin

         for I in 0 .. Stochastic_Tries loop

            declare

               Coords : constant Point := Draw_Random_Position (Current_Zoom);
               Lossy_Color : constant Gdk_RGBA :=
                 Color_Info_To_GdkRGBA
                   (Get_Pixel_Color (Data, Coords.X, Coords.Y));

            begin

               if RGBA."=" (Lossy_Color, Ocean) then

                  Put_Pixel (Data, Coords.X, Coords.Y, Deep_Ocean);

               else
                  Put_Pixel (Data, Coords.X, Coords.Y, Rocky_Hills);

               end if;

            end;
         end loop;

         Write_PNG (Image_Destination & Source, Data);
      end;

   end Place_Hills;

   procedure Place_Biomes (Source : String; Temp_Map : Temperature_Map_Z5) is

      Image : Handle;

   begin

      Read (Image_Destination & Source, Image);

      declare

         Data : Image_Data := Image.Value;
      begin

         for i_index in Row_Z5'Range loop
            for j_index in Col_Z5'Range loop

               declare

                  I : constant Pos := Pos (i_index);
                  J : constant Pos := Pos (j_index);

                  Color_Gdk : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA (Get_Pixel_Color (Data, I, J));

                  T : constant Temperature_Type := Temp_Map (i_index, j_index);

               begin

                  null;

                  if RGBA."=" (Color_Gdk, Rocks) then

                     case T is

                        when Warm =>
                           Put_Pixel (Data, I, J, Desert);
                        when Temperate =>
                           Put_Pixel (Data, I, J, Plain);
                        when Cold =>
                           Put_Pixel (Data, I, J, Snowy);
                        when Freezing =>
                           Put_Pixel (Data, I, J, Ice);
                     end case;

                  elsif RGBA."=" (Color_Gdk, Rocky_Hills) then

                     case T is

                        when Warm =>
                           Put_Pixel (Data, I, J, Desert_Hills);
                        when Temperate =>
                           Put_Pixel (Data, I, J, Plain_Hills);
                        when Cold =>
                           Put_Pixel (Data, I, J, Snowy_Hills);
                        when Freezing =>
                           Put_Pixel (Data, I, J, Ice_Hills);
                     end case;

                  end if;

               end;
            end loop;
         end loop;

         Write_PNG (Image_Destination & Source, Data);

      end;

   end Place_Biomes;

end Generation;
