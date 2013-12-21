program GraphTasks;

{$mode objfpc}{$H+}

uses
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

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
    procedure LoadGraph(Graph: TGraph; InputFile: string);
    function GetNonOptParamCount: integer;
    function GetNonOptParams(Index: integer): string;
  public
    constructor Create(TheOwner: TComponent); override;
    //destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  { TMyApplication }

  procedure TMyApplication.DoRun;
  var
    ErrorMsg: string;
    TaskNumber: integer;
    InputFile: string;
    Graph: TGraph;
    Task: ITask;
  begin
    // quick check parameters
    ErrorMsg := CheckOptions('h', 'help from-point:');
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;

    // parse parameters
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;

    if (GetNonOptParamCount < 1) or (GetNonOptParamCount > 2) then
    begin
      writeln('Invalid amount of arguments. Use -h (or --help) option for help.');
      Terminate;
      Exit;
    end;

    TaskNumber := StrToInt(GetNonOptParams(1));
    InputFile := GetNonOptParams(2);

    Graph := TGraph.Create;
    LoadGraph(Graph, InputFile);

    case TaskNumber of
      1: Task := TTask1.Create(Graph);
      2: Task := TTask2.Create(Graph);
      3: Task := TTask3.Create(Graph, StrToInt(GetOptionValue('from-point')));
      4: Task := TTask4.Create(Graph, StrToInt(GetOptionValue('from-point')));
      5: Task := TTask5.Create(Graph, StrToInt(GetOptionValue('from-point')));
      6: Task := TTask6.Create(Graph);
      else
        Writeln('Invalid task number: ', TaskNumber);
    end;

    Task.Execute;

    FreeAndNil(Graph);

    // stop program loop
    Terminate;
  end;

  procedure TMyApplication.LoadGraph(Graph: TGraph; InputFile: string);
  var
    F: Text;
    Point1, Point2, Weight: integer;
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
    while (not EOF(F)) do
    begin
      Readln(F, Point1, Point2, Weight);
      if ((Point1 = 0) and (Point2 = 0)) then
        continue;     // Skip empty line
      Graph.AddEdge(Point1, Point2, Weight);
    end;
    CloseFile(F);
  end;

  constructor TMyApplication.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  //destructor TMyApplication.Destroy;
  //begin
  //  inherited Destroy;
  //end;

  procedure TMyApplication.WriteHelp;
  begin
    Writeln('Graph Tasks');
    Writeln('===========');
    Writeln;
    Writeln('Usage: ', ExtractFileName(ExeName), ' <TaskNum> [<InFile>] [Options]');
    Writeln;
    Writeln('  <TaskNum> - A digit from 1 to 6');
    Writeln('  <InFile>  - A file name of input graph');
    Writeln;
    Writeln('Options:');
    Writeln;
    Writeln('  --from-point=N        Starting point for task #3, #4, #5');
    Writeln;
  end;

  function TMyApplication.GetNonOptParamCount: integer;
  var
    RealParamCount, I: integer;
    NonOptionParamCount: integer = 0;
  begin
    RealParamCount := GetParamCount();
    for I := 1 to RealParamCount do
      if GetParams(I)[1] <> '-' then
        Inc(NonOptionParamCount);
    Result := NonOptionParamCount;
  end;

  function TMyApplication.GetNonOptParams(Index: integer): string;
  var
    RealParamCount, I: integer;
    NonOptionParamCount: integer = 0;
    Found: boolean = False;
  begin
    RealParamCount := GetParamCount();
    for I := 1 to RealParamCount do
    begin
      if GetParams(I)[1] <> '-' then
        Inc(NonOptionParamCount);
      if NonOptionParamCount = Index then
      begin
        Result := inherited GetParams(I);
        Found := True;
        break;
      end;
    end;

    if not Found then
      raise ERangeError.Create('Command-line parameter ' + IntToStr(Index) +
        ' is out of range');
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
