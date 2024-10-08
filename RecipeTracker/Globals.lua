ResourcePath = "Bowcosid/RecipeTracker/Resources/";

Images = {
	MinimizedIcon = ResourcePath .. "RecipeTrackerIcon.tga",
	Expand = ResourcePath .. "expand_button.tga",
	ExpandAll = ResourcePath .. "expand_all_button.tga",
	Collapse = ResourcePath .. "collapse_button.tga",
	CollapseAll = ResourcePath .. "collapse_all_button.tga",
	Proficient = ResourcePath .. "icon_craft_proficient.tga",
	Master = ResourcePath .. "icon_craft_master.tga",
	Refresh = ResourcePath .. "button_refresh.tga",
	TabBase = ResourcePath .. "tab_tier1_middle_";
};
	-- à = \195\160
    -- â = \195\162
    -- á = \195\161
	-- ä = \195\164
    -- Ä = \195\132
	-- é = \195\169
	-- è = \195\168
    -- ê = \195\170
    -- ú = \195\186
    -- û = \195\187
    -- ü = \195\188
	-- ö = \195\182
    -- ó = \195\179
	-- ß = \195\159
    -- í = \195\173
    -- Û = \195\155
    -- ù = \195\185
	-- Ü =\195\156

-- added the french translation by Homeopatix
function CreateLocalizationInfo()
	Strings = {};
	Strings.TierNames = {};
	Strings.ProfessionNames = {};
	Strings.RecipeMatchSubstitutions = {};
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		Strings.Usage = "Verwendung:\n   /recipetracker show - Zeigt das Hauptfenster\n   /recipetracker hide - Versteckt das Hauptfenster\n   /recipetracker toggle - Schaltet das Hauptfenster um\n   /recipetracker options - Zeigt die Optionen";
		Strings.PluginName = "Rezept Tracker v2";
		Strings.Search = "Suche:";
		Strings.KnownBy = "Bereits gelernt von:";
		Strings.NeededBy = "Ben\195\182tigt von:";
		Strings.RecipeSearch = "Rezeptsuche";
		Strings.DragToSearch = "<- zum Vergleich Rezept hier reinziehen";
		Strings.NotRecipe = "Dies ist kein Rezept!";
		Strings.RecipeSearchResults = "Resultate der Rezeptsuche:";
		Strings.AllCharactersWithProfession = "Alle Character mit diesem Beruf";
		Strings.Tracking = "Tracking";
		Strings.Details = "Details";
		Strings.Ingredients = "Zutaten:";
		Strings.RecipeSearchPattern = "^Rezept: (.+)";
		Strings.SearchByName = "Suche:";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Apprentice] = "Lehrling";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Journeyman] = "Geselle";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Expert] = "Experte";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Artisan] = "Virtuose";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Master] = "Meister";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Supreme] = "\195\156berragend";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Westfold] = "Westfold";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Eastemnet] = "Ost-Emnet";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Westemnet] = "West-Emnet";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Anorien] = "Anórien";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Doomfold] = "Unheilskluft";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Ironfold] = "Eisenbruch";
		Strings.TierNames[Turbine.Gameplay.CraftTier.MinasIthil] = "Minis Ithil";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Gundabad] = "Gundabad";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Umbar] = "Umbar";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Tailor] = "Schneider";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Woodworker] = "Drechsler";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Farmer] = "Bauer";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Cook] = "Koch";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Jeweller] = "Goldschmied";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Scholar] = "Gelehrter";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Weaponsmith] = "Waffenschmied";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Metalsmith] = "Schmied";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Forester] = "F\195\182rster";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Prospector] = "Sch\195\188rfer";
		Strings.RecipeMatchSubstitutions["Ostemnet"] = "Ost-Emnet";
		Strings.RecipeMatchSubstitutions["Ost-Emnet"] = "Ostemnet";
		Strings.RecipeMatchSubstitutions["Werkzeuge des Ost-Emnet-Entdeckers"] = "Ost-Emnet-Entdecker-Werkzeuge";
		Strings.RecipeMatchSubstitutions["Zwergenstahl-Sch\195\164rfwerkzeug"] = "Sch\195\164rfwerkzeuge aus Zwergenstahl";
		Strings.RecipeMatchSubstitutions["Schneiderwerkzeug aus uraltem Eisen"] = "Schneiderwerkzeuge aus uraltem Eisen";
		Strings.RecipeMatchSubstitutions["Meissel (Stufe 75)"] = "�berragender Calenard-Meissel";
		Strings.RecipeMatchSubstitutions["Farbe Indigo"] = "Indigo-Farbe";
		Strings.RecipeMatchSubstitutions["Farbe \"Evendim\"-Blau"] = "Blaue Farbe \"Evendim\"";
		Strings.RecipeMatchSubstitutions["Durchtr�nktes Nestad-Pergament der Westfold"] = "Nestad-Pergament der Westfold";
		Strings.RecipeMatchSubstitutions["Durchtr�nktes Dagor-Pergament der Westfold"] = "Dagor-Pergament der Westfold";
		Strings.RecipeMatchSubstitutions["Westfold-Schilddorn-Ausr�stsatz: Beleriand-Art"] = "Schilddorn-Ausr�stsatz der Westfold: Beleriand-Art";
		Strings.RecipeMatchSubstitutions["B�renfalle (Stufe 75)"] = "Messerscharfe B�renfalle";
		Strings.RecipeMatchSubstitutions["Gepr�gtes Westfold-Wappen"] = "Gepr�gtes Wappen der Westfold";
		Strings.RecipeMatchSubstitutions["Waffenmeister-Horn (Stufe 75)"] = "Feldzugshorn";
		Strings.RecipeMatchSubstitutions["Westfold-�berw�ltigungstaktik"] = "�berw�ltigungstaktik der Westfold";
		Strings.RecipeMatchSubstitutions["Lochfeile (Stufe 70)"] = "Calenard-Lochfeile";
		Strings.RecipeMatchSubstitutions["Meissel (Stufe 70)"] = "Calenard-Meissel";
		Strings.RecipeMatchSubstitutions["B�renfalle (Stufe 70)"] = "Messerscharfe B�renfalle";
		Strings.RecipeMatchSubstitutions["Beutel Murmeln (Stufe 70)"] = "Calenard-Murmeln";
		Strings.RecipeMatchSubstitutions["Calenard-Kr�henf�sse"] = "Calenard-Kr�henf��";
		Strings.RecipeMatchSubstitutions["�berragendes Eichen-Horn"] = "�berragendes Eichen-Feldzugshorn";
		Strings.RecipeMatchSubstitutions["Rote Achat-Brosche"] = "Rotee Achat-Brosche";
		Strings.RecipeMatchSubstitutions["�berragende Riddermark-Kr�henf�sse"] = "�berragender Riddermark-Kr�henfu�";
		Strings.RecipeMatchSubstitutions["Leichter Schild des H�ters"] = "Leichter Schild des W�chters";
		Strings.RecipeMatchSubstitutions["Schwere Blankstahl-Schwert"] = "Schweres Blankstahl-Schwert";
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		Strings.Usage = "Utilisation:\n   /recipetracker show - montrer la fenetre principale\n   /recipetracker hide - Cacher la fenetre principale\n   /recipetracker toggle - Bascule la fenetre principale\n   /recipetracker options - Montrer la fenetre d'options";
		Strings.PluginName = "Recettes Tracker";
		Strings.Search = "Rech:";
		Strings.KnownBy = "D\195\169j\195\160 connu par:";
		Strings.NeededBy = "En a besoin:";
		Strings.RecipeSearch = "Chercher une recette";
		Strings.DragToSearch = "<- Tirer une recette ici pour rechercher";
		Strings.NotRecipe = "Ce n'est pas une recette!";
		Strings.RecipeSearchResults = "R\195\169sultat de la recherche de recette:";
		Strings.AllCharactersWithProfession = "Tous les perso avec cette profession";
		Strings.Tracking = "Chercher";
		Strings.Details = "D\195\169tails";
		Strings.Ingredients = "Ingr\195\169dients:";
		Strings.RecipeSearchPattern = "(.+) Recipe$";
		Strings.SearchByName = "Ou rechercher par nom:";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Apprentice] = "Apprenti";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Journeyman] = "Compagnon";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Expert] = "Expert";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Artisan] = "Artisan";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Master] = "Ma\195\174tre";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Supreme] = "Supr\195\170me";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Westfold] = "Ouestfolde";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Eastemnet] = "Estemnet";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Westemnet] = "Ouestemnet";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Anorien] = "An\195\182rien";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Doomfold] = "Folde du Destin";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Ironfold] = "Crevasse de fer";
		Strings.TierNames[Turbine.Gameplay.CraftTier.MinasIthil] = "Minas Ithil";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Gundabad] = "Gundabad";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Umbar] = "Umbar";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Tailor] = "Tailleur";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Woodworker] = "Menuisier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Farmer] = "Fermier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Cook] = "Cuisinier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Jeweller] = "Bijoutier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Scholar] = "Erudit";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Weaponsmith] = "Armurier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Metalsmith] = "Ferronnier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Forester] = "Forestier";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Prospector] = "Proscpecteur";
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		Strings.Usage = "Usage:\n   /recipetracker show - Shows the main window\n   /recipetracker hide - Hides the main window\n   /recipetracker toggle - Toggles the main window\n   /recipetracker options - Shows the options window";
		Strings.PluginName = "Recipe Tracker v2";
		Strings.Search = "Search:";
		Strings.KnownBy = "Already known by:";
		Strings.NeededBy = "Needed by:";
		Strings.RecipeSearch = "Recipe Search";
		Strings.DragToSearch = "<- Drag a recipe here to search";
		Strings.NotRecipe = "Not a recipe!";
		Strings.RecipeSearchResults = "Recipe search results:";
		Strings.AllCharactersWithProfession = "All characters with this profession";
		Strings.Tracking = "Tracking";
		Strings.Details = "Details";
		Strings.Ingredients = "Ingredients:";
		Strings.RecipeSearchPattern = "(.+) Recipe$";
		Strings.SearchByName = "Or search by name:";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Apprentice] = "Apprentice";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Journeyman] = "Journeyman";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Expert] = "Expert";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Artisan] = "Artisan";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Master] = "Master";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Supreme] = "Supreme";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Westfold] = "Westfold";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Eastemnet] = "Eastemnet";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Westemnet] = "Westemnet";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Anorien] = "Anorien";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Doomfold] = "Doomfold";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Ironfold] = "Ironfold";
		Strings.TierNames[Turbine.Gameplay.CraftTier.MinasIthil] = "Minas Ithil";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Gundabad] = "Gundabad";
		Strings.TierNames[Turbine.Gameplay.CraftTier.Umbar] = "Umbar";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Tailor] = "Tailor";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Woodworker] = "Woodworker";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Farmer] = "Farmer";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Cook] = "Cook";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Jeweller] = "Jeweller";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Scholar] = "Scholar";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Weaponsmith] = "Weaponsmith";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Metalsmith] = "Metalsmith";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Forester] = "Forester";
		Strings.ProfessionNames[Turbine.Gameplay.Profession.Prospector] = "Prospector";
	end
end
