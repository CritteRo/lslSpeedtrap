RegisterNetEvent('lslSpeedtrap.UpdateLeaderboard')

textbox = {
    a = "The Blaine County Sheriff Department, together with the LSPD, installed a couple of speed traps throught the island...",
    b = "So the game is simple. Pass the cameras as fast as possible.",
    c = "Fastest 10 degenerates end up on the leaderboard.",
    d = "Have fun!",
    e = "Looks like speeding is not an issue in this area.\nHow about we change that",
    f = "No records set",
}


--[[ MAIN MENU ]]--
TriggerEvent('lobbymenu:CreateMenu', 'speedTrap:mainMenu', "Speed Traps", "", "SPEED TRAPS", "INFO", "ZONE LIST")
TriggerEvent('lobbymenu:SetHeaderDetails', 'speedTrap:mainMenu', false, true, 2, 6)
TriggerEvent('lobbymenu:SetDetailsTitle', 'speedTrap:mainMenu', "Speedtrap List", 'pm_tt_12', 'ttshot12')

TriggerEvent('lobbymenu:SetTextBoxToColumn', 'speedTrap:mainMenu', 1, "Speed Traps", textbox.a.."\n\n"..textbox.b.."\n\n"..textbox.c, textbox.d)

for i, k in pairs(speedtraps) do
    TriggerEvent('lobbymenu:AddButton', 'speedTrap:mainMenu', {trapid = i}, k.name, "", false, 1, "speedTrap:ChangeMenu")
end
TriggerEvent('lobbymenu:AddButton', 'speedTrap:mainMenu', {}, "Close Menu", "", false, 0, "lobbymenu:CloseMenu")

for i, k in pairs(speedtraps) do
    TriggerEvent('lobbymenu:AddDetailsRow', 'speedTrap:mainMenu', " ",  k.name)
end


--[[ INDIVIDUAL SPEEDTRAP MENU ]]--

for i, k in pairs(speedtraps) do
    TriggerEvent('lobbymenu:CreateMenu', 'speedTrap:trapMenu:'..i, k.name, "", "MENU", "LEADERBOARDS", "DETAILS")
    TriggerEvent('lobbymenu:SetHeaderDetails', 'speedTrap:trapMenu:'..i, false, true, 2, 6)
    TriggerEvent('lobbymenu:SetDetailsTitle', 'speedTrap:trapMenu:'..i, k.name, 'pm_tt_12', 'ttshot12')

    TriggerEvent('lobbymenu:SetTextBoxToColumn', 'speedTrap:trapMenu:'..i, 1, "Nothing here?", textbox.e, textbox.f)

    TriggerEvent('lobbymenu:AddDetailsRow', 'speedTrap:trapMenu:'..i, "Location:",  ActualZoneNames[GetNameOfZone(k.x,k.y,k.z)])
    local spd = 0
    if ShouldUseMetricMeasurements() then
        spd = math.floor(k.minSpeed * 3.6).." KM/h"
    else
        spd = math.floor(k.minSpeed * 2.236936).." MPH"
    end
    TriggerEvent('lobbymenu:AddDetailsRow', 'speedTrap:trapMenu:'..i, "Speed Limit:", spd)

    TriggerEvent('lobbymenu:AddButton', 'speedTrap:trapMenu:'..i, {trapid = i, x = k.x, y = k.y}, "Add Waypoint", "", false, 0, "speedTrap:WaypointToSpeedTrap")
    TriggerEvent('lobbymenu:AddButton', 'speedTrap:trapMenu:'..i, {trapid = 0}, "Back", "", false, 0, "speedTrap:ChangeMenu")
end

AddEventHandler('speedTrap:ChangeMenu', function(_data)
    if _data.trapid ~= nil and _data.trapid > 0 then
        TriggerServerEvent('lslSpeedtrap.RequestLeaderboard', _data.trapid)
        TriggerEvent('lobbymenu:CloseMenu')
        Citizen.Wait(100)
        TriggerEvent('lobbymenu:OpenMenu', 'speedTrap:trapMenu:'.._data.trapid, true)
    elseif _data.trapid ~= nil and _data.trapid == 0 then
        TriggerEvent('lobbymenu:CloseMenu')
        Citizen.Wait(100)
        TriggerEvent('lobbymenu:OpenMenu', 'speedTrap:mainMenu', true)
    end
end)

AddEventHandler('speedTrap:WaypointToSpeedTrap', function(_data)
    if _data.trapid ~= nil then
        TriggerEvent('lobbymenu:CloseMenu')
        Citizen.Wait(100)
        SetNewWaypoint(_data.x, _data.y)
    end
end)

AddEventHandler('lslSpeedtrap.UpdateLeaderboard', function(_trapid, _leaderboard)
    local pName = GetPlayerName(PlayerId())
    TriggerEvent('lobbymenu:ResetPlayerList', 'speedTrap:trapMenu:'.._trapid)
    local count = 0
    for i,k in pairs(_leaderboard) do
        local col = 8
        if k.name == pName then
            col = 11
        end
        local spd = 0
        if ShouldUseMetricMeasurements() then
            spd = math.floor(k.speed * 3.6).." KM/h"
        else
            spd = math.floor(k.speed * 2.236936).." MPH"
        end
        TriggerEvent('lobbymenu:AddPlayer', 'speedTrap:trapMenu:'.._trapid, k.name, "", spd, 65, i, true, col, col)
        count = count + 1
    end
    if count > 0 then
        TriggerEvent('lobbymenu:SetTextBoxToColumn', 'speedTrap:trapMenu:'.._trapid, 0, "Nothing here?", textbox.e, textbox.f)
    end
    TriggerEvent('lobbymenu:UpdateMenu', 'speedTrap:trapMenu:'.._trapid)
end)

--[[  ::  MENU END  ::  ]]--

RegisterCommand('speedboard', function()
    TriggerEvent('lobbymenu:OpenMenu', 'speedTrap:mainMenu', true)
end)