-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

local function main()
	game.forces["player"].character_build_distance_bonus = 16384
	game.forces["player"].character_reach_distance_bonus = 16384
	game.forces["player"].character_resource_reach_distance_bonus = 16384
	game.forces["player"].character_item_drop_distance_bonus = 16384
end

function long_reach_OnPlayerFirstJoinedGame()
	main()
end


script.on_init(function ()
	apply_long_reach_settings()	
end)

script.on_configuration_changed(function (data)
	apply_long_reach_settings()		
end)

script.on_event(defines.events.on_runtime_mod_setting_changed,function ()
	apply_long_reach_settings()
end)

function apply_long_reach_settings()
	game.forces["player"].character_build_distance_bonus = 16384
	game.forces["player"].character_reach_distance_bonus = 16384
end
