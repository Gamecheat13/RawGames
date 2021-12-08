-- Copyright (c) Microsoft. All rights reserved.


global TagFilterClass = table.makePermanent
{
	data = {},
	count = 0;
};

-- A struct to help map required tags to variants
hstructure TagFilterDataStruct
	allowedVariants:table;
	totalVariants:number;
end

function TagFilterClass:New():table
	local newTagFilter:table = table.addMetatableRecursive(self);

	return newTagFilter;
end

function TagFilterClass:Add(tagDefinition:tag, variantID:string):void
	if not IsValidTag(tagDefinition) then return; end

	local tagFilterData:TagFilterDataStruct = self.data[tagDefinition];

	if tagFilterData ~= nil then		
		-- If the variant id is assigned, and we don't have it in the list already, it will add the new variant id to the list of allowed variants
		-- Otherwise, this will assume that all variants are allowed
		if not stringIsNullOrEmpty(variantID) then
			local variantIDToStringID:string_id = get_string_id_from_string(variantID);
			if tagFilterData.allowedVariants[variantIDToStringID] == nil then
				tagFilterData.allowedVariants[variantIDToStringID] = true;
				tagFilterData.totalVariants = tagFilterData.totalVariants + 1;
			else
				dprint("TagFilterClass: Variant is already included in filter.");
			end
		else
			if tagFilterData.totalVariants > 0 then
				dprint("TagFilterClass: Clearing variants from tag because the variant id passed in was empty or nil. Was this intentional?");
			end

			tagFilterData.allowedVariants = {};
			tagFilterData.totalVariants = 0;
		end
	else
		local newTagFilterData:TagFilterDataStruct = hmake TagFilterDataStruct
		{
			allowedVariants = {},
			totalVariants = 0
		};

		if not stringIsNullOrEmpty(variantID) then
			local variantIDToStringID:string_id = get_string_id_from_string(variantID);
			newTagFilterData.allowedVariants[variantIDToStringID] = true;
			newTagFilterData.totalVariants = 1;
		end

		self.data[tagDefinition] = newTagFilterData;
		self.count = self.count + 1;
	end
end

function TagFilterClass:Remove(tagDefinition:tag, variantID:string):void
	if not IsValidTag(tagDefinition) then return; end

	local tagFilterData:TagFilterDataStruct = self.data[tagDefinition];

	if tagFilterData ~= nil then
		-- If a variant id is passed in and this has variants, attempt to find that entry
		if not stringIsNullOrEmpty(variantID) and tagFilterData.totalVariants > 0 then
			local variantIDToStringID:string_id = get_string_id_from_string(variantID);
			if 	tagFilterData.allowedVariants[variantIDToStringID] ~= nil then
				tagFilterData.allowedVariants[variantIDToStringID] = nil;
				tagFilterData.totalVariants = tagFilterData.totalVariants - 1;
			end		
		else
			-- Otherwise, this will assume that the tag itself should be removed
			self.data[tagDefinition] = nil;
			self.count = self.count - 1;
		end
	end	
end

function TagFilterClass:Matches(someObject:object):boolean
	local result:boolean = false;

	if object_index_valid(someObject) then
		local tagDefinition = Object_GetDefinition(someObject);
		local variantStringID = ObjectGetVariant(someObject);
		local tagFilterData:TagFilterDataStruct = self.data[tagDefinition];

		if tagFilterData ~= nil then
			-- If we found the tag and have no specific variants defined, it counts
			-- A tag with no variants defined in its data here means that all variants are allowed
			if tagFilterData.totalVariants == 0 then
				result = true;
			else
				result = tagFilterData.allowedVariants[variantStringID] ~= nil;
			end
		end
	end

	return result;
end

-- Helpers

function TagFilterClass:GetCount()
	return self.count;
end