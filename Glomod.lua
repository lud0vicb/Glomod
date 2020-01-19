MyFunctions = {}
tableFrame = { --global bcause used in different functions
    PlayerFrame, TargetFrame, MainMenuBar, MultiBarRight, BuffFrame, MicroButtonAndBagsBar, ChatFrame1, ChatFrame2,
} 

function GlomodOnload(self) 
    isZoomOn = true
    isInCombat = false
    isTargeting = false
    isFishing = false
    isFirstFeetMove = true
    isFirstMountMove = true

    intFade = 0
    intMountZoom = 15
    intFeetZoom = 5
    intFishZoom = 1.5
    intCombatZoom = 10

    secTimerFade = 3
    
    FRClass, ENClass, iclass = UnitClass("player")
    if iclass == 11 or iclass == 7 then
        iforme = GetShapeshiftForm(flag)
        tableForm = {[11]=3, [7]=1}
    end
    
    for i,v in ipairs(tableFrame) do
        v:SetScript('OnEnter', function() ShowAll() end)
        v:SetScript('OnLeave', function() CheckHide() end)
    end

    local tableEvent = {
      "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED",
      "UNIT_SPELLCAST_SUCCEEDED", "PLAYER_ENTERING_WORLD", 
      "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST", "UNIT_SPELLCAST_SUCCEEDED",
      "PLAYER_STARTED_MOVING", "PLAYER_STOPPED_MOVING", "UNIT_SPELLCAST_START",
      "GROUP_FORMED", "ADDON_LOADED", "PLAYER_LOGOUT", "UPDATE_SHAPESHIFT_FORM"
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
    
    FadeAll()
    
    local tableShowOnMouse = {
    }
    for i,v in ipairs(tableShowOnMouse) do
        ShowOnMouse(v)
    end
end

function ShowOnMouse(frame)
    frame:SetScript('OnEnter', function() frame:SetAlpha(1) end)
    frame:SetScript('OnLeave', function() frame:SetAlpha(0) end)
    C_Timer.After(6, function() frame:SetAlpha(0) end)
end

function MoveCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM",30, 30)
    CastingBarFrame:SetHeight(14)
end

function CombatHide()
    if isInCombat then
        ObjectiveTrackerFrame:SetAlpha(0.5) -- il y a des quêtes avec des icones à cliquer sur le tracker donc pas bon de le cacher
        Minimap:SetAlpha(0.5)
        --MicroButtonAndBagsBar:SetAlpha(0)
    else
        ObjectiveTrackerFrame:SetAlpha(1)
        Minimap:SetAlpha(1)
        --MicroButtonAndBagsBar:SetAlpha(1)
    end
end

function CheckHide()
    if isInCombat == false then
        C_Timer.After(secTimerFade, function() HideAll() end)
    end
end

function HideAll()
    if isInCombat or isTargeting or PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or MultiBarRight:IsMouseOver()
        or MainMenuBar:IsMouseOver() or BuffFrame:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver()
        or ChatFrame1:IsMouseOver()
        or ChatFrame2:IsMouseOver()
    then 
        return 
    end
    if intFade ~= 0 then
        intFade = intFade-0.1
    end
    --print(intFade)
    FadeAll()
    if intFade > 0 then
        C_Timer.After(.1, function() HideAll() end)
    end
end

function FadeAll()
    for i,v in ipairs(tableFrame) do
        v:SetAlpha(intFade);
    end
end

function ShowAll()
    intFade = 1; 
    FadeAll();
end
