function GlomodOnload(self) 
  inCombat = false
  fade=0
  targeting=false
  FadeAll()
  MountZoom=15
  FeetZoom=5
  FishZoom=2
  IsFishing = false
  
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
  self:RegisterEvent("PLAYER_STARTED_MOVING");
  --self:RegisterEvent("PLAYER_STOPPED_MOVING");
  
  PlayerFrame:SetScript('OnEnter', function() ShowAll() end)
  PlayerFrame:SetScript('OnLeave', function() CheckHide() end)
  TargetFrame:SetScript('OnEnter', function() ShowAll() end)
  TargetFrame:SetScript('OnLeave', function() CheckHide() end)
  MainMenuBar:SetScript('OnEnter', function() ShowAll() end)
  MainMenuBar:SetScript('OnLeave', function() CheckHide() end)
  MultiBarRight:SetScript('OnEnter', function() ShowAll() end)
  MultiBarRight:SetScript('OnLeave', function() CheckHide() end)
  MicroButtonAndBagsBar:SetScript('OnEnter', function() ShowAll() end)
  MicroButtonAndBagsBar:SetScript('OnLeave', function() CheckHide() end)
  ChatFrame1:SetScript('OnEnter', function() ShowAll() end)
  ChatFrame1:SetScript('OnLeave', function() CheckHide() end)
  MainMenuBarArtFrame.LeftEndCap:Hide()
  MainMenuBarArtFrame.RightEndCap:Hide()
  MainMenuBarArtFrameBackground:Hide()
end

function MoveCam(ref)
  local z=GetCameraZoom()
  if ref > z then
    CameraZoomOut(ref - z)
  else
    CameraZoomIn(z - ref)
  end
end

function CheckHide()
    if inCombat == false then
      C_Timer.After(3, function() HideAll() end)
    end
end

function HideAll()
  if inCombat or targeting or PlayerFrame:IsMouseOver() or TargetFrame:IsMouseOver() or MultiBarRight:IsMouseOver() or 
    MainMenuBar:IsMouseOver() or MicroButtonAndBagsBar:IsMouseOver() or ChatFrame1:IsMouseOver() then 
      return 
  end
  fade=fade-0.1
  --print(fade)
  FadeAll()
  if fade >= 0 then
    C_Timer.After(.1, function() HideAll() end)
  end
end

function FadeAll()
  PlayerFrame:SetAlpha(fade);
  TargetFrame:SetAlpha(fade)
  MainMenuBar:SetAlpha(fade)
  MicroButtonAndBagsBar:SetAlpha(fade)
  ChatFrame1:SetAlpha(fade)
  MultiBarRight:SetAlpha(fade)
end

function ShowAll()
  fade=1; 
  FadeAll();
end

function CheckMount()
  if IsMounted() then 
    MoveCam(MountZoom)
  else 
    if inCombat == false then
      MoveCam (FeetZoom)
    end
  end
end

function GlomodEventHandler(self, event, arg1, arg2, arg3)
  --print("EVENT TRIGGERED : " .. event);
  
  ---- ENTREE EN COMBAT
  if event == 'PLAYER_REGEN_DISABLED' then 
    inCombat = true; 
    ShowAll()
  
  ---- FIN DE COMBAT
  elseif event == 'PLAYER_REGEN_ENABLED' then
    inCombat = false; 
    CheckHide()
  
  ---- DEBUT DEPLACEMENT MANUEL
  elseif event == 'PLAYER_STARTED_MOVING' then
    -- la caméra de druide est gérée direct via les transformations
    if iclass ~= 11 then
      CheckMount()
    end
    IsFishing = false
  
  ---- CHANGEMENT DE CIBLE (ou perte de cible)
  elseif event == 'PLAYER_TARGET_CHANGED' then
    if UnitExists("target") then
        ShowAll(); 
        targeting=true
    else
        CheckHide(); 
        targeting=false
    end
  
  ---- AVATAR HORS DE CONTROL (inclut le taxi)
  elseif event == 'PLAYER_CONTROL_LOST' then
    UIParent:Hide()
    MoveViewLeftStart(0.1)
    SetView(2)
  
  ---- AVATAR DE NOUVEAU SOUS CONTROL
  elseif event == 'PLAYER_CONTROL_GAINED' then
    UIParent:Show()
    MoveViewLeftStop()
    SetView(1)
  
  ---- UN SORT EST LANCE
  elseif event == 'UNIT_SPELLCAST_SUCCEEDED' then
    --print ('SPELL '..arg3)
    -- PECHE A LA LIGNE
    if arg3 == 131476 then
      if not IsFishing then
        MoveViewRightStart(0.05)
        C_Timer.After(2, function() MoveViewRightStop() end)
        IsFishing = true
        MoveCam (FishZoom)
      end
    end
  
  ---- ENTREE DANS LE JEU (inclut après un chargement)
  elseif event == 'PLAYER_ENTERING_WORLD' then
    fade=0; 
    FadeAll()
  
  ---- AVATAR CHANGE DE MODELE 3D (inclut les transformations)
  elseif event == 'UNIT_MODEL_CHANGED' then
    -- druide
    if iclass == 11 then
      local iforme = GetShapeshiftForm(flag)
      --print('CHANGEFORM'.. iforme)
      if iforme == 3 or iforme == 4 then
        MoveCam(MountZoom)
      else
        MoveCam(FeetZoom)
      end
    end
    -- shaman
    if iclass == 7 then
      local iforme = GetShapeshiftForm(flag)
      --print('CHANGEFORM'.. iforme)
      if iforme == 1 then
        MoveCam(MountZoom)
      else
        MoveCam(FeetZoom)
      end
    end
  end
end

