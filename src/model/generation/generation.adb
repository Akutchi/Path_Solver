with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;

with Generation.gtkRGBA_To_IMRGBA; use Generation.gtkRGBA_To_IMRGBA;
with Generation.Random_Biome;      use Generation.Random_Biome;
with Constants;                    use Constants;

package body Generation is

   ------------------
   -- Create_Image --
   ------------------

   procedure Create_Image (Name : String; Zoom : Positive) is

      To_String_Zoom : constant String :=
        Trim (Positive'Image (Zoom), Ada.Strings.Left);

      Size_String : constant String := To_String_Zoom & "x" & To_String_Zoom;

      Full_Name : constant String := Image_Destination & Name;

      Full_Cmd : constant String :=
        "convert -size " & Size_String & " xc:transparent " & Full_Name;

      create_image_cmd : aliased constant C.char_array := C.To_C (Full_Cmd);

   begin

      result := system (create_image_cmd);
      if result /= 0 then
         raise Program_Error with "Exit code:" & result'Image;
      end if;

   end Create_Image;

   ---------------
   -- Put_Pixel --
   ---------------

   procedure Put_Pixel (Name : String; X, Y : Integer; Color : Gdk_RGBA) is

      Full_Name : constant String := Image_Destination & Name;

      X_Str : constant String := Trim (Integer'Image (X), Ada.Strings.Left);
      Y_Str : constant String := Trim (Integer'Image (Y), Ada.Strings.Left);

      Full_Cmd : constant String :=
        "convert " & Full_Name & " -fill " & "'" &
        Convert_GdkRGBA_To_String (Color) & "' -draw 'color " & X_Str & ", " &
        Y_Str & " point' " & Full_Name;

      Put_Pixel_Cmd : aliased constant C.char_array := C.To_C (Full_Cmd);

   begin

      result := system (Put_Pixel_Cmd);
      if result /= 0 then
         raise Program_Error with "Exit code:" & result'Image;
      end if;

   end Put_Pixel;

   function Get_Pixel_Color (Source : String; X, Y : Integer) return String is

      Full_Name : constant String := Image_Destination & Source;

      X_Str : constant String := Trim (Integer'Image (X), Ada.Strings.Left);
      Y_Str : constant String := Trim (Integer'Image (Y), Ada.Strings.Left);

      Full_Cmd : constant String :=
        "convert " & Full_Name & " -format '%[pixel:u.p{" & X_Str & ", " &
        Y_Str & "}]\n' info: > res.txt ";

      Get_Pixel_Color_Cmd : aliased constant C.char_array := C.To_C (Full_Cmd);

      F    : File_Type;
      Data : Unbounded_String := Null_Unbounded_String;

   begin

      result := system (Get_Pixel_Color_Cmd);
      if result /= 0 then
         raise Program_Error with "Exit code:" & result'Image;
      end if;

      Open (File => F, Mode => In_File, Name => Pixel_Type);

      Append (Data, Get_Line (F));
      Close (F);

      return To_String (Data);

   exception
      when others =>
         return "none";

   end Get_Pixel_Color;

   function Pixel_Is_Transparent
     (Source : String; X, Y : Integer) return Boolean
   is
      Pixel_Color : constant String := Get_Pixel_Color (Source, X, Y);
   begin

      return Pixel_Color = No_Pixel;

   end Pixel_Is_Transparent;

   procedure Island (Source : String) is

      Case_Until_End : constant Natural := Zoom_Levels (0) * Zoom_Levels (0);
      Choice         : Land_Or_Ocean;
      Color          : Gdk_RGBA;

   begin

      Put_Line (Natural'Image (Case_Until_End));

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

end Generation;
