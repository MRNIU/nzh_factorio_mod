-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- legendary_items.lua for MRNIU/nzh_factorio_mod.

-- 定义要添加的传奇装备列表
local legendary_equipment = {
    { name = "toolbelt-equipment",               quality = "legendary", count = 5 },
    { name = "fusion-reactor-equipment",         quality = "legendary", count = 4 },
    { name = "battery-mk3-equipment",            quality = "legendary", count = 7 },
    { name = "solar-panel-equipment",            quality = "legendary", count = 1 },
    { name = "belt-immunity-equipment",          quality = "legendary", count = 1 },
    { name = "exoskeleton-equipment",            quality = "legendary", count = 14 },
    { name = "night-vision-equipment",           quality = "legendary", count = 1 },
    { name = "energy-shield-mk2-equipment",      quality = "legendary", count = 3 },
    { name = "personal-laser-defense-equipment", quality = "legendary", count = 4 },
    { name = "personal-roboport-mk2-equipment",  quality = "legendary", count = 4 },
}

--------------------------------------------------------------------------------------
-- 给玩家添加传奇机甲装甲并配置装备
local function give_legendary_mech_armor(player)
    -- 创建传奇品质的机甲装甲
    local mech_armor = {
        name = "mech-armor",
        count = 1,
        quality = "legendary"
    }
    local grid = mech_armor.grid

    -- 添加装备到装备网格
    for _, equipment_data in pairs(legendary_equipment) do
        for i = 1, equipment_data.count do
            local position = grid.find_empty_stack(equipment_data.name)
            if position then
                grid.put {
                    name = equipment_data.name,
                    position = position,
                    quality = equipment_data.quality
                }
            end
        end
    end

    -- 检查玩家装备栏是否有空位
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    -- 先移除当前装甲
    armor_inventory.clear()
    -- 添加传奇机甲装甲
    armor_inventory.insert(mech_armor)
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
legendary_items.preset_legendary_items = {
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
    if not legendary_items.preset_legendary_items[preset_name] then
        game.print("预设物品包 " .. preset_name .. " 不存在")
        return
    end

    give_legendary_items(player_name, legendary_items.preset_legendary_items[preset_name])
end

return {
    give_legendary_mech_armor = give_legendary_mech_armor,
    give_legendary_items = give_legendary_items,
    give_preset_legendary_items = give_preset_legendary_items
}
