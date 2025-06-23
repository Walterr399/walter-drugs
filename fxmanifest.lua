fx_version "cerulean"
lua54 "yes"

games {
    "gta5"
}

author "Walter"
description "A simple drugs system built for fivem (QBCore & ESX)"

dependency "ox_lib"

shared_scripts {
    "@ox_lib/init.lua",
    "@es_extended/imports.lua", -- ESX (optional)
    "@qb-core/shared/locale.lua" -- QBCore (optional)
}

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua",
    "data/*.lua"
}