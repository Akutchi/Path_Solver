with Gtk.Enums;    use Gtk.Enums;
with Gtk.Handlers; use Gtk.Handlers;
with Gtk.Widget;   use Gtk.Widget;
with Gtk.Main;     use Gtk.Main;

with Constants; use Constants;

package body Main_Windows is

   package Window_Cb is new Callback (Gtk_Widget_Record);

   ---------------
   -- Exit_Main --
   ---------------

   procedure Exit_Main (Object : access Gtk_Widget_Record'Class) is
   begin
      Destroy (Object);
      Main_Quit;

   end Exit_Main;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Win : access Main_Window_Record'Class) is

      Win_Config : Window_Configuration;

   begin

      Gtk.Window.Initialize (Win, Window_Toplevel);
      Set_Default_Size (Win, Win_Config.Width, Win_Config.Height);
      Set_Position (Win, Win_Pos_Center);
      Set_Resizable (Win, False);

      Window_Cb.Connect
        (Win, "destroy", Window_Cb.To_Marshaller (Exit_Main'Access));

   end Initialize;

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Win : out Main_Window) is
   begin

      Win := new Main_Window_Record;
      Main_Windows.Initialize (Win);

   end Gtk_New;

end Main_Windows;
