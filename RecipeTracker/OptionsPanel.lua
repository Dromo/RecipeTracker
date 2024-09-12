
function CreateOptionsPanel()
	OptionsPanel = Turbine.UI.Control();

	OptionsPanel:SetHeight(500);

	local minimizeCheckBox = Turbine.UI.Lotro.CheckBox();
	minimizeCheckBox:SetParent(OptionsPanel);
	minimizeCheckBox:SetPosition(10, 10);
	minimizeCheckBox:SetWidth(300);
	minimizeCheckBox:SetText("Enable minimized icon");
	minimizeCheckBox:SetChecked(Settings.isMinimizeEnabled);

	minimizeCheckBox.CheckedChanged = function(sender, args)
		Settings.isMinimizeEnabled = minimizeCheckBox:IsChecked();
		UpdateMinimizedIcon();
	end

	local opacityLabel = Turbine.UI.Label();
	opacityLabel:SetParent(OptionsPanel);
	opacityLabel:SetPosition(10, 60);
	opacityLabel:SetSize(170, 16);
	opacityLabel:SetText("Minimize icon opacity:");

	local opacitySlider = Slider();
	opacitySlider:SetParent(OptionsPanel);
	opacitySlider:SetPosition(180, 60);
	opacitySlider:SetValue(Settings.minimizeOpacity);

	opacitySlider.ValueChanged = function(sender)
		Settings.minimizeOpacity = opacitySlider:GetValue();
		UpdateMinimizedIcon();
	end
end
