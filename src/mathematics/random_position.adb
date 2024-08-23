with Constants; use Constants;

package body Random_Position is

   function Draw (Zoom : Integer) return Point is
   begin

      Random_Z1.Reset (GZ1);
      Random_Z2.Reset (GZ2);
      Random_Z3.Reset (GZ3);
      Random_Z4.Reset (GZ4);
      Random_Z5.Reset (GZ5);
      Random_Z6.Reset (GZ6);
      Random_Z7.Reset (GZ7);

      case Zoom is

         when Z1 =>
            return (Random_Z1.Random (GZ1), Random_Z1.Random (GZ1));
         when Z2 =>
            return (Random_Z2.Random (GZ2), Random_Z2.Random (GZ2));
         when Z3 =>
            return (Random_Z3.Random (GZ3), Random_Z3.Random (GZ3));
         when Z4 =>
            return (Random_Z4.Random (GZ4), Random_Z4.Random (GZ4));
         when Z5 =>
            return (Random_Z5.Random (GZ5), Random_Z5.Random (GZ5));
         when Z6 =>
            return (Random_Z6.Random (GZ6), Random_Z6.Random (GZ6));
         when Z7 =>
            return (Random_Z7.Random (GZ7), Random_Z7.Random (GZ7));

            --  This should never happen
         when others =>
            null;

      end case;

      return (0, 0);

   end Draw;

   function Draw_Random_Position (Zoom : Integer) return Point is
   begin

      case Zoom is

         when Z1 =>
            return Draw (Z1);
         when Z2 =>
            return Draw (Z2);
         when Z3 =>
            return Draw (Z3);
         when Z4 =>
            return Draw (Z3);
         when Z5 =>
            return Draw (Z5);
         when Z6 =>
            return Draw (Z6);
         when Z7 =>
            return Draw (Z7);

            --  This should never happen
         when others =>
            null;

      end case;

      return (0, 0);

   end Draw_Random_Position;

end Random_Position;
