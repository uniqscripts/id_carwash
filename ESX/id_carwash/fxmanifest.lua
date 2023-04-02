fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "id_carwash"
description "Simple Car Wash resource with business owner system and responsive UI"
author "grandson#6863"
version "1.1.0"

client_scripts {
    'client/*.lua',
    'shared/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'shared/*.lua',
}

ui_page "web/index.html"

files {
    'web/index.html',
    'web/script.js',
	'web/img/*.png',
    'web/style.css',
}

shared_script {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
}
