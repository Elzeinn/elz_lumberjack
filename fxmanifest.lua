fx_version 'cerulean'
game 'gta5'
author 'Elzein Code'
description 'Lumberjack Scripts'
lua54 'yes'
this_is_a_map 'yes'
ui_page 'assets/index.html'

files {
    'assets/index.html',
    'assets/script.js',
    'assets/sound.mp3',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}
