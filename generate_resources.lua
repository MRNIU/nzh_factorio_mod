-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- generate_resources.lua for MRNIU/nzh_factorio_mod.
-- 资源生成器 - 用于在指定区域内生成指定类型与数量的资源

-- 引入区块工具模块
local chunk_utils = require("chunk_utils")

--------------------------------------------------------------------------------------
-- 在指定surface指定区域内生成指定类型与数量的资源
-- @param surface: 目标表面对象
-- @param area: 区域定义 {left_top = {x, y}, right_bottom = {x, y}}
-- @param resource_name: 资源类型名称（如 "iron-ore", "copper-ore", "coal", "stone", "uranium-ore", "crude-oil"）
-- @param total_amount: 要生成的资源总数量
-- @param density: 资源密度（可选，默认为每个tile放置的资源数量的基础值）
-- @return boolean: 成功返回true，失败返回false
local function generate_resources_in_area(surface, area, resource_name, total_amount, density)
    if not surface or not surface.valid then
        return false
    end

    if not area or not area.left_top or not area.right_bottom then
        return false
    end

    if not resource_name or not total_amount or total_amount <= 0 then
        return false
    end
    density = density or 1024 -- 默认密度

    -- 强制生成区域内的所有chunk
    chunk_utils.force_generate_chunks(surface, area)

    -- 计算区域大小
    local left_top = area.left_top
    local right_bottom = area.right_bottom
    local width = (right_bottom.x or right_bottom[1]) - (left_top.x or left_top[1])
    local height = (right_bottom.y or right_bottom[2]) - (left_top.y or left_top[2])
    local area_size = width * height

    if area_size <= 0 then
        return false
    end

    -- 先清除区域内现有的资源
    local existing_resources = surface.find_entities_filtered {
        area = area,
        type = "resource"
    }
    for _, resource in pairs(existing_resources) do
        if resource.valid then
            resource.destroy()
        end
    end

    -- 生成资源位置列表
    local positions = {}
    for x = left_top.x or left_top[1], (right_bottom.x or right_bottom[1]) - 1 do
        for y = left_top.y or left_top[2], (right_bottom.y or right_bottom[2]) - 1 do
            -- 检查该位置是否可以放置资源（没有其他实体占用）
            local entities_at_position = surface.find_entities_filtered {
                position = { x, y },
                collision_mask = "resource"
            }
            if #entities_at_position == 0 then
                table.insert(positions, { x = x, y = y })
            end
        end
    end

    if #positions == 0 then
        return false -- 没有可用位置
    end

    -- 计算每个位置的资源数量
    local amount_per_position = math.max(1, math.floor(total_amount / #positions))
    local remaining_amount = total_amount

    -- 在每个可用位置生成资源
    for i, position in pairs(positions) do
        if remaining_amount <= 0 then
            break
        end

        local amount_to_place = math.min(amount_per_position, remaining_amount)

        -- 创建资源实体
        local resource_entity = surface.create_entity {
            name = resource_name,
            position = position,
            amount = amount_to_place * density
        }

        if resource_entity and resource_entity.valid then
            remaining_amount = remaining_amount - amount_to_place
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 在指定坐标区域生成资源
-- @param surface: 目标表面
-- @param x1, y1: 左上角坐标
-- @param x2, y2: 右下角坐标
-- @param resource_name: 资源类型名称
-- @param total_amount: 要生成的资源总数量
-- @param density: 资源密度（可选，默认1024）
local function generate_resources_by_coordinates(surface, x1, y1, x2, y2, resource_name, total_amount, density)
    local area = {
        left_top = { x = math.min(x1, x2), y = math.min(y1, y2) },
        right_bottom = { x = math.max(x1, x2), y = math.max(y1, y2) }
    }

    return generate_resources_in_area(surface, area, resource_name, total_amount, density or 1024)
end

--------------------------------------------------------------------------------------
-- 在 nauvis 生成一系列资源矿藏
-- 适合地球星球的资源配置
local function generate_resource_nauvis(amount)
    local surface = game.surfaces.nauvis

    if not surface or not surface.valid then
        return false
    end

    if not amount or amount <= 0 then
        amount = 1024 * 8 -- 默认资源数量
    end

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

    if not surface or not surface.valid then
        return false
    end

    if not amount or amount <= 0 then
        amount = 1024 * 8
    end

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

    if not surface or not surface.valid then
        return false
    end

    if not amount or amount <= 0 then
        amount = 1024 * 8
    end

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

    if not surface or not surface.valid then
        return false
    end

    if not amount or amount <= 0 then
        amount = 1024 * 8
    end

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

    if not surface or not surface.valid then
        return false
    end

    if not amount or amount <= 0 then
        amount = 1024 * 8
    end

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
    generate_resources_in_area = generate_resources_in_area,
    generate_resources_by_coordinates = generate_resources_by_coordinates,
    generate_resource_nauvis = generate_resource_nauvis,
    generate_resource_vulcanus = generate_resource_vulcanus,
    generate_resource_gleba = generate_resource_gleba,
    generate_resource_fulgora = generate_resource_fulgora,
    generate_resource_aquilo = generate_resource_aquilo,
    generate_resource_planet = generate_resource_planet
}
