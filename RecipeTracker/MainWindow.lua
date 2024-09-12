
function CreateMainWindow()
	local windowWidth = 700;
	local windowHeight = 500;

	local characterDropDownTop = 40;
	local characterDropDownLeft = 20;

	local professionButtonTop = 40;
	local professionButtonWidth = 100;

	local searchTop = 70;

	local treeLeft = 10;
	local treeTop = searchTop + 20;
	local treeWidth = windowWidth * 0.45;
	local treeHeight = windowHeight - 115;

	local tabLeft = treeWidth + 25;
	local tabTop = 70;
	local tabWidth = 100;
	local tabHeight = 20;

	local selectedRecipeLeft = tabLeft;
	local selectedRecipeTop = tabTop + tabHeight;
	local selectedRecipeWidth = (windowWidth * 0.55) - 40;
	local selectedRecipeHeight = 270;

	local quickslotSearchLeft = selectedRecipeLeft;
	local quickslotSearchTop = selectedRecipeTop + selectedRecipeHeight + 10;
	local quickslotSearchWidth = selectedRecipeWidth;
	local quickslotSearchHeight = windowHeight - selectedRecipeTop - selectedRecipeHeight - 35;

	local controlBackColor = Turbine.UI.Color(0.03,0.03,0.03);

	local displayWidth, displayHeight = Turbine.UI.Display.GetSize();
	if Settings.windowX < 0 then
		Settings.windowX = 0;
	elseif Settings.windowX > displayWidth-windowWidth then
		Settings.windowX = displayWidth-windowWidth;
	end
	if Settings.windowY < 0 then
		Settings.windowY = 0;
	elseif Settings.windowY > displayHeight-windowHeight then
		Settings.windowY = displayHeight-windowHeight;
	end

	MainWindow = Turbine.UI.Lotro.Window();
	MainWindow:SetText(Strings.PluginName);
	MainWindow:SetSize(windowWidth, windowHeight);
	MainWindow:SetPosition(Settings.windowX, Settings.windowY);
	-- MainWindow:SetResizable(true);
	MainWindow:SetVisible(Settings.isWindowVisible);

	MainWindow.Closing = function()
		Settings.isWindowVisible = false;
		UpdateMinimizedIcon();
	end

	MainWindow.PositionChanged = function()
		Settings.windowX = MainWindow:GetLeft();
		Settings.windowY = MainWindow:GetTop();
	end

	MainWindow:SetWantsKeyEvents(true);
	MainWindow.KeyDown = function(sender,args)
		if args.Action == 268435635 then -- F12
			IsHidingUI = not IsHidingUI;
			if IsHidingUI then
				MainWindow:SetVisible(false);
				MainMinimizedIcon:SetVisible(false);
			else
				MainWindow:SetVisible(Settings.isWindowVisible);
				UpdateMinimizedIcon();
			end
		end

		if args.Action == 145 then -- Esc
			HideMainWindow();
		end
	end

	local characterNames = {};
	for i = 1, #CharacterList do
		characterNames[i] = CharacterList[i].name;
	end

	local characterDropDown = DropDown.Create(characterNames, characterNames[CurrentCharacter]);
	characterDropDown:SetParent(MainWindow);
	characterDropDown:SetPosition(characterDropDownLeft, characterDropDownTop);
	
	characterDropDown.ItemChanged = function()
		local name = characterDropDown:GetText();
		for i = 1, #CharacterList do
			if CharacterList[i].name == name then
				CurrentCharacter = i;
			end
		end
		UpdateCharacter();
	end

	MainWindow.professionButtons = {};
	MainWindow.professionButtonIndices = {};
	local pos = characterDropDown:GetLeft() + characterDropDown:GrabWidth() + 20;
	for i = 1, ProfessionNumber do
		MainWindow.professionButtonIndices[i] = 0;
		local professionButton = Turbine.UI.Lotro.Button();
		professionButton:SetParent(MainWindow);
		
		professionButton:SetPosition(pos+(i-1)*(professionButtonWidth+10), professionButtonTop);
		professionButton:SetSize(professionButtonWidth, 32);
		table.insert(MainWindow.professionButtons, professionButton);

		professionButton.Click = function(sender, args)
			SetCurrentProfession(i);
		end
	end

	local recipeTree = Turbine.UI.TreeView();
	MainWindow.recipeTree = recipeTree;
	recipeTree:SetParent(MainWindow);
	recipeTree:SetPosition(treeLeft, treeTop);
	recipeTree:SetSize(treeWidth, treeHeight);
	recipeTree:SetIndentationWidth(7);
	recipeTree:SetBackColor(controlBackColor);
	recipeTree:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);

	local recipeTreeScrollBar = Turbine.UI.Lotro.ScrollBar();
	recipeTreeScrollBar:SetParent(MainWindow);
	recipeTreeScrollBar:SetPosition(treeWidth+10, treeTop);
	recipeTreeScrollBar:SetSize(10, treeHeight);
	recipeTreeScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    
	recipeTree:SetVerticalScrollBar(recipeTreeScrollBar);

	recipeTree.SelectedNodeChanged = function(sender, args)
		UpdateSelectedRecipe();
	end

	local expandAllIcon = Turbine.UI.Control();
	expandAllIcon:SetParent(MainWindow);
	expandAllIcon:SetPosition(treeLeft, searchTop);
	expandAllIcon:SetSize(16, 16);
	expandAllIcon:SetBackground(Images.ExpandAll);
	expandAllIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	expandAllIcon.MouseClick = function(sender, args)
		ExpandAllRecipes();
	end

	local collapseAllIcon = Turbine.UI.Control();
	collapseAllIcon:SetParent(MainWindow);
	collapseAllIcon:SetPosition(treeLeft+20, searchTop);
	collapseAllIcon:SetSize(16, 16);
	collapseAllIcon:SetBackground(Images.CollapseAll);
	collapseAllIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	collapseAllIcon.MouseClick = function(sender, args)
		CollapseAllRecipes();
	end

	local searchLabel = Turbine.UI.Label();
	searchLabel:SetParent(MainWindow);
	searchLabel:SetText(Strings.Search);
	searchLabel:SetPosition(50, searchTop);
	searchLabel:SetWidth(50);
	searchLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
	searchLabel:SetForeColor(Turbine.UI.Color.Khaki);
	searchLabel:SetMarkupEnabled(true);

	local searchTextBox = Turbine.UI.Lotro.TextBox();
	MainWindow.searchTextBox = searchTextBox;
	searchTextBox:SetParent(MainWindow);
	searchTextBox:SetPosition(110, searchTop-2);
	searchTextBox:SetSize(treeWidth-130, 18);
	searchTextBox:SetFont(Turbine.UI.Lotro.Font.Verdana14);

	searchTextBox.TextChanged = function(sender, args)
		MainWindow.searchText = string.lower(searchTextBox:GetText());
		-- Can't get this to work yet, maybe it's bugged, temp hack alternative
		-- recipeTree:SetFilter(RecipeFilterCallback);
		UpdateRecipeList();
		ExpandAllRecipes();
	end

	local refreshIcon = Turbine.UI.Control();
	MainWindow.refreshIcon = refreshIcon;
	refreshIcon:SetParent(MainWindow);
	refreshIcon:SetPosition(treeWidth-6, searchTop);
	refreshIcon:SetSize(16, 16);
	refreshIcon:SetBackground(Images.Refresh);
	refreshIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	refreshIcon.MouseClick = function(sender, args)
		UpdatePlayerData(true);
		UpdateCharacter();
	end

	local tabControl = Turbine.UI.Control();
	MainWindow.tabControl = tabControl;
	tabControl:SetParent(MainWindow);
	tabControl:SetVisible(false);
	tabControl:SetPosition(tabLeft, tabTop);
	tabControl:SetSize(tabWidth*2, tabHeight);

	local trackingTab = Tab(Strings.Tracking, nil);
	MainWindow.trackingTab = trackingTab;
	trackingTab:SetParent(tabControl);
	trackingTab:SetPosition(0, 0);
	trackingTab:SetSize(tabWidth, tabHeight);
	trackingTab:SetSelected(true);

	local detailsTab = Tab(Strings.Details, nil);
	MainWindow.detailsTab = detailsTab;
	detailsTab:SetParent(tabControl);
	detailsTab:SetPosition(tabWidth, 0);
	detailsTab:SetSize(tabWidth, tabHeight);

	trackingTab.SelectRequested = function()
		trackingTab:SetSelected(true);
		detailsTab:SetSelected(false);
		MainWindow.selectedRecipeTrackingControl:SetVisible(true);
		MainWindow.selectedRecipeDetailsControl:SetVisible(false);
	end
	detailsTab.SelectRequested = function()
		trackingTab:SetSelected(false);
		detailsTab:SetSelected(true);
		MainWindow.selectedRecipeTrackingControl:SetVisible(false);
		MainWindow.selectedRecipeDetailsControl:SetVisible(true);
	end

	local selectedRecipeControl = Turbine.UI.Control();
	MainWindow.selectedRecipeControl = selectedRecipeControl;
	selectedRecipeControl:SetParent(MainWindow);
	selectedRecipeControl:SetVisible(false);
	selectedRecipeControl:SetPosition(selectedRecipeLeft, selectedRecipeTop);
	selectedRecipeControl:SetSize(selectedRecipeWidth, selectedRecipeHeight);
	selectedRecipeControl:SetBackColor(controlBackColor);
	selectedRecipeControl:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);

	local selectedRecipeItem = OfflineItemInfoControl();
	MainWindow.selectedRecipeItem = selectedRecipeItem;
	selectedRecipeItem:SetParent(selectedRecipeControl);
	selectedRecipeItem:SetPosition(10, 10);

	local selectedRecipeLabel = Turbine.UI.Label();
	MainWindow.selectedRecipeLabel = selectedRecipeLabel;
	selectedRecipeLabel:SetParent(selectedRecipeControl);
	selectedRecipeLabel:SetPosition(50, 20);
	selectedRecipeLabel:SetSize(selectedRecipeWidth-60, 50);
	selectedRecipeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro18);
	selectedRecipeLabel:SetMarkupEnabled(true);

	local selectedRecipeTrackingControl = Turbine.UI.Label();
	MainWindow.selectedRecipeTrackingControl = selectedRecipeTrackingControl;
	selectedRecipeTrackingControl:SetParent(selectedRecipeControl);
	selectedRecipeTrackingControl:SetPosition(0, 65);
	selectedRecipeTrackingControl:SetSize(selectedRecipeWidth, selectedRecipeHeight-65);

	local knownByLabel = Turbine.UI.Label();
	knownByLabel:SetParent(selectedRecipeTrackingControl);
	knownByLabel:SetPosition(10, 0);
	knownByLabel:SetSize(selectedRecipeWidth-20, 16);
	knownByLabel:SetText(Strings.KnownBy);
	knownByLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	knownByLabel:SetForeColor(Turbine.UI.Color.Khaki);

	local knownByList = Turbine.UI.Label();
	MainWindow.knownByList = knownByList;
	knownByList:SetParent(selectedRecipeTrackingControl);
	knownByList:SetPosition(50, 20);
	knownByList:SetSize(selectedRecipeWidth-60, 16);
	knownByList:SetFont(Turbine.UI.Lotro.Font.Verdana14);

	local neededByLabel = Turbine.UI.Label();
	MainWindow.neededByLabel = neededByLabel;
	neededByLabel:SetParent(selectedRecipeTrackingControl);
	neededByLabel:SetPosition(10, 35);
	neededByLabel:SetSize(selectedRecipeWidth-20, 16);
	neededByLabel:SetText(Strings.NeededBy);
	neededByLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	neededByLabel:SetForeColor(Turbine.UI.Color.Khaki);

	local neededByList = Turbine.UI.Label();
	MainWindow.neededByList = neededByList;
	neededByList:SetParent(selectedRecipeTrackingControl);
	neededByList:SetPosition(50, 45);
	neededByList:SetSize(selectedRecipeWidth-60, 16);
	neededByList:SetFont(Turbine.UI.Lotro.Font.Verdana14);

	local neededSoonByList = Turbine.UI.Label();
	MainWindow.neededSoonByList = neededSoonByList;
	neededSoonByList:SetParent(selectedRecipeTrackingControl);
	neededSoonByList:SetPosition(50, 75);
	neededSoonByList:SetSize(selectedRecipeWidth-60, 16);
	neededSoonByList:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	neededSoonByList:SetForeColor(Turbine.UI.Color.Gray);

	local selectedRecipeDetailsControl = Turbine.UI.Label();
	MainWindow.selectedRecipeDetailsControl = selectedRecipeDetailsControl;
	selectedRecipeDetailsControl:SetParent(selectedRecipeControl);
	selectedRecipeDetailsControl:SetPosition(0, 65);
	selectedRecipeDetailsControl:SetSize(selectedRecipeWidth, selectedRecipeHeight-65);
	selectedRecipeDetailsControl:SetVisible(false);

	local ingredientsLabel = Turbine.UI.Label();
	ingredientsLabel:SetParent(selectedRecipeDetailsControl);
	ingredientsLabel:SetPosition(10, 0);
	ingredientsLabel:SetSize(selectedRecipeWidth-20, 16);
	ingredientsLabel:SetText(Strings.Ingredients);
	ingredientsLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
	ingredientsLabel:SetForeColor(Turbine.UI.Color.Khaki);

	MainWindow.ingredientItems = {};
	MainWindow.ingredientLabels = {};
	for i = 1, 8 do
		local posX = 10 + ((i-1)%2)*(selectedRecipeWidth-15)*0.5;
		local posY = 20 + math.floor((i-1)/2)*40;

		local ingredientItem = OfflineItemInfoControl();
		MainWindow.ingredientItems[i] = ingredientItem;
		ingredientItem:SetParent(selectedRecipeDetailsControl);
		ingredientItem:SetPosition(posX, posY);
		ingredientItem:SetVisible(false);

		local ingredientLabel = Turbine.UI.Label();
		MainWindow.ingredientLabels[i] = ingredientLabel;
		ingredientLabel:SetParent(selectedRecipeDetailsControl);
		ingredientLabel:SetPosition(posX+40, posY);
		ingredientLabel:SetSize((selectedRecipeWidth-20)/2-40, 35);
		ingredientLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
		ingredientLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		ingredientLabel:SetVisible(false);
	end

	local quickslotSearchControl = Turbine.UI.Control();
	quickslotSearchControl:SetParent(MainWindow);
	quickslotSearchControl:SetPosition(quickslotSearchLeft, quickslotSearchTop);
	quickslotSearchControl:SetSize(quickslotSearchWidth, quickslotSearchHeight);
	quickslotSearchControl:SetBackColor(controlBackColor);
	quickslotSearchControl:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);

	local quickslotSearchLabel = Turbine.UI.Label();
	quickslotSearchLabel:SetParent(quickslotSearchControl);
	quickslotSearchLabel:SetPosition(10, 3);
	quickslotSearchLabel:SetSize(quickslotSearchWidth-20, 20);
	quickslotSearchLabel:SetText(Strings.RecipeSearch);
	quickslotSearchLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	quickslotSearchLabel:SetForeColor(Turbine.UI.Color.Khaki);

	local recipeSearchQuickslot = Turbine.UI.Lotro.Quickslot();
	MainWindow.recipeSearchQuickslot = recipeSearchQuickslot;
	recipeSearchQuickslot:SetParent(quickslotSearchControl);
	recipeSearchQuickslot:SetPosition(10, 25);
	recipeSearchQuickslot:SetSize(35, 35);
	recipeSearchQuickslot:SetUseOnRightClick(false);

	recipeSearchQuickslot.ShortcutChanged = function(sender, args)
		UpdateQuickslotSearch();
	end

	local quickslotInfoLabel = Turbine.UI.Label();
	quickslotInfoLabel:SetParent(quickslotSearchControl);
	quickslotInfoLabel:SetPosition(50, 35);
	quickslotInfoLabel:SetSize(quickslotSearchWidth-50, 16);
	quickslotInfoLabel:SetText(Strings.DragToSearch);
	quickslotInfoLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	quickslotInfoLabel:SetMarkupEnabled(true);

	local quickSearchLabel = Turbine.UI.Label();
	quickSearchLabel:SetParent(quickslotSearchControl);
	quickSearchLabel:SetText(Strings.SearchByName);
	quickSearchLabel:SetPosition(10, 70);
	quickSearchLabel:SetWidth(120);
	quickSearchLabel:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	quickSearchLabel:SetMarkupEnabled(true);

	local quickSearchTextBox = Turbine.UI.Lotro.TextBox();
	MainWindow.quickSearchTextBox = quickSearchTextBox;
	quickSearchTextBox:SetParent(quickslotSearchControl);
	quickSearchTextBox:SetPosition(130, 68);
	quickSearchTextBox:SetSize(quickslotSearchWidth-140, 18);
	quickSearchTextBox:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	quickSearchTextBox:SetMultiline(false);

	quickSearchTextBox.TextChanged = function(sender, args)
		UpdateQuickSearch(quickSearchTextBox:GetText());
	end

	local quickslotFailLabel = Turbine.UI.Label();
	MainWindow.quickslotFailLabel = quickslotFailLabel;
	quickslotFailLabel:SetParent(quickslotSearchControl);
	quickslotFailLabel:SetVisible(false);
	quickslotFailLabel:SetPosition(10, 90);
	quickslotFailLabel:SetSize(quickslotSearchWidth-50, 20);
	quickslotFailLabel:SetText(Strings.NotRecipe);
	quickslotFailLabel:SetFont(Turbine.UI.Lotro.Font.Verdana18);
	quickslotFailLabel:SetForeColor(Turbine.UI.Color.Yellow);
	quickslotFailLabel:SetMarkupEnabled(true);

	UpdateCharacter();

	-- Minimized icon
	MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, 32, 32, ShowMainWindow);

	if Settings.minimizeX < 0 then
		Settings.minimizeX = 0;
	elseif Settings.minimizeX > displayWidth-32 then
		Settings.minimizeX = displayWidth-32;
	end
	if Settings.minimizeY < 0 then
		Settings.minimizeY = 0;
	elseif Settings.minimizeY > displayHeight-32 then
		Settings.minimizeY = displayHeight-32;
	end

	MainMinimizedIcon:SetPosition(Settings.minimizeX, Settings.minimizeY);

	MainMinimizedIcon.PositionChanged = function()
		Settings.minimizeX = MainMinimizedIcon:GetLeft();
		Settings.minimizeY = MainMinimizedIcon:GetTop();
	end

	UpdateMinimizedIcon();
