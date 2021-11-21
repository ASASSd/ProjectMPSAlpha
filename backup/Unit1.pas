unit Unit1;

interface

uses
  LCLIntf, LCLType, LMessages, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ExtCtrls, StrUtils, StdCtrls,
  UnitTypes, Grids, Menus;

type

  { TFormM }

  TFormM = class(TForm)
  CF_R: TCheckBox;
    Image1: TImage;
    lines_alu: TImage;
    lines_data_1: TImage;
    lines_data_2: TImage;
    lines_ron_a1: TImage;
    lines_ron_a2: TImage;
    lines_rk: TImage;
    lines_dc: TImage;
    lines_pointer: TImage;
    lines_cacheup: TImage;
    lines_cachedown: TImage;
    lines_wb3: TImage;
    lines_wb5: TImage;
    lines_w3: TImage;
    lines_ron_w1: TImage;
    lines_ron_w2: TImage;
    lines_buf_alu: TImage;
    PanelPipe1: TPanel;
    PanelPipe2: TPanel;
    PanelPipe3: TPanel;
    PanelPipe4: TPanel;
    PanelPipe5: TPanel;
    PanelCodeOP: TPanel;
    PanelR1: TPanel;
    PanelR2: TPanel;
    PanelR3: TPanel;
    PanelPcom: TPanel;
    PanelDC: TPanel;
    PanelRONAA: TPanel;
    PanelRONAB: TPanel;
    PanelRONAWB: TPanel;
    PanelRONWA: TPanel;
    PanelRONWB: TPanel;
    PanelRONWWB: TPanel;
    PanelAWBS3: TPanel;
    PanelWWBS3: TPanel;
    PanelAWBS5: TPanel;
    PanelWWBS5: TPanel;
    PanelRESin: TPanel;
    PanelRESout: TPanel;
    PanelBUF1OUT: TPanel;
    PanelBUF1IN: TPanel;
    PanelBUF2OUT: TPanel;
    PanelBUF2IN: TPanel;
    PF_R: TCheckBox;
    q_alu: TImage;
    q_ron1: TImage;
    q_ron2: TImage;
    q_ron3: TImage;
    q_rk: TImage;
    q_cacheIN: TImage;
    q_ozu: TImage;
    q_dc: TImage;
    q_bufin: TImage;
    q_bufout: TImage;
    q_resin: TImage;
    q_resout: TImage;
    q_pointer: TImage;
    ButtonAction: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PanelJMP4A: TPanel;
    PanelJMP4NO: TPanel;
    lines_jmp4: TImage;
    PanelCacheOUT: TPanel;
    PanelCacheIN: TPanel;
    q_cacheOUT: TImage;
    Label5: TLabel;
    Label6: TLabel;
    GridOZU: TStringGrid;
    GridRON: TStringGrid;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N11: TMenuItem;
    N21: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GridCache: TStringGrid;
    N6: TMenuItem;
    Label7: TLabel;
    N4: TMenuItem;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    N31: TMenuItem;
    N41: TMenuItem;
    ALU_CMD: TLabel;
    Label11: TLabel;
    ZF_R: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonActionClick(Sender: TObject);
    procedure ButtonInitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure menu1();
    procedure menu2();
    procedure menu3();
    procedure menu4();
    procedure menu5();
    procedure GridOZUDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure GridRONDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure N3Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure GridCacheDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure N4Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N41Click(Sender: TObject);
private
  { Private declarations }
  procedure ResetView();
  procedure st1(const xcolor:Tcolor);
  procedure st2(const xcolor:Tcolor);
  procedure st3(const xcolor:Tcolor;const op:TTypeOP;const back:Byte=0);
  procedure st4(const xcolor:TColor;const op:TTypeOP;const back:Byte=0);
  procedure st5(const xcolor:TColor;const op:TTypeOP);
  procedure ShowOZU();
  procedure ShowRON();
  procedure ShowCACHE();
  procedure showall();
  procedure RunStage1();
  procedure RunStage2();
  procedure RunStage3();
  procedure RunStage4();
  procedure RunStage5();
  function checkForward():Boolean;
  function checkRound():Word;
  procedure Init();
  function strColor(const color0:TColor):String;
  procedure setImg(img:TImage;const path:String);
  procedure Action();
  public
    { Public declarations }
  end;


var
  FormM: TFormM;
  list4:TStringList;
  imgpath:String;


implementation

uses UnitEditor;



{$R *.lfm}

// The code for the ScrollBarVisible function is below:

function ScrollBarVisible(Handle : HWnd; Style : Longint) : Boolean;
begin
   Result := (GetWindowLong(Handle, GWL_STYLE) and Style) <> 0;
end;

