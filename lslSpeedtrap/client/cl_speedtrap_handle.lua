speedtraps = {
    {name = "68th Devil", x = 880.364, y = 2698.003, z = 40.255, minSpeed = 10.0},
    {name = "Sandy Driveby", x = 1212.397, y = 3536.227, z = 34.568, minSpeed = 22.35},
    {name = "Tongva Valley Spy", x = -1511.871, y = 1445.777, z = 120.061, minSpeed = 22.35},
    {name = "Paleto Problems", x = -110.463, y = 6266.835, z = 30.543, minSpeed = 22.35},
}

Citizen.CreateThread(function()
    TriggerEvent("lslSpeedtrap:BuildTraps", speedtraps)
    local trapID = nil
    while true do
        local validSpot = false
        for i,k in pairs(speedtraps) do
            if #(vector3(k.x, k.y, k.z) - GetEntityCoords(PlayerPedId())) <= 7.01 then
                validSpot = true
                trapID = i
            end -- Use Z
        end

        if validSpot == true then
            local ped = PlayerPedId()
            local car = GetVehiclePedIsIn(ped, false)
            if GetEntitySpeed(car) >= speedtraps[trapID].minSpeed and GetPedInVehicleSeat(car, -1) == ped and GetEntitySpeed(car) > 0.0 then
                TriggerServerEvent('lslSpeedtrap.Got_A_Runner', trapID, GetEntitySpeed(car))
                TriggerEvent('lslSpeedtrap.ShowSpeed', GetEntitySpeed(car), speedtraps[trapID].name)
                validSpot = false
                trapID = nil
                Citizen.Wait(4000)
            else
                --print('too slow')
                --TriggerEvent('lslSpeedtrap.ShowSpeed', "TOO SLOW")
                validSpot = false
                trapID = nil
                Citizen.Wait(2000)
            end
        else
            --Citizen.Wait(10)
        end
        Citizen.Wait(1)
    end
end)
