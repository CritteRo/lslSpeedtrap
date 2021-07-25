blipDump = {
    [0] = 0
}

function createBlip(i, name, blip, x, y, z)
    blipDump[i] = AddBlipForCoord(x, y, z)
    SetBlipSprite(blipDump[i], blip)
    SetBlipDisplay(blipDump[i], 4)
    SetBlipScale(blipDump[i], 0.9)
    SetBlipColour(blipDump[i], 0)
    SetBlipAsShortRange(blipDump[i], true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(blipDump[i])
end

AddEventHandler("lslSpeedtrap:BuildTraps", function(_traps)
    for i, k in pairs(blipDump) do
        RemoveBlip(k)
    end
    for i, k in pairs(_traps) do
        createBlip(i, "Speed Trap", 184, k.x, k.y, k.z)
    end
end)

function generateCountdown(string1, r, g, b)
    local scaleform = RequestScaleformMovie("COUNTDOWN")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    BeginScaleformMovieMethod(scaleform, "SET_MESSAGE")
    PushScaleformMovieMethodParameterString(string1)
    PushScaleformMovieMethodParameterInt(r)
    PushScaleformMovieMethodParameterInt(g)
    PushScaleformMovieMethodParameterInt(b)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "FADE_MP")
    PushScaleformMovieMethodParameterString(string1)
    PushScaleformMovieMethodParameterInt(r)
    PushScaleformMovieMethodParameterInt(g)
    PushScaleformMovieMethodParameterInt(b)
    EndScaleformMovieMethod()

    return scaleform
end

function generateBanner(string1, string2)
    local scaleform = RequestScaleformMovie("MIDSIZED_MESSAGE")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SHOW_COND_SHARD_MESSAGE")
    PushScaleformMovieMethodParameterString(string1)
    PushScaleformMovieMethodParameterString(string2)
    PushScaleformMovieMethodParameterInt(11)
    PushScaleformMovieMethodParameterBool(true)
    EndScaleformMovieMethod()
    return scaleform
end

AddEventHandler('lslSpeedtrap.ShowSpeed', function(_speed, _trapName)
    local scale = 0
    local showCountdown = true
    PlaySoundFrontend(-1, "ON", "NOIR_FILTER_SOUNDS", 1)
    if _speed ~= "TOO SLOW" then
        local spd = 0
        if ShouldUseMetricMeasurements() then
            spd = math.floor(_speed * 3.6).." KM/h"
        else
            spd = math.floor(_speed * 2.236936).." MPH"
        end
        --scale = generateCountdown(spd, 0, 150, 200)
        scale = generateBanner(spd, 'Caught by ~y~"'.._trapName..'"~s~ camera.')
    else
        --scale = generateCountdown("TOO SLOW", 0, 150, 200)
        scale = generateBanner("TOO SLOW", '')
    end
    Citizen.CreateThread(function()
        Citizen.Wait(4000)
        BeginScaleformMovieMethod(scale, "SHARD_ANIM_OUT")
        PushScaleformMovieMethodParameterInt(2)
        PushScaleformMovieMethodParameterFloat(0.3)
        PushScaleformMovieMethodParameterBool(true)
        EndScaleformMovieMethod()
        Citizen.Wait(1000)
        showCountdown = false
    end)
    Citizen.CreateThread(function()
        while showCountdown do
            Citizen.Wait(1)
            DrawScaleformMovieFullscreen(scale, 255, 255, 255, 255)
        end
    end)
end)

