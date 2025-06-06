%%
%% %CopyrightBegin%
%%
%% SPDX-License-Identifier: Apache-2.0
%% 
%% Copyright Ericsson AB 1997-2025. All Rights Reserved.
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
-module(inet_tcp).
-moduledoc false.

%% Socket server for TCP/IP

-export([connect/3, connect/4, listen/2, accept/1, accept/2, close/1]).
-export([send/2, send/3, recv/2, recv/3, unrecv/2]).
-export([shutdown/2]).
-export([controlling_process/2]).
-export([fdopen/2]).

-export([family/0, mask/2, parse_address/1]). % inet_tcp_dist
-export([getserv/1, getaddr/1, getaddr/2, getaddrs/1, getaddrs/2]).
-export([translate_ip/1]).

-include("inet_int.hrl").

-define(FAMILY, inet).
-define(PROTO,  tcp).
-define(TYPE,   stream).

%% -define(DBG(T), erlang:display({{self(), ?MODULE, ?LINE, ?FUNCTION_NAME}, T})).


%% my address family
family() -> ?FAMILY.

%% Apply netmask on address
mask({M1,M2,M3,M4}, {IP1,IP2,IP3,IP4}) ->
    {M1 band IP1,
     M2 band IP2,
     M3 band IP3,
     M4 band IP4}.

%% Parse address string
parse_address(Host) ->
    inet_parse:ipv4strict_address(Host).

%% inet_tcp port lookup
getserv(Port) when is_integer(Port) -> {ok, Port};
getserv(Name) when is_atom(Name) -> inet:getservbyname(Name, ?PROTO).

%% inet_tcp address lookup
getaddr(Address) -> inet:getaddr(Address, ?FAMILY).
getaddr(Address, Timer) -> inet:getaddr_tm(Address, ?FAMILY, Timer).

%% inet_tcp address lookup
getaddrs(Address) -> inet:getaddrs(Address, ?FAMILY).
getaddrs(Address, Timer) -> inet:getaddrs_tm(Address, ?FAMILY, Timer).

%% inet_udp special this side addresses
translate_ip(IP) -> inet:translate_ip(IP, ?FAMILY).

%%
%% Send data on a socket
%%
send(Socket, Packet, Opts) -> prim_inet:send(Socket, Packet, Opts).
send(Socket, Packet) -> prim_inet:send(Socket, Packet, []).

%%
%% Receive data from a socket (inactive only)
%%
recv(Socket, Length) -> prim_inet:recv(Socket, Length).
recv(Socket, Length, Timeout) -> prim_inet:recv(Socket, Length, Timeout).

unrecv(Socket, Data) -> prim_inet:unrecv(Socket, Data).

%%
%% Shutdown one end of a socket
%%
shutdown(Socket, How) ->
    prim_inet:shutdown(Socket, How).

%%
%% Close a socket (async)
%%
close(Socket) -> 
    inet:tcp_close(Socket).

%%
%% Set controlling process
%%
controlling_process(Socket, NewOwner) ->
    inet:tcp_controlling_process(Socket, NewOwner).

%%
%% Connect
%%
connect(Address, Port, Opts) when is_integer(Port) andalso is_list(Opts) ->
    do_connect(Address, Port, Opts, infinity);
connect(SockAddr, Opts, Time) when is_map(SockAddr) andalso is_list(Opts) ->
    do_connect(SockAddr, Opts, Time).

connect(Address, Port, Opts, infinity) ->
    do_connect(Address, Port, Opts, infinity);
connect(Address, Port, Opts, Timeout)
  when is_integer(Timeout), Timeout >= 0 ->
    do_connect(Address, Port, Opts, Timeout).

do_connect(#{addr := {A,B,C,D},
             port := Port} = SockAddr, Opts, Time)
  when ?ip(A,B,C,D) andalso ?port(Port) ->
    do_connect2(SockAddr, Opts, Time);
do_connect(#{addr := Addr,
             port := Port} = SockAddr, Opts, Time)
  when (Addr =:= loopback) andalso ?port(Port) ->
    do_connect2(SockAddr, Opts, Time).

