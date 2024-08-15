with Generation;      use Generation;
with Temperature_Map; use Temperature_Map;

procedure Generation_Main is

   Temp_Map_Z3 : Temperature_Map_Z3;
   Temp_Map_Z5 : Temperature_Map_Z5;

begin

   Island ("Layer_1.png");                                       --  x5

   Zoom
     (Source      => "Layer_1.png", Multiply => Zoom_Levels (0), --  x10
      Destination => "Layer_2.png");

   Add_Islands ("Layer_2.png", Zoom_Levels (1), 2);

   Zoom
     (Source      => "Layer_2.png", Multiply => Zoom_Levels (1), --  x20
      Destination => "Layer_3.png");

   Init_Temperature_Map_Z3 (Temp_Map_Z3);
   Smooth_Temperature (Temp_Map_Z3);
   Quadruple_Map (From => Temp_Map_Z3, To => Temp_Map_Z5);

   Add_Islands ("Layer_3.png", Zoom_Levels (2), 4);
   Add_Islands ("Layer_3.png", Zoom_Levels (2), 4);
   Add_Islands ("Layer_3.png", Zoom_Levels (2), 4);

   Remove_Too_Much_Ocean ("Layer_3.png");
   Remove_Too_Much_Ocean ("Layer_3.png");
   Remove_Too_Much_Ocean ("Layer_3.png");

   Zoom
     (Source      => "Layer_3.png", Multiply => Zoom_Levels (2), --  x40
      Destination => "Layer_4.png");

   Zoom
     (Source      => "Layer_4.png", Multiply => Zoom_Levels (3), --  x80
      Destination => "Layer_5.png");

   Add_Islands ("Layer_5.png", Zoom_Levels (4), 8);

   Place_Hills ("Layer_5.png", Zoom_Levels (4), 8);

   Place_Biomes ("Layer_5.png", Temp_Map_Z5);

   Zoom
     (Source      => "Layer_5.png", Multiply => Zoom_Levels (4), --  x160
      Destination => "Layer_6.png");

end Generation_Main;
