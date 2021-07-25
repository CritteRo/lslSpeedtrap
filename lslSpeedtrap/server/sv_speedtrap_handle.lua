print(' --[[  :: lslSpeedtrap by CritteR / CritteRo :: ]]-- ')
RegisterNetEvent('lslSpeedtrap.Got_A_Runner')
RegisterNetEvent('lslSpeedtrap.RequestLeaderboard')



AddEventHandler("lslSpeedtrap.Got_A_Runner", function(_trapid, _speed)
    local source = source
    local charCount = 0

    MySQL.Async.fetchAll("SELECT COUNT(name) AS `count` FROM `speedtrapLB` WHERE `name` = @name AND `trapid` = @race", {["@name"] = GetPlayerName(source), ["@race"] = _trapid}, function(result)
        charCount = result[1].count
        if charCount == 0 then
            MySQL.Async.fetchAll(string.format("INSERT INTO `speedtrapLB` (name, trapid, speed) VALUES (@name, '%i', '%f')", _trapid, _speed), {["@name"] = GetPlayerName(source)}, function(result)
                --_notif = {type = "simple", text = "~y~"..GetPlayerName(source).."~s~ set a new personal record on Timetrial ~y~"..RaceIdToName(raceid).."~s~!"}
                --TriggerClientEvent("core.notify", -1, _notif.type, _notif)
            end)
        elseif charCount == 1 then
            MySQL.Async.fetchAll(string.format("SELECT * FROM `speedtrapLB` WHERE `name` = '%s' AND `trapid` = '%i'", GetPlayerName(source), _trapid),{}, function(result)
                if _speed >= result[1].speed then
                    MySQL.Async.fetchAll(string.format("UPDATE `speedtrapLB` SET `speed` = '%f' WHERE `name` = @name AND `trapid` = '%i'", _speed, _trapid),{["@name"] = GetPlayerName(source)}, function(result)
                        --_notif = {type = "simple", text = "~y~"..GetPlayerName(source).."~s~ set a new personal record on Timetrial ~y~"..RaceIdToName(raceid).."~s~!"}
                        --TriggerClientEvent("core.notify", -1, _notif.type, _notif)
                    end)
                end
            end)
        end
    end)
end)

AddEventHandler('lslSpeedtrap.RequestLeaderboard', function(_trapid, _overrideSource)
    local top = {}
    local src = source
    if _overrideSource ~= nil and _overrideSource > 0 then
        src = _overrideSource
    end
    MySQL.Async.fetchAll(string.format("SELECT * FROM `speedtrapLB` WHERE `trapid`='%i' ORDER BY `speed` DESC", _trapid),{}, function(result)
        for i,k in pairs(result) do
            if result[i] ~= nil then
                if i < 11 then
                    top[i] = result[i]
                elseif k.name == GetPlayerName(src) then
                    top[i] = result[i]
                end
            else
                break
            end
        end
        TriggerClientEvent('lslSpeedtrap.UpdateLeaderboard', src, _trapid, top)
    end)
end)

AddEventHandler('lslSpeedtrap.RequestLeaderboardFlush', function(_trapid, _reason, _passcode)
    if source == 0 or _passcode == "Flu$hM3" then
        MySQL.Async.fetchAll(string.format("DELETE FROM `speedtrapLB` WHERE `trapid`=%i", _trapid),{}, function(result)
            print('Speedtrap ID '.._trapid..' leaderboard was flushed. Reason: '.._reason..'.')
        end)
    else
        print('ID '..source.." tried to run this server-only event, but he was not allowed.")
    end
end)

RegisterCommand('flush', function(source, args)
    if args[2] ~= nil then
        if args[1] == "Flu$hM3" then
            if tonumber(args[2]) ~= nil then
                TriggerEvent('lslSpeedtrap.RequestLeaderboardFlush', tonumber(args[2]), "Flushed by test.", args[1])
            end
        end
    end
end)