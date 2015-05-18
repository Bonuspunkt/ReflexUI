require "base/internal/ui/reflexcore"
local funcArray = require "base/internal/ui/bonus/lib/funcArray"
local icons = require "base/internal/ui/bonus/lib/icons"
local nvg = require "base/internal/ui/bonus/nvg"
local const = require "base/internal/ui/bonus/const"

_G.bonusTeamInfo =
{
  draw = function()

  -- Early out if HUD should not be shown.
  if not _G.shouldShowHUD() then return end;

  -- Early out if we are not in (A)TDM
  local gameMode = _G.gamemodes[_G.world.gameModeIndex].shortName;
  if gameMode ~= 'tdm' and gameMode ~= 'atdm' then return end;

  -- Find player
  local player = _G.getPlayer();

  nvg.fontFace(const.font.text);
  nvg.fontSize(const.font.sizeDefault);

  funcArray(_G.players)
    .filter(function(p)
      return p.state == const.playerState.ingame
        and p.team == player.team
        and p.connected
        and p ~= player
    end)
    .forEach(function(p, i)
      local y = 32*i;

      nvg.textAlign(nvg.const.hAlign.right, nvg.const.vAlign.middle);

      if p.health > 0 then
        -- draw armorProtection
        icons.drawArmor(0, y, 8, p.armorProtection)

        -- draw armor
        nvg.text(52, y, p.armor)

        -- draw mega
        icons.drawMega(64, y, 8, p.hasMega)

        -- draw health
        nvg.text(115, y, p.health)

        -- draw carnage
        if (p.carnageTimer > 0) then -- player has carnage
          icons.drawCarnage(120, y, 8, p.carnageTimer)
          nvg.text(150, y, math.ceil(p.carnageTimer / 1000))
        end
      else
        nvg.textAlign(nvg.const.hAlign.center, nvg.const.vAlign.middle);
        nvg.text(75, y, "DEAD")
      end

      -- draw name
      nvg.textAlign(nvg.const.hAlign.left, nvg.const.vAlign.middle);
      nvg.text(160, y, p.name)

      y = y + 16;

      funcArray(p.weapons)
        .map(function(weapon, j)
          weapon.index = j -- HACK: we loose the proper index
          return weapon
        end)
        .filter(function(weapon, index)
          return index ~= 1 -- skip axe
            and weapon.pickedup
            and weapon.ammo > 0
        end)
        .forEach(function(weapon, j)
          icons.drawWeapon(64 * j, y, 8, weapon.index, weapon.color)
          nvg.text(64 * j + 16, y, weapon.ammo)
        end)
    end)
  end
};

_G.registerWidget("bonusTeamInfo");
