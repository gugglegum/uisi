//
// Задача 4: Выполнить обход графа в ширину.
//
unit Task4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TPointsQueue }

  TPointsQueue = class
  private
    FPoints: array [0 .. MaxPoints] of integer;
    FLength: integer;
  public
    constructor Create;
    procedure Clean;
    procedure AddPoint(Point: integer);
    function GetLength: integer;
    function GetPoint: integer;
  end;

  { TTask4 }

  TTask4 = class(TInterfacedObject, ITask)
  private
    FGraph: TGraph;
    //FCurrentPath: TGraphPath;
    FBypassPath: TGraphPath;
    FPointsQueue: TPointsQueue;
    FFromPoint: integer;
    procedure PrintPath(Path: TGraphPath);
    function HasPointInPath(Point: integer; Path: TGraphPath): boolean;
  public
    constructor Create(Graph: TGraph; FromPoint: integer);
    procedure Execute;
  end;

implementation

constructor TTask4.Create(Graph: TGraph; FromPoint: integer);
begin
  FGraph := Graph;
  FFromPoint := FromPoint;
  //FCurrentPath := TGraphPath.Create;
  FBypassPath := TGraphPath.Create;
  FPointsQueue := TPointsQueue.Create;
end;

procedure TTask4.Execute;
var
  Point, Offset: integer;
  Edge: TGraphEdge;
begin
  //Recursion(FFromPoint, 0);
  FPointsQueue.AddPoint(FFromPoint);
  while (FPointsQueue.GetLength() > 0) do
  begin
    Point := FPointsQueue.GetPoint();

    if Not HasPointInPath(Point, FBypassPath) then
      FBypassPath.AddPoint(Point, 0);

    Offset := FGraph.GetFirstOutgoingEdgeIndex(Point);
    while (Offset <> -1) do
    begin
      Edge := FGraph.GetEdge(Offset);
      if Not HasPointInPath(Edge.Point2, FBypassPath) then
        FPointsQueue.AddPoint(Edge.Point2);
      Offset := FGraph.GetNextOutgoingEdgeIndex(Point, Offset);
    end;

  end;
  PrintPath(FBypassPath);
end;

procedure TTask4.PrintPath(Path: TGraphPath);
begin
  Writeln;
  Writeln('Путь обхода в ширину: ');
  Writeln;
  Path.Print;
  Writeln;
end;

function TTask4.HasPointInPath(Point: integer; Path: TGraphPath): boolean;
var
  Index: integer;
begin
  Result := False;
  for Index := 0 to Path.GetLength - 1 do
    if (Path.GetPoint(Index) = Point) then
    begin
      Result := True;
      break;
    end;
end;


{ TPointsQueue }

constructor TPointsQueue.Create;
begin
  Clean();
end;

procedure TPointsQueue.Clean;
begin
  FLength := 0;
end;

procedure TPointsQueue.AddPoint(Point: integer);
begin
  FPoints[FLength] := Point;
  Inc(FLength);
end;

function TPointsQueue.GetLength: integer;
begin
  Result := FLength;
end;

function TPointsQueue.GetPoint: integer;
var
  i: integer;
begin
  if (FLength > 0) then
  begin
    Result := FPoints[0];
    // Shifting down queue
    for i := 1 to FLength - 1 do
      FPoints[i-1] := FPoints[i];
    Dec(FLength);
  end
  else
    Result := 0;
end;

end.
