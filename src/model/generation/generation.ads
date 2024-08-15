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

with Temperature_Map; use Temperature_Map;

package Generation is

   type Zoom_Levels_List is array (Natural range 0 .. 5) of Positive;
   Zoom_Levels : constant Zoom_Levels_List := (5, 10, 20, 40, 80, 160);

   procedure Island (Source : String);
   procedure Zoom (Source : String; Multiply : Positive; Destination : String);
   procedure Add_Islands (Source : String; Current_Zoom : Positive);

end Generation;
