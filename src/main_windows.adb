with Gtk.Enums;    use Gtk.Enums;
with Gtk.Handlers; use Gtk.Handlers;
with Gtk.Widget;   use Gtk.Widget;
with Gtk.Main;     use Gtk.Main;

package body Main_Windows is

   package Window_Cb is new Callback (Gtk_Widget_Record);

   procedure Exit_Main (Object : access Gtk_Widget_Record'Class) is
   begin
      Destroy (Object);
      Main_Quit;

   end Exit_Main;

   procedure Initialize (Win : access Main_Window_Record'Class) is
   begin

      Gtk.Window.Initialize (Win, Window_Toplevel);
      Set_Default_Size (Win, 800, 600);

      Window_Cb.Connect
        (Win, "destroy", Window_Cb.To_Marshaller (Exit_Main'Access));

   end Initialize;

   procedure Gtk_New (Win : out Main_Window) is
   begin

      Win := new Main_Window_Record;
      Initialize (Win);

   end Gtk_New;

end Main_Windows;
