-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

--[[

  ██████ ▓█████ ▓█████ ▓█████▄   ██████ ▓█████   █████   █    ██ ▓█████  ███▄    █  ▄████▄  ▓█████ 
▒██    ▒ ▓█   ▀ ▓█   ▀ ▒██▀ ██▌▒██    ▒ ▓█   ▀ ▒██▓  ██▒ ██  ▓██▒▓█   ▀  ██ ▀█   █ ▒██▀ ▀█  ▓█   ▀ 
░ ▓██▄   ▒███   ▒███   ░██   █▌░ ▓██▄   ▒███   ▒██▒  ██░▓██  ▒██░▒███   ▓██  ▀█ ██▒▒▓█    ▄ ▒███   
  ▒   ██▒▒▓█  ▄ ▒▓█  ▄ ░▓█▄   ▌  ▒   ██▒▒▓█  ▄ ░██  █▀ ░▓▓█  ░██░▒▓█  ▄ ▓██▒  ▐▌██▒▒▓▓▄ ▄██▒▒▓█  ▄ 
▒██████▒▒░▒████▒░▒████▒░▒████▓ ▒██████▒▒░▒████▒░▒███▒█▄ ▒▒█████▓ ░▒████▒▒██░   ▓██░▒ ▓███▀ ░░▒████▒
▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒░ ░ ▒▒▓  ▒ ▒ ▒▓▒ ▒ ░░░ ▒░ ░░░ ▒▒░ ▒ ░▒▓▒ ▒ ▒ ░░ ▒░ ░░ ▒░   ▒ ▒ ░ ░▒ ▒  ░░░ ▒░ ░
░ ░▒  ░ ░ ░ ░  ░ ░ ░  ░ ░ ▒  ▒ ░ ░▒  ░ ░ ░ ░  ░ ░ ▒░  ░ ░░▒░ ░ ░  ░ ░  ░░ ░░   ░ ▒░  ░  ▒    ░ ░  ░
░  ░  ░     ░      ░    ░ ░  ░ ░  ░  ░     ░      ░   ░  ░░░ ░ ░    ░      ░   ░ ░ ░           ░   
      ░     ░  ░   ░  ░   ░          ░     ░  ░    ░       ░        ░  ░         ░ ░ ░         ░  ░
                        ░                                                          ░               

]]--

global SeedSequence:table = Parcel.MakeParcel
{

    --Parcel Variables
	--Place all the variables your parcel needs here.
	--Whether the parcel is ready to start.  Used by the parcel manager
	canStart = false,  				
	--Whether the parcel has had it's completion requirements met.  The parcel ends when this is true
	complete = false,
	--Ideally each instance of this parcel would have a unique name.  Set via the New() function
	instanceName = "SeedSequence",

	-- SeedSequence variables
    handle = 0,                                                     -- of the total created sequences, what index is this one
    seedRoot = nil,			                                        -- the seed value the system returns to

    seedCurrent = nil,			                                    -- this is the current seed
    depthCnt = 0,					                                -- the current count of numbers generated

    sequenceParent = nil,                                           -- parent sequence
    sequenceChildList = {},                                         -- list of children sequences

    CONFIG = 
	{
        seedInitial = nil,		                                    -- this is the initial seed
        seedLock = false,                                           -- locks the initial generated seed rootvalue so that it will be the same after resets

        debugPrintEnabled = false,
    },

	EVENTS =
	{
	},
	
    GLOBALS = { 
        createdCnt = 0,
        seedMacroList = {},

        debugPrintEnabled = false,
    },

    CONST = 
	{
		MAX_SEED = 2^24,							                -- mantissa! this value is where it seems like the floating point precision starts to break down and will eventually break down where the value after a randomseed will be the same for subsequent seed values
		SEED_DEFAULT = "{DEFAULT}",                                 -- system default seed token
    },

};



