local LAM = LibAddonMenu2

GuardWarner = {}

GuardWarner.savedVariables = nil
GuardWarner.name = "GuardWarner"
GuardWarner.icon = nil

GuardWarner.defaults = {
  showHeatWarning = true,
  playHeatAlertSound = true,
  showNoHeatWarning = true,
  playNoHeatAlertSound = false
}

function GuardWarner.Initialize()
  GuardWarner.savedVariables = ZO_SavedVars:NewCharacterIdSettings("GuardWarnerSavedVariables", 1, GetWorldName(), GuardWarner.defaults)

  -- Register for events that interest us
  EVENT_MANAGER:RegisterForEvent(GuardWarner.name, EVENT_RETICLE_TARGET_CHANGED, GuardWarner.OnReticleTargetChanged)
  EVENT_MANAGER:RegisterForEvent(GuardWarner.name, EVENT_PLAYER_COMBAT_STATE, GuardWarner.OnPlayerCombatState)
  
  -- Pre-load a shield .dds icon centered just above the player's reticle and hide it.
  GuardWarner.inCombat = IsUnitInCombat("player")
  GuardWarner.icon = WINDOW_MANAGER:CreateControl("GUARD_WARNER_ICON", ZO_ReticleContainer, CT_TEXTURE)
  GuardWarner.icon:ClearAnchors()
  GuardWarner.icon:SetAnchor(CENTER, ZO_ReticleContainer, CENTER, 0, -100)
  GuardWarner.icon:SetTexture("GuardWarner\\Textures\\shield.dds")
  GuardWarner.icon:SetDimensions(128, 128)
  GuardWarner.icon:SetColor(255, 255, 255, 0.5)
  GuardWarner.icon:SetScale(0.5)
  GuardWarner.icon:SetHidden(true)

  -- Initialize the settings panel
  local panelData = {
    type = "panel",
    name = GetString(TITLE),
    displayName = "|cFFFFB0" .. GetString(TITLE) .. "|r",
    author = GetString(AUTHOR),
    version = GetString(VERSION),
    slashCommand = "/guardwarner",
    registerForRefresh = true,
    registerForDefaults = true,
    website = GetString(WEBSITE),
  }
  LAM:RegisterAddonPanel("GW", panelData)

  local optionsTable = {
    {
    type = "checkbox",
    name = GetString(HEAT_WARNING),
    tooltip = GetString(HEAT_WARNING),
    getFunc = function()
      return GuardWarner.savedVariables.showHeatWarning
    end,
    setFunc = function(state)
      GuardWarner.savedVariables.showHeatWarning = state
    end,
    default = true,
  },
  {
    type = "checkbox",
    name = GetString(HEAT_ALERT_SOUND),
    tooltip = GetString(HEAT_ALERT_SOUND),
    getFunc = function()
      return GuardWarner.savedVariables.playHeatAlertSound
    end,
    setFunc = function(state)
      GuardWarner.savedVariables.playHeatAlertSound = state
    end,
    default = true,
  },
  {
    type = "checkbox",
    name = GetString(NO_HEAT_WARNING),
    tooltip = GetString(NO_HEAT_WARNING),
    getFunc = function()
      return GuardWarner.savedVariables.showNoHeatWarning
    end,
    setFunc = function(state)
      GuardWarner.savedVariables.showNoHeatWarning = state
    end,
    default = true,
  },
  {
    type = "checkbox",
    name = GetString(NO_HEAT_ALERT_SOUND),
    tooltip = GetString(NO_HEAT_ALERT_SOUND),
    getFunc = function() return
      GuardWarner.savedVariables.playNoHeatAlertSound
    end,
    setFunc = function(state)
      GuardWarner.savedVariables.playNoHeatAlertSound = state
    end,
    default = false,
  },
}
  LAM:RegisterOptionControls("GW", optionsTable)
end

-- When the player moves their reticle over an invulnerable guard:
--   and the player has a bounty, we want a red shield to appear above the reticle and sound an alert.
--   and the player has no bounty, we want to optionally display a yellow shield above the reticle.
function GuardWarner.OnReticleTargetChanged(eventCode)
  if (IsUnitInvulnerableGuard("reticleover")) then
    if (GetBounty() > 0) then

      if (GuardWarner.savedVariables.playHeatAlertSound) then
        PlaySound(SOUNDS.JUSTICE_STATE_CHANGED)
      end

      if (GuardWarner.savedVariables.showHeatWarning) then
        GuardWarner.icon:SetColor( 255, 0, 0, .75 )
        GuardWarner.icon:SetHidden(false)
      end

    else

      if (GuardWarner.savedVariables.playNoHeatAlertSound) then
        PlaySound(SOUNDS.JUSTICE_STATE_CHANGED)
      end

      if (GuardWarner.savedVariables.showNoHeatWarning) then
        GuardWarner.icon:SetColor( 255, 255, 0, .5 )
        GuardWarner.icon:SetHidden(false)
      end

    end
  else
    GuardWarner.icon:SetHidden(true)
  end
end

-- Check to see if the player has entered combat with an invulnerable guard and ensure that the shield is red.
function GuardWarner.OnPlayerCombatState(eventCode, inCombat)
  if (inCombat and IsUnitInvulnerableGuard("reticleover")) then
    GuardWarner.icon:SetColor( 255, 0, 0, .75 )
    GuardWarner.icon:SetHidden(not GuardWarner.savedVariables.showHeatWarning)
  end
end

-- Callback to load the GuardWarner add-on.
function GuardWarner.OnLoaded(event, addOnName)
  if addOnName == GuardWarner.name then
    GuardWarner.Initialize()
    EVENT_MANAGER:UnregisterForEvent(GuardWarner.name, EVENT_ADD_ON_LOADED) 
  end
end

-- Register for load
EVENT_MANAGER:RegisterForEvent(GuardWarner.name, EVENT_ADD_ON_LOADED, GuardWarner.OnLoaded)