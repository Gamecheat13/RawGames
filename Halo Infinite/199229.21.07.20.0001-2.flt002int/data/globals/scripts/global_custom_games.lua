-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------
--   ______  __    __       _______..___________.  ______   .___  ___.      _______      ___      .___  ___.  _______      _______.      --
--  /      ||  |  |  |     /       ||           | /  __  \  |   \/   |     /  _____|    /   \     |   \/   | |   ____|    /       |      --
-- |  ,----'|  |  |  |    |   (----``---|  |----`|  |  |  | |  \  /  |    |  |  __     /  ^  \    |  \  /  | |  |__      |   (----`      --
-- |  |     |  |  |  |     \   \        |  |     |  |  |  | |  |\/|  |    |  | |_ |   /  /_\  \   |  |\/|  | |   __|      \   \          --
-- |  `----.|  `--'  | .----)   |       |  |     |  `--'  | |  |  |  |    |  |__| |  /  _____  \  |  |  |  | |  |____ .----)   |         --
--  \______| \______/  |_______/        |__|      \______/  |__|  |__|     \______| /__/     \__\ |__|  |__| |_______||_______/          --
--                                                                                                                                       --
-------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------


hstructure ModePrerequisiteBaseArgs
	objectId 	:number;
	objectName 	:string_id;
	objectDisplayName :string;
	objectType 	:number;
end

hstructure ModePrerequisiteTeamArgs:ModePrerequisiteBaseArgs
	owningTeam	:mp_team_designator;
end

hstructure OptionSet
	metadata 				:table; --data connecting this option set to a particular parcel
	PARAMS					:table;	--enum table, for simplifying the use of strings for parameter names (must match the variable names in parcel.CONFIG)
	paramData				:table;	--the options associated with this option set
	orderParamArray			:table;	--same elements as paramData, but contained in an array ordered for display in the menu (see CreateUIParameter())
	modePrerequisites 		:table;	--Prerequisities this mode may have for a map inorder to run correctly
end

-- Hstruct definitions for UI
hstructure VariantFloatParam
	displayName				:string_id;
	description				:string_id;
	values 					:table;  -- list of UI markup values w/ localized strings;
	defaultValue 			:number; -- The initial value to be selected on the menu
	variantPropertyName 	:string_id;	--the name of this property in the variant
end

hstructure VariantBoolParam
	displayName				:string_id;
	description				:string_id;
	values 					:table;
	defaultValue 			:boolean;
	variantPropertyName 	:string_id;
end

hstructure VariantStringIdParam
	displayName				:string_id;
	description				:string_id;
	values 					:table;
	defaultValue 			:string_id;
	variantPropertyName 	:string_id;
end

hstructure VariantEngineParam
	displayName				:string_id;
	description				:string_id;
	values 					:table;
	defaultValue 			:any;
	engineReflectionString	:string;
end

-- Table that will be iterated when generating custom game options for a given variant. All options tables should have an entry on this table
global g_CustomGameOptionSets:table = {};

global GlobalCustomGameValueSets:table = 
{
	TrueFalse =
	{
		{ value = 1, displayString = Engine_ResolveStringId("cgui_true") },
		{ value = 0, displayString = Engine_ResolveStringId("cgui_false") },
	},
	EnabledDisabled =
	{
		{ value = 1, displayString = Engine_ResolveStringId("cgui_enabled") },
		{ value = 0, displayString = Engine_ResolveStringId("cgui_disabled") },
	},
};


--This function expects the format of the ui string to be cgui_VALUE_TYPE, e.g cgui_1_points
--You can find these strings in custom_games_ui.txt
function GenerateCustomUIString(value:number, postfix:string):string
	return "cgui_" .. tostring(value) .. postfix;
end

