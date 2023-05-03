-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- settings.lua for MRNIU/nzh_factorio_mod.

data:extend(
    {
        {
            type = "int-setting",
            name = "nzh_time_int_maximum_speed",
            setting_type = "runtime-global",
            default_value = 64,
            allowed_values = { 2, 4, 8, 16, 32, 64, 128 }
        },
    }
)
