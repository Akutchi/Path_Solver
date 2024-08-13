with Glib;          use Glib;
with Cairo;         use Cairo;
with Gtkada.Canvas; use Gtkada.Canvas;
with Gdk.RGBA;      use Gdk.RGBA;

package Canvas is

   type Image_Canvas_Record is new Interactive_Canvas_Record with record

      Backgroud : Cairo_Pattern := Null_Pattern;
      Draw_Grid : Boolean       := False;

   end record;

   type Image_Canvas is access all Image_Canvas_Record'Class;

   procedure Gtk_New (Canvas : out Image_Canvas);

   type Display_Item_Record is new Canvas_Item_Record with record

      Canvas : Interactive_Canvas;
      Color  : Gdk_RGBA;
      x, y   : Gdouble;
      W, H   : Gint;

   end record;

   type Display_Item is access all Display_Item_Record'Class;

   overriding procedure Draw
     (Item : access Display_Item_Record; Cr : Cairo_Context);

   procedure Initial_Setup (Canvas : access Interactive_Canvas_Record'Class);

end Canvas;
