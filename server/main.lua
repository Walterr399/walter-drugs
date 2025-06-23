local Config = require("data.config")

local ESX = nil
local QBCore = nil

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "QBCore" then
    QBCore = exports["qb-core"]:GetCoreObject()
end

lib.callback.register("walter-drugs:server:reward:player", function(source, drugType)
    local src = source
    local data = Config.Configuration[drugType]

    if not data then
        return false
    end

    if Config.Framework == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
    elseif Config.Framework == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return false end
    end
        
    local amount = math.random(3, 8)
        
    if amount < 3 or amount > 8 then
        if Config.Anticheat == "ElectronAC" then
            exports["ElectronAC"]:banPlayer(src, "Drugs exploit", "Drugs exploit", true)
        elseif Config.Anticheat == "FiveGuard" then
            exports["fiveguard"]:fg_BanPlayer(src, "Drugs - Exploit", true)
        end
            
        DropPlayer(src, "Exploit")
        return
    end
    exports.ox_inventory:AddItem(src, data.item, amount)
    return true
end)

lib.callback.register("walter-drugs:server:send:data", function()
    return Config
end)
