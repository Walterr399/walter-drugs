local Config = require("data.config")

if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
end

lib.callback.register("walter-drugs:server:reward:player", function(source, drugType)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then
        return false
    end

    local data = Config.Configuration[drugType]

    if not data then
        return false
    end

    exports.ox_inventory:AddItem(src, data.item, math.random(3, 8))

    return true
end)

lib.callback.register("walter-drugs:server:send:data", function()
    return Config
end)
