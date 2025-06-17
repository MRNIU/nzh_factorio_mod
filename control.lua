-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- control.lua for MRNIU/nzh_factorio_mod.

--------------------------------------------------------------------------------------
local function OnInit()
    if remote.interfaces["freeplay"] then
        -- 不生成飞船残骸
        remote.call("freeplay", "set_disable_crashsite", true)
        -- 跳过开场介绍
        remote.call("freeplay", "set_skip_intro", true)
    end

end

--------------------------------------------------------------------------------------
script.on_init(OnInit)
