-- Variables
local object = nil
local logObject = nil
local PlayerData = {
    active = false,
}

-- Test Kenvera
-- Function
local function Lerp(start, stop, t)
    return start + (stop - start) * t
end

local function SetupBlips(data)
    local blips = AddBlipForCoord(data.coords)
    SetBlipSprite(blips, 171)
    SetBlipDisplay(blips, 4)
    SetBlipScale(blips, 0.8)
    SetBlipAsShortRange(blips, true)
    SetBlipColour(blips, 28)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Pohon')
    EndTextCommandSetBlipName(blips)
end

local function CuttingWood(entity)
    Citizen.CreateThread(function()
        SendNUIMessage({
            action = 'show',
            data = 'sound'
        })
        PlaySoundFromEntity(-1, "DLC_HEIST_FLEECA_SOUNDSET", entity, "DLC_HEIST_FLEECA_SOUNDSET", false, 0, true)
        for i = 1, 130 do
            local woodCoords = GetEntityCoords(entity)
            local woodRotation = GetEntityRotation(entity, 2)
            local newZ = Lerp(woodCoords.z, woodCoords.z - 0.1, 0.1)
            SetEntityCoords(entity, woodCoords.x, woodCoords.y, newZ, false, false, false, true)
            local newRotationX = Lerp(woodRotation.x, woodRotation.x + 5.0, 0.1)
            SetEntityRotation(entity, newRotationX, woodRotation.y, woodRotation.z, 2)
            Wait(20)
        end

        Wait(700)
        local coords = GetEntityCoords(entity)
        PlaySoundFromCoord(-1, "DLC_HEIST_FLEECA_SOUNDSET", coords.x, coords.y, coords.z, "DLC_HEIST_FLEECA_SOUNDSET",
            false, 0, true)

        local finalCoords = GetEntityCoords(entity)
        local finalRotation = GetEntityRotation(entity, 2)
        DeleteEntity(entity)

        Utils.LoadModel("prop_log_01")

        logObject = CreateObject('prop_log_01', finalCoords.x, finalCoords.y, finalCoords.z + 10, true, true,
            true)

        UseParticleFxAssetNextCall("core")
        StartParticleFxNonLoopedAtCoord("bul_wood_splinter", finalCoords.x, finalCoords.y, finalCoords.z, 0.0, 0.0, 0.0,
            10.0,
            false,
            false, false, false)
        SetEntityRotation(logObject, finalRotation.x, finalRotation.y, finalRotation.z, 2)
        FreezeEntityPosition(logObject, true)
        PlaceObjectOnGroundProperly(logObject)
        exports.ox_target:addLocalEntity(logObject, {
            icon = 'fa-solid fa-bong',
            label = 'Potong Pohon',
            onSelect = function(data)
                local axeModel = "prop_tool_fireaxe"
                Utils.LoadModel(axeModel)
                local playerPed = PlayerPedId()
                local axe = CreateObject(axeModel, 0, 0, 0, true, true, true)
                AttachEntityToEntity(
                    axe,
                    playerPed,
                    GetPedBoneIndex(playerPed, 57005),
                    0.0160,
                    -0.3140,
                    -0.0860,
                    -97.1455,
                    165.0749,
                    13.9114,
                    true, true, false, true, 1, true
                )
                Utils.LoadAnim('melee@large_wpn@streamed_core')

                local cutDuration = 15000
                local startTime = GetGameTimer()
                Utils.LoadAnimSet('move_ped_crouched')
                SetPedUsingActionMode(playerPed, false, -1, "DEFAULT_ACTION")
                SetPedMovementClipset(playerPed, 'move_ped_crouched', 0.55)
                SetPedStrafeClipset(playerPed, 'move_ped_crouched_strafing')
                SetWeaponAnimationOverride(playerPed, "Ballistic")
                FreezeEntityPosition(playerPed, true)
                while GetGameTimer() - startTime < cutDuration do
                    TaskPlayAnim(playerPed, 'melee@large_wpn@streamed_core', 'ground_attack_on_spot', 8.0, 8.0, -1, 49, 0,
                        false, false, false)
                    UseParticleFxAssetNextCall("core")
                    local logCoords = GetEntityCoords(logObject)
                    StartParticleFxNonLoopedAtCoord("bul_wood_splinter", logCoords.x, logCoords.y, logCoords.z + 1.0, 0.0,
                        0.0, 0.0, 1.0, false, false, false)

                    Wait(800)
                end
                lib.callback.await('elz_lumberjack:server:CutTree', false)
                FreezeEntityPosition(playerPed, false)
                ClearPedTasks(playerPed)
                DeleteObject(axe)
                DeleteEntity(data.entity)
            end
        })
    end)
