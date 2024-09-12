import "Turbine.UI"
import "Turbine.UI.Lotro"
import "Turbine.Gameplay"

import "Bowcosid.RecipeTracker.Class"
import "Bowcosid.RecipeTracker.Type"

import "Bowcosid.RecipeTracker.Commands"
import "Bowcosid.RecipeTracker.DropDown"
import "Bowcosid.RecipeTracker.Globals"
import "Bowcosid.RecipeTracker.MainWindow"
import "Bowcosid.RecipeTracker.MinimizedIcon"
import "Bowcosid.RecipeTracker.OfflineItemInfoControl"
import "Bowcosid.RecipeTracker.OptionsPanel"
import "Bowcosid.RecipeTracker.Recipes"
import "Bowcosid.RecipeTracker.Slider"
import "Bowcosid.RecipeTracker.Tab"
import "Bowcosid.RecipeTracker.VindarPatch"


Turbine.Gameplay.CraftTier.Apprentice = 1;
Turbine.Gameplay.CraftTier.Journeyman = 2;
Turbine.Gameplay.CraftTier.Expert = 3;
Turbine.Gameplay.CraftTier.Artisan = 4;
Turbine.Gameplay.CraftTier.Master = 5;
Turbine.Gameplay.CraftTier.Supreme = 6;
Turbine.Gameplay.CraftTier.Westfold = 7;
Turbine.Gameplay.CraftTier.Eastemnet = 8;
Turbine.Gameplay.CraftTier.Westemnet = 9;
Turbine.Gameplay.CraftTier.Anorien = 10;
Turbine.Gameplay.CraftTier.Doomfold = 11;
Turbine.Gameplay.CraftTier.Ironfold = 12;
Turbine.Gameplay.CraftTier.MinasIthil = 13;



Turbine.Shell.WriteLine("<rgb=#9ACD32>Recipe Tracker v2</rgb> <rgb=#DDDDDD>v. ".. plugin:GetVersion() .." by Bowcosid.</rgb>")

-- Load saved data
RecipeList = PatchDataLoad(Turbine.DataScope.Server, "RecipeTracker_RecipeList");
if not RecipeList then
	RecipeList = {};
end

IngredientList = PatchDataLoad(Turbine.DataScope.Server, "RecipeTracker_IngredientList");
if not IngredientList then
	IngredientList = {};
end

CharacterList = PatchDataLoad(Turbine.DataScope.Server, "RecipeTracker_CharacterList");
if not CharacterList then
	CharacterList = {};
end

-- Remove session characters that previous characters accidentally included
for i = 1, #CharacterList do
	if CharacterList[i] then
		if string.sub(CharacterList[i].name, 1, 1) == "~" then
			table.remove(CharacterList, i);
		end
	end
end

-- Load settings
Settings = PatchDataLoad(Turbine.DataScope.Account, "RecipeTracker_Settings");
if not Settings then
	Settings = {};
	Settings.windowX = 400;
	Settings.windowY = 200;
	Settings.isWindowVisible = true;
	Settings.isMinimizeEnabled = true;
	Settings.minimizeOpacity = 0.5;
	Settings.minimizeX = 1;
	Settings.minimizeY = Turbine.UI.Display.GetHeight()-32-1;
	Settings.version = plugin:GetVersion();
end

-- Handle data upgrades
if Settings.version == nil then
	if not UpgradeCharacterList() then
		Turbine.Shell.WriteLine("ERROR: RecipeTracker data corrupt, sorry, resetting all data...");
		RecipeList = {};
		CharacterList = {};
	end
end
Settings.version = plugin:GetVersion();

BuildRecipeHash();
BuildIngredientHash();

CreateLocalizationInfo();

plugin.Unload = function( sender, args )
	Turbine.Shell.WriteLine("<rgb=#9ACD32>Recipe Tracker:</rgb> <rgb=#DDDDDD>Unloading...</rgb>")

	-- Save data, without item infos
	UpdatePlayerData(false);
	PatchDataSave(Turbine.DataScope.Server, "RecipeTracker_RecipeList", RecipeList);
	PatchDataSave(Turbine.DataScope.Server, "RecipeTracker_IngredientList", IngredientList);
	PatchDataSave(Turbine.DataScope.Server, "RecipeTracker_CharacterList", CharacterList);

	-- Save settings
	PatchDataSave(Turbine.DataScope.Account, "RecipeTracker_Settings", Settings);
end

plugin.GetOptionsPanel = function(self)
	return OptionsPanel;
end

-- Get the latest local player data, including item info
UpdatePlayerData(true);

-- Set default character to the current character
CurrentCharacter = LocalPlayerCharacter;

CreateMainWindow();
CreateOptionsPanel();

RegisterCommands();
