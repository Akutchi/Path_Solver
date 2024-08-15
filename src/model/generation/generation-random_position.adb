with Constants; use Constants;

package body Generation.Random_Position is

   function Draw (Zoom : Integer) return Point is
   begin

      Reset (GZ1);
      Reset (GZ2);
      Reset (GZ3);
      Reset (GZ4);
      Reset (GZ5);
      Reset (GZ6);

      case Zoom is

         when Z1 =>
            return (Random (GZ1), Random (GZ1));
         when Z2 =>
            return (Random (GZ2), Random (GZ2));
         when Z3 =>
            return (Random (GZ3), Random (GZ3));
         when Z4 =>
            return (Random (GZ4), Random (GZ4));
         when Z5 =>
            return (Random (GZ5), Random (GZ5));
         when Z6 =>
            return (Random (GZ6), Random (GZ6));

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

            --  This should never happen
         when others =>
            null;

      end case;

      return (0, 0);

   end Draw_Random_Position;

end Generation.Random_Position;
