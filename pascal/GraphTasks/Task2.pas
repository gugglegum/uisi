unit Task2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TTask2 }

  TTask2 = class(TInterfacedObject, ITask, ITaskBestPath)
  private
    FGraph: TGraph;
    FBestPath, FCurrentPath: TGraphPath;
    procedure Recursion(Point, Weight: integer);
    function HasPointCurrentPath(Point: integer): boolean;
  public
    constructor Create(Graph: TGraph);
    procedure Execute;
    function GetBestPath: TGraphPath;
  end;

implementation

constructor TTask2.Create(Graph: TGraph);
begin
  FGraph := Graph;
  FBestPath := TGraphPath.Create;
  FCurrentPath := TGraphPath.Create;
end;

procedure TTask2.Execute;
var
  Point: integer;
begin
  for Point := 1 to FGraph.GetNumPoints() do
  begin
    FCurrentPath.Clean;
    Recursion(Point, 0);
  end;

  if (GetBestPath.GetLength > 0) then
  begin
    GetBestPath.Print;
    Writeln(' (weight: ', GetBestPath.GetWeight, ')');
  end
  else
    Writeln('no path');
end;

procedure TTask2.Recursion(Point, Weight: integer);
var
  Offset: integer;
  Edge: TGraphEdge;
  HasPoint: boolean;
begin
  HasPoint := HasPointCurrentPath(Point);

  FCurrentPath.AddPoint(Point, Weight);

  if (FCurrentPath.GetLength > 1) and (Point = FCurrentPath.GetPoint(0)) then
  begin
    if (FBestPath.GetLength = 0) or (FCurrentPath.GetWeight > FBestPath.GetWeight) then
      FBestPath.CopyFrom(FCurrentPath);
    FCurrentPath.RemovePoint(Weight);
    Exit;
  end;

  if ((HasPoint) or (FCurrentPath.GetLength > MaxPoints)) then
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

function TTask2.HasPointCurrentPath(Point: integer): boolean;
var
  Index: integer;
begin
  Result := False;
  for Index := 0 to FCurrentPath.GetLength - 1 do
    if (FCurrentPath.GetPoint(Index) = Point) then
    begin
      Result := True;
      break;
    end;
end;

function TTask2.GetBestPath: TGraphPath;
begin
  Result := FBestPath;
end;

end.
