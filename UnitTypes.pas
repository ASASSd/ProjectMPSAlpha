unit UnitTypes;

interface
  USES Graphics, SysUtils, StrUtils, Dialogs;

const
  ozuSize = 65535;  // FFFF
  ronSize = 255;    // FF
  cacheSize = 255;
  colors : array[0..4] of Tcolor = (clFuchsia,clGreen,clBlue,clRed,clGray);

type

  TRcom = record
    CodeOP:Word;
    R1:Word;
    R2:Word;
    R3:Word;
  end;

  TTypeOP = (load, jump, exec, nop); // Тип операции. Загрузка, переход, арифметика

  TCacheLine=record      //Кэш
    Afrom:Word;
    Ajump:Word;
    prediction:Boolean;
    charged:Boolean;
  end;

  Tcache = array [0..cacheSize] of TCacheLine;
  Tcommand = record
    CodeOP:Word;
    NameOP:String[255];
    TypeOP:TTypeOP; // Тип операции. Загрузка, переход, арифметика
    R_WB:Word; // Регистр для Write Back
    R_CONST:Word; // Для load это константа, которую грузим, для jump - адрес перехода
    R_RA:Word; // регистр для чтения (exec)
    R_RB:Word; // регистр для чтения (exec)
    Adress:Word;// до какой ступени (self) запирать какое действие
    color: TColor;
  end;

  Tozu = record
    commands: array [0..ozuSize-1] of Tcommand;  // FFFF-1 = 65535-1 , -1 ибо с нуля
    Adress:Word;
    Word:Word;
  end;

  Tron = record
    data: array[0..ronSize-1] of Word;
    A1:Word;
    A2:Word;
    A3:Word;
    W1:Word;
    W2:Word;
    W3:Word;
  end;

  Tcmdpipe = array[1..5] of Tcommand; // Конвейер команд
  Tregister = record
    input:Word;
    output:Word;
  end;
  Tinternal = record
    colorPointer:Word;
    ozuPointer:Word;
  end;

  function cmdMov(const what,where:Word):Tcommand;
  function cmdJP(const where2go:Word):Tcommand;
  function cmdAdd(const RA,RB,WB:Word):Tcommand;
  function cmdAnd(const RA,RB,WB:Word):Tcommand;
  function cmdOr(const RA,RB,WB:Word):Tcommand;
  function cmdSub(const RA,RB,WB:Word):Tcommand;
  function cmdJMP(const where2go:Word):Tcommand;
  function cmdJZ(const where2go:Word):Tcommand;
  function cmdJC(const where2go:Word):Tcommand;    
  function cmdIncr(const where:Word):Tcommand;
  function cmdDecr(const where:Word):Tcommand;
  function cmdNop():Tcommand;
  procedure changePrediction(const from:Word);
  function jumpPrediction(const from:Word):Boolean;
  procedure loadCache();
  procedure ozuAdd(const command:TCommand;const where:Integer=-1);
  function nextColor():TColor;
  function cmd2str(const command:TCommand):String;
  function c16(const num:Word;const length:Word=2):String;
  function nextOzuPointer(const from:Word):Word;

var
  ron:Tron;
  ozu:Tozu;
  cmdpipe:Tcmdpipe;  // Конвейер
  Rcom:TRcom; // Решистр команд
  Pcom:Integer; // command pointer  - СЧАК
  BUF1:Tregister; // Буферные регистры АЛУ
  BUF2:Tregister;
  RoundAEnabled:Boolean;
  RoundBEnabled:Boolean;
  RResult:Tregister;
  internal:TInternal;
  cache:Tcache;
  skip:Boolean;         // Конфликт по обращению
  dropPipe:Boolean; // Передача управления JZ
  lastResult:Word;
  CF:Boolean;  // Флаг переноса
  ZF:Boolean;  // Нуля
  PF:Boolean;   // Положительный

implementation

function c16(const num:Word;const length:Word=2):String;
begin
Result:=Format('%'+IntToStr(length)+'x', [num]);
Result:=StringReplace(Result,' ','0',[rfReplaceAll]);
end;

function nextOzuPointer(const from:Word):Word;
var
  i:Word;
begin
  Result:=from+1;
  for i:=0 to cacheSize-1 do
  begin
    if(not cache[i].charged) then Exit;
    if(cache[i].Afrom=from)then
    begin
      if(cache[i].prediction) then Result:=cache[i].Ajump;
      Exit;
    end;
  end;
end;

function jumpPrediction(const from:Word):Boolean;
var
  i:Word;
begin
  Result:=false;
  for i:=0 to cacheSize-1 do
  begin
    if(not cache[i].charged) then Exit;
    if(cache[i].Afrom=from) then
    begin
      Result:=cache[i].prediction;
      Exit;
    end;
  end;
end;

procedure changePrediction(const from:Word);
var
  i:Word;
begin
  for i:=0 to cacheSize-1 do
  begin
    if(not cache[i].charged) then Exit;
    if(cache[i].Afrom=from)then
    begin
      cache[i].prediction:=not cache[i].prediction;
      Exit;
    end;
  end;
end;

