fx_version 'cerulean'
game 'gta5'
author 'Elzein Code'
description 'Lumberjack Scripts'
lua54 'yes'
this_is_a_map 'yes'
ui_page 'assets/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'bridge/init.lua',
    'shared/*.lua',
}

files {
    'assets/index.html',
    'assets/script.js',
    'assets/sound.mp3',
}

server_scripts {
    'bridge/**/server.lua',
    'server/*.lua',
}

client_scripts {
    'bridge/**/client.lua',
    'client/*.lua',
}
