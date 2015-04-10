require "base/internal/ui/reflexcore"
local FuncArray = require "base/internal/ui/bonus/_FuncArray"
local Icons = require "base/internal/ui/bonus/_Icons"

local armorColors = {
    Color(0, 255, 0, 255),
    Color(255, 255, 0, 255),
    Color(255, 0, 0, 255)
}

TeamInfo =
{
    draw = function()

        -- Early out if HUD should not be shown.
        if not shouldShowHUD() then return end;

        -- Early out if we are not in (A)TDM
        local gameMode = gamemodes[world.gameModeIndex].shortName;
        if gameMode ~= 'tdm' and gameMode ~= 'atdm' then return end;

        -- Find player
        local player = getPlayer();

        nvgFontFace(FONT_TEXT);
        nvgFontSize(28);

        FuncArray(players)
            .filter(function(p)
                    return p.state == PLAYER_STATE_INGAME
                        and p.team == player.team
                        and p.connected
                        and p ~= player
            end)
            .forEach(function(player, i)
                local y = 32*i;

                nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_MIDDLE);

                if player.health > 0 then
                    -- draw armorProtection
                    Icons.drawArmor(0, y, 8, player.armorProtection)

                    -- draw armor
                    nvgText(52, y, player.armor)

                    -- draw mega
                    Icons.drawMega(64, y, 8, player.hasMega)

                    -- draw health
                    nvgText(115, y, player.health)

                    local x1 = 120;


                    -- draw carnage
                    if (player.carnageTimer > 0) then -- player has carnage
                        Icons.drawCarnage(120, y, 8, player.carnageTimer)
                        nvgText(150, y, math.ceil(player.carnageTimer / 1000))
                        x1 = x1 + 48
                    end
                else
                    nvgTextAlign(NVG_ALIGN_CENTER, NVG_ALIGN_MIDDLE);
                    nvgText(75, y, "DEAD")
                end

                -- draw name
                nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
                nvgText(160, y, player.name)

                y = y + 16;

                FuncArray(player.weapons)
                    .map(function(weapon, i) weapon.index = i; return weapon end)
                    .filter(function(weapon, index)
                        return index ~= 1 -- skip axe
                            and weapon.pickedup
                            and weapon.ammo > 0
                    end)
                    .forEach(function(weapon, j)
                        Icons.drawWeapon(64 * j, y, 8, weapon.index, weapon.color)
                        nvgText(64 * j + 16, y, weapon.ammo)
                    end)
            end)
    end
};
registerWidget("TeamInfo");