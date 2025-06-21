fx_version "cerulean"
lua54 "yes"

games {
    "gta5"
}

author "Walter"

shared_scripts {
    "@ox_lib/init.lua",
    "@es_extended/imports.lua"
}

client_scripts {
    "client/*.lua"
}

server_scripts {
    "server/*.lua",
    "data/*.lua"
}