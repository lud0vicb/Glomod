function playSnd (msg)
    sndId = tonumber(msg)
    PlaySound(sndId)
end

SLASH_PL1 = '/pl'
SLASH_PL2 = '/play'
SlashCmdList["PL"] = playSnd

function switchZoomFunc(args)
    local cmd = string.sub(args, 1, 1)
    if cmd == "0" then
        isZoomOn = false
        print ('GLO ZOOM disabled')
    elseif cmd == '1' then
        isZoomOn = true
        local tableArgs = {}
        local j = 0
        for i in string.gmatch(args, "%w+") do
            tableArgs[j] = i
            j = j +1
        end
        intFeetZoom = tonumber(tableArgs[1])
        intMountZoom = tonumber(tableArgs[2])
        print ('GLO ZOOM CHANGE ' .. tableArgs[1] .. ' ' .. tableArgs[2])
    end
end
SLASH_ZOOM1 = '/zoom'
SLASH_ZOOM2 = '/z'
SlashCmdList["ZOOM"] = switchZoomFunc

function printZoom(msg)
    print('GLOZOOM ' .. tostring(isZoomOn) .. ' ' .. tostring(intFeetZoom) .. ' ' .. tostring(intMountZoom))
end
SLASH_PZOOM1 = '/pzoom'
SLASH_PZOOM2 = '/pz'
SlashCmdList["PZOOM"] = printZoom
