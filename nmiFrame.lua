function nmiFrameOnclose(self)
    nmiFrame:Hide()
end

function nmiFrameOnload(self)
  -- fenêtre elle même
  self:SetMovable(true)
  self:EnableMouse(true)
  self:RegisterForDrag("LeftButton")
  self:SetScript("OnDragStart", self.StartMoving)
  self:SetScript("OnDragStop", self.StopMovingOrSizing)
  -- les boutons
  self.emote1 = createButton(self, 25, -55, emote1, "")
  self.emote1:SetNormalTexture("Interface\\CHARACTERFRAME\\TemporaryPortrait-Male-NightElf")
  self.emote1:SetPushedTexture("Interface\\CHARACTERFRAME\\TemporaryPortrait-Male-NightElf")
  self.emote1:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")


end

function nmiFrameOnopen(self)
  nmiFrame:Show()
end

function emote1()
  DoEmote("HELLO")
end
