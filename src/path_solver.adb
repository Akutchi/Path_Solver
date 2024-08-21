with Gtk.Main; use Gtk.Main;

with Main_Windows;   use Main_Windows;
with Canvas;         use Canvas;
with Generation;     use Generation;
with Dijkstra_Model; use Dijkstra_Model;

procedure Path_Solver is

   Win          : Main_Windows.Main_Window;
   Main_Canvas  : Image_Canvas;
   Dijkstra_Map : Cost_Map;

begin

   Generate_Baseline;
   Generate_Hills_Model;
   Generate_Deep_Ocean_Model;
   Generate_Biomes;

   Init;

   Main_Windows.Gtk_New (Win);

   Canvas.Gtk_New (Main_Canvas);

   Init_Dijsktra (Dijkstra_Map);

   Initial_Setup (Main_Canvas);

   Realize (Main_Canvas);

   Add (Win, Main_Canvas);

   Show_All (Win);

   Main;

end Path_Solver;
