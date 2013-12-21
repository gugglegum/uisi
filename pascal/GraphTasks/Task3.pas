//
// Задача 3: Выполнить обход графа в глубину.
//
unit Task3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TTask3 }

  TTask3 = class(TInterfacedObject, ITask)
  private
    FGraph: TGraph;
    FCurrentPath: TGraphPath;
    FBypassPath: TGraphPath;
    FFromPoint: integer;
    procedure Recursion(Point: integer);
    procedure PrintPath(Path: TGraphPath);
    function HasPointInPath(Point: integer; Path: TGraphPath): boolean;
  public
    constructor Create(Graph: TGraph; FromPoint: integer);
    procedure Execute;
  end;

implementation

constructor TTask3.Create(Graph: TGraph; FromPoint: integer);
begin
  FGraph := Graph;
  FFromPoint := FromPoint;
  FCurrentPath := TGraphPath.Create;
  FBypassPath := TGraphPath.Create;
end;

procedure TTask3.Execute;
begin
  Recursion(FFromPoint);
  PrintPath(FBypassPath);
end;

procedure TTask3.Recursion(Point: integer);
var
  Offset: integer;
  Edge: TGraphEdge;
  HasPoint: boolean;
begin
  if Not HasPointInPath(Point, FBypassPath) then
    FBypassPath.AddPoint(Point, 0);

  HasPoint := HasPointInPath(Point, FCurrentPath);

  FCurrentPath.AddPoint(Point, 0);

  if (FCurrentPath.GetLength > 1) and (Point = FCurrentPath.GetPoint(0)) then
  begin
    FCurrentPath.RemovePoint(0);
    Exit;
  end;

  if (HasPoint) or (FCurrentPath.GetLength > MaxPoints) then
  begin
    FCurrentPath.RemovePoint(0);
    Exit;
  end;

  Offset := FGraph.GetFirstOutgoingEdgeIndex(Point);
  while (Offset <> -1) do
  begin
    Edge := FGraph.GetEdge(Offset);
    Recursion(Edge.Point2);
    Offset := FGraph.GetNextOutgoingEdgeIndex(Point, Offset);
  end;

  FCurrentPath.RemovePoint(0);
end;

procedure TTask3.PrintPath(Path: TGraphPath);
begin
  Writeln;
  Writeln('Путь обхода в глубину: ');
  Writeln;
  Path.Print;
  Writeln;
end;

function TTask3.HasPointInPath(Point: integer; Path: TGraphPath): boolean;
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

end.
