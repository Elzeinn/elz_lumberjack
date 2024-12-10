if not Framework.IsESX and not Framework.IsQB then
    return
end

---@param id number
Framework.GetPlayerFromId = function(id)
    if Framework.IsESX then
        return Core.GetPlayerFromId(id)
    elseif Framework.IsQB then
        return Core.Functions.GetPlayer(id)
    end
end

---@param source number
---@param amount number
---@param type string
Framework.RemoveMoney = function(source, amount, type)
    local xPlayer = Framework.GetPlayerFromId(source)
    if Framework.IsESX then
        return xPlayer.removeAccountMoney(type, amount)
    elseif Framework.IsQB then
        return xPlayer.Functions.RemoveMoney(type, amount)
    end
end

---@param source number
---@param amount number
---@param type string
Framework.AddMoney = function(source, amount, type)
    local xPlayer = Framework.GetPlayerFromId(source)
    if Framework.IsESX then
        return xPlayer.addAccountMoney(type, amount)
    elseif Framework.IsQB then
        return xPlayer.Functions.AddMoney(type, amount)
    end
end

---@param source number
---@return string
Framework.GetJob = function(source)
    if Framework.IsESX then
        return Core.GetPlayerFromId(source).getJob().name
    elseif Framework.IsQB then
        return Core.Functions.GetPlayer(source).PlayerData.job.name
    end
end

---@param source number
---@return number
Framework.GetJobGrade = function(source)
    if Framework.IsESX then
        return Core.GetPlayerFromId(source).getJob().grade
    elseif Framework.IsQB then
        return Core.Functions.GetPlayer(source).PlayerData.job.grade.level
    end
end

---@param source number
---@param item string
---@param count number
Framework.AddItem = function(source, item, count)
    local Player = Framework.GetPlayerFromId(source)

    if Framework.IsESX then
        return Player.addInventoryItem(item, count)
    elseif Framework.IsQB then
        return Player.Functions.AddItem(item, count)
    end
end

---@param source number
---@param item string
---@param count number
Framework.RemoveItem = function(source, item, count)
    local Player = Framework.GetPlayerFromId(source)
    if Framework.IsESX then
        return Player.removeInventoryItem(item, count)
    elseif Framework.IsQB then
        return Player.Functions.RemoveItem(item, count)
    end
end
