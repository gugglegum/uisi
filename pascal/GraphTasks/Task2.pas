unit Task2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TTask2 }

  TTask2 = Class(TInterfacedObject, ITask, ITaskBestPath)
  private
    FGraph: TGraph;
    FBestPath, FCurrentPath: TGraphPath;
    procedure Recursion(Point, Weight: Integer);
    function HasPointCurrentPath(Point: Integer): Boolean;
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
  Point : Integer;
begin
  for Point := 1 to FGraph.GetNumPoints() do
  begin
    FCurrentPath.Clean;
    Recursion(Point, 0);
  end;
end;

procedure TTask2.Recursion(Point, Weight: Integer);
var
  Offset: Integer;
  Edge: TGraphEdge;
  HasPoint: Boolean;
begin
  HasPoint := HasPointCurrentPath(Point);

  FCurrentPath.AddPoint(Point, Weight);

  if (FCurrentPath.GetLength > 1) AND (Point = FCurrentPath.GetPoint(0)) then
  begin
    if (FBestPath.GetLength = 0) OR (FCurrentPath.GetWeight > FBestPath.GetWeight) then
    begin
      FBestPath.CopyFrom(FCurrentPath);
    end;
    FCurrentPath.RemovePoint(Weight);
    Exit;
  end;

  if ((HasPoint) OR (FCurrentPath.GetLength > MaxPoints)) then
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

function TTask2.HasPointCurrentPath(Point: Integer): Boolean;
var
  Index: Integer;
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
