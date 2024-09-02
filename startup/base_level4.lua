-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

require("items")
require("level4bp")
require("functions")

-- 设置初始区域
function base_level4(surface)
	local area = {
		left_top = { -1700, -1700 },
		right_bottom = { -1, -1 }
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
		SolarArray10_8MW, false, false)
	PlaceBlueprint(surface, { x = area.left_top[1] + 38.5, y = area.right_bottom[2] - 38.5 - 1 }, game.players[1],
		SolarArray10_8MW, false, false)
	PlaceBlueprint(surface, { x = area.right_bottom[1] - 38.5 - 1, y = area.left_top[2] + 38.5 }, game.players[1],
		SolarArray10_8MW, false, false)
	PlaceBlueprint(surface, { x = area.right_bottom[1] - 38.5 - 1, y = area.right_bottom[2] - 38.5 - 1 }, game.players
		[1],
		SolarArray10_8MW, false, false)

	PlaceBlueprint(surface, { 0, 0 }, game.players[1], BaseBlueprint, false, true)

	-- 添加围墙
	for x = area.left_top[1], area.right_bottom[1] - 1 do
		local stone_wall = surface.create_entity({
			name = "stone-wall",
			position = { x, area.left_top[2] },
			force = game.forces.player
		})
		stone_wall.destructible = false

		local stone_wall2 = surface.create_entity({
			name = "stone-wall",
			position = { x, area.left_top[2] + 2 },
			force = game.forces.player
		})
		stone_wall2.destructible = false
	end
	for x = area.left_top[1], area.right_bottom[1] - 1 do
		local stone_wall = surface.create_entity({
			name = "stone-wall",
			position = { x, area.right_bottom[2] - 1 },
			force = game.forces.player
		})
		stone_wall.destructible = false

		local stone_wall2 = surface.create_entity({
			name = "stone-wall",
			position = { x, area.right_bottom[2] - 3 },
			force = game.forces.player
		})
		stone_wall2.destructible = false
	end
	for y = area.left_top[2], area.right_bottom[2] - 1 do
		local stone_wall = surface.create_entity({
			name = "stone-wall",
			position = { area.left_top[1], y },
			force = game.forces.player
		})
		if stone_wall ~= nil then
			stone_wall.destructible = false
		end

		local stone_wall2 = surface.create_entity({
			name = "stone-wall",
			position = { area.left_top[1] + 2, y },
			force = game.forces.player
		})
		if stone_wall2 ~= nil then
			stone_wall2.destructible = false
		end
	end
	for y = area.left_top[2], area.right_bottom[2] - 1 do
		local stone_wall = surface.create_entity({
			name = "stone-wall",
			position = { area.right_bottom[1] - 1, y },
			force = game.forces.player
		})
		if stone_wall ~= nil then
			stone_wall.destructible = false
		end

		local stone_wall2 = surface.create_entity({
			name = "stone-wall",
			position = { area.right_bottom[1] - 3, y },
			force = game.forces.player
		})
		if stone_wall2 ~= nil then
			stone_wall2.destructible = false
		end
	end

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
end
