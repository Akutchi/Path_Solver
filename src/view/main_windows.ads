with Gtk.Frame;  use Gtk.Frame;
with Gtk.Window; use Gtk.Window;

with Canvas; use Canvas;

package Main_Windows is

   type Main_Window_Record is new Gtk_Window_Record with record

      Main_Frame : Gtk_Frame;
      Canvas     : Image_Canvas;

   end record;

   type Main_Window is access all Main_Window_Record'Class;

   procedure Initialize (Win : access Main_Window_Record'Class);

   procedure Gtk_New (Win : out Main_Window);

end Main_Windows;
