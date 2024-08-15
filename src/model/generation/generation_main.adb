with Generation;      use Generation;
with Temperature_Map; use Temperature_Map;

procedure Generation_Main is

   Temp_Map_20 : Temperature_Map_20;
   Temp_Map_80 : Temperature_Map_80;

begin

   --  Island ("Layer_1.png");                                       --  x5

   --  Zoom
   --    (Source      => "Layer_1.png", Multiply => Zoom_Levels (0), --  x10
   --     Destination => "Layer_2.png");

   --  Add_Islands ("Layer_2.png", Zoom_Levels (1));

   --  Zoom
   --    (Source      => "Layer_2.png", Multiply => Zoom_Levels (1), --  x20
   --     Destination => "Layer_3.png");

   --  Add_Islands ("Layer_3.png", Zoom_Levels (2));
   --  Add_Islands ("Layer_3.png", Zoom_Levels (2));

   Init_Temperature_Map_20 (Temp_Map_20);
   Smooth_Temperature (Temp_Map_20);
   Quadruple_Map (From => Temp_Map_20, To => Temp_Map_80);
   Print_Map_80 (Temp_Map_80);

   --  Zoom
   --    (Source      => "Layer_4.png", Multiply => Zoom_Levels (2), --  x40
   --     Destination => "Layer_5.png");
   --  Zoom
   --    (Source      => "Layer_5.png", Multiply => Zoom_Levels (3), --  x80
   --     Destination => "Layer_6.png");

end Generation_Main;
