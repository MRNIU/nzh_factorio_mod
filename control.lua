-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

-- 引入区域清理器模块
local area_cleaner = require("area_cleaner")
local generate_resources = require("generate_resources")

--------------------------------------------------------------------------------------
-- 在游戏初始化时清空中心区域
local function OnInit()
    -- 清空中心区域
    area_cleaner.clear_center_area(game.surfaces.nauvis)

    generate_resources.generate_resource_nauvis()
end

--------------------------------------------------------------------------------------
-- 在新星球创建时清空中心区域
local function OnSurfaceCreated(event)
    local surface = game.surfaces[event.surface_index]

    area_cleaner.clear_center_area(surface)
    generate_resources.generate_resource_planet(surface)
end

script.on_init(OnInit)
script.on_event(defines.events.on_surface_created, OnSurfaceCreated)
