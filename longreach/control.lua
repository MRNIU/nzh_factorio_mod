-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

require "util"
require "event"

local function apply_settings()
	game.forces["player"].character_build_distance_bonus = 9999
	game.forces["player"].character_item_drop_distance_bonus = 9999
	game.forces["player"].character_reach_distance_bonus = 9999
	game.forces["player"].character_resource_reach_distance_bonus = 9999
end

local function set_join_options(event)
	apply_settings()

	-- an earlier version of this mod set these two settings, and causes major game lag if 1000. Ajust them to something acceptable
	if game.players[event.player_index].force_item_pickup_distance_bonus > 10 then
		game.players[event.player_index].force_item_pickup_distance_bonus = 1
	end
	if game.players[event.player_index].force_loot_pickup_distance_bonus > 10 then
		game.players[event.player_index].force_loot_pickup_distance_bonus = 1
	end
end

function NZH_longreach_on_init()
	apply_settings()
end

function NZH_longreach_on_configuration_changed()
	apply_settings()
end

Event.register(defines.events.on_player_joined_game, set_join_options)
