%%
%% %CopyrightBegin%
%%
%% SPDX-License-Identifier: Apache-2.0
%%
%% Copyright Ericsson AB 2013-2025. All Rights Reserved.
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
%%
-module(prim_eval).
-moduledoc false.

%% This module is simply a stub which abstract code gets included in the result
%% of compilation of prim_eval.S, to keep Dialyzer happy.

-export(['receive'/2]).

-spec 'receive'(fun((term()) -> nomatch | T), timeout()) -> T.
'receive'(_, _) ->
    erlang:nif_error(stub).