function BolToStr(b:boolean):String; //Debug
begin
  Result:='False';
  if b then Result:='True';
end;

procedure TFormM.ShowOZU();
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
    ColWidths[0]:=36;
    ColWidths[1]:=GridOZU.Width-ColWidths[0]-10-ScrollBarWidth;
  for i:= 0 to 31 do
    begin
    Cells[0,i]:=c16(i,4);
    Cells[1,i]:=cmd2str(ozu.commands[i]);
    end;
  end;
  ShowCACHE();
  Exit;
end;

procedure TFormM.ShowRON();
var
  i:Word;
  ScrollBarWidth:Integer;
begin
  if ScrollBarVisible(GridRON.Handle, WS_VSCROLL) then
        ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL)
     else
        ScrollBarWidth := 0;
  With (GridRON) do
  begin
    RowCount:=ronSize;
    ColWidths[0]:=30;
    ColWidths[1]:=Width-ColWidths[0]-10-ScrollBarWidth;
    for i:=0 to RowCount-1 do
      begin
      Cells[0,i]:=c16(i,2);
      Cells[1,i]:=c16(ron.data[i],4);
      end;
  end;
  GridRON.Repaint;
  Exit;
end;

procedure TFormM.ShowCACHE();
var
  j:Integer;
  ScrollBarWidth:Integer;
begin
  if ScrollBarVisible(GridOZU.Handle, WS_VSCROLL) then
        ScrollBarWidth := GetSystemMetrics(SM_CXVSCROLL)
     else
        ScrollBarWidth := 0;
  GridCache.RowCount:=1;
  GridCache.Cells[0,0]:='';
  GridCache.Cells[1,0]:='';
  GridCache.ColWidths[0]:=40;
  GridCache.ColWidths[1]:=GridCache.Width-GridCache.ColWidths[0]-10-ScrollBarWidth;
  With (GridCache) do
    begin
    for j:=0 to 31 do
      begin
      RowCount:=j+1;
      if(Cache[j].charged) then
        begin
        if(Cache[j].prediction) then
          begin
          GridCache.Cells[0,j]:=(c16(Cache[j].Afrom,4));
          GridCache.Cells[1,j]:='JUMP TO '+' '+c16(Cache[j].Ajump,4);
          end
        else
          begin
          GridCache.Cells[0,j]:=(c16(Cache[j].Afrom,4));
          GridCache.Cells[1,j]:='NO JUMP '+' '+c16(Cache[j].Ajump,4);
          end;
      end
    else
      begin
        RowCount:=j;
        Break;
      end;
    end;
  end;
end;


procedure TFormM.Action();
begin
  if(not skip) and (not dropPipe) then Pcom:=nextOzuPointer(Pcom);
  dropPipe:=false;
  skip:=false;

  cmdpipe[5]:=cmdpipe[4];
  cmdpipe[4]:=cmdpipe[3];
  cmdpipe[3]:=cmdNop();

  if checkForward() then
  begin
    cmdpipe[3]:=cmdpipe[2];
    cmdpipe[2]:=cmdNop();
    cmdpipe[2]:=cmdpipe[1];
    cmdpipe[1]:=ozu.commands[Pcom];
    if(cmdpipe[1].TypeOP<>nop) then cmdpipe[1].color:=nextColor();
  end else skip:=true;
  RunStage5();
  RunStage4();
  RunStage3();
  RunStage2();
  RunStage1();
  ShowRON();
end;



function TFormM.checkForward():Boolean;
var
  tc:TCommand;
  i:Word;
begin
  tc:=cmdpipe[2];//2
  Result:=true;
  if(tc.TypeOP<>exec) then Exit;  //WB - куда запишем
  for i:=4 to 5 do
  begin
    // Если загрузка операнда, который потребуется, еще не прошла - false.
    if(cmdpipe[i].TypeOP=load) and ((cmdpipe[i].R_WB=tc.R_RA)or(cmdpipe[i].R_WB=tc.R_RB)) then
    begin
      Result:=false;
      Exit;
    end;
  end;
// через одну команду не берем, а в 4ой можно подобрать обходной
  if(cmdpipe[5].TypeOP=exec) and ((cmdpipe[5].R_WB=tc.R_RA)or(cmdpipe[5].R_WB=tc.R_RB)) then
  begin
    Result:=false;
    Exit;
  end;
end;

procedure TFormM.RunStage5(); // 5я ступень ( WRITE )
begin
  With cmdpipe[5] do
  begin
    RResult.output:=RResult.input;
    if ( TypeOP=load ) then
    begin
      ron.A3:=R_WB;
      ron.W3:=R_CONST;
      ron.data[ron.A3]:=ron.W3;
      end;
    if ( TypeOP=exec ) then
    begin
      ron.A3:=R_WB;
      ron.W3:=RResult.output;
      ron.data[ron.A3]:=ron.W3;
    end;   
  end;
