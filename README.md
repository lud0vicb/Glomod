# Glomod

## Gestion frame

On les gère plutôt dans le fichier xml. Mais on peut le faire des le code :

```
local GloFrame = CreateFrame("FRAME", "GlomodFrame");
GloFrame:SetScript("OnEvent", GlomodEventHandler);
```

Utiliser la commande /fstack en jeu pour identifier les élements de l'interface wow
  
## Bouger une frame déjà définie

on ne définit pas le xml puisqu'il existe déjà, donc on appelle des méthodes lua

```
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
```

## Gestion souris

```
PlayerFrame:EnableMouse();TargetFrame:EnableMouse();MainMenuBar:EnableMouse(); 

-- GERER LE MOUSE OVER
frame:EnableMouse()
frame:SetScript('OnEnter', function() highlightStuff end)
frame:SetScript('OnLeave', function() unHighightStuff end)

```

## Masquer une frame

```
-- MASQUER UN ELEMENTE
PlayerFrame:SetAlpha(0);
-- autres syntaxes ; à noter qu'une frame cachée ne peut être survolée à la souris !
HideUIPanel(PlayerFrame);
PlayerFrame:Hide();
```