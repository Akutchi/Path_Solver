with Ada.Strings.Fixed; use Ada.Strings.Fixed;

with Generation.gtkRGBA_To_IMRGBA; use Generation.gtkRGBA_To_IMRGBA;
with Generation.Random_Position;   use Generation.Random_Position;

with Ada.Text_IO; use Ada.Text_IO;

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

   end Put_Pixel;

   procedure Island (In_File : String) is

      Case_Until_End : Natural := Zoom_Levels (0) * Zoom_Levels (0);
      Result         : Point;

   begin

      Create_Image (In_File, Zoom_Levels (0));

      Result := Draw_Random_Position (5);

      Put_Line (Pos'Image (Result.X) & " " & Pos'Image (Result.Y));

      Case_Until_End := 0;

      loop

         exit when Case_Until_End = 0;

      end loop;

   end Island;

end Generation;
