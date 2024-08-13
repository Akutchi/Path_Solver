with Gtk.Window;
with Gtk.Enums;

package body Main_Windows is

   procedure Initialize (Win : access Main_Window_Record'Class) is

   begin

      Gtk.Window.Initialize (Win, Gtk.Enums.Window_Toplevel);
      Set_Default_Size (Win, 800, 600);

   end Initialize;

   procedure Gtk_New (Win : out Main_Window) is
   begin

      Win := new Main_Window_Record;
      Initialize (Win);

   end Gtk_New;

end Main_Windows;
