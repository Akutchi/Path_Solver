with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings.Maps;      use Ada.Strings.Maps;
with Ada.Text_IO;           use Ada.Text_IO;

package body RGBA is

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

   ---------------------
   -- Get_Pixel_Color --
   ---------------------

   function Get_Pixel_Color (Source : String; X, Y : Integer) return String is

      X_Str : constant String := Trim (Integer'Image (X), Ada.Strings.Left);
      Y_Str : constant String := Trim (Integer'Image (Y), Ada.Strings.Left);

      --  Using a python script instead of IM, because the latter can return
      --  " fractal ", which is a problem.
      Full_Cmd : constant String :=
        "python3 ../src/model/image_manipulation/get_pixel.py " &
        Image_Destination & " " & Source & " " & X_Str & " " & Y_Str;

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

   ----------------------
   -- Float_To_Int_RBG --
   ----------------------

   function Float_To_Int_RGB (x : Gdouble) return Integer is
   begin
      return Integer (Float (x) * 255.0);
   end Float_To_Int_RGB;

   ---------------------------
   -- Integer_To_String_RGB --
   ---------------------------

   function Integer_To_String_RGB (n : Integer) return String is
   begin
      return Integer'Image (n);
   end Integer_To_String_RGB;

   -------------------------------
   -- Convert_GdkRGBA_To_String --
   -------------------------------

   function Convert_GdkRGBA_To_String (Color : Gdk_RGBA) return String is

      R : constant String :=
        Trim
          (Integer_To_String_RGB (Float_To_Int_RGB (Color.Red)),
           Ada.Strings.Left);

      G : constant String :=
        Trim
          (Integer_To_String_RGB (Float_To_Int_RGB (Color.Green)),
           Ada.Strings.Left);

      B : constant String :=
        Trim
          (Integer_To_String_RGB (Float_To_Int_RGB (Color.Blue)),
           Ada.Strings.Left);

   begin
      return "rgb(" & R & ", " & G & ", " & B & ")";
   end Convert_GdkRGBA_To_String;

   -----------------
   -- Strip_Space --
   -----------------

   function Strip_Space (S : String) return String is
      Result  : String   := S;
      Current : Positive := Result'First;
      Last    : Natural  := Result'Last;
   begin
      loop
         exit when Current > Last;
         if Result (Current) = ' ' then
            Result (Current .. Last - 1) := Result (Current + 1 .. Last);
            Last                         := Last - 1;
         else
            Current := Current + 1;
         end if;
      end loop;
      return Result (Result'First .. Last);
   end Strip_Space;

   function Convert_String_To_GdkRGBA (Color_Str : String) return Gdk_RGBA is

      Slice_Color_Str : constant String :=
        Strip_Space (Color_Str (Color_Str'First + 5 .. Color_Str'Last - 1));

      F     : Positive;
      L     : Natural;
      I     : Natural := Slice_Color_Str'First;
      Index : Natural := 0;

      Comma : constant Character_Set := To_Set (',');

      Color_Obj : Gdk_RGBA;

      Color_Components : Array_Gdouble;

   begin

      while I in Slice_Color_Str'Range loop

         Find_Token
           (Source => Slice_Color_Str, Set => Comma, From => I,
            Test   => Outside, First => F, Last => L);

         exit when L = 0;

         Color_Components (Index) :=
           Gdouble (Float'Value (Slice_Color_Str (F .. L)) / 255.0);

         I     := L + 1;
         Index := Index + 1;

      end loop;

      Color_Obj.Red   := Color_Components (0);
      Color_Obj.Green := Color_Components (1);
      Color_Obj.Blue  := Color_Components (2);
      Color_Obj.Alpha := 1.0;

      return Color_Obj;

   exception
      when others =>
         return (0.0, 0.0, 0.0, 1.0);

   end Convert_String_To_GdkRGBA;

end RGBA;