-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- SeedSequence Functions
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 
-- FUNCTION: New --------------------------------------------------------------------------------------
--	creates a new SeedSequence parcel
-- RETURN: New SeedSequence parcel
-- ----------------------------------------------------------------------------------------------------
--		seed = initial seed value; nil = CONST.SEED_DEFAULT
--			can be any number or string (with numbers or tokens; see SetSeed)
--      lockSeed = locks the seed root value to the initial processed value so that it's no longer a string where the tokens could change the root seed value when it's reset
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:New(seed, lockSeed:boolean):table

	--New is used to set up all the variables and functions for the parcel.
	local newInstance = self:CreateParcelInstance();

    -- keep global/shared parcel data pointing back to the master table and not a copy; saves memory, macro changes can happen in one place
    newInstance.GLOBALS = SeedSequence.GLOBALS;
    newInstance.CONST = SeedSequence.CONST;

    -- increment global sequence created count
    newInstance.GLOBALS.createdCnt = newInstance.GLOBALS.createdCnt + 1;

    -- assign the handle with the total created amount (last instance)
    newInstance.handle = SeedSequence.GLOBALS.createdCnt;

    -- set CONFIG values with arguements
    newInstance.CONFIG.seedInitial = seed;
    newInstance.CONFIG.seedLock = lockSeed;

    -- set the seed root with the seed value; if lock seed, then commit the current generated seed (possibly from a string, etc.) to the initial seed in case of a reset
    if (lockSeed) then
        newInstance.seedRoot = newInstance:SeedProcess(newInstance.CONFIG.seedInitial);
    else
        newInstance.seedRoot = newInstance.CONFIG.seedInitial;
    end

    -- reset the seed to initialize components
    newInstance:Reset();

    -- debugging
    self:DebugPrint("SeedSequence:New()\tseed\t" .. tostring(self.seedCurrent) .. "\tlock\t" .. tostring(lockSeed) .. "\tcurrent\t" .. tostring(newInstance.seedCurrent) .. "\tinitial\t" .. tostring(newInstance.CONFIG.seedInitial) .. "\troot\t" .. tostring(newInstance.seedRoot));

	-- initialize values and return
	return newInstance;

end

-- FUNCTION: Reset ------------------------------------------------------------------------------------
--	Simple function to reset the sequence
-- RETURN: self SeedSequence parcel
function SeedSequence:Reset():boolean

    -- restore the depth to 0
    self.depthCnt = 0;

    -- set the current seed value with the seed from the root
    self.seedCurrent = self:SeedProcess(self.seedRoot);

    -- return self
    return true;
    
end



-- ====================================================================================================
-- ====================================================================================================
-- GROUP: SEED ========================================================================================
--	Functions related to the seed
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: SeedCurrent ------------------------------------------------------------------------------
--	Gets the current seed used to generate the next value
-- RETURN: current seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:SeedCurrent():number
    return self.seedCurrent;
end 

-- FUNCTION: SeedInitial ------------------------------------------------------------------------------
--	Gets the initial seed value
-- RETURN: current seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:SeedInitial():number
    return self.CONFIG.seedInitial;
end 

-- FUNCTION: SeedRoot ---------------------------------------------------------------------------------
--	Gets the root seed value (what it will return to after a reset; processed)
-- RETURN: root seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:SeedRoot():number
    return self.seedRoot;
end 

