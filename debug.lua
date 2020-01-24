function printDebug(log)
    log = tostring(intDebugLine) .. "- " .. log
    tableDebugLine[intDebugLine] = log
    if intDebugLine == intMaxDebug then
        intDebugLine = 1
    else
        intDebugLine = intDebugLine + 1
    end
    tableDebugLine[intDebugLine] = ""
    debugFrame.debugText:SetText(table.concat(tableDebugLine, "\n"))
end