end



function RecipeFilterCallback(node)
	Turbine.Shell.WriteLine(tostring(node));
	node:SetEnabled(true);
	node:SetVisible(true);

	return true;
end



function UpdateCharacter()
	local character = CharacterList[CurrentCharacter];

	for i = 1, ProfessionNumber do
		MainWindow.professionButtons[i]:SetVisible(false);
		MainWindow.professionButtonIndices[i] = 0;
	end
	local buttonIndex = 1;
	for profession, professionData in pairs(character.professions) do
		MainWindow.professionButtons[buttonIndex]:SetVisible(true);
		MainWindow.professionButtons[buttonIndex]:SetText(GetProfessionName(profession));
		MainWindow.professionButtonIndices[buttonIndex] = profession;
		buttonIndex = buttonIndex + 1;
	end

	MainWindow.refreshIcon:SetVisible(CurrentCharacter == LocalPlayerCharacter);

	SetCurrentProfession(1);
end


function SetCurrentProfession(profession)
	-- Update profession button status
	for i = 1, ProfessionNumber do
		if i == profession then
			MainWindow.professionButtons[i]:SetEnabled(false);
		else
			MainWindow.professionButtons[i]:SetEnabled(true);
		end
	end

	-- Clear search box
	MainWindow.searchTextBox:SetText(nil);
	MainWindow.searchText = nil;

	CurrentProfession = MainWindow.professionButtonIndices[profession];
	UpdateRecipeList();
