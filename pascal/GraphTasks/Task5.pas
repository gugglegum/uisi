//
// Задача 5: Определить кратчайший путь из заданной вершины во все остальные.
//
unit Task5;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TTask5 }

  TTask5 = class(TInterfacedObject, ITask)
  private
    FGraph: TGraph;
    FFromPoint: integer;
    FBestPath, FCurrentPath: TGraphPath;
    procedure Recursion(Point, TargetPoint, Weight: integer);
    function HasPointInPath(Point: integer; Path: TGraphPath): boolean;
  public
    constructor Create(Graph: TGraph; FromPoint: integer);
    procedure Execute;
    procedure PrintPath(Path: TGraphPath);
  end;

implementation

constructor TTask5.Create(Graph: TGraph; FromPoint: integer);
begin
  FGraph := Graph;
  FFromPoint := FromPoint;
  FBestPath := TGraphPath.Create;
  FCurrentPath := TGraphPath.Create;
end;

procedure TTask5.Execute;
var
  ToPoint: integer;
begin
  Writeln;
  Writeln('Кратчайшие пути из одной вершины во все остальные: ');
  Writeln;
  for ToPoint := 1 to FGraph.GetNumPoints do
  begin
    if ToPoint = FFromPoint then
      continue;
    FCurrentPath.Clean;
    FBestPath.Clean;
    Recursion(FFromPoint, ToPoint, 0);

    Write(FFromPoint, ' .. ', ToPoint, ' : ');
    PrintPath(FBestPath);
  end;
end;

procedure TTask5.PrintPath(Path: TGraphPath);
begin
  if (Path.GetLength > 0) then
  begin
    Path.Print;
    Writeln(' (вес: ', FBestPath.GetWeight, ')');
  end
  else
    Writeln('нет пути');
end;

procedure TTask5.Recursion(Point, TargetPoint, Weight: integer);
var
  Offset: integer;
  Edge: TGraphEdge;
  HasPoint: boolean;
begin
  HasPoint := HasPointInPath(Point, FCurrentPath);

  FCurrentPath.AddPoint(Point, Weight);

  if (FCurrentPath.GetLength > 1) and (Point = TargetPoint) then
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
    Recursion(Edge.Point2, TargetPoint, Edge.Weight);
    Offset := FGraph.GetNextOutgoingEdgeIndex(Point, Offset);
  end;
  FCurrentPath.RemovePoint(Weight);
end;

function TTask5.HasPointInPath(Point: integer; Path: TGraphPath): boolean;
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
