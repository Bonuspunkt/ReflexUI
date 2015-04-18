local ui = require "../ui"
local nvg = require "../nvg"
local userData = require "../userData"
local funcArray = require "../lib/funcArray"

local properties = {
  "world",
  "clientGameState",
  "playerIndexCameraAttachedTo",
  "playerIndexLocalPlayer",
  "showScores",
  "players",
  "pickupTimers"
}

local name = ""
local config
local snapshotNames
local snapshotState = {}

local function initOrFixConfig()
  config = config or userData.load() or {}
  if not config.active then config.active = "" end
  if not config.store then config.store = {} end
  if not snapshotNames then
    _G.consolePrint("rebuild")
    snapshotNames = { "" }
    for key in pairs(config.store) do
      _G.consolePrint("Key: " .. key)
      snapshotNames[#snapshotNames+1] = key
    end

  end
end

_G.Emulator = {
  canPosition = false,

  draw = function()
    initOrFixConfig()

    if not config.active or config.active == "" then return end

    nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle)
    nvg.text(0,0, "EMULATING...");

    funcArray(properties).forEach(function(property)
      _G[property] = config.store[config.active][property]
    end)

  end,

  drawOptions = function(_, x, y)
    initOrFixConfig()

    ui.label("Snapshot", x, y)
    name = ui.editBox(name, x + 120, y, 380)

    local snapshotClicked = ui.button("make snapshot", nil,
      x, y + 40, 500, 40, nil, nil, config.active == "")

    if name ~= "" and snapshotClicked then
      local data = {}
      funcArray(properties).forEach(function(property) data[property] = _G[property] end)

      config.store[name] = data

      -- trigger rebuild
      snapshotNames = nil;
    end

    ui.label("Emulate", x, y + 120)
    config.active = ui.comboBox(snapshotNames, config.active, x + 120, y + 120, 300, snapshotState)

    userData.save(config)

  end

}

_G.registerWidget('Emulator')
