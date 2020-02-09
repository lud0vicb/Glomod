function playSnd (msg)
    sndId = tonumber(msg)
    PlaySound(sndId)
end
SLASH_PL1 = '/pl'
SLASH_PL2 = '/play'
SlashCmdList["PL"] = playSnd

function showDebug()
    if debugFrame:IsVisible() then
        debugFrame:Hide()
    else
        debugFrame:Show()
    end
end
SLASH_DEBUG1 = '/debug'
SlashCmdList["DEBUG"] = showDebug
