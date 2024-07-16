-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- data.lua for MRNIU/nzh_factorio_mod.

require("utils")
require("prototypes.styles")

-- 设置电力采矿机开采速度为 45，即一条蓝带
data.raw["mining-drill"]["electric-mining-drill"].mining_speed = 45

-- 设置插件只占用一个格子
for _, energyshield in pairs(data.raw["energy-shield-equipment"]) do
    energyshield.shape = {width = 1, height = 1, type = "full"}
end

for _, solarpanelequipment in pairs(data.raw["solar-panel-equipment"]) do
    solarpanelequipment.shape = {width = 1, height = 1, type = "full"}
end

for _, reactorequipment in pairs(data.raw["generator-equipment"]) do
    reactorequipment.shape = {width = 1, height = 1, type = "full"}
end

for _, batteryequipment in pairs(data.raw["battery-equipment"]) do
    batteryequipment.shape = {width = 1, height = 1, type = "full"}
end

for _, roboportequipment in pairs(data.raw["roboport-equipment"]) do
    roboportequipment.shape = {width = 1, height = 1, type = "full"}
end

for _, nightvisionequipment in pairs(data.raw["night-vision-equipment"]) do
    nightvisionequipment.shape = {width = 1, height = 1, type = "full"}
end

for _, exoskeletonequipment in pairs(data.raw["movement-bonus-equipment"]) do
    exoskeletonequipment.shape = {width = 1, height = 1, type = "full"}
end

for _, activedefenseequipment in pairs(data.raw["active-defense-equipment"]) do
    activedefenseequipment.shape = {width = 1, height = 1, type = "full"}
end

-- 设置管道泵可随意放置
data.raw["offshore-pump"]["offshore-pump"].adjacent_tile_collision_test = { "ground-tile", "water-tile", "object-layer" }
data.raw["offshore-pump"]["offshore-pump"].adjacent_tile_collision_mask = nil
data.raw["offshore-pump"]["offshore-pump"].placeable_position_visualization = nil
data.raw["offshore-pump"]["offshore-pump"].flags = {"placeable-neutral", "player-creation"}
data.raw["offshore-pump"]["offshore-pump"].adjacent_tile_collision_box = { { -0.5, -0.25}, {0.5, 0.25} }