end



function UpdateRecipeList()
	local recipeTree = MainWindow.recipeTree;
	local rootNodes = recipeTree:GetNodes();
	rootNodes.Clear();
	MainWindow.allExpandIcons = {};

	local character = CharacterList[CurrentCharacter];

	if not character.professions then
		return;
	end

	local professionData = character.professions[CurrentProfession];
	if not professionData then
		return;
	end

	local recipeTreeData = CreateRecipeTree(professionData.recipes);

	local proficiencyExpDone = false;
	local masteryExpDone = false;
	for tier, tierTree in pairs(recipeTreeData) do
		local node = Turbine.UI.TreeNode();
		node:SetSize(recipeTree:GetWidth()-3, 18);
		local nodeExpandIcon = Turbine.UI.Control();
		table.insert(MainWindow.allExpandIcons, nodeExpandIcon);
		nodeExpandIcon:SetParent(node);
		nodeExpandIcon:SetSize(16, 16);
		nodeExpandIcon:SetBackground(Images.Expand);
		nodeExpandIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
		nodeExpandIcon:SetMouseVisible(false);
		local nodeLabel = Turbine.UI.Label();
		nodeLabel:SetParent(node);
		nodeLabel:SetText(GetTierName(tier));
		nodeLabel:SetPosition(20, 0);
		nodeLabel:SetSize(node:GetWidth()-20, node:GetHeight());
		nodeLabel:SetMultiline(false);
		nodeLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro15);
		nodeLabel:SetForeColor(Turbine.UI.Color.Yellow);
		nodeLabel:SetMarkupEnabled(true);
		nodeLabel:SetMouseVisible(false);
		if tier <= professionData.proficiencyLevel then
			local proficiencyIcon = Turbine.UI.Control();
			proficiencyIcon:SetParent(node);
			proficiencyIcon:SetPosition(180, 0);
			proficiencyIcon:SetSize(32, 16);
			proficiencyIcon:SetBackground(Images.Proficient);
			proficiencyIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
			proficiencyIcon:SetMouseVisible(false);
			if tier <= professionData.masteryLevel then
				local proficiencyIcon = Turbine.UI.Control();
				proficiencyIcon:SetParent(node);
				proficiencyIcon:SetPosition(215, 0);
				proficiencyIcon:SetSize(32, 16);
				proficiencyIcon:SetBackground(Images.Master);
				proficiencyIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
				proficiencyIcon:SetMouseVisible(false);
			elseif not masteryExpDone then
				masteryExpDone = true;
				if professionData.masteryExpTarget then
					local expLabel = Turbine.UI.Label();
					expLabel:SetParent(node);
					expLabel:SetPosition(215, 0);
					expLabel:SetSize(100, 16);
					expLabel:SetText(professionData.masteryExp .. "/" .. professionData.masteryExpTarget);
					expLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
					expLabel:SetMarkupEnabled(true);
				end
			end
		elseif not proficiencyExpDone then
			proficiencyExpDone = true;
			if professionData.proficiencyExpTarget then
				local expLabel = Turbine.UI.Label();
				expLabel:SetParent(node);
				expLabel:SetPosition(180, 0);
				expLabel:SetSize(100, 16);
				expLabel:SetText(professionData.proficiencyExp .. "/" .. professionData.proficiencyExpTarget);
				expLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
				expLabel:SetMarkupEnabled(true);
			end
		end
		rootNodes:Add(node);

		node.MouseClick = function(sender, args)
			if node:IsExpanded() then
				nodeExpandIcon:SetBackground(Images.Collapse);
			else
				nodeExpandIcon:SetBackground(Images.Expand);
			end
		end

		local tierChildren = node:GetChildNodes();

		for categoryIndex = 1, #tierTree.categoryList do
			local categoryName = tierTree.categoryList[categoryIndex];

			local node = Turbine.UI.TreeNode();
			node:SetSize(recipeTree:GetWidth()-3, 18);
			local nodeExpandIcon = Turbine.UI.Control();
			table.insert(MainWindow.allExpandIcons, nodeExpandIcon);
			nodeExpandIcon:SetParent(node);
			nodeExpandIcon:SetSize(16, 16);
			nodeExpandIcon:SetBackground(Images.Expand);
			nodeExpandIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
			nodeExpandIcon:SetMouseVisible(false);
			local nodeLabel = Turbine.UI.Label();
			nodeLabel:SetParent(node);
			nodeLabel:SetText(categoryName);
			nodeLabel:SetPosition(20, 0);
			nodeLabel:SetSize(node:GetWidth()-20, node:GetHeight());
			nodeLabel:SetMultiline(false);
			nodeLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
			nodeLabel:SetMarkupEnabled(true);
			nodeLabel:SetMouseVisible(false);

			node.MouseClick = function(sender, args)
				if node:IsExpanded() then
					nodeExpandIcon:SetBackground(Images.Collapse);
				else
					nodeExpandIcon:SetBackground(Images.Expand);
				end
			end

			local categoryChildren = node:GetChildNodes();

			local categoryTree = tierTree[categoryName];
			for recipeIndex = 1, #categoryTree do
				local recipe = categoryTree[recipeIndex];

				if not MainWindow.searchText or string.find(string.lower(recipe.name), MainWindow.searchText, 1, true) then
					local node = Turbine.UI.TreeNode();
					node:SetSize(recipeTree:GetWidth()-3, 18);
					local nodeLabel = Turbine.UI.Label();
					nodeLabel:SetParent(node);
					nodeLabel:SetText(recipe.name);
					nodeLabel:SetPosition(10, 0);
					nodeLabel:SetSize(node:GetWidth()-10, node:GetHeight());
					nodeLabel:SetMultiline(false);
					nodeLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
					nodeLabel:SetMarkupEnabled(true);
					nodeLabel:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay);
					categoryChildren:Add(node);

					node.SelectedChanged = function(sender, args)
						if node:IsSelected() then
							nodeLabel:SetBackColor(Turbine.UI.Color(0.2,0.2,0.2));
						else
							nodeLabel:SetBackColor(nil);
						end
					end

					node.recipe = recipe;
				end
			end

			-- don't add empty categories (i.e. when searching)
			if categoryChildren:GetCount() > 0 then
				tierChildren:Add(node);
			end
		end
	end

	-- Just clear directly, selected tree node somehow hasn't changed yet
	-- UpdateSelectedRecipe();
	MainWindow.selectedRecipeControl:SetVisible(false);
	MainWindow.tabControl:SetVisible(false);
