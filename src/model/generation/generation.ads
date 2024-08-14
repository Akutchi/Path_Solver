-------------------------------------------------------------------------------
--                                                                           --
--                                                                           --
-- This file, and the folder in general is my ada implementation of a        --
-- minecraft-like world generator [1].                                       --
--                                                                           --
-- Each layer is a procedure which act on an image inside the                --
-- layer_templates folder. It takes in an In_File and output and Out_File.   --
-- The only exception being the Island layer which create the first map.     --
-- Each Stack is a list of procedure.                                        --
--                                                                           --
--                                                                           --
-- [1] https://www.alanzucconi.com/2022/06/05/minecraft-world-generation/    --
--                                                                           --
-------------------------------------------------------------------------------

with Gdk.RGBA; use Gdk.RGBA;

with Interfaces.C;

package Generation is

   package C renames Interfaces.C;
   use type C.int;

   function system (command : C.char_array) return C.int with
     Import, Convention => C;

   result : C.int;

   Image_Destination : constant String := "../layer_templates/";
   Pixel_Type        : constant String := "../layer_templates/res.txt";
   No_Pixel          : constant String := "none";

   type Zoom_Levels_List is array (Natural range 0 .. 5) of Positive;
   Zoom_Levels : constant Zoom_Levels_List := (5, 10, 20, 40, 80, 160);

   procedure Island (Source : String);

private

   procedure Create_Image (Name : String; Zoom : Positive);
   procedure Put_Pixel (Name : String; X, Y : Integer; Color : Gdk_RGBA);
   function Get_Pixel_Color (Source : String; X, Y : Integer) return String;
   function Pixel_Is_Transparent
     (Source : String; X, Y : Integer) return Boolean;

end Generation;
