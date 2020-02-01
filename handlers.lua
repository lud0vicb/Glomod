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
    if UnitExists("target") then
        showAll();
        isTargeting = true
    else
        checkHide();
        isTargeting = false
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
    fadeAll()
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
    if saveZoom == nil then
        saveZoom = {5, 15, true, 10}
    else
        intFeetZoom = saveZoom[1]
        intMountZoom = saveZoom[2]
        isZoomOn = saveZoom[3]
        intCombatZoom = saveZoom[4]
        local z =""
        if isZoomOn then
            optionsFrame.enterZF:SetText(tonumber(intFeetZoom))
            optionsFrame.enterZC:SetText(tonumber(intCombatZoom))
            optionsFrame.enterZM:SetText(tonumber(intMountZoom))
            optionsFrame.zoomButton:SetChecked(true)
        else
            optionsFrame.enterZF:SetText(tonumber(intFeetZoom))
            optionsFrame.enterZC:SetText(tonumber(intCombatZoom))
            optionsFrame.enterZM:SetText(tonumber(intMountZoom))
            optionsFrame.zoomButton:SetChecked(false)
        end
        debugFrame.zoomText:SetText(z)
    end
end

function myHandlers:PLAYER_LOGOUT()
    saveZoom[1] = intFeetZoom
    saveZoom[2] = intMountZoom
    saveZoom[3] = isZoomOn
    saveZoom[4] = intCombatZoom
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
    ChatFrame1:SetAlpha(1)
end
function myHandlers:PET_BATTLE_OPENING_DONE()
end
