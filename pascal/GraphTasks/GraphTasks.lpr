program GraphTasks;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, GraphModel, Task1, TaskBase;

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
    procedure LoadGraph(Graph : TGraph; InputFile : String);
    procedure PrintPath(Path: array of Integer; Length: Integer);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
  TaskNumber : Integer;
  InputFile : String;
  Graph : TGraph;
  Task : ITask;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h','help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if (GetParamCount < 1) OR (GetParamCount > 2) then
  begin
    writeln('Invalid amount of arguments. Use -h (or --help) option for help.');
    Terminate;
    Exit;
  end;

  TaskNumber := StrToInt(GetParams(1));
  InputFile := GetParams(2);

  Graph := TGraph.Create;
  LoadGraph(Graph, InputFile);

  case TaskNumber of
    1 : Task := TTask1.Create(Graph);
    else
      Writeln('Invalid task number: ', TaskNumber);
  end;

  Task.Execute;

  if Task is ITaskBestPath then
  begin
    (Task as ITaskBestPath).GetBestPath.Print;
  end;

  Graph.Destroy;
  Graph := nil;

  // stop program loop
  Terminate;
end;

procedure TMyApplication.LoadGraph(Graph : TGraph; InputFile : String);
var
    F : text;
    Point1, Point2, Weight : integer;
begin
    if InputFile <> '' then
    begin
      System.Assign(F, InputFile);
      Reset(F);
    end
    else
    begin
      F := input;   // Assign F to STDIN
    end;
    while (not Eof(F)) do
    begin
        Readln(F, Point1, Point2, Weight);
        if ((Point1 = 0) AND (Point2 = 0)) then
            continue;     // Пропуск пустой строки
        Graph.AddEdge(Point1, Point2, Weight);
    end;
    CloseFile(F);
end;

procedure TMyApplication.PrintPath(Path: array of Integer; Length: Integer);
var
  Index: Integer;
begin
  for Index := 0 to Length - 1 do
  begin
    if (Index > 0) then
      Write(' -> ');
    Write(Path[Index]);
  end;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  Writeln('Graph Tasks');
  Writeln('===========');
  Writeln;
  Writeln('Usage: ', ExeName, ' <Task> [<File>]');
end;

var
  Application: TMyApplication;

{$R *.res}

begin
  Application := TMyApplication.Create(nil);
  Application.Title := 'Graph Tasks';
  Application.Run;
  Application.Free;
end.

