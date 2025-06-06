%%--------------------------------------------------------------------
%% %CopyrightBegin%
%%
%% SPDX-License-Identifier: Apache-2.0
%%
%% Copyright Ericsson AB 2008-2025. All Rights Reserved.
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
%%----------------------------------------------------------------------
%% File    : xmerl_sax_parser.hrl
%% Description : 
%%
%% Created : 25 Jun 2008 
%%----------------------------------------------------------------------
%%======================================================================
%% Include files
%%======================================================================


%%======================================================================
%% Macros
%%======================================================================

%%----------------------------------------------------------------------
%% Definition of XML whitespace characters. These are 'space', 
%% 'carriage return', 'line feed' and 'tab'
%%----------------------------------------------------------------------
-define(is_whitespace(C), C=:=?space ; C=:=?cr ; C=:=?lf ; C=:=?tab).
-define(space, 32).
-define(cr,    13).
-define(lf,    10).
-define(tab,   9).

%%----------------------------------------------------------------------
%% Definition of hexadecimal digits
%%----------------------------------------------------------------------
-define(is_hex_digit(C), $0 =< C, C =< $9; $a =< C, C =< $f; $A =< C, C =< $F). 

%%----------------------------------------------------------------------
%% Definition of XML characters
%%
%% [2] Char #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
%%----------------------------------------------------------------------
-define(is_char(C), ?space =< C, C =< 55295; C=:=?cr ; C=:=?lf ; C=:=?tab;
       57344 =< C, C =< 65533; 65536 =< C, C =< 1114111).

%% non-characters according to Unicode: 16#ffff and 16#fffe
%% -define(non_character(H1,H2), H1==16#ff,H2==16#fe;H1==16#ff,H2==16#ff).
%% -define(non_ascii(H), list(H),hd(H)>=128;integer(H),H>=128).

%%----------------------------------------------------------------------
%% Error handling
%%----------------------------------------------------------------------
-define(fatal_error(State, Reason), 
	throw({fatal_error, {State, Reason}})).

%%======================================================================
%% Records
%%======================================================================

%%----------------------------------------------------------------------
%% State record for the SAX parser
%%----------------------------------------------------------------------
-record(xmerl_sax_parser_state,
        {
         event_state,               % User state for events
         event_fun,                 % Fun used for each event
         continuation_state,        % User state for continuation calls
         continuation_fun,          % Fun used to fetch more input
         encoding=utf8,             % Which encoding is used
         line_no = 1,               % Current line number
         ns = [],                   % List of current namespaces
         current_tag = [],          % Current tag 
         end_tags = [],             % Stack of tags used for end tag matching 
         match_end_tags = true,     % Flag which defines if the parser should match on end tags
         ref_table,                 % Table containing entitity definitions
         standalone = no,           % yes if the document is standalone and don't need an external DTD.
         file_type = normal,        % Can be normal, dtd and entity
         current_location,          % Location of the currently parsed XML entity
         entity,                    % Parsed XML entity
         skip_external_dtd = false, % If true the external DTD is skipped during parsing
         input_type,                % Source type: file | stream
         attribute_values = [],     % default attribute values
         allow_entities = true,     % If true entities are allowed in the document
         entity_recurse_limit = 3,  % How many levels of recursion is allowed for entities
         external_entities = none,  % Which types of external entities are allowed: all, file or none(default)
         fail_undeclared_ref = true, % If false the reference will be left unresolved in the document, true is default
         discard_ws_before_xml_document = false % If true allow whitespace fefore the xml tag
        }).
