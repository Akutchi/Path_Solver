with Ada.Containers; use Ada.Containers;

with Gdk.RGBA; use Gdk.RGBA;

package Math_Hash is

   function hash (c : Gdk_RGBA) return Hash_Type;

end Math_Hash;
