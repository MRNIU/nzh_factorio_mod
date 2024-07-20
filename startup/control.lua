-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

require("items")

-- 初始化玩家
local function InitPlayer(player)
	if global.startup_is_player_inited[player.index] == true then
		return
	end

	-- 清空已有物品
	player.clear_items_inside()

	-- 背包内物品
	for _, item in ipairs(player_inventory_items) do
		player.insert(item)
	end
	if player.name == "PTRNULL" then
		-- 永续箱
		player.insert { name = "infinity-chest", count = 10 }
		-- 永续管
		player.insert { name = "infinity-pipe", count = 10 }
		-- 极速装卸机
		player.insert { name = "express-loader", count = 10 }
	end

	-- 冲锋枪
	player.get_inventory(defines.inventory.character_guns).insert { name = "submachine-gun", count = 1 }
	-- 贫铀穿甲弹
	player.get_inventory(defines.inventory.character_ammo).insert { name = "uranium-rounds-magazine", count = 200 }
	-- 能量装甲
	player.get_inventory(defines.inventory.character_armor).insert { name = "power-armor-mk2", count = 1 }

	-- 能量装甲内物品
	for _, item in ipairs(power_armor_grid_items) do
		for i = 1, item.count, 1 do
			player.get_inventory(defines.inventory.character_armor)[1].grid.put({ name = item.name })
		end
	end

	-- 创建蜘蛛机甲
	local spidertron = player.surface.create_entity { name = "spidertron", position = player.position, force = game.forces.player }
	-- 蜘蛛机甲内物品
	for _, item in ipairs(spidertron_trunk_items) do
		spidertron.get_inventory(defines.inventory.spider_trunk).insert(item)
	end
	-- 蜘蛛机甲弹药
	spidertron.get_inventory(defines.inventory.spider_ammo).insert { name = "explosive-rocket", count = 200 }
	spidertron.get_inventory(defines.inventory.spider_ammo).insert { name = "explosive-rocket", count = 200 }
	spidertron.get_inventory(defines.inventory.spider_ammo).insert { name = "explosive-rocket", count = 200 }
	spidertron.get_inventory(defines.inventory.spider_ammo).insert { name = "explosive-rocket", count = 200 }
	-- 蜘蛛机甲装备
	for _, item in ipairs(spidertron_grid_items) do
		for i = 1, item.count, 1 do
			spidertron.grid.put({ name = item.name })
		end
	end
	-- 设置驾驶员
	spidertron.set_driver(player)

	global.startup_is_player_inited[player.index] = true
end

-- 生成资源
function GenerateResources(surface, area, resource_name, amount)
	for x = area.left_top[1], area.right_bottom[1] - 1 do
		for y = area.left_top[2], area.right_bottom[2] - 1 do
			surface.create_entity({
				name = resource_name,
				amount = amount,
				position = { x, y },
				force = game.forces.neutral
			})
		end
	end
end

-- 放置蓝图
local function PlaceBlueprint(surface, position, player, blueprint_string)
	local blueprint = player.cursor_stack
	blueprint.import_stack(blueprint_string)

	if blueprint.valid_for_read and blueprint.is_blueprint then
		local entities = blueprint.build_blueprint {
			surface = surface,
			force = game.forces.player,
			position = position,
			force_build = true
		}

		for _, entity in pairs(entities) do
			local _, new_entity = entity.revive()
			new_entity.force = game.forces.player
			new_entity.destructible = false
			new_entity.minable = false
		end
	end
end

