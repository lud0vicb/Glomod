function MyFunctions:PLAYER_REGEN_DISABLED()
    inCombat = true
    CombatHide()
    ShowAll()  
end

function MyFunctions:UNIT_SPELLCAST_START()
  
end

function MyFunctions:PLAYER_REGEN_ENABLED()
    inCombat = false
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
        targeting = true
    else
        CheckHide(); 
        targeting = false
    end
end

function MyFunctions:PLAYER_CONTROL_LOST()
    UIParent:Hide()
    MoveViewLeftStart(0.1)
    MoveCam(MountZoom)
end

function MyFunctions:PLAYER_CONTROL_GAINED()
    UIParent:Show()
    MoveViewLeftStop()
    MoveCam(FeetZoom)
end

function MyFunctions:UNIT_SPELLCAST_SUCCEEDED(arg1, arg2, arg3, arg4)  
    local caster = arg2
    local iSpell = arg4
    if caster ~= "player" then
        return
    end
    -- PECHE A LA LIGNE
    if iSpell == 131476 then
        if not IsFishing then
            MoveViewRightStart(0.05)
            C_Timer.After(2, function() MoveViewRightStop() end)
            IsFishing = true
            MoveCam (FishZoom)
            FirstFeetMove = true
            FirstMountMove = true
        end
    end
    -- CHANGEFORM
    -- druid
    if iSpell == 5487 or iSpell == 768 then
        MoveCam(FeetZoom)
    elseif iSpell == 783 then
        MoveCam(MountZoom)
    end
    -- shaman
    if iSpell == 2645 then
        MoveCam(MountZoom)
    end
end

function MyFunctions:PLAYER_ENTERING_WORLD()
    fade = 0; 
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
            FirstFeetMove = true
            print ('GLO Druid FORM : FirstFeetMove')
        end
    end
    -- shaman
    if iclass == 7 then
        local iforme = GetShapeshiftForm(flag)
        if iforme == 0 then
            FirstFeetMove = true
            print ('GLO Shaman FORM : FirstFeetMove')
        end
    end 
end