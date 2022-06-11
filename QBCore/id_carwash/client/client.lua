local QBCore = exports['qb-core']:GetCoreObject()

local washing = false
local inMenu = false

local PlayerData = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

Citizen.CreateThread(function()
    for i, data in ipairs(Config.CarWash) do
        local blip = AddBlipForCoord(data.coords)
        SetBlipSprite(blip, Config.Blip.ID)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.Size)
        SetBlipColour(blip, Config.Blip.Colour)
        SetBlipAsShortRange(blip, false)
        SetBlipHighDetail(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Display)
        EndTextCommandSetBlipName(blip)
    end
end)

-- FUNCTIONS
function washVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    TriggerServerEvent('iCarWash:removeMoney', Config.WashPrice)
    SetVehicleDirtLevel(vehicle, 0)
    QBCore.Functions.Notify({
        text = Config.Translation.Title,
        caption = Config.Translation.Message,
    }, "success")
end

-- NUI CALLBACKS AND STUFF
function showUI()
    SetNuiFocus(true, true)

    SendNUIMessage({
        type = "show",
        status = true,
    })

    QBCore.Functions.TriggerCallback("iCarWash:getOwner", function(owner)
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

    QBCore.Functions.TriggerCallback("iCarWash:getBusinessMoney", function(businessmoney)
        SendNUIMessage({action = 'businessmoney', value = businessmoney})
    end)

    QBCore.Functions.TriggerCallback("iCarWash:getOwnername", function(owner)
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
    if PlayerData.money["cash"] >= Config.WashPrice then
        washing = true
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        UseParticleFxAssetNextCall("core")
        particles = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", pedCoords.x, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
        UseParticleFxAssetNextCall("core")
        particles2 = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", pedCoords.x + 2, pedCoords.y, pedCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

        QBCore.Functions.Progressbar("washing_pb", Config.Translation.WashingVehicle, Config.WashDuration * 1000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            washVehicle()
            StopParticleFxLooped(particles, 0)
            StopParticleFxLooped(particles2, 0)
            washing = false
        end, function() -- Cancel
        end)
    else
        QBCore.Functions.Notify({
            text = Config.Translation.Title,
            caption = Config.Translation.notEnoughMoney,
        }, "error")

    end
end)

RegisterNUICallback("ownermenu", function(data)
    closeUI()
    QBCore.Functions.TriggerCallback('iCarWash:getOwner', function(isOwner)
        if isOwner then
            local input = exports['qb-input']:ShowInput({
                header = "Withdraw Business Money",
                submitText = "Withdraw",
                inputs = {
                    {
                        text = "Amount",
                        name = "amount",
                        type = "number",
                        isRequired = true,
                    }
                },
            })
            if input ~= nil then
                local amount = tonumber(input.amount)

                TriggerServerEvent('iCarWash:addMoney', amount)
            end
        else
            QBCore.Functions.Notify({
                text = Config.Translation.Title,
                caption = Config.Translation.NotOwner,
            }, "error")          
        end
    end)
end)

local function UIListener()
    CreateThread(function()
        while inCarWash do
            if IsControlJustPressed(0, 38) then
                exports['qb-core']:KeyPressed(38)
                showUI()
            end
            Wait(1)
        end
    end)
end

local function StartFunctionsAndMarkers(i)
    Citizen.CreateThread(function()
        local coords = Config.CarWash[i].coords
        local boxName = "CarwashInside_"..i
        local boxData = Config.CarWash[i].polyzoneBoxData

        Citizen.CreateThread(function()
            while nearCarWash do
                DrawMarker(Config.Marker.Type, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, Config.Marker.ColorR, Config.Marker.ColorG, Config.Marker.ColorB, 50, false, true, 2, nil, nil, false)
                Citizen.Wait(0)
            end
        end)

        local zone = BoxZone:Create(coords, boxData.innerLength, boxData.innerWidth, {
            name = boxName,
            heading = boxData.heading,
            debugPoly = boxData.debug,
            minZ = coords.z - 1.0,
            maxZ = coords.z + 2.0
        })

        zone:onPlayerInOut(function(isPointInside)
            if isPointInside then
                inCarWash = true
                UIListener()
                exports['qb-core']:DrawText('[E] - ' .. Config.Translation.AccessCarWash, 'left')                
            else
                inCarWash = false
                exports['qb-core']:HideText()
            end
        end)
        
        boxData.created = true
        boxData.zone = zone
    end)
end

local function StopFunctionsAndMarkers(i)
    Citizen.CreateThread(function()
        if Config.CarWash[i].polyzoneBoxData.created then
            Config.CarWash[i].polyzoneBoxData.zone:destroy()
            Config.CarWash[i].polyzoneBoxData.created = false
            Config.CarWash[i].polyzoneBoxData.zone = nil
        end
    end)
end

local function CreateCarWashZones()
    Citizen.CreateThread(function()
        for i, data in ipairs(Config.CarWash) do
            local zone = CircleZone:Create(data.coords, Config.MarkerDistance, {
                name = "Carwash_"..i,
                debugPoly = data.polyzoneBoxData.debug,
                useZ = true
            })

            zone:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    nearCarWash = true
                    StartFunctionsAndMarkers(i)
                else
                    nearCarWash = false
                    StopFunctionsAndMarkers(i)
                end
            end)

            data.polyzoneBoxData.created = true
            data.polyzoneBoxData.zone = zone
        end
    end)
end

Citizen.CreateThread(function()
    local wait = 500
    while not QBCore.Functions.GetPlayerData() do
        Wait(wait)
    end

    CreateCarWashZones()

    PlayerData = QBCore.Functions.GetPlayerData()
end)
