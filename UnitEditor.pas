unit UnitEditor;

interface

uses
  LCLIntf, LCLType, LMessages, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, UnitTypes, ExtCtrls, Menus;

type

  { TFormEditor }

  TFormEditor = class(TForm)
    GridOZU: TStringGrid;
    Label1: TLabel;
    Label3: TLabel;
    GB: TGroupBox;
    CBcmd: TComboBox;
    Label2: TLabel;
    LabelHint: TLabel;
    ButtonSC: TButton;
    PanelADDSUB: TPanel;
    EditA: TLabeledEdit;
    EditB: TLabeledEdit;
    EditR: TLabeledEdit;
    PanelJ: TPanel;
    EditJ: TLabeledEdit;
    PanelMOV: TPanel;
    EditM: TLabeledEdit;
    EditC: TLabeledEdit;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Panel_Incr_Decr: TPanel;
    EditID: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure GridOZUSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure CBcmdChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonSCClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
    procedure ShowOZU();
    procedure ECell(r:Integer);
    procedure cmdChange(const id:Integer);
    function Eval(E:TLabeledEdit):Integer;
  public
    { Public declarations }
    tmpOZU:TOzu;

    procedure bedit(const e:Boolean=true);

  end;

  //TozuFile = file of Tozu;

var
  FormEditor: TFormEditor;

  hints:TStringList;
  ozuAdr : Integer;
  edit:Boolean;
implementation

{$R *.lfm}

procedure TFormEditor.bedit(const e:Boolean=true);
begin
  edit:=e;
end;

// The code for the ScrollBarVisible function is below:

function ScrollBarVisible(Handle : HWnd; Style : Longint) : Boolean;
begin
   Result := (GetWindowLong(Handle, GWL_STYLE) and Style) <> 0;
end;

procedure TFormEditor.FormDestroy(Sender: TObject);
begin
hints.Free;
end;


procedure TFormEditor.FormShow(Sender: TObject);
var
  i:Integer;
begin
//
if not(edit) then
  for i:=0 to ozuSize-1 do
  begin
  tmpOZU.commands[i]:=cmdNop();
  end
else
 tmpOzu:=ozu;

ShowOZU();
GridOZU.Row:=0;
ECell(0);
end;



procedure TFormEditor.ECell(r:Integer);
begin
//
GB.Caption:='ОЗУ[ '+GridOZU.Cells[0,r]+' ]';
ozuAdr:=StrToInt('$0'+trim(GridOZU.Cells[0,r]));

CBcmd.ItemIndex:=Cbcmd.Items.IndexOf(tmpOZU.commands[ozuAdr].NameOP);
cmdChange(CBcmd.ItemIndex);

//ButtonSC.Enabled:=false;

end;

procedure TFormEditor.GridOZUSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
//

ECell(ARow);

end;

procedure TFormEditor.ShowOZU();
var
  i:Word;
  ScrollBarWidth:Integer;
begin
if ScrollBarVisible(GridOZU.Handle, WS_VSCROLL) then
      ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL)
   else
      ScrollBarWidth := 0;

With (GridOZU) do
  begin
  ColWidths[0]:=40;
  ColWidths[1]:=GridOZU.Width-ColWidths[0]-10-ScrollBarWidth;


  for i:= 0 to 31 do
    begin
    Cells[0,i]:=c16(i,4);
    Cells[1,i]:=cmd2str(tmpOZU.commands[i]);

    //Add(c16(i,4)+' '+cmd2str(ozu.commands[i]));
    end;
  end;


end;

procedure TFormEditor.cmdChange(const id:Integer);
begin

