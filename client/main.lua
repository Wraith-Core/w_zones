--[[
    w_zones — Free Native RDR2 Zone Notifications for Wraith Core
    Uses RDR2's built-in native location banner (_UI_FEED_POST_LOCATION_SHARD) with zero NUI.
]]

local ZONE = {
    STATE = 0,
    TOWN = 1,
    DISTRICT = 10,
}

local TOWNS = {
    [459833523]   = 'Valentine',
    [2046780049]  = 'Rhodes',
    [-765540529]  = 'Saint Denis',
    [427683330]   = 'Strawberry',
    [1053078005]  = 'Blackwater',
    [-744494798]  = 'Armadillo',
    [-1524959147] = 'Tumbleweed',
    [7359335]     = 'Annesburg',
    [2126321341]  = 'Van Horn Trading Post',
    [201158410]   = 'Manicato',
    [1463094051]  = 'Manzanita Post',
}

local DISTRICTS = {
    [2025841068]  = 'Bayou Nwa',
    [822658194]   = 'Big Valley',
    [1308232528]  = 'Bluewater Marsh',
    [1835499550]  = 'Cumberland Forest',
    [476637847]   = 'Great Plains',
    [1645618177]  = 'Grizzlies East',
    [-120156735]  = 'Grizzlies West',
    [-512529193]  = 'Guarma',
    [131399519]   = 'The Heartlands',
    [178647645]   = 'Roanoke Ridge',
    [-864275692]  = 'Scarlett Meadows',
    [1684533001]  = 'Tall Trees',
    [-2066240242] = 'Gaptooth Ridge',
    [-2145992129] = 'Rio Bravo',
    [-108848014]  = 'Cholla Springs',
    [892930832]   = "Hennigan's Stead",
}

local STATES = {
    [`Ambarino`]           = { name = 'Ambarino',       short = 'AM' },
    [`Guarma`]             = { name = 'Guarma',         short = 'GU' },
    [`lemoyne`]            = { name = 'Lemoyne',        short = 'LE' },
    [`LowerWestElizabeth`] = { name = 'West Elizabeth', short = 'WE' },
    [`UpperWestElizabeth`] = { name = 'West Elizabeth', short = 'WE' },
    [`WestElizabeth`]      = { name = 'West Elizabeth', short = 'WE' },
    [`NewAustin`]          = { name = 'New Austin',     short = 'NA' },
    [`NewHanover`]         = { name = 'New Hanover',    short = 'NH' },
}

local lastZone = { town = nil, district = nil, state = nil }

local function getZoneInfo(coords)
    local townHash     = GetMapZoneAtCoords(coords.x, coords.y, coords.z, ZONE.TOWN)
    local districtHash = GetMapZoneAtCoords(coords.x, coords.y, coords.z, ZONE.DISTRICT)
    local stateHash    = GetMapZoneAtCoords(coords.x, coords.y, coords.z, ZONE.STATE)

    local stateEntry = STATES[stateHash]
    return {
        town       = TOWNS[townHash],
        district   = DISTRICTS[districtHash],
        state      = stateEntry and stateEntry.name or nil,
        stateShort = stateEntry and stateEntry.short or nil,
    }
end

local function buildReadings(coords)
    local parts = {}

    if Config.ShowTime then
        local h, m = GetClockHours(), GetClockMinutes()
        if ShouldUse_24HourClock() then
            parts[#parts + 1] = ('%02d:%02d'):format(h, m)
        else
            local h12 = h % 12
            if h12 == 0 then h12 = 12 end
            parts[#parts + 1] = ('%02d:%02d %s'):format(h12, m, h < 12 and 'AM' or 'PM')
        end
    end

    if Config.ShowTemperature then
        local c = GetTemperatureAtCoords(coords.x, coords.y, coords.z)
        if ShouldUseMetricTemperature() then
            parts[#parts + 1] = ('%d°C'):format(math.ceil(c))
        else
            parts[#parts + 1] = ('%d°F'):format(math.ceil(c * 9 / 5 + 32))
        end
    end

    return table.concat(parts, '  |  ')
end

local function showBanner(title, region, coords)
    if not title or title == '' then return end

    local readings = buildReadings(coords)
    local subtitle = region or ''
    if readings ~= '' then
        subtitle = subtitle ~= '' and (subtitle .. '  ·  ' .. readings) or readings
    end

    exports[GetCurrentResourceName()]:ShowLocationBanner(subtitle, title, Config.Duration or 4000)
end

local function showCurrentZone()
    local ped = PlayerPedId()
    if not ped or ped == 0 then return false end

    local coords = GetEntityCoords(ped)
    local info = getZoneInfo(coords)

    if info.town then
        local region = info.district
            and (info.stateShort and (info.district .. ', ' .. info.stateShort) or info.district)
            or info.state
        showBanner(info.town, region, coords)
        return true
    end

    if info.district then
        showBanner(info.district, info.state, coords)
        return true
    end

    if info.state then
        showBanner(info.state, nil, coords)
        return true
    end

    return false
end

local function isPlayerReady()
    if not Config.WaitForLogin then return true end
    return LocalPlayer.state.isLoggedIn == true
end

CreateThread(function()
    local poll = math.max(250, tonumber(Config.PollInterval) or 1000)

    while true do
        Wait(poll)

        if isPlayerReady() and not IsPauseMenuActive() then
            local ped = PlayerPedId()
            if ped and ped ~= 0 then
                local coords = GetEntityCoords(ped)
                local info = getZoneInfo(coords)

                if info.town and info.town ~= lastZone.town then
                    local region = info.district
                        and (info.stateShort and (info.district .. ', ' .. info.stateShort) or info.district)
                        or info.state
                    showBanner(info.town, region, coords)
                elseif not info.town and Config.AnnounceDistricts and info.district and info.district ~= lastZone.district then
                    showBanner(info.district, info.state, coords)
                elseif not info.town and not info.district and Config.AnnounceStates and info.state and info.state ~= lastZone.state then
                    showBanner(info.state, nil, coords)
                end

                lastZone.town     = info.town
                lastZone.district = info.district
                lastZone.state    = info.state
            end
        end
    end
end)

if Config.Command and Config.Command ~= '' then
    RegisterCommand(Config.Command, function()
        showCurrentZone()
    end, false)
end

exports('GetCurrentZone', function()
    local ped = PlayerPedId()
    if not ped or ped == 0 then return {} end
    local info = getZoneInfo(GetEntityCoords(ped))
    return {
        town = info.town,
        district = info.district,
        state = info.state,
    }
end)

exports('ShowCurrentZone', showCurrentZone)
