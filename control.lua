-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.


-- 游戏速度
require("time/control")
require("startup.control")
require("longreach.control")

--------------------------------------------------------------------------------------
local function nzh_on_init()
    NZH_time_on_init()
    NZH_startup_on_init()
    NZH_longreach_on_init()
end

--------------------------------------------------------------------------------------
local function nzh_on_load()
    NZH_time_on_load()
end

--------------------------------------------------------------------------------------
local function nzh_on_configuration_changed(_data)
    NZH_time_on_configuration_changed(_data)
    NZH_longreach_on_configuration_changed()
end

--------------------------------------------------------------------------------------
local function nzh_on_player_created(_event)
    NZH_time_on_player_created(_event)
end

--------------------------------------------------------------------------------------
local function nzh_on_player_joined_game(_event)
    NZH_time_on_player_joined_game(_event)
end

--------------------------------------------------------------------------------------
local function nzh_on_tick(_event)
    NZH_time_on_tick(_event)
end

--------------------------------------------------------------------------------------
local function nzh_on_gui_click(_event)
    NZH_time_on_gui_click(_event)
end

--------------------------------------------------------------------------------------
script.on_init(nzh_on_init)
script.on_load(nzh_on_load)
script.on_configuration_changed(nzh_on_configuration_changed)
script.on_event(defines.events.on_player_created, nzh_on_player_created)
script.on_event(defines.events.on_player_joined_game, nzh_on_player_joined_game)
script.on_event(defines.events.on_tick, nzh_on_tick)
script.on_event(defines.events.on_gui_click, nzh_on_gui_click)
