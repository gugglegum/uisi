unit GraphModel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  MaxPoints = 20;
  MaxEdges = MaxPoints * (MaxPoints - 1) div 2;

type
  TGraphEdge = record
    Point1, point2: integer;
    weight: integer;
  end;

  { TGraph }

  TGraph = class
  private
    _numPoints: integer;
    _numEdges: integer;
    _edges: array[0 .. MaxEdges - 1] of TGraphEdge;

  public
    constructor Create;
    function HasEdge(Point1, Point2: integer): Boolean;
    procedure AddEdge(Point1, Point2, Weight: Integer);
    function GetEdge(Index: Integer): TGraphEdge;
    function GetNumEdges: Integer;
    function GetNumPoints: Integer;
    function GetNextOutgoingEdgeIndex(Point, Offset: Integer): Integer;
    function GetFirstOutgoingEdgeIndex(Point: Integer): Integer;
  end;


implementation

constructor TGraph.Create;
begin
  _numPoints := 0;
  _numEdges := 0;
end;

function TGraph.HasEdge(Point1, Point2: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to _numEdges - 1 do
  begin
    if ((_edges[i].Point1 = Point1) and (_edges[i].Point2 = Point2)) then
    begin
      Result := True;
      break;
    end;
  end;
end;

procedure TGraph.AddEdge(Point1, Point2, Weight: Integer);
begin
  if (HasEdge(Point1, Point2)) then
    raise EInOutError.Create('Duplicate edge');
  if ((Point1 < 1) or (Point2 < 1)) then
    raise EInOutError.Create('Too small point number value');
  if ((Point1 > MaxPoints) or (Point2 > MaxPoints)) then
    raise EInOutError.Create('Too big point number value');
  if (_numEdges > MaxEdges - 1) then
    raise EInOutError.Create('Too many edges (max ' + IntToStr(MaxEdges) + ')');
  if (Weight < 0) then
    raise ERangeError.Create('Weight of graph edge must not be negative');
  _edges[_numEdges].Point1 := Point1;
  _edges[_numEdges].Point2 := Point2;
  _edges[_numEdges].Weight := Weight;
  Inc(_numEdges);
  if (Point1 > _numPoints) then
    _numPoints := Point1;
  if (Point2 > _numPoints) then
    _numPoints := Point2;
end;

function TGraph.GetEdge(Index: Integer): TGraphEdge;
begin
  if (Index < 0) or (Index > _numEdges - 1) then
    raise ERangeError.Create('Edge index is out of range');
  Result := _edges[Index];
end;

function TGraph.GetNumEdges: Integer;
begin
  Result := _numEdges;
end;

function TGraph.GetNumPoints: Integer;
begin
  Result := _numPoints;
end;

function TGraph.GetNextOutgoingEdgeIndex(Point, Offset: Integer): Integer;
begin
  Result := -1;
  for Offset := Offset + 1 to _numEdges - 1 do
  begin
    if (_edges[Offset].Point1 = Point) then
    begin
      Result := Offset;
      break;
    end;
  end;
end;

function TGraph.GetFirstOutgoingEdgeIndex(Point: Integer): Integer;
begin
  Result := GetNextOutgoingEdgeIndex(Point, -1);
end;

end.

