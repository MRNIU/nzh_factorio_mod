-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

function NZH_startup_on_init()
	local created_items = remote.call("freeplay", "get_created_items")
		-- 蜘蛛机甲
		created_items["spidertron"] = 1
		-- 蜘蛛机甲遥控
		created_items["spidertron-remote"] = 1
		-- 能量装甲 MK2
		created_items["power-armor-mk2"] = 1
		-- 能量盾模块 MK2
		created_items["energy-shield-mk2-equipment"] = 20
		-- 外骨骼模块
		created_items["exoskeleton-equipment"] = 20
		-- 聚变堆模块
		created_items["fusion-reactor-equipment"] = 20
		-- 激光防御模块
		created_items["personal-laser-defense-equipment"] = 20
		-- 机器人指令模块
		created_items["personal-roboport-mk2-equipment"] = 18
		-- 夜视模块
		created_items["night-vision-equipment"] = 1
		-- 锚定模块
		created_items["belt-immunity-equipment"] = 1
		-- 机器人指令平台
		created_items["roboport"] = 14
		-- 建设机器人
		created_items["construction-robot"] = 100
		-- 太阳能板
		created_items["solar-panel"] = 720
		-- 电池组
		created_items["accumulator"] = 600
		-- 电线杆
		created_items["small-electric-pole"] = 50
		created_items["medium-electric-pole"] = 50
		created_items["big-electric-pole"] = 50
		created_items["substation"] = 114
		-- 雷达
		created_items["radar"] = 50
		remote.call("freeplay", "set_created_items", created_items)
end
