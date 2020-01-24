function printDebug(log)
    tableDebugLine[intDebugLine] = log
    if intDebugLine == 25 then
        intDebugLine = 1
    else
        intDebugLine = intDebugLine + 1
    end
    tableDebugLine[intDebugLine] = ""
    debugFrame.debugText:SetText(tableDebugLine)
end
