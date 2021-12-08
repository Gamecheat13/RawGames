-- =============================================================================================================================
-- ============================================ ENCOUNTER DEBUG SCRIPTS ========================================================
-- =============================================================================================================================
-- _______   _______ .______    __    __    _______ 
--|       \ |   ____||   _  \  |  |  |  |  /  _____|
--|  .--.  ||  |__   |  |_)  | |  |  |  | |  |  __  
--|  |  |  ||   __|  |   _  <  |  |  |  | |  | |_ | 
--|  '--'  ||  |____ |  |_)  | |  `--'  | |  |__| | 
--|_______/ |_______||______/   \______/   \______| 
--## SERVER


--turns on a mode where the parcels and child parcels are shown on the imGUI


global g_parcelDebuggerShown = false;
global g_resizeParcelDebuggerWindow = false;
global g_parcelDebuggerFilter = nil;

function DebugParcels()
	if g_parcelDebuggerShown == true then
		ImGui_DeactivateCallback("sys_imGuiDebugParcels");
		g_parcelDebuggerShown = false;
	else
		ImGui_ActivateCallback("sys_imGuiDebugParcels");
		g_parcelDebuggerShown = true;
	end
end

function sys_imGuiDebugParcels()
	--button to resize window
	if g_resizeParcelDebuggerWindow == true then
		ImGui_SetNextWindowSize(500, 500);
		g_resizeParcelDebuggerWindow = false;
	end
	
	if ImGui_Begin("Parcel Debugger") == true then
		if ImGui_Button("  Resize Window  ") == true then
			g_resizeParcelDebuggerWindow = true;
		end

		if ImGui_Button("  Close Parcel Debugger  ") == true then
			DebugParcels();
		end
		
		local numActive:number = ParcelHandler:GetNumActiveParcels();
		local numTotal:number = ParcelHandler:GetNumPossibleParcels()
		local numPossible:number =  numTotal - numActive;

		ImGui_Text("Total Parcels: "..numTotal);
		ImGui_Text("Active Parcels: "..numActive);

		local parentParcels, childParcels = sys_GetParentChildParcelInfo();

		local numChildParcels:number = table.countKeys(childParcels);
		local numParentParcels:number = table.countKeys(parentParcels);

		--filter parcels by name
		g_parcelDebuggerFilter = ImGui_InputText("FILTER BY NAME:", g_parcelDebuggerFilter or "");
		--show parentless parcels
		sys_ShowParentlessParcels(numActive - numChildParcels - numParentParcels, parentParcels, childParcels);

		--show parent parcels
		sys_ShowParentParcels(numParentParcels, parentParcels);

		--show child parcels
		sys_ShowChildParcels(numChildParcels, childParcels);

		ImGui_Separator();
		--show stopped parcels
		sys_ShowStoppedParcels(numPossible);
	end
	ImGui_End();
end

function sys_ShowStoppedParcels(numPossible:number)
	ImGui_Text("Stopped Parcels: "..numPossible);
	ImGui_Indent();
		
	--show possible parcels
	for parcel, parcelName in hpairs(ParcelHandlerParcelReference.possibleParcels) do
		if ParcelHandlerParcelReference.activeParcels[parcel] == nil then
			if ImGui_Button("Force Start Parcel") == true then
				ParcelStart(parcel);
			end
			ImGui_AddTooltip("force start a parcel (use with caution, the parcel could easily stop 1 frame into starting)");
				
			ImGui_SameLine();
			ImGui_Text(parcelName);
		end
	end
	ImGui_Unindent();
end

function sys_ShowChildParcels(numChildParcels:number, childParcels:table)
	ImGui_Text("Child Parcels: "..numChildParcels);
	ImGui_Indent();
		for parcel, parcelTab in hpairs(childParcels) do
			sys_ShowParcel(parcelTab.parent, parcel, parcelTab.name);
		end
	ImGui_Unindent();
end

function sys_ShowParentParcels(numParentParcels:number, parentParcels:table)
	ImGui_Text("Parent Parcels: "..numParentParcels);
	ImGui_Indent();
	for parcel, parcelName in hpairs(parentParcels) do
		sys_ShowParcel(nil, parcel, parcelName);
	end
	ImGui_Unindent();
end

function sys_ShowParentlessParcels(numParcels:number, parentParcels:table, childParcels:table)
	ImGui_Text("Parentless Parcels: "..numParcels);
	ImGui_Indent();
	for parcel, parcelName in hpairs(ParcelHandlerParcelReference.activeParcels) do
		if parentParcels[parcel] == nil and childParcels[parcel] == nil then
			sys_ShowParcel(nil, parcel, parcelName);
		end
	end
	ImGui_Unindent();
end

function sys_GetParentChildParcelInfo()
	local parentParcels = {};
	local childParcels = {};

	--get all the info for parent and child parcels
	for parcel, parcelName in hpairs(ParcelHandlerParcelReference.activeParcels) do
		if parcel.childParcels ~= nil then
			parentParcels[parcel] = parcelName;
			for childParcel in set_elements(parcel.childParcels) do
				childParcels[childParcel] = {parent = parcel, name = ParcelHandlerParcelReference.activeParcels[childParcel]};
			end
		end
	end

	return parentParcels, childParcels;
end

function sys_ShowParcel(parentParcel:table, parcel:table, name:string)
	name = name or "??"
	if string.find(name:lower(), g_parcelDebuggerFilter) == nil then
		return;
	end
	ImGui_PushStringID(GetEngineString(parcel));
	if ImGui_Button("End Parcel") == true then
		ParcelEndChildParcel(parentParcel, parcel);
	end
	ImGui_AddTooltip("force ends a parcel (use with caution)");
	ImGui_SameLine();
	
	ImGui_SameLine();
	if ImGui_CollapsingHeader(name) == true then
		ImGui_Indent();
		sys_ShowParcelParentName(parentParcel);
		sys_ShowParcelInformation(parcel);
		sys_ShowChildParcelInformation(parcel);
		sys_ShowParcelEvents(parcel);
		ImGui_Unindent();
	end

	ImGui_PopID();
end

function sys_ShowParcelParentName(parentParcel:table)
	if parentParcel ~= nil then
		if ImGui_CollapsingHeader("Parent Parcel: "..ParcelHandlerParcelReference.activeParcels[parentParcel]) == true then
			sys_DebugTable(parentParcel);
		end
	end
end

function sys_ShowParcelInformation(parcel:table)
	if ImGui_CollapsingHeader("Parcel Information") == true then
		sys_DebugTable(parcel);
	end
end

function sys_ShowChildParcelInformation(parcel:table)
	if parcel.childParcels ~= nil then
		if ImGui_CollapsingHeader("Child Parcels") == true then
			ImGui_Indent();
			for parc in set_elements(parcel.childParcels) do
				sys_ShowParcel(parcel, parc, parc.parcelName);
			end
			ImGui_Unindent();
		end
	end
end

function sys_ShowParcelEvents(parcel:table)
	--make unique
	if parcel.storedEvents ~= nil then
		if ImGui_CollapsingHeader("Parcel Events") == true then
			ImGui_Indent();
			for event, onItem in hpairs(parcel.storedEvents) do
				--show the real name here
				ImGui_Text(table.getEnumValueAsString(g_eventTypes, event));
				sys_DebugTable(onItem);
			end
			ImGui_Unindent();
		end
	end
end