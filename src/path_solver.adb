with Gtk.Main; use Gtk.Main;

with Generation;     use Generation;
with Dijkstra_Model; use Dijkstra_Model;

with Main_Windows;
with Canvas;

procedure Path_Solver is

   Win           : Main_Windows.Main_Window;
   Main_Canvas   : Canvas.Image_Canvas;
   Dijkstra_Info : Cost_Map;
   Prev          : Prev_Array;
   Path          : Shortest_Path.Vector;

begin

   Generate_Baseline;
   Generate_Hills_Model;
   Generate_Deep_Ocean_Model;
   Generate_Biomes;

   Init_Dijsktra (Dijkstra_Info);
   Init;

   Prev := Calculate_Shortest_Path (Dijkstra_Info);
   Path := Salmon_Swim (Prev, Dijkstra_Info);
   Draw_On_Map (Path, Dijkstra_Info);

   Main_Windows.Gtk_New (Win);
   Canvas.Gtk_New (Main_Canvas);

   Canvas.Initial_Setup (Main_Canvas);
   Canvas.Realize (Main_Canvas);

   Main_Windows.Add (Win, Main_Canvas);
   Main_Windows.Show_All (Win);
   Main;

end Path_Solver;
