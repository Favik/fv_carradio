if Config.CheckVersion then
    Citizen.CreateThread( function()
        while true do
            local CheckTime = Config.CheckVersionDelay*60000
            Wait(CheckTime)
            updatePath = "https://raw.githubusercontent.com/Favik/fv_carradio/main/version"
            resourceName = GetCurrentResourceName()
            function checkVersion(err,responseText, headers)
                curVersion = LoadResourceFile(GetCurrentResourceName(), "version")
                if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
                    print('\n############################################################')
                    print("A new version ^2"..responseText.."^7 is available, your current version is ^1"..curVersion.."^7\nPlease update it from https://github.com/Favik/fv_carradio")
                    print('############################################################\n')
                elseif tonumber(curVersion) > tonumber(responseText) then
                    print("^1You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update (or downgrade?)")
                else
                    print("^2["..resourceName.."] ^7The version (v"..curVersion..") is up to date!")
                end
            end  
            PerformHttpRequest(updatePath, checkVersion, "GET")
        end
    end)
end