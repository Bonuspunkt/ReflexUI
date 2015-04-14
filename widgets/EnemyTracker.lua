--require "base/internal/ui/reflexcore"
local reflexMath = require "base/internal/ui/bonus/lib/reflexMath"

local otherPlayer;
local oldMe;
local oldTimers = _G.pickupTimers

local function reset()
  otherPlayer = {
    health = 100,
    armor = 0,
    armorProtection = 0
  }
  oldMe = otherPlayer
  oldTimers = _G.pickupTimers

  _G.consolePrint('reset')
end

_G.EnemyTracker =
{
  draw = function()
    if _G.world.gameTime == 0 then
      -- TODO: Beter check - also resets at overtime
      reset()
      return
    end

    local me = _G.getPlayer();

    if not oldTimers then
      reset()
    end

    for i, timer in pairs(_G.pickupTimers) do

      if (timer.timeUntilRespawn > oldTimers[i].timeUntilRespawn) then
        _G.consolePrint('somebody pick something up')

        local wasOtherPlayer = true

        if timer.type < 50 then
          -- did i pick the health up?
          if me.health > oldMe.health then
            wasOtherPlayer = false
          end
        elseif timer.type >= 50 then
          -- did i pick the armor up?
          if me.armor > oldMe.armor then
            wasOtherPlayer = false
          end
        end

        if wasOtherPlayer then
          -- TODO: if newArmorProt < oldArmorProt -- calulate damage taken and recalc health

          local hadMega = otherPlayer.hasMega
          otherPlayer = reflexMath.pickup(otherPlayer, timer.type)
          otherPlayer.hasMega = hadMega
        end
      end

      -- TODO: Health decay - save healthPickupTime

      -- TODO: enemyMega wearOff < 100sec --> calculate lost armor

      -- TODO: if my fragCount goes up, reset enemy player

      -- TODO: abuse crosshair to inject dmg gives / minor pickups (health/shards)
      -- see widgetTimer for reference
        -- NOTE: if the nmy player picked up 50/25hps his health was below 100 / recalc armor
    end

    _G.nvgFontSize(50)
    _G.nvgText(0,0, otherPlayer.health)
    _G.nvgText(0,40, otherPlayer.armor)
    _G.nvgText(0,80, reflexMath.trueStack(otherPlayer))

    oldTimers = _G.pickupTimers
  end
};
_G.registerWidget("EnemyTracker");
