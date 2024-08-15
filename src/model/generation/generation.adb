with Ada.Numerics.Generic_Elementary_Functions;

with Gdk.RGBA; use Gdk.RGBA;

with RGBA;                       use RGBA;
with Generation.Random_Biome;    use Generation.Random_Biome;
with Generation.Random_Position; use Generation.Random_Position;
with Constants;                  use Constants;

package body Generation is

   package Float_Calculations is new Ada.Numerics.Generic_Elementary_Functions
     (Float_Type => Float);

   use Float_Calculations;

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

            I : constant Pos := Pos (k / Zoom_Levels (0));
            J : constant Pos := Pos (k mod Zoom_Levels (0));

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

   ----------
   -- Zoom --
   ----------

   procedure Zoom (Source : String; Multiply : Positive; Destination : String)
   is

      I, J : Pos := 0; --  Base coords
      K, L : Pos := 0; --  Zoomed Coords

   begin

      Create_Image (Destination, Multiply * 2);

      loop

         exit when Natural (L) > Multiply * 2 - 1;

         I := 0;
         K := 0;

         loop

            exit when Natural (K) > Multiply * 2 - 1;

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

   -----------------
   -- Add_Islands --
   -----------------

   procedure Add_Islands (Source : String; Current_Zoom : Positive) is

      N                : constant Float    := Float (Current_Zoom);
      Stochastic_Tries : constant Positive :=
        Positive (N * Log (N, Ada.Numerics.e));

   begin

      for I in 1 .. Stochastic_Tries loop

         declare

            Coords : constant Point    := Draw_Random_Position (Current_Zoom);
            Color_Str   : constant String   :=
              Get_Pixel_Color (Source, Coords.X, Coords.Y);
            Lossy_Color : constant Gdk_RGBA :=
              Convert_String_To_GdkRGBA (Color_Str);

         begin

            if RGBA."=" (Lossy_Color, Ocean) then

               Put_Pixel (Source, Coords.X, Coords.Y, Rocks);

            end if;

         end;

      end loop;

   end Add_Islands;

end Generation;
