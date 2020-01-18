function playSnd (msg)
    sndId = tonumber(msg)
    PlaySound(sndId)
end
SLASH_PL1 = '/pl'
SLASH_PL2 = '/play'
SlashCmdList["PL"] = playSnd


