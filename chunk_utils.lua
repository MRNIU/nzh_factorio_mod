-- This file is a part of MRNIU/nzh_factorio_mod
-- (https://github.com/MRNIU/nzh_factorio_mod).
--
-- chunk_utils.lua for MRNIU/nzh_factorio_mod.
-- 区块工具 - 用于处理区块生成相关操作

--------------------------------------------------------------------------------------
-- 强制生成指定区域的所有chunk
-- @param surface: 目标表面对象
-- @param area: 区域定义 {left_top = {x, y}, right_bottom = {x, y}}
-- @return boolean: 成功返回true，失败返回false
local function force_generate_chunks(surface, area)
    if not surface or not surface.valid then
        return false
    end

    if not area or not area.left_top or not area.right_bottom then
        return false
    end

    local left_top = area.left_top
    local right_bottom = area.right_bottom

    -- 计算chunk范围（每个chunk是32x32）
    local chunk_left = math.floor((left_top.x or left_top[1]) / 32)
    local chunk_top = math.floor((left_top.y or left_top[2]) / 32)
    local chunk_right = math.floor((right_bottom.x or right_bottom[1]) / 32)
    local chunk_bottom = math.floor((right_bottom.y or right_bottom[2]) / 32)

    -- 强制生成所有相关的chunk
    for chunk_x = chunk_left, chunk_right do
        for chunk_y = chunk_top, chunk_bottom do
            surface.request_to_generate_chunks({ chunk_x * 32, chunk_y * 32 }, 0)
            surface.force_generate_chunk_requests()
        end
    end

    return true
end

--------------------------------------------------------------------------------------
-- 导出函数供其他文件使用
return {
    force_generate_chunks = force_generate_chunks
}
