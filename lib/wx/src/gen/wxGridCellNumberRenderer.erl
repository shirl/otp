%%
%% %CopyrightBegin%
%%
%% SPDX-License-Identifier: Apache-2.0
%%
%% Copyright Ericsson AB 2009-2025. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% %CopyrightEnd%
%% This file is generated DO NOT EDIT

-module(wxGridCellNumberRenderer).
-moduledoc """
This class may be used to format integer data in a cell.

See:
* `m:wxGridCellRenderer`

* `m:wxGridCellBoolRenderer`

* `m:wxGridCellFloatRenderer`

* `m:wxGridCellStringRenderer`

This class is derived, and can use functions, from:

* `m:wxGridCellStringRenderer`

* `m:wxGridCellRenderer`

wxWidgets docs: [wxGridCellNumberRenderer](https://docs.wxwidgets.org/3.2/classwx_grid_cell_number_renderer.html)
""".
-include("wxe.hrl").
-export([destroy/1,new/0]).

%% inherited exports
-export([draw/8,getBestSize/6,parent_class/1]).

-type wxGridCellNumberRenderer() :: wx:wx_object().
-export_type([wxGridCellNumberRenderer/0]).
-doc false.
parent_class(wxGridCellStringRenderer) -> true;
parent_class(wxGridCellRenderer) -> true;
parent_class(_Class) -> erlang:error({badtype, ?MODULE}).

-doc "Default constructor.".
-spec new() -> wxGridCellNumberRenderer().
new() ->
  wxe_util:queue_cmd(?get_env(), ?wxGridCellNumberRenderer_new),
  wxe_util:rec(?wxGridCellNumberRenderer_new).

-doc "Destroys the object".
-spec destroy(This::wxGridCellNumberRenderer()) -> 'ok'.
destroy(Obj=#wx_ref{type=Type}) ->
  ?CLASS(Type,wxGridCellNumberRenderer),
  wxe_util:queue_cmd(Obj, ?get_env(), ?wxGridCellNumberRenderer_destroy),
  ok.
 %% From wxGridCellStringRenderer
 %% From wxGridCellRenderer
-doc false.
getBestSize(This,Grid,Attr,Dc,Row,Col) -> wxGridCellRenderer:getBestSize(This,Grid,Attr,Dc,Row,Col).
-doc false.
draw(This,Grid,Attr,Dc,Rect,Row,Col,IsSelected) -> wxGridCellRenderer:draw(This,Grid,Attr,Dc,Rect,Row,Col,IsSelected).
