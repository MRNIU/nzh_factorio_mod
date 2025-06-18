-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- area_cleaner.lua for MRNIU/nzh_factorio_mod.
-- 区域清理器 - 用于清空指定区域内的所有实体并替换地表

--------------------------------------------------------------------------------------
-- 清空指定区域内的所有实体，并将地表替换为土地
-- @param surface: 目标表面对象
-- @param area: 区域定义 {left_top = {x, y}, right_bottom = {x, y}}
-- @return boolean: 成功返回true，失败返回false
local function clear_area_to_land(surface, area)
    if not surface or not surface.valid then
        return false
    end
    
    if not area or not area.left_top or not area.right_bottom then
        return false
    end
    
    -- 删除所有实体（包括敌人、建筑、树木、岩石等）
    local entities = surface.find_entities(area)
    for _, entity in pairs(entities) do
        if entity.valid then
            -- 不删除角色（玩家）
            if entity.type ~= "character" then
                entity.destroy()
            end
        end
    end
    
    -- 删除所有资源
    local resources = surface.find_entities_filtered{
        area = area,
        type = "resource"
    }
    for _, resource in pairs(resources) do
        if resource.valid then
            resource.destroy()
        end
    end
    
    -- 删除悬崖
    local cliffs = surface.find_entities_filtered{
        area = area,
        type = "cliff"
    }
    for _, cliff in pairs(cliffs) do
        if cliff.valid then
            cliff.destroy()
        end
    end
    
    -- 将地形替换为草地（土地）
    local tiles = {}
    local left_top = area.left_top
    local right_bottom = area.right_bottom
    
    for x = left_top.x or left_top[1], right_bottom.x or right_bottom[1] - 1 do
        for y = left_top.y or left_top[2], right_bottom.y or right_bottom[2] - 1 do
            table.insert(tiles, {name = "grass-1", position = {x, y}})
        end
    end
    
    -- 设置地形
    surface.set_tiles(tiles)
    
    return true
end

--------------------------------------------------------------------------------------
-- 清空玩家周围指定大小的区域
-- @param player_index: 玩家索引
-- @param size: 区域大小（可选，默认100）
local function clear_area_around_player(player_index, size)
    local player = game.get_player(player_index)
    if not player or not player.valid then
        return false
    end
    
    size = size or 100
    local half_size = size / 2
    local position = player.position
    
    local area = {
        left_top = {x = position.x - half_size, y = position.y - half_size},
        right_bottom = {x = position.x + half_size, y = position.y + half_size}
    }
    
    local success = clear_area_to_land(player.surface, area)
    if success then
        player.print("已清空周围 " .. size .. "x" .. size .. " 区域并替换为土地")
    else
        player.print("清空区域失败")
    end
    
    return success
end

--------------------------------------------------------------------------------------
-- 清空指定坐标区域
-- @param surface: 目标表面
-- @param x1, y1: 左上角坐标
-- @param x2, y2: 右下角坐标
local function clear_area_by_coordinates(surface, x1, y1, x2, y2)
    local area = {
        left_top = {x = math.min(x1, x2), y = math.min(y1, y2)},
        right_bottom = {x = math.max(x1, x2), y = math.max(y1, y2)}
    }
    
    return clear_area_to_land(surface, area)
end

--------------------------------------------------------------------------------------
-- 导出函数供其他文件使用
return {
    clear_area_to_land = clear_area_to_land,
    clear_area_around_player = clear_area_around_player,
    clear_area_by_coordinates = clear_area_by_coordinates
}
