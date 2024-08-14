package body Generation.Random_Position is

   function Draw (Zoom : Integer) return Point is
   begin

      Reset (G5);
      Reset (G10);
      Reset (G20);
      Reset (G40);
      Reset (G80);
      Reset (G160);

      case Zoom is

         when 5 =>
            return (Random (G5), Random (G5));
         when 10 =>
            return (Random (G10), Random (G10));
         when 20 =>
            return (Random (G20), Random (G20));
         when 40 =>
            return (Random (G40), Random (G40));
         when 80 =>
            return (Random (G80), Random (G80));
         when 160 =>
            return (Random (G160), Random (G160));

            --  This should never happen
         when others =>
            null;

      end case;

      return (0, 0);

   end Draw;

   function Draw_Random_Position (Zoom : Integer) return Point is
   begin

      case Zoom is

         when 5 =>
            return Draw (5);
         when 10 =>
            return Draw (10);
         when 20 =>
            return Draw (20);
         when 40 =>
            return Draw (20);
         when 80 =>
            return Draw (80);
         when 160 =>
            return Draw (160);

            --  This should never happen
         when others =>
            null;

      end case;

      return (0, 0);

   end Draw_Random_Position;

end Generation.Random_Position;
