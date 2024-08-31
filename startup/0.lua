-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- 0.lua for MRNIU/nzh_factorio_mod.

-- 背包物品
local player_inventory_items = {
	-- 钢箱
	{ name = "steel-chest",              count = 50 },
	-- 三级组装机
	{ name = "assembling-machine-3",     count = 50 },
	-- 极速传送带
	{ name = "express-transport-belt",   count = 200 },
	-- 极速地下传送带
	{ name = "express-underground-belt", count = 50 },
	-- 极速分流器
	{ name = "express-splitter",         count = 50 },
	-- 管道
	{ name = "pipe",                     count = 200 },
	-- 地下管道
	{ name = "pipe-to-ground",           count = 100 },
	-- 加长机械臂
	{ name = "long-handed-inserter",     count = 50 },
	-- 快速机械臂
	{ name = "fast-inserter",            count = 50 },
	-- 水泵
	{ name = "offshore-pump",            count = 2 },
	-- 油井
	{ name = "pumpjack",                 count = 10 },
	-- 电力采矿机
	{ name = "electric-mining-drill",    count = 50 },
	-- 蜘蛛机甲遥控器
	{ name = "spidertron-remote",        count = 1 },
	-- 建设机器人
	{ name = "construction-robot",       count = 100 },
	-- 电线杆
	{ name = "small-electric-pole",      count = 50 },
	{ name = "medium-electric-pole",     count = 50 },
	{ name = "big-electric-pole",        count = 50 },
	{ name = "substation",               count = 50 },
	-- 雷达
	{ name = "radar",                    count = 50 },
	-- 贫铀穿甲弹
	{ name = "uranium-rounds-magazine",  count = 1000 },
	-- 机枪炮塔
	{ name = "gun-turret",               count = 50 },
	-- 修理包
	{ name = "repair-pack",              count = 100 },
	-- 管道泵
	{ name = "pump",                     count = 4 },
	-- 机器人指令平台
	{ name = "roboport",                 count = 10 },
}

-- 能量装甲装备
local power_armor_grid_items = {
	-- 能量盾模块 MK2
	{ name = "energy-shield-mk2-equipment",      count = 30 },
	-- 聚变堆模块
	{ name = "fusion-reactor-equipment",         count = 20 },
	-- 激光防御模块
	{ name = "personal-laser-defense-equipment", count = 30 },
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
	{ name = "energy-shield-mk2-equipment",      count = 20 },
	-- 聚变堆模块
	{ name = "fusion-reactor-equipment",         count = 10 },
	-- 激光防御模块
	{ name = "personal-laser-defense-equipment", count = 20 },
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

-- 初始化玩家
function Level0(player)
	-- 清空已有物品
	player.clear_items_inside()

	-- 背包内物品
	for _, item in ipairs(player_inventory_items) do
		player.insert(item)
	end
	if player.name == "PTRNULL" then
		-- 永续箱
		player.insert { name = "infinity-chest", count = 50 }
		-- 永续管
		player.insert { name = "infinity-pipe", count = 10 }
		-- 极速装卸机
		player.insert { name = "express-loader", count = 50 }
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
end
