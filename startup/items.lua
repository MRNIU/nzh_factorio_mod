-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

-- 背包物品
player_inventory_items = {
	-- 钢箱
	{ name = "steel-chest",             count = 50 },
	-- 一级组装机
	{ name = "assembling-machine-1",    count = 50 },
	-- 二级组装机
	{ name = "assembling-machine-2",    count = 50 },
	-- 三级组装机
	{ name = "assembling-machine-3",    count = 50 },
	-- 传送带
	{ name = "transport-belt",          count = 200 },
	-- 地下传送带
	{ name = "underground-belt",        count = 50 },
	-- 分流器
	{ name = "splitter",                count = 50 },
	-- 管道
	{ name = "pipe",                    count = 200 },
	-- 地下管道
	{ name = "pipe-to-ground",          count = 100 },
	-- 机械臂
	{ name = "inserter",                count = 50 },
	-- 加长机械臂
	{ name = "long-handed-inserter",    count = 50 },
	-- 快速机械臂
	{ name = "fast-inserter",           count = 50 },
	-- 水泵
	{ name = "offshore-pump",           count = 2 },
	-- 油井
	{ name = "pumpjack",                count = 10 },
	-- 电力采矿机
	{ name = "electric-mining-drill",   count = 50 },
	-- 蜘蛛机甲遥控器
	{ name = "spidertron-remote",       count = 1 },
	-- 建设机器人
	{ name = "construction-robot",      count = 100 },
	-- 电线杆
	{ name = "small-electric-pole",     count = 50 },
	{ name = "medium-electric-pole",    count = 50 },
	{ name = "big-electric-pole",       count = 50 },
	{ name = "substation",              count = 50 },
	-- 雷达
	{ name = "radar",                   count = 50 },
	-- 贫铀穿甲弹
	{ name = "uranium-rounds-magazine", count = 1000 },
	-- 机枪炮塔
	{ name = "gun-turret",              count = 50 },
	-- 修理包
	{ name = "repair-pack",             count = 100 },
	-- 管道泵
	{ name = "pump",                    count = 4 },
	-- 机器人指令平台
	{ name = "roboport",                count = 10 },
}

-- 物品箱 1 物品
chest1_items = {
	-- 钢箱
	{ name = "steel-chest",          count = 100 },
	-- 一级组装机
	{ name = "assembling-machine-1", count = 100 },
	-- 二级组装机
	{ name = "assembling-machine-2", count = 50 },
	-- 三级组装机
	{ name = "assembling-machine-3", count = 50 },
	-- 传送带
	{ name = "transport-belt",       count = 2400 },
	-- 地下传送带
	{ name = "underground-belt",     count = 300 },
	-- 分流器
	{ name = "splitter",             count = 100 },
	-- 管道
	{ name = "pipe",                 count = 200 },
	-- 地下管道
	{ name = "pipe-to-ground",       count = 200 },
}

-- 物品箱 2 物品
chest2_items = {
	-- 热能机械臂
	{ name = "burner-inserter",      count = 600 },
	-- 机械臂
	{ name = "inserter",             count = 600 },
	-- 加长机械臂
	{ name = "long-handed-inserter", count = 200 },
	-- 快速机械臂
	{ name = "fast-inserter",        count = 200 },
	-- 电线杆
	{ name = "small-electric-pole",  count = 400 },
	{ name = "medium-electric-pole", count = 100 },
	{ name = "big-electric-pole",    count = 50 },
	{ name = "substation",           count = 50 },
}

-- 物品箱 3 物品
chest3_items = {
	-- 实验室
	{ name = "lab",                   count = 40 },
	-- 炼油厂
	{ name = "oil-refinery",          count = 20 },
	-- 化工厂
	{ name = "chemical-plant",        count = 20 },
	-- 水泵
	{ name = "offshore-pump",         count = 20 },
	-- 油井
	{ name = "pumpjack",              count = 20 },
	-- 钢炉
	{ name = "steel-furnace",         count = 400 },
	-- 电力采矿机
	{ name = "electric-mining-drill", count = 400 },
	-- 悬崖炸药
	{ name = "cliff-explosives",      count = 200 },
}

-- 物品箱 4 物品
chest4_items = {
	-- 雷达
	{ name = "radar",                   count = 100 },
	-- 贫铀穿甲弹
	{ name = "uranium-rounds-magazine", count = 2000 },
	-- 机枪炮塔
	{ name = "gun-turret",              count = 200 },
	-- 锅炉
	{ name = "boiler",                  count = 40 },
	-- 蒸汽机
	{ name = "steam-engine",            count = 80 },
	-- 火焰炮塔
	{ name = "flamethrower-turret",     count = 200 },
	-- 石墙
	{ name = "stone-wall",              count = 1000 },
}

-- 物品箱 5 物品
chest5_items = {
	-- 石墙
	{ name = "stone-wall",          count = 2000 },
	-- 常量运算器
	{ name = "constant-combinator", count = 200 },
	-- 筛选机械臂
	{ name = "filter-inserter",     count = 200 },
	-- 集装机械臂
	{ name = "stack-inserter",      count = 200 },
	-- 修理包
	{ name = "repair-pack",         count = 100 },
	-- 储液罐
	{ name = "storage-tank",        count = 50 },
	-- 管道泵
	{ name = "pump",                count = 50 },
	-- 灯
	{ name = "small-lamp",          count = 200 },
}

-- 物品箱 6 物品
chest6_items = {
	-- 极速传送带
	{ name = "express-transport-belt",   count = 3200 },
	-- 极速地下传送带
	{ name = "express-underground-belt", count = 400 },
	-- 极速分流器
	{ name = "express-splitter",         count = 400 },
}

-- 物品箱 7 物品
chest7_items = {
	-- 极速传送带
	{ name = "express-transport-belt", count = 2000 },
	-- 机枪炮塔
	{ name = "gun-turret",             count = 1000 },
}

-- 物品箱 8 物品
chest8_items = {
	-- 快速机械臂
	{ name = "fast-inserter", count = 1000 },
}

-- 能量装甲装备
power_armor_grid_items = {
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
spidertron_grid_items = {
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
spidertron_trunk_items = {
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

-- 太阳能矩阵蓝图
SolarArray10_8MW =
"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"
