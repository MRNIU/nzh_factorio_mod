-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- data-final-fixes.lua for MRNIU/nzh_factorio_mod.

local function NZH_handcraft_setup()
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
end

NZH_handcraft_setup()
