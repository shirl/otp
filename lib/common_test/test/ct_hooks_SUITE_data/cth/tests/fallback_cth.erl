%%
%% %CopyrightBegin%
%%
%% SPDX-License-Identifier: Apache-2.0
%%
%% Copyright Ericsson AB 2010-2025. All Rights Reserved.
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


-module(fallback_cth).


-include_lib("common_test/src/ct_util.hrl").
-include_lib("common_test/include/ct_event.hrl").


%% CT Hooks
-compile(export_all).

id(Opts) ->
    empty_cth:id(Opts).

init(Id, Opts) ->
    empty_cth:init(Id, Opts).

pre_init_per_suite(Suite, Config, State) ->
    empty_cth:pre_init_per_suite(Suite,Config,State).

post_init_per_suite(Suite,Config,Return,State) ->
    empty_cth:post_init_per_suite(Suite,Config,Return,State).

pre_end_per_suite(Suite,Config,State) ->
    empty_cth:pre_end_per_suite(Suite,Config,State).

post_end_per_suite(Suite,Config,Return,State) ->
    empty_cth:post_end_per_suite(Suite,Config,Return,State).

pre_init_per_group(Group,Config,State) ->
    empty_cth:pre_init_per_group(fallback_nosuite,Group,Config,State).

post_init_per_group(Group,Config,Return,State) ->
    empty_cth:post_init_per_group(fallback_nosuite,Group,Config,Return,State).

pre_end_per_group(Group,Config,State) ->
    empty_cth:pre_end_per_group(fallback_nosuite,Group,Config,State).

post_end_per_group(Group,Config,Return,State) ->
    empty_cth:post_end_per_group(fallback_nosuite,Group,Config,Return,State).

pre_init_per_testcase(TC,Config,State) ->
    empty_cth:pre_init_per_testcase(fallback_nosuite,TC,Config,State).

post_init_per_testcase(TC,Config,Return,State) ->
    empty_cth:post_init_per_testcase(fallback_nosuite,TC,Config,Return,State).

pre_end_per_testcase(TC,Config,State) ->
    empty_cth:pre_end_per_testcase(fallback_nosuite,TC,Config,State).

post_end_per_testcase(TC,Config,Return,State) ->
    empty_cth:post_end_per_testcase(fallback_nosuite,TC,Config,Return,State).

on_tc_fail(TC, Reason, State) ->
    empty_cth:on_tc_fail(fallback_nosuite,TC,Reason,State).

on_tc_skip(TC, Reason, State) ->
    empty_cth:on_tc_skip(fallback_nosuite,TC,Reason,State).

terminate(State) ->
    empty_cth:terminate(State).
