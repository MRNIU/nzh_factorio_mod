-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- settings.lua for MRNIU/nzh_factorio_mod.

data:extend({
    {
        type = "int-setting",
        name = "nzh_startup_base_level",
        setting_type = "startup",
        default_value = 0,
        allowed_values = { 0, 1, 2, 3 }
    }
})
