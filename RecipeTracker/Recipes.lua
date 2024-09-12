
function UpdatePlayerData(includeItemInfo)
	local player = Turbine.Gameplay.LocalPlayer.GetInstance();

	-- Get character data for the local player
	if not LocalPlayerCharacter then
		-- Must be first call, find the local player index
		localPlayerName = player:GetName();
		if string.sub(localPlayerName, 1, 1) == "~" then
			-- session play, just use the first and return without overwriting any real characters
			LocalPlayerCharacter = 1;
			return;
		else
			for i = 1, #CharacterList do
				if CharacterList[i].name == localPlayerName then
					LocalPlayerCharacter = i;
				end
			end
		end

		-- No existing character data, create new
		if not LocalPlayerCharacter then
			local newCharacter = { name = localPlayerName };
			table.insert(CharacterList, newCharacter);

			-- Keep sorted
			local characterSorter = function(character1, character2)
				return character1.name < character2.name;
			end
			table.sort(CharacterList, characterSorter);

			-- Find new index
			for i = 1, #CharacterList do
				if CharacterList[i].name == localPlayerName then
					LocalPlayerCharacter = i;
				end
			end
		end
	end

	local character = CharacterList[LocalPlayerCharacter];

	local playerAttr = player:GetAttributes();
	character.vocation = playerAttr:GetVocation();
	character.professions = nil;

	if character.vocation then
		character.professions = {};

		for k,v in pairs(Turbine.Gameplay.Profession) do
			local professionInfo = playerAttr:GetProfessionInfo(v);

			if professionInfo then
				local professionData = {};
			
				professionData.proficiencyLevel = professionInfo:GetProficiencyLevel();
				professionData.masteryLevel = professionInfo:GetMasteryLevel();

				professionData.proficiencyExp = professionInfo:GetProficiencyExperience();
				professionData.proficiencyExpTarget = professionInfo:GetProficiencyExperienceTarget();
				professionData.masteryExp = professionInfo:GetMasteryExperience();
				professionData.masteryExpTarget = professionInfo:GetMasteryExperienceTarget();

				professionData.recipes = {};
				for i = 1, professionInfo:GetRecipeCount() do
					local recipe = professionInfo:GetRecipe(i);
					local recipeName = recipe:GetName();
					local recipeIndex = RecipeHash[recipeName];
					local recipeData = nil;
					if recipeIndex then
						recipeData = RecipeList[recipeIndex];
					else
						recipeData = {};
						table.insert(RecipeList, recipeData);
						recipeIndex = #RecipeList;
						RecipeHash[recipeName] = recipeIndex;
					end

					recipeData.name = recipeName;
					recipeData.category = recipe:GetCategoryName();
					recipeData.tier = recipe:GetTier();

					local itemInfo = recipe:GetResultItemInfo();
					if includeItemInfo then
						recipeData.resultItemInfo = itemInfo;
					else
						recipeData.resultItemInfo = nil;
					end
					recipeData.resultIcon = itemInfo:GetIconImageID();
					recipeData.resultIconBack = itemInfo:GetBackgroundImageID();

					recipeData.ingredients = {};

					for j = 1, recipe:GetIngredientCount() do
						local ingredient = recipe:GetIngredient(j);
						local ingredientInfo = ingredient:GetItemInfo();
						local ingredientName = ingredientInfo:GetName();

						local ingredientIndex = IngredientHash[ingredientName];
						local ingredientData = nil;
						if ingredientIndex then
							ingredientData = IngredientList[ingredientIndex];
						else
							ingredientData = {};
							table.insert(IngredientList, ingredientData);
							ingredientIndex = #IngredientList;
							IngredientHash[ingredientName] = ingredientIndex;
						end

						ingredientData.name = ingredientName;
						if includeItemInfo then
							ingredientData.itemInfo = ingredientInfo;
						else
							ingredientData.itemInfo = nil;
						end
						ingredientData.icon = ingredientInfo:GetIconImageID();
						ingredientData.iconBack = ingredientInfo:GetBackgroundImageID();

						local quantity = ingredient:GetRequiredQuantity();

						recipeData.ingredients[ingredientIndex] = quantity;
					end

					professionData.recipes[recipeIndex] = true;
				end

				character.professions[v] = professionData;
			end
		end
	end

end

function GetTierName(tier)
	return Strings.TierNames[tier];
end

function GetProfessionName(profession)
	return Strings.ProfessionNames[profession];
end

function GetVocationName(vocation)
	for k, v in pairs(Turbine.Gameplay.Vocation) do
		if v == vocation then
			return k;
		end
	end
	return "Invalid vocation";
end

function CreateRecipeTree(recipes)
	local tree = {};

	for recipeIndex, v in pairs(recipes) do
		local recipe = RecipeList[recipeIndex];

		local tierTree = tree[recipe.tier];
		if not tierTree then
			tierTree = {};
			tree[recipe.tier] = tierTree;
		end

		local categoryTree = tierTree[recipe.category];
		if not categoryTree then
			categoryTree = {};
			tierTree[recipe.category] = categoryTree;
		end

		table.insert(categoryTree, recipe);
	end

	local recipeSorter = function(recipe1, recipe2)
		return recipe1.name < recipe2.name;
	end

	-- sorting, add a sorted category list in each tier, and sort the recipe list directly
	for tier, tierTree in pairs(tree) do
		local categoryList = {};
		for category, categoryTree in pairs(tierTree) do
			table.insert(categoryList, category);
			table.sort(categoryTree, recipeSorter);
		end

		table.sort(categoryList);
		tierTree.categoryList = categoryList;
	end

	return tree;
end



function BuildRecipeHash()
	RecipeHash = {};
	for i = 1, #RecipeList do
		local recipe = RecipeList[i];
		RecipeHash[recipe.name] = i;
	end
end

function BuildIngredientHash()
	IngredientHash = {};
	for i = 1, #IngredientList do
		local ingredient = IngredientList[i];
		IngredientHash[ingredient.name] = i;
	end
end


function UpgradeCharacterList()
	if #RecipeList ~= 0 then
		return false;
	end

	RecipeHash = {};

	for characterIndex = 1, #CharacterList do
		local character = CharacterList[characterIndex];
		for profession, professionData in pairs(character.professions) do
			professionData.recipeHash = nil;

			local newRecipes = {};
			for i = 1, #professionData.recipes do
				local recipe = professionData.recipes[i];
				local recipeIndex = RecipeHash[recipe.name];
				if not recipeIndex then
					table.insert(RecipeList, recipe);
					recipeIndex = #RecipeList;
					RecipeHash[recipe.name] = recipeIndex;
				end
				newRecipes[recipeIndex] = true;
			end
			professionData.recipes = newRecipes;
		end
	end

	return true;
end
