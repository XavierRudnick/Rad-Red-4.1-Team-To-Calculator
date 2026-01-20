-- Save this as "RR_Live_Export.lua" in mGBA
local PARTY_START = 0x02024284
local PKMN_SIZE = 100
local output_path = [[C:\Users\Xav\Desktop\PokeRadicalRedCode\Rad-Red-4.1-Team-To-Calculator\party_raw.txt]]

function export_to_file()
    local file = io.open(output_path, "w") -- Opens in "write" mode to overwrite
    if not file then return end

    for i = 0, 5 do
        local offset = PARTY_START + (i * PKMN_SIZE)
        local species = emu:read16(offset + 32) -- Your offset for species
        if species == 0 then break end

        -- Read relevant data points as raw IDs
        local level = emu:read8(offset + 84)
        local item = emu:read16(offset + 34)
        local pid = emu:read32(offset + 0)
        local ev_hp = emu:read8(offset + 56)
        local ev_attack = emu:read8(offset + 57)
        local ev_defense = emu:read8(offset + 58)
        local ev_speed = emu:read8(offset + 59)
        local ev_special_attack = emu:read8(offset + 60)
        local ev_special_defense = emu:read8(offset + 61)

        local ev_data = ev_hp | (ev_attack << 8) | (ev_defense << 16) | (ev_speed << 24)

        local iv_data = emu:read32(offset + 72)
        local move1 = emu:read16(offset + 44)
        local move2 = emu:read16(offset + 46)
        local move3 = emu:read16(offset + 48)
        local move4 = emu:read16(offset + 50)
        local current_hp = emu:read16(offset + 86)
        local max_hp = emu:read16(offset + 88)
        local status_raw = emu:read32(offset + 80)

        -- Ensure no nil values
        if iv_data == nil then iv_data = 0 end
        if move1 == nil then move1 = 0 end
        if move2 == nil then move2 = 0 end
        if move3 == nil then move3 = 0 end
        if move4 == nil then move4 = 0 end
        if current_hp == nil then current_hp = 0 end
        if max_hp == nil then max_hp = 0 end
        if status_raw == nil then status_raw = 0 end

        -- Write as a simple comma-separated line for Python to parse
        file:write(string.format("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n", species, level, item, pid, ev_data, iv_data, move1, move2, move3, move4, current_hp, max_hp, status_raw))
    end
    file:close() -- Always close to ensure data is flushed to disk
    console:log("Team exported to party_raw.txt")
end

-- Hotkey: Press L + R (bitmask 768) to trigger
callbacks:add("frame", function()
    if emu:getKeys() == 768 then
        export_to_file()
    end
end)