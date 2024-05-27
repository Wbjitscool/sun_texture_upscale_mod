# `sun` API

This API provides functionality related to the sun.

## `default_sun.get_sun()`

Returns the current texture of the default_sun.

* 0 = Morning
* 1 = Midday
* 2 = Afternoon
* 3 = Evening
* 4 = Night

## Example Usage:

```lua
local = default_sun.get_sun()
-- Use value to determine default_sun position or behavior
