-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

local initial_items = {
	-- 蜘蛛机甲
	{name = "spidertron", count = 1},
	-- 蜘蛛机甲遥控
	{name = "spidertron-remote", count = 1},
	-- 能量装甲 MK2
	{name = "power-armor-mk2", count = 1},
	-- 能量盾模块 MK2
	{name = "energy-shield-mk2-equipment", count = 30},
	-- 外骨骼模块
	{name = "exoskeleton-equipment", count = 40},
	-- 聚变堆模块
	{name = "fusion-reactor-equipment", count = 30},
	-- 激光防御模块
	{name = "personal-laser-defense-equipment", count = 30},
	-- 机器人指令模块
	{name = "personal-roboport-mk2-equipment", count = 28},
	-- 夜视模块
	{name = "night-vision-equipment", count = 1},
	-- 锚定模块
	{name = "belt-immunity-equipment", count = 1},
	-- 机器人指令平台
	{name = "roboport", count = 18},
	-- 建设机器人
	{name = "construction-robot", count = 100},
	-- 太阳能板
	{name = "solar-panel", count = 1440},
	-- 电池组
	{name = "accumulator", count = 1200},
	-- 电线杆
	{name = "small-electric-pole", count = 50},
	{name = "medium-electric-pole", count = 50},
	{name = "big-electric-pole", count = 50},
	{name = "substation", count = 178},
	-- 雷达
	{name = "radar", count = 50},
	-- 火箭弹
	{name = "rocket", count = 2400},
	-- 高爆火箭弹
	{name = "explosive-rocket", count = 2400},
	-- 贫铀穿甲弹
	{name = "uranium-rounds-magazine", count = 1200},
	-- 冲锋枪
	{name = "submachine-gun", count = 1},
}

function NZH_startup_on_player_created(event)
	-- local player = game.get_player(event.player_index)
	local player = game.players[event.player_index]
	player.clear_items_inside()
	for _, item in ipairs(initial_items) do
		player.insert(item)
	end
end
