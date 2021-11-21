program ProjectMPSAlpha;

{$mode objfpc}{$H+}
{$codepage UTF8}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitTypes in 'UnitTypes.pas',
  Unit1 in 'Unit1.pas' {FormM},
  UnitEditor in 'UnitEditor.pas' {FormEditor};
  {$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormM, FormM);
  Application.CreateForm(TFormEditor, FormEditor);
  Application.Run;
end.

