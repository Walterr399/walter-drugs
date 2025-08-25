local Config = {}

Config.Anticheat = "ElectronAC" -- Options: [ "ElectronAC", "FiveGuard" ]

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

Config.Messages = {
    "Je trok aan die plant alsof het je wifi-kabel was niks geplukt, alles verpest.",
    "Plant zei letterlijk ‘nee broer, niet vandaag’.",
    "Je handen waren te glad van de olie, je gleed gewoon langs de bladeren.",
    "Broer, dit is geen boksbal zachtjes plukken, niet meppen.",
    "Plant is gevlucht, zei: ‘ik ga wel groeien bij iemand met respect’."
}

return Config
