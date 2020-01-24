MyFunctions = {}
function GlomodOnload(self)
    isZoomOn = true
    isInCombat = false
    isTargeting = false
    isFishing = false
    isFirstFeetMove = true
    isFirstMountMove = true
    isDebuging = false

    intFade = 0
    intMountZoom = 15
    intFeetZoom = 5
    intFishZoom = 1.5
    intCombatZoom = 10
    intVignetteSave = 1
    intDebugLine = 1
    intMaxDebug = 26

    secTimerFade = 3

    FRClass, ENClass, iclass = UnitClass("player")
    if iclass == 11 or iclass == 7 then
        iforme = GetShapeshiftForm(flag)
        tableForm = {[11]=3, [7]=1}
    end

    tableFrame = {
        PlayerFrame, TargetFrame, MainMenuBar, MultiBarRight, BuffFrame,
        MicroButtonAndBagsBar, ChatFrame1, ChatFrame2, MainMenuBarArtFrame,
    }
    for i,v in ipairs(tableFrame) do
        v:SetScript('OnEnter', function() showAll() end)
        v:SetScript('OnLeave', function() checkHide() end)
    end

    local tableEvent = {
      "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_TARGET_CHANGED",
      "UNIT_SPELLCAST_SUCCEEDED", "PLAYER_ENTERING_WORLD", "VIGNETTE_MINIMAP_UPDATED",
      "PLAYER_CONTROL_GAINED", "PLAYER_CONTROL_LOST",
      "PLAYER_STARTED_MOVING", "PLAYER_STOPPED_MOVING",
      "GROUP_FORMED", "ADDON_LOADED", "PLAYER_LOGOUT", "UPDATE_SHAPESHIFT_FORM",
      "UNIT_ENTERING_VEHICLE", "UNIT_EXITING_VEHICLE",
      "GOSSIP_SHOW", "MERCHANT_SHOW", "MERCHANT_UPDATE",
      "QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_GREETING",
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

    fadeAll()

    local tableShowOnMouse = {
    }
    for i,v in ipairs(tableShowOnMouse) do
        ShowOnMouse(v)
    end
    tableVignetteSave = {}
    for ind=1, 12, 1 do
        tableVignetteSave[ind] = ""
    end
    tableDebugLine = {}
    for ind=1, intMaxDebug, 1 do
        tableDebugLine[ind] = ""
    end
end

function showOnMouse(frame)
    frame:SetScript('OnEnter', function() frame:SetAlpha(1) end)
    frame:SetScript('OnLeave', function() frame:SetAlpha(0) end)
    C_Timer.After(6, function() frame:SetAlpha(0) end)
end

function moveCastBar()
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("TOP", PlayerFrame, "BOTTOM",30, 30)
    CastingBarFrame:SetHeight(14)
end

function combatHide()
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

function checkHide()
    if isInCombat == false then
        C_Timer.After(secTimerFade, function() hideAll() end)
    end
end

function hideAll()
    if  isInCombat or isTargeting or
        PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or
        MultiBarRight:IsMouseOver() or MainMenuBarArtFrame:IsMouseOver() or
        MainMenuBar:IsMouseOver() or BuffFrame:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver() or
        ChatFrame1:IsMouseOver() or ChatFrame2:IsMouseOver()
    then
        return
    end
    if isDebuging and intFade == 1 then
        printDebug("Start fading")
    end
    if intFade ~= 0 then
        intFade = intFade-0.1
    end
    --print(intFade)
    fadeAll()
    if intFade > 0 then
        C_Timer.After(.1, function() hideAll() end)
    end
end

function fadeAll()
    for i,v in ipairs(tableFrame) do
        v:SetAlpha(intFade);
    end
end

function showAll()
    intFade = 1;
    fadeAll();
end
function moveFrame(fr)
    fr:ClearAllPoints()
    fr:SetPoint("LEFT", "UIParent", "CENTER", 100, 0)
    if isDebuging then
        local log = string.format("Move %s", fr:GetName())
        printDebug(log)
    end
end