--The function helps creates an array of pairs (value, stringID) for a given range, with a given step value.
function GenerateAndAppendOptionValuesFromRange(valueArr:table, startValue:number, endValue:number, stepValue:number,  postfix:string)
	--if no values are present, add the start value
	local initialValue = startValue;
	if valueArr[#valueArr] ~= nil and valueArr[#valueArr].value == startValue then
		initialValue = startValue + stepValue;
	end
	
	for val = initialValue, endValue, stepValue do
		table.insert(valueArr, {value = val, displayString = Engine_ResolveStringId(GenerateCustomUIString(val, postfix))});
	end
end

--This function allows for the adding of one off values, that cannot be handled by the GenerateOptionValuesFromRange
--e.g. NumberOfRounds = { 0,1,2, Unlimited}
function AppendSpecificOptionValue(valueArr:table, value:number, uiString:string)
	table.insert(valueArr, {value = value, displayString = Engine_ResolveStringId(uiString)});
end

function OptionSetGetParamData(optionSet:OptionSet, paramName:string):table
	local parameter = optionSet.PARAMS[paramName];
	assert(parameter ~= nil, string.format("No parameter with the name '%s' could be found in the OptionSet.", paramName));
	assert(optionSet.paramData[parameter] ~= nil, string.format("Could not find paramData for parameter '%s' in the OptionSet.", paramName));
	return optionSet.paramData[parameter];
end

function OptionSetGetParamDataValues(optionSet:OptionSet, paramName:string):table
	return OptionSetGetParamData(optionSet, paramName).values;
end

function OptionSetAppendRangeForParam(optionSet:OptionSet, paramName:string, startValue:number, endValue:number, stepValue:number, postFix:string):void
	GenerateAndAppendOptionValuesFromRange(OptionSetGetParamDataValues(optionSet, paramName), startValue, endValue, stepValue, postFix);
end

-- Range table is a table of tables with three numbers in them, startValue, endValue, stepValue.
-- Equivalent to calling OptionSetAppendRangeForParam on each set of range tables
-- Ranges can also contain a string and a value which will manually insert that option
-- into the list. This is useful for things that need a 'nil' option to specify 'Default' or 'Any'
-- ex. 
-- OptionSetAppendRangeListForParam(optionSet, "MyTimeBasedParameter", "_seconds", {
--	   { "cgui_default", nil },    -- will display "Default" in ui and pass nil to the parameter
--     { 1, 10, 1 },
--     { 10, 12, 2 },
--     { 12, 15, 3 },
--     { 15, 60, 5 },});
--
-- This creates parameter options of 1, 2, 3, ..., 10, 12, 15, 20, 25, ..., 60
--
function OptionSetAppendRangeListForParam(optionSet:OptionSet, paramName:string, postFix:string, ranges:table):void
	for _, range in ipairs(ranges) do
		if (type(range[1]) == "number") then
			assert(type(range[2]) == "number");
			assert(type(range[3]) == "number");
			OptionSetAppendRangeForParam(optionSet, paramName, range[1], range[2], range[3], postFix);
		elseif (type(range[1]) == "string") then
			local valueArr:table = OptionSetGetParamDataValues(optionSet, paramName);
			table.insert(valueArr, {value = range[2], displayString = Engine_ResolveStringId(range[1])});
		end
	end
end

function OptionSetAppendForParam(optionSet:OptionSet, paramName:string, value:number, uiString:string):void
	AppendSpecificOptionValue(OptionSetGetParamDataValues(optionSet, paramName), value, uiString);
end

function OptionSetAppendListForParam(optionSet:OptionSet, paramName:string, list:table):void
	local valueTable:table = OptionSetGetParamDataValues(optionSet, paramName);
	local base:number = #valueTable;

	for i, uiString in ipairs(list) do
		assert(type(uiString) == "string");
		OptionSetAppendForParam(optionSet, paramName, i + base, uiString);
	end
end

function OptionSetAssignValuesForParam(optionSet:OptionSet, paramName:string, valueArr:table)
	OptionSetGetParamData(optionSet, paramName).values = valueArr;
end

function LoadVariantParametersForParcel(parcelInstance:table, optionSetName:string):void
	local options:OptionSet = _G[optionSetName];

	--this nil check is required if a particular variant doesn't support UI markups, but utilizes a shared script with ones that do.
	--Example. CTF/BTB doesn't have UI markups (as of 07/10/2020), but uses the same ModeCTF.lua as the others. That script calls this function.
	if (options == nil) then
		return;
	end

	for paramName, paramDef in hpairs(options.paramData) do
		local paramVariantPropertyName:string = options.metadata.variantPrefix .. paramName;
		if (Variant_DoesPropertyExist(paramVariantPropertyName)) then
			local paramTypeName:string = struct.name(paramDef);
			local paramValue = nil;

			if (paramTypeName == "VariantFloatParam") then
				paramValue = Variant_GetFloatProperty(paramVariantPropertyName);
			elseif (paramTypeName == "VariantBoolParam") then
				paramValue = Variant_GetBoolProperty(paramVariantPropertyName);
			elseif (paramTypeName == "VariantStringIdParam") then
				paramValue = Variant_GetStringIdProperty(paramVariantPropertyName);
			elseif (paramTypeName == "VariantEngineParam") then
				--paramValue = -- Go through the C++ reflection system
			end

			parcelInstance.CONFIG[paramName] = paramValue;
		end
	end
end

-- called by tool in C++; applies the default values for all variant params against the variant, creating entries that can be reflected against to be read by the UI
function ApplyParametersToVariant():void
	for _, optionSet in hpairs(g_CustomGameOptionSets) do
		for paramName, paramDef in hpairs(optionSet.paramData) do
				local paramVariantPropertyName:string = optionSet.metadata.variantPrefix .. paramName;
				local paramTypeName:string = struct.name(paramDef);
				local defaultValue = nil;

				-- Find the default value for this param and create the game variant property
				if (paramTypeName == "VariantFloatParam") then
					defaultValue = GetDefaultValue_FloatParam(optionSet.metadata.parcelType, paramName);
					Variant_CreateFloatProperty(paramVariantPropertyName, defaultValue);
				elseif (paramTypeName == "VariantBoolParam") then
					defaultValue = GetDefaultValue_BoolParam(optionSet.metadata.parcelType, paramName);
					Variant_CreateBoolProperty(paramVariantPropertyName, defaultValue);
				elseif (paramTypeName == "VariantStringIdParam") then
					defaultValue = GetDefaultValue_StringIdParam(optionSet.metadata.parcelType, paramName);
					Variant_CreateStringIdProperty(paramVariantPropertyName, defaultValue);
				elseif (paramTypeName == "VariantEngineParam") then				
					print("Error: Engine Params Not Yet Unsupported");
				end

				-- Set the default value and variant property name back onto the hstruct for later
				paramDef.defaultValue = defaultValue;
				if (paramTypeName ~= "VariantEngineParam") then
					paramDef.variantPropertyName = paramVariantPropertyName;
				end
		end

		for _, prerequisite in hpairs(optionSet.modePrerequisites) do
			local createResult = false;

			if (prerequisite.owningTeam ~= nil) then
				createResult = Variant_CreateDataDependencyRequiredTeamObject(prerequisite.objectName, prerequisite.objectDisplayName, prerequisite.objectType, prerequisite.owningTeam);
			else
				createResult = Variant_CreateDataDependencyRequiredObject(prerequisite.objectName, prerequisite.objectDisplayName, prerequisite.objectType);
			end

			if (createResult == false) then
				print("ERROR! Unable to create duplicate prerequisite [" .. prerequisite.objectName .. "] object in game variant!");
			end
		end
	end
end

function VerifyGameVariantPrerequisitesFromMapVariant():boolean
	local result = true;
	
	for _, optionSet in hpairs(g_CustomGameOptionSets) do
		for _, prerequisite in hpairs(optionSet.modePrerequisites) do
			local localResult = true;
			if (prerequisite.owningTeam ~= nil) then
				localResult = VerifyPrerequisiteGameModeTeamObjectLabelInMap(prerequisite.objectName, prerequisite.objectType, prerequisite.owningTeam);
			else
				localResult = VerifyPrerequisiteGameModeObjectLabelInMap(prerequisite.objectName, prerequisite.objectType);
			end

			if (localResult == false) then
				result = false;
				print("ERROR! Unable to find [" .. prerequisite.objectName .. "] in Map Variant!");
			end
		end
	end

	return result;
end

--called by tool in C++; it generates all of the markup that will be read by the UI
--lots of pseudo code here
function GenerateCustomGameOptionsMarkup(currentMarkupParentHandle):void
	for _, optionSet in hpairs(g_CustomGameOptionSets) do
		local menuHandle = CustomGamesMarkup_AddNewMenu(
			currentMarkupParentHandle,
			optionSet.metadata.localizedName,
			optionSet.metadata.localizedDescription
			);
		

		for _, paramDef in ipairs(optionSet.orderParamArray) do
			local paramTypeName:string = struct.name(paramDef);
			local engineType = GetTypeFromParamTypeName(paramTypeName);

			local entryHandle = CustomGamesMarkup_AddEntry(
				menuHandle,
				engineType, -- this will include the info of if this is a VariantProperty or engine binding
				paramDef.displayName,
				paramDef.description,
				paramDef.variantPropertyName-- or paramDef.engineReflectionString -- whichever one is applicable
				);

			for _, entry in hpairs(paramDef.values) do 
				CustomGamesMarkup_AddValueForEntry(entryHandle, entry.value, entry.displayString);
			end
		end

	end
end


--
-- Helpers
--

function GetDefaultValue_FloatParam(parcelTypeName:string, paramName:string):number
	local paramDefaultValue = nil;
	local parcel = _G[parcelTypeName];
	if (parcel ~= nil) then
		paramDefaultValue = parcel.CONFIG[paramName];
	end

	if (paramDefaultValue == nil) then
		paramDefaultValue = 0;
	end

	return paramDefaultValue;
end

function GetDefaultValue_BoolParam(parcelTypeName:string, paramName:string):boolean
	local paramDefaultValue = nil;
	local parcel = _G[parcelTypeName];
	if (parcel ~= nil) then
		paramDefaultValue = parcel.CONFIG[paramName];
	end

	if (paramDefaultValue == nil) then
		paramDefaultValue = false;
	end

	return paramDefaultValue;
end

function GetDefaultValue_StringIdParam(parcelTypeName:string, paramName:string):number
	local paramDefaultValue = nil;
	local parcel = _G[parcelTypeName];
	if (parcel ~= nil) then
		paramDefaultValue = parcel.CONFIG[paramName];
	end

	if (paramDefaultValue == nil) then
		paramDefaultValue = k_emptyStringId;
	end

	return paramDefaultValue;
end

function CreateUIParameter(parentStruct:OptionSet, parameterName:string, parameterStruct, uiName:string, uiDescription:string)
	parameterStruct.displayName = uiName;
	parameterStruct.description = uiDescription;
	parameterStruct.values = {};
	parentStruct.paramData[parameterName] = parameterStruct;
	table.insert(parentStruct.orderParamArray, parameterStruct);
end

-- Creates a UI parameter as a VariantBoolParam and assigns it options defined in valueTable
-- Most common uses are defined in GlobalCustomGameValueSets such as GlobalCustomGameValueSets.TrueFalse or GlobalCustomGameValueSets.EnabledDisabled
function CreateUIBooleanParameter(optionSet:OptionSet, paramName:string, labelId:string, descriptionId:string, valueTable:table):void
	assert(optionSet.PARAMS[paramName] ~= nil);
	CreateUIParameter(optionSet, optionSet.PARAMS[paramName], hmake VariantBoolParam{}, labelId, descriptionId);
	OptionSetAssignValuesForParam(optionSet, paramName, valueTable);
end
