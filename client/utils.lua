Utils = {}

---@param model string
Utils.LoadModel = function(model)
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
    end
end

---@param dict string
Utils.LoadAnim = function(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(0)
        end
    end
end

---@param set string
Utils.LoadAnimSet = function(set)
    if not HasAnimSetLoaded(set) then
        RequestAnimSet(set)
        while not HasAnimSetLoaded(set) do
            Wait(0)
        end
    end
end

---@param msg string
---@param type string
---@param duration number
Utils.Notify = function(msg, type, duration)
    if Framework.IsQB == 'qb' then
        return exports.qbx_core:Notify(msg, type, duration)
    elseif Framework.IsESX == 'esx' then
        return ESX.ShowNotification(msg)
    else
        return exports.ox_lib:Notify(msg, type, duration)
    end
end
