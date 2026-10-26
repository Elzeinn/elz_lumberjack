---@param source number
lib.callback.register('elz_lumberjack:server:CutTree', function(source)
    local status = lib.callback.await('elz_lumberjack:client:CheckValidate', source)
    if not status then return end
    if exports.ox_inventory:CanCarryItem(source, Config.CutThree.item, Config.CutThree.amount) then
        Framework.AddItem(source, Config.CutThree.item, Config.CutThree.amount)
    end
end)

---@param source number
---@param data table
lib.callback.register('elz_lumberjack:server:SellItem', function(source, data)
    local item = exports.ox_inventory:GetItem(source, Config.SellItems.item)
    if item >= data.amount then
        Framework.RemoveItem(Config.SellItems.item, data.amount)
        Framework.AddMoney(source, data.amount * Config.SellItems.price, Config.SellItems.payment)
    else
        return false
    end
end)
