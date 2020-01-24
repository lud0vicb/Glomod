function DebugFrameOnload(self)
    print('yo')
end
function debugButtonOnload(self)
    self:SetText("debug on")
end
function debugButtonClick(self)
    if isDebuging == true then
        self:SetText("debug on")
        isDebuging = false
        DebugFrame:Hide()
    else
        self:SetText("debug off")
        isDebuging = true
        DebugFrame:Show()
    end
end
