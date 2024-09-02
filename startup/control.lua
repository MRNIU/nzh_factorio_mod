-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

require("items")
require("blue_prints")
require("functions")
require("base_level1")
require("base_level4")

local startup_is_area_inited = false

local function main(player)
	if startup_is_area_inited == true then
		return
	end
	if player == nil then return end


	local base_level = settings.startup["nzh_startup_base_level"].value
	
	if base_level == 1 then
		base_level1(player.surface)
	elseif base_level == 2 then
		-- @todo
	elseif base_level == 3 then
		-- @todo
	elseif base_level == 4 then
		base_level4(player.surface)
	end

	startup_is_area_inited = true
end

function startup_OnPlayerFirstJoinedGame(event)
	main(game.get_player(event.player_index))
end
