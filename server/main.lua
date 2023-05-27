if Config.UseItem then
    ESX.RegisterUsableItem(Config.Item, function(source)
        TriggerClientEvent('fv_carradio:open', source)
    end)
else
    RegisterCommand(Config.Command, function(source, args, rawCommand)
        TriggerClientEvent('fv_carradio:open', source)
    end, false)
end

RegisterNetEvent("fv_carradio:soundStatus")
AddEventHandler("fv_carradio:soundStatus", function(type, musicId, data)
    TriggerClientEvent("fv_carradio:soundStatus", -1, type, musicId, data)
end)

RegisterNetEvent("fv_carradio:debug")
AddEventHandler("fv_carradio:debug", function(data)
    print('^3[Debug]^7: '..data)
end)