local Config = {}

Config.Framework = "ESX" --# [ ESX, QBCore ]

Config.Anticheat = "ElectronAC" --# Optional: [ "ElectronAC", "FiveGuard" ]

Config.Configuration = {
    ["weed"] = {
        location = vector3(1618.9978, -219.5101, 258.1835),
        prop = "prop_plant_01a",
        radius = 25,
        item = "cannabis",
        minPlants = 20,
        maxPlants = 25,
        respawnTime = 300
    }
}

return Config
