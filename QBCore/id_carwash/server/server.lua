local QBCore = exports['qb-core']:GetCoreObject()

local cache = {}

QBCore.Functions.CreateCallback('iCarWash:getOwnername', function(source, cb, broj)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    local ownername
        
    MySQL.Async.fetchScalar('SELECT * FROM carwash WHERE owner = owner', {
    }, function(owner)
      if owner then
        local res = MySQL.Sync.fetchAll('SELECT * FROM carwash')
                    
        for key, val in ipairs(res) do
            hasowner = val.owner~=nil and val.owner~=""
            if hasowner and not cache[val.owner] then cache[val.owner]=MySQL.Sync.fetchAll("SELECT firstname,lastname FROM users WHERE identifier = @identifier",{["@identifier"]=val.owner})[1] end
            if val.owner~=nil then cache[val.owner] = cache[val.owner]~=nil and cache[val.owner] or {firstname="N/A",lastname="N/A"} end
            ownername = cache[val.owner].firstname.." "..cache[val.owner].lastname or "Nobody"
        end
      
        cb(ownername)
      end
    end)
end)

QBCore.Functions.CreateCallback('iCarWash:getOwner', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    MySQL.Async.fetchScalar('SELECT * FROM carwash WHERE owner = @owner ', {
      ["@owner"] = xPlayer.PlayerData.citizenid,
    }, function(owner)
  
    cb(owner)
  end)
end)

QBCore.Functions.CreateCallback('iCarWash:getBusinessMoney', function(source, cb)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    MySQL.Async.fetchScalar('SELECT money FROM carwash WHERE owner = @owner ', {
      ["@owner"] = xPlayer.PlayerData.citizenid,
    }, function(businesscash)
  
    cb(businesscash)
  end)
end)

RegisterServerEvent("iCarWash:removeMoney")
AddEventHandler("iCarWash:removeMoney", function(amount)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    --xPlayer.removeMoney(amount)
    xPlayer.Functions.RemoveMoney("cash", amount, "carwash")

    MySQL.Sync.execute(
      'UPDATE carwash SET money = money + @amount',
      {
          ["@amount"] = amount
      }
    )
end)

RegisterServerEvent("iCarWash:addMoney")
AddEventHandler("iCarWash:addMoney", function(amount)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    MySQL.Async.fetchScalar('SELECT money FROM carwash WHERE owner = @owner', {
        ["@owner"] = xPlayer.PlayerData.citizenid,
    }, function(money)
        if amount > 0 then
            if amount <= tonumber(money) then
              xPlayer.Functions.AddMoney("cash", amount, "carwash")

                MySQL.Sync.execute(
                  'UPDATE carwash SET money = money - @amount',
                  {
                      ["@amount"] = amount
                  }
                )
            end
        end
    end)
end)
