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
    FFromPoint: integer;
    procedure Recursion(Point, Weight: integer);
    procedure PrintPath(Path: TGraphPath);
    function HasPointCurrentPath(Point: integer): boolean;
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
end;

procedure TTask3.Execute;
begin
  Recursion(FFromPoint, 0);
end;

procedure TTask3.Recursion(Point, Weight: integer);
var
  Offset: integer;
  Edge: TGraphEdge;
  HasPoint: boolean;
begin
  HasPoint := HasPointCurrentPath(Point);

  FCurrentPath.AddPoint(Point, Weight);
  PrintPath(FCurrentPath);

  if (FCurrentPath.GetLength > 1) and (Point = FCurrentPath.GetPoint(0)) then
  begin
    FCurrentPath.RemovePoint(Weight);
    Exit;
  end;

  if (HasPoint) or (FCurrentPath.GetLength > MaxPoints) then
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

  PrintPath(FCurrentPath);
  FCurrentPath.RemovePoint(Weight);
end;

procedure TTask3.PrintPath(Path: TGraphPath);
begin
  if (Path.GetLength > 0) then
  begin
    Path.Print;
    Writeln;
  end
  else
    Writeln('no path');
end;

function TTask3.HasPointCurrentPath(Point: integer): boolean;
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

end.
