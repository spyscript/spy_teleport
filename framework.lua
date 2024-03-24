function Notify(p1,p2,p3,p4)
    if IsDuplicityVersion() then 
        local src = p1
        local text = p2
        local type = p3
        local time = p4
        -- RSGCore.Functions.Notify(src, text, type, time)
        TriggerClientEvent("vorp:TipBottom",src, text, time, type)
    else
        local text = p1
        local type = p2
        local time = p3
        -- RSGCore.Functions.Notify(text, type, time)
        TriggerEvent("vorp:TipBottom", text, time, type)
 
    end
end


if IsDuplicityVersion() then
    if Config.Framework == "vorp" then
        VorpCore = {}
    
        TriggerEvent("getCore", function(core)
            VorpCore = core
        end)
    
        VorpInv = {}
        VorpInv = exports.vorp_inventory:vorp_inventoryApi()
        
        function SPYRegisterUsableItem(itemname,callBack)
            
            VorpInv.RegisterUsableItem(itemname, function(data)
                local array = {
                    source = data.source,
                    item = data.item
                }
                callBack(array)
            end)
        end
    
        function SPYIsAdmin(src)
            local User = VorpCore.getUser(src)
            return User.getGroup == "admin" or IsPlayerAceAllowed(src,"group.admin")
        end
    
        function SPYRemoveItem(src,itemName,itemCount,Metadata)
            return VorpInv.subItem(src, itemName, itemCount, Metadata)
        end
        
        function SPYAddItem(src,itemName,itemCount,Metadata)
            return VorpInv.addItem(src, itemName, itemCount, Metadata)
        end
        
        function SPYGetItem(src,ItemName,Metadata)
            return VorpInv.getItem(src, ItemName,Metadata)
        end
    
        function SPYGetPlayerData(src)
            local User = VorpCore.getUser(src)
            local Character = User.getUsedCharacter
            return {
                job = Character.job,
                grade = Character.jobGrade,
                charid = Character.charIdentifier,
            }
        end
    elseif Config.Framework == "rsg" then
        RSGCore = exports['rsg-core']:GetCoreObject()

        function SPYRegisterUsableItem(itemname,callBack)
            RSGCore.Functions.CreateUseableItem(itemname, function(source,item)
                local array = {
                    source = source,
                    item = item
                }
                array.item.metadata = item.info
                callBack(array)
            end)
        end
    
        function SPYIsAdmin(src)
            return RSGCore.Functions.HasPermission(src, "mod") or IsPlayerAceAllowed(src,"group.admin")
        end
        
        function SPYAddItem(src,itemName,itemCount,Metadata)
            local Player = RSGCore.Functions.GetPlayer(src)
            return Player.Functions.AddItem(itemName, itemCount,Metadata)
        end
        
        function SPYGetItem(src,ItemName,Metadata)
            local Player = RSGCore.Functions.GetPlayer(src)
            local founditem = false
            for slot,item in pairs(Player.PlayerData.items) do
                if item.name:lower() == ItemName:lower() then
                    if item.info.spyscript == Metadata.spyscript then
                        founditem = item
                    end
                    break
                end
            end
            return founditem
        end
    
        function SPYGetPlayerData(src)
            local Player = RSGCore.Functions.GetPlayer(src)
            return {
                job = Player.PlayerData.job.name,
                grade = Player.PlayerData.job.grade.level,
                charid = Player.PlayerData.citizenid,
            }
        end
    end
   
else
    if Config.Framework == "vorp" then
    elseif Config.Framework == "rsg" then
        RSGCore = exports['rsg-core']:GetCoreObject()
    end
end
