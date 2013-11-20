Program GraphTasks;
uses SysUtils;
const
    MAX_POINTS = 20;
    MAX_EDGES = MAX_POINTS*(MAX_POINTS-1) div 2;
type
    GraphEdge = record
        point1, point2 : integer;
        weight : integer;
    end;

    GraphModel = class
        private
            _numPoints : integer;
            _numEdges : integer;
            _edges : array[0 .. MAX_EDGES-1] of GraphEdge;

        public
            constructor Create;
            function HasEdge(point1, point2 : integer) : boolean;
            procedure AddEdge(point1, point2, weight : integer);
            function GetEdge(index : integer) : GraphEdge;
            function GetNumEdges : integer;
            function GetNumPoints : integer;
            function GetNextOutgoingEdgeIndex(point, offset : integer) : integer;
    end;

    constructor GraphModel.Create;
    begin
        _numPoints := 0;
        _numEdges := 0;
    end;

    function GraphModel.HasEdge(point1, point2 : integer) : boolean;
    var
        i : integer;
    begin
        result := false;
        for i := 0 to _numEdges -1 do
        begin
            if ((_edges[i].point1 = point1) AND (_edges[i].point2 = point2)) then
            begin
                result := true;
                break;
            end;
        end;
    end;

    procedure GraphModel.AddEdge(point1, point2, weight : integer);
    begin
        if (HasEdge(point1, point2)) then
            raise EInOutError.Create('Duplicate edge');
        if ((point1 < 1) OR (point2 < 1)) then
            raise EInOutError.Create('Too small point number value');
        if ((point1 > MAX_POINTS) OR (point2 > MAX_POINTS)) then
            raise EInOutError.Create('Too big point number value');
        if (_numEdges > MAX_EDGES-1) then
            raise EInOutError.Create('Too many edges (max ' + IntToStr(MAX_EDGES) + ')');
        if (weight < 0) then
            raise ERangeError.Create('Weight of graph edge must not be negative');
        _edges[_numEdges].point1 := point1;
        _edges[_numEdges].point2 := point2;
        _edges[_numEdges].weight := weight;
        inc(_numEdges);
        if (point1 > _numPoints) then
            _numPoints := point1;
        if (point2 > _numPoints) then
            _numPoints := point2;
    end;

    function GraphModel.GetEdge(index : integer) : GraphEdge;
    begin
        if (index < 0) OR (index > _numEdges - 1) then
            raise ERangeError.Create('Edge index is out of range');
        result := _edges[index];
    end;

    function GraphModel.GetNumEdges : integer;
    begin
        result := _numEdges;
    end;

    function GraphModel.GetNumPoints : integer;
    begin
        result := _numPoints;
    end;

    function GraphModel.GetNextOutgoingEdgeIndex(point, offset : integer) : integer;
    begin
        result := -1;
        for offset := offset + 1 to _numEdges - 1 do
        begin
            if (_edges[offset].point1 = point) then
            begin
                result := offset;
                break;
            end;
        end;

    end;

    function getGraphFileName():string;
    begin
        write('Enter file name: ');
        //readln(result);
        writeln('graph1.txt');
        result := 'graph1.txt';
    end;

    procedure LoadGraph(graph : GraphModel);
    var
        f : text;
        fileName : string;
        point1, point2, weight : integer;
    begin
        fileName := getGraphFileName();
        assign(f, fileName);
        reset(f);
        while (not eof(f)) do
        begin
            readln(f, point1, point2, weight);
            if ((point1 = 0) AND (point2 = 0)) then
                continue; // Просто пустая строка
            //writeln(point1, ' ', point2, ' w=', weight);
            graph.AddEdge(point1, point2, weight);
        end;
        CloseFile(f);
        //writeln('numEdges = ', graph.GetNumEdges);
        //writeln('numPoints = ', graph.GetNumPoints);
    end;

    type
        Task1 = class
            private
                _graph : GraphModel;
                _bestPath : array[0 .. MAX_POINTS] of integer;
                _bestPathLength : integer;
                _bestPathWeight : integer;
                _currentPath : array[0 .. MAX_POINTS] of integer;
                _currentPathLength : integer;
                _currentPathWeight : integer;
            public
                constructor Create(graph : GraphModel);
                procedure Execute;
                procedure Recursion(point, weight : integer);
                function HasPointCurrentPath(point : integer) : boolean;
                procedure MakeCurrentPathBest;
                procedure PrintBestPath;
                procedure PrintCurrentPath;
        end;

    constructor Task1.Create(graph : GraphModel);
    begin
        _graph := graph;
        _bestPathLength := 0;
        _currentPathLength := 0;
    end;

    procedure Task1.Execute;
    var
        point : integer;
    begin
        for point := 1 to _graph.GetNumPoints() do
        begin
            _currentPathLength := 0;
            Recursion(point, 0);
        end;

        PrintBestPath();
    end;

    procedure Task1.Recursion(point, weight : integer);
    var
        offset : integer;
        edge : GraphEdge;
        hasPoint : boolean;
    begin
        hasPoint := HasPointCurrentPath(point);

        _currentPath[_currentPathLength] := point;
        inc(_currentPathLength);
        inc(_currentPathWeight, weight);
        //PrintCurrentPath();

        if (_currentPathLength > 1) AND (point = _currentPath[0]) then
        begin
            if (_bestPathLength = 0) OR (_currentPathWeight < _bestPathWeight) then
            begin
                MakeCurrentPathBest();
            end;
            dec(_currentPathLength);
            dec(_currentPathWeight, weight);
            exit;
        end;

        if ((hasPoint) OR (_currentPathLength > MAX_POINTS)
            OR ((_bestPathLength > 0) AND (_currentPathWeight >= _bestPathWeight))) then
        begin
            dec(_currentPathLength);
            dec(_currentPathWeight, weight);
            exit;
        end;

        offset := _graph.GetNextOutgoingEdgeIndex(point, -1);
        while (offset <> -1) do
        begin
            edge := _graph.GetEdge(offset);
            Recursion(edge.point2, edge.weight);
            offset := _graph.GetNextOutgoingEdgeIndex(point, offset);
        end;
        dec(_currentPathLength);
        dec(_currentPathWeight, weight);
    end;

    function Task1.HasPointCurrentPath(point : integer) : boolean;
    var
        index : integer;
    begin
        result := false;
        for index := 0 to _currentPathLength - 1 do
            if (_currentPath[index] = point) then
            begin
                result := true;
                break;
            end;
    end;

    procedure Task1.MakeCurrentPathBest;
    var
        index : integer;
    begin
        //writeln('Save best result');
        for index := 0 to _currentPathLength - 1 do
            _bestPath[index] := _currentPath[index];
        _bestPathLength := _currentPathLength;
        _bestPathWeight := _currentPathWeight;
    end;

    procedure Task1.PrintBestPath;
    var
        index : integer;
    begin
        if (_bestPathLength > 0) then
        begin
            write('The shortest path is: ');
            for index := 0 to _bestPathLength - 1 do
            begin
                if (index > 0) then
                    write(' -> ');
                write(_bestPath[index]);
            end;
            writeln();
            writeln('The best cycle weight is ', _bestPathWeight);
        end
        else
            writeln('There is no cycle, sorry.');
    end;

    procedure Task1.PrintCurrentPath;
    var
        index : integer;
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
            //writeln('The current cycle weight is ', _currentPathWeight);
        end
        else
            writeln('There is no cycle, sorry.');
    end;

var
    graph : GraphModel;
    t1 : Task1;
begin
    graph := GraphModel.Create();
    LoadGraph(graph);
    t1 := Task1.Create(graph);
    t1.Execute();
end.