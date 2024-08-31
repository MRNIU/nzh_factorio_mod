-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

require("time.control")
require("startup.control")
require("startup_items.control")
require("long_reach.control")

--------------------------------------------------------------------------------------
local function OnInit()
    if remote.interfaces["freeplay"] then
        -- 不生成飞船残骸
        remote.call("freeplay", "set_disable_crashsite", true)
        -- 跳过开场介绍
        remote.call("freeplay", "set_skip_intro", true)
    end

    NZH_time_on_init()
    long_reach_OnPlayerFirstJoinedGame()
end

--------------------------------------------------------------------------------------
local function OnConfigurationChanged(_data)
    NZH_time_on_configuration_changed()
    long_reach_OnPlayerFirstJoinedGame()
end

--------------------------------------------------------------------------------------
local function OnPlayerCreated(event)
    NZH_time_on_player_created(event)
    startup_OnPlayerFirstJoinedGame(event)
    startup_items_OnPlayerFirstJoinedGame(event)
end

--------------------------------------------------------------------------------------
local function OnPlayerJoinedGame(event)
    NZH_time_on_player_joined_game(event)
    startup_OnPlayerFirstJoinedGame(event)
    startup_items_OnPlayerFirstJoinedGame(event)
end

--------------------------------------------------------------------------------------
local function OnTick(event)
    NZH_time_on_tick(event)
end

--------------------------------------------------------------------------------------
local function OnGuiClick(event)
    NZH_time_on_gui_click(event)
end

--------------------------------------------------------------------------------------
local function OnRuntimeModSettingChanged()
    long_reach_OnPlayerFirstJoinedGame()
end

--------------------------------------------------------------------------------------
script.on_init(OnInit)
script.on_configuration_changed(OnConfigurationChanged)
script.on_event(defines.events.on_player_created, OnPlayerCreated)
script.on_event(defines.events.on_player_joined_game, OnPlayerJoinedGame)
script.on_event(defines.events.on_tick, OnTick)
script.on_event(defines.events.on_gui_click, OnGuiClick)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnRuntimeModSettingChanged)
