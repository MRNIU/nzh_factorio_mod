
require("utils")


--------------------------------------------------------------------------------------
local function init_globals()
	if global.display == nil then global.display = true end
	
	global.speed_mem = global.speed_mem or settings.global["timetools-maximum-speed"].value
end

--------------------------------------------------------------------------------------
local function init_player(player)
	
	-- initialize or update per player globals of the mod, and reset the gui
	
	if player.connected then
		build_gui(player)
	end
end

--------------------------------------------------------------------------------------
local function init_players()
	for _, player in pairs(game.players) do
		init_player(player)
	end
end


--------------------------------------------------------------------------------------
local function on_init() 
	-- called once, the first time the mod is loaded on a game (new or existing game)
	init_globals()
	init_players()
end

script.on_init(on_init)

--------------------------------------------------------------------------------------
local function on_configuration_changed(data)
	-- detect any mod or game version change
	if data.mod_changes ~= nil then
		if changes ~= nil then
			init_globals()
			

			-- migrations
			for _, player in pairs(game.players) do
				if player.gui.top.timebar_frame then player.gui.top.timebar_frame.destroy() end -- destroy old bar
			end

			init_players()

			update_guis()			
		end
	end
end

script.on_configuration_changed(on_configuration_changed)

--------------------------------------------------------------------------------------
local function on_player_created(event)
	-- called at player creation
	local player = game.players[event.player_index]
	
	init_player(player)
end

script.on_event(defines.events.on_player_created, on_player_created )

--------------------------------------------------------------------------------------
local function on_player_joined_game(event)
	-- called in SP(once) and MP(every connect), eventually after on_player_created
	local player = game.players[event.player_index]
	
	init_player(player)
end

script.on_event(defines.events.on_player_joined_game, on_player_joined_game )


--------------------------------------------------------------------------------------

local function on_tick(event)
	if global.speed_mem > settings.global["timetools-maximum-speed"].value then
		-- User changed the speed mid acceleration or on the fly
		global.speed_mem = settings.global["timetools-maximum-speed"].value
		if  game.speed > global.speed_mem then
			game.speed = global.speed_mem
			update_guis()
		end
	end
end

script.on_event(defines.events.on_tick, on_tick)

--------------------------------------------------------------------------------------
local function on_gui_click(event)
	local player = game.players[event.player_index]
	if player.admin then	
		if event.element.name == "timetools_but_slower" then
			if game.speed >= 0.2 then game.speed = game.speed / 2 end -- minimum 0.1
			if game.speed ~= 1 then global.speed_mem = game.speed end
			update_guis()
		elseif event.element.name == "timetools_but_faster" then
			if game.speed < settings.global["timetools-maximum-speed"].value then game.speed = game.speed * 2 end
			if game.speed ~= 1 then global.speed_mem = game.speed end
			update_guis()

		elseif event.element.name == "timetools_but_speed" then
			if game.speed == 1 then game.speed = global.speed_mem else game.speed = 1 end
			update_guis()
		end
	else
		player.print({"mod-messages.timetools-message-admins-only"})
	end
end

script.on_event(defines.events.on_gui_click, on_gui_click )

--------------------------------------------------------------------------------------
function build_gui( player )
	local gui = player.gui.top.timetools_flow
	
	if gui == nil and global.display then
		gui = player.gui.top.add({type = "flow", name = "timetools_flow", direction = "horizontal", style = "timetools_flow_style"})
		gui.add({type = "button", name = "timetools_but_slower", caption = "<" , font_color = colors.white, style = "timetools_button_style"})
		gui.add({type = "button", name = "timetools_but_faster", caption = ">" , font_color = colors.white, style = "timetools_button_style"})
		gui.add({type = "button", name = "timetools_but_speed", caption = "x1" , font_color = colors.white, style = "timetools_button_style"})
	end
	return( gui )
end
	
--------------------------------------------------------------------------------------
function update_guis()
	if global.display then
		for _, player in pairs(game.players) do
			if player.connected then
				local flow = build_gui(player)
				local s
				
				if game.speed == 1 then
					flow.timetools_but_speed.caption = "x1"
					flow.timetools_but_speed.style.font_color = colors.white
				elseif game.speed < 1 then
					s = string.format("/%1.0f", 1/game.speed )
					flow.timetools_but_speed.caption = s
					flow.timetools_but_speed.style.font_color = colors.green
				elseif game.speed > 1 then
					s = string.format("x%1.0f", game.speed )
					flow.timetools_but_speed.caption = s
					flow.timetools_but_speed.style.font_color = colors.lightred
				end
			end
		end	
	end
end

--------------------------------------------------------------------------------------

local interface = {}

function interface.reset()
	for _,force in pairs(game.forces) do
		force.reset_recipes()
		force.reset_technologies()
	end
	
	for _, player in pairs(game.players) do
		if player.gui.top.timetools_flow then	
			player.gui.top.timetools_flow.destroy()
		end
	end
	
	update_guis()
end

function interface.setspeed(speed)
	if speed == nil then speed = 1 end
	speed = math.floor(speed) -- ensure integer
	if speed < 1 then speed = 1 end
	if speed > settings.global["timetools-maximum-speed"].value then
		speed = settings.global["timetools-maximum-speed"].value
	end
	global.speed = speed
	update_guis()
end

function interface.off( )
	global.display = false
	
	for _, player in pairs(game.players) do
		if player.connected and player.gui.top.timetools_flow then player.gui.top.timetools_flow.destroy() end
	end
end

function interface.on( )

	global.display = true
	
	update_guis()
end


remote.add_interface( "timetools", interface )
