%% -------------------------------------------------------------------
%%
%% count_incr_fsm_sup: One-for-one supervisor for per request increment fsm
%%
%% Copyright (c) 2007-2012 Basho Technologies, Inc.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

-module(count_incr_fsm_sup).
-behaviour(supervisor).

-export([start_incr_fsm/2]).
-export([start_link/0]).
-export([init/1]).

start_incr_fsm(Node, Args) ->
    supervisor:start_child({?MODULE, Node}, Args).

%% @spec start_link() -> ServerRet
%% @doc API for starting the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec init([]) -> SupervisorTree
%% @doc supervisor callback.
init([]) ->
    IncrFsmSpec = {undefined,
               {count_incr_fsm, start_link, []},
               temporary, 5000, worker, [count_incr_update_fsm]},

    {ok, {{simple_one_for_one, 10, 10}, [IncrFsmSpec]}}.
