unit Task6;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel, TaskBase;

type

  { TTask6 }

  TTask6 = class(TInterfacedObject, ITask, ITaskBestPath)
  private
    FGraph: TGraph;
    FBestPath, FCurrentPath: TGraphPath;
    procedure Recursion(Point, TargetPoint, Weight: integer);
    function HasPointCurrentPath(Point: integer): boolean;
  public
    constructor Create(Graph: TGraph);
    procedure Execute;
    function GetBestPath: TGraphPath;
  end;

implementation

constructor TTask6.Create(Graph: TGraph);
begin
  FGraph := Graph;
  FBestPath := TGraphPath.Create;
  FCurrentPath := TGraphPath.Create;
end;

procedure TTask6.Execute;
var
  FromPoint, ToPoint: integer;
begin
  for FromPoint := 1 to FGraph.GetNumPoints do
    for ToPoint := 1 to FGraph.GetNumPoints do
    begin
      if FromPoint = ToPoint then
        continue;
      FCurrentPath.Clean;
      FBestPath.Clean;
      Recursion(FromPoint, ToPoint, 0);

      Write(FromPoint, ' .. ', ToPoint, ' : ');
      if (GetBestPath.GetLength > 0) then
      begin
        GetBestPath.Print;
        Writeln(' (weight: ', GetBestPath.GetWeight, ')');
      end
      else
        Writeln('no path');
    end;
end;

procedure TTask6.Recursion(Point, TargetPoint, Weight: integer);
var
  Offset: integer;
  Edge: TGraphEdge;
  HasPoint: boolean;
begin
  HasPoint := HasPointCurrentPath(Point);

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

function TTask6.HasPointCurrentPath(Point: integer): boolean;
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

function TTask6.GetBestPath: TGraphPath;
begin
  Result := FBestPath;
end;

end.
