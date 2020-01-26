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
    fadeAll()
    if intFade > 0 then
        C_Timer.After(.1, function() hideAll() end)
    end
end

function fadeAll()
    for i,v in ipairs(tableFrameShowHide) do
        v:SetAlpha(intFade);
    end
end

function showAll()
    intFade = 1;
    fadeAll();
end
function combatHide()
    if isInCombat then
        ObjectiveTrackerFrame:SetAlpha(0.5) -- il y a des quêtes avec des icones à cliquer sur le tracker donc pas bon de le cacher
        Minimap:SetAlpha(0.5)
    else
        ObjectiveTrackerFrame:SetAlpha(1)
        Minimap:SetAlpha(1)
    end
end

function checkHide()
    if isInCombat == false then
        C_Timer.After(secTimerFade, function() hideAll() end)
    end
end

function showOnMouse(frame)
    frame:SetScript('OnEnter', function() frame:SetAlpha(1) end)
    frame:SetScript('OnLeave', function() frame:SetAlpha(0) end)
    C_Timer.After(6, function() frame:SetAlpha(0) end)
end
