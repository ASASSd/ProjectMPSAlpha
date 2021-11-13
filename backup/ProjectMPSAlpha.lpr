program ProjectMPSAlpha;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitTypes in 'UnitTypes.pas',
  Unit1 in 'Unit1.pas' {FormM},
  UnitEditor in 'UnitEditor.pas' {FormEditor};

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
// Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormM, FormM);
  Application.CreateForm(TFormEditor, FormEditor);
  Application.Run;
end.
