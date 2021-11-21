unit UnitMain;

interface

uses
  LCLIntf, LCLType, LMessages, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls,

  // MY!
  UnitTypes, StdCtrls,
  StrUtils,
  Unit1, ComCtrls
  ;

type
  TFormMain = class(TForm)
    Timer1: TTimer;
    ProgressBar1: TProgressBar;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }



  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
implementation


{$R *.lfm}


procedure TFormMain.FormCreate(Sender: TObject);
begin
ProgressBar1.Position:=0;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
if(Timer2.Enabled=false) then
  begin
  if(FormM.Visible=false) then
    FormMain.Close();


  end;
//Timer1.Enabled:=false;
end;

procedure TFormMain.Timer2Timer(Sender: TObject);
begin
Timer2.Enabled:=false;
if(ProgressBar1.Position=ProgressBar1.Max) then
  begin
  Timer2.Enabled:=false;
  //FormMain.Hide;

  FormM.ShowModal;

  FormMain.Show;
  FormMain.Close();
  Exit;
  end
else
  begin
  ProgressBar1.Position:=ProgressBar1.Position+1;
  Application.ProcessMessages;
  Timer2.Enabled:=true;
  end;
end;

end.
