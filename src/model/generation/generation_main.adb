with Generation; use Generation;

procedure Generation_Main is
begin

   Island ("Layer_1.png");
   Zoom
     (Source      => "Layer_1.png", Multiply => Zoom_Levels (0),
      Destination => "Layer_2.png");
   Add_Islands ("Layer_2.png", Zoom_Levels (1));
   Zoom
     (Source      => "Layer_2.png", Multiply => Zoom_Levels (1),
      Destination => "Layer_3.png");
   Add_Islands ("Layer_3.png", Zoom_Levels (2));
   Add_Islands ("Layer_3.png", Zoom_Levels (2));

end Generation_Main;
