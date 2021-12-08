-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

-- requires
REQUIRES('scripts\ParcelLibrary\parcel_seedsequence.lua');

--[[

 ███▄ ▄███▓ ██▓███       ██████ ▓█████ ▓█████ ▓█████▄   ██████ ▓█████   █████   █    ██ ▓█████  ███▄    █  ▄████▄  ▓█████ 
 ▓██▒▀█▀ ██▒▓██░  ██▒   ▒██    ▒ ▓█   ▀ ▓█   ▀ ▒██▀ ██▌▒██    ▒ ▓█   ▀ ▒██▓  ██▒ ██  ▓██▒▓█   ▀  ██ ▀█   █ ▒██▀ ▀█  ▓█   ▀ 
 ▓██    ▓██░▓██░ ██▓▒   ░ ▓██▄   ▒███   ▒███   ░██   █▌░ ▓██▄   ▒███   ▒██▒  ██░▓██  ▒██░▒███   ▓██  ▀█ ██▒▒▓█    ▄ ▒███   
 ▒██    ▒██ ▒██▄█▓▒ ▒     ▒   ██▒▒▓█  ▄ ▒▓█  ▄ ░▓█▄   ▌  ▒   ██▒▒▓█  ▄ ░██  █▀ ░▓▓█  ░██░▒▓█  ▄ ▓██▒  ▐▌██▒▒▓▓▄ ▄██▒▒▓█  ▄ 
 ▒██▒   ░██▒▒██▒ ░  ░   ▒██████▒▒░▒████▒░▒████▒░▒████▓ ▒██████▒▒░▒████▒░▒███▒█▄ ▒▒█████▓ ░▒████▒▒██░   ▓██░▒ ▓███▀ ░░▒████▒
 ░ ▒░   ░  ░▒▓▒░ ░  ░   ▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒░ ░ ▒▒▓  ▒ ▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒▒░ ▒ ░▒▓▒ ▒ ▒ ░░ ▒░ ░░ ▒░   ▒ ▒ ░ ░▒ ▒  ░░░ ▒░ ░
 ░  ░      ░░▒ ░        ░ ░▒  ░ ░ ░ ░  ░ ░ ░  ░ ░ ▒  ▒ ░ ░▒  ░ ░ ░ ░  ░ ░ ▒░  ░ ░░▒░ ░ ░  ░ ░  ░░ ░░   ░ ▒░  ░  ▒    ░ ░  ░
 ░      ░   ░░          ░  ░  ░     ░      ░    ░ ░  ░ ░  ░  ░     ░      ░   ░  ░░░ ░ ░    ░      ░   ░ ░ ░           ░   
        ░                     ░     ░  ░   ░  ░   ░          ░     ░  ░    ░       ░        ░  ░         ░ ░ ░         ░  ░
                                                ░                                                          ░               
 
]]--
 
-- master seed sequence manager
global MPSeedSequenceManager:table = Parcel.MakeParcel
{

       --Parcel Variables
       --Place all the variables your parcel needs here.
       --Whether the parcel is ready to start.  Used by the parcel manager
       canStart = false,  				
       --Whether the parcel has had it's completion requirements met.  The parcel ends when this is true
       complete = false,
       --Ideally each instance of this parcel would have a unique name.  Set via the New() function
       instanceName = "MPSeedSequenceManager",

       list = {},

       CONFIG = 
       {
       },
       EVENTS =
       {
       },
       GLOBALS = { 
       },

};

function MPSeedSequenceManager:New():table
	local newSeqManager = self:CreateParcelInstance();
	return newSeqManager;
end

function MPSeedSequenceManager:Run()
end

function MPSeedSequenceManager:shouldEnd():boolean
	return self.complete;
end

function MPSeedSequenceManager:InitializeImmediate():void
	AddCommonGlobalSeedTokens();
	AddMultiplayerGlobalSeedTokens();
end

function MPSeedSequenceManager:Initialize():void
	self:OverrideVariantKeys();
end

function MPSeedSequenceManager:OverrideVariantKeys():void
	local overriddenKeyCount:number = Variant_GetSeedSequenceOverrideCount();
	local seqTable:table = GetGeneralMPItemGameVariantSeedSequenceKeyArgs();

	for i = 0, overriddenKeyCount do
		local seedValue:string = Variant_GetSeedSequenceSeedValueOverrideByIndex(i);

		if (seedValue ~= nil and seedValue ~= "") then
			local keyName:string = Variant_GetSeedSequenceOverrideNameByIndex(i);

			if (seqTable[keyName] ~= nil) then
				seqTable[keyName].seed = seedValue;
			end
		end

		local roundReset:number = Variant_GetSeedSequenceRoundResetOverrideByIndex(i);

		if (roundReset ~= nil) then
			-- roundReset can be 1, 0 or 255 (NONE = -1)
			if (roundReset == 0) then
				seqTable[Variant_GetSeedSequenceOverrideNameByIndex(i)].roundReset = false;
			elseif (roundReset == 1) then
				seqTable[Variant_GetSeedSequenceOverrideNameByIndex(i)].roundReset = true;
			end
		end
	end
