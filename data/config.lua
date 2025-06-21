local Config = {}

Config.Framework = "ESX"

Config.Configuration = {
    ["weed"] = {
        location = vector3(222.5, -800.3, 30.7),
        prop = "prop_plant_01a",
        radius = 5,
        item = "cannabis",
        amount = math.random(1, 3),
        minPlants = 3,
        maxPlants = 6
    },
    ["coke"] = {
        location = vector3(1500.0, -2000.0, 30.0),
        prop = "prop_plant_01b",
        radius = 5,
        item = "coke_leaf",
        amount = math.random(2, 4),
        minPlants = 2,
        maxPlants = 5
    }
}

return Config