local SUN_TEXTURE = "sun.png"
local SUN_SCALE = 3.75

-- Define the colors for sunrise, noon, and sunset
local SUNRISE_COLOR = {r = 255, g = 223, b = 0}  -- Yellow
local NOON_COLOR = {r = 255, g = 255, b = 255}    -- White
local SUNSET_COLOR = {r = 255, g = 223, b = 0}    -- Yellow

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
    if time_of_day < 0.5 then
        -- Sunrise to noon
        return lerp_color(SUNRISE_COLOR, NOON_COLOR, time_of_day * 2)
    else
        -- Noon to sunset
        return lerp_color(NOON_COLOR, SUNSET_COLOR, (time_of_day - 0.5) * 2)
    end
end

-- Function to update sun parameters
local function update_sun(player)
    local time_of_day = minetest.get_timeofday()
    local sun_color = get_sun_color(time_of_day)
    local sun_tonemap = color_to_hex(sun_color)
    local sun_arg = {
        texture = SUN_TEXTURE,
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