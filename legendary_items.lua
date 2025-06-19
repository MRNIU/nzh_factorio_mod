-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- legendary_items.lua for MRNIU/nzh_factorio_mod.

--------------------------------------------------------------------------------------
-- 配置传奇机甲
local function init_legendary_mech_armor(mech_armor)
    local grid = mech_armor.grid

    -- 手动指定装备位置配置 (机甲网格: 15宽 × 17高，索引从0开始)
    local equipment_positions = {
        -- toolbelt-equipment(3×1) - 放在顶部
        {
            name = "toolbelt-equipment",
            positions = {
                { 0, 0 }, { 3, 0 }, { 6, 0 }, { 9, 0 }, { 12, 0 } -- 5个工具栏装备
            }
        },

        -- fusion-reactor-equipment(4×4) - 主要能源设备
        {
            name = "fusion-reactor-equipment",
            positions = {
                { 0, 1 }, -- 左上角 (0,1) 到 (3,4)
                { 4, 1 }, -- 中上 (4,1) 到 (7,4)
                { 0, 5 }, -- 左下 (0,5) 到 (3,8)
                { 4, 5 }, -- 右上 (4,5) 到 (7,8)
            }
        },

        -- night-vision-equipment(2×2) - 夜视装备
        {
            name = "night-vision-equipment",
            positions = {
                { 12, 1 } -- 右上角 (12,1) 到 (13,2)
            }
        },

        -- energy-shield-mk2-equipment(2×2) - 能量护盾
        {
            name = "energy-shield-mk2-equipment",
            positions = {
                { 12, 3 }, -- (4,5) 到 (5,6)
                { 12, 5 }, -- (6,5) 到 (7,6)
                { 12, 7 }  -- (8,5) 到 (9,6)
            }
        },

        -- solar-panel-equipment(1×1) - 太阳能板
        {
            name = "solar-panel-equipment",
            positions = {
                { 14, 1 } -- 最右上角
            }
        },

        -- belt-immunity-equipment(1×1) - 传送带免疫
        {
            name = "belt-immunity-equipment",
            positions = {
                { 14, 2 } -- 紧邻太阳能板下方
            }
        },

        -- battery-mk3-equipment(1×2) - 电池，放在右侧
        {
            name = "battery-mk3-equipment",
            positions = {
                { 14, 3 },  -- (14,3) 到 (14,4)
                { 14, 5 },  -- (14,5) 到 (14,6)
                { 14, 7 },  -- (14,7) 到 (14,8)
                { 14, 9 },  -- (14,9) 到 (14,10)
                { 14, 11 }, -- (14,11) 到 (14,12)
                { 14, 13 }, -- (14,13) 到 (14,14)
                { 14, 15 }  -- (14,15) 到 (14,16)
            }
        },


        -- personal-laser-defense-equipment(2×2) - 个人激光防御
        {
            name = "personal-laser-defense-equipment",
            positions = {
                { 10, 1 }, -- (10,5) 到 (11,6)
                { 10, 3 }, -- (12,5) 到 (13,6)
                { 10, 5 }, -- (0,9) 到 (1,10)
                { 10, 7 }  -- (2,9) 到 (3,10)
            }
        },

        -- personal-roboport-mk2-equipment(2×2) - 个人机器人港
        {
            name = "personal-roboport-mk2-equipment",
            positions = {
                { 8, 1 }, -- (4,9) 到 (5,10)
                { 8, 3 }, -- (6,9) 到 (7,10)
                { 8, 5 }, -- (8,9) 到 (9,10)
                { 8, 7 }  -- (10,9) 到 (11,10)
            }
        },

        -- exoskeleton-equipment(2×4) - 外骨骼装备，放在底部
        {
            name = "exoskeleton-equipment",
            positions = {
                { 0, 9 },   -- (0,11) 到 (1,14)
                { 2, 9 },   -- (2,9) 到 (3,14)
                { 4, 9 },   -- (4,9) 到 (5,14)
                { 6, 9 },   -- (6,9) 到 (7,14)
                { 8, 9 },   -- (8,9) 到 (9,14)
                { 10, 9 },  -- (10,9) 到 (9,14)
                { 12, 9 },  -- (12,11) 到 (13,14)
                { 0, 13 },  -- (0,13) 到 (1,16) - 注意这里是y=15，到y=16正好不超出17的边界
                { 2, 13 },  -- (2,13) 到 (3,16)
                { 4, 13 },  -- (4,13) 到 (5,16)
                { 6, 13 },  -- (6,13) 到 (7,16)
                { 8, 13 },  -- (8,13) 到 (9,16)
                { 10, 13 }, -- (10,13) 到 (11,16)
                { 12, 13 }  -- (12,13) 到 (13,16)
            }
        }
    }

    -- 按指定位置添加装备
    for _, equipment_config in pairs(equipment_positions) do
        for i, position in ipairs(equipment_config.positions) do
            grid.put {
                name = equipment_config.name,
                position = position,
                quality = "legendary"
            }
        end
    end
