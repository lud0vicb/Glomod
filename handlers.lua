function myHandlers:UNIT_ENTERING_VEHICLE(event, target)
    if target ~= "player" then
        return
    end
    moveCam(intVehicleZoom)
    isZoomOn = false
end

function myHandlers:UNIT_EXITING_VEHICLE(event, target)
    if target ~= "player" then
        return
    end
    isZoomOn = true
    moveCam(intFeetZoom)
end

function myHandlers:PLAYER_REGEN_DISABLED()
    isInCombat = true
    combatHide()
    showAll()
    combatCamIn()
end

function myHandlers:PLAYER_REGEN_ENABLED()
    isInCombat = false
    checkHide()
    combatHide()
    combatCamOut()
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
    MoveViewLeftStart(0.1)
    moveCam(intMountZoom)
end

function myHandlers:PLAYER_CONTROL_GAINED()
    UIParent:Show()
    MoveViewLeftStop()
    moveCam(intFeetZoom)
end

function myHandlers:UNIT_SPELLCAST_SUCCEEDED(event, caster, arg3, iSpell)
    if caster ~= "player" then
        return
    end
    if isDebuging then
        local msg = string.format("SPELL %d", iSpell)
        printDebug(msg)
    end
    if iSpell == 131476 then -- PECHE A LA LIGNE
        if not isFishing then
            MoveViewRightStart(0.05)
            C_Timer.After(2, function() MoveViewRightStop() end)
            isFishing = true
            moveCam (intFishZoom)
            isFirstFeetMove = true
            isFirstMountMove = true
        end
    elseif iSpell == 125883 then -- nuage volant du moine
        --moveCam (intMountZoom)
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
    if iclass == 11 or iclass == 7 then -- druid shaman
        local fff = GetShapeshiftForm(flag)
        if isDebuging then
           local m = string.format("SHAPESHIFT %d %d", fff, iforme)
           printDebug(m)
         end
        if iforme == fff or fff == 4 or fff == 6 then
            return
        end
        iforme = fff
        if iforme ~= tableForm[iclass] then
            if isInCombat then
                moveCam(intCombatZoom)
                m = string.format("SH combat %d",  intCombatZoom)
            else
                moveCam(intFeetZoom)
                m = string.format("SH feet %d",  intFeetZoom)
            end
        else
            moveCam(intMountZoom)
            m = string.format("SH mount %d",  intMountZoom)
        end
        if isDebuging then
          printDebug(m)
        end
    end
end

function myHandlers:ADDON_LOADED(arg1, addon)
    if addon ~= "Glomod" then
        return
    end
    local z = ""
    if gloptions == nil then
        intFeetZoom = 5
        intMountZoom = 15
        isZoomOn = true
        intCombatZoom = 10
        saveZoom = {}
        isFadeOn = true
        isZoomOn = true
        isVignetteOn = true
        gloptions = {isFadeOn, isZoomOn, isVignetteOn, intFeetZoom, intMountZoom, isZoomOn, intCombatZoom}
        z = string.format("z:0 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
    else
        intFeetZoom = gloptions[4]
        intMountZoom = gloptions[5]
        isZoomOn = gloptions[6]
        intCombatZoom = gloptions[7]
        if isZoomOn then
            optionsFrame.enterZF:SetText(tonumber(intFeetZoom))
            optionsFrame.enterZC:SetText(tonumber(intCombatZoom))
            optionsFrame.enterZM:SetText(tonumber(intMountZoom))
            optionsFrame.zoomButton:SetChecked(true)
            z = string.format("z:1 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
        else
            optionsFrame.enterZF:SetText(tonumber(intFeetZoom))
            optionsFrame.enterZC:SetText(tonumber(intCombatZoom))
            optionsFrame.enterZM:SetText(tonumber(intMountZoom))
            optionsFrame.zoomButton:SetChecked(false)
            z = string.format("z:0 %d %d %d", intFeetZoom, intCombatZoom, intMountZoom)
        end
        isFadeOn = not gloptions[1]
        isZoomOn = not gloptions[2]
        isVignetteOn = not gloptions[3]
        optionsZoom()
        optionsFading()
        optionsVignette()
    end
    optionsFrame.zoomButton:SetChecked(isZoomOn)
    optionsFrame.fadingButton:SetChecked(isFadeOn)
    optionsFrame.vignetteButton:SetChecked(isVignetteOn)
    debugFrame.zoomActual:SetText(string.format("a: %d", GetCameraZoom()))
    debugFrame.zoomText:SetText(z)
end

function myHandlers:PLAYER_LOGOUT()
    gloptions[4] = intFeetZoom
    gloptions[5] = intMountZoom
    gloptions[6] = isZoomOn
    gloptions[7] = intCombatZoom
    gloptions[1] = isFadeOn
    gloptions[2] = isZoomOn
    gloptions[3] = isVignetteOn
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
