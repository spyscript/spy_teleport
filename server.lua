local function checkAuth(source,uniqueID)
    local src = source
    local conf = Config.Zones[uniqueID]
    local isAuth = true
    local Player = SPYGetPlayerData(src)
    if conf.authorizedIdentifiers then
        local identifiers = {}
        for i = 0, GetNumPlayerIdentifiers(src) - 1 do
            local id = GetPlayerIdentifier(src, i)
            identifiers[id] = true
        end
        identifiers["charid:"..Player.charid] = true
        local retval = false
        for key,value in pairs(conf.authorizedIdentifiers) do
            if identifiers[key] then
                retval = true
                break
            end
        end
        isAuth = retval
        if not isAuth then return isAuth end
    end
    if conf.requiredJobs then
        if conf.requiredJobs[Player.job] and conf.requiredJobs[Player.job] <= Player.grade then
            --done
        else
            isAuth = false
            return isAuth
        end
    end
    if conf.requiredKey then
        local item = SPYGetItem(src,"roomkey",{description=uniqueID.." Rooms Key",spyscript = uniqueID})
        if item then
            if item.metadata and item.metadata.spyscript and item.metadata.spyscript == uniqueID then
                -- done
            else
                isAuth = false
            end
        else
            isAuth = false
        end
    end
    return isAuth
end

RegisterNetEvent('spy_teleport:server:checkAuthorized',function(key,targetIndex)
    local src = source
    if Config.Zones[key].isLocked then
        Notify(src,"Door is locked!","error",4000)
    else
        -- if checkAuth(src,key) then
            TriggerClientEvent('spy_teleport:client:teleport',src,key,targetIndex)
        -- else
        --     Notify(src,"You do not permission to be enter here!","error",4000)
        -- end
    end
end)

RegisterNetEvent('spy_teleport:server:setLockStatus',function(key)
    local src = source
    if checkAuth(src,key) then
        Config.Zones[key].isLocked = not Config.Zones[key].isLocked
        TriggerClientEvent('spy_teleport:client:updateConfig',-1,Config.Zones)
    else
        Notify(src,"You do not permission to be enter here!","error",4000)
    end
end)

RegisterNetEvent('spy_teleports:server:getConfig',function()
    local src = source
    TriggerClientEvent('spy_teleport:client:updateConfig',src,Config.Zones)
end)

-- /givekey id keyname
RegisterCommand('givekey',function(source,args,raw)
    local src = source

    if SPYIsAdmin(src) then
        if args and args[1] and args[2] then
            local target = tonumber(args[1])
            SPYAddItem(target, "roomkey", 1, {description=args[2].." Rooms Key",spyscript = args[2]})
        else
            Notify(src,"/givekey <id> <keyName>","error",4000)
        end
    else
        Notify(src,"You are not admin","error",4000)
    end
end)
