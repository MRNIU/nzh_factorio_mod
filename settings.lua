-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- settings.lua for MRNIU/nzh_factorio_mod.

require("startup.settings")

data:extend({
    {
        type = "int-setting",
        name = "nzh_mining_drill",
        setting_type = "startup",
        default_value = 0,
        allowed_values = { 0, 1, 2, 3 }
    }
})
