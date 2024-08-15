unit uMain;

interface

uses
  System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.GraphUtil,

  FBC.IniAttr;

type
  [IniSection('USER')]
  TSettings = class(TIniObject)
  private
    FLastLogin: TDate;
    FSaveID: Boolean;
    FUserID: string;
    FUserLevel: Integer;
  public
    [IniDate('2024-07-04')]
    property LastLogin: TDate read FLastLogin write FLastLogin;
    [IniBool(False)]
    property SaveID: Boolean read FSaveID write FSaveID;
    [IniString('admin')]
    property UserID: string read FUserID write FUserID;
    [IniInt(20)]
    property UserLevel: Integer read FUserLevel write FUserLevel;
  end;

  TForm5 = class(TForm)
  private
    FSettings: TSettings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

{ TForm5 }

constructor TForm5.Create(AOwner: TComponent);
begin
  inherited;

  FSettings := TSettings.Create;
  FSettings.LoadFromFile(ChangeFileExt(Application.ExeName, '.ini'));

  // 값을 바꾸어본다
//  FSettings.LastLogin := Now();
//  FSettings.SaveID := True;
//  FSettings.UserID := 'test';
//  FSettings.UserLevel := 10;
end;

destructor TForm5.Destroy;
begin
  FSettings.SaveToFile(ChangeFileExt(Application.ExeName, '.ini'));
  FSettings.Free;

  inherited;
end;

end.