-- 设置初始区域
local function ClearAndSetupInitArea(surface)
	if global.startup_is_area_inited == true then
		return
	end

	local area = {
		left_top = { -207, -207 },
		right_bottom = { 207, 207 }
	}

	-- 删除初始区域内的物品
	for _, entity in ipairs(surface.find_entities_filtered { area, force = { game.forces.enemy, game.forces.neutral } }) do
		entity.destroy { do_cliff_correction = true }
	end

	-- 在初始区域铺地砖
	local land_fill_tiles = {}
	for x = area.left_top[1], area.right_bottom[1] - 1 do
		for y = area.left_top[2], area.right_bottom[2] - 1 do
			table.insert(land_fill_tiles, { position = { x, y }, name = "landfill" })
		end
	end
	surface.set_tiles(land_fill_tiles)

	local refined_concrete_tiles = {}
	for x = area.left_top[1], area.right_bottom[1] - 1 do
		for y = area.left_top[2], area.right_bottom[2] - 1 do
			table.insert(refined_concrete_tiles, { position = { x, y }, name = "refined-concrete" })
		end
	end
	surface.set_tiles(refined_concrete_tiles)

	-- 沿边缘建设广域配电站
	for x = area.left_top[1] + 9, area.right_bottom[1] - 1, 18 do
		local substation = surface.create_entity({
			name = "substation",
			position = { x, area.left_top[2] + 9 },
			force = game.forces.player
		})
		substation.destructible = false
		substation.minable = false
	end
	for x = area.left_top[1] + 9, area.right_bottom[1] - 1, 18 do
		local substation = surface.create_entity({
			name = "substation",
			position = { x, area.right_bottom[2] - 9 },
			force = game.forces.player
		})
		substation.destructible = false
		substation.minable = false
	end
	for y = area.left_top[2] + 9, area.right_bottom[2] - 1, 18 do
		local substation = surface.create_entity({
			name = "substation",
			position = { area.left_top[1] + 9, y },
			force = game.forces.player
		})
		substation.destructible = false
		substation.minable = false
	end
	for y = area.left_top[2] + 9, area.right_bottom[2] - 1, 18 do
		local substation = surface.create_entity({
			name = "substation",
			position = { area.right_bottom[1] - 9, y },
			force = game.forces.player
		})
		substation.destructible = false
		substation.minable = false
	end

	-- 添加雷达
	local radar1 = surface.create_entity({
		name = "radar",
		position = { area.left_top[1] + 13, area.left_top[2] + 13 },
		force = game.forces.player
	})
	radar1.destructible = false
	radar1.minable = false
	local radar2 = surface.create_entity({
		name = "radar",
		position = { area.right_bottom[1] - 13 - 1, area.left_top[2] + 13 },
		force = game.forces.player
	})
	radar2.destructible = false
	radar2.minable = false
	local radar3 = surface.create_entity({
		name = "radar",
		position = { area.left_top[1] + 13, area.right_bottom[2] - 13 - 1 },
		force = game.forces.player
	})
	radar3.destructible = false
	radar3.minable = false
	local radar4 = surface.create_entity({
		name = "radar",
		position = { area.right_bottom[1] - 13 - 1, area.right_bottom[2] - 13 - 1 },
		force = game.forces.player
	})
	radar4.destructible = false
	radar4.minable = false
	local radar5 = surface.create_entity({
		name = "radar",
		position = { area.left_top[1] + 13, 0 },
		force = game.forces.player
	})
	radar5.destructible = false
	radar5.minable = false
	local radar6 = surface.create_entity({
		name = "radar",
		position = { area.right_bottom[1] - 13 - 1, 0 },
		force = game.forces.player
	})
	radar6.destructible = false
	radar6.minable = false
	local radar7 = surface.create_entity({
		name = "radar",
		position = { 0, area.left_top[2] + 13 },
		force = game.forces.player
	})
	radar7.destructible = false
	radar7.minable = false
	local radar8 = surface.create_entity({
		name = "radar",
		position = { 0, area.right_bottom[2] - 13 - 1 },
		force = game.forces.player
	})
	radar8.destructible = false
	radar8.minable = false

	-- 放置太阳能
	PlaceBlueprint(surface, { x = area.left_top[1] + 38.5, y = area.left_top[2] + 38.5 }, game.players[1],
		SolarArray10_8MW)
	PlaceBlueprint(surface, { x = area.left_top[1] + 38.5, y = area.right_bottom[2] - 38.5 - 1 }, game.players[1],
		SolarArray10_8MW)
	PlaceBlueprint(surface, { x = area.right_bottom[1] - 38.5 - 1, y = area.left_top[2] + 38.5 }, game.players[1],
		SolarArray10_8MW)
	PlaceBlueprint(surface, { x = area.right_bottom[1] - 38.5 - 1, y = area.right_bottom[2] - 38.5 - 1 }, game.players
		[1],
		SolarArray10_8MW)

	-- 添加资源
	local base_count = 10000
	local grid_size = 32
	local base_left_top_y = -grid_size * 5
	local base_right_bottom_y = -grid_size * 4
	local base_space = 4

	local coal_area = {
		left_top = { -grid_size * 3, base_left_top_y },
		right_bottom = { -grid_size * 2 - base_space, base_right_bottom_y }
	}
	GenerateResources(surface, coal_area, "coal", base_count)

	local copper_ore_area = {
		left_top = { -grid_size * 2, base_left_top_y },
		right_bottom = { -grid_size * 1 - base_space, base_right_bottom_y }
	}
	GenerateResources(surface, copper_ore_area, "copper-ore", base_count)

	local iron_ore_area = {
		left_top = { -grid_size * 1, base_left_top_y },
		right_bottom = { grid_size * 1 - base_space, base_right_bottom_y }
	}
	GenerateResources(surface, iron_ore_area, "iron-ore", base_count)

	local stone_area = {
		left_top = { grid_size * 1, base_left_top_y },
		right_bottom = { grid_size * 2 - base_space, base_right_bottom_y }
	}
	GenerateResources(surface, stone_area, "stone", base_count)

	local uranium_ore_area = {
		left_top = { grid_size * 2, base_left_top_y },
		right_bottom = { grid_size * 3 - base_space, base_right_bottom_y }
	}
	GenerateResources(surface, uranium_ore_area, "uranium-ore", base_count)
	local sulfuric_acid_infinity_pipe = surface.create_entity { name = "infinity-pipe", position = { grid_size * 2, base_left_top_y - 1 }, force = game.forces.player }
	sulfuric_acid_infinity_pipe.set_infinity_pipe_filter { name = "sulfuric-acid", percentage = 1 }
	sulfuric_acid_infinity_pipe.destructible = false
	sulfuric_acid_infinity_pipe.operable = false
	sulfuric_acid_infinity_pipe.minable = false

	local crude_oil_infinity_pipe = surface.create_entity { name = "infinity-pipe", position = { grid_size * 3, base_left_top_y }, force = game.forces.player }
	crude_oil_infinity_pipe.set_infinity_pipe_filter { name = "crude-oil", percentage = 1 }
	crude_oil_infinity_pipe.destructible = false
	crude_oil_infinity_pipe.operable = false
	crude_oil_infinity_pipe.minable = false

	local water_infinity_pipe = surface.create_entity { name = "infinity-pipe", position = { grid_size * 3 + 4, base_left_top_y }, force = game.forces.player }
	water_infinity_pipe.set_infinity_pipe_filter { name = "water", percentage = 1 }
	water_infinity_pipe.destructible = false
	water_infinity_pipe.operable = false
	water_infinity_pipe.minable = false

	global.startup_is_area_inited = true