-- FUNCTION: SeedProcess ------------------------------------------------------------------------------
--  Processes seed value to remove tokens and convert it into a usable seed number
-- RETURN: processed seed value clamped by SeedSequence.CONST.MAX_SEED
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:SeedProcess(seed):number
    
    -- if invalid seed, use default seed 
    seed = ((seed == nil) or (seed == "") or ((type(seed) ~= "number") and (type(seed) ~= "string"))) and SeedSequence.CONST.SEED_DEFAULT or seed;

    -- for anything that's not a number, make it a string to process
    if ((type(seed) ~= "number") and (type(seed) ~= "string")) then
        seed = tostring(seed);
    end

    -- process string seed
    if (type(seed) == "string") then

        -- get date/time data for token values
        local t_date = os.date('!*t');
        
        -- process macro token list 
        seed = self:sys_seedMacroList_process(seed);

        -- token values
        -- date
        seed = seed:gsub("{DATE.YEAR}",           t_date.year);                           -- token; year; eg, 2020
        seed = seed:gsub("{DATE.MONTH}",          t_date.month);                          -- token; month (1-12); eg, 11 
        seed = seed:gsub("{DATE.WEEK}",           1 + math.floor(t_date.yday/7));         -- token; week of the year (1-52); eg, 46
        seed = seed:gsub("{DATE.DAY}",            t_date.day);                            -- token; day of the month (1-31); eg, 24
        seed = seed:gsub("{DATE.YEARDAY}",        t_date.yday);                           -- token; day of the year (1-366); eg, 326
        seed = seed:gsub("{DATE.WEEKDAY}",        t_date.wday);                           -- token; day of the week (Sunday is 1, Monday is 2 etc.)
        -- time
        seed = seed:gsub("{TIME.HOUR}",           t_date.hour);                           -- token; military hour (0-23)
        seed = seed:gsub("{TIME.HOUR.12}",        (t_date.hour%12) +1);                   -- token; am/pm hour (1-12)
        seed = seed:gsub("{TIME.MINUTE}",         t_date.min);                            -- token; minute (0-59)
        seed = seed:gsub("{TIME.SECOND}",         t_date.sec);                            -- token; second (0-59)
        seed = seed:gsub("{TIME.MILLISECOND}",    math.floor(os.clock()*1000));           -- token; MILLISECOND
        -- players
        seed = seed:gsub("{PLAYER.COUNT}",        GetTotalPlayerCount());                 -- token; total player count
        -- sequence
        seed = seed:gsub("{SEQUENCE.HANDLE}",     self:Handle());                         -- token; sequence ID number
        seed = seed:gsub("{SEQUENCE.COUNT}",      SeedSequence.GLOBALS.createdCnt);       -- token; number of sequences crated     
        -- mode info
        seed = seed:gsub("{MODE.ENGINE}",         tostring(Variant_GetEngineName()));     -- token; sequence ID number
        seed = seed:gsub("{MODE.VARIANT}",        tostring(Variant_GetVariantName()));    -- token; number of sequences crated     
        -- map info
        seed = seed:gsub("{MAP.BASE}",            tostring(MapVariant_GetAssetId()));     -- token; sequence ID number
        seed = seed:gsub("{MAP.VARIANT}",         tostring(MapVariant_GetName()));        -- token; number of sequences crated     

        -- get rid of the white space
        seed = stringRemoveWhiteSpace(seed);

        -- convert the string seed to a number for final testing
        local seedNum = tonumber(seed);

        -- if seed wasn't the number that became seedNum or seedNum is too large, process as a string
        if ((seed ~= tostring(seedNum)) or (seedNum > SeedSequence.CONST.MAX_SEED)) then

            seedNum = 0;
            local baseMultiplier = 1;
            for i = #seed, 1, -1 do

                local c = seed:sub(i, i);
                local cVal = string.byte(c) * baseMultiplier;

                -- if the offset value gets too high, reset the multiplier
                if (cVal <= SeedSequence.CONST.MAX_SEED) then
                    baseMultiplier = baseMultiplier * 10;
                else
                    cVal = string.byte(c);
                    baseMultiplier = 1;
                end

                -- increment the seed with the cVal
                seedNum = self:sys_seedOffset(seedNum, cVal);
 
            end

        end

        -- set seed with its numeric value
        seed = seedNum;

    end

    -- assert if not a number
    if (type(seed) ~= "number") then
        debug_assert(type(seed) ~= "number", "MPItemMSeedSequence:SeedProcess Seed value is not a number: " .. tostring(seed));
        return 0;
    end
    
    -- if too large of a seed was passed into the system, reprocess as a string
    if (seed > SeedSequence.CONST.MAX_SEED) then
        return self:SeedProcess(tostring(seed));
    end

    -- return
    return seed;

end

function SeedSequence:sys_seedOffset(seed:number, offset:number):number

    local new:number = seed + offset;
    if (new > SeedSequence.CONST.MAX_SEED) then
        return self:sys_seedOffset(0, offset - (SeedSequence.CONST.MAX_SEED - seed));
    end
    return new;

end
-- system functions for processing the macro seed token list
function SeedSequence:sys_seedMacroList_process(value:string, noProcess:table):string
    local oldValue = value;
    noProcess = noProcess or {};

    for token,tokenValue in hpairs(SeedSequence.GLOBALS.seedMacroList) do
        if (noProcess[token] == nil) then
            value = value:gsub(token, tokenValue);
            if (value ~= oldValue) then
                noProcess[token] = true;
                value = self:sys_seedMacroList_process(value, noProcess);
                -- this is an optiomization for subsiquent runs to quick swap out tokens values that have already been processed
                if (SeedSequence.GLOBALS.seedMacroList[oldValue] ~= nil) then
                    SeedSequence.GLOBALS.seedMacroList[oldValue] = value;
                end
                return value;
            end
        end
    end

    return value;

end

-- system functions to build the initial seed macro list
function SYS_SeedSequence_GlobalSeedToken_add(token:string, value:string)
    -- assign the macrotoken key index with the procesed value; also make sure it does not contain its own token
    SeedSequence.GLOBALS.seedMacroList[token] = SeedSequence:sys_seedMacroList_process(value);
end

