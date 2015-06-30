require "base/internal/ui/reflexcore"
--
-- copy from OptionsMenu - thank you TurboPixelStudio :)
--
local function uiKeyBind(bindCommand, x, y, w, bindState, optionalId, enabled)
	local h = 28;

	local c = 255;
	local k = nil;
	if enabled == false then
		c = UI_DISABLED_TEXT;
	else
		k = inputGrabRegion(x, y, w, h, optionalId);
	end

	nvgSave();

	-- Edit
	nvgBeginPath();
	nvgRoundedRect(x+1,y+1, w-2,h-2, 4-1);
	nvgFillBoxGradient(x+1, y+1+1.5, w-2, h-2, 3,4, Color(c,c,c,32), Color(32,32,32,32));
	nvgFill();

	local key = bindReverseLookup(bindCommand);
	if key == "(unbound)" then
		c = c / 2;
	else
		key = string.upper(key);
	end

	-- default border colour
	local bc = Color(0,0,0,48);

	-- modify when hovering
	bc.r = lerp(bc.r, UI_HOVER_BORDER_COLOR.r, k.hoverAmount);
	bc.g = lerp(bc.g, UI_HOVER_BORDER_COLOR.g, k.hoverAmount);
	bc.b = lerp(bc.b, UI_HOVER_BORDER_COLOR.b, k.hoverAmount);
	bc.a = lerp(bc.a, UI_HOVER_BORDER_COLOR.a, k.hoverAmount);

	-- modify when have focus
	if k.focus then
		local intensity = k.focusAmount;

		-- pulse
		intensity = intensity * (math.sin(OptionsMenu.keyBindPulseTimer) * 0.5 + 0.5);
		OptionsMenu.keyBindPulseTimer = OptionsMenu.keyBindPulseTimer + deltaTime * 16;

		bc.r = lerp(bc.r, 255, intensity);
		bc.g = lerp(bc.g, 255, intensity);
		bc.b = lerp(bc.b, 0, intensity);
	end

	-- border
	nvgBeginPath();
	nvgRoundedRect(x+0.5,y+0.5, w-1,h-1, 4-0.5);
	nvgStrokeColor(bc);
	nvgStroke();

	local tw = nvgTextWidth(key);
	if tw >= w - 5 then
		nvgScissor(x, y, w - 5, 100);
	end

	-- text
	nvgFontSize(20);
	nvgFontFace(FONT_TEXT);
	nvgFillColor(Color(c,c,c,64));
	nvgTextAlign(NVG_ALIGN_LEFT, NVG_ALIGN_MIDDLE);
	nvgText(x+h*0.3, y+h*0.5, key);

	nvgRestore();

	if k.nameKeyPressed ~= nil then
		if key ~= "(unbound)" then
			--consolePrint("unbind "..key);
			consolePerformCommand("unbind "..key);
		end
		if bindState ~= nil then
			consolePerformCommand("bind "..bindState.." "..k.nameKeyPressed.." "..bindCommand);
		else
			consolePerformCommand("bind "..k.nameKeyPressed.." "..bindCommand);
		end
	end

	return text;
end
--
-- copy end
--

local widgetName = "bonusSnapDistance"
local cvar = "ui_" .. widgetName .. "_snap"

local widget = {

  -- we have no ui
  canHide = false,
  canPosition = false,

  initialize = function()
    _G.widgetCreateConsoleVariable("snap", "string", "0");
  end,

  drawOptions = function(_, x, y)
    -- TODO: BINDINGS FOR DOUBLE HALF, etc
    local keyWidth = 240
    local keyOffset = keyWidth + 10;
    local hSize = 40

    _G.uiLabel("double snapdistance", x, y);
  	uiKeyBind(cvar ..  " " .. "*" , x + keyOffset, y, keyWidth, "me");
    y = y + hSize

    _G.uiLabel("half snapdistance", x, y);
  	uiKeyBind(cvar ..  " " .. "/" , x + keyOffset, y, keyWidth, "me");
    y = y + hSize

    _G.uiLabel("snapdistance + 1", x, y);
  	uiKeyBind(cvar ..  " " .. "+" , x + keyOffset, y, keyWidth, "me");
    y = y + hSize

    _G.uiLabel("snapdistance - 1", x, y);
  	uiKeyBind(cvar ..  " " .. "-" , x + keyOffset, y, keyWidth, "me");
  end,

  draw = function()
    local command = _G.widgetGetConsoleVariable("snap")

    if command == "0" then return end

    local snapdistance = _G.consoleGetVariable('me_snapdistance')

    if command == "*" then
      snapdistance = 2 * snapdistance
    elseif command == "/" then
      snapdistance = snapdistance / 2
    elseif command == "+" then
      snapdistance = snapdistance + 1
    elseif command == "-" then
      snapdistance = snapdistance - 1
    else
      return
    end

    snapdistance = math.floor(snapdistance);

    _G.consolePerformCommand('me_snapdistance ' .. snapdistance)
    _G.consolePerformCommand(cvar ..' 0')

  end
};


_G[widgetName] = widget
_G.registerWidget(widgetName);
