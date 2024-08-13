with Gtk.Enums; use Gtk.Enums;
with Gtk.Main;  use Gtk.Main;

with Main_Windows; use Main_Windows;
with Canvas;       use Canvas;

procedure Path_Solver is

   Win         : Main_Windows.Main_Window;
   Main_Canvas : Image_Canvas;

begin

   Init;

   Main_Windows.Gtk_New (Win);
   Win.Set_Position (Win_Pos_Center);
   Win.Set_Resizable (False);

   Canvas.Gtk_New (Main_Canvas);
   Realize (Main_Canvas);
   Initial_Setup (Main_Canvas);

   Add (Win, Main_Canvas);
   Show_All (Win);

   Main;

end Path_Solver;
