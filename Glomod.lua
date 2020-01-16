MyFunctions={}
tableFrame ={ --global bcause used in different functions
    PlayerFrame, TargetFrame, MainMenuBar, MultiBarRight, BuffFrame, MicroButtonAndBagsBar
} 
  
function GlomodOnload(self) 
    inCombat = false
    fade=0
    targeting=false
    FadeAll()
    MountZoom=15
    FeetZoom=5
    FishZoom=1.5
    IsFishing = false
    FirstFeetMove = true
    FirstMountMove = true
    TimerFade = 3
    
    FRClass, ENClass, iclass = UnitClass("player")
    
    for i,v in ipairs(tableFrame) do
        v:SetScript('OnEnter', function() ShowAll() end)
        v:SetScript('OnLeave', function() CheckHide() end)
    end

    local tableEvent = {
      "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED","UNIT_SPELLCAST_SUCCEEDED","PLAYER_ENTERING_WORLD",
      "UNIT_MODEL_CHANGED", "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST", "UNIT_SPELLCAST_SUCCEEDED", "PLAYER_STARTED_MOVING",
      "PLAYER_STOPPED_MOVING", "UNIT_SPELLCAST_START"
    }
    for i,v in ipairs(tableEvent) do
        self:RegisterEvent(v);
    end
    
    self:SetScript('OnEvent', function(self, event, ...) MyFunctions[event](self, event, ...) end)
          
    local tableHide={
        MainMenuBarArtFrame.LeftEndCap, MainMenuBarArtFrame.RightEndCap, MainMenuBarArtFrameBackground
    }
    for i,v in ipairs(tableHide) do
        v:Hide()
    end  
  
    local tableShowOnMouse = {
        ChatFrame1, ChatFrame2,
    }
    for i,v in ipairs(tableShowOnMouse) do
        --ShowOnMouse(v)
    end
    
end

function ShowOnMouse(frame)
    frame:SetScript('OnEnter', function() frame:SetAlpha(1) end)
    frame:SetScript('OnLeave', function() frame:SetAlpha(0) end)
    C_Timer.After(6, function() frame:SetAlpha(0) end)
end

function MoveCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("TOP",PlayerFrame,"BOTTOM",30, 30)
    CastingBarFrame:SetHeight  (14)
end

function CombatHide()
    if inCombat then
        ObjectiveTrackerFrame:SetAlpha(0.5) -- il y a des quêtes avec des icones à cliquer sur le tracker donc pas bon de le cacher
        Minimap:SetAlpha(0.5)
        --MicroButtonAndBagsBar:SetAlpha(0)
    else
        ObjectiveTrackerFrame:SetAlpha(1)
        Minimap:SetAlpha(1)
        --MicroButtonAndBagsBar:SetAlpha(1)
    end
end

function Moved()
      -- druide et shaman
    if iclass == 11 or iclass == 7 then
        local iforme = GetShapeshiftForm(flag)
        if iforme == 0 then
            -- le druide/shaman est en humanoide ; il peut en se cas être sur une monture !
            CheckMount()
        end
      else
          CheckMount()
      end
      if IsFishing then
          IsFishing = false
          MoveViewLeftStart(0.05)
          C_Timer.After(2, function() MoveViewLeftStop() end)
    end
end

function MoveCam(ref)
    local z=GetCameraZoom()
    if ref > z then
        CameraZoomOut(ref - z)
    else
        CameraZoomIn(z - ref)
    end
end

function CheckHide()
    if inCombat == false then
        C_Timer.After(TimerFade, function() HideAll() end)
    end
end

function HideAll()
    if inCombat or targeting or PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or MultiBarRight:IsMouseOver() or 
        MainMenuBar:IsMouseOver() or BuffFrame:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver()
    then 
          return 
    end
    if fade ~= 0 then
        fade=fade-0.1
    end
    --print(fade)
    FadeAll()
    if fade > 0 then
        C_Timer.After(.1, function() HideAll() end)
    end
end

function FadeAll()
    for i,v in ipairs(tableFrame) do
        v:SetAlpha(fade);
    end
end

function ShowAll()
    fade=1; 
    FadeAll();
end

function CheckMount()
    if IsMounted() then 
        if not FirstMountMove then return end
        MoveCam(MountZoom)
        FirstMountMove = false
        FirstFeetMove = true
    else 
        if not inCombat then
            if not FirstFeetMove then return end
            MoveCam (FeetZoom)
            FirstFeetMove = false
            FirstMountMove = true
        end
      end
end

------------------------------------- EVENT HANDLERS

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
        targeting=true
    else
        CheckHide(); 
        targeting=false
    end
end

function MyFunctions:PLAYER_CONTROL_LOST()
    UIParent:Hide()
    MoveViewLeftStart(0.1)
    MoveCam (MountZoom)
end

function MyFunctions:PLAYER_CONTROL_GAINED()
    UIParent:Show()
    MoveViewLeftStop()
    MoveCam (FeetZoom)
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
    fade=0; 
    FadeAll()
end

function MyFunctions:UNIT_MODEL_CHANGED()
    -- druid
    if iclass == 11 then
        local iforme = GetShapeshiftForm(flag)
        if iforme == 0 or iforme == 1 or iforme == 3 then
            FirstFeetMove = true
        end
    end
    -- shaman
    if iclass == 7 then
        local iforme = GetShapeshiftForm(flag)
        if iforme == 0 then
            FirstFeetMove = true
        end
    end 
end
