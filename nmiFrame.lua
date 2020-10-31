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
  self.emote1 = createButton(self, 24, -54, emote1, "")
  self.emote1:SetNormalTexture("Interface\\ICONS\\INV_Glove_Leather_RaidMonk_M_01")
--  self.emote1:SetPushedTexture("Interface\\ICONS\\Ability_Warrior_BattleShout")
  self.emote1:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote2 = createButton(self, 66, -54, emote2, "")
  self.emote2:SetNormalTexture("Interface\\ICONS\\Achievement_WorldEvent_Brewmaster")
  self.emote2:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote3 = createButton(self, 108, -54, emote3, "")
  self.emote3:SetNormalTexture("Interface\\ICONS\\INV_Gauntlets_40")
  self.emote3:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote4 = createButton(self, 150, -54, emote4, "")
  self.emote4:SetNormalTexture("Interface\\ICONS\\INV_MISC_BEER_02")
  self.emote4:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote5 = createButton(self, 24, -94, emote5, "")
  self.emote5:SetNormalTexture("Interface\\ICONS\\INV_Misc_Bomb_04")
  self.emote5:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote6 = createButton(self, 66, -94, emote6, "")
  self.emote6:SetNormalTexture("Interface\\ICONS\\Spell_Priest_Pontifex")
  self.emote6:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote7 = createButton(self, 108, -94, emote7, "")
  self.emote7:SetNormalTexture("Interface\\ICONS\\Spell_Priest_VowofUnity")
  self.emote7:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
  self.emote8 = createButton(self, 150, -94, emote8, "")
  self.emote8:SetNormalTexture("Interface\\ICONS\\Ability_DemonHunter_EyeBeam")
  self.emote8:SetHighlightTexture("Interface\\Buttons\\LegendaryOrange64","MOD")
end

function nmiFrameOnopen(self)
  nmiFrame:Show()
end

function emote1()
  DoEmote("HELLO")
end
function emote2()
  DoEmote("LAUGH")
end
function emote3()
  DoEmote("BYE")
end
function emote4()
  DoEmote("DRINK")
end
function emote5()
  DoEmote("KISS")
end
function emote6()
  DoEmote("THANK")
end
function emote7()
  DoEmote("APPLAUD")
end
function emote8()
  DoEmote("CRY")
end
