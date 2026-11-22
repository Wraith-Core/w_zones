# w_zones

Lightweight, **100% native RDR2** zone announcement banner for **Wraith Core** (and standalone RedM servers).

Uses Red Dead Redemption 2's built-in native location shard (`_UI_FEED_POST_LOCATION_SHARD`) with **zero NUI** overhead.

## Features

- Native RDR2 top location banner (no HTML/CSS/NUI frame).
- Covers all major RDR2 towns, districts, and states.
- Optional in-game clock (respects player 12h/24h setting) and local temperature (respects °C/°F setting).
- `/zone` command to re-display the current location at any time.
- Client exports for other resources.

## Installation

1. Place `w_zones` inside `resources/[wraith]/w_zones`.
2. Add `ensure w_zones` to your `server.cfg` (after `w_core`).

## Configuration

Edit [`config.lua`](config.lua):

```lua
Config.PollInterval      = 1000   -- ms between zone checks
Config.Duration          = 4000   -- banner duration in ms
Config.ShowTime          = true   -- show in-game clock
Config.ShowTemperature   = true   -- show local temperature
Config.AnnounceDistricts = true   -- announce district crossings
Config.AnnounceStates    = true   -- announce state crossings
Config.Command           = 'zone' -- command to display current zone (false to disable)
Config.WaitForLogin      = true   -- wait for LocalPlayer.state.isLoggedIn
```

## Client Exports

```lua
-- Returns { town = string?, district = string?, state = string? }
local zone = exports.w_zones:GetCurrentZone()

-- Displays the native banner for the player's current location
exports.w_zones:ShowCurrentZone()

-- Displays a custom native RDR2 location banner
exports.w_zones:ShowLocationBanner('The Heartlands, NH · 14:30 · 22°C', 'Valentine', 4000)
```

## License

MIT — © Wraith Studio
