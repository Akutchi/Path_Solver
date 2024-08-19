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
with Random_Position; use Random_Position;

package Generation is

   type Zoom_Levels_List is array (Natural range 0 .. 6) of Positive;
   Zoom_Levels : constant Zoom_Levels_List := (Z1, Z2, Z3, Z4, Z5, Z6, Z7);

   type Row_Visit is range 0 .. Z5 - 1;
   type Col_Visit is range 0 .. Z5 - 1;
   type Is_Visited_Map is array (Row_Visit, Col_Visit) of Boolean;
   type Any_Visit_Map is access all Is_Visited_Map;

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

   function Not_Correct_Terrain (Color : Gdk_RGBA) return Boolean;

   function Not_Correct_Temperature
     (Temp_Map : Temperature_Map_Z5; I, J : Pos; T : Temperature_Type)
      return Boolean;

   function Will_Be_Out_Of_Bound (I, J : Pos) return Boolean;

   function Is_Already_Visited
     (Visit_Map : Any_Visit_Map; I, J : Pos) return Boolean;

   function Diffuse
     (Data      : out Image_Data; Temp_Map : Temperature_Map_Z5;
      Visit_Map :     Any_Visit_Map; I, J : Pos; T : Temperature_Type;
      Biome     :     Gdk_RGBA) return Natural;
   --  The current way of creating biomes is by diffusing recursively.
   --
   --  Indeed, because of biomes variations, the temperatures are not equal to
   --  one biome each. Thus, choosing a random variation and putting it in a
   --  position (I, J) would result in too much mess.
   --
   --  Thus, I opted for 1 Zone = 1 SubBiome.

   function Choose_And_Diffuse
     (Data      : out Image_Data; Temp_Map : Temperature_Map_Z5;
      Visit_Map :     Any_Visit_Map; I, J : Pos; T : Temperature_Type)
      return Natural;

   function Everything_Visited (Visit_Map : Any_Visit_Map) return Boolean;

   procedure Place_Biomes
     (Source : String; Temp_Map : Temperature_Map_Z5; Current_Zoom : Positive);

   procedure Place_Topography (Source : String; Current_Zoom : Positive);

end Generation;
