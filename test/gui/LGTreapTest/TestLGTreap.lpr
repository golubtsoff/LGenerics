program TestLGTreap;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, LGTreapTest;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

