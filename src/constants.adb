package body Constants is

   function Case_Number return Integer is

      Can_Config : Canvas_Configuration;

      Width_Nb  : Gint;
      Height_Nb : Gint;
   begin

      Width_Nb  := Can_Config.Width / Can_Config.Case_Width;
      Height_Nb := Can_Config.Height / Can_Config.Case_Height;

      return Integer (Width_Nb * Height_Nb);

   end Case_Number;

end Constants;
