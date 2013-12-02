unit TaskBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel;

type

  ITask = Interface ['{a128105a-da52-4e13-9e6a-1a1b797d64cf}']
    procedure Execute;

  end;

  ITaskBestPath = Interface(ITask) ['{39f109ca-25be-4f3d-abf3-0f09957869cc}']
    function GetBestPath: TGraphPath;
  end;

implementation

end.

