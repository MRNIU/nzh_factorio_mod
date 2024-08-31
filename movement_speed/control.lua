-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

local -- Forward declarations
reset_all_active_players,
reset_active_player,
register_on_tick_handler,
on_tick

local is_tick_registered = false

reset_all_active_players = function()
	global.active_players = {}
	for _, player in pairs(game.players) do
		reset_active_player(player)
	end
end

reset_active_player = function(player)
	local global_settings = settings.global
	local player_settings = settings.get_player_settings(player)

	local is_active = global_settings['adaptive-movement-speed-global-enabled'].value and
		player_settings['adaptive-movement-speed-enabled'].value and
		player.connected

	if is_active then
		local maximum_speed = 1000
		local base_speed = 100
		local speed_up_rate = 1 / 300
		local cool_down_factor = math.pow(0.05, 1 / 120)

		global.active_players[player.index] = {
			player = player,
			progress = 0,

			base_speed = base_speed * 0.01,
			maximum_speed = maximum_speed * 0.01,
			speed_up_rate = speed_up_rate,
			cool_down_factor = cool_down_factor,
		}
	else
		global.active_players[player.index] = nil
		if player.character then
			player.character_running_speed_modifier = 0
		end
	end
end

on_tick = function(event)
	local global_settings = settings.global
	local disable_upon_taking_damage_ticks = math.floor(60 *
		global_settings['adaptive-movement-speed-global-disable-upon-taking-damage'].value + 0.5)
	for player_index, active_player in pairs(global.active_players) do
		if not active_player.player then
			local new_player = game.get_player(player_index)
			if new_player then
				active_player.player = new_player
			else
				reset_all_active_players()
				register_on_tick_handler()
				return
			end
		end

		local character = active_player.player.character
		if character then
			if character.tick_of_last_damage + disable_upon_taking_damage_ticks >= event.tick then
				active_player.progress = 0
			elseif character.walking_state.walking then
				active_player.progress = math.min(
					1,
					active_player.progress + active_player.speed_up_rate
				)
			else
				active_player.progress = math.max(
					0,
					active_player.progress * active_player.cool_down_factor
				)
				if active_player.progress < 0.001 then
					active_player.progress = 0
				end
			end

			character.character_running_speed_modifier =
				active_player.base_speed * (1 - active_player.progress) +
				active_player.maximum_speed * active_player.progress -
				1
		else
			active_player.progress = 0
		end
	end
end

register_on_tick_handler = function()
	if next(global.active_players) then
		if not is_tick_registered then
			is_tick_registered = true
			script.on_event(defines.events.on_tick, on_tick)
		end
	elseif is_tick_registered then
		is_tick_registered = false
		script.on_event(defines.events.on_tick, nil)
	end
end

script.on_load(function()
	register_on_tick_handler()
end)

local is_inited = {}

local function main(player)
	if player == nil then return end

	if is_inited[player.index] == true then
		return
	end

	reset_active_player(player)
	register_on_tick_handler()
end

function movement_speed_OnPlayerFirstJoinedGame(event)
	main(game.get_player(event.player_index))
end
