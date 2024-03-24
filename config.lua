Config = {}

Config.Framework = "vorp" -- rsg

Config.Zones = {
    ["zone1"] = {
        label = "Zone 1 Teleport",
        teleports = {
            [1] = vector4(-67.2791, -392.3473, 71.8717, 170.0787),
            [2] = vector4(-75.3074, -400.5630, 71.4296, 142.0636),
        },
        distance = 2,
        isLocked = true, -- Default Locked Status
        -- requiredKey = true, -- If it's true, anyone with the key will have access.
        -- requiredJobs = {-- If it's true, anyone with the job will have access.
        --     ["sheriff"] = 4
        -- },
        authorizedIdentifiers = {-- If it's true, the person whose identifier is in the list will have access
            ["license:123"] = true,
            ["steam:123"] = true,
            ["discord:123"] = true,
            ["charid:2"] = true,
        },
        
    }
}

