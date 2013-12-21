program GraphTasksI;

{$mode objfpc}{$H+}

uses
  Crt,
  Classes,
  SysUtils,
  CustApp,
  GraphModel,
  TaskBase,
  Task1,
  Task2,
  Task3,
  Task4,
  Task5,
  Task6;

var
  Graph: TGraph;

function StrSplit(Str: string; Separator: char; Limit: integer; var StrParts: array of string): integer;
var
  I, PartNum: integer;
  Flag: boolean;
begin
  PartNum := -1;
  Flag := false;
  for I := 1 to Length(Str) do
  begin
    if Str[I] <> Separator then
    begin
      if Flag = false then
      begin
        Inc(PartNum);
        if (PartNum < Limit) then
          StrParts[PartNum] := '';
        Flag := true;
      end;
      if (PartNum < Limit) then
        StrParts[PartNum] := StrParts[PartNum] + Str[I];
    end
    else
      Flag := false;
  end;
  Result := PartNum + 1;
end;

procedure LoadGraphFromFile(Graph: TGraph; InputFile: string);
var
  F: Text;
  Str: string;
  Point1, Point2, Weight, PartsCount: integer;
  StrParts: array [0 .. 2] of string;
begin
  Graph.Clear();
  Assign(F, InputFile);
  Reset(F);
  while (not EOF(F)) do
  begin
    Readln(F, Str);
    Writeln(Str);
    if (Str = '') OR (Str[1] = '#') then
      continue; // Skip empty or comment line

    PartsCount := StrSplit(Str, ' ', 3, StrParts);
    if PartsCount <> 3 then
    begin
      Writeln('������: �������� ���-�� �������� � ������');
      break;
    end;

    Point1 := StrToInt(StrParts[0]);
    Point2 := StrToInt(StrParts[1]);
    Weight := StrToInt(StrParts[2]);
    
    Graph.AddEdge(Point1, Point2, Weight);
  end;
  CloseFile(F);
  Writeln;
  Writeln('*** ���� ������� �������� ***');
  Writeln;
end;

procedure LoadGraphFromKeyboard(Graph: TGraph);
var
  Str: string;
  Point1, Point2, Weight, PartsCount: integer;
  StrParts: array [0 .. 2] of string;
begin
  Graph.Clear();
  while (true) do
  begin
    Readln(Str);
    if (Str = '') then
      break;

    PartsCount := StrSplit(Str, ' ', 3, StrParts);
    if PartsCount <> 3 then
    begin
      Writeln('������: �������� ���-�� �������� � ������');
      continue;
    end;

    try
      Point1 := StrToInt(StrParts[0]);
      Point2 := StrToInt(StrParts[1]);
      Weight := StrToInt(StrParts[2]);
    except
      on E: EConvertError do
      begin
        Writeln('��������� ����: ', E.Message);
        continue;
      end;
    end;

    Graph.AddEdge(Point1, Point2, Weight);

  end;
  Writeln;
  Writeln('*** ���� ������� ����� ***');
  Writeln;
end;

procedure LoadMenu;
var
  Input: string;
  Ch: char;
begin
  repeat
    Writeln;
    Writeln('�������� ����� �� �����');
    Writeln;
    Writeln('  [F] ��������� �� �����');
    Writeln('  [M] ������ �������');
    Writeln('  [B] ��������� � ������� ����');
    Writeln;
    Write('�������� ����� ����: ');

    Readln(Input);
    Input := Input;

    if Length(Input) = 1 then
      Ch := UpperCase(Input)[1]
    else
      Ch := Chr(0);

    case Ch of
      'F' : begin
              Write('������� ��� �����: ');
              Readln(Input);
              if Length(Input) > 0 then
              begin
                try
                  LoadGraphFromFile(Graph, Input);
                  break;
                except
                  on E: EInOutError do
                    Writeln('������ �������� �����: ', E.Message);
                  on E: EConvertError do
                    Writeln('��������� ����: ', E.Message);
                end;
              end;
            end;
      'M' : begin
              Writeln('������ ���� �����');
              Writeln;
              Writeln('������� ���� ����� ��������� � �������:');
              Writeln;
              writeln('<���������> <��������> <��������> (��������: "1 2 10" - ����� 1-2 � ����� 10)');
              Writeln;
              Writeln('(������ ������ - ����� �����)');
              Writeln;
              LoadGraphFromKeyboard(Graph);
              break;
            end;
      'B' : begin
              break;
            end;
      else
        Writeln('��������� ����: "', Input, '"');
    end;
  until (false);