end

local function CutTree(data)
    local ped = PlayerPedId()
    TaskTurnPedToFaceCoord(ped, data.coords.x, data.coords.y, data.coords.z, -1)
    Wait(200)
    local axeModel = "prop_tool_fireaxe"
    Utils.LoadModel(axeModel)

    local coords = GetEntityCoords(ped)
    local axe = CreateObject('prop_tool_fireaxe', coords.x, coords.y, coords.z, true, true, true)
    AttachEntityToEntity(
        axe,
        ped,
        GetPedBoneIndex(ped, 57005),
        0.055812, 0.031364, 0.0,
        34.9089, 37.0982, -153.6617,
        true,
        true,
        false,
        true,
        1,
        true
    )
    Utils.LoadAnim("melee@hatchet@streamed_core")
    FreezeEntityPosition(ped, true)

    for i = 1, 10 do
        TaskPlayAnim(ped, "melee@hatchet@streamed_core", "plyr_front_takedown", 8.0, -8.0, -1, 0, 0,
            true,
            true, true)
        if i % 2 == 0 then
            UseParticleFxAssetNextCall("core")
            StartParticleFxNonLoopedAtCoord("bul_wood_splinter", coords.x, coords.y, coords.z, 0.0,
                0.0, 0.0, 1.0,
                false,
                false, false, false)
        end
        Wait(1000)
    end
    FreezeEntityPosition(ped, false)
    DeleteObject(axe)
    CuttingWood(data.entity)
end

local function getLabelDuty()
    if PlayerData.active then
        return 'Off Duty'
    else
        return 'On Duty'
    end
end


local function OpenMenu()
    lib.registerContext({
        id = 'event_menu',
        title = 'Lumberjack Menu',
        menu = 'some_menu',
        options = {
            {
                title = getLabelDuty(),
                icon = 'fa-solid fa-clock',
                description = 'Select to toggle duty',
                onSelect = function()
                    PlayerData.active = not PlayerData.active
                end
            },
            {
                title = 'Sell Item',
                icon = 'fa-solid fa-coins',
                description = 'Sell item in here',
                onSelect = function()
                    local input = lib.inputDialog('Lumberjack', {
                        { type = 'number', label = 'Input', description = 'Amount for sell', icon = 'hashtag' },
                    })
                    local chekcItems = exports.ox_inventory:GetItemCount('burger')
                    if chekcItems >= Config.SellItems.requiredForSell then
                        local status = lib.callback.await('elz_lumberjack:server:SellItem', false,
                            { amount = input[1] })
                    else
                        lib.notify({
                            title = 'Lumberjack',
                            description = 'You do not have enough items',
                            type = 'error'
                        })
                    end
                end
            },
        }
    })

    lib.showContext('event_menu')
end

-- Threads
CreateThread(function()
    for i = 1, #Config.DataObject do
        local value = Config.DataObject[i]
        Utils.LoadModel(value.model)
        object = CreateObject(value.model, value.coords.x, value.coords.y, value.coords.z, false, false, false)
        SetEntityAsMissionEntity(object, true, true)
        FreezeEntityPosition(object, true)
        SetupBlips(value)
    end
    exports.ox_target:addModel('prop_tree_cedar_02', {
        icon = 'fa-solid fa-bong',
        label = 'Tebang Pohon',
        distance = 1,
        onSelect = function(data)
            CutTree(data)
        end,
        canInteract = function()
            return PlayerData.active and Config.Jobs.use
        end
    })
end)

CreateThread(function()
    if not Config.PedLocation.use then return end
    Utils.LoadModel(Config.PedLocation.model)
    local ped = CreatePed(4, Config.PedLocation.model, Config.PedLocation.coords.x, Config.PedLocation.coords.y,
        Config.PedLocation.coords.z, Config.PedLocation.coords.w, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    FreezeEntityPosition(ped, true)
    exports.ox_target:addLocalEntity(ped, {
        icon = 'fa-solid fa-bong',
        label = 'Start Working',
        distance = 1,
        onSelect = function(data)
            if not Config.Jobs.use then return OpenMenu() end
            if Utils.GetPlayerData().job.name == Config.Jobs.job then
                OpenMenu()
            else
                Utils.Notify('Not Job Access')
            end
        end
    })
end)


-- Event Handler
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        DeleteObject(logObject)
        DeleteObject(object)
    end
end)
