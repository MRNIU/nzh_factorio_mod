-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- data.lua for MRNIU/nzh_factorio_mod.

-- require("bottleneck.data-final-fixes")

--- 手搓一切
for k, character in pairs(data.raw.character) do
    local alreadyIn = {}
    local count = 0
    local characterCategories = character.crafting_categories
    for category, _ in pairs(characterCategories) do
        alreadyIn[category] = 1
        count = count + 1
    end
    for category, _ in pairs(data.raw['recipe-category']) do
        if not alreadyIn[category] then
            count = count + 1
            characterCategories[count] = category
        end
    end
end
