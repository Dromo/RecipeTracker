import "Turbine.UI";

Tab = class(Turbine.UI.Control);

-- colors
Tab.ItemColor = Turbine.UI.Color(180/255, 150/255, 0/255);
Tab.DisabledColor = Turbine.UI.Color(162/255, 162/255, 162/255);
Tab.HighlightColor = Turbine.UI.Color(255/255, 255/255, 0/255);
Tab.OutlineColor = Turbine.UI.Color(0, 0, 0);
Tab.HoverColor = Turbine.UI.Color(1, 1, 1);

function Tab:Constructor(name, content)
    Turbine.UI.Control.Constructor(self);

    -- state
    self.selected = false;
    self.pressed = false;
    self.mouse = false;
	
	-- content
	self.content = content;
	
	-- label
    self.label = Turbine.UI.Label();
    self.label:SetParent(self);
    self.label:SetText(name);
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
    self.label:SetForeColor(Tab.ItemColor);
	self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.label:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.label:SetMouseVisible(false);
    self.label:SetZOrder(5);

	-- left
	self.left = Turbine.UI.Control();
	self.left:SetParent(self);
	self.left:SetMouseVisible(false);
	self.left:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.left:SetBackground(Images.TabBase.."back_w.tga");
	
	-- right
	self.right = Turbine.UI.Control();
	self.right:SetParent(self);
	self.right:SetMouseVisible(false);
	self.right:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	self.right:SetBackground(Images.TabBase.."back_e.tga");
	
	-- default size
	self:SetSize(95, 22);
end

function Tab:MouseClick(args)
    if (not self:IsEnabled()) then
        return;
    end
    
    if (args.Button == Turbine.UI.MouseButton.Left) then
		self:SelectRequested();
    end
end

function Tab:SelectRequested()
end

function Tab:MouseEnter(args)
    self.mouse = true;
    self:UpdateState();
end

function Tab:MouseLeave(args)
    self.mouse = false;
    self:UpdateState();
end

function Tab:MouseDown(args)
    self.pressed = true;
    self:UpdateState();
end

function Tab:MouseUp(args)
    self.pressed = false;
    self:UpdateState();
end

function Tab:IsSelected()
    return self.selected;
end

function Tab:SetSelected(selected)
    self.selected = selected;
    self:UpdateState();
end

function Tab:SetEnabled(enabled)
    Turbine.UI.Control.SetEnabled(self, enabled);
    self:UpdateState();
end

function Tab:SetText(text)
    self.label:SetText(text);
end

function Tab:GetContent()
	return self.content;
end

function Tab:SizeChanged(args)
	self:Layout();
end

function Tab:Layout()
    local width = self:GetWidth();
    if (width < 40) then
        width = 40;
    end
    
    self.label:SetPosition(5, 0);
    self.left:SetPosition(0, 0);
    self.right:SetPosition(width - 18, 0);
    
    self.label:SetSize(width - 10, 22);
    self.left:SetSize(width - 18, 22);
    self.right:SetSize(18, 22);
end

function Tab:UpdateState()
    local enabled = self:IsEnabled();
    local state = self.selected and "front" or "back";
    local color = self.selected and Tab.HighlightColor or Tab.ItemColor;
    local font = self.selected and Turbine.UI.Lotro.Font.TrajanPro16 or Turbine.UI.Lotro.Font.TrajanPro15;

    if (not enabled) then
        color = Tab.DisabledColor;
    elseif (self.pressed) then
        color = Tab.HoverColor;
    elseif (self.mouse) then
        state = "front";
    end

	self.label:SetFont(font);
    self.label:SetForeColor(color);
    self.left:SetBackground(Images.TabBase..state.."_w.tga");
    self.right:SetBackground(Images.TabBase..state.."_e.tga");
end
