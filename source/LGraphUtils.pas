{****************************************************************************
*                                                                           *
*   This file is part of the LGraphs package.                               *
*   Most common graph types and utils.                                      *
*                                                                           *
*   Copyright(c) 2018 A.Koverdyaev(avk)                                     *
*                                                                           *
*   This code is free software; you can redistribute it and/or modify it    *
*   under the terms of the Apache License, Version 2.0;                     *
*   You may obtain a copy of the License at                                 *
*     http://www.apache.org/licenses/LICENSE-2.0.                           *
*                                                                           *
*  Unless required by applicable law or agreed to in writing, software      *
*  distributed under the License is distributed on an "AS IS" BASIS,        *
*  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. *
*  See the License for the specific language governing permissions and      *
*  limitations under the License.                                           *
*                                                                           *
*****************************************************************************}
unit LGraphUtils;

{$mode objfpc}{$H+}
{$INLINE ON}
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH NESTEDPROCVARS}

interface

uses
  Classes,
  SysUtils,
  math,
  LGUtils,
  {%H-}LGHelpers,
  LGArrayHelpers,
  LGStack,
  LGQueue,
  LGStrConst;

type

  ELGGraphError = class(Exception); //???

  TEmptyRec     = record end;

  TIntArray     = array of SizeInt;
  TShortArray   = array of ShortInt;
  TIntHelper    = specialize TGNumArrayHelper<SizeInt>;
  TIntStack     = specialize TGLiteStack<SizeInt>;
  TIntQueue     = specialize TGLiteQueue<SizeInt>;

  TOnIntVisit   = procedure (aValue: SizeInt) of object;
  TOnIntTest    = function (aValue: SizeInt): Boolean of object;

  generic TGOnAddEdge<T> = procedure(aSrc, aDst: SizeInt; aData: Pointer) of object;

  { TDisjointSetUnion }

  TDisjointSetUnion = record
  private
    FTree: array of SizeInt;
    function  GetSize: SizeInt; inline;
    procedure SetSize(aValue: SizeInt);
  public
    procedure Clear; inline;
    function  FindSet(aValue: SizeInt): SizeInt;
    procedure Union(L, R: SizeInt);
    property  Size: SizeInt read GetSize write SetSize;
  end;

implementation
{$B-}{$COPERATORS ON}

{ TDisjointSetUnion }

function TDisjointSetUnion.GetSize: SizeInt;
begin
  Result := System.Length(FTree);
end;

procedure TDisjointSetUnion.SetSize(aValue: SizeInt);
var
  OldSize, I: SizeInt;
begin
  OldSize := Size;
  if aValue > OldSize then
    begin
      System.SetLength(FTree, aValue);
      for I := OldSize to Pred(aValue) do
        FTree[I] := I;
    end;
end;

procedure TDisjointSetUnion.Clear;
begin
  FTree := nil;
end;

function TDisjointSetUnion.FindSet(aValue: SizeInt): SizeInt;
begin
  if FTree[aValue] = aValue then
    exit(aValue);
  Result := FindSet(FTree[aValue]);
  FTree[aValue] := Result;
end;

procedure TDisjointSetUnion.Union(L, R: SizeInt);
begin
  L := FindSet(L);
  R := FindSet(R);
  if Odd(Random(1000000)) then // random selection ???
    FTree[L] := R
  else
    FTree[R] := L;
end;

end.

