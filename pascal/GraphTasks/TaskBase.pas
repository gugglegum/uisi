unit TaskBase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphModel;

type

  ITask = Interface
    procedure Execute;
  end;

implementation

end.