-- system functions to build the initial seed macro list
function SYS_SeedSequence_GlobalSeedToken_get(token:string)
    return SeedSequence.GLOBALS.seedMacroList[token];
end

-- add macro tokens to the default list
function AddCommonGlobalSeedTokens():void
	SYS_SeedSequence_GlobalSeedToken_add(SeedSequence.CONST.SEED_DEFAULT,   "{RANDOM}");                                                            -- macro token; system default
	SYS_SeedSequence_GlobalSeedToken_add("{RANDOM}",                        "{GAME.VERSION} {SEQUENCE.HANDLE} {TIME.MOMENT}");                      -- macro token; the randomest seed we can generate with the system 

	-- date based
	SYS_SeedSequence_GlobalSeedToken_add("{DATE}",                          "{DATE.YEAR} {DATE.ANNUAL}");                                           -- macro token; 
	SYS_SeedSequence_GlobalSeedToken_add("{DATE.ANNUAL}",                   "{DATE.MONTH} {DATE.DAY}");                                             -- macro token; this day anually; repeats every year
	-- time based
	SYS_SeedSequence_GlobalSeedToken_add("{TIME}",                          "{TIME.HOUR} {TIME.MINUTE} {TIME.SECOND} {TIME.MILLISECOND}");          -- macro token; this same exact time every day
	SYS_SeedSequence_GlobalSeedToken_add("{TIME.12}",                       "{TIME.HOUR.12} {TIME.MINUTE} {TIME.SECOND} {TIME.MILLISECOND}");       -- macro token; this same exact time every day
	SYS_SeedSequence_GlobalSeedToken_add("{TIME.MOMENT}",                   "{DATE} {TIME}");                                                       -- macro token; this moment in time, never repeats
	-- game information
	SYS_SeedSequence_GlobalSeedToken_add("{GAME.VERSION}",                  "0");                                                                   -- macro token; game version number
end


-- ====================================================================================================
-- ====================================================================================================
-- GROUP: Seed Value ==================================================================================
--	Functions for getting the value of a seed
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: SeedRandomSequenceRatio ------------------------------------------------------------------
--	Gets the random ratio return value of a seed
-- RETURN: next seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:SeedRandomSequenceRatio(seed):number

    -- prepare the seed
    self:sys_SeedRandomSequencePrep(seed);

    -- return seeded value
    return math.random();

end

-- FUNCTION: SeedRandomSequenceRange ------------------------------------------------------------------
--	Gets the seed value represented as range integers
-- RETURN: range seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:SeedRandomSequenceRange(seed, min, max):number

    -- prepare the seed
    self:sys_SeedRandomSequencePrep(seed);

    -- return the next ratio range
    return math.random(min, max);

end 
function SeedSequence:sys_SeedRandomSequencePrep(seed)

    -- process the seed
    seed = self:SeedProcess(self:sys_SeedParented(seed));

    -- seed with the current seed value
    math.randomseed(seed);

    -- dirty the "randomest" random so that it recalculates
    sys_randomest_range_set_dirty();

end
function SeedSequence:sys_SeedParented(seed)
    
    -- append parent seeds to the seed
    local parent = self.sequenceParent;
    while (parent ~= nil) do

        -- append parent to front of seed
        seed = tostring(parent:SeedCurrent()) .. " " .. seed;

        -- see if the parent has a parent
        parent = parent.sequenceParent;

    end

    return seed;

end

-- ====================================================================================================
-- ====================================================================================================
-- GROUP: CURRENT =====================================================================================
--	Functions for getting the current value of a sequenced seed
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: CurrentRandomSequenceRatio ---------------------------------------------------------------
--	Gets the current seed ratio value
-- RETURN: Current seed ratio
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:CurrentRandomSequenceRatio():number

    -- return the value
    return self:SeedRandomSequenceRatio(self.seedCurrent);

end 

-- FUNCTION: CurrentRandomSequenceRange ---------------------------------------------------------------
--	Gets the current ratio value represented as range integers
-- RETURN: Current range seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:CurrentRandomSequenceRange(min:number, max:number):number

    -- return the current ratio range
    return self:SeedRandomSequenceRange(self.seedCurrent, min, max);

end 



-- ====================================================================================================
-- ====================================================================================================
-- GROUP: NEXT ========================================================================================
--	Functions for getting the next value of a sequenced seed
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: NextRandomSequenceRatio ------------------------------------------------------------------
--	Gets the next seed ratio value
-- RETURN: Next seed ratio
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:NextRandomSequenceRatio():number

    -- step to the next value in the seuence
    self:Next();

    -- return the ratio
    return self:CurrentRandomSequenceRatio();

