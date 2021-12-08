-- preprocess
-- Copyright (c) Microsoft. All rights reserved.

global ScriptImGuiCallbacks:table = 
{
	{ callback = "DynamicEventsDebug_ImGuiUpdate",	display = "Dynamic Events" },
	{ callback = "sys_EventDebugImGui",				display = "Event System" },
	{ callback = "sys_imGuiDebugParcels",			display = "Parcels" },
	
	--mission manager
	{ callback = "sys_DebugPoiActivator",			display = "POI Activators" },
	{ callback = "sys_ShowMissionManagerImGui",		display = "Mission Manager" },
	{ callback = "sys_ShowAllMissionsImGui",		display = "Mission Map Data" },

	{ callback = "sys_ShowCollectiblesImGui",		display = "Collectible Data" },
	{ callback = "sys_ShowUpgradesImGui",			display = "Equipment Upgrades" },
	
	--directives and AI
	{ callback = "sys_DebugDirectiveManagers",		display = "Directive Manager" },
	{ callback = "sys_DebugBloodGatesImGui",		display = "Blood Gates" },
	{ callback = "sys_DebugRando",					display = "Rando Debug" },
	{ callback = "sys_DebugWildlifeRando",			display = "Wildlife Rando Debug" },
	{ callback = "PhantomDropKitImGui",				display = "Phantom Drop Kit Debug" },

	--narrative
	{ callback = "sys_ShowNarrativeDebugger",		display = "Narrative Debug" },

	--other
	{ callback = "sys_todDebugImGui",				display = "Time of Day"},
	{ callback = "Valor_ImGuiUpdate",				display = "Valor" },
	{ callback = "sys_DebugOobImgui",				display = "Out of Bounds" },

	--objects and kits
	{ callback = "sys_allObjectsDebuggerImGui",		display = "Debug All Objects"},
	{ callback = "sys_allKitsDebuggerImGui",		display = "Debug All Kits" },
	{ callback = "sys_CommNodeDebuggerImGui",		display = "Debug All Comm Objects" },

	-- dungeons
	{ callback = "DallasDebugWindow",				display = "Dallas Debug" },
	{ callback = "HoustonDebugWindow",				display = "Houston Debug" },

	-- MP item spawners
	{ callback = "sys_DebugMPItemSpawnersImGUI",	display = "MP Item Spawners" },

	-- MP Vehicle Resupply
	{ callback = "sys_DebugMPVehicleResupplyKitsImGUI",	display = "MP Vehicle Resupply Kits" },

	{ callback = "HSImGuiFeatureTest", display = "Feature Test" },
	{ callback = "FunctionThatDoesntExistPleaseDontMakeThisExistJustToSpiteMyTest", display = "Oh no, what have I done?" },
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Tests
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

global HSImGuiFeatureTestVars =
{
	tabOne = true,
	tabTwo = false,
	float = 4,
	int = 7,
	string = "test string",
	bool = false,

	comboBox = "entry one",
	listBox = "entry two",
	stringEntries =
	{
		"entry one",
		"entry two",
		"entry three",
		"entry four",
		"entry five",
		"entry six"
	},

	dataSet = 
	{
		[1] = real_random_range(0, 47),
		[2] = real_random_range(0, 47),
		[3] = real_random_range(0, 47),
		[4] = real_random_range(0, 47),
		[5] = real_random_range(0, 47),
		[6] = real_random_range(0, 47),
		[7] = real_random_range(0, 47),
		[8] = real_random_range(0, 47),
		[9] = real_random_range(0, 47),
		[10] = real_random_range(0, 47),
	},
	
	progress = 0,
};

function HSImGuiFeatureTest():void
	ImGui_SetNextWindowSize(550, 550);
	if ImGui_Begin("Feature Test") == true then
		if ImGui_Button("Cause Script Error") == true then
			local we = nil;
			local here = we.go;
		end

		if ImGui_CollapsingHeader("Floats") == true then
			ImGui_DisplayFloat("DisplayFloat", HSImGuiFeatureTestVars.float);
			HSImGuiFeatureTestVars.float = ImGui_InputFloat("InputFloat", HSImGuiFeatureTestVars.float);
			HSImGuiFeatureTestVars.float = ImGui_SliderFloat("SliderFloat", HSImGuiFeatureTestVars.float, 0, 47);
		end

		if ImGui_CollapsingHeader("Ints") == true then
			ImGui_DisplayInt("DisplayInt", HSImGuiFeatureTestVars.int);
			HSImGuiFeatureTestVars.int = ImGui_InputInt("InputInt", HSImGuiFeatureTestVars.int);
			HSImGuiFeatureTestVars.int = ImGui_SliderInt("SliderInt", HSImGuiFeatureTestVars.int, 0, 47);
		end

		if ImGui_CollapsingHeader("Bools") == true then
			ImGui_DisplayBool("DisplayBool", HSImGuiFeatureTestVars.bool);
			HSImGuiFeatureTestVars.bool = ImGui_Checkbox("Checkbox", HSImGuiFeatureTestVars.bool);
		end

		if ImGui_CollapsingHeader("Text") == true then
			HSImGuiFeatureTestVars.string = ImGui_InputText("InputText", HSImGuiFeatureTestVars.string);
			ImGui_Text(HSImGuiFeatureTestVars.string);
		end

		if ImGui_CollapsingHeader("Selectables") == true then
			HSImGuiFeatureTestVars.comboBox = ImGui_ComboBox("Combo Box", HSImGuiFeatureTestVars.comboBox, HSImGuiFeatureTestVars.stringEntries);
			ImGui_Separator();
			HSImGuiFeatureTestVars.listBox = ImGui_ListBox("List Box", HSImGuiFeatureTestVars.listBox, HSImGuiFeatureTestVars.stringEntries);
		end

		if ImGui_CollapsingHeader("Number Stuff") == true then
			ImGui_PlotLines("PlotLines", HSImGuiFeatureTestVars.dataSet);
			ImGui_Separator();
			ImGui_PlotHistogram("PlotHistogram", HSImGuiFeatureTestVars.dataSet);
			ImGui_Separator();
			HSImGuiFeatureTestVars.progress = HSImGuiFeatureTestVars.progress + 0.001;
			if HSImGuiFeatureTestVars.progress >= 1 then
				HSImGuiFeatureTestVars.progress = 0;
			end
			ImGui_ProgressBar("ProgressBar", HSImGuiFeatureTestVars.progress);
		end

		if ImGui_CollapsingHeader("Tabs") == true then
			if ImGui_BeginTabBar("TabsTest") == true then
				if ImGui_BeginTabItem("Tab One") == true then
					ImGui_Text("Tab One Contents");
					ImGui_EndTabItem();
				end

				if ImGui_BeginTabItem("Tab Two") == true then
					ImGui_Text("Tab Two Contents");
					ImGui_EndTabItem();
				end

				ImGui_EndTabBar();
			end
		end

		if ImGui_CollapsingHeader("Colors") == true then
			local red = color_rgba(1, 0, 0, 1);
			local green = color_rgba(0, 1, 0, 1);
			local blue = color_rgba(0, 0, 1, 1);

			ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Text, red);
			ImGui_Text("Colored Text");
			ImGui_PopStyleColor();

			ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_Button, blue);
			ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_ButtonHovered, green);
			ImGui_PushStyleColor(IMGUI_STYLE_COLOR.ImGuiCol_ButtonActive, red);
			ImGui_Button("Button");
			ImGui_PopStyleColor();
			ImGui_PopStyleColor();
			ImGui_PopStyleColor();
		end

		if ImGui_CollapsingHeader("Columns") == true then
			ImGui_Columns(3);

			ImGui_Text("Row 1, Column 1");
			ImGui_NextColumn();

			ImGui_Text("Row 1, Column 2");
			ImGui_NextColumn();

			ImGui_Text("Row 1, Column 3");
			ImGui_NextColumn();

			ImGui_Text("Row 2, Column 1");
			ImGui_NextColumn();

			ImGui_Text("Row 2, Column 2");
			ImGui_NextColumn();

			ImGui_Text("Row 2, Column 3");
			
			ImGui_Columns(1);

			ImGui_Separator();

			ImGui_Columns(4);
			ImGui_SetColumnWidth(0, 100);
			ImGui_SetColumnWidth(1, 125);
			ImGui_SetColumnWidth(2, 150);
			ImGui_SetColumnWidth(3, 175);

			ImGui_Text("100 Width");
			ImGui_NextColumn();

			ImGui_Text("125 Width");
			ImGui_NextColumn();

			ImGui_Text("150 Width");
			ImGui_NextColumn();

			ImGui_Text("175 Width");

			ImGui_Columns(1);
		end

		if ImGui_CollapsingHeader("Child Windows") == true then
			if ImGui_BeginChild("ChildWindowOne", 0, 0, false) == true then
				ImGui_Text("Auto sizing, no border");
			end
			ImGui_EndChild();

			if ImGui_BeginChild("ChildWindowTwo", 250, 100, true) == true then
				ImGui_Text("Static sizing, with border");
			end
			ImGui_EndChild();

			if ImGui_BeginChild("ChildWindowThree", 0, 100, true) == true then
				ImGui_Text("Mixed sizing, with border");
			end
			ImGui_EndChild();
		end

	end
	ImGui_End();
end