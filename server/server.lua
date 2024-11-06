if Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    function GetPlayerFromId(source)
        return QBCore.Functions.GetPlayer(source)
    end

    function GetDataJob(source)
        return QBCore.Functions.GetPlayer(source).PlayerData.job
    end

    function addMoney(source, amount)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.AddMoney('cash', amount)
    end
elseif Framework == 'esx' then
    function GetPlayerFromId(source)
        return ESX.GetPlayerFromId(source)
    end

    function GetDataJob(source)
        return ESX.GetPlayerFromId(source).job
    end

    function addMoney(source, amount)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addMoney(amount)
    end
end

lib.callback.register('elz_lumberjack:server:CutTree', function(source)
    local player = GetPlayerFromId(source)
    local item = exports.ox_inventory:GetItem(source, Config.CutThree.item)
    exports.ox_inventory:AddItem(source, item, Config.CutThree.amount)
end)

lib.callback.register('elz_lumberjack:server:SellItem', function(source, data)
    local player = GetPlayerFromId(source)
    local item = exports.ox_inventory:GetItem(source, Config.SellItems.item)
    if item >= data.amount then
        player.Functions.RemoveItem(Config.SellItems.item, data.amount)
        addMoney(source, data.amount * Config.SellItems.price)
    end
end)