end 

-- FUNCTION: NextRandomSequenceRange ------------------------------------------------------------------
--	Gets the next ratio value represented as range integers
-- RETURN: Current range seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:NextRandomSequenceRange(min:number, max:number):number

    -- step to the next value in the seuence
    self:Next();

    -- return the next ratio range
    return self:CurrentRandomSequenceRange(min, max);

end 

-- FUNCTION: Next -------------------------------------------------------------------------------------
--	Steps to the next value in the sequence
-- RETURN: the next seed value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:Next()

    -- seed with the current seed value
    math.randomseed(self.seedCurrent);   -- depth being part of it will help it from looping back in-on-itself if it generates a seed that is one of the previous seeds
    local seedNext = math.random(0, SeedSequence.CONST.MAX_SEED);

    -- dirty the "randomest" random so that it recalculates
    sys_randomest_range_set_dirty();

    -- increment the depth for reference
    self.depthCnt = self.depthCnt + 1;

    -- set the current seed with the next random value range
    self.seedCurrent = self:sys_seedOffset(seedNext, self.depthCnt);

    -- return the ratio
    return self.seedCurrent;

end 



-- ====================================================================================================
-- ====================================================================================================
-- GROUP: Parent ======================================================================================
--	Functions to access the parent sequence
--      When children get a seed value, it is combined with the seed of their parent as well
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: ParentSet --------------------------------------------------------------------------------
--	Sets the parent sequence
-- RETURN: true if the sequence was set as the parent
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:ParentSet(parent:table)
    
    -- if it's a new parent sequence, attach
    if (parent ~= self.sequenceParent) then

        -- detach old parent
        if (self.sequenceParent ~= nil) then
            self.sequenceParent:ChildRemove(self);
        end

        -- attach new parent
        if (parent ~= nil) then
            -- make sure the parent and its parents aren't using self as a parent (would create a loop)
            local test_parent = parent;
            while (test_parent ~= nil) do
                if (test_parent.sequenceParent == self) then
                    return false;
                end
                test_parent = test_parent.sequenceParent;
            end

            return parent:ChildAdd(self);
        end

        -- value must have been nil, asign and return
        self.sequenceParent = nil;
        return true;

    end

    -- return the parent handle
    return false;

end

-- FUNCTION: ParentGet --------------------------------------------------------------------------------
--	Gets the sequences parent sequence
-- RETURN: SeedSequence object of the parent; nil = none
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:ParentGet():SeedSequence

    -- return the parent handle
    return self.sequenceParent;

end



-- ====================================================================================================
-- ====================================================================================================
-- GROUP: Child =======================================================================================
--	Functions to access the child sequences
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: ChildAdd ---------------------------------------------------------------------------------
--	Adds a child sequence
-- RETURN: true if the sequence was added as a child
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:ChildAdd(child:table):boolean

    -- ignore invalid children or if the parent is already this sequence
    if ((child == nil) or (self.sequenceParent == self)) then
        return false;
    end

    -- success; insert the child into the list
    table.insert(self.sequenceChildList, child);
    child.sequenceParent = self;
    return true;

end

-- FUNCTION: ChildRemove ------------------------------------------------------------------------------
--	Removes a child sequence
-- RETURN: SeedSequence object of the parent
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:ChildRemove(child:table):boolean

    -- find the child in the list
    for i, list_child in ipairs(self.sequenceChildList) do
        
        -- if found, remove it and return
        if (child == list_child) then
            table.remove(self.sequenceChildList, i);
            return true;
        end
        
    end

    -- failed to remove the child
    return false;

end

-- FUNCTION: ChildList --------------------------------------------------------------------------------
--	Gets the list of child sequences
-- RETURN: SeedSequence object of the parent; nil = none
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:ChildList():table

    -- return the parent handle
    return self.sequenceChildList;

end



-- ====================================================================================================
-- ====================================================================================================
-- GROUP: General =====================================================================================
--	Functions to get general information about the sequence
-- ====================================================================================================
-- ====================================================================================================

-- FUNCTION: Handle -----------------------------------------------------------------------------------
--	Gets the Handle of the seed sequence; essentially the order this seqence was created
-- RETURN: current depth value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:Handle():number
    
    return self.handle;

end

