unit Task1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel;

type

  { TTask1 }

  TTask1 = class
  private
    _graph: TGraph;
    _bestPath: array[0 .. MaxPoints] of Integer;
    _bestPathLength: Integer;
    _bestPathWeight: Integer;
    _currentPath: array[0 .. MaxPoints] of Integer;
    _currentPathLength: Integer;
    _currentPathWeight: Integer;
  public
    constructor Create(Graph: TGraph);
    procedure Execute;
    procedure Recursion(Point, Weight: Integer);
    function HasPointCurrentPath(Point: Integer): Boolean;
    procedure MakeCurrentPathBest;
    procedure PrintBestPath;
    procedure PrintCurrentPath;
  end;

implementation

constructor TTask1.Create(Graph: TGraph);
begin
  _graph := Graph;
  _bestPathLength := 0;
  _currentPathLength := 0;
end;

procedure TTask1.Execute;
var
  Point : integer;
begin
  for Point := 1 to _graph.GetNumPoints() do
  begin
    _currentPathLength := 0;
    Recursion(Point, 0);
  end;

  PrintBestPath();
end;

procedure TTask1.Recursion(Point, Weight: Integer);
var
  Offset: Integer;
  Edge: TGraphEdge;
  HasPoint: Boolean;
begin
  HasPoint := HasPointCurrentPath(Point);

  _currentPath[_currentPathLength] := Point;
  Inc(_currentPathLength);
  Inc(_currentPathWeight, Weight);
  //PrintCurrentPath();

  if (_currentPathLength > 1) AND (Point = _currentPath[0]) then
  begin
    if (_bestPathLength = 0) OR (_currentPathWeight < _bestPathWeight) then
    begin
      MakeCurrentPathBest();
    end;
    Dec(_currentPathLength);
    Dec(_currentPathWeight, weight);
    Exit;
  end;

  if ((HasPoint) OR (_currentPathLength > MaxPoints)
    OR ((_bestPathLength > 0) AND (_currentPathWeight >= _bestPathWeight))) then
  begin
    Dec(_currentPathLength);
    Dec(_currentPathWeight, weight);
    Exit;
  end;

  Offset := _graph.GetNextOutgoingEdgeIndex(Point, -1);
  while (Offset <> -1) do
  begin
    Edge := _graph.GetEdge(Offset);
    Recursion(Edge.Point2, Edge.Weight);
    Offset := _graph.GetNextOutgoingEdgeIndex(Point, Offset);
  end;
  Dec(_currentPathLength);
  Dec(_currentPathWeight, Weight);
end;

function TTask1.HasPointCurrentPath(Point: Integer): Boolean;
var
  Index: Integer;
begin
  Result := False;
  for Index := 0 to _currentPathLength - 1 do
    if (_currentPath[Index] = Point) then
    begin
      Result := True;
      break;
    end;
end;

procedure TTask1.MakeCurrentPathBest;
var
  Index: Integer;
begin
  for Index := 0 to _currentPathLength - 1 do
    _bestPath[Index] := _currentPath[Index];
  _bestPathLength := _currentPathLength;
  _bestPathWeight := _currentPathWeight;
end;

procedure TTask1.PrintBestPath;
var
  Index: Integer;
begin
  if (_bestPathLength > 0) then
  begin
    write('The shortest path is: ');
    for Index := 0 to _bestPathLength - 1 do
    begin
      if (Index > 0) then
        Write(' -> ');
      Write(_bestPath[index]);
    end;
    Writeln();
    Writeln('The best cycle weight is ', _bestPathWeight);
  end
  else
    Writeln('There is no cycle, sorry.');
end;

procedure TTask1.PrintCurrentPath;
var
  Index: Integer;
begin
  if (_currentPathLength > 0) then
  begin
    write('The current path is: ');
    for index := 0 to _currentPathLength - 1 do
    begin
      if (index > 0) then
        write(' -> ');
      write(_currentPath[index]);
    end;
    writeln();
  end
  else
    writeln('There is no cycle, sorry.');
end;

end.

