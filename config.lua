Config = {}

Config.CheckVersion = true                -- Check version
Config.CheckVersionDelay = 60             -- Version check interval (in minutes)

Config.ESXnotify = true                  -- If set to false mythic_notify is used for notifications and if set to true ESX notifications are used.

Config.UseItem = true                     -- If set to false only the command can be used
Config.Item = 'carradio'                  -- Item to open the radio

Config.Command = 'carradio'               -- Command to open the radio if Config.UseItem is set to false

Config.MaxDistance = 15                   -- Maximum distance where the radio can be heard
Config.DefaultVolume = 0.1                -- Default volume when starting music (0.1 = 10%)


Config.Locale = 'en'                      -- Language settings / Translation

Locales['cs'] = {
    ['not_in_veh'] = 'Nejste ve vozidle.',
    ['not_url'] = 'Zadejte URL',
    ['not_driver'] = 'Nejste řidičem vozidla.',
}

Locales['pl'] = {
    ['not_in_veh'] = 'Nie ma Cię w pojeździe.',
    ['not_url'] = 'Wpisz adres URL',
    ['not_driver'] = 'Nie jest Pan/Pani kierowcą pojazdu',
}

Locales['en'] = {
    ['not_in_veh'] = 'You are not in the vehicle.',
    ['not_url'] = 'Enter the URL',
    ['not_driver'] = 'You are not the driver of the vehicle.',
}