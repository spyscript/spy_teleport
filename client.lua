local prompts = GetRandomIntInRange(0, 0xffffff)
local movements = {}
local keysTable = {
    {"Enter", 0xC7B5340A},
    {"Unlock", 0x760A9C6F},
}

Citizen.CreateThread(function()
    Citizen.Wait(10)
    for _, keyData in pairs(keysTable) do
        local str = "TEST"
        local movement = PromptRegisterBegin() 
        PromptSetControlAction(movement, keyData[2])
        str = CreateVarString(10, 'LITERAL_STRING', keyData[1])
        PromptSetText(movement, str)
        PromptSetEnabled(movement, 1)
        PromptSetVisible(movement, 1)
        PromptSetStandardMode(movement,1)
        PromptSetGroup(movement, prompts)
        Citizen.InvokeNative(0xC5F428EE08FA7F2C,movement,true)
        PromptRegisterEnd(movement)
        table.insert(movements, movement) 
        --PromptSetMashMode(movements[3], 50)
        PromptSetHoldMode(movements[_], 1000)
        PromptRegisterEnd(movements[_])
    end
end)

local event = "playerSpawned" 
if Config.Framework == "vorp" then
    event = "vorp:SelectedCharacter"
elseif Config.Framework == "rsg" then
    event = "RSGCore:Client:OnPlayerLoaded"
end

RegisterNetEvent(event,function()
    TriggerServerEvent('spy_teleports:server:getConfig')
end)
RegisterNetEvent('spy_teleport:client:updateConfig',function(conf)
    Config.Zones = conf
end)
Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        for key,value in pairs(Config.Zones) do
            local coords = GetEntityCoords(PlayerPedId())
            for i=1, #value.teleports do
                local dist = #(vector3(value.teleports[i].x,value.teleports[i].y,value.teleports[i].z) - coords)
                if dist <= value.distance then
                    sleep = 1
                    local title = CreateVarString(10, 'LITERAL_STRING',value.label)
                    local str = "locked"
                    if value.isLocked then
                        str = CreateVarString(10, 'LITERAL_STRING', "Unlock")
                    else
                        str = CreateVarString(10, 'LITERAL_STRING', "Lock")
                    end
                    PromptSetText(movements[2], str)
                    PromptSetActiveGroupThisFrame(prompts, title)
                    if PromptHasHoldModeCompleted(movements[1]) then
                        Wait(200)
                        local targetIndex = (i % 2) + 1
                        TriggerServerEvent('spy_teleport:server:checkAuthorized',key,targetIndex)
                    end
                    if PromptHasHoldModeCompleted(movements[2]) then
                        Wait(200)      
                        TriggerServerEvent('spy_teleport:server:setLockStatus',key)
                    end
                    
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('spy_teleport:client:teleport',function(key,targetIndex)
    local conf = Config.Zones[key]
    local coords = conf.teleports[targetIndex]
    local ped = PlayerPedId()
    if not IsPedDeadOrDying(ped) then
        DoScreenFadeOut(300)
        Wait(1000)
        SetEntityCoords(ped,coords.x,coords.y,coords.z)
        SetEntityHeading(ped,coords.w)
        Wait(500)
        DoScreenFadeIn(1000)
    else
        Notify("You can not do that, if you are dead!","error",4000)
    end
end)