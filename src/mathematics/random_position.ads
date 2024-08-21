-------------------------------------------------------------------------------
--                                                                           --
--                                                                           --
-- This package is used for the random choosing of the positions of          --
-- land etc. in the layers. Each layer has a random distribution associated  --
-- to it.                                                                    --
--                                                                           --
-------------------------------------------------------------------------------

with Ada.Numerics.Discrete_Random;

package Random_Position is

   type Pos is range 0 .. 320;
   subtype Pos_Z1 is Pos range 0 .. 4;
   subtype Pos_Z2 is Pos range 0 .. 9;
   subtype Pos_Z3 is Pos range 0 .. 19;
   subtype Pos_Z4 is Pos range 0 .. 39;
   subtype Pos_Z5 is Pos range 0 .. 79;
   subtype Pos_Z6 is Pos range 0 .. 159;
   subtype Pos_Z7 is Pos range 0 .. 319;

   package Random_Z1 is new Ada.Numerics.Discrete_Random (Pos_Z1);
   package Random_Z2 is new Ada.Numerics.Discrete_Random (Pos_Z2);
   package Random_Z3 is new Ada.Numerics.Discrete_Random (Pos_Z3);
   package Random_Z4 is new Ada.Numerics.Discrete_Random (Pos_Z4);
   package Random_Z5 is new Ada.Numerics.Discrete_Random (Pos_Z5);
   package Random_Z6 is new Ada.Numerics.Discrete_Random (Pos_Z6);
   package Random_Z7 is new Ada.Numerics.Discrete_Random (Pos_Z7);

   use Random_Z1;
   use Random_Z2;
   use Random_Z3;
   use Random_Z4;
   use Random_Z5;
   use Random_Z6;
   use Random_Z7;

   GZ1 : Random_Z1.Generator;
   GZ2 : Random_Z2.Generator;
   GZ3 : Random_Z3.Generator;
   GZ4 : Random_Z4.Generator;
   GZ5 : Random_Z5.Generator;
   GZ6 : Random_Z6.Generator;
   GZ7 : Random_Z7.Generator;

   type Point is record

      X : Pos;
      Y : Pos;

   end record;

   function Draw_Random_Position (Zoom : Integer) return Point;

private

   function Draw (Zoom : Integer) return Point;

end Random_Position;
