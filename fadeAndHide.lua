function hideAll()
    if  isInCombat or isTargeting or
        PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or
        MultiBarRight:IsMouseOver() or MainMenuBarArtFrame:IsMouseOver() or
        MainMenuBar:IsMouseOver() or BuffFrame:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver() or
        ChatFrame1:IsMouseOver() or ChatFrame2:IsMouseOver()
    then
        intFade = 1
        isFading = false
        return
    end
    if intFade == 1 then
        -- first run
        isFading = true
        if isDebuging then
            printDebug("Start fading")
        end
        intFade = intFade-0.1
        fadeAll()
        C_Timer.After(.1, function() hideAll() end)
    else
        if not isFading then
            intFade = 1
        else
            if intFade > 0 then
                intFade = intFade - 0.1
                fadeAll()
                C_Timer.After(.1, function() hideAll() end)
            else
                isFading = false
            end
        end
    end
end

function fadeAll()
    for i,v in ipairs(tableFrameShowHide) do
        v:SetAlpha(intFade);
    end
end

function showAll()
    if isFadeOn then
        intFade = 1
        isFading = false
        fadeAll()
    end
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
    if isFadeOn and not isInCombat then
        C_Timer.After(secTimerFade, function() hideAll() end)
    end
end

function showOnMouse(frame)
    frame:SetScript('OnEnter', function() frame:SetAlpha(1) end)
    frame:SetScript('OnLeave', function() frame:SetAlpha(0) end)
    C_Timer.After(3, function() frame:SetAlpha(0) end)
end
