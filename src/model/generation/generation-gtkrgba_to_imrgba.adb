with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package body Generation.gtkRGBA_To_IMRGBA is

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

end Generation.gtkRGBA_To_IMRGBA;
