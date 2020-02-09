function myHandlers:UNIT_ENTERING_VEHICLE(event, target)
    if target ~= "player" then
        return
    end
    saveCam = GetCameraZoom()
    moveCam(intVehicleZoom)
end

function myHandlers:UNIT_EXITING_VEHICLE(event, target)
    if target ~= "player" then
        return
    end
    moveCam(saveCam)
end

function myHandlers:PLAYER_REGEN_DISABLED()
    isInCombat = true
    combatHide()
    showAll()
end

function myHandlers:PLAYER_REGEN_ENABLED()
    isInCombat = false
    combatHide()
    checkHide()
end

function myHandlers:VIGNETTE_MINIMAP_UPDATED(event, id, isVisible)
    if not isVisible then
        return
    end
    vInfo = C_VignetteInfo.GetVignetteInfo(id)
    if checkVignetteSave(vInfo) then
        return
    end
    sendInfoVignette(vInfo)
end

function myHandlers:UNIT_SPELLCAST_START()
end

function myHandlers:PLAYER_STOPPED_MOVING()
    moved()
end
function myHandlers:PLAYER_STARTED_MOVING()
    moved()
end

function myHandlers:PLAYER_TARGET_CHANGED()
    if isFadeOn then
        if UnitExists("target") then
            showAll();
            isTargeting = true
        else
            checkHide();
            isTargeting = false
        end
    end
end

function myHandlers:PLAYER_CONTROL_LOST()
    UIParent:Hide()
    MoveViewLeftStart(intRotationSpeed)
    -- find if we are on a taxi to moveCam
end

function myHandlers:PLAYER_CONTROL_GAINED()
    UIParent:Show()
    MoveViewLeftStop()
end

function myHandlers:UNIT_SPELLCAST_SUCCEEDED(event, caster, arg3, iSpell)
    if caster ~= "player" then
        return
    end
    --if isDebuging then
        --local msg = string.format("SPELL %d", iSpell)
        --printDebug(msg)
    --end
    if iSpell == 131476 then -- PECHE A LA LIGNE
        if not isFishing then
            MoveViewRightStart(0.05)
            C_Timer.After(2, function() MoveViewRightStop() end)
            isFishing = true
        end
    elseif iSpell == 125883 then -- nuage volant du moine
    end
end

function myHandlers:PLAYER_ENTERING_WORLD()
    intFade = 0;
    if isFadeOn then
        fadeAll()
    end
end

function myHandlers:GROUP_FORMED()
    PlaySound(17316)
end

function myHandlers:UPDATE_SHAPESHIFT_FORM()
end

function myHandlers:ADDON_LOADED(arg1, addon)
    if addon ~= "Glomod" then
        return
    end
    if gloptions == nil then
        isFadeOn = true
        isVignetteOn = true
        gloptions = {isFadeOn, false, isVignetteOn, 0, 0, false, 0, 0}
    else
        isFadeOn = not gloptions[1]
        isVignetteOn = not gloptions[3]
        optionsFading()
        optionsVignette()
    end
    optionsFrame.fadingButton:SetChecked(isFadeOn)
    optionsFrame.vignetteButton:SetChecked(isVignetteOn)
end

function myHandlers:PLAYER_LOGOUT()
    gloptions[4] = 0
    gloptions[5] = 0
    gloptions[6] = false
    gloptions[7] = 0
    gloptions[1] = isFadeOn
    gloptions[2] = false
    gloptions[3] = isVignetteOn
    gloptions[8] = 0
end

function myHandlers:GOSSIP_SHOW()
    moveFrame(GossipFrame)
end
function myHandlers:QUEST_GREETING()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_PROGRESS()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_DETAIL()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_ITEM_UPDATE()
    moveFrame(QuestFrame)
end
function myHandlers:QUEST_COMPLETE()
    moveFrame(QuestFrame)
end
function myHandlers:MERCHANT_SHOW()
    moveFrame(MerchantFrame)
end
function myHandlers:MERCHANT_UPDATE()
    moveFrame(MerchantFrame)
end
function myHandlers:PET_BATTLE_CLOSE()
end
function myHandlers:PET_BATTLE_OPENING_DONE()
    ChatFrame1:SetAlpha(1)
end
