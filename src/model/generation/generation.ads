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
-- It is here supposed that the created images are square images.            --
--                                                                           --
--                                                                           --
-- [1] https://www.alanzucconi.com/2022/06/05/minecraft-world-generation/    --
--                                                                           --
-------------------------------------------------------------------------------

with Image_IO; use Image_IO;

with Constants;       use Constants;
with Temperature_Map; use Temperature_Map;

package Generation is

   type Zoom_Levels_List is array (Natural range 0 .. 5) of Positive;
   Zoom_Levels : constant Zoom_Levels_List := (Z1, Z2, Z3, Z4, Z5, Z6);

   procedure Island (Source : String);
   procedure Zoom (Source : String; Multiply : Positive; Destination : String);
   procedure Add_Islands
     (Source : String; Current_Zoom : Positive; Multiplier : Integer := 1);
   procedure Remove_Too_Much_Ocean (Source : String);
   procedure Place_Hills
     (Source : String; Current_Zoom : Positive; Multiplier : Integer);
   procedure Place_Biomes (Source : String; Temp_Map : Temperature_Map_Z5);

private

   function Is_Land (Data : Image_Data; I, J : Lign_Type) return Integer;
   function Surrounded_By_Land
     (Data : Image_Data; I, J : Lign_Type) return Boolean;

end Generation;
