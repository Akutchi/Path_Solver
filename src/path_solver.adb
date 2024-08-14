with Gtk.Main; use Gtk.Main;

with Main_Windows; use Main_Windows;
with Canvas;       use Canvas;
with Constants;    use Constants;

procedure Path_Solver is

   Win         : Main_Windows.Main_Window;
   Main_Canvas : Image_Canvas;

begin

   Init;

   Main_Windows.Gtk_New (Win);

   Canvas.Gtk_New (Main_Canvas);
   Initial_Setup (Main_Canvas);
   Realize (Main_Canvas);

   Add (Win, Main_Canvas);

   Update (Main_Canvas, Moutain, 2, 2);
   Show_All (Win);

   Main;

end Path_Solver;