ActualZoneNames = {
    ['AIRP'] = 'Los Santos International Airport',  
    ['ALAMO'] = 'Alamo Sea',
    ['ALTA'] = 'Alta',
    ['ARMYB'] = 'Fort Zancudo',
    ['BANHAMC'] = 'Banham Canyon Dr  ',
    ['BANNING'] = 'Banning  ',
    ['BEACH'] = 'Vespucci Beach  ',
    ['BHAMCA'] = 'Banham Canyon  ',
    ['BRADP'] = 'Braddock Pass  ',
    ['BRADT'] = 'Braddock Tunnel  ',
    ['BURTON'] = 'Burton  ',
    ['CALAFB'] = 'Calafia Bridge  ',
    ['CANNY'] = 'Raton Canyon  ',
    ['CCREAK'] = 'Cassidy Creek  ',
    ['CHAMH'] = 'Chamberlain Hills  ',
    ['CHIL'] = 'Vinewood Hills  ',
    ['CHU'] = 'Chumash  ',
    ['CMSW'] = 'Chiliad Mountain State Wilderness  ',
    ['CYPRE'] = 'Cypress Flats  ',
    ['DAVIS'] = 'Davis  ',
    ['DELBE'] = 'Del Perro Beach  ',
    ['DELPE'] = 'Del Perro  ',
    ['DELSOL'] = 'La Puerta  ',
    ['DESRT'] = 'Grand Senora Desert  ',
    ['DOWNT'] = 'Downtown  ',
    ['DTVINE'] = 'Downtown Vinewood  ',
    ['EAST_V'] = 'East Vinewood  ',
    ['EBURO'] = 'El Burro Heights  ',
    ['ELGORL'] = 'El Gordo Lighthouse  ',
    ['ELYSIAN'] = 'Elysian Island  ',
    ['GALFISH'] = 'Galilee  ',
    ['GOLF'] = 'GWC and Golfing Society  ',
    ['GRAPES'] = 'Grapeseed  ',
    ['GREATC'] = 'Great Chaparral  ',
    ['HARMO'] = 'Harmony  ',
    ['HAWICK'] = 'Hawick  ',
    ['HORS'] = 'Vinewood Racetrack  ',
    ['HUMLAB'] = 'Humane Labs and Research  ',
    ['JAIL'] = 'Bolingbroke Penitentiary  ',
    ['KOREAT'] = 'Little Seoul  ',
    ['LACT'] = 'Land Act Reservoir  ',
    ['LAGO'] = 'Lago Zancudo  ',
    ['LDAM'] = 'Land Act Dam  ',
    ['LEGSQU'] = 'Legion Square  ',
    ['LMESA'] = 'La Mesa  ',
    ['LOSPUER'] = 'La Puerta  ',
    ['MIRR'] = 'Mirror Park  ',
    ['MORN'] = 'Morningwood  ',
    ['MOVIE'] = 'Richards Majestic  ',
    ['MTCHIL'] = 'Mount Chiliad  ',
    ['MTGORDO'] = 'Mount Gordo  ',
    ['MTJOSE'] = 'Mount Josiah  ',
    ['MURRI'] = 'Murrieta Heights  ',
    ['NCHU'] = 'North Chumash  ',
    ['NOOSE'] = 'N.O.O.S.E  ',
    ['OCEANA'] = 'Pacific Ocean  ',
    ['PALCOV'] = 'Paleto Cove  ',
    ['PALETO'] = 'Paleto Bay  ',
    ['PALFOR'] = 'Paleto Forest  ',
    ['PALHIGH'] = 'Palomino Highlands  ',
    ['PALMPOW'] = 'Palmer-Taylor Power Station  ',
    ['PBLUFF'] = 'Pacific Bluffs  ',
    ['PBOX'] = 'Pillbox Hill  ',
    ['PROCOB'] = 'Procopio Beach  ',
    ['RANCHO'] = 'Rancho  ',
    ['RGLEN'] = 'Richman Glen  ',
    ['RICHM'] = 'Richman',
    ['ROCKF'] = 'Rockford Hills  ',
    ['RTRAK'] = 'Redwood Lights Track  ',
    ['SANAND'] = 'San Andreas  ',
    ['SANCHIA'] = 'San Chianski Mountain Range  ',
    ['SANDY'] = 'Sandy Shores  ',
    ['SKID'] = 'Mission Row  ',
    ['SLAB'] = 'Stab City  ',
    ['STAD'] = 'Maze Bank Arena  ',
    ['STRAW'] = 'Strawberry  ',
    ['TATAMO'] = 'Tataviam Mountains  ',
    ['TERMINA'] = 'Terminal  ',
    ['TEXTI'] = 'Textile City  ',
    ['TONGVAH'] = 'Tongva Hills  ',
    ['TONGVAV'] = 'Tongva Valley  ',
    ['VCANA'] = 'Vespucci Canals  ',
    ['VESP'] = 'Vespucci',
    ['VINE'] = 'Vinewood',
    ['WINDF'] = 'Ron Alternates Wind Farm  ',
    ['WVINE'] = 'West Vinewood  ',
    ['ZANCUDO'] = 'Zancudo River  ',
    ['ZP_ORT'] = 'Port of South Los Santos' ,
    ['ZQ_UAR'] = 'Davis Quartz',
}