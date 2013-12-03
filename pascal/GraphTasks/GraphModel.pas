unit GraphModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  MaxPoints = 64;
  MaxEdges = MaxPoints * (MaxPoints - 1) div 2;

type
  TGraphEdge = record
    Point1, Point2: integer;
    Weight: integer;
  end;

  { TGraph }

  TGraph = class
  private
    FNumPoints: integer;
    FNumEdges: integer;
    FEdges: array[0 .. MaxEdges - 1] of TGraphEdge;

  public
    constructor Create;
    function HasEdge(Point1, Point2: integer): boolean;
    procedure AddEdge(Point1, Point2, Weight: integer);
    function GetEdge(Index: integer): TGraphEdge;
    function GetNumEdges: integer;
    function GetNumPoints: integer;
    function GetNextOutgoingEdgeIndex(Point, Offset: integer): integer;
    function GetFirstOutgoingEdgeIndex(Point: integer): integer;
  end;

  { TGraphPath }

  TGraphPath = class
  private
    FPoints: array[0 .. MaxPoints] of integer;
    FLength: integer;
    FWeight: integer;
  public
    constructor Create;
    procedure Clean;
    procedure AddPoint(Point, Weight: integer);
    procedure RemovePoint(Weight: integer);
    function GetLength: integer;
    function GetWeight: integer;
    function GetPoint(Index: integer): integer;
    procedure CopyFrom(GraphPath: TGraphPath);
    procedure Print;
  end;


implementation

constructor TGraph.Create;
begin
  FNumPoints := 0;
  FNumEdges := 0;
end;

function TGraph.HasEdge(Point1, Point2: integer): boolean;
var
  I: integer;
begin
  Result := False;
  for I := 0 to FNumEdges - 1 do
  begin
    if ((FEdges[i].Point1 = Point1) and (FEdges[i].Point2 = Point2)) then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TGraph.AddEdge(Point1, Point2, Weight: integer);
begin
  if (HasEdge(Point1, Point2)) then
    raise EInOutError.Create('Duplicate edge');
  if ((Point1 < 1) or (Point2 < 1)) then
    raise EInOutError.Create('Too small point number value');
  if ((Point1 > MaxPoints) or (Point2 > MaxPoints)) then
    raise EInOutError.Create('Too big point number value');
  if (FNumEdges > MaxEdges - 1) then
    raise EInOutError.Create('Too many edges (max ' + IntToStr(MaxEdges) + ')');
  if (Weight < 0) then
    raise ERangeError.Create('Weight of graph edge must not be negative');
  FEdges[FNumEdges].Point1 := Point1;
  FEdges[FNumEdges].Point2 := Point2;
  FEdges[FNumEdges].Weight := Weight;
  Inc(FNumEdges);
  if (Point1 > FNumPoints) then
    FNumPoints := Point1;
  if (Point2 > FNumPoints) then
    FNumPoints := Point2;
end;

function TGraph.GetEdge(Index: integer): TGraphEdge;
begin
  if (Index < 0) or (Index > FNumEdges - 1) then
    raise ERangeError.Create('Edge index is out of range');
  Result := FEdges[Index];
end;

function TGraph.GetNumEdges: integer;
begin
  Result := FNumEdges;
end;

function TGraph.GetNumPoints: integer;
begin
  Result := FNumPoints;
end;

function TGraph.GetNextOutgoingEdgeIndex(Point, Offset: integer): integer;
begin
  Result := -1;
  for Offset := Offset + 1 to FNumEdges - 1 do
  begin
    if (FEdges[Offset].Point1 = Point) then
    begin
      Result := Offset;
      break;
    end;
  end;
end;

function TGraph.GetFirstOutgoingEdgeIndex(Point: integer): integer;
begin
  Result := GetNextOutgoingEdgeIndex(Point, -1);
end;


constructor TGraphPath.Create;
begin
  Clean;
end;

procedure TGraphPath.Clean;
begin
  FLength := 0;
  FWeight := 0;
end;

procedure TGraphPath.AddPoint(Point, Weight: integer);
begin
  FPoints[FLength] := Point;
  Inc(FLength);
  Inc(FWeight, Weight);
end;

procedure TGraphPath.RemovePoint(Weight: integer);
begin
  Dec(FLength);
  Dec(FWeight, Weight);
end;

function TGraphPath.GetLength: integer;
begin
  Result := FLength;
end;

function TGraphPath.GetWeight: integer;
begin
  Result := FWeight;
end;

function TGraphPath.GetPoint(Index: integer): integer;
begin
  Result := FPoints[Index];
end;

procedure TGraphPath.CopyFrom(GraphPath: TGraphPath);
var
  Index: integer;
begin
  Clean;
  for Index := 0 to GraphPath.GetLength - 1 do
    AddPoint(GraphPath.GetPoint(Index), 0);
  FWeight := GraphPath.GetWeight;
end;

procedure TGraphPath.Print;
var
  Index: integer;
begin
  for Index := 0 to FLength - 1 do
  begin
    if (Index > 0) then
      Write(' -> ');
    Write(FPoints[Index]);
  end;
end;


end.