-- FUNCTION: Depth ------------------------------------------------------------------------------------
--	Gets the current depth of the seed sequence
-- RETURN: current depth value
-- ----------------------------------------------------------------------------------------------------
function SeedSequence:Depth():number
    
    return self.depthCnt;

end



-- ====================================================================================================
-- ====================================================================================================
-- GROUP: General =====================================================================================
--	Functions to get general information about the sequence
-- ====================================================================================================
-- ====================================================================================================
function SeedSequence:DebugPrintEnable(enable):void
	self.CONFIG.debugPrintEnabled = enable;
end
function SeedSequence:DebugPrintGlobal(enable):void
	self.GLOBALS.debugPrintEnabled = enable;
end
function SeedSequence:DebugPrint(...):void
	-- use DebugPrint() instead of print() in the parcel to have the ability to disable 
	-- debug print statements when you don't want to see them.
	if (self.CONFIG.debugPrintEnabled or self.GLOBALS.debugPrintEnabled) then
		print(...);
	end	
end



-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
--	math.random replacer; lite
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

-- this function is to replace the generic math.random used; it coordinates with the seed sequencer to make sure it's not stepping on it when requesting a random number, 
--  reseeding if a sequence last used the seed to ensure the best variety of random numbers 

global G_seedsequence_randomest_shift = 1;
function randomest_range(min:number, max:number):number
    return sys_randomest_range_dirty(min, max);
end
function randomest_real(min:number, max:number):number
    return sys_randomest_real_dirty(min, max);
end
function randomest_ratio():number
    return randomest_real(0.0, 1.0);
end
random_range = randomest_range;     -- Hijack random_range function to use math_randomest function because of the way the sequencer can thrash the seed
real_random_range = randomest_real;
random_ratio = randomest_ratio;

-- work horse functions for randomest
function sys_randomest_seed()

    local seed = tostring(G_seedsequence_randomest_shift) .. tostring(os.clock() + os.time());

    -- the index helps prevent dupe random values from being generated even if the n_math_seed_current gets used by the seedsequence in the same frame
    G_seedsequence_randomest_shift = G_seedsequence_randomest_shift + 1; 

    --seed = ;
    seed = tonumber("0." .. seed:gsub("%D+", "")) * SeedSequence.CONST.MAX_SEED;

    -- get the "randomest" seed from the current clock offset by the index to ensure m
    math.randomseed(seed);

end

function sys_randomest_range_dirty(min:number, max:number):number
    
    -- set clean!
    sys_randomest_range_set_clean();

    -- seed randomest
    sys_randomest_seed();

    -- return clean value
    return sys_randomest_range_clean(min, max);

end
function sys_randomest_range_clean(min:number, max:number):number
    if (max ~= nil) then
        if (min == nil) then
            min = max;
            max = nil;
        elseif (min < max) then
            return math.random(min, max);
        elseif (min == max) then
            return min;
        end
        return sys_randomest_range_clean(max, min);
    end
    if (min ~= nil) then
        return math.random(min);
    end
    return math.random();
end
function sys_randomest_real_dirty(min:number, max:number):number
    
    -- set clean!
    sys_randomest_range_set_clean();

    -- seed randomest
    sys_randomest_seed();

    -- return clean value
    return sys_randomest_real_clean(min, max);

end
function sys_randomest_real_clean(min:number, max:number):number
    if (max ~= nil) then
        if (min == nil) then
            min = max;
            max = nil;
        elseif (min < max) then
            return min + (math.random() * (max-min));
        elseif (min == max) then
            return min;
        end
        return sys_randomest_range_clean(max, min);
    end
    if (min ~= nil) then
        return math.random() * min;
    end
    return math.random();
end
-- functions to switch it between dirty/clean
function sys_randomest_range_set_dirty()
    randomest_range = sys_randomest_range_dirty;
    randomest_real = sys_randomest_real_dirty;
end
function sys_randomest_range_set_clean()
    randomest_range = sys_randomest_range_clean;
    randomest_real = sys_randomest_real_clean;
end
-- initialize dirty
sys_randomest_range_set_dirty();



-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
--	TESTING SCRIPTS
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
-- $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


