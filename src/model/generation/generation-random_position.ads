-------------------------------------------------------------------------------
--                                                                           --
--                                                                           --
-- This package is used for the random choosing of the positions of          --
-- land etc. in the layers. Each layer has a random distribution associated  --
-- to it.                                                                    --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Numerics.Discrete_Random;

package Generation.Random_Position is

   type Pos is range 0 .. 160;
   subtype Pos_5 is Pos range 0 .. 4;
   subtype Pos_10 is Pos range 0 .. 9;
   subtype Pos_20 is Pos range 0 .. 19;
   subtype Pos_40 is Pos range 0 .. 39;
   subtype Pos_80 is Pos range 0 .. 79;
   subtype Pos_160 is Pos range 0 .. 159;

   package Random_5 is new Ada.Numerics.Discrete_Random (Pos_5);
   package Random_10 is new Ada.Numerics.Discrete_Random (Pos_10);
   package Random_20 is new Ada.Numerics.Discrete_Random (Pos_10);
   package Random_40 is new Ada.Numerics.Discrete_Random (Pos_10);
   package Random_80 is new Ada.Numerics.Discrete_Random (Pos_10);
   package Random_160 is new Ada.Numerics.Discrete_Random (Pos_10);

   use Random_5;
   use Random_10;
   use Random_20;
   use Random_40;
   use Random_80;
   use Random_160;

   G5   : Random_5.Generator;
   G10  : Random_10.Generator;
   G20  : Random_20.Generator;
   G40  : Random_40.Generator;
   G80  : Random_80.Generator;
   G160 : Random_160.Generator;

   type Point is record

      X : Pos;
      Y : Pos;

   end record;

   function Draw_Random_Position (Zoom : Integer) return Point;

private

   function Draw (Zoom : Integer) return Point;

end Generation.Random_Position;