end;

procedure Print;
var
  I: integer;
  Edge: TGraphEdge;
begin
  Writeln('����� �����');
  Writeln;
  if Graph.GetNumEdges() > 0 then
  begin
    Writeln('����� ����� � ���� ������ ���� � �������: <���������> <��������> <��������>');
    Writeln;
    for I := 0 to Graph.GetNumEdges() - 1 do
    begin
      Edge := Graph.GetEdge(I);
      Writeln(Edge.Point1, ' ', Edge.Point2, ' ', Edge.Weight);
    end;
  end
  else
    Writeln('*** ���� ������ ***');
  Writeln;
end;

procedure Task1;
var
  Task: TTask1;
begin
  Task := TTask1.Create(Graph);
  Task.Execute();
  Task.Destroy();
end;

procedure Task2;
var
  Task: TTask2;
begin
  Task := TTask2.Create(Graph);
  Task.Execute();
  Task.Destroy();
end;

procedure Task3;
var
  Task: TTask3;
  StartPoint: integer;
begin
  Write('������� ��������� �������: ');
  Readln(StartPoint);
  Task := TTask3.Create(Graph, StartPoint);
  Task.Execute();
  Task.Destroy();
end;

procedure Task4;
var
  Task: TTask4;
  StartPoint: integer;
begin
  Write('������� ��������� �������: ');
  Readln(StartPoint);
  Task := TTask4.Create(Graph, StartPoint);
  Task.Execute();
  Task.Destroy();
end;

procedure Task5;
var
  Task: TTask5;
  StartPoint: integer;
begin
  Write('������� ��������� �������: ');
  Readln(StartPoint);
  Task := TTask5.Create(Graph, StartPoint);
  Task.Execute();
  Task.Destroy();
end;

procedure Task6;
var
  Task: TTask6;
begin
  Task := TTask6.Create(Graph);
  Task.Execute();
  Task.Destroy();
end;

procedure MainMenu;
var
  Input: string;
  Ch: Char;
begin
  repeat
    Writeln;
    Writeln('������� ����');
    Writeln;
    Writeln('  [L] ��������� ����');
    Writeln('  [P] ������� ����');
    Writeln('  [1] ������ 1: ���������� ����� �������� ���� � �����');
    Writeln('  [2] ������ 2: ���������� ����� ������� ���� � �����');
    Writeln('  [3] ������ 3: ��������� ����� ����� � �������');
    Writeln('  [4] ������ 4: ��������� ����� ����� � ������');
    Writeln('  [5] ������ 5: ���������� ���������� ���� �� �������� ������� �� ��� ���������');
    Writeln('  [6] ������ 6: ���������� ���������� ���� ����� ����� ������ ������');
    Writeln('  [Q] �����');
    Writeln;
    Write('�������� ����� ����: ');

    Readln(Input);
    Input := Input;

    if Length(Input) = 1 then
      Ch := UpperCase(Input)[1]
    else
      Ch := Chr(0);

    case Ch of
      'L' : LoadMenu();
      'P' : Print();
      '1' : Task1();
      '2' : Task2();
      '3' : Task3();
      '4' : Task4();
      '5' : Task5();
      '6' : Task6();
      'Q' : begin
              Writeln('����� ������...');
              break;
            end;
      else
        Writeln('��������� ����: "', Input, '"');
    end;
  until (false);
end;

begin
  Graph := TGraph.Create();

  Writeln;
  Writeln('������ � �������');
  MainMenu();
end.