--[[
TODO: future; add testing into unit test framework

function SeedSequence:OutputTestCnt(cnt, min, max):string
    cnt = math.floor(cnt);
    local o = "";
    local d, v = nil;
    for i = 1, cnt do
        v = self:NextRandomSequenceRange(min, max);
        d = self:Depth();
        o = o .. "(" .. tostring(d) .. ") " .. tostring(v) .. "\t";
    end
    return o;
end
function seedsequence_randomest_test(grouping,cnt)

    local p = "\tseedsequence_randomest_test: \t" .. grouping .. " = ";

    for i = 1, cnt do
        p = p .. "\t" .. tostring(random_range(0,100));
    end
    print(p);

end
function seedsequence_test_outputblock_start(block, seed_a, seed_b)
    print("TEST " .. tostring(block) .. "--------------------------------------------------");
    print("\tseed_a = " .. tostring(seed_a:SeedRoot()) .. "\tseed_b = " .. tostring(seed_b:SeedRoot()) .. "\tSHOULD MATCH = " .. tostring((seed_a:SeedRoot() == seed_b:SeedRoot()) and (seed_a:SeedRoot() ~= nil) and (seed_b:SeedRoot() ~= nil) and (seed_a:Depth() == seed_b:Depth())));
end

function seedsequence_test()
    print("seedsequence_test");

    -- defaults
    local seq_seed = nil;
    local seq_seed_a = "123ABC";
    local seq_seed_b = "123ABC";
    local seq_seed_c = "123abc";
    local seq_lock = true;
    local seq_lock_a = nil
    local seq_lock_b = nil;
    local seq_lock_c = nil;
    local seq_debugout_cnt = 50;
    local seq_debugout_split = 4;
    local seq_randomest_cnt = 3;
    local seq_min = 0;
    local seq_max = 9;

    -- create the sequences
    local seq_a = SeedSequence:New(seq_seed_a or seq_seed, seq_lock_a or seq_lock);
    local seq_b = SeedSequence:New(seq_seed_b or seq_seed, seq_lock_b or seq_lock);
    local seq_c = SeedSequence:New(seq_seed_c or seq_seed, seq_lock_c or seq_lock);

    local seq_a_debug = "";
    local seq_b_debug = "";

    -- tests
    seedsequence_test_outputblock_start("A", seq_a, seq_b);
    seedsequence_randomest_test("A1",seq_randomest_cnt);
    seq_a_debug = seq_a:OutputTestCnt(seq_debugout_cnt, seq_min, seq_max);
    seedsequence_randomest_test("A2",seq_randomest_cnt);
    seq_b_debug = seq_b:OutputTestCnt(seq_debugout_cnt, seq_min, seq_max);
    seedsequence_randomest_test("A3",seq_randomest_cnt);
    tprint("seedsequence_test", seq_a, "test1-seq_a", seq_a_debug);
    tprint("seedsequence_test", seq_b, "test1-seq_b", seq_b_debug);
    seedsequence_randomest_test("A4",seq_randomest_cnt);

    seq_a:Reset();
    seq_b:Reset();
    seedsequence_test_outputblock_start("B", seq_a, seq_b);
    seq_a_debug = seq_a:OutputTestCnt(seq_debugout_cnt, seq_min, seq_max);
    seq_b_debug = seq_b:OutputTestCnt(seq_debugout_cnt, seq_min, seq_max);
    tprint("seedsequence_test", seq_a, "test1-seq_a", seq_a_debug);
    tprint("seedsequence_test", seq_b, "test1-seq_b", seq_b_debug);

    seq_a:Reset();
    seedsequence_test_outputblock_start("C", seq_a, seq_b);
    seq_a_debug = seq_a:OutputTestCnt(seq_debugout_cnt, seq_min, seq_max);
    seq_b_debug = seq_b:OutputTestCnt(seq_debugout_cnt, seq_min, seq_max);
    tprint("seedsequence_test", seq_a, "test1-seq_a", seq_a_debug);
    tprint("seedsequence_test", seq_b, "test1-seq_b", seq_b_debug);

    seq_a:Reset();
    seq_b:Reset();
    seedsequence_test_outputblock_start("D", seq_a, seq_b);
    seq_a_debug = "";
    seq_b_debug = "";
    for i = 1, seq_debugout_split do
        seq_a_debug = seq_a_debug .. seq_a:OutputTestCnt(seq_debugout_cnt/seq_debugout_split, seq_min, seq_max);
        seq_b_debug = seq_b_debug .. seq_b:OutputTestCnt(seq_debugout_cnt/seq_debugout_split, seq_min, seq_max);
    end
    tprint("seedsequence_test", seq_a, "test1-seq_a", seq_a_debug);
    tprint("seedsequence_test", seq_b, "test1-seq_b", seq_b_debug);

    --test parenting
    print("test parenting----");
    seq_a = SeedSequence:New(123, true);
    seq_b = SeedSequence:New(123, true);
    seq_c = SeedSequence:New(456, true);

    print("1: a\t" .. tostring(seq_a:CurrentRandomSequenceRatio()) .. "\tb\t" .. tostring(seq_b:CurrentRandomSequenceRatio()) .. "\tc\t" .. tostring(seq_c:CurrentRandomSequenceRatio()));
    seq_a:ParentSet(seq_c);
    seq_b:ParentSet(seq_c);
    print("2: a\t" .. tostring(seq_a:CurrentRandomSequenceRatio()) .. "\tb\t" .. tostring(seq_b:CurrentRandomSequenceRatio()) .. "\tc\t" .. tostring(seq_c:CurrentRandomSequenceRatio()));
    seq_a:Next();
    print("3: a\t" .. tostring(seq_a:CurrentRandomSequenceRatio()) .. "\tb\t" .. tostring(seq_b:CurrentRandomSequenceRatio()) .. "\tc\t" .. tostring(seq_c:CurrentRandomSequenceRatio()));
    seq_b:Next();
    print("4: a\t" .. tostring(seq_a:CurrentRandomSequenceRatio()) .. "\tb\t" .. tostring(seq_b:CurrentRandomSequenceRatio()) .. "\tc\t" .. tostring(seq_c:CurrentRandomSequenceRatio()));
    seq_c:Next();
    print("5: a\t" .. tostring(seq_a:CurrentRandomSequenceRatio()) .. "\tb\t" .. tostring(seq_b:CurrentRandomSequenceRatio()) .. "\tc\t" .. tostring(seq_c:CurrentRandomSequenceRatio()));
    seq_c:Reset();
    print("6: a\t" .. tostring(seq_a:CurrentRandomSequenceRatio()) .. "\tb\t" .. tostring(seq_b:CurrentRandomSequenceRatio()) .. "\tc\t" .. tostring(seq_c:CurrentRandomSequenceRatio()));
end

-- test
seedsequence_test();
]]--

