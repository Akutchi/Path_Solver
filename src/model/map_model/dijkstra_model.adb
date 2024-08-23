with Image_IO.Holders;    use Image_IO.Holders;
with Image_IO.Operations; use Image_IO.Operations;

with RGBA; use RGBA;

package body Dijkstra_Model is

   ----------------
   -- Init_Costs --
   ----------------

   procedure Init_Costs (C_Hash : out Map) is

      function T (x : Float) return Float;
      function S (x : Float) return Float;
      function f (x, y : Float) return Float;

      function T (x : Float) return Float is
      begin
         return x**2 + 1.0;
      end T;

      function S (x : Float) return Float is
      begin
         return x;
      end S;

      function f (x, y : Float) return Float is

         a : constant Float := 1.0;
         b : constant Float := 0.5;
      begin
         return a * T (x) + b * S (y);

      end f;

      Desert_Cost     : constant Float := f (2.0, 2.0);
      Mesa_Cost       : constant Float := f (1.8, 2.0);
      Jungle_Cost     : constant Float := f (1.7, 5.0);
      Rainforest_Cost : constant Float := f (1.6, 1.5);
      Forest_Cost     : constant Float := f (1.0, 1.3);
      Rocks_Cost      : constant Float := f (0.0, 0.0);
      Snowy_Cost      : constant Float := f (-1.3, 1.0);
      SnowyTaiga_Cost : constant Float := f (-1.5, 1.6);
      Ice_Cost        : constant Float := f (-2.0, 1.3);
      SnowIce_Cost    : constant Float := f (-2.0, 1.5);

      df : constant Float := 0.5;

   begin

      --  Flatten to nearest round float because there's a slight difference
      --  between constants.ads colors and colors got from Layer_6.png.
      --
      --  In essence, for all x in [0, 1], e << x, Flatten ([x-e; x+e]) = x

      C_Hash.Include (Flatten (Ocean), INFINITY);
      C_Hash.Include (Flatten (Deep_Ocean), INFINITY);

      C_Hash.Include (Flatten (Desert), Desert_Cost);
      C_Hash.Include (Flatten (Mesa), Mesa_Cost);
      C_Hash.Include (Flatten (Jungle), Jungle_Cost);
      C_Hash.Include (Flatten (Rainforest), Rainforest_Cost);
      C_Hash.Include (Flatten (Forest), Forest_Cost);
      C_Hash.Include (Flatten (Rocks), Rocks_Cost);
      C_Hash.Include (Flatten (Snowy), Snowy_Cost);
      C_Hash.Include (Flatten (SnowyTaiga), SnowyTaiga_Cost);
      C_Hash.Include (Flatten (Ice), Ice_Cost);
      C_Hash.Include (Flatten (SnowIce), SnowIce_Cost);

      C_Hash.Include (Flatten (Mesa_Hills), Mesa_Cost + df);
      C_Hash.Include (Flatten (Rainforest_Hills), Rainforest_Cost + df);
      C_Hash.Include (Flatten (Jungle_Tree), Jungle_Cost + df);
      C_Hash.Include (Flatten (Forest_Trees), Forest_Cost + df);
      C_Hash.Include (Flatten (Rocky_Hills), Rocks_Cost + df);
      C_Hash.Include (Flatten (Snowy_Hills), Snowy_Cost + df);
      C_Hash.Include (Flatten (SnowyTaiga_Snow), SnowyTaiga_Cost + df);
      C_Hash.Include (Flatten (Ice_Hills), Ice_Cost + df);
      C_Hash.Include (Flatten (SnowyIce_Hills), SnowIce_Cost + df);

   end Init_Costs;

   -----------------
   -- Init_Points --
   -----------------

   procedure Init_Points (Data : Image_Data; C_Map : out Cost_Map) is

      Positions_Decided : Natural := 0;
      Coords            : Point;

   begin

      while Positions_Decided /= 2 loop

         Coords := Draw_Random_Position (Z6);

         if RGBA."/="
             (Color_Info_To_GdkRGBA
                (Get_Pixel_Color (Data, Coords.X, Coords.Y)),
              Ocean)
           and then RGBA."/="
             (Color_Info_To_GdkRGBA
                (Get_Pixel_Color (Data, Coords.X, Coords.Y)),
              Deep_Ocean)
         then

            if Positions_Decided = 0 then
               C_Map.Start_Point := Coords;

            elsif Positions_Decided = 1 then
               C_Map.End_Point := Coords;

            end if;
            Positions_Decided := Positions_Decided + 1;

         end if;
      end loop;

   end Init_Points;

   ----------------
   -- Init_Queue --
   ----------------

   procedure Init_Queue (Data : Image_Data; Q : out Queue) is
   begin

      Q (Q'Last) := Z6 * Z6;

      for I in Q'First .. Q'Last - 1 loop

         declare

            X : constant Pos := Pos (I / Z6);
            Y : constant Pos := Pos (I mod Z6);

            Color : constant Gdk_RGBA :=
              Color_Info_To_GdkRGBA (Get_Pixel_Color (Data, X, Y));

         begin

            if RGBA."=" (Color, Ocean) and then RGBA."=" (Color, Deep_Ocean)
            then
               Q (I)      := 0;
               Q (Q'Last) := Q (Q'Last) - 1;

            end if;
         end;
      end loop;
   end Init_Queue;

   -------------------
   -- Init_Dijkstra --
   -------------------

   procedure Init_Dijsktra (C_Map : out Cost_Map) is

      Image : Handle;
   begin

      Init_Costs (C_Map.Costs);

      Read (Map_Destination, Image);

      declare
         Data : constant Image_Data := Image.Value;

      begin
         Init_Points (Data, C_Map);
      end;

   end Init_Dijsktra;

   -------------
   -- Get_Min --
   -------------

   function Get_Min (Q : out Queue; Dist : Dist_Array) return Natural is

      min : Float   := INFINITY;
      k   : Natural := 0;
   begin

      for I in Q'First .. Q'Last - 1 loop

         --  Warning : ma be referenced before it has a value
         --  never happends here because was init on L.272
         if Q (I) = 1 and then Dist (I) < min then

            min := Dist (I);
            k   := I;

         end if;
      end loop;

      Q (k)      := 0;
      Q (Q'Last) := Q (Q'Last) - 1;

      return k;

   end Get_Min;

   --------------------
   -- Get_Neighbours --
   --------------------

   function Get_Neighbours (Q : Queue; u : Natural) return Neighbours.Vector is

      N     : Neighbours.Vector;
      First : constant Integer := Integer (Q'First + 1);
      Last  : constant Integer := Integer (Q'Last - 1);

      v : constant Integer := u + 1;
      w : constant Integer := u - Z6;
      s : constant Integer := u - 1;
      t : constant Integer := u + Z6;

   begin

      if v < Last and then Q (Natural (v)) = 1 then
         N.Append (v);
      end if;

      if w > First and then Q (Natural (w)) = 1 then
         N.Append (w);
      end if;

      if s > First and then Q (Natural (s)) = 1 then
         N.Append (s);
      end if;

      if t < Last and then Q (Natural (t)) = 1 then
         N.Append (t);
      end if;

      return N;

   end Get_Neighbours;

   -----------
   -- Costs --
   -----------

   function Cost (Data : Image_Data; Costs : Map; v : Natural) return Float is

      X : constant Pos      := Pos (v / Z6);
      Y : constant Pos      := Pos (v mod Z6);
      C : constant Gdk_RGBA :=
        Flatten (Color_Info_To_GdkRGBA (Get_Pixel_Color (Data, X, Y)));

   begin
      return Costs (C);
   end Cost;

   -----------------------------
   -- Calculate_Shortest_Path --
   -----------------------------

   function Calculate_Shortest_Path
     (Dijkstra_Info : Cost_Map) return Prev_Array
   is

      Source : constant Natural :=
        Natural (Dijkstra_Info.Start_Point.X) * Z6 +
        Natural (Dijkstra_Info.Start_Point.Y);
      Target : constant Natural :=
        Natural (Dijkstra_Info.End_Point.X) * Z6 +
        Natural (Dijkstra_Info.End_Point.Y);

      Image : Handle;

      Dist : Dist_Array := (others => INFINITY);
      Prev : Prev_Array := (others => -1);
      Q    : Queue      := (others => 1);

   begin

      Read (Map_Destination, Image);

      declare

         Data  : constant Image_Data := Image.Value;
         u_min : Natural             := 0;
         alt   : Float               := 0.0;

      begin
         Init_Queue (Data, Q);
         Dist (Source) := 0.0;

         while u_min /= Target and then Q (Q'Last) > 0 loop

            u_min := Get_Min (Q, Dist);

            for v of Get_Neighbours (Q, u_min) loop

               alt := Dist (u_min) + Cost (Data, Dijkstra_Info.Costs, v);
               if alt < Dist (v) then

                  Dist (v) := alt;
                  Prev (v) := u_min;

               end if;
            end loop;
         end loop;
      end;

      return Prev;

   end Calculate_Shortest_Path;

   -----------------
   -- Salmon_Swim --
   -----------------

   function Salmon_Swim
     (Prev : Prev_Array; Dijkstra_Info : Cost_Map) return Shortest_Path.Vector
   is

      Path : Shortest_Path.Vector;

      Source : constant Natural :=
        Natural (Dijkstra_Info.Start_Point.X) * Z6 +
        Natural (Dijkstra_Info.Start_Point.Y);
      Target : constant Natural :=
        Natural (Dijkstra_Info.End_Point.X) * Z6 +
        Natural (Dijkstra_Info.End_Point.Y);

      u : Natural := Target;

   begin

      if Prev (u) /= -1 or else Prev (u) = Source then

         while Prev (u) /= -1 loop
            Append (Path, (Pos (u / Z6), Pos (u mod Z6)));
            u := Prev (u);

         end loop;
      end if;

      return Path;

   end Salmon_Swim;

   -----------------
   -- Draw_On_Map --
   -----------------

   procedure Draw_On_Map
     (Path : Shortest_Path.Vector; Dijkstra_Info : Cost_Map)
   is

      Image_Src  : Handle;
      Image_Dest : Handle;
   begin

      Create_Image (Final_Destination, Z6);

      Read (Map_Destination, Image_Src);
      Read (Final_Destination, Image_Dest);

      declare
         Data_Src  : constant Image_Data := Image_Src.Value;
         Data_Dest : Image_Data          := Image_Dest.Value;
         Color     : Gdk_RGBA;

         Source : constant Point := Dijkstra_Info.Start_Point;
         Target : constant Point := Dijkstra_Info.End_Point;

      begin

         for I in 0 .. Z6 - 1 loop
            for J in 0 .. Z6 - 1 loop

               declare
                  Color : constant Gdk_RGBA :=
                    Color_Info_To_GdkRGBA
                      (Get_Pixel_Color (Data_Src, Pos (I), Pos (J)));
               begin
                  Put_Pixel (Data_Dest, Pos (I), Pos (J), Color);
               end;
            end loop;
         end loop;

         if not Is_Empty (Path) then

            for p of Path loop

               if p = First_Element (Path) or else p = Last_Element (Path) then
                  Color := Black;
               else
                  Color := Dark_Red;
               end if;

               Put_Pixel (Data_Dest, p.X, p.Y, Color);
            end loop;

         else
            Put_Pixel (Data_Dest, Source.X, Source.Y, Black);
            Put_Pixel (Data_Dest, Target.X, Target.Y, Black);
         end if;

         Write_PNG (Final_Destination, Data_Dest);
      end;

   end Draw_On_Map;

end Dijkstra_Model;
