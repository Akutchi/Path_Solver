with Ada.Numerics.Float_Random;

with Image_IO.Holders;    use Image_IO.Holders;
with Image_IO.Operations; use Image_IO.Operations;

with RGBA;                       use RGBA;
with Generation.Random_Biome;    use Generation.Random_Biome;
with Generation.Random_Position; use Generation.Random_Position;
with Generation.Math;            use Generation.Math;

package body Generation is

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

   procedure Add_Islands (Source : String; Current_Zoom : Positive) is

      N     : constant Positive := Current_Zoom;
      Image : Handle;

      function Choose_Land_Or_Ocean return Gdk_RGBA is

         x : Ada.Numerics.Float_Random.Uniformly_Distributed;

      begin

         Ada.Numerics.Float_Random.Reset (Gf);
         x := Ada.Numerics.Float_Random.Random (Gf);

         return (if x > 0.4 then Ocean else Rocks);

      end Choose_Land_Or_Ocean;

   begin

      Read (Image_Destination & Source, Image);

      declare

         Data : Image_Data := Image.Value;

      begin

         for i_index in 1 .. N - 2 loop
            for j_index in 1 .. N - 2 loop

               declare

                  I : constant Pos := Pos (i_index);
                  J : constant Pos := Pos (j_index);

               begin

                  if norm (Gradient_x (Data, I, J)) > 0.0
                    or else norm (Gradient_y (Data, I, J)) > 0.0
                  then

                     Put_Pixel (Data, I - 1, J - 1, Choose_Land_Or_Ocean);
                     Put_Pixel (Data, I, J - 1, Choose_Land_Or_Ocean);
                     Put_Pixel (Data, I + 1, J, Choose_Land_Or_Ocean);

                     Put_Pixel (Data, I - 1, J, Choose_Land_Or_Ocean);
                     Put_Pixel (Data, I, J, Choose_Land_Or_Ocean);
                     Put_Pixel (Data, I + 1, J, Choose_Land_Or_Ocean);

                     Put_Pixel (Data, I - 1, J + 1, Choose_Land_Or_Ocean);
                     Put_Pixel (Data, I, J + 1, Choose_Land_Or_Ocean);
                     Put_Pixel (Data, I + 1, J + 1, Choose_Land_Or_Ocean);

                  end if;
               end;
            end loop;
         end loop;

         Write_PNG (Image_Destination & Source, Data);
      end;

   end Add_Islands;

   ------------------------
   -- Surrounded_By_Land --
   ------------------------

   function Surrounded_By
     (Terrain           : Gdk_RGBA; Data : Image_Data; I, J : Lign_Type;
      Dilatation_Number : Positive := 5) return Boolean
   is

      function Is_Terrain
        (Terrain : Gdk_RGBA; Data : Image_Data; I, J : Lign_Type)
         return Integer;

      function Is_Terrain
        (Terrain : Gdk_RGBA; Data : Image_Data; I, J : Lign_Type)
         return Integer
      is

         Pixel : constant Gdk_RGBA :=
           Color_Info_To_GdkRGBA (Get_Pixel_Color (Data, Pos (I), Pos (J)));
      begin

         return (if RGBA."=" (Pixel, Terrain) then 1 else 0);

      end Is_Terrain;

   begin

      return
        Is_Terrain (Terrain, Data, I + 1, J) +
        Is_Terrain (Terrain, Data, I + 1, J - 1) +
        Is_Terrain (Terrain, Data, I, J - 1) +
        Is_Terrain (Terrain, Data, I - 1, J - 1) +
        Is_Terrain (Terrain, Data, I - 1, J) +
        Is_Terrain (Terrain, Data, I - 1, J + 1) +
        Is_Terrain (Terrain, Data, I, J + 1) +
        Is_Terrain (Terrain, Data, I + 1, J + 1) >=
        Dilatation_Number;

   end Surrounded_By;

   ---------------------
   -- Remove_Too_Much --
   ---------------------

   procedure Remove_Too_Much
     (Terrain      : Gdk_RGBA; From : Gdk_RGBA; Source : String;
      Current_Zoom : Positive; Dilatation_Number : Positive := 5)
   is

      N     : constant Positive := Current_Zoom;
      Image : Handle;
   begin

      Read (Image_Destination & Source, Image);

      declare
         Data : Image_Data := Image.Value;

      begin

         for I in 1 .. N - 2 loop
            for J in 1 .. N - 2 loop

               declare

                  Color : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA
                      (Get_Pixel_Color (Data, Pos (I), Pos (J)));

               begin

                  if RGBA."=" (Color, Terrain)
                    and then Surrounded_By
                      (From, Data, Lign_Type (I), Lign_Type (J),
                       Dilatation_Number)
                  then

                     Put_Pixel (Data, Pos (I), Pos (J), From);

                  end if;
               end;

            end loop;
         end loop;

         Write_PNG (Image_Destination & Source, Data);

      end;

   end Remove_Too_Much;

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
                  end if;

               end;
            end loop;
         end loop;

         Write_PNG (Image_Destination & Source, Data);
      end;

   end Place_Biomes;

   ----------------------
   -- Place_Topography --
   ----------------------

   procedure Place_Topography (Source : String; Current_Zoom : Positive) is

      N : constant Integer := Current_Zoom;

      Hills_Map : Handle;
      Ocean_Map : Handle;
      Biome_Map : Handle;

   begin

      Read (Image_Destination & "Hills_6.png", Hills_Map);
      Read (Image_Destination & "Ocean_6.png", Ocean_Map);
      Read (Image_Destination & Source, Biome_Map);

      declare
         Data_Hills : constant Image_Data := Hills_Map.Value;
         Data_Ocean : constant Image_Data := Ocean_Map.Value;
         Data_Biome : Image_Data          := Biome_Map.Value;
      begin

         for i_index in 0 .. N - 1 loop
            for j_index in 0 .. N - 1 loop

               declare

                  I : constant Pos := Pos (i_index);
                  J : constant Pos := Pos (j_index);

                  Hill_Map_Pixel : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA (Get_Pixel_Color (Data_Hills, I, J));

                  Ocean_Map_Pixel : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA (Get_Pixel_Color (Data_Ocean, I, J));

                  Biome_Map_Pixel : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA (Get_Pixel_Color (Data_Biome, I, J));

               begin

                  if RGBA."=" (Hill_Map_Pixel, Rocks) then

                     if RGBA."=" (Biome_Map_Pixel, Desert) then
                        Put_Pixel (Data_Biome, I, J, Desert_Hills);

                     elsif RGBA."=" (Biome_Map_Pixel, Plain) then
                        Put_Pixel (Data_Biome, I, J, Plain_Hills);

                     elsif RGBA."=" (Biome_Map_Pixel, Snowy) then
                        Put_Pixel (Data_Biome, I, J, Snowy_Hills);

                     elsif RGBA."=" (Biome_Map_Pixel, Ice) then
                        Put_Pixel (Data_Biome, I, J, Ice_Hills);

                     end if;
                  end if;

                  if RGBA."=" (Ocean_Map_Pixel, Rocks)
                    and then RGBA."=" (Biome_Map_Pixel, Ocean)
                  then

                     Put_Pixel (Data_Biome, I, J, Deep_Ocean);

                  end if;

               end;
            end loop;
         end loop;

         Write_PNG (Image_Destination & Source, Data_Biome);
      end;

   end Place_Topography;

   -----------------------
   -- Generate_Baseline --
   -----------------------

   procedure Generate_Baseline is

      x2  : constant Positive := Zoom_Levels (0);
      x4  : constant Positive := Zoom_Levels (1);
      x8  : constant Positive := Zoom_Levels (2);
      x16 : constant Positive := Zoom_Levels (3);

   begin

      --  e.g 5x5
      Island ("Layer_1.png");

      --  e.g 5x5 -> 10x10
      Zoom
        (Source      => "Layer_1.png", Multiply => x2,
         Destination => "Layer_2.png");

      Add_Islands (Source => "Layer_2.png", Current_Zoom => x4);

      Zoom
        (Source      => "Layer_2.png", Multiply => x4,
         Destination => "Layer_3.png");

      Add_Islands (Source => "Layer_3.png", Current_Zoom => x8);
      Add_Islands (Source => "Layer_3.png", Current_Zoom => x8);
      Add_Islands (Source => "Layer_3.png", Current_Zoom => x8);

      Remove_Too_Much
        (Ocean, From => Rocks, Source => "Layer_3.png", Current_Zoom => x8);

      Remove_Too_Much
        (Rocks, From => Ocean, Source => "Layer_3.png", Current_Zoom => x8,
         Dilatation_Number => 6);

      Zoom
        (Source      => "Layer_3.png", Multiply => x8,
         Destination => "Layer_4.png");

      Remove_Too_Much
        (Ocean, From => Rocks, Source => "Layer_4.png", Current_Zoom => x16);

      Zoom
        (Source      => "Layer_4.png", Multiply => x16,
         Destination => "Layer_5.png");

   end Generate_Baseline;

   --------------------------
   -- Generate_Hilld_Model --
   --------------------------

   procedure Generate_Hills_Model is

      x2  : constant Positive := Zoom_Levels (0);
      x4  : constant Positive := Zoom_Levels (1);
      x8  : constant Positive := Zoom_Levels (2);
      x16 : constant Positive := Zoom_Levels (3);
      x32 : constant Positive := Zoom_Levels (4);

   begin

      Island ("Hills_1.png");

      Zoom
        (Source      => "Hills_1.png", Multiply => x2,
         Destination => "Hills_2.png");

      Add_Islands (Source => "Hills_2.png", Current_Zoom => x4);

      Zoom
        (Source      => "Hills_2.png", Multiply => x4,
         Destination => "Hills_3.png");

      Add_Islands (Source => "Hills_3.png", Current_Zoom => x8);
      Add_Islands (Source => "Hills_3.png", Current_Zoom => x8);
      Add_Islands (Source => "Hills_3.png", Current_Zoom => x8);

      Remove_Too_Much
        (Rocks, From => Ocean, Source => "Hills_3.png", Current_Zoom => x8,
         Dilatation_Number => 7);

      Zoom
        (Source      => "Hills_3.png", Multiply => x8,
         Destination => "Hills_4.png");

      Zoom
        (Source      => "Hills_4.png", Multiply => x16,
         Destination => "Hills_5.png");

      Zoom
        (Source      => "Hills_5.png", Multiply => x32,
         Destination => "Hills_6.png");

   end Generate_Hills_Model;

   -------------------------------
   -- Generate_Deep_Ocean_Model --
   -------------------------------

   procedure Generate_Deep_Ocean_Model is

      x2  : constant Positive := Zoom_Levels (0);
      x4  : constant Positive := Zoom_Levels (1);
      x8  : constant Positive := Zoom_Levels (2);
      x16 : constant Positive := Zoom_Levels (3);
      x32 : constant Positive := Zoom_Levels (4);

   begin

      Island ("Ocean_1.png");

      Zoom
        (Source      => "Ocean_1.png", Multiply => x2,
         Destination => "Ocean_2.png");

      Add_Islands (Source => "Ocean_2.png", Current_Zoom => x4);

      Zoom
        (Source      => "Ocean_2.png", Multiply => x4,
         Destination => "Ocean_3.png");

      Add_Islands (Source => "Ocean_3.png", Current_Zoom => x8);
      Add_Islands (Source => "Ocean_3.png", Current_Zoom => x8);
      Add_Islands (Source => "Ocean_3.png", Current_Zoom => x8);

      Remove_Too_Much
        (Rocks, From => Ocean, Source => "Ocean_3.png", Current_Zoom => x8,
         Dilatation_Number => 7);

      Remove_Too_Much
        (Ocean, From => Rocks, Source => "Ocean_3.png", Current_Zoom => x8);

      Zoom
        (Source      => "Ocean_3.png", Multiply => x8,
         Destination => "Ocean_4.png");

      Zoom
        (Source      => "Ocean_4.png", Multiply => x16,
         Destination => "Ocean_5.png");

      Zoom
        (Source      => "Ocean_5.png", Multiply => x32,
         Destination => "Ocean_6.png");

   end Generate_Deep_Ocean_Model;

   ---------------------
   -- Generate_Biomes --
   ---------------------

   procedure Generate_Biomes is

      Temp_Map_Z2 : Temperature_Map_Z2;
      Temp_Map_Z5 : Temperature_Map_Z5;

      x32 : constant Positive := Zoom_Levels (4);
      x64 : constant Positive := Zoom_Levels (5);

   begin

      Init_Temperature_Map_Z2 (Temp_Map_Z2);
      Smooth_Temperature (Temp_Map_Z2);
      Scale_Map (From => Temp_Map_Z2, To => Temp_Map_Z5);

      Place_Biomes ("Layer_5.png", Temp_Map_Z5);

      Zoom
        (Source      => "Layer_5.png", Multiply => x32,
         Destination => "Layer_6.png");

      Place_Topography (Source => "Layer_6.png", Current_Zoom => x64);

   end Generate_Biomes;

end Generation;
