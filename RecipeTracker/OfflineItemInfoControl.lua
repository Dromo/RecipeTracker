
OfflineItemInfoControl = class(Turbine.UI.Control);

function OfflineItemInfoControl:Constructor()
    Turbine.UI.Control.Constructor(self);

	self:SetSize(35, 35);

	self.itemInfoControl = Turbine.UI.Lotro.ItemInfoControl();
	self.itemInfoControl:SetParent(self);
	self.itemInfoControl:SetPosition(0, 0);
	self.itemInfoControl:SetSize(35, 35);

	self.iconBack = Turbine.UI.Control();
	self.iconBack:SetParent(self);
	self.iconBack:SetPosition(0, 2);
	self.iconBack:SetSize(32, 32);
	self.iconBack:SetBlendMode(Turbine.UI.BlendMode.Normal);

	self.icon = Turbine.UI.Control();
	self.icon:SetParent(self.iconBack);
	self.icon:SetPosition(0, 0);
	self.icon:SetSize(32, 32);
	self.icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	self.quantityLabel = Turbine.UI.Label();
	self.quantityLabel:SetParent(self.icon);
	self.quantityLabel:SetPosition(7, 16);
	self.quantityLabel:SetSize(20, 15);
	self.quantityLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	self.quantityLabel:SetForeColor(Turbine.UI.Color.Khaki);
	self.quantityLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	self.quantityLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
	self.quantityLabel:SetVisible(false);
end

function OfflineItemInfoControl:SetItem(itemInfo, iconId, iconBackId, quantity)
	self.itemInfoControl:SetItemInfo(itemInfo);
	self.itemInfoControl:SetQuantity(quantity);
	self.icon:SetBackground(iconId);
	self.iconBack:SetBackground(iconBackId);
	self.quantityLabel:SetText(quantity);

	if itemInfo then
		self.itemInfoControl:SetVisible(true);
		self.icon:SetVisible(false);
		self.iconBack:SetVisible(false);
		self.quantityLabel:SetVisible(false);
	else
		self.itemInfoControl:SetVisible(false);
		self.icon:SetVisible(true);
		self.iconBack:SetVisible(true);
		self.quantityLabel:SetVisible(quantity > 1);
	end
end
