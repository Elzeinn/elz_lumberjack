if not Framework.IsESX and not Framework.IsQB then
    return print('Framework not found')
end


Framework.GetPlayerData = function()
    if Framework.IsESX then
        return Core.PlayerData
    elseif Framework.IsQB then
        return Core.Functions.GetPlayerData()
    end
end

Framework.GetPlayerGrade = function()
    if Framework.IsESX then
        return Core.PlayerData.job.grade
    elseif Framework.IsQB then
        return Core.Functions.GetPlayerData().job.grade.level
    end
end
