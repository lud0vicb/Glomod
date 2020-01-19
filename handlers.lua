function MyFunctions:PLAYER_REGEN_DISABLED()
    isInCombat = true
    CombatHide()
    ShowAll()
    combatCamIn()
end

function MyFunctions:PLAYER_REGEN_ENABLED()
    isInCombat = false
    CheckHide()
    CombatHide()
    combatCamOut()
    --CheckMount()
end

function MyFunctions:VIGNETTE_MINIMAP_UPDATED(event, id, isVisible)
    if not isVisible then
        return
    end
    --PlaySound(77003)
    vInfo = C_VignetteInfo.GetVignetteInfo(id)
    local type, _, iServer, iInstance, iZone, iNpc, iSpawn = strsplit("-", vInfo.objectGUID)
    ChatFrame1:SetAlpha(1)
    local msg = string.format("ALERTE %s : %s à proximité", type, vInfo.name)
    if UnitInParty("player") then
        SendChatMessage(msg, "PARTY")
    else
        SendChatMessage(msg, "EMOTE")
    end
    if type == "Creature" then
        DoEmote("OPENFIRE")
    elseif type == "GameObject" then
        DoEmote("CHARGE")
    end
    --SendChatMessage(msg, "WHISPER", nil, GetUnitName("player"))
end

function MyFunctions:UNIT_SPELLCAST_START()
end

function MyFunctions:PLAYER_STOPPED_MOVING()
    Moved()
end
function MyFunctions:PLAYER_STARTED_MOVING()
    Moved()
end

function MyFunctions:PLAYER_TARGET_CHANGED()
    if UnitExists("target") then
        ShowAll();
        isTargeting = true
    else
        CheckHide();
        isTargeting = false
    end
end

function MyFunctions:PLAYER_CONTROL_LOST()
    UIParent:Hide()
    MoveViewLeftStart(0.1)
    MoveCam(intMountZoom)
end

function MyFunctions:PLAYER_CONTROL_GAINED()
    UIParent:Show()
    MoveViewLeftStop()
    MoveCam(intFeetZoom)
end

function MyFunctions:UNIT_SPELLCAST_SUCCEEDED(event, caster, arg3, iSpell)
    --local caster = arg2
    --local iSpell = arg4
    if caster ~= "player" then
        return
    end
    -- PECHE A LA LIGNE
    if iSpell == 131476 then
        if not isFishing then
            MoveViewRightStart(0.05)
            C_Timer.After(2, function() MoveViewRightStop() end)
            isFishing = true
            MoveCam (intFishZoom)
            isFirstFeetMove = true
            isFirstMountMove = true
        end
    end
end

function MyFunctions:PLAYER_ENTERING_WORLD()
    intFade = 0;
    FadeAll()
end

function MyFunctions:GROUP_FORMED()
    PlaySound(17316)
end

function MyFunctions:UPDATE_SHAPESHIFT_FORM()
    if iclass == 11 or iclass == 7 then -- druid
        local fff = GetShapeshiftForm(flag)
        if iforme == fff or fff == 4 then
            return
        end
        iforme = fff
        --print (string.format("FORM %d", iforme))
        if iforme ~= tableForm[iclass] then
            if isInCombat then
                MoveCam(intCombatZoom)
            else
                MoveCam(intFeetZoom)
            end
        else
            MoveCam(intMountZoom)
        end
    end
end

function MyFunctions:ADDON_LOADED(arg1, arg2)
    if arg2 ~= "Glomod" then
        return
    end
    if saveZoom == nil then
        saveZoom = {5, 15, true, 10}
    else
        intFeetZoom = saveZoom[1]
        intMountZoom = saveZoom[2]
        isZoomOn = saveZoom[3]
        intCombatZoom = saveZoom[4]
        printZoom()
    end
end

function MyFunctions:PLAYER_LOGOUT()
    saveZoom[1] = intFeetZoom
    saveZoom[2] = intMountZoom
    saveZoom[3] = isZoomOn
    saveZoom[4] = intCombatZoom
end
