with Gdk.RGBA; use Gdk.RGBA;

with RGBA;                    use RGBA;
with Generation.Random_Biome; use Generation.Random_Biome;
with Constants;               use Constants;

package body Generation is

   ------------
   -- Island --
   ------------

   procedure Island (Source : String) is

      Case_Until_End : constant Natural := Zoom_Levels (0) * Zoom_Levels (0);
      Choice         : Land_Or_Ocean;
      Color          : Gdk_RGBA;

   begin

      Create_Image (Source, Zoom_Levels (0));

      for k in 0 .. Case_Until_End - 1 loop

         declare

            I : constant Integer := k / Zoom_Levels (0);
            J : constant Integer := k mod Zoom_Levels (0);

         begin

            Choice := Draw_Random_Base_Biome;

            if Choice > 3 then
               Color := Ocean;
            else
               Color := Rocks;
            end if;
            Put_Pixel (Source, I, J, Color);

         end;
      end loop;

   end Island;

   procedure Zoom (Source : String; Destination : String; Base_Zoom : Natural)
   is

      I, J : Natural := 0; --  Base coords
      K, L : Natural := 0; --  Zoomed Coords

   begin

      Create_Image (Destination, Base_Zoom * 2);

      loop

         exit when L > Base_Zoom * 2 - 1;

         I := 0;
         K := 0;

         loop

            exit when K > Base_Zoom * 2 - 1;

            declare
               Color_Str : constant String   := Get_Pixel_Color (Source, I, J);
               Color     : constant Gdk_RGBA :=
                 Convert_String_To_GdkRGBA (Color_Str);

            begin

               Put_Pixel (Destination, K, L, Color);
               Put_Pixel (Destination, K + 1, L, Color);
               Put_Pixel (Destination, K, L + 1, Color);
               Put_Pixel (Destination, K + 1, L + 1, Color);

            end;

            I := I + 1;
            K := K + 2;

         end loop;

         J := J + 1;
         L := L + 2;

      end loop;

   end Zoom;

end Generation;
