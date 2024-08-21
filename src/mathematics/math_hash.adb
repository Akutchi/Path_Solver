with RGBA; use RGBA;

with Ada.Text_IO; use Ada.Text_IO;

package body Math_Hash is

   function hash (c : Gdk_RGBA) return Hash_Type is

      red   : constant Positive := Positive (Gdouble_To_UInt8 (c.Red));
      green : constant Positive := Positive (Gdouble_To_UInt8 (c.Green));
      blue  : constant Positive := Positive (Gdouble_To_UInt8 (c.Blue));

   begin
      return Hash_Type (red + (green * 2**8) + (blue * 2**16));
   end hash;

end Math_Hash;
