-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

-- 引入区域清理器模块
local area_cleaner = require("area_cleaner")

--------------------------------------------------------------------------------------
-- 在游戏初始化时清空中心区域
local function OnInit()
    -- 清空中心区域
    area_cleaner.clear_center_area(game.surfaces.nauvis)

end

--------------------------------------------------------------------------------------
script.on_init(OnInit)
