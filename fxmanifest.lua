fx_version 'cerulean'
games { 'gta5' }

client_scripts {
    'client/*.lua',
}
server_scripts {
    'server/*.lua',
}

shared_scripts {
    'client/entity.lua'
}

ui_page 'html/index.html'

files {
    'html/js/*.js',
    'html/*.html',
    'html/style/*.css'
}

lua54 'yes'