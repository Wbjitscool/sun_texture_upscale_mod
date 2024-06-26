local SUN_TEXTURE = "sun.png"
local SUN_SCALE = 3.25
local TOTAL_FRAMES = 32  -- Total number of frames in the texture

-- Define the colors for sunrise, noon, sunset, and night
local SUNRISE_COLOR = {r = 255, g = 223, b = 0}  -- Yellow
local NOON_COLOR = {r = 255, g = 255, b = 255}   -- White
local SUNSET_COLOR = {r = 255, g = 223, b = 0}   -- Yellow
local NIGHT_COLOR = {r = 0, g = 0, b = 0}        -- Black

-- Function to linearly interpolate between two colors
local function lerp_color(color1, color2, t)
    return {
        r = math.floor(color1.r + (color2.r - color1.r) * t),
        g = math.floor(color1.g + (color2.g - color1.g) * t),
        b = math.floor(color1.b + (color2.b - color1.b) * t)
    }
end

-- Convert color to hex string
local function color_to_hex(color)
    return string.format("#%02x%02x%02x", color.r, color.g, color.b)
end

-- Calculate the sun color based on time of day
local function get_sun_color(time_of_day)
    if time_of_day < 0.04 or time_of_day >= 0.95 then
        -- Night
        return NIGHT_COLOR
    elseif time_of_day < 0.14 then
        -- Late night to early morning (faster sunrise transition)
        return lerp_color(NIGHT_COLOR, SUNRISE_COLOR, (time_of_day - 0.04) * 20)
    elseif time_of_day < 0.28 then
        -- Morning to mid morning (white sun)
        return lerp_color(SUNRISE_COLOR, NOON_COLOR, (time_of_day - 0.14) * (5/3))
    elseif time_of_day < 0.8 then
        -- Mid morning to late evening (white sun)
        return NOON_COLOR
    elseif time_of_day < 0.85 then
        -- Late evening to early night (faster sunset transition)
        return lerp_color(NOON_COLOR, NIGHT_COLOR, (time_of_day - 0.8) * 10)
    else
        -- Early night to late night (faster sunset transition)
        return NIGHT_COLOR
    end
end

-- Function to calculate the frame index based on time of day
local function get_frame_index(time_of_day)
    return math.floor(time_of_day * TOTAL_FRAMES) % TOTAL_FRAMES
end

-- Function to update sun parameters
local function update_sun(player)
    local time_of_day = minetest.get_timeofday()
    local sun_color = get_sun_color(time_of_day)
    local sun_tonemap = color_to_hex(sun_color)
    local frame_index = get_frame_index(time_of_day)
    local sun_arg = {
        texture = SUN_TEXTURE .. "^[verticalframe:" .. TOTAL_FRAMES .. ":" .. frame_index,
        tonemap = sun_tonemap,
        scale = SUN_SCALE
    }
    player:set_sun(sun_arg)
end

-- Update sun for all players in globalstep
minetest.register_globalstep(function(dtime)
    local players = minetest.get_connected_players()
    for _, player in ipairs(players) do
        update_sun(player)
    end
end)

-- Set initial sun parameters when a player joins
minetest.register_on_joinplayer(function(player)
    update_sun(player)
end)
