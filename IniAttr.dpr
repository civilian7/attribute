program IniAttr;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {Form5},
  FBC.Database in 'FBC.Database.pas',
  FBC.IniAttr in 'FBC.IniAttr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