end;

procedure TFormM.RunStage4(); // Четвертая ступень ( EXECUTE )
var
  testC,testZ,testP:Bool;
  checkWhat:Word;
begin
  With cmdpipe[4] do
  begin
    BUF1.output:=Buf1.input;
    BUF2.output:=Buf2.input;
    if TypeOP=jump then
    begin
      if(NameOP='JZ') then dropPipe := ZF xor jumpPrediction(Adress);
      if(NameOP='JC') then dropPipe := CF xor jumpPrediction(Adress);
      if(NameOP='JP') then dropPipe := PF xor jumpPrediction(Adress);
      if(dropPipe) then // Когда вызывается пик
      begin
        if(jumpPrediction(Adress)) then Pcom:=Adress+1 //Adress - откуда
        else
        begin
          Pcom:=R_CONST; //R_CONST - Куда
          ZF:=false;
          CF:=false; //Чтобы не переходил по единожды установленному флагу
          PF:=false;
        end;
        changePrediction(Adress);
        cmdpipe[1]:=cmdNOP;
        cmdpipe[2]:=cmdNOP;
        cmdpipe[3]:=cmdNOP;
      end;
    end else //if not(cmdpipe[3].TypeOP=Nop) then
    begin
      ZF:=false;CF:=false;PF:=false;
    end;
    if TypeOP=exec then
    begin
      if(NameOP='OR') then RResult.input := BUF1.output or Buf2.output;
      if(NameOP='AND') then RResult.input := BUF1.output and Buf2.output;

      if(NameOP='INCR') then
      begin
        RResult.input := BUF1.output + 1;
        if RResult.input < BUF1.output then CF := True;
      end;

      if(NameOP='DECR') then
      begin
        if BUF1.output = 0 then CF := True;
        RResult.input := BUF1.output - 1;
      end;

      if(NameOP='ADD') then
      begin
           RResult.input := BUF1.output + Buf2.output;
           if (RResult.input < BUF2.output) or (RResult.input < BUF1.output) then CF := True;
      end;

      if(NameOP='SUB') then
      begin
        if BUF1.output > BUF2.output then CF := True;
        RResult.input := BUF2.output - Buf1.output;
      end;

      if RResult.input = 0 then ZF := True
      else if RResult.input mod 2=0 then PF := True;

      testC := CF;
      testZ := ZF;  // Можно вырезать, было нужно для проверки флагов
      testP := PF;

      lastResult:=RResult.input;
    end;   
  end;
end;


procedure TFormM.RunStage3(); // Третья ступень ( READ )
begin
  With cmdpipe[3] do
  begin
    RoundAEnabled:=(checkRound()=1) and ( TypeOP=exec );
    RoundBEnabled:=(checkRound()=2) and ( TypeOP=exec );
    if ( TypeOP=exec ) then
    begin
      ron.A1:=R_RA;
      ron.A2:=R_RB;
      if(NameOP='INCR')or(NameOP='DECR') then ron.A2:=0;
      if not(NameOP='INCR')or(NameOP='DECR') then
      begin
        if(checkRound()<>1) then
        begin
          ron.A1:=R_RA;
          ron.W1:=ron.data[ron.A1];
          Buf1.input:=ron.W1;
        end else Buf1.input:=RResult.input;
        if(checkRound()<>2) then
        begin
          ron.A2:=R_RB;
          ron.W2:=ron.data[ron.A2];
          Buf2.input:=ron.W2;
        end else Buf2.input:=RResult.input;
      end else
      begin
          ron.A1:=R_RA;
          ron.W1:=ron.data[ron.A1];
          if (RoundAEnabled) then Buf1.input:=RResult.input else Buf1.input:=ron.W1;
      end;
    end; 
  end;
end;

function TFormM.checkRound():Word;
begin
  Result:=0; // 1 и 2 - соответствующие буферные регистры
  if(cmdpipe[4].R_WB=cmdpipe[3].R_RA)and(cmdpipe[4].TypeOP<>nop) then Result:=1; //and(cmdpipe[4].R_WB<>0)
  if(cmdpipe[4].R_WB=cmdpipe[3].R_RB)and(cmdpipe[4].TypeOP<>nop) then Result:=2; //and(cmdpipe[4].R_WB<>0)
end;

procedure TFormM.RunStage2(); // Вторая ступень (DECODE INSTRUCTION)
begin
end;

