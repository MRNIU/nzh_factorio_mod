-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

-- 引入区域清理器模块
local area_cleaner = require("area_cleaner")
local generate_resources = require("generate_resources")
local legendary_items = require("legendary_items")

--------------------------------------------------------------------------------------
-- 在游戏初始化时清空中心区域
local function OnInit()
    -- 初始化全局变量
    global.equipped_players = global.equipped_players or {}
    global.equipment_setup_pending = global.equipment_setup_pending or {}
end

--------------------------------------------------------------------------------------
-- 配置指定玩家名称列表
-- 当这些玩家首次创建角色或加入游戏时，会自动获得传奇装备
local target_players = {
    "ptrnull",
    -- 可以在这里添加更多玩家名称
    -- "player2",
    -- "player3",
}

--------------------------------------------------------------------------------------
-- 在新星球创建时清空中心区域
local function OnSurfaceCreated(event)
    local surface = game.surfaces[event.surface_index]

    area_cleaner.clear_center_area(surface)
    generate_resources.generate_resource_planet(surface)
end

--------------------------------------------------------------------------------------
-- 当玩家创建时给指定角色配置传奇装备
local function OnPlayerCreated(event)
    local player = game.players[event.player_index]
    if not player then
        return
    end
    
    -- 检查是否是目标玩家且未配置过装备
    for _, target_name in pairs(target_players) do
        if player.name == target_name and not global.equipped_players[player.name] then
            game.print("检测到目标玩家 " .. player.name .. "，正在配置传奇装备...")
            
            -- 标记玩家已配置装备（防止重复配置）
            global.equipped_players[player.name] = true
            
            -- 使用全局变量存储需要处理的玩家信息
            global.equipment_setup_pending[player.name] = {
                player_name = player.name,
                tick_count = 0
            }
            break
        end
    end
end

--------------------------------------------------------------------------------------
-- 每 tick 检查是否需要为目标玩家配置装备
local function OnTick(event)
    local has_pending = false
    
    -- 遍历所有待处理的玩家
    for player_name, setup_data in pairs(global.equipment_setup_pending) do
        setup_data.tick_count = setup_data.tick_count + 1
        has_pending = true
        
        -- 等待 60 tick (1秒) 后执行配置
        if setup_data.tick_count >= 60 then
            -- 给玩家添加传奇机甲装甲
            legendary_items.give_legendary_mech_armor(player_name)
            
            -- 给玩家添加建设物品包
            legendary_items.give_preset_legendary_items(player_name, "construction")
            
            -- 给玩家添加战斗物品包
            legendary_items.give_preset_legendary_items(player_name, "combat")
            
            -- 给玩家添加交通物品包
            legendary_items.give_preset_legendary_items(player_name, "transport")
            
            game.print("玩家 " .. player_name .. " 的传奇装备配置完成！")
            
            -- 从待处理列表中移除该玩家
            global.equipment_setup_pending[player_name] = nil
        end
    end
    
    -- 如果没有待处理的玩家，停止 tick 事件
    if not has_pending then
        script.on_event(defines.events.on_tick, nil)
    end
end

--------------------------------------------------------------------------------------
-- 当玩家加入游戏时检查是否需要配置装备（处理已存在的玩家首次加入）
local function OnPlayerJoinedGame(event)
    local player = game.players[event.player_index]
    if not player then
        return
    end
    
    -- 检查是否是目标玩家且未配置过装备
    for _, target_name in pairs(target_players) do
        if player.name == target_name and not global.equipped_players[player.name] then
            game.print("检测到目标玩家 " .. player.name .. " 首次加入游戏，正在配置传奇装备...")
            
            -- 标记玩家已配置装备（防止重复配置）
            global.equipped_players[player.name] = true
            
            -- 使用全局变量存储需要处理的玩家信息
            global.equipment_setup_pending[player.name] = {
                player_name = player.name,
                tick_count = 0
            }
            
            -- 启动 tick 事件监听
            script.on_event(defines.events.on_tick, OnTick)
            break
        end
    end
end

--------------------------------------------------------------------------------------
-- 事件注册
script.on_init(OnInit)
script.on_event(defines.events.on_surface_created, OnSurfaceCreated)
script.on_event(defines.events.on_player_created, function(event)
    OnPlayerCreated(event)
    
    -- 检查是否有待处理的装备配置，启动 tick 事件监听
    local has_pending = false
    for _ in pairs(global.equipment_setup_pending) do
        has_pending = true
        break
    end
    
    if has_pending then
        script.on_event(defines.events.on_tick, OnTick)
    end
end)
script.on_event(defines.events.on_player_joined_game, OnPlayerJoinedGame)
