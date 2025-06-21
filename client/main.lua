local Config = lib.callback.await("walter-drugs:server:send:data", false)

local messages = {
    "Je trok aan die plant alsof het je wifi-kabel was niks geplukt, alles verpest.",
    "Plant zei letterlijk ‘nee broer, niet vandaag’.",
    "Je handen waren te glad van de olie, je gleed gewoon langs de bladeren.",
    "Broer, dit is geen boksbal zachtjes plukken, niet meppen.",
    "Plant is gevlucht, zei: ‘ik ga wel groeien bij iemand met respect’."
}

local objects = {}

for drugType, data in pairs(Config.Configuration) do
    local coords = data.location
    local radius = data.radius
    local model = data.prop

    local point = lib.points.new({
        coords = coords,
        distance = radius
    })

    function point:onEnter()
        spawnPlants(drugType, coords, model, data)
    end

    function point:onExit()
    end

    function point:nearby()
    end
end

function spawnPlants(drugType, baseCoords, plantModel, data)
    lib.requestModel(plantModel, 5000)

    local minPlants = data.minPlants
    local maxPlants = data.maxPlants
    local plantCount = math.random(minPlants, maxPlants)

    spawnedObjects[drugType] = {}

    for i = 1, plantCount do
        local offsetX = math.random(-3, 3) + math.random()
        local offsetY = math.random(-3, 3) + math.random()
        local offset = vec3(offsetX, offsetY, 0.0)

        local spawnCoords = baseCoords + offset
        local plant = CreateObject(joaat(plantModel), spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, false)

        PlaceObjectOnGroundProperly(plant)
        FreezeEntityPosition(plant, true)
        table.insert(spawnedObjects[drugType], plant)

        exports.ox_target:addLocalEntity(plant, {
            {
                name = "harvest" .. drugType .. "_" .. i,
                icon = "fas fa-seedling",
                label = "Plant Plukken",
                distance = 2.0,
                onSelect = function()
                    local coords = GetEntityCoords(cache.ped)
                    local plant = GetEntityCoords(plant)

                    local distance = #(coords - plant)

                    if distance > 2.5 then
                        lib.notify({
                            title = "Niffo?",
                            description = "Je probeert planten te plukken van 3 meter afstand ben je shi tovenaar ofzo?",
                            type = "error"
                        })
                        return
                    end

                    local success = lib.skillCheck({ 'easy', 'easy' }, { 'e', 'e' })

                    if not success then
                        local message = messages[math.random(1, #messages)]
                        lib.notify({
                            title = "Wallahi nee!",
                            description = message,
                            type = "error"
                        })
                        return
                    end

                    lib.progressCircle({
                        duration = 2500,
                        label = "Aan het plukken...",
                        useWhileDead = false,
                        canCancel = false,
                        position = "bottom"
                    })

                    DeleteObject(plant)

                    lib.callback.await("walter-drugs:server:reward:player", false, drugType)
                end
            }
        })
    end

    SetModelAsNoLongerNeeded(joaat(plantModel))
end

--# Maybe using in Future use.
--[[function despawnPlants(drugType)
    if objects[drugType] then
        for _, obj in ipairs(objects[drugType]) do
            if DoesEntityExist(obj) then
                DeleteObject(obj)
            end
        end
        objects[drugType] = nil
    end
end]]