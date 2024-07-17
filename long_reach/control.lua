-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

local function main(player)
	for _, player in pairs(game.players) do
		if player.character then
			player.character_build_distance_bonus = 16384
			player.character_reach_distance_bonus = 16384
			player.character_resource_reach_distance_bonus = 16384
			player.character_item_drop_distance_bonus = 16384
		end
	end
end

function long_reach_OnPlayerFirstJoinedGame()
	main(game)
end
