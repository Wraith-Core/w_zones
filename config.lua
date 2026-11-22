Config = {}

-- How often (in ms) to check if the player crossed into a new zone.
Config.PollInterval = 1000

-- Duration (in ms) the native RDR2 location banner stays on screen.
Config.Duration = 4000

-- Include the in-game clock in the subtitle line (follows the player's 12h/24h game setting).
Config.ShowTime = true

-- Include the local temperature in the subtitle line (follows the player's °C/°F game setting).
Config.ShowTemperature = true

-- Announce when crossing into a new district even if not inside a town.
Config.AnnounceDistricts = true

-- Announce when crossing into a new state.
Config.AnnounceStates = true

-- Command name to manually show the current location banner (set to false to disable).
Config.Command = 'zone'

-- Wait until LocalPlayer.state.isLoggedIn is true before showing banners.
-- Set to false if running standalone without a framework that sets isLoggedIn.
Config.WaitForLogin = true