LabelHint.Caption:=hints[id];
PanelADDSUB.Visible:=(id=2)or(id=3)or(id=10)or(id=11);
Panel_Incr_Decr.Visible:=(id=7)or(id=8);//new
if(PanelADDSUB.Visible)then
  begin
  if tmpOZU.commands[ozuAdr].TypeOP=exec then   //new
    begin

    EditA.Text:=c16(tmpOZU.commands[ozuAdr].R_RA);
    EditB.Text:=c16(tmpOZU.commands[ozuAdr].R_RB);
    EditR.Text:=c16(tmpOZU.commands[ozuAdr].R_WB);

    end
  else
    begin
    EditA.Text:=c16(0);
    EditB.Text:=c16(0);
    EditR.Text:=c16(0);
    end;
  end;


  PanelMOV.Visible:=(id=1);
  if(PanelMOV.Visible)then
    begin
    if(tmpOZU.commands[ozuAdr].TypeOP=load) then
      begin

      EditM.Text:=c16(tmpOZU.commands[ozuAdr].R_WB);
      EditC.Text:=c16(tmpOZU.commands[ozuAdr].R_CONST,4);

      end
    else
      begin
      EditM.Text:=c16(0);
      EditC.Text:=c16(0,4);
      end;
    end;


  PanelJ.Visible:=(id=4)or(id=5)or(id=6)or(id=9);
  if(PanelJ.Visible)then
    if(tmpOZU.commands[ozuAdr].TypeOP=jump) then
      EditJ.Text:=c16(tmpOZU.commands[ozuAdr].R_CONST,4)
    else EditJ.Text:=c16(0,4);

  if (Panel_Incr_Decr.Visible) then EditID.Text:=c16(0,2);
end;

function TFormEditor.Eval(E:TLabeledEdit):Integer;
begin
try
  Result:=StrToInt('$0'+trim(E.Text));
except
  Result:=-1;
end;

end;

procedure TFormEditor.Button1Click(Sender: TObject);
begin

ozu:=tmpOZU;
ModalResult:=555;

end;

procedure TFormEditor.Button2Click(Sender: TObject);
begin

if (mrYes = Application.MessageBox('Сбросить все произведённые изменения?','Отмена изменений',MB_YESNO or MB_ICONQUESTION)) then
  begin

  Close;

  end;

end;

procedure TFormEditor.ButtonSCClick(Sender: TObject);
var
  A,B,R,J,M,C:Integer;
