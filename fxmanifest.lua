fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name "id_carwash"
description "Simple Car Wash resource with business owner system and responsive UI"
author "grandson#6863"
version "1.0.0"

client_scripts {
    'client/*.lua',
    'shared/*.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
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

shared_script '@ox_lib/init.lua' -- Used for notifications, progressbar, text UI and context menu, can be changed in client side (if you need help read README.md, but I recommend using overextended resources - https://github.com/overextended)