procedure TFormM.RunStage1(); // Первая ступень (INSTRUCTION FETCH)
begin
  With cmdpipe[1] do
    begin
    Rcom.CodeOP:=CodeOP;
    if (TypeOP=exec) or (TypeOP=nop) then
    begin
      Rcom.R1:=R_RA;
      Rcom.R2:=R_RB;
      if(NameOP='INCR')or(NameOP='DECR') then Rcom.R2:= 0;
    end
    else if(TypeOP=load) or (TypeOP=jump) Then
    begin
      Rcom.R1:=StrToInt('$0'+LeftStr(c16(R_CONST,4),2));
      Rcom.R2:=StrToInt('$0'+RightStr(c16(R_CONST,4),2));
    end
    else if(TypeOP=jump) then
    begin
    end;
    Rcom.R3:=R_WB;
  end;
end;

procedure TFormM.menu1();
begin
  Init();
  ozuAdd(cmdMov(17,03),0);        // с нуля стартуем
  ozuAdd(cmdMov(34,07));
  ozuAdd(cmdAdd(03,07,08));
  ozuAdd(cmdSub(03,07,09));
  ozuAdd(cmdSub(09,03,1032));
  ozuAdd(cmdJMP(7));
  ozuAdd(cmdMov(1,07));
  ozuAdd(cmdMov($FFFF,07));
  loadCache();
  ShowOzu();
end;

procedure TFormM.menu2();
begin
  Init();
  ozuAdd(cmdMov($000C,03),0);        // с нуля стартуем
  ozuAdd(cmdMov($0002,04));
  ozuAdd(cmdMov($0000,07));
  ozuAdd(cmdSub(04,03,03)); // R[03] = R[03]-R[04]
  ozuAdd(cmdSub(04,03,03)); // R[03] = R[03]-R[04]
  ozuAdd(cmdJC($000A)); // если НОЛЬ, то показать АААА
  ozuAdd(cmdMov($FFFF,07)); // Показать FFFF
  ozuAdd(cmdJMP($0002)); // если не ноль
  ozuAdd(cmdMov($AAAA,07),$000A);
  ozuAdd(cmdJMP($0000)); //
  loadCache();
  ShowOzu();
end;

procedure TFormM.menu3();
begin
  FormEditor.bedit(true);
  if(FormEditor.ShowModal()=555)then
    begin
    Init();
    ozu:=FormEditor.tmpOZU;
    loadCache();
    ShowOzu();
    ShowRON();
    end;
end;

procedure TFormM.menu4();
begin
  Init();
  ozuAdd(cmdMov($0004,03),0);        // с нуля стартуем
  ozuAdd(cmdMov($0002,04));
  ozuAdd(cmdMov($0000,07));
  ozuAdd(cmdSub(04,03,03)); // R[03] = R[03]-R[04]
  ozuAdd(cmdJZ($000A)); // если НОЛЬ, то показать АААА
  ozuAdd(cmdMov($FFFF,07)); // Показать FFFF
  ozuAdd(cmdJMP($0002)); // если не ноль
  ozuAdd(cmdMov($AAAA,07),$000A);
  ozuAdd(cmdJMP($0000)); //
  loadCache();
  ShowOzu();

end;

procedure TFormM.menu5();
begin
  Init();
  ozuAdd(cmdMov($0005,00),0);
  ozuAdd(cmdMov($0005,03));
  ozuAdd(cmdIncr(01));
  ozuAdd(cmdIncr(01));
  ozuAdd(cmdDecr(00));
  ozuAdd(cmdJZ($0007));
  ozuAdd(cmdJMP($0002));
  ozuAdd(cmdAnd(03,01,05));
  ozuAdd(cmdOr(03,01,04));
  ozuAdd(cmdJP($0000));
  loadCache();
  ShowOzu();
end;

procedure TFormM.ButtonActionClick(Sender: TObject);
var i:integer;
begin
  Action();
  ShowAll();
  GridOzu.Repaint;

  //-- Debug Make Label7.Visible := TRUE --
  label7.Caption:='dp '+ BolToStr(dropPipe);
  label7.Caption:=label7.Caption +
                   #13#10+ 'skp ' + BolToStr(skip)+
                   #13#10+ 'Pcom '+c16(Pcom)+
                   #13#10+ 'LR '+c16(lastResult)+#13#10;
  for i:=1 to 5 do Label7.caption:=label7.Caption+cmdPipe[i].NameOP+' ';
  label7.Caption:= label7.Caption + #13#10+'ZF '+BolToStr(ZF)+#13#10+'CF '+ BolToStr(CF);
  label7.Caption:= label7.Caption + #13#10+'RR = '+ c16(RResult.input);
  label7.Caption:= label7.Caption + #13#10+'ChRnd = '+ c16(checkRound());
  label7.Caption:= label7.Caption + #13#10+'RoundAEnabled = '+ BolToStr(RoundAEnabled);
  label7.Caption:= label7.Caption + #13#10+'RoundBEnabled = '+ BolToStr(RoundBEnabled);
  //--------------------------------
  if not(cmdpipe[4].TypeOp=exec) then
  begin
    CF:=FALSE;
    ZF:=FALSE;
    PF:=FALSE;
  end;
  if not(dropPipe) then
  begin
    CF_R.Checked := CF;
    ZF_R.Checked := ZF;
    PF_R.Checked := PF;
  end;

