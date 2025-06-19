-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- generate_resources.lua for MRNIU/nzh_factorio_mod.
-- 资源生成器 - 用于在指定区域内生成指定类型与数量的资源

-- 引入区块工具模块
local chunk_utils = require("chunk_utils")

-- 定义地块类型的资源（需要使用set_tiles）
local tile_resources = {
    ["water"] = true,
    ["lava"] = true,
    ["oil-ocean-shallow"] = true,
    ["gleba-deep-lake"] = true,
    ["ammoniacal-ocean"] = true,
    ["overgrowth-jellynut-soil"] = true,
    ["overgrowth-yumako-soil"] = true
}

-- 定义流体资源
local fluid_resources = {
    ["crude-oil"] = true,
    ["sulfuric-acid-geyser"] = true,
    ["lithium-brine"] = true,
    ["fluorine-vent"] = true
}

-- 定义普通类型的资源
local normal_resources = {
    ["copper-ore"] = true,
    ["iron-ore"] = true,
    ["stone"] = true,
    ["uranium-ore"] = true,
    ["coal"] = true
}

--------------------------------------------------------------------------------------
-- 在指定 surface 指定区域内生成指定类型与数量的资源
-- @param surface: 目标表面对象
-- @param area: 区域定义 {left_top = {x, y}, right_bottom = {x, y}}
-- @param resource_name: 资源类型名称（如 "iron-ore", "copper-ore", "coal", "stone", "uranium-ore", "crude-oil"）
-- @param amount: 资源数量
-- @return boolean: 成功返回true，失败返回false
local function generate_resources_in_area(surface, area, resource_name, amount)
    if fluid_resources[resource_name] then
        -- 流体资源 - 在中心点 create_entity
        local center_x = area.left_top.x + math.floor((area.right_bottom.x - area.left_top.x) / 2)
        local center_y = area.left_top.y + math.floor((area.right_bottom.y - area.left_top.y) / 2)

        local entity = surface.create_entity {
            name = resource_name,
            position = { center_x, center_y },
            amount = amount
        }
    else
        for x = area.left_top.x, area.right_bottom.x - 1 do
            for y = area.left_top.y, area.right_bottom.y - 1 do
                -- 创建资源实体
                surface.create_entity {
                    name = resource_name,
                    position = { x, y },
                    amount = amount
                }
            end
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 在指定 surface 指定区域内生成 tile
-- @param surface: 目标表面对象
-- @param area: 区域定义 {left_top = {x, y}, right_bottom = {x, y}}
-- @param tile_name: tile 名称（如 "iron-ore", "copper-ore", "coal", "stone", "uranium-ore", "crude-oil"）
-- @return boolean: 成功返回true，失败返回false
local function generate_tile_in_area(surface, area, tile_name)
    local tiles = {}
    for x = area.left_top.x, area.right_bottom.x - 1 do
        for y = area.left_top.y, area.right_bottom.y - 1 do
            table.insert(tiles, { name = tile_name, position = { x, y } })
        end
    end
    if #tiles > 0 then
        surface.set_tiles(tiles)
    end

    return #tiles
end

--------------------------------------------------------------------------------------
-- 处理资源列表，统一转换为表格式
local function preprocess_resources_table(resource_list, amount)
    local resources = {}
    if type(resource_list) == "string" then
        -- 单个资源字符串
        resources = { { name = resource_list, amount = amount } }
    elseif type(resource_list) == "table" then
        -- 资源列表
        for i, resource in ipairs(resource_list) do
            if type(resource) == "string" then
                -- 资源名称字符串
                table.insert(resources, { name = resource, amount = amount })
            elseif type(resource) == "table" and resource.name then
                -- 资源配置对象
                table.insert(resources, {
                    name = resource.name,
                    amount = resource.amount or amount
                })
            end
        end
    else
        return false
    end

    return resources
end