end



function ExpandAllRecipes()
	MainWindow.recipeTree:ExpandAll();
	for i, icon in pairs(MainWindow.allExpandIcons) do
		icon:SetBackground(Images.Collapse);
	end
end


function CollapseAllRecipes()
	MainWindow.recipeTree:CollapseAll();
	for i, icon in pairs(MainWindow.allExpandIcons) do
		icon:SetBackground(Images.Expand);
	end
end


function UpdateSelectedRecipe()
	local node = MainWindow.recipeTree:GetSelectedNode();

	if node and node.recipe then
		UpdateRecipe(node.recipe, CurrentProfession);
	else
		UpdateRecipe(nil, nil);
	end

	MainWindow.quickSearchTextBox:SetText("");
end

function UpdateRecipe(recipe, profession)
	if recipe then
		MainWindow.tabControl:SetVisible(true);
		MainWindow.selectedRecipeControl:SetVisible(true);
		MainWindow.selectedRecipeTrackingControl:SetVisible(MainWindow.trackingTab:IsSelected());
		MainWindow.selectedRecipeDetailsControl:SetVisible(MainWindow.detailsTab:IsSelected());
		MainWindow.selectedRecipeLabel:SetText(recipe.name);
		MainWindow.selectedRecipeItem:SetItem(recipe.resultItemInfo, recipe.resultIcon, recipe.resultIconBack, 1);
		MainWindow.quickslotFailLabel:SetVisible(false);

		for i = 1, 8 do
			MainWindow.ingredientItems[i]:SetVisible(false);
			MainWindow.ingredientLabels[i]:SetVisible(false);
		end
		if recipe.ingredients then
			local ingredientCount = 1;
			for ingredientIndex, quantity in pairs(recipe.ingredients) do
				if ingredientCount <= 8 then
					local ingredient = IngredientList[ingredientIndex];
				
					MainWindow.ingredientItems[ingredientCount]:SetItem(ingredient.itemInfo, ingredient.icon, ingredient.iconBack, quantity);
					MainWindow.ingredientItems[ingredientCount]:SetVisible(true);

					MainWindow.ingredientLabels[ingredientCount]:SetText(ingredient.name);
					MainWindow.ingredientLabels[ingredientCount]:SetVisible(true);

					ingredientCount = ingredientCount + 1;
				end
			end
		end

		local knownList = {};
		local neededList = {};
		local neededSoonList = {};
		local recipeIndex = RecipeHash[recipe.name];
		for i = 1, #CharacterList do
			local character = CharacterList[i];
			local professionData = character.professions[profession];
			if professionData then
				if professionData.recipes[recipeIndex] then
					table.insert(knownList, character.name);
				else
					if recipe.tier <= (professionData.proficiencyLevel+1) then
						table.insert(neededList, character.name);
					else
						table.insert(neededSoonList, character.name);
					end
				end
			end
		end

		UpdateKnownAndNeededLists(knownList, neededList, neededSoonList);
	else
		MainWindow.selectedRecipeControl:SetVisible(false);
		MainWindow.tabControl:SetVisible(false);
	end