end

-- 创建初始物品箱
local function AddBox(surface)
	if global.startup_is_box_inited == true then
		return
	end

	local logistic_chest_storage1 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 - 4, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage2 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 - 3, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage3 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 - 2, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage4 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 - 1, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage5 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 + 0, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage6 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 + 1, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage7 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 + 2, y = 0 + 4 }, force = game.forces.player }
	local logistic_chest_storage8 = surface.create_entity { name = "logistic-chest-storage", position = { x = 0 + 3, y = 0 + 4 }, force = game.forces.player }
	for _, item in ipairs(chest1_items) do
		logistic_chest_storage1.insert(item)
	end
	for _, item in ipairs(chest2_items) do
		logistic_chest_storage2.insert(item)
	end
	for _, item in ipairs(chest3_items) do
		logistic_chest_storage3.insert(item)
	end
	for _, item in ipairs(chest4_items) do
		logistic_chest_storage4.insert(item)
	end
	for _, item in ipairs(chest5_items) do
		logistic_chest_storage5.insert(item)
	end
	for _, item in ipairs(chest6_items) do
		logistic_chest_storage6.insert(item)
	end
	for _, item in ipairs(chest7_items) do
		logistic_chest_storage7.insert(item)
	end
	for _, item in ipairs(chest8_items) do
		logistic_chest_storage8.insert(item)
	end
	global.startup_is_box_inited = true
end

local function main(player)
	if player == nil then return end

	if global.startup_is_player_inited == nil then
		global.startup_is_player_inited = {}
		global.startup_is_area_inited = false
		global.startup_is_box_inited = false
	end

	ClearAndSetupInitArea(player.surface)
	InitPlayer(player)
	AddBox(player.surface)
end

function startup_OnPlayerFirstJoinedGame(event)
	main(game.get_player(event.player_index))
end