-- 按指定规律生成资源区域
-- @param surface: 目标表面对象
-- @param start_position: 起始位置 {x, y}
-- @param direction: 排列方向 ("horizontal" 水平 或 "vertical" 垂直)
-- @param area_size: 单个资源区域大小 {width, height}
-- @param spacing: 区域间隔距离
-- @param resource_list: 资源列表，可以是字符串（单个资源）或表（多个资源配置）
--   - 字符串形式: "iron-ore"
--   - 表形式: {
--       {name = "iron-ore", amount = 5000},
--       {name = "copper-ore", amount = 3000},
--       ...
--     }
-- @param amount: 默认资源数量（当resource_list为字符串或资源项未指定amount时使用）
-- @return boolean: 成功返回true，失败返回false
local function generate_resources_pattern(surface, start_position, direction, area_size, spacing, resource_list,
                                          amount)
    local resources = preprocess_resources_table(resource_list, amount)
    if not resources or #resources == 0 then
        return false
    end

    local success_count = 0

    for i = 1, #resources do
        -- 循环使用资源列表中的资源
        local resource_index = ((i - 1) % #resources) + 1
        local current_resource = resources[resource_index]

        -- 计算当前区域的位置
        local current_x = start_position.x
        local current_y = start_position.y

        if direction == "horizontal" then
            current_x = current_x + (i - 1) * (area_size.width + spacing)
        else -- vertical
            current_y = current_y + (i - 1) * (area_size.height + spacing)
        end

        -- 构建区域定义
        local area = {
            left_top = { x = current_x, y = current_y },
            right_bottom = { x = current_x + area_size.width, y = current_y + area_size.height }
        }

        -- 根据资源类型选择不同的生成方式
        if tile_resources[current_resource.name] then
            -- 地块类型资源 - 使用set_tiles
            generate_tile_in_area(surface, area, current_resource.name)
            success_count = success_count + 1
        elseif fluid_resources[current_resource.name] or normal_resources[current_resource.name] then
            -- 流体资源或普通资源 - 使用create_entity
            if generate_resources_in_area(surface, area, current_resource.name, current_resource.amount) then
                success_count = success_count + 1
            end
        else
            return false
        end
    end

    return success_count == #resources
end

--------------------------------------------------------------------------------------
-- 在指定坐标区域生成资源
-- @param surface: 目标表面
-- @param x1, y1: 左上角坐标
-- @param x2, y2: 右下角坐标
-- @param resource_name: 资源类型名称
-- @param amount: 资源数量
local function generate_resources_by_coordinates(surface, x1, y1, x2, y2, resource_name, amount)
    local area = {
        left_top = { x = math.min(x1, x2), y = math.min(y1, y2) },
        right_bottom = { x = math.max(x1, x2), y = math.max(y1, y2) }
    }

    return generate_resources_in_area(surface, area, resource_name, amount)
end

--------------------------------------------------------------------------------------
-- 在 nauvis 生成一系列资源矿藏
-- 适合地球星球的资源配置
local function generate_resource_nauvis(amount)
    local surface = game.surfaces.nauvis

    -- 生成铜矿区域1 (X: -176 to -144)
    generate_resources_by_coordinates(
        surface,
        -176, -160, -144, -96,
        "copper-ore",
        amount
    )

    -- 生成铁矿区域1 (X: -144 to -112)
    generate_resources_by_coordinates(
        surface,
        -144, -160, -112, -96,
        "iron-ore",
        amount
    )

    -- 生成铜矿区域2 (X: -112 to -80)
    generate_resources_by_coordinates(
        surface,
        -112, -160, -80, -96,
        "copper-ore",
        amount
    )

    -- 生成铁矿区域2 (X: -80 to -48)
    generate_resources_by_coordinates(
        surface,
        -80, -160, -48, -96,
        "iron-ore",
        amount
    )

    -- 生成铁矿区域3 (X: -48 to -16)
    generate_resources_by_coordinates(
        surface,
        -48, -160, -16, -96,
        "iron-ore",
        amount
    )

    -- 生成铁矿区域4 (X: -16 to 16)
    generate_resources_by_coordinates(
        surface,
        -16, -160, 16, -96,
        "iron-ore",
        amount
    )

    -- 生成石头区域 (X: 16 to 48)
    generate_resources_by_coordinates(
        surface,
        16, -160, 48, -96,
        "stone",
        amount
    )

    -- 生成铀矿区域 (X: 48 to 80)
    generate_resources_by_coordinates(
        surface,
        48, -160, 80, -96,
        "uranium-ore",
        amount
    )

    -- 预留区域-石油 (X: 80 to 112)
    -- 在指定区域生成石油
    surface.create_entity {
        name = "crude-oil",
        position = { 96, -128 },
        amount = amount * 1024 * 1024
    }

    -- 预留区域-水 (X: 112 to 144)
    -- 在指定区域生成水
    for x = 112, 143 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "water", position = { x, y } } })
        end
    end

    -- 生成煤炭区域 (X: 144 to 176)
    generate_resources_by_coordinates(
        surface,
        144, -160, 176, -96,
        "coal",
        amount
    )

    return true