end

function UpdateQuickSearch(searchText)
	local searchTextLower = string.lower(searchText);
	local bestRecipeMatch = nil;
	local bestMatchPos = -1;
	local bestRecipeProfession = nil;

	if searchText ~= "" then
		for characterIndex = 1, #CharacterList do
			local character = CharacterList[characterIndex];
			for profession, professionData in pairs(character.professions) do
				-- Checking all recipes, not using hash because we want partial name matches
				for recipeIndex, v in pairs(professionData.recipes) do
					local recipe = RecipeList[recipeIndex];
					local matchPos = string.find(string.lower(recipe.name), searchTextLower, 1, true);
					if matchPos then
						if not bestRecipeMatch or matchPos < bestMatchPos then
							bestRecipeMatch = recipe;
							bestMatchPos = matchPos;
							bestRecipeProfession = profession;
						end
					end
				end
			end
		end
	end

	UpdateRecipe(bestRecipeMatch, bestRecipeProfession);
end

function UpdateQuickslotSearch()
	MainWindow.quickSearchTextBox:SetText("");

	local shortcut = MainWindow.recipeSearchQuickslot:GetShortcut();
	if shortcut and shortcut:GetType() ~= Turbine.UI.Lotro.ShortcutType.Undefined then
		MainWindow.quickslotFailLabel:SetVisible(false);

		local item = shortcut:GetItem();
		if item then
			local itemName = item:GetName();
			local recipeName = string.match(itemName, Strings.RecipeSearchPattern);
			if recipeName then
				MainWindow.tabControl:SetVisible(false);
				MainWindow.selectedRecipeControl:SetVisible(true);
				MainWindow.selectedRecipeTrackingControl:SetVisible(true);
				MainWindow.selectedRecipeDetailsControl:SetVisible(false);
				MainWindow.selectedRecipeLabel:SetText(Strings.RecipeSearchResults .. "\n" .. recipeName);
				MainWindow.selectedRecipeItem:SetItem(item:GetItemInfo(), nil, nil, 1);

				-- Prepare some alternate names, due to bad localization
				local searchTextArray = { recipeName };
				for pattern, replacement in pairs(Strings.RecipeMatchSubstitutions) do
					if string.find(recipeName, pattern, 1, true) then
						searchTextArray[#searchTextArray] = string.gsub(recipeName, pattern, replacement);
					end
				end

				-- Do the search
				ExecuteQuickslotSearch(searchTextArray);
			else
				MainWindow.quickslotFailLabel:SetVisible(true);
			end
		else
			MainWindow.quickslotFailLabel:SetVisible(true);
		end

		-- Clear the quickslot, prevent accidentally using the recipe!
		MainWindow.recipeSearchQuickslot:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Undefined, ""));
	end
