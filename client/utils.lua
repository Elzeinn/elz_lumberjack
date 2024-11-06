Utils = {}

Utils.LoadModel = function(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end
end

Utils.LoadAnim = function(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

Utils.LoadAnimSet = function(set)
    if not HasAnimSetLoaded(set) then
        RequestAnimSet(set)
        while not HasAnimSetLoaded(set) do
            Wait(0)
        end
    end
end

Utils.Notify = function(msg, type, duration)
    if Framework == 'qb' then
        exports.qbx_core:Notify(msg, type, duration)
    elseif Framework == 'esx' then
        ESX.ShowNotification(msg)
    else
        print(msg)
    end
end

Utils.GetPlayerData = function()
    if Framework == 'qb' then
        local QBCore = exports['qb-core']:GetCoreObject()
        return QBCore.Functions.GetPlayerData()
    elseif Framework == 'esx' then
        return ESX.PlayerData
    else
        print('not framework')
    end
end
