xSound = exports.xsound

RegisterNetEvent("fv_carradio:open")
AddEventHandler("fv_carradio:open", function()
    local player = PlayerPedId()
        if IsPedSittingInAnyVehicle(player) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(player), -1) == player then
                SetNuiFocus(true, true)
                SendNUIMessage({action = 'enable'}) 
            else
                if Config.ESXnotify then
                    ESX.ShowNotification(_U('not_driver'))
                else
                    exports['mythic_notify']:SendAlert('warn', _U('not_driver'))
                end
            end
        else
            if Config.ESXnotify then
                ESX.ShowNotification( _U('not_in_veh'))
            else
                exports['mythic_notify']:SendAlert('warn', _U('not_in_veh'))
            end
        end	
end)

local musicId
local playing = false
CreateThread(function()
    Wait(1000)
    local Player = PlayerPedId()
    local ID = PedToNet(Player)
    musicId = "music_id_"..ID
    local pos
    while true do
        local vehPlayer = GetPlayersLastVehicle(Player)
        local pos = GetEntityCoords(vehPlayer)
        Wait(100)
        if xSound:soundExists(musicId) and playing then
            if xSound:isPlaying(musicId) then
                TriggerServerEvent("fv_carradio:soundStatus", "position", musicId, { position = pos })
            else
                Wait(1000)
            end
        else
            Wait(1000)
        end
    end
end)

RegisterNUICallback('action', function(data)
    if data.action == "playMusic" then
        local vehPlayer = GetPlayersLastVehicle(Player)
        local pos = GetEntityCoords(vehPlayer)  
        local musicURL = data.url
        TriggerServerEvent("fv_carradio:soundStatus", "play", musicId, { position = pos, link = data.url})
        if not xSound:soundExists(musicId) and not playing then
            print('Playing URL: '..musicURL..'\nMusicID: '..musicId)
            TriggerEvent("fv_carradio:checkRadioPlay")
        end
        playing = true
        MusicInfo(data.action, musicId)
    elseif data.action == "destroyMusic" then
        playing = false
        TriggerServerEvent("fv_carradio:soundStatus", "destroy", musicId)
        SendNUIMessage({ action = 'playend' })
    elseif data.action == "loopMusic" then
        TriggerServerEvent("fv_carradio:soundStatus", "loop", musicId)
        MusicInfo(data.action, musicId)
    elseif data.action == "volumeUp" then
        TriggerServerEvent("fv_carradio:soundStatus", "volumeUp", musicId)
        MusicInfo(data.action, musicId)
    elseif data.action == "volumeDown" then
        TriggerServerEvent("fv_carradio:soundStatus", "volumeDown", musicId)
        MusicInfo(data.action, musicId)
    elseif data.action == "errorPlay" then
        if Config.ESXnotify then
            ESX.ShowNotification(_U('not_url'))
        else
            exports['mythic_notify']:SendAlert('error', _U('not_url'))
        end
    elseif data.action == "closeCarRadio" then
        SetNuiFocus(false, false)
    end
end)

RegisterNetEvent("fv_carradio:soundStatus")
AddEventHandler("fv_carradio:soundStatus", function(type, musicId, data)
    if type == "position" then
        if xSound:soundExists(musicId) then
            xSound:Position(musicId, data.position)
        end
    end
    if type == "play" then
        if xSound:soundExists(musicId) then
            if xSound:isPlaying(musicId) then
                xSound:Pause(musicId)
            else
                xSound:Resume(musicId)
            end
        end
        if not xSound:soundExists(musicId) then
            xSound:PlayUrlPos(musicId, data.link, Config.DefaultVolume, data.position)
            xSound:Distance(musicId, Config.MaxDistance)
        end
    end
    if type == "destroy" then
        if xSound:soundExists(musicId) then
            xSound:Destroy(musicId)
        end
    end
    if type == "loop" then
        if xSound:soundExists(musicId) then
            if xSound:isLooped(musicId) then
                xSound:setSoundLoop(musicId, false)
            else
                xSound:setSoundLoop(musicId, true)
            end
        end
    end
    if type == "volumeUp" then
        if xSound:soundExists(musicId) then
            local volume = xSound:getVolume(musicId) + 0.1
            if xSound:getVolume(musicId) < 0.9 then
                xSound:setVolume(musicId, volume)
            end
        end
    end
    if type == "volumeDown" then
        if xSound:soundExists(musicId) then
            local volume = xSound:getVolume(musicId) - 0.1
            if xSound:getVolume(musicId) >= 0.1 then
                xSound:setVolume(musicId, volume)
            end
        end
    end
end)

AddEventHandler("fv_carradio:checkRadioPlay", function()
    while true do
        Wait(2000)
        if xSound:soundExists(musicId) and playing then
            xSound:onPlayEnd(musicId, function()  
                SendNUIMessage({ action = 'playend' })
                playing = false          
            end)
        end
        if not playing then 
            print('Playing End')
            break 
        end
    end
end)

function MusicInfo(event, music)
    if event == 'playMusic' then
        if xSound:soundExists(music) then
            if xSound:isPlaying(music) then
                SendNUIMessage({ action = 'pause' })
            else
                SendNUIMessage({ action = 'play' })
                local volume = (('<b>Volume:</b> '.. math.floor((xSound:getVolume(music)*100) - 0.1+1).."%"))
                SendNUIMessage({ action = "volumeinfo", volume = volume, })
            end
        else
            local volume = (('<b>Volume:</b> '.. math.floor((Config.DefaultVolume*100) - 0.1+1).."%"))
            SendNUIMessage({ action = "volumeinfo", volume = volume, })
            SendNUIMessage({ action = "play" })
        end
    elseif event == 'loopMusic' then
        if xSound:soundExists(music) then
            if xSound:isLooped(music) then
                SendNUIMessage({ action = 'noloop' })
            else
                SendNUIMessage({ action = 'loop' })
            end
        end
    elseif event == 'volumeUp' then
        if xSound:soundExists(music) then
            if xSound:getVolume(music) < 0.9 then
                local addvolume = xSound:getVolume(music) + 0.1
                local volume = (('<b>Volume:</b> '.. math.floor((addvolume*100) - 0.1+1).."%"))
                SendNUIMessage({ action = "volumeinfo", volume = volume, })
            end
        end
    elseif event == 'volumeDown' then
        if xSound:soundExists(music) then
            if xSound:getVolume(music) >= 0.1 then
                local remvolume = xSound:getVolume(music) - 0.1
                local volume = (('<b>Volume:</b> '.. math.floor((remvolume*100) - 0.1+1).."%"))
                SendNUIMessage({ action = "volumeinfo", volume = volume, })
            end
        end
    end
end