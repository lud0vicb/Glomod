function MyFunctions:PLAYER_REGEN_DISABLED()
    isInCombat = true
    CombatHide()
    ShowAll()  
end

function MyFunctions:UNIT_SPELLCAST_START()
  
end

function MyFunctions:PLAYER_REGEN_ENABLED()
    isInCombat = false
    CheckHide()
    CombatHide()
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

function MyFunctions:UNIT_SPELLCAST_SUCCEEDED(arg1, arg2, arg3, arg4)  
    local caster = arg2
    local iSpell = arg4
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
    -- CHANGEFORM
    -- druid
    if iSpell == 5487 or iSpell == 768 then
        MoveCam(intFeetZoom)
    elseif iSpell == 783 then
        MoveCam(intMountZoom)
    end
    -- shaman
    if iSpell == 2645 then
        MoveCam(intMountZoom)
    end
end

function MyFunctions:PLAYER_ENTERING_WORLD()
    intFade = 0; 
    FadeAll()
end

function MyFunctions:GROUP_FORMED()
    PlaySound(17316)
end

function MyFunctions:UNIT_MODEL_CHANGED()
    -- druid
    if iclass == 11 then
        local iforme = GetShapeshiftForm(flag)
        if iforme == 0 or iforme == 1 or iforme == 3 then
            isFirstFeetMove = true
            print ('GLO Druid FORM : isFirstFeetMove')
        end
    end
    -- shaman
    if iclass == 7 then
        local iforme = GetShapeshiftForm(flag)
        if iforme == 0 then
            isFirstFeetMove = true
            print ('GLO Shaman FORM : isFirstFeetMove')
        end
    end 
end

function MyFunctions:ADDON_LOADED(arg1, arg2)
    if arg2 ~= "Glomod" then
        return
    end
    if saveZoom == nil then
        saveZoom = {5, 15, true}
        print ('INIT')
    else
        intFeetZoom = saveZoom[1] 
        intMountZoom = saveZoom[2]
        isZoomOn = saveZoom[3]
        print('LOADED ' )
        print(intFeetZoom)
        print(intMountZoom)
        print(tostring(isZoomOn))
    end
end

function MyFunctions:PLAYER_LOGOUT()
    saveZoom[1] = intFeetZoom
    saveZoom[2] = intMountZoom
    saveZoom[3] = isZoomOn
end