do_connect2(SockAddr, Opts, Time) ->
    case inet:connect_options(Opts, ?MODULE) of
	{error, Reason} -> exit(Reason);
	{ok,
	 #connect_opts{fd     = Fd,
                       ifaddr = BAddr,
                       port   = BPort,
                       opts   = SockOpts}}
          when is_map(BAddr); % sockaddr_in()
               ?port(BPort), ?ip(BAddr);
               ?port(BPort), BAddr =:= undefined ->
	    case
                inet:open(
                  Fd, BAddr, BPort, SockOpts,
                  ?PROTO, ?FAMILY, ?TYPE, ?MODULE)
            of
		{ok, S} ->
		    case prim_inet:connect(S, SockAddr, Time) of
			ok -> {ok,S};
			Error -> prim_inet:close(S), Error
		    end;
		Error -> Error
	    end;
	{ok, _} -> exit(badarg)
    end.

do_connect(Addr = {A,B,C,D}, Port, Opts, Time)
  when ?ip(A,B,C,D), ?port(Port) ->
    case inet:connect_options(Opts, ?MODULE) of
	{error, Reason} -> exit(Reason);
	{ok,
	 #connect_opts{
	    fd = Fd,
	    ifaddr = BAddr,
	    port = BPort,
	    opts = SockOpts}}
          when ?port(BPort), ?ip(BAddr);
               ?port(BPort), BAddr =:= undefined ->
	    case
                inet:open(
                  Fd, BAddr, BPort, SockOpts,
                  ?PROTO, ?FAMILY, ?TYPE, ?MODULE)
            of
		{ok, S} ->
		    case prim_inet:connect(S, Addr, Port, Time) of
			ok -> {ok,S};
			Error -> prim_inet:close(S), Error
		    end;
		Error -> Error
	    end;
	{ok, _} -> exit(badarg)
    end.

%% 
%% Listen
%%
listen(Port, Opts) ->
    %% ?DBG([{port, Port}, {opts, Opts}]),
    case inet:listen_options([{port,Port} | Opts], ?MODULE) of
	{error, Reason} -> exit(Reason);
	{ok,
	 #listen_opts{
	    fd = Fd,
	    ifaddr = BAddr,
	    port = BPort,
	    opts = SockOpts} = R}
          when is_map(BAddr); % sockaddr_in()
               ?port(BPort), ?ip(BAddr);
               ?port(BPort), BAddr =:= undefined ->
            %% ?DBG([{fd, Fd},
            %%       {baddr, BAddr},
            %%       {bport, BPort},
            %%       {sock_opts, SockOpts}]),
	    case
                inet:open_bind(
                  Fd, BAddr, BPort, SockOpts,
                  ?PROTO, ?FAMILY, ?TYPE, ?MODULE)
            of
		{ok, S} ->
		    case prim_inet:listen(S, R#listen_opts.backlog) of
			ok ->
                            {ok, S};
			Error ->
                            %% ?DBG(["prim inet listen error", {error, Error}]),
                            prim_inet:close(S), Error
		    end;
		Error ->
                    %% ?DBG(["open bind error", {error, Error}]),
                    Error
	    end;
	{ok, _} ->
            %% ?DBG([{bad_listen_opts, _LO}]),
            exit(badarg)
    end.

%%
%% Accept
%%
accept(L) ->
    case prim_inet:accept(L, accept_family_opts()) of
	{ok, S} ->
	    inet_db:register_socket(S, ?MODULE),
	    {ok,S};
	Error -> Error
    end.

accept(L, Timeout) ->
    case prim_inet:accept(L, Timeout, accept_family_opts()) of
	{ok, S} ->
	    inet_db:register_socket(S, ?MODULE),
	    {ok,S};
	Error -> Error
    end.

accept_family_opts() -> [tos, ttl, recvtos, recvttl].

%%
%% Create a port/socket from a file descriptor 
%%
fdopen(Fd, Opts) ->
    inet:fdopen(Fd, Opts, ?PROTO, ?FAMILY, ?TYPE, ?MODULE).