function cmd2str(const command:TCommand):String;
begin
  if(command.CodeOP<=0) then begin Result:=''; Exit; end;
  if(command.TypeOP=load) then Result:=command.NameOP+' '+C16(command.R_WB)+', #'+c16(command.R_CONST,4);
  if(command.TypeOP=exec) then
    if (command.NameOP='INCR') or (command.NameOP='DECR') then Result:=command.NameOP+' '+C16(command.R_WB)
    else Result:=command.NameOP+' '+C16(command.R_WB)+', '+c16(command.R_RA)+', '+c16(command.R_RB);
  if(command.TypeOP=jump) then Result:=command.NameOP+' '+c16(command.R_CONST,4);
  Exit;
end;

procedure loadCache();
var
  i:Word;
  cpoi:Word;
begin
  cpoi:=0;
  for i:= 0 to ozuSize-1 do
  begin
    if(ozu.commands[i].TypeOP=jump) then
    begin
      cache[cpoi].charged:=true;
      cache[cpoi].Afrom:=i;
      cache[cpoi].Ajump:=ozu.commands[i].R_CONST;
      cache[cpoi].prediction:=false;
      cache[cpoi].prediction:=true;
      inc(cpoi);
    end;
  end;
end;

function nextColor():TColor;
begin
  Result:=Colors[internal.ColorPointer];
  if(internal.ColorPointer=4) then internal.ColorPointer:=0
  else inc(internal.ColorPointer);
end;

procedure ozuAdd(const command:TCommand;const where:Integer=-1);
var
  pointer:Word;
begin
  if(where=-1) then pointer:=internal.ozuPointer else pointer:=where;
  ozu.commands[pointer]:=command;
  ozu.commands[pointer].Adress:=pointer;
  internal.ozuPointer:=pointer+1;
end;

function cmdMov(const what,where:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=01;
    NameOP:='MOV';
    R_WB:=where;
    R_CONST:=what;
    color:=clLime;  //Из ячейки нельзя читать, в ней нельзя писать до тех пор,
    TypeOP:=load;   //пока команда MOV не пройдет 5-ую ступень. Т.е. не запишет в РОН константу.
  end;
end;

function cmdJMP(const where2go:Word):Tcommand;
begin
With Result do
  begin

  CodeOP:=04;
  NameOP:='JMP';
  R_WB:=0;
  R_CONST:=where2go;
  color:=clLime;
  TypeOP:=jump;

  end;
end;


function cmdJZ(const where2go:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=05;
    NameOP:='JZ';
    R_WB:=0;
    R_CONST:=where2go;
    color:=clLime;
    TypeOP:=jump;
  end;
end;

function cmdJC(const where2go:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=06;
    NameOP:='JC';
    R_WB:=0;
    R_CONST:=where2go;
    color:=clLime;
    TypeOP:=jump;
  end;
end;

function cmdJP(const where2go:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=09;
    NameOP:='JP';
    R_WB:=0;
    R_CONST:=where2go;
    color:=clLime;
    TypeOP:=jump;
  end;
end;

function cmdAdd(const RA,RB,WB:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=02;
    NameOP:='ADD';
    R_WB:=WB;
    R_RA:=RA;
    R_RB:=RB;
    color:=clLime;
    TypeOP:=exec;
  end;
end;
function cmdOr(const RA,RB,WB:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=10;
    NameOP:='OR';
    R_WB:=WB;
    R_RA:=RA;
    R_RB:=RB;
    color:=clLime;
    TypeOP:=exec;
  end;
end;

function cmdAnd(const RA,RB,WB:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=11;
    NameOP:='AND';
    R_WB:=WB;
    R_RA:=RA;
    R_RB:=RB;
    color:=clLime;
    TypeOP:=exec;
  end;
end;

function cmdIncr(const where:Word):Tcommand;
begin
With Result do
  begin

  CodeOP:=07;
  NameOP:='INCR';
  R_WB:=where;

  R_RA:=where;
  color:=clLime;
  TypeOP:=exec;
  end;
end;

function cmdDecr(const where:Word):Tcommand;
begin
With Result do
  begin
  CodeOP:=08;
  NameOP:='DECR';
  R_WB:=where;
  R_RA:=where;
  color:=clLime;
  TypeOP:=exec;
  end;
end;

function cmdNop():Tcommand;
begin
  With Result do
  begin
    CodeOP:=00;
    NameOP:='NOP';
    color:=$00FAF5A0; // light blue
    TypeOP:=nop;
    R_WB:=0;
    R_RA:=0;
    R_RB:=0;
    R_CONST:=0;
  end;
end;

function cmdSub(const RA,RB,WB:Word):Tcommand;
begin
  With Result do
  begin
    CodeOP:=03;
    NameOP:='SUB';
    R_WB:=WB;

    R_RA:=RA;
    R_RB:=RB;
    color:=clLime;
    TypeOP:=exec;
    {
     Заблокировать чтение и запись в ячейку РОН[WB] до тех пор,
     пока мы не сохраним результат.

     Команду типа exeс можно будет запустить после того, как на
     выходе АЛУ повиснет результат. Задействовав обходную цепь.
     После 4-ой ступени.
    }
  end;
end;

end.
