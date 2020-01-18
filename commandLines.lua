function playSnd (msg)
    sndId = tonumber(msg)
    PlaySound(sndId)
end

SLASH_PL1 = '/pl'
SLASH_PL2 = '/play'
SlashCmdList["PL"] = playSnd

function switchZoomFunc(msg)
    if zoomFunc == true then
        zoomFunc = false
    else
        zoomFunc = true
    end
end

SLASH_ZOOM1 = '/zoom'
SLASH_ZOOM2 = '/z'
SlashCmdList["ZOOM"] = switchZoomFunc

