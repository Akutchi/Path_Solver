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

with Gdk.RGBA; use Gdk.RGBA;

with Image_IO; use Image_IO;

with Constants;       use Constants;
with Temperature_Map; use Temperature_Map;

package Generation is

   type Zoom_Levels_List is array (Natural range 0 .. 6) of Positive;
   Zoom_Levels : constant Zoom_Levels_List := (Z1, Z2, Z3, Z4, Z5, Z6, Z7);

   procedure Generate_Baseline;
   procedure Generate_Hills_Model;
   procedure Generate_Deep_Ocean_Model;
   procedure Generate_Biomes;

private

   function Surrounded_By
     (Terrain           : Gdk_RGBA; Data : Image_Data; I, J : Lign_Type;
      Dilatation_Number : Positive := 5) return Boolean;

   procedure Island (Source : String);

   procedure Zoom (Source : String; Multiply : Positive; Destination : String);

   procedure Add_Islands (Source : String; Current_Zoom : Positive);
   --  Here, we don't handle borders (it is simpler) as we have to check
   --  the (horizontal/vertical) neighbourhood around a point.

   procedure Remove_Too_Much
     (Terrain      : Gdk_RGBA; From : Gdk_RGBA; Source : String;
      Current_Zoom : Positive; Dilatation_Number : Positive := 5);
   --  Here, we don't handle borders (it is simpler) as we have to check
   --  the neighbourhood around a point.

   procedure Place_Topography (Source : String; Current_Zoom : Positive);

   procedure Place_Biomes (Source : String; Temp_Map : Temperature_Map_Z5);

end Generation;