end;

procedure TFormM.ButtonInitClick(Sender: TObject);
begin
  Init();
end;

procedure TFormM.FormCreate(Sender: TObject);
begin
  list4:=TStringList.Create;
  List4.Add('RONWA');
  List4.Add('RONWB');
  List4.Add('RONWB');
  List4.Add('BUF1IN');
  List4.Add('BUF2IN');
  List4.Add('BUF1OUT');
  List4.Add('BUF2OUT');
  List4.Add('RESin');
  List4.Add('RESout');
  List4.Add('WWBS5');
  List4.Add('WWBS3');
  List4.Add('Pcom');
  List4.Add('PanelPcom');
  List4.Add('PanelCacheIN');
  List4.Add('PanelCacheOUT');
  imgpath:=extractfiledir(paramstr(0))+'\images\';
end;

procedure TFormM.Init();
var
  i:Word;
begin
  CF:=false;       //Сброс флагов
  ZF:=false;
  PF:=false;
  CF_R.Checked:=CF;
  ZF_R.Checked:=ZF;
  PF_R.Checked:=PF;
  RResult.input := 0; //Проблема с 0 ячейкой РОН
  for i:=1 to 5 do
    begin
    cmdpipe[i]:=cmdNop();    // Чистит конвеер
    end;
  for i:=0 to ozuSize-1 do
  begin
    ozu.commands[i]:=cmdNop();   // Чистит ОЗУ
  end;
  for i:=0 to ronSize-1 do
  begin
    ron.data[i]:=0;         // Чистит РОН
  end;
  for i:=0 to cacheSize-1 do      // Чистит кэш
    begin
    cache[i].Afrom:=0;
    cache[i].Ajump:=0;
    cache[i].prediction:=false;
    cache[i].charged:=false;
    end;
  internal.colorPointer:=0;
  Pcom:=-1; // СЧАК  = 0
  lastResult:=0;
  ShowOZU();
  ShowRON();
  ShowCACHE();
  Label3.Caption:='[0..'+c16(ozuSize-1,4)+']';
  Label4.Caption:='[0..'+c16(ronSize-1,2)+']';
  Label6.Caption:='[0..'+c16(cacheSize-1,2)+']';
  setImg(image1,'mps-lines');  //All
  ResetView;
end;

procedure TFormM.N11Click(Sender: TObject);
begin
  menu1();
end;
procedure TFormM.N21Click(Sender: TObject);
begin
  menu2();
end;
procedure TFormM.N3Click(Sender: TObject);
begin
  menu3();
end;

procedure TFormM.N4Click(Sender: TObject); //CLR
begin
  Init();
  loadCache();
  ShowOzu();
  ResetView();
  GridOzu.Repaint;
end;

procedure TFormM.FormDestroy(Sender: TObject);
begin
  List4.Free;
end;

procedure TFormM.FormShow(Sender: TObject);
begin
  Init();
end;

procedure TFormM.GridCacheDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  mrow,mcol:Integer;
begin
mrow:=Arow;
mcol:=Acol;
With (Sender as TStringGrid) do
  begin
  Canvas.Brush.Color:= clWhite;
  if(pos('TO',Cells[1,mrow])>0) then
    begin
    Canvas.font.color := clGreen;
    if(mcol=0) then Canvas.Font.Style := Canvas.Font.Style+[fsBold];
    end
  else
    begin
    Canvas.font.color := clRed;
    Canvas.Font.Style := Canvas.Font.Style-[fsBold];
    end;
    canvas.fillRect(Rect);
    canvas.TextOut(Rect.Left+2,Rect.Top+2,Cells[mCol,mRow]);
  end;
end;

procedure TFormM.GridOZUDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i:Integer;
  dr:Boolean;
  mrow,mcol:Integer;
begin
mrow:=Arow;
mcol:=Acol;
dr:=false;
  With (Sender as TStringGrid) do
  begin
    for i:=1 to 5 do
    begin
      if ( ((cmdpipe[i].TypeOP=exec) or (cmdpipe[i].TypeOP=load) or (cmdpipe[i].TypeOP=jump)) and (c16(cmdpipe[i].Adress,4)=trim(Cells[0,mRow])) ) then
      begin
        dr:=true;
        break;
      end;
    end;
    if (dr) then
    begin
      Canvas.Brush.Color := cmdpipe[i].Color;
      Canvas.font.color := clWhite;
    end
    else
    begin
      if(mRow=Row) then
      begin
        Canvas.Brush.Color := clWhite;
        Canvas.font.color := clBlack;
        Brush.Style := bsCross;
      end;
    end;
    canvas.fillRect(Rect);
    canvas.TextOut(Rect.Left+2,Rect.Top+2,Cells[mCol,mRow]);
  end;
