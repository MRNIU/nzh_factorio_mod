-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

require("utils")

-- 是否绘制 gui
local display = true
-- 将当前游戏速度与上次使用的游戏速度互换
local speed = 1

--------------------------------------------------------------------------------------
local function build_gui(_player)
	local gui = _player.gui.top.nzh_time_flow
	if gui == nil and display then
		gui = _player.gui.top.add({
			type = "flow",
			name = "nzh_time_flow",
			direction = "horizontal",
			style = "nzh_flow_style"
		})
		gui.add({
			type = "button",
			name = "nzh_time_button_slower",
			caption = "<",
			font_color = default,
			style = "nzh_button_style"
		})
		gui.add({
			type = "button",
			name = "nzh_time_button_faster",
			caption = ">",
			font_color = default,
			style = "nzh_button_style"
		})
		gui.add({
			type = "button",
			name = "nzh_time_button_speed",
			caption = "x1",
			font_color = default,
			style = "nzh_button_style"
		})
	end
	return gui
end

--------------------------------------------------------------------------------------
local function update_guis()
	if display then
		for _, player in pairs(game.players) do
			if player.connected then
				local flow = build_gui(player)
				local s

				if game.speed == 1 then
					flow.nzh_time_button_speed.caption = "x1"
				elseif game.speed < 1 then
					s = string.format("/%1.0f", 1 / game.speed)
					flow.nzh_time_button_speed.caption = s
				elseif game.speed > 1 then
					s = string.format("x%1.0f", game.speed)
					flow.nzh_time_button_speed.caption = s
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------
local function init_player(_player)
	-- initialize or update per player globals of the mod, and reset the gui
	if _player.connected then
		build_gui(_player)
	end
end

--------------------------------------------------------------------------------------
local function init_players()
	for _, player in pairs(game.players) do
		init_player(player)
	end
end

--------------------------------------------------------------------------------------
function NZH_time_on_player_created(_event)
	-- called at player creation
	local player = game.players[_event.player_index]
	init_player(player)
end

--------------------------------------------------------------------------------------
function NZH_time_on_player_joined_game(_event)
	-- called in SP(once) and MP(every connect), eventually after on_player_created
	local player = game.players[_event.player_index]
	init_player(player)
end

--------------------------------------------------------------------------------------
function NZH_time_on_init()
	init_players()
end

--------------------------------------------------------------------------------------
function NZH_time_on_load()
	init_players()
end

--------------------------------------------------------------------------------------
function NZH_time_on_configuration_changed(_data)
	-- detect any mod or game version change
	if _data.mod_changes ~= nil then
		local changes = data.mod_changes[NZH_mod_name]
		if changes ~= nil then
			-- migrations
			for _, player in pairs(game.players) do
				if player.gui.top.timebar_frame then player.gui.top.timebar_frame.destroy() end -- destroy old bar
			end
			init_players()
			update_guis()
		end
	end
end

--------------------------------------------------------------------------------------
function NZH_time_on_tick(_event)
	if speed > settings.global["nzh_time_int_maximum_speed"].value then
		-- User changed the speed mid acceleration or on the fly
		speed = settings.global["nzh_time_int_maximum_speed"].value
		if game.speed > speed then
			game.speed = speed
			update_guis()
		end
	end
end

--------------------------------------------------------------------------------------
function NZH_time_on_gui_click(_event)
	local player = game.players[_event.player_index]
	if player.admin then
		if _event.element.name == "nzh_time_button_slower" then
			if game.speed >= 0.2 then game.speed = game.speed / 2 end -- minimum 0.1
			if game.speed ~= 1 then speed = game.speed end
			update_guis()
		elseif _event.element.name == "nzh_time_button_faster" then
			if game.speed < settings.global["nzh_time_int_maximum_speed"].value then game.speed = game.speed * 2 end
			if game.speed ~= 1 then speed = game.speed end
			update_guis()
		elseif _event.element.name == "nzh_time_button_speed" then
			if game.speed == 1 then game.speed = speed else game.speed = 1 end
			update_guis()
		end
	else
		player.print({ "mod-messages.nzh_time_message_admins_only" })
	end
end

--------------------------------------------------------------------------------------
local nzh_time_interface = {}

function nzh_time_interface.reset()
	for _, force in pairs(game.forces) do
		force.reset_recipes()
		force.reset_technologies()
	end

	for _, player in pairs(game.players) do
		if player.gui.top.nzh_time_flow then
			player.gui.top.nzh_time_flow.destroy()
		end
	end

	update_guis()
end

function nzh_time_interface.setspeed(_speed)
	if _speed == nil then _speed = 1 end
	_speed = math.floor(_speed) -- ensure integer
	if _speed < 1 then _speed = 1 end
	if _speed > settings.global["nzh_time_int_maximum_speed"].value then
		_speed = settings.global["nzh_time_int_maximum_speed"].value
	end
	global.speed = _speed
	update_guis()
end

function nzh_time_interface.off()
	display = false
	for _, player in pairs(game.players) do
		if player.connected and player.gui.top.nzh_time_flow then player.gui.top.nzh_time_flow.destroy() end
	end
end

function nzh_time_interface.on()
	display = true
	update_guis()
end

remote.add_interface("nzh_time", nzh_time_interface)
