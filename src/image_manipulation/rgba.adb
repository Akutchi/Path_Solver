with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Strings.Maps;      use Ada.Strings.Maps;
with Ada.Text_IO;           use Ada.Text_IO;

package body RGBA is

   function Almost_Equal (x, y : Gdouble; epsilon : Precision) return Boolean
   is
   begin

      return Precision (abs (x - y)) < epsilon;

   end Almost_Equal;

   function "=" (Lossy_Color : Gdk_RGBA; To : Gdk_RGBA) return Boolean is

      epsilon : constant Precision := 0.1;

   begin

      return
        Almost_Equal (Lossy_Color.Red, To.Red, epsilon)
        and then Almost_Equal (Lossy_Color.Green, To.Green, epsilon)
        and then Almost_Equal (Lossy_Color.Blue, To.Blue, epsilon);

   end "=";

   ------------------
   -- Create_Image --
   ------------------

   procedure Create_Image (Name : String; Zoom : Positive) is

      To_String_Zoom : constant String :=
        Trim (Positive'Image (Zoom), Ada.Strings.Left);

      Size_String : constant String := To_String_Zoom & " " & To_String_Zoom;

      Full_Cmd : constant String :=
        "python3 " & Relative_Path_From_Bin & "create_image.py " &
        Image_Destination & " " & Name & " " & Size_String;

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

   procedure Put_Pixel (Name : String; X, Y : Pos; Color : Gdk_RGBA) is

      X_Str : constant String := Trim (Pos'Image (X), Ada.Strings.Left);
      Y_Str : constant String := Trim (Pos'Image (Y), Ada.Strings.Left);

      Full_Cmd : constant String :=
        "python3 " & Relative_Path_From_Bin & "put_pixel.py " &
        Image_Destination & " " & Name & " " & X_Str & " " & Y_Str & " " &
        Convert_GdkRGBA_To_String (Color);

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

   function Get_Pixel_Color (Source : String; X, Y : Pos) return String is

      X_Str : constant String := Trim (Pos'Image (X), Ada.Strings.Left);
      Y_Str : constant String := Trim (Pos'Image (Y), Ada.Strings.Left);

      Full_Cmd : constant String :=
        "python3 " & Relative_Path_From_Bin & "get_pixel.py " &
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
      return Integer (Float'Rounding (Float (x) * 255.0));
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
      return R & "," & G & "," & B;
   end Convert_GdkRGBA_To_String;

   -------------------------------
   -- Convert_String_To_GdkRGBA --
   -------------------------------

   function Convert_String_To_GdkRGBA (Color_Str : String) return Gdk_RGBA is

      Slice_Color_Str : constant String :=
        Color_Str (Color_Str'First + 1 .. Color_Str'Last - 1);

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
