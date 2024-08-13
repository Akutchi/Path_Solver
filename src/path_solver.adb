with Gtk.Enums; use Gtk.Enums;

with Gtk.Main;

with Main_Windows;

procedure Path_Solver is

   Win : Main_Windows.Main_Window;

begin

   Gtk.Main.Init;

   Main_Windows.Gtk_New (Win);
   Win.Set_Position (Win_Pos_Center);
   Main_Windows.Show_All (Win);

   Gtk.Main.Main;

end Path_Solver;
