
function RegisterCommands()
	MainCommand = Turbine.ShellCommand();

	function MainCommand:Execute(command, arguments)
		if arguments == "show" then
			ShowMainWindow();
		elseif arguments == "hide" then
			HideMainWindow();
		elseif arguments == "toggle" then
			if MainWindow:IsVisible() then
				HideMainWindow();
			else
				ShowMainWindow();
			end
		elseif arguments == "options" then
			Turbine.PluginManager.ShowOptions(Plugins["RecipeTracker v2"]);
		else
			Turbine.Shell.WriteLine(Strings.Usage);
		end
	end

	function MainCommand:GetHelp()
		return Strings.Usage;
	end

	function MainCommand:GetShortHelp()
		return Strings.Usage;
	end

	Turbine.Shell.AddCommand("recipetracker", MainCommand);
end





