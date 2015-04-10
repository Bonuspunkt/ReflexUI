require "base/internal/ui/reflexcore"

local function filter(tbl, func)
    local newtbl= {}
    for i,v in pairs(tbl) do
        if func(v) then
            newtbl[i]=v
        end
    end
    return newtbl
end

local function forEach(tbl, func)
    for key,value in pairs(tbl) do
        func(value, key, tbl)
    end
end

local armorColors = {
    Color(0, 255, 0, 255),
    Color(255,255,0,255),
    Color(255,0,0,255)
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
        nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_TOP);

        local teamPlayers = filter(players, function(p)
            return p.state == PLAYER_STATE_INGAME
                and p.team == player.team
                and p.connected
                and p ~= player
        end)

        -- draw players
        forEach(teamPlayers, function(player, i)
            local y = 32*i;

            -- draw armorProtection
            nvgFillColor(armorColors[player.armorProtection + 1]);
            nvgSvg("internal/ui/icons/armor", 0, y + 12, 8)
            -- draw armor
            nvgText(16, y, player.armor)

            -- draw health
            nvgText(64, y, player.health)

            local x1 = 120;

            if player.hasMega then
                nvgFillColor(Color(60,80,255));
                nvgSvg("internal/ui/icons/health", x1, y + 12, 8)
                x1 = x1 + 24;
            end

            if (player.carnageTimer > 0) then -- player has carnage
                nvgFillColor(Color(255,120,128))
                nvgSvg("internal/ui/icons/carnage", x1, y + 12, 8)
                nvgText(x1 + 8, y, math.ceil(player.carnageTimer / 1000))
                x1 = x1 + 48
            end


            -- draw name
            nvgText(x1, y, player.name)

            y = y + 16;

            local j = 0
            forEach(player.weapons, function(weapon, weaponIndex)
                if weaponIndex == 1 -- skip the axe
                    or not weapon.pickedup -- skip not picked up weapons
                    or weapon.ammo == 0 then -- and empty ones
                    return
                end

                nvgFillColor(weapon.color);
                local svgName = "internal/ui/icons/weapon"..weaponIndex;
                nvgSvg(svgName, 64 * j, y + 16, 8);
                nvgText(64 * j + 16, y, weapon.ammo)

                j = j+1
            end)
        end)
    end
};
registerWidget("TeamInfo");