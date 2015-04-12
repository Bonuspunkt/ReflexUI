local const = require "base/internal/ui/bonus/const"

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end


-- calculates the amount of damage to kill the player
local trueStack = function(player)
  return math.min(
    player.armor,
    player.health * (player.armorProtection + 1)
  ) + player.health;
end

-- checks if the player can pickup an item
local canPickup = function(player, itemType)
  if itemType == const.pickupType.health100 then

    return player.health < 200

  elseif itemType == const.pickupType.armor150 then

    return player.armorProtection < 2
        or player.armor < 200

  elseif itemType == const.pickupType.armor100 then

    return player.armorProtection == 2 and player.armor < 133
        or player.armorProtection ~= 2 and player.armor < 150

  elseif itemType == const.pickupType.armor50 then

    return player.armorProtection == 2 and player.armor < 66
        or player.armorProtection == 1 and player.armor < 75
        or player.armorProtection == 0 and player.armor < 100

  elseif itemType == const.pickupType.powerupCarnage then

      return player.carnageTimer == 0

  end

  return false
end

-- calculates the player stats after an item pickup
local pickup = function(player, itemType)
  if not canPickup(player, itemType) then
    return {
      armorProtection = player.armorProtection,
      armor = player.armor,
      health = player.health
    }
  elseif itemType == const.pickupType.health100 then
    return {
      armorProtection = player.armorProtection,
      armor = player.armor,
      health = math.min(200, player.health + 100)
    }
  elseif itemType == const.pickupType.armor150 then
    return {
      armorProtection = 2,
      armor = math.min(200, player.armor + 150),
      health = player.health
    }
  elseif itemType == const.pickupType.armor100 then
    return {
      armorProtection = 1,
      armor = math.min(150, player.armor + 100),
      health = player.health
    }
  elseif itemType == const.pickupType.armor50 then
    return {
      armorProtection = 0,
      armor = math.min(100, player.armor + 50),
      health = player.health
    }
  end
end

-- priorizes which item will be most useful for the players stack
local priorize = function(player, itemType)
  if itemType == const.pickupType.powerupCarnage then
    return 401;
  end
  return trueStack(pickup(player, itemType))
end

-- calculates the new player stats after receiving damage
local receiveDamage = function(player, damage)
  local armorDamage = damage * (1 - (1/(player.armorProtection + 2)));
  local armorAbsorbs = round(math.min(player.armor, armorDamage));

  return {
    armorProtection = player.armorProtection,
    armor = player.armor - armorAbsorbs,
    health = player.health - (damage - armorAbsorbs)
  }
end

return {
  trueStack = trueStack,
  canPickup = canPickup,
  pickup = pickup,
  priorize = priorize,
  receiveDamage = receiveDamage
}
