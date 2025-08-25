
local Config = lib.callback.await("walter-drugs:server:send:data", false)
local spawnedObjects = {}

for drugType, data in pairs(Config.Configuration) do
    local point = lib.points.new({
        coords = data.coords,
        distance = data.radius
    })

    function point:onEnter()
        spawnPlants(drugType, coords, data.model, data)
    end

    function point:onExit()
    end

    function point:nearby()
    end
end

function spawnPlants(drugType, baseCoords, plantModel, data)
    if spawnedObjects[drugType] and #spawnedObjects[drugType] > 0 then
        return
    end

    lib.requestModel(plantModel, 5000)

    local count = math.random(data.minPlants, data.maxPlants)

    spawnedObjects[drugType] = {}

    for i = 1, count do
        SetTimeout(i * 1000, function()
            local radius = data.radius
            local angle = math.random() * math.pi * 2
            local distance = math.sqrt(math.random()) * radius
            local offsetX = math.cos(angle) * distance
            local offsetY = math.sin(angle) * distance
            local offset = vec3(offsetX, offsetY, 0.0)
            local tempCoords = baseCoords + offset
            local foundGround, groundZ = GetGroundZFor_3dCoord(tempCoords.x, tempCoords.y, tempCoords.z + 50.0, 0)
            local spawnCoords = vector3(tempCoords.x, tempCoords.y, foundGround and groundZ or tempCoords.z)
            local plant = CreateObject(joaat(plantModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, false)

            FreezeEntityPosition(plant, true)
            table.insert(spawnedObjects[drugType], plant)

            exports["ox_target"]:addLocalEntity(plant, {
                {
                    name = "harvest" .. drugType .. "_" .. i,
                    icon = "fas fa-cannabis",
                    label = "Plant Plukken",
                    distance = 2.0,
                    onSelect = function()
                        if #(GetEntityCoords(cache.ped) - GetEntityCoords(plant)) > 2.0 then
                            lib.notify({
                                title = "Niffo?",
                                description = "Je probeert planten te plukken van 3 meter afstand ben je shi tovenaar ofzo?",
                                type = "error"
                            })
                            TriggerServerEvent("walter-drugs:server:ban", drugType)
                            return
                        end

                        local success = lib.skillCheck({ 'easy', 'easy' }, { 'e', 'e' })

                        if not success then
                            local message = messages[math.random(1, #Config.Messages)]
                            lib.notify({
                                title = "Wallahi nee!",
                                description = message,
                                type = "error"
                            })
                            return
                        end

                        if lib.progressCircle({
                            duration = 2500,
                            label = "Aan het plukken...",
                            useWhileDead = false,
                            canCancel = false,
                            position = "bottom",
                            disable = {
                                move = true,
                                car = true,
                                combat = true,
                            },
                            anim = {
                                dict = "amb@world_human_gardener_plant@male@base",
                                clip = "base"
                            }
                        }) then
                            DeleteObject(plant)
                            lib.callback.await("walter-drugs:server:reward:player", false, drugType)

                            for index, obj in ipairs(spawnedObjects[drugType]) do
                                if obj == plant then
                                    table.remove(spawnedObjects[drugType], index)
                                    break
                                end
                            end

                            if #spawnedObjects[drugType] == 0 then
                                SetTimeout((data.respawnTime or 300) * 1000, function()
                                    spawnPlants(drugType, baseCoords, plantModel, data)
                                end)
                            end
                        end
                    end
                }
            })
        end)
    end
end

function despawnPlants()
    for _, objects in pairs(spawnedObjects) do
        for _, obj in ipairs(objects) do
            if DoesEntityExist(obj) then
                DeleteObject(obj)
            end
        end
    end
    spawnedObjects = {}
end

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        despawnPlants()
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    for drugType, data in pairs(Config.Configuration) do
        local coords = data.location
        local model = data.prop

        spawnPlants(drugType, coords, model, data)
    end
end)