--[[
function test_max_seed_good(seed,depth)

    --return seed ~= (seed + 1);

    math.randomseed(seed);
    local rand_val = math.random();
    local t = nil;
    --print("\ttest_max_seed_good a seed\t" .. tostring(seed) .. "\tval\t" .. tostring(rand_val));
    for i = 1, depth do
        math.randomseed(seed + i);
        t = math.random();
        if (t == rand_val) then
            --print("\ttest_max_seed_good b seed\t" .. tostring(seed) .. "\ti\t" .. tostring(i) .. "\tval\t" .. tostring(rand_val));
            return false;
        end
    end

    math.randomseed(seed-1);
    t = math.random() ~= rand_val;
    --print("\ttest_max_seed_good c\t" .. tostring(t));
    return t;

end

--1000000000
function find_MAX_SEED()
    local min = 1;
    local max = 1;
    local test_cnt = 10;
    local step = 2;
   
    --values = 	17031250	17031252:1	17031252
    --LOOP DONE = 	17031250	17031252

    -- find ranges
    repeat
        min = max;
        max = min * step;
    until (not test_max_seed_good(max,5));

    local mid = nil;
    local b_find_minmax = true;
    if (b_find_minmax) then
        --print("start = \tmin\t" .. tostring(min) .. "\tmax\t" .. tostring(max));
        repeat

            step = math.floor(max-min) / 2;
            mid = min + step;
            
            --print("values = \t" .. tostring(min) .. "\t" .. tostring(mid) .. ":" .. tostring(step) .. "\t" .. tostring(max));

            if (not test_max_seed_good(mid, test_cnt)) then
                --print("a\t" .. tostring(mid));
                max = mid;
            else
                --print("B\t" .. tostring(mid));
                min = mid;
            end

        until (step <= 1);
        print("LOOP DONE = \t" .. tostring(min) .. "\t" .. tostring(max));
    end
    --min = 17031250;
    --max = 17031250; -- 17031252
    --FOUND IT = 16777215

    while (not test_max_seed_good(max, test_cnt)) do
        print("f: " .. tostring(max));
        max = max - 1;
    end

    print("FOUND IT = " .. tostring(max));
    for i=1,100 do
        print("\tval = " .. tostring(max-i));
    end

end
--find_MAX_SEED();
--local test_a = 17031250;
--local test_b = test_a + 1;
--print("testing: test_a = \t" .. tostring(test_a) .. "\ttest_b = \t" .. tostring(test_b));
]]--