end

--------------------------------------------------------------------------------------
-- 在 vulcanus 生成一系列资源矿藏
-- 适合火山星球的资源配置
local function generate_resource_vulcanus(amount)
    local surface = game.surfaces.vulcanus

    -- 生成煤炭区域 (X: -80 to -48)
    generate_resources_by_coordinates(
        surface,
        -80, -160, -48, -96,
        "coal",
        amount
    )

    -- 生成方解石区域 (X: -48 to -16)
    generate_resources_by_coordinates(
        surface,
        -48, -160, -16, -96,
        "calcite",
        amount
    )

    -- 预留区域-硫酸 (X: -16 to 16)
    -- 在指定区域生成硫酸
    surface.create_entity {
        name = "sulfuric-acid-geyser",
        position = { 0, -128 },
        amount = amount * 1024 * 1024
    }

    -- 生成钨矿区域 (X: 16 to 48)
    generate_resources_by_coordinates(
        surface,
        16, -160, 48, -96,
        "tungsten-ore",
        amount
    )

    -- 生成熔岩区域 (X: 48 to 80)
    for x = 48, 80 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "lava", position = { x, y } } })
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 在 gleba 生成一系列资源矿藏
-- 适合沼泽星球的资源配置
local function generate_resource_gleba(amount)
    local surface = game.surfaces.gleba

    -- 生成石头区域 (X: -80 to -48)
    generate_resources_by_coordinates(
        surface,
        -80, -160, -48, -96,
        "stone",
        amount
    )

    -- 生成果冻果沃土 (X: -48 to -16)
    for x = -48, -16 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "overgrowth-jellynut-soil", position = { x, y } } })
        end
    end

    -- 生成玉玛果沃土 (X: -16 to 16)
    for x = -16, 16 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "overgrowth-yumako-soil", position = { x, y } } })
        end
    end

    -- 生成沼泽水域 (X: 16 to 48)
    for x = 16, 48 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "gleba-deep-lake", position = { x, y } } })
        end
    end

    -- 生成沼泽水域 (X: 48 to 80)
    for x = 48, 80 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "gleba-deep-lake", position = { x, y } } })
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 在 fulgora 生成一系列资源矿藏
-- 适合雷电星球的资源配置
local function generate_resource_fulgora(amount)
    local surface = game.surfaces.fulgora

    -- 生成废料回收区域 (X: -80 to -48)
    generate_resources_by_coordinates(
        surface,
        -80, -160, -48, -96,
        "scrap",
        amount
    )

    -- 生成废料回收区域 (X: -48 to -16)
    generate_resources_by_coordinates(
        surface,
        -48, -160, -16, -96,
        "scrap",
        amount
    )

    -- 生成废料回收区域 (X: -16 to 16)
    -- 在指定区域生成硫酸
    generate_resources_by_coordinates(
        surface,
        -16, -160, 16, -96,
        "scrap",
        amount
    )

    -- 生成废料回收区域 (X: -16 to 16)
    generate_resources_by_coordinates(
        surface,
        -16, -160, 16, -96,
        "scrap",
        amount
    )

    -- 生成油海 (X: 16 to 48)
    for x = 16, 48 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "oil-ocean-shallow", position = { x, y } } })
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 在 aquilo 生成一系列资源矿藏
-- 适合冰雪星球的资源配置
local function generate_resource_aquilo(amount)
    local surface = game.surfaces.aquilo

    -- 预留区域-lithium-brine (X: 80 to -48)
    -- 在指定区域生成lithium-brine
    surface.create_entity {
        name = "lithium-brine",
        position = { -64, -128 },
        amount = amount * 1024 * 1024
    }

    -- 预留区域-fluorine-vent (X: -48 to -16)
    -- 在指定区域生成fluorine-vent
    surface.create_entity {
        name = "fluorine-vent",
        position = { -32, -128 },
        amount = amount * 1024 * 1024
    }

    -- 预留区域-crude-oil (X: -16 to 16)
    -- 在指定区域生成crude-oil
    surface.create_entity {
        name = "crude-oil",
        position = { 0, -128 },
        amount = amount * 1024 * 1024
    }

    -- 生成氨海 (X: 16 to 48)
    for x = 16, 48 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "ammoniacal-ocean", position = { x, y } } })
        end
    end

    -- 生成氨海 (X: 48 to 80)
    for x = 48, 80 do
        for y = -160, -97 do
            surface.set_tiles({ { name = "ammoniacal-ocean", position = { x, y } } })
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 在新星球创建时清空中心区域
local function generate_resource_planet(surface)
    if not surface or not surface.valid then
        return false
    end

    if surface.name == "nauvis" then
        generate_resource_nauvis()
    elseif surface.name == "vulcanus" then
        generate_resource_vulcanus()
    elseif surface.name == "gleba" then
        generate_resource_gleba()
    elseif surface.name == "fulgora" then
        generate_resource_fulgora()
    elseif surface.name == "aquilo" then
        generate_resource_aquilo()
    end

    return true
