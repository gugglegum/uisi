//
// Задача 1: Определить самый короткий цикл в графе.
//
unit Task1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TTask1 }

  TTask1 = class(TInterfacedObject, ITask)
  private
    FGraph: TGraph;
    FBestPath, FCurrentPath: TGraphPath;
    procedure Recursion(Point, Weight: integer);
    function HasPointInPath(Point: integer; Path: TGraphPath): boolean;
  public
    constructor Create(Graph: TGraph);
    procedure Execute;
    procedure PrintPath(Path: TGraphPath);
  end;

implementation

constructor TTask1.Create(Graph: TGraph);
begin
  FGraph := Graph;
  FBestPath := TGraphPath.Create;
  FCurrentPath := TGraphPath.Create;
end;

procedure TTask1.Execute;
var
  Point: integer;
begin
  for Point := 1 to FGraph.GetNumPoints() do
  begin
    FCurrentPath.Clean;
    Recursion(Point, 0);
  end;

  PrintPath(FBestPath);
end;

procedure TTask1.PrintPath(Path: TGraphPath);
begin
  if (Path.GetLength > 0) then
  begin
    Path.Print;
    Writeln(' (вес: ', FBestPath.GetWeight, ')');
  end
  else
    Writeln('нет циклов');
end;

procedure TTask1.Recursion(Point, Weight: integer);
var
  Offset: integer;
  Edge: TGraphEdge;
  HasPoint: boolean;
begin
  HasPoint := HasPointInPath(Point, FCurrentPath);

  FCurrentPath.AddPoint(Point, Weight);

  if (FCurrentPath.GetLength > 1) and (Point = FCurrentPath.GetPoint(0)) then
  begin
    if (FBestPath.GetLength = 0) or (FCurrentPath.GetWeight < FBestPath.GetWeight) then
      FBestPath.CopyFrom(FCurrentPath);
    FCurrentPath.RemovePoint(Weight);
    Exit;
  end;

  if ((HasPoint) or (FCurrentPath.GetLength > MaxPoints) or
    ((FBestPath.GetLength > 0) and (FCurrentPath.GetWeight >= FBestPath.GetWeight))) then
  begin
    FCurrentPath.RemovePoint(Weight);
    Exit;
  end;

  Offset := FGraph.GetFirstOutgoingEdgeIndex(Point);
  while (Offset <> -1) do
  begin
    Edge := FGraph.GetEdge(Offset);
    Recursion(Edge.Point2, Edge.Weight);
    Offset := FGraph.GetNextOutgoingEdgeIndex(Point, Offset);
  end;
  FCurrentPath.RemovePoint(Weight);
end;

function TTask1.HasPointInPath(Point: integer; Path: TGraphPath): boolean;
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
