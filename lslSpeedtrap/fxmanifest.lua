fx_version 'cerulean'
game 'gta5'

author 'CritteR / CritteRo'

client_scripts {
    'client/cl_speedtrap_scaleform.lua',
    'client/cl_speedtrap_handle.lua',
    'client/cl_speedtrap_menu.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua', --required for leaderboards
    'server/sv_speedtrap_handle.lua'
}