end

--------------------------------------------------------------------------------------
-- 导出函数供其他文件使用
return {
    generate_resource_planet = generate_resource_planet
}

-- 使用示例:
-- 1. 单个资源 - 水平排列生成3个32x32的铁矿区域，间隔16格距离
-- generate_resources_pattern(game.surfaces.nauvis, {x=0, y=0}, "horizontal", {width=32, height=32}, 16,
-- {"iron-ore", "iron-ore", "iron-ore"}, 5000)
--
-- 2. 多个资源（字符串列表） - 按顺序循环生成不同资源
-- generate_resources_pattern(game.surfaces.nauvis, {x=0, y=0}, "horizontal", {width=32, height=32}, 16,
--   {"iron-ore", "copper-ore", "coal", "stone"}, 5000)  -- 按iron-ore, copper-ore, coal, stone的顺序循环
--
-- 3. 多个资源（详细配置） - 每种资源可以有不同的数量和密度
-- generate_resources_pattern(game.surfaces.nauvis, {x=0, y=0}, "vertical", {width=64, height=64}, 20, {
--   {name = "iron-ore", amount = 10000, density = 2048},
--   {name = "copper-ore", amount = 8000, density = 1536},
--   {name = "water", amount = 1, density = 1},  -- 地块类型，amount和density会被忽略
--   {name = "crude-oil", amount = 50000, density = 1024}  -- 流体资源
-- }, nil)
--
-- 4. 混合类型资源 - 包含矿物、地块和流体
-- generate_resources_pattern(game.surfaces.nauvis, {x=100, y=100}, "horizontal", {width=48, height=48}, 10, {
--   "iron-ore",  -- 使用默认配置
--   {name = "water", amount = 1},  -- 地块类型
--   {name = "crude-oil", amount = 100000, density = 2048}  -- 流体资源
-- }, 6000)  -- 默认数量6000
