fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

name 'w_zones'
author 'Wraith Studio'
version '1.0.0'
description 'Free native RDR2 zone announcement banner for Wraith Core (zero NUI)'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/notify.js',
    'client/main.lua',
}
