with RGBA; use RGBA;

with Ada.Text_IO; use Ada.Text_IO;

with Constants; use Constants;

package body Math_Hash is

   function hash (c : Gdk_RGBA) return Hash_Type is

      M : constant Positive := 20;
      R : constant Positive := 31;

      red   : constant Positive := Positive (Gdouble_To_UInt8 (c.Red));
      green : constant Positive := Positive (Gdouble_To_UInt8 (c.Green));
      blue  : constant Positive := Positive (Gdouble_To_UInt8 (c.Blue));

   begin
      return Hash_Type ((((red * R + green) mod M) * R + blue) mod M);
   end hash;

end Math_Hash;
