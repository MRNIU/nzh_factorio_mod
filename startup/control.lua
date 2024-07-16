-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

-- 背包物品
local player_inventory_items = {
	-- 钢箱
	{ name = "steel-chest",             count = 50 },
	-- 一级组装机
	{ name = "assembling-machine-1",    count = 50 },
	-- 二级组装机
	{ name = "assembling-machine-2",    count = 50 },
	-- 三级组装机
	{ name = "assembling-machine-3",    count = 50 },
	-- 传送带
	{ name = "transport-belt",          count = 1000 },
	-- 地下传送带
	{ name = "underground-belt",        count = 200 },
	-- 分流器
	{ name = "splitter",                count = 100 },
	-- 管道
	{ name = "pipe",                    count = 1000 },
	-- 地下管道
	{ name = "pipe-to-ground",          count = 200 },
	-- 机械臂
	{ name = "inserter",                count = 200 },
	-- 加长机械臂
	{ name = "long-handed-inserter",    count = 200 },
	-- 快速机械臂
	{ name = "fast-inserter",           count = 200 },
	-- 实验室
	{ name = "lab",                     count = 10 },
	-- 炼油厂
	{ name = "oil-refinery",            count = 10 },
	-- 化工厂
	{ name = "chemical-plant",          count = 10 },
	-- 水泵
	{ name = "offshore-pump",           count = 2 },
	-- 油井
	{ name = "pumpjack",                count = 10 },
	-- 钢炉
	{ name = "steel-furnace",           count = 50 },
	-- 电力采矿机
	{ name = "electric-mining-drill",   count = 50 },
	-- 蜘蛛机甲遥控器
	{ name = "spidertron-remote",       count = 1 },
	-- 建设机器人
	{ name = "construction-robot",      count = 100 },
	-- 电线杆
	{ name = "small-electric-pole",     count = 200 },
	{ name = "medium-electric-pole",    count = 50 },
	{ name = "big-electric-pole",       count = 50 },
	{ name = "substation",              count = 50 },
	-- 雷达
	{ name = "radar",                   count = 50 },
	-- 贫铀穿甲弹
	{ name = "uranium-rounds-magazine", count = 1000 },
}

-- 能量装甲装备
local power_armor_grid_items = {
	-- 能量盾模块 MK2
	{ name = "energy-shield-mk2-equipment",      count = 20 },
	-- 外骨骼模块
	{ name = "exoskeleton-equipment",            count = 20 },
	-- 聚变堆模块
	{ name = "fusion-reactor-equipment",         count = 20 },
	-- 激光防御模块
	{ name = "personal-laser-defense-equipment", count = 20 },
	-- 机器人指令模块
	{ name = "personal-roboport-mk2-equipment",  count = 18 },
	-- 夜视模块
	{ name = "night-vision-equipment",           count = 1 },
	-- 锚定模块
	{ name = "belt-immunity-equipment",          count = 1 },
}

-- 蜘蛛机甲装备
local spidertron_grid_items = {
	-- 能量盾模块 MK2
	{ name = "energy-shield-mk2-equipment",      count = 10 },
	-- 外骨骼模块
	{ name = "exoskeleton-equipment",            count = 20 },
	-- 聚变堆模块
	{ name = "fusion-reactor-equipment",         count = 10 },
	-- 激光防御模块
	{ name = "personal-laser-defense-equipment", count = 10 },
	-- 机器人指令模块
	{ name = "personal-roboport-mk2-equipment",  count = 8 },
	-- 夜视模块
	{ name = "night-vision-equipment",           count = 1 },
	-- 锚定模块
	{ name = "belt-immunity-equipment",          count = 1 },
}

-- 蜘蛛机甲物品
local spidertron_trunk_items = {
	-- 机器人指令平台
	{ name = "roboport",             count = 40 },
	-- 建设机器人
	{ name = "construction-robot",   count = 100 },
	-- 太阳能板
	{ name = "solar-panel",          count = 1440 },
	-- 电池组
	{ name = "accumulator",          count = 1200 },
	-- 电线杆
	{ name = "small-electric-pole",  count = 200 },
	{ name = "medium-electric-pole", count = 200 },
	{ name = "big-electric-pole",    count = 200 },
	{ name = "substation",           count = 200 },
	-- 雷达
	{ name = "radar",                count = 50 },
	-- 高爆火箭弹
	{ name = "explosive-rocket",     count = 800 },
}

local function main(player)
	if player == nil then return end

	-- 清空已有物品
	player.clear_items_inside()

	-- 背包内物品
	for _, item in ipairs(player_inventory_items) do
		player.insert(item)
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
	local spidertron = player.surface.create_entity { name = "spidertron", position = player.position, force = player.force }
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
end

function startup_OnPlayerFirstJoinedGame(event)
	main(game.get_player(event.player_index))
end