begin
  if(CBcmd.ItemIndex=7)or(CBcmd.ItemIndex=8) then //INCR DECR
  begin              //new
    A:=Eval(EditID);
    if(A<0) or (A>$001F) then
    begin
      Application.MessageBox(PChar('Введите адрес ячейки.'+#10#13+'Реальный диапазон адресов: 0000..'+c16(ozuSize,4)+#10#13+'Искусственное ограничение для наглядности: 0000..001F'),'Ошибка',MB_OK or MB_ICONWARNING);
      Exit;
    end;
    if(CBcmd.ItemIndex=7) then tmpOZU.commands[ozuAdr]:=cmdIncr(A);
    if(CBcmd.ItemIndex=8) then tmpOZU.commands[ozuAdr]:=cmdDecr(A);
    ShowOZU();
  end;

  if(CBcmd.ItemIndex=3)or(CBcmd.ItemIndex=2)or(CBcmd.ItemIndex=10)or(CBcmd.ItemIndex=11) then   //  ADD SUB OR AND
    begin
    A:=Eval(EditA);
    B:=Eval(EditB);
    R:=Eval(EditR);

    if(A<0) or (B<0) or (R<0) or (R>ronSize-1) or (A>ronSize-1) or (B>ronSize-1) then
      begin
      Application.MessageBox(PChar('Введите адреса операндов и результата в регистровой памяти (РОН)!'+#10#13+'Диапазон адресов: 00..'+c16(ronSize)),'Ошибка',MB_OK or MB_ICONWARNING);
      Exit;
      end;

    if(CBcmd.ItemIndex=3) then tmpOZU.commands[ozuAdr]:=cmdSUB(A,B,R);
    if(CBcmd.ItemIndex=2) then tmpOZU.commands[ozuAdr]:=cmdADD(A,B,R);
    if(CBcmd.ItemIndex=10) then tmpOZU.commands[ozuAdr]:=cmdOR(A,B,R);
    if(CBcmd.ItemIndex=11) then tmpOZU.commands[ozuAdr]:=cmdAND(A,B,R);        
    ShowOZU();
    end;

  if(CBcmd.ItemIndex=1) then    //  MOV
    begin
    M:=Eval(EditM);
    C:=Eval(EditC);

    if(M<0) or (C<0) or (M>ronSize-1) or (C>$FFFF) then
      begin
      Application.MessageBox(PChar('Введите адреса по которому будет загружена константа в регистровую память (РОН) и саму константу!'+#10#13+'Диапазон адресов РОН: 00..'+c16(ronSize)),'Ошибка',MB_OK or MB_ICONWARNING);
      Exit;
      end;

    tmpOZU.commands[ozuAdr]:=cmdMov(C,M);
    ShowOZU();
    end;

  if(CBcmd.ItemIndex=4)or(CBcmd.ItemIndex=5)or(CBcmd.ItemIndex=6)or(CBcmd.ItemIndex=9) then  //  JMP JZ JP
    begin
    J:=Eval(EditJ);

    if(J<0) or (J>$001F) then
      begin
      Application.MessageBox(PChar('Введите адреса перехода.'+#10#13+'Реальный диапазон адресов: 0000..'+c16(ozuSize,4)+#10#13+'Искусственное ограничение для наглядности: 0000..001F'),'Ошибка',MB_OK or MB_ICONWARNING);
      Exit;
      end;

    if(CBcmd.ItemIndex=4) then tmpOZU.commands[ozuAdr]:=cmdJMP(J);
    if(CBcmd.ItemIndex=5) then tmpOZU.commands[ozuAdr]:=cmdJZ(J);
    if(CBcmd.ItemIndex=6) then tmpOZU.commands[ozuAdr]:=cmdJC(J);
    if(CBcmd.ItemIndex=9) then tmpOZU.commands[ozuAdr]:=cmdJP(J);    
    ShowOZU();
    end;

  if(CBcmd.ItemIndex=0) then
    begin
    tmpOZU.commands[ozuAdr]:=cmdNOP();
    ShowOZU();
    end;


  tmpOZU.commands[ozuAdr].Adress:=ozuAdr;
end;

procedure TFormEditor.CBcmdChange(Sender: TObject);
begin
cmdChange(CBcmd.ItemIndex);
end;

procedure TFormEditor.FormCreate(Sender: TObject);
var
  i:Integer;
begin
hints:=TStringList.Create;
hints.Clear;
{
0 NOP
1 MOV
2 ADD
3 SUB
4 JMP
5 JZ
6 JC
7 INCR
8 DECR
9 JP
10 OR
11 AND
}


hints.Add('NOP - Нет команды. Никаких действий не выполняется.'+#10#13+#10#13+'Выберите команду, которую необходимо поместить в ячейку оперативной памяти.');
hints.Add('MOV adr, #CONST - Загрузить константу в регистровую память (РОН) по адресу ADR.');
hints.Add('ADD adr R, adr A, adr B - Выполнить сложение операндов, находящихся в регистровой памяти (РОН) по адресам adr A и adr B. Результат сложения записать в РОН по адресу adr R.');
hints.Add('SUB adr R, adr A, adr B - Выполнить вычитание операндов, находящихся в регистровой памяти (РОН) по адресам adr A и adr B. Из B вычитается А. Результат вычитания записать в РОН по адресу adr R.');
hints.Add('JMP adr - Команда безусловного перехода по адресу adr в оперативной памяти.');
hints.Add('JZ adr - Команда условного перехода по адресу adr в оперативной памяти. Переход выполняется по флагу Z, если результатом предшествовавшей арифметической операции на АЛУ был нулевым.');
hints.Add('JC adr - Команда условного перехода по адресу adr в оперативной памяти. Переход выполняется по флагу C, если результат предшествовавшей арифметической операции на АЛУ был с заёмом или с переполнением.');
hints.Add('INCR adr - Команда инкремента данных по адресу adr в оперативной памяти.');
hints.Add('DECR adr - Команда декремента данных по адресу adr в оперативной памяти.');
hints.Add('JP adr - Команда условного перехода по адресу adr в оперативной памяти. Переход выполняется по флагу P, если результат предшествовавшей арифметической операции на АЛУ был чётным.');
hints.Add('OR adr R, adr A, adr B - Выполнить побитовую конъюнкцию операндов, находящихся в регистровой памяти (РОН) по адресам adr A и adr B. Результат записать в РОН по адресу adr R.');
hints.Add('AND adr R, adr A, adr B - Выполнить побитовую дизъюнкцию операндов, находящихся в регистровой памяти (РОН) по адресам adr A и adr B. Результат записать в РОН по адресу adr R.');
Label3.Caption:='[0..'+c16(ozuSize-1,4)+']';

for i:=0 to ozuSize-1 do
  begin
  tmpOZU.commands[i]:=cmdNop();
  end;

ShowOZU();
end;

end.