end


function ExecuteQuickslotSearch(searchTextArray)
	local knownList = {};
	local knownFlags = {};
	local recipeProfession = nil;
	local recipeTier = nil;
	for characterIndex = 1, #CharacterList do
		local character = CharacterList[characterIndex];
		for profession, professionData in pairs(character.professions) do
			-- Checking all recipes, not using hash because we want partial name matches
			for recipeIndex, v in pairs(professionData.recipes) do
				local recipe = RecipeList[recipeIndex];
				local isFound = false;
				for i = 1, #searchTextArray do
					if string.find(recipe.name, searchTextArray[i], 1, true) then
						isFound = true;
						break;
					end
				end
				if isFound then
					table.insert(knownList, character.name);
					knownFlags[characterIndex] = true;
					recipeProfession = profession;
					recipeTier = recipe.tier;
					break;
				end
			end
		end
	end
	local neededList = {};
	local neededSoonList = {};
	if recipeProfession then
		for characterIndex = 1, #CharacterList do
			local character = CharacterList[characterIndex];
			local professionData = character.professions[recipeProfession];
			if professionData and not knownFlags[characterIndex] then
				if recipeTier <= (professionData.proficiencyLevel+1) then
					table.insert(neededList, character.name);
				else
					table.insert(neededSoonList, character.name);
				end
			end
		end
	else
		table.insert(neededList, Strings.AllCharactersWithProfession);
	end

	UpdateKnownAndNeededLists(knownList, neededList, neededSoonList);
