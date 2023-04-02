
local washing = false
local inMenu = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
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

		if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, Config.CarWash) < Config.MarkerDistance and not washing and not inMenu then
            sleep = 5
            DrawMarker(Config.Marker.Type, Config.CarWash, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.Marker.ColorR, Config.Marker.ColorG, Config.Marker.ColorB, 50, false, true, 2, nil, nil, false)
        end

        if Vdist(pedCoords.x, pedCoords.y, pedCoords.z, Config.CarWash) < Config.TextUIDistance and (GetPedInVehicleSeat(vehicle, -1) == ped) and not washing and not inMenu then
           sleep = 5
           inZone = true
           if IsControlJustPressed(0, 38) then
               showUI()
           end
        end
        
        if not enteredZone and inZone then
            lib.showTextUI('[E] - ' .. Config.Translation.AccessCarWash, {
                position = "top-center",
                icon = Config.TextUIicon,
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
    local blip = AddBlipForCoord(Config.CarWash)
    SetBlipSprite(blip, Config.Blip.ID)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, Config.Blip.Size)
    SetBlipColour(blip, Config.Blip.Colour)
    SetBlipAsShortRange(blip, false)
    SetBlipHighDetail(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.Display)
    EndTextCommandSetBlipName(blip)
end)

-- FUNCTIONS
function washVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    TriggerServerEvent('iCarWash:removeMoney', Config.WashPrice)
    SetVehicleDirtLevel(vehicle, 0)
    lib.defaultNotify({
        title = Config.Translation.Title,
        description = Config.Translation.Message,
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
            if Config.OwnerCategoryEveryone then
                SendNUIMessage({
                    type = "showowner",
                    status = true,
                })
            end
        end
    end)

    SendNUIMessage({action = 'businesscash', value = Config.WashPrice})

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
        if cash >= Config.WashPrice then
            washing = true
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            UseParticleFxAssetNextCall("core")
	        particles = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", pedCoords.x, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	        UseParticleFxAssetNextCall("core")
	        particles2 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", pedCoords.x + 2, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            if lib.progressBar({
                duration = Config.WashDuration * 1000,
                label = Config.Translation.WashingVehicle,
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
                title = Config.Translation.Title,
                description = Config.Translation.notEnoughMoney,
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
                title = Config.Translation.Title,
                description = Config.Translation.NotOwner,
                status = 'error'
            })            
        end
    end)
end)
