-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

local function add_item(_player, _item, _amount)
	if (_amount > 0) then
		_player.insert({ name = _item, count = _amount })
	end
end

local function insert(_player)
	-- 蜘蛛机甲
	add_item(_player, "spidertron", 1)
	-- 蜘蛛机甲遥控
	add_item(_player, "spidertron-remote", 1)
	-- 能量装甲 MK2
	add_item(_player, "power-armor-mk2", 1)
	-- 能量盾模块 MK2
	add_item(_player, "energy-shield-mk2-equipment", 30)
	-- 外骨骼模块
	add_item(_player, "exoskeleton-equipment", 40)
	-- 聚变堆模块
	add_item(_player, "fusion-reactor-equipment", 30)
	-- 激光防御模块
	add_item(_player, "personal-laser-defense-equipment", 30)
	-- 机器人指令模块
	add_item(_player, "personal-roboport-mk2-equipment", 28)
	-- 夜视模块
	add_item(_player, "night-vision-equipment", 1)
	-- 锚定模块
	add_item(_player, "belt-immunity-equipment", 1)
	-- 机器人指令平台
	add_item(_player, "roboport", 18)
	-- 建设机器人
	add_item(_player, "construction-robot", 100)
	-- 太阳能板
	add_item(_player, "solar-panel", 1440)
	-- 电池组
	add_item(_player, "accumulator", 1200)
	-- 电线杆
	add_item(_player, "small-electric-pole", 50)
	add_item(_player, "medium-electric-pole", 50)
	add_item(_player, "big-electric-pole", 50)
	add_item(_player, "substation", 178)
	-- 雷达
	add_item(_player, "radar", 50)
	-- 火箭弹
	add_item(_player, "rocket", 2400)
	-- 高爆火箭弹
	add_item(_player, "explosive-rocket", 2400)
	-- 贫铀穿甲弹
	add_item(_player, "uranium-rounds-magazine", 1200)
	-- 冲锋枪
	add_item(_player, "submachine-gun", 1)
	-- -- 采矿效率，890 级时满蓝带 https://wiki.factorio.com/Mining_productivity_(research)#Normal%20mode
	-- _player.force.technologies['mining-productivity-1'].researched = true
	-- _player.force.technologies['mining-productivity-2'].researched = true
	-- _player.force.technologies['mining-productivity-3'].researched = true
	-- for x = 0, 886 do
	-- 	_player.force.technologies['mining-productivity-4'].researched = true
	-- end
	-- _player.force.manual_mining_speed_modifier = 89
end

function NZH_startup_on_player_created(_event)
	local player = game.players[_event.player_index]
	if not player.character == nil then
		insert(player)
	end
end

function NZH_startup_on_cutscene_cancelled(_event)
	local player = game.players[_event.player_index]
	insert(player)
end