end


function UpdateKnownAndNeededLists(knownList, neededList, neededSoonList)
	MainWindow.knownByList:SetText(table.concat(knownList, "\n"));
	MainWindow.knownByList:SetHeight(15*#knownList);

	MainWindow.neededByLabel:SetTop(35 + MainWindow.knownByList:GetHeight());
	MainWindow.neededByList:SetTop(20 + MainWindow.neededByLabel:GetTop());
	MainWindow.neededByList:SetText(table.concat(neededList, "\n"));
	MainWindow.neededByList:SetHeight(15*#neededList);

	MainWindow.neededSoonByList:SetTop(MainWindow.neededByList:GetTop() + MainWindow.neededByList:GetHeight());
	MainWindow.neededSoonByList:SetText(table.concat(neededSoonList, "\n"));
	MainWindow.neededSoonByList:SetHeight(15*#neededSoonList);
end


function ShowMainWindow()
	UpdatePlayerData(true);
	UpdateCharacter();
	MainWindow:SetVisible(true);
	Settings.isWindowVisible = true;
	UpdateMinimizedIcon();
end


function HideMainWindow()
	MainWindow:SetVisible(false);
	Settings.isWindowVisible = false;
	UpdateMinimizedIcon();
end


function UpdateMinimizedIcon()
	MainMinimizedIcon:SetVisible(Settings.isMinimizeEnabled and not Settings.isWindowVisible);
	MainMinimizedIcon:SetDefaultOpacity(Settings.minimizeOpacity);
end