end

-- ====================================================================================================
-- ====================================================================================================
-- GROUP: Key =========================================================================================
--	Functions related to interacting with the manageres sequence keys
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: KeyGet -----------------------------------------------------------------------------------
--	Gets the seed sequence from the key
-- RETURN: Returns the seed sequence with that key
-- ----------------------------------------------------------------------------------------------------
function MPSeedSequenceManager:KeyGet(key:string):table
       return self.list[key];
end

-- FUNCTION: KeyActive --------------------------------------------------------------------------------
--	Checks if there's a sequence active with that key
-- RETURN: True if there's a sequence already with that key, False if not
-- ----------------------------------------------------------------------------------------------------
function MPSeedSequenceManager:KeyActive(key:string):boolean
       return (self.list[key] ~= nil);
end

-- FUNCTION: KeyAdd -----------------------------------------------------------------------------------
--	Adds a seed sequence at that key
-- RETURN: True if it added the seed sequence to the list
-- ASSERTS:
--     if key is already active; must explicitly remove it first
--     if seedSequence is not a table
--     if seedSequence is not a SeedSequence
-- ----------------------------------------------------------------------------------------------------
function MPSeedSequenceManager:KeyAdd(key:string, seedSequence:table):boolean

       -- check that it's OK to add the sequence
       if (self:KeyActive(key) or (type(seedSequence) ~= "table") or (seedSequence.instanceName ~= "SeedSequence")) then
              debug_assert(self:KeyActive(key), "MPSeedSequenceManager:KeyAdd - Attempted to add a key that already exists: " .. tostring(key) .. tostring(seedSequence));
              debug_assert(type(seedSequence) ~= "table", "MPSeedSequenceManager:KeyAdd - seedSequence is not a table: " .. tostring(seedSequence));
              debug_assert((type(seedSequence) == "table") and (seedSequence.instanceName ~= "SeedSequence"), "MPSeedSequenceManager:KeyAdd - seedSequence is not a SeedSequence table: " .. tostring(seedSequence.instanceName));
              return false
       end

       -- add the key to the table
       self.list[key] = seedSequence;
       return true;

end

-- FUNCTION: KeyRemove --------------------------------------------------------------------------------
--	Removes a key from the seedsequence table
-- RETURN: False if the key was not found, true if it was
-- ----------------------------------------------------------------------------------------------------
function MPSeedSequenceManager:KeyRemove(key:string):boolean

       -- key is not already active
       if (not self:KeyActive(key)) then
           return false;
       end
   
       -- add the key to the table
       self.list[key] = nil;
       return true;
   
   end
   

-- FUNCTION: KeyCount ---------------------------------------------------------------------------------
--	The number of SeedSequences tracked by the manager
-- RETURN: managed SeedSequence count 
-- ----------------------------------------------------------------------------------------------------
function MPSeedSequenceManager:KeyCount():number
       return table.countKeys(self.list);
end



-- ====================================================================================================
-- ====================================================================================================
--     Additional MP exclusive 
-- ====================================================================================================
-- ====================================================================================================

function AddMultiplayerGlobalSeedTokens():void
	-- mp related global seed macros
	SYS_SeedSequence_GlobalSeedToken_add("{RANDOM}",                        "{MAP} {SEASON} {PLAYER.COUNT} {MODE} {RANDOM}");  -- macro token; the "randomest" seed we can generate with the system 

	-- seasons
	SYS_SeedSequence_GlobalSeedToken_add("{SEASON}",                        "game_s0");                             -- macro token; game season
	SYS_SeedSequence_GlobalSeedToken_add("{SEASON.COMP}",                   "comp_s0");                             -- macro token; competitive season
	SYS_SeedSequence_GlobalSeedToken_add("{SEASON.HCS}",                    "hcs_s0");                              -- macro token; hcs season

	-- mode information
	SYS_SeedSequence_GlobalSeedToken_add("{MODE}",                          "{MODE.ENGINE} {MODE.VARIANT}");        -- macro token; game version number

	-- map information
	SYS_SeedSequence_GlobalSeedToken_add("{MAP}",                           "{MAP.BASE} {MAP.VARIANT}");            -- macro token; map id
end