ESX = nil
local washing = false
local inMenu = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    local inZone = false
    local enteredZone = false
    while true do
        inZone = false
        local sleep = 1000
        local ped = PlayerPedId()
	    local pedCoords = GetEntityCoords(ped)
        local vehicle = GetVehiclePedIsIn(ped, false)
		for _,i in pairs(GlobalState.CarWash) do
		    if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, i) < GlobalState.MarkerDistance and not washing and not inMenu then
              sleep = 5
              DrawMarker(GlobalState.Marker.Type, i, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, GlobalState.Marker.ColorR, GlobalState.Marker.ColorG, GlobalState.Marker.ColorB, 50, false, true, 2, nil, nil, false)
            end
	
            if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, i) < GlobalState.TextUIDistance and (GetPedInVehicleSeat(vehicle, -1) == ped) and not washing and not inMenu then
                sleep = 5
                inZone = true
                if IsControlJustPressed(0, 38) then
                    showUI()
                end
            end
        end
        if not enteredZone and inZone then
            lib.showTextUI('[E] - ' .. GlobalState.Translation.AccessCarWash, {
                position = "top-center",
                icon = GlobalState.TextUIicon,
            })                
            enteredZone = true
        elseif enteredZone and not inZone then
            lib.hideTextUI()
            enteredZone = false
        end

    Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    for _,i in pairs(GlobalState.CarWash) do
        local blip = AddBlipForCoord(GlobalState.CarWash)
        SetBlipSprite(blip, GlobalState.Blip.ID)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, GlobalState.Blip.Size)
        SetBlipColour(blip, GlobalState.Blip.Colour)
        SetBlipAsShortRange(blip, true)
        SetBlipHighDetail(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(GlobalState.Blip.Display)
        EndTextCommandSetBlipName(blip)
    end
end)

-- FUNCTIONS
function washVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    TriggerServerEvent('iCarWash:removeMoney', GlobalState.WashPrice)
    SetVehicleDirtLevel(vehicle, 0)
    lib.defaultNotify({
        title = GlobalState.Translation.Title,
        description = GlobalState.Translation.Message,
        status = 'success'
    })
end

-- NUI CALLBACKS AND STUFF
function showUI()
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "show",
        status = true,
    })

    ESX.TriggerServerCallback("iCarWash:getOwner", function(owner)
        if owner then
            SendNUIMessage({
                type = "showowner",
                status = true,
            })
        else
            if GlobalState.OwnerCategoryEveryone then
                SendNUIMessage({
                    type = "showowner",
                    status = true,
                })
            end
        end
    end)

    SendNUIMessage({action = 'businesscash', value = GlobalState.WashPrice})

    ESX.TriggerServerCallback("iCarWash:getBusinessMoney", function(businessmoney)
        SendNUIMessage({action = 'businessmoney', value = businessmoney})
    end)

    ESX.TriggerServerCallback("iCarWash:getOwnername", function(owner)
        SendNUIMessage({action = 'ownername', value = owner})
    end)

    inMenu = true
end

function closeUI()
    SetNuiFocus(false, false)

    SendNUIMessage({
        type = "show",
        status = false,
    })

    inMenu = false
end

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)

    inMenu = false
end)

RegisterNUICallback("wash", function(data)
    closeUI()
    ESX.TriggerServerCallback('iCarWash:getMoney', function(cash)
        if cash >= GlobalState.WashPrice then
            washing = true
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            UseParticleFxAssetNextCall("core")
	        particles = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", pedCoords.x, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	        UseParticleFxAssetNextCall("core")
	        particles2 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", pedCoords.x + 2, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            if lib.progressBar({
                duration = GlobalState.WashDuration * 1000,
                label = GlobalState.Translation.WashingVehicle,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            }) then
                washVehicle()
                StopParticleFxLooped(particles, 0)
                StopParticleFxLooped(particles2, 0)
                washing = false
            else
            end
        else
            lib.defaultNotify({
                title = GlobalState.Translation.Title,
                description = GlobalState.Translation.notEnoughMoney,
                status = 'error'
            })
        end
    end)
end)

RegisterNUICallback("ownermenu", function(data)
    closeUI()
    ESX.TriggerServerCallback('iCarWash:getOwner', function(isOwner)
        if isOwner then
            local input = lib.inputDialog('Withdraw Business Money', {'Amount'})

            if input then
                local amount = tonumber(input[1])

                TriggerServerEvent('iCarWash:addMoney', amount)
            end
        else
            lib.defaultNotify({
                title = GlobalState.Translation.Title,
                description = GlobalState.Translation.NotOwner,
                status = 'error'
            })            
        end
    end)
end)
