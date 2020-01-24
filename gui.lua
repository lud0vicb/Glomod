function debugFrameOnload(self)
    debugFrame:Show()
    isDebuging = true
    self.zoomText = debugFrame:CreateFontString(nil, "OVERLAY")
    self.zoomActual = debugFrame:CreateFontString(nil, "OVERLAY")
    self.zoomText:SetPoint("BOTTOMLEFT", 22, 83)
    self.zoomText:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.zoomText:SetText("zooms")
    self.zoomActual:SetPoint("BOTTOMLEFT", 172, 83)
    self.zoomActual:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    self.zoomActual:SetText("0")
    self.debugText = debugFrame:CreateFontString(nil, "OVERLAY")
    self.debugText:SetPoint("TOPLEFT", debugFrame, "TOPLEFT", 22, -80)
    self.debugText:SetWidth(300)
    self.debugText:SetHeight(320)
    self.debugText:SetJustifyH("LEFT")
    self.debugText:SetJustifyV("TOP")
    self.debugText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    self.debugText:SetText("this is it\noh yeah")
end
function debugButtonOnload(self)
    self:SetText("debug on")
end
function debugButtonClick(self)
    if debugFrame:IsVisible() then
        self:SetText("debug on")
        isDebuging = false
        debugFrame:Hide()
    else
        self:SetText("debug off")
        isDebuging = true
        debugFrame:Show()
    end
end
function debugFrameOnclose(self)
    debugButton:SetText("debug on")
    isDebuging = false
    debugFrame:Hide()
end
