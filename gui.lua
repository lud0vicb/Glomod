function DebugFrameOnload(self)
    print('DEBUG')
    DebugFrame:Show()
    self.zoomText = DebugFrame:CreateFontString(nil, "OVERLAY")
    self.zoomText:SetPoint("BOTTOMLEFT", 22, 83)
    self.zoomText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.zoomText:SetText("zooms")
end
function debugButtonOnload(self)
    self:SetText("debug on")
end
function debugButtonClick(self)
    if DebugFrame:IsVisible() then
        self:SetText("debug on")
        isDebuging = false
        DebugFrame:Hide()
    else
        self:SetText("debug off")
        isDebuging = true
        DebugFrame:Show()
    end
end
function DebugFrameOnclose(self)
    debugButton:SetText("debug on")
    isDebuging = false
end