end

--------------------------------------------------------------------------------------
--- 给玩家添加传奇机甲装甲
local function give_legendary_mech_armor(player)
    -- 检查玩家装备栏是否有空位
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory then
        return
    end

    -- 添加传奇机甲装甲
    armor_inventory.insert({
        name = "mech-armor",
        count = 1,
        quality = "legendary"
    })
    -- 初始化传奇机甲装甲
    init_legendary_mech_armor(armor_inventory[1])
end

--------------------------------------------------------------------------------------
-- 给玩家背包添加传奇物品
local function give_legendary_items(player_name, items)
    local player = game.players[player_name]
    if not player then
        game.print("Player " .. player_name .. " not found")
        return
    end

    local main_inventory = player.get_inventory(defines.inventory.character_main)
    if not main_inventory then
        game.print("无法访问玩家背包")
        return
    end

    local added_items = {}

    for _, item_data in pairs(items) do
        local item_name = item_data.name or item_data[1]
        local item_count = item_data.count or item_data[2] or 1
        local item_quality = item_data.quality or "legendary"

        if prototypes.item[item_name] then
            local legendary_item = {
                name = item_name,
                count = item_count,
                quality = item_quality
            }

            local inserted = main_inventory.insert(legendary_item)
            if inserted > 0 then
                table.insert(added_items, item_count .. "x " .. item_quality .. " " .. item_name)
            end
        else
            game.print("物品 " .. item_name .. " 不存在，跳过")
        end
    end

    if #added_items > 0 then
        game.print("给玩家 " .. player_name .. " 添加了以下传奇物品: " .. table.concat(added_items, ", "))
    else
        game.print("没有成功添加任何物品")
    end
end

--------------------------------------------------------------------------------------
-- 预设的传奇物品包
local preset_legendary_items = {
    -- 基础建设包
    construction = {
        { name = "construction-robot",    count = 100 },
        { name = "logistic-robot",        count = 100 },
        { name = "roboport",              count = 10 },
        { name = "assembling-machine-3",  count = 50 },
        { name = "electric-furnace",      count = 20 },
        { name = "beacon",                count = 20 },
        { name = "productivity-module-3", count = 100 },
        { name = "speed-module-3",        count = 100 },
        { name = "efficiency-module-3",   count = 100 }
    },

    -- 战斗装备包
    combat = {
        { name = "power-armor-mk2",                  count = 1 },
        { name = "personal-laser-defense-equipment", count = 5 },
        { name = "energy-shield-mk2-equipment",      count = 3 },
        { name = "exoskeleton-equipment",            count = 2 },
        { name = "personal-roboport-mk2-equipment",  count = 2 },
        { name = "fusion-reactor-equipment",         count = 1 },
        { name = "combat-shotgun",                   count = 1 },
        { name = "piercing-shotgun-shell",           count = 200 }
    },

    -- 交通运输包
    transport = {
        { name = "locomotive",        count = 5 },
        { name = "cargo-wagon",       count = 20 },
        { name = "fluid-wagon",       count = 10 },
        { name = "rail",              count = 1000 },
        { name = "train-stop",        count = 20 },
        { name = "rail-signal",       count = 100 },
        { name = "rail-chain-signal", count = 100 },
        { name = "spidertron",        count = 1 },
        { name = "spidertron-remote", count = 5 }
    }
}

--------------------------------------------------------------------------------------
-- 给玩家添加预设传奇物品包
local function give_preset_legendary_items(player_name, preset_name)
    if not preset_legendary_items[preset_name] then
        game.print("预设物品包 " .. preset_name .. " 不存在")
        return
    end

    give_legendary_items(player_name, preset_legendary_items[preset_name])
end

return {
    give_legendary_mech_armor = give_legendary_mech_armor,
    give_legendary_items = give_legendary_items,
    give_preset_legendary_items = give_preset_legendary_items,
    preset_legendary_items = preset_legendary_items
}