end;

procedure TFormM.GridRONDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  i:Integer;
  dr:Boolean;
  mrow,mcol:Integer;
begin
  mrow:=Arow;
  mcol:=Acol;
  dr:=false;
  With (Sender as TStringGrid) do
  begin
    Canvas.Brush.Color := clWhite;
    Canvas.font.color := clBlack;
    if (trim(Cells[1,mRow])<>'0000') then
      Canvas.font.Style := Canvas.font.Style+[fsBold]
        else Canvas.font.Style := Canvas.font.Style-[fsBold];
    if(mRow=Row) then Brush.Style := bsCross;
    canvas.fillRect(Rect);
    canvas.TextOut(Rect.Left+2,Rect.Top+2,Cells[mCol,mRow]);
  end;
end;

function TFormM.strColor(const color0:TColor):String;
begin
  if (color0=clGreen)then Result:='green'
  else if color0=clRed then Result:='red'
  else if color0=clFuchsia then Result:='rose'
  else if color0=clGray then Result:='grey'
  else if color0=clBlue then Result:='blue'
  else Result:='not-exists-than-hide';
end;

procedure TFormM.st1(const xcolor:Tcolor);
var
  color1:String;          // Дописать для обращений в CACHE
begin
  color1:=strColor(xcolor);
  panelpipe1.Color:=xcolor;
  setImg(q_pointer,color1+'\pointer');  
  setImg(q_rk,color1+'\rk');
  setImg(q_ozu,color1+'\ozu');
  setImg(lines_pointer,'lines\'+color1+'\pointer');
  setImg(lines_rk,'lines\'+color1+'\rk');
  setImg(lines_cachedown,'lines\'+color1+'\cachedown');
  if (cmdpipe[2].TypeOP=jump) and (jumpPrediction(cmdpipe[2].Adress)) then
    begin
    setImg(lines_cacheup,'lines\'+color1+'\cacheup');
    PanelCacheOUT.Caption:=c16(Pcom,4);
    PanelCacheOUT.Color:=xcolor;
    setImg(q_cacheOUT,color1+'\resout');
    end;
  PanelCacheIN.Color:=xcolor;
  setImg(q_cacheIN,color1+'\resin');
  PanelPcom.Color:=xcolor;
  PanelCodeOP.Color:=xcolor;
  PanelR1.Color:=xcolor;
  PanelR2.Color:=xcolor;
  PanelR3.Color:=xcolor;
end;

procedure TFormM.st2(const xcolor:TColor);
var
  color2:String;
begin
  color2:=strColor(xcolor);
  panelpipe2.Color:=xcolor;
  setImg(q_dc,color2+'\dc');
  setImg(lines_dc,'lines\'+color2+'\dc-lines');
  PanelDC.Color:=xcolor;
end;

procedure TFormM.st3(const xcolor:TColor;const op:TTypeOP;const back:Byte=0);
var
  color3:String;
begin
  color3:=strColor(xcolor);
  panelpipe3.Color:=xcolor;
  PanelAWBS3.Color:=xcolor;
  if not(op=jump) then setImg(lines_wb3,'lines\'+color3+'\wb3');
  if(op=load) then
  begin
    setImg(lines_data_1,'lines\'+color3+'\data1');
    PanelWWBS3.Color:=xcolor;
  end else if(op=exec) then
  begin
    setImg(q_bufin,color3+'\bufin');
    PanelBUF1IN.Color:=xcolor;
    PanelBUF2IN.Color:=xcolor;
    if(back<>1) then
    begin
      setImg(lines_ron_a1,'lines\'+color3+'\ron-a1');
      setImg(lines_ron_w1,'lines\'+color3+'\ronw1');
      setImg(q_ron1,color3+'\ron1');
      PanelRONAA.Color:=xcolor;
      PanelRONWA.Color:=xcolor;
    end;
    if(back<>2) then
    begin
      if (cmdPipe[3].codeOP=7)or((cmdPipe[3].codeOP=8)) then
      begin
        setImg(lines_ron_a1,'lines\'+color3+'\ron-a1');
        setImg(lines_ron_w1,'lines\'+color3+'\ronw1');
        setImg(q_ron1,color3+'\ron1');
      end
      else begin
        setImg(lines_ron_a2,'lines\'+color3+'\ron-a2');
        setImg(lines_ron_w2,'lines\'+color3+'\ronw2');
        setImg(q_ron2,color3+'\ron2');
      end;
      if (cmdPipe[3].codeOP=7)or((cmdPipe[3].codeOP=8))then
      begin
        PanelRONAA.Color:=xcolor;
        PanelRONWA.Color:=xcolor;
      end else
      begin
        PanelRONAB.Color:=xcolor;
        PanelRONWB.Color:=xcolor;
      end;
    end;
  end;
  PanelAWBS3.Visible:=(op=exec)or(op=load);
  PanelWWBS3.Visible:=(op=load);
end;

procedure TFormM.st4(const xcolor:TColor;const op:TTypeOP;const back:Byte=0);
var
  color4:String;
begin
  color4:=strColor(xcolor);
  panelpipe4.Color:=xcolor;
  if(dropPipe) then
  begin
    PanelJMP4A.Color:=xcolor;
    PanelJMP4NO.Color:=xcolor;
    PanelJMP4NO.Caption:=IfThen(jumpPrediction(cmdpipe[4].Adress),'GO','NO');
    PanelJMP4A.Caption:=c16(cmdpipe[4].Adress,4);
    setImg(lines_jmp4,'lines\'+color4+'\stage4jmp');
    PanelCacheIN.Color:=xcolor;
    PanelCacheIN.Caption:=c16(cmdpipe[4].Adress,4)+' '+PanelJMP4NO.Caption;
    setImg(q_cacheIN,color4+'\resin');
    setImg(q_pointer,color4+'\pointer');
    PanelPcom.Color:=xcolor;
    PanelJMP4A.Visible:=true;
    PanelJMP4NO.Visible:=true;
    ShowCache();
  end;
  if(op=exec) then
    begin
    setImg(q_bufout,color4+'\bufout');
    setImg(q_resin,color4+'\resin');
    PanelBUF1OUT.Color:=xcolor;
    PanelBUF2OUT.Color:=xcolor;
    setImg(lines_buf_alu,'lines\'+color4+'\bufalu');
    PanelRESin.Color:=xcolor;
    setImg(q_alu,color4+'\alu');
    if(back=1) then setImg(lines_alu,'lines\'+color4+'\alu-left');
    if(back=2) then setImg(lines_alu,'lines\'+color4+'\alu-right');
    if(back=0) then setImg(lines_alu,'lines\'+color4+'\alu-noback');
    end
end;


procedure TFormM.st5(const xcolor:TColor;const op:TTypeOP);
var
  color5:String;
begin
  color5:=strColor(xcolor);
  panelpipe5.Color:=xcolor;
  if(op<>jump) then
    begin
    PanelAWBS5.Color:=xcolor;
    setImg(lines_wb5,'lines\'+color5+'\wb5');
    setImg(q_ron3,color5+'\ron3');
    PanelRONWWB.Color:=xcolor;
    PanelRONAWB.Color:=xcolor;
    end;
  if(op=load) then
  begin
    setImg(lines_data_2,'lines\'+color5+'\data2');
    PanelWWBS5.Color:=xcolor;
  end else if(op=exec) then
    begin
      setImg(q_resout,color5+'\resout');
      setImg(lines_w3,'lines\'+color5+'\ronw3');
      PanelRESout.Color:=xcolor;
    end;
  PanelAWBS5.Visible:=(op=exec)or(op=load);
  PanelWWBS5.Visible:=(op=load);
end;

procedure TFormM.setImg(img:TImage;const path:String);
begin
  if(fileExists(imgpath+path+'.png')) then
    begin
    img.Picture.LoadFromFile(imgpath+path+'.png');
    img.Visible:=true;
    end
  else img.Visible:=false;
end;

procedure TFormM.ResetView();
var
  i:Word;
begin
  for i:=0 to FormM.ComponentCount-1 do
  begin
    if (FormM.Components[i] is TImage)then
    begin
      if (LeftStr((FormM.Components[i] as TComponent).Name,6)='lines_') then
        (FormM.Components[i] as TImage).Visible:=false
      else if (LeftStr((FormM.Components[i] as TComponent).Name,2)='q_') then
        (FormM.Components[i] as TImage).Visible:=false;
    end;
    if (FormM.Components[i] is TPanel)then
      With (FormM.Components[i] as TPanel) do
      begin
        if(list4.IndexOf(Name)<>-1) then
        begin
          Caption:='xxxx';
        end else Caption:='xx';
        Color:=$00FAF5A0;
      end;
  end; // For on components
  PanelAWBS5.Visible:=false;
  PanelAWBS3.Visible:=false;
  PanelWWBS3.Visible:=false;
  PanelWWBS5.Visible:=false;
  PanelJMP4A.Visible:=false;
  PanelJMP4NO.Visible:=false;
end;

procedure TFormM.showall();
var
  i:Word;
  iTmp:Word;
begin
  ResetView;
  for i:=1 to 5 do  // показать содержимое конвейера
  begin
    With (FindComponent('PanelPipe'+IntToStr(i)) as TPanel) do
    begin
      Caption:=cmdpipe[i].NameOP;
      Color:=cmdpipe[i].color;
    end;
  end;
  st1(cmdpipe[1].color);
  st2(cmdpipe[2].color);
  iTmp:=0;
  if RoundAEnabled then iTmp:=1     //Обходная цепь
  else if RoundBEnabled then iTmp:=2;
  st3(cmdpipe[3].color,cmdpipe[3].TypeOP,iTmp);
  st4(cmdpipe[4].color,cmdpipe[4].TypeOP,iTmp);
  st5(cmdpipe[5].color,cmdpipe[5].TypeOP);
  PanelPcom.Caption:=c16(Pcom,4);//C4AK
  if(cmdpipe[1].TypeOP<>nop) then
    PanelCacheIN.Caption:=c16(Pcom,4); //Cache
  PanelCodeOp.Caption:=c16(Rcom.CodeOP);
  PanelR1.Caption:=c16(Rcom.R1);
  PanelR2.Caption:=c16(Rcom.R2);
  if (Rcom.CodeOP=7)or(Rcom.CodeOP=8) then PanelR2.Caption:='xx';  
  if(cmdpipe[1].TypeOP<>jump) then PanelR3.Caption:=c16(Rcom.R3);
  PanelDC.Caption:=cmdpipe[2].NameOP;
  if(cmdpipe[3].TypeOP=load) or (cmdpipe[3].TypeOP=exec) then
    PanelAWBS3.Caption:=c16(cmdpipe[3].R_WB);
  PanelWWBS3.Caption:=c16(cmdpipe[3].R_CONST,4);
  PanelBUF1IN.caption:=c16(buf1.input,4); //Buffers
  PanelBUF1OUT.caption:=c16(buf1.output,4);
  PanelBUF2IN.caption:=c16(buf2.input,4);
  PanelBUF2OUT.caption:=c16(buf2.output,4);
  PanelRESin.Caption:=c16(Rresult.input,4); //Reg Result
  if(cmdpipe[3].TypeOP=exec) then
  begin
    PanelRONAA.Caption:=c16(ron.A1);
    PanelRONAB.Caption:=c16(ron.A2);
    PanelRONWA.Caption:=c16(ron.W1,4);
    PanelRONWB.Caption:=c16(ron.W2,4);
    PanelBUF1IN.Caption:=c16(BUF1.input,4);
    PanelBUF2IN.Caption:=c16(BUF2.input,4);
    if (cmdpipe[3].CodeOP=7)or((cmdpipe[3].CodeOP=8)) then
    begin
      PanelRONAB.Caption:='xx';
      PanelRONWB.Caption:='xxxx';
      PanelBUF2out.Caption:='xxxx';
      PanelBUF2in.Caption:='xxxx';
    end;
  end;
  if(cmdpipe[5].TypeOP=load) or (cmdpipe[5].TypeOP=exec) then
  begin
    PanelAWBS5.Caption:=c16(cmdpipe[5].R_WB);
    PanelRONAWB.Caption:=c16(ron.A3);
    PanelRONWWB.Caption:=c16(ron.W3,4);
  end;
  PanelWWBS5.Visible:=(cmdpipe[5].TypeOP=load);
  if(cmdpipe[5].TypeOP=load) then PanelWWBS5.Caption:=c16(cmdpipe[5].R_CONST,4); // Доп. панелька
  PanelRESout.Caption:=c16(Rresult.output,4);
  if (cmdpipe[4].TypeOP=jump) and (cmdpipe[5].TypeOP=nop) then
    PanelRESout.Font.Color:=clBlack
      else PanelRESout.Font.Color:=clWhite;
  if (cmdPipe[4].CodeOP=7)or(cmdPipe[4].CodeOP=8) then PanelBUF2OUT.Caption:='xxxx';
  if (cmdPipe[4].TypeOP=exec) then
  begin
    ALU_CMD.Caption:=cmdPipe[4].NameOP;
    ALU_CMD.Visible:=true;
    ALU_CMD.Font.Color:=cmdPipe[4].color;
  end else ALU_CMD.Visible:=false;
end;

procedure TFormM.N31Click(Sender: TObject);
begin
  menu4();
end;

procedure TFormM.N41Click(Sender: TObject);
begin
  menu5();
end;

end.  //Rebuild by JeyFry
