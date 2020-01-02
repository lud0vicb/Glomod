
function GlomodOnload(self) 
  inCombat = false
  fade=0
  targeting=false
  FadeAll()
  FRClass, ENClass, iclass = UnitClass("player")
  self:RegisterEvent("PLAYER_REGEN_DISABLED")
  self:RegisterEvent("PLAYER_REGEN_ENABLED")
  self:RegisterEvent("PLAYER_TARGET_CHANGED")
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  self:RegisterEvent("PLAYER_ENTERING_WORLD");
  self:RegisterEvent("UNIT_MODEL_CHANGED");
  self:RegisterEvent("PLAYER_CONTROL_GAINED");  
  self:RegisterEvent("PLAYER_CONTROL_LOST");  
  self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
  PlayerFrame:SetScript('OnEnter', function() ShowAll() end)
  PlayerFrame:SetScript('OnLeave', function() CheckHide() end)
  TargetFrame:SetScript('OnEnter', function() ShowAll() end)
  TargetFrame:SetScript('OnLeave', function() CheckHide() end)
  MainMenuBar:SetScript('OnEnter', function() ShowAll() end)
  MainMenuBar:SetScript('OnLeave', function() CheckHide() end)
  MicroButtonAndBagsBar:SetScript('OnEnter', function() ShowAll() end)
  MicroButtonAndBagsBar:SetScript('OnLeave', function() CheckHide() end)
  ChatFrame1:SetScript('OnEnter', function() ShowAll() end)
  ChatFrame1:SetScript('OnLeave', function() CheckHide() end)
  MainMenuBarArtFrame.LeftEndCap:Hide()
  MainMenuBarArtFrame.RightEndCap:Hide()
end

function CheckHide()
    if inCombat == false then C_Timer.After(3, function() HideAll() end) end
end

function HideAll()
  if inCombat or targeting or PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or
    MainMenuBar:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver() or ChatFrame1:IsMouseOver() then 
        return 
  end
  fade=fade-0.1
  --print(fade)
  FadeAll()
  if fade >= 0 then C_Timer.After(.1, function() HideAll() end) end
end

function FadeAll()
  PlayerFrame:SetAlpha(fade); 
  TargetFrame:SetAlpha(fade);
  MainMenuBar:SetAlpha(fade);
  MicroButtonAndBagsBar:SetAlpha(fade); 
  ChatFrame1:SetAlpha(fade);
end

function ShowAll()
  fade=1; 
  FadeAll();
end

function CheckMount()
    if IsMounted() then 
        SetView(2) 
    else 
        if inCombat == false then SetView(1) end
        --SetView(1)
    end
end

function GlomodEventHandler(self, event, arg1, arg2, arg3)
  --print("EVENT TRIGGERED : " .. event);
  -- utiliser la commande /fstack en jeu pour identifier les élements de l'interface wow
  if event == 'PLAYER_REGEN_DISABLED' then 
    inCombat = true; 
    ShowAll()
  elseif event == 'PLAYER_REGEN_ENABLED' then
    inCombat = false; 
    CheckHide()
  elseif event == 'UNIT_SPELLCAST_SUCCEEDED' then
    print ('SPELL'..arg1..' '..arg3); 
    C_Timer.After(1, function() CheckMount() end)
  elseif event == 'PLAYER_TARGET_CHANGED' then
    if UnitExists("target") then
      ShowAll(); 
      targeting=true
    else
      CheckHide(); 
      targeting=false
    end
  elseif event == 'PLAYER_CONTROL_LOST' then
    UIParent:Hide()
    MoveViewLeftStart(0.1)
    SetView(2)
  elseif event == 'PLAYER_CONTROL_GAINED' then
    UIParent:Show()
    MoveViewLeftStop()
    SetView(1)
  elseif event == 'PLAYER_ENTERING_WORLD' then
    fade=0; 
    FadeAll()
  elseif event == 'UNIT_MODEL_CHANGED' then
    -- druide
    if iclass == 11 then
        local iforme = GetShapeshiftForm(flag)
        print('CHANGEFORM'.. iforme)
        if iforme == 3 or iforme == 4 then SetView(2) else SetView(1) end
    end
    -- shaman
    if iclass == 7 then
        local iforme = GetShapeshiftForm(flag)
        print('CHANGEFORM'.. iforme)
        if iforme == 1 then SetView(2) else SetView(1) end
    end
  end
end

