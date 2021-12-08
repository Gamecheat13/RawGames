-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

--Guarantee that the global user table always exists.
global ForgeUserValuesTable_GlobalUserValues:table = {};


---
--- Custom Events
---

-- Arguments to be passed when a user triggers a Custom Event.
-- Nodes have a 4 pin limit (and one is reserved for the Identifier), so can only pass three pins at present.
hstructure ForgeCustomEventArgsStruct
  num : number;
  vec3 : vector;
  obj_list : table;
end

function ForgeCreateCustomEventArgsStruct(numberToPass:number, v:vector, objList:table):ForgeCustomEventArgsStruct
  local eventArgs:ForgeCustomEventArgsStruct = hmake ForgeCustomEventArgsStruct
  {
    num = numberToPass,
    vec3 = v,
    obj_list = objList,
  };

  return eventArgs;
end

-- Have each global custom event represented as a sub-table within the GlobalUserValues table, so we can do multiple On Custom Event, Global nodes.
-- The On Custom Event, Global will store its function in the sub-table. So we can have multiple nodes store functions in the same "Event_Identifier" index this way.
-- When triggering, check if the event is defined, and if it does, iterate through and call each event in the sub-table.
function ForgeTriggerCustomEventGlobal(identifier, eventArgs:ForgeCustomEventArgsStruct):void
  
  local customEventName:string = "Event_" .. identifier;
  if ForgeUserValuesTable_GlobalUserValues[customEventName] ~= nil then  
    -- ForgeUserValuesTable_GlobalUserValues[customEventName] should be a table if not nil. So iterate it.
    for i, customEvent in hpairs(ForgeUserValuesTable_GlobalUserValues[customEventName]) do
      customEvent(eventArgs);
    end
  end

end

-- Run at the beginning of every On Custom Event, Global node.  If this is the first Global custom event node 
-- using that event, initalize the sub-table so that we don't try to index nil.
-- If it already exists, then another On Custom Event, Global node already created the sub-table, so do nothing.
function ForgeCreateGlobalCustomEventRowIfNotExist(identifier):void
  
  local customEventName:string = "Event_" .. identifier;
  if ForgeUserValuesTable_GlobalUserValues[customEventName] == nil then
    ForgeUserValuesTable_GlobalUserValues[customEventName] = {};
  end
  
end

-- OBJECT REFERENCE HELPER FUNCTIONS --
function InitializeObjectReferenceFromMvarId(mvarId)
  local objectReference = {EntryIndex = mvarId, ObjectIndex = Forge_FindObjectIndexFromEntryIndex(mvarId), PlayerIndex = nil};
  return objectReference;
end

function InitializeObjectReferenceFromObjectId(objectId)
  local objectReference = {EntryIndex = Forge_FindEntryIndexFromObjectIndex(objectId), ObjectIndex = objectId, PlayerIndex = GetPlayerFromObject(objectId)};
  return objectReference;
end

function InitializeObjectReferenceFromPlayer(playerId)
  local objectReference = {EntryIndex = nil, ObjectIndex = Player_GetUnit(playerId) or Player_GetDeadUnit(playerId), PlayerIndex = playerId};
  return objectReference;
end

function ForgeSafeDivide(a, b)
  return (b == 0) and 0 or (a/b);
end

function ForgeSafeMod(a, b)
  return (b == 0) and 0 or (a%b);
end

function ForgeRandom(a, b)
  if (a==b) then
    return a;
  end

  local upper = a;
  local lower = b;
  if (a<b) then
    upper = b;
    lower = a;
  end

  if (a%1) == (b%1) and (a%1) == 0 then
    return math.random(lower, upper);
  else
    return lower + ((upper - lower) * math.random());
  end
end

function ForgeRandomBoolean(weightingPercent:number):boolean
  local weight:number = ForgeConvertToClampedPercent(weightingPercent);
  
  local r:number = math.random();  --return number 0-1, exlcuding one

  if (r >= weight) then
    return false
  else
    return true
  end
end

--So that users can work with "50" in the editor instead of 0.5
function ForgeConvertToClampedPercent(x):number
  if (x <= 0) then
    return 0;
  elseif (x >= 100) then
    return 1;
  else
    return (x / 100);
  end
end

function AreSameObject(objectA, objectB)
  return (objectA.EntryIndex == objectB.EntryIndex and objectA.EntryIndex ~= nil) or
         (objectA.ObjectIndex == objectB.ObjectIndex and objectA.ObjectIndex ~= nil) or
         (objectA.PlayerIndex == objectB.PlayerIndex and objectA.PlayerIndex ~= nil);
end

function ForgeObjectRefreshHandle(objectHandle)
  return ((objectHandle.EntryIndex and InitializeObjectReferenceFromMvarId(objectHandle.EntryIndex)) or
          (objectHandle.PlayerIndex and InitializeObjectReferenceFromPlayer(objectHandle.PlayerIndex)) or
           objectHandle);
end

function ForgeObjectListRefreshHandles(objects)
  for listKey, listValue in ipairs(objects) do
    objects[listKey] = ForgeObjectRefreshHandle(listValue);
  end

  return objects;
end

-- Use this function to create a list of objects sourced from the nodegraph (IE: Node properties or input pins provide the objects)
function ForgeCreateObjectList(objects)
  local list = {};

  if (objects == nil) then
    return list;    
  end

  for k, curObject in ipairs(objects) do
    if curObject ~= nil then
      local object = curObject;

      -- Uninitialized objects references can only come from setting the entry id in the UI properties
      if type(object) ~= "table" then
        object = InitializeObjectReferenceFromMvarId(object);
      end

      local inList = false;
      for listKey, listValue in ipairs(list) do
        if AreSameObject(object, listValue) then
          inList = true;
          break;
        end
      end

      if inList == false then
        table.insert(list, object);
      end
    end
  end

  return list;
end

-- Use this function to create a list of objects sourced from mp lua (functions returning lists of objectinstances, etc)
function ForgeConvertObjectList(objectInstances)
  local list = {};

  if (objectInstances == nil) then
    return list;
  end  

  for k, curObject in ipairs(objectInstances) do
    if curObject ~= nil then
      local object = curObject;

      -- If it's not an initialized object reference table, first check for an object struct, otherwise assume mvar id
      if type(object) == "struct" and object.instance ~= nil then
        object = InitializeObjectReferenceFromObjectId(Object_GetIndex(object));
      else
        object = InitializeObjectReferenceFromObjectId(object);
      end

      local inList = false;
      for listKey, listValue in ipairs(list) do
        if AreSameObject(object, listValue) then
          inList = true;
          break;
        end
      end

      if inList == false then
        list[#list+1] = object;
      end
    end
  end

  return list;
end

function ForgeObjectListCopyAndAdd(objects, addObject)
  local newList = objects;
  local objectAlreadyContained = false;
  for listKey, listValue in ipairs(newList) do
    if AreSameObject(addObject, listValue) then
      objectAlreadyContained = true;
      break;
    end
  end

  if objectAlreadyContained == false then
    newList[#newList+1] = addObject;
  end

  return newList;
end

function ForgeObjectListCopyAndRemove(objects, removeObject)
  local newList = {};

  for listKey, listValue in ipairs(objects) do
    if AreSameObject(removeObject, listValue) == false then
      newList[#newList+1] = listValue;
    end
  end

  return newList;
end

function ForgeObjectListGetTopN(objects, n)
  n = math.floor(n);
  local newList = {};

  if (n <= 0) then
    return newList;
  end

  if (#objects <= n) then
    newList = objects;
    return newList;
  end

  for i = 1, n, 1 do
    newList[#newList+1] = objects[i];
  end

  return newList;
end

function ForgeObjectListGetBottomN(objects, n)
  n = math.floor(n);
  local newList = {};

  if (n <= 0) then
    return newList;
  end

  if (#objects <= n) then
    newList = objects;
    return newList;
  end

  for i = 0, n-1, 1 do
    newList[#newList+1] = objects[#objects-i];
  end

  return newList;
end

function ForgeObjectListGetRandomN(objects, n)
  n = math.floor(n);
  local shuffledList = objects;
  local newList = {};

  if (n <= 0) then
    return newList;
  end

  -- Shuffle a copy of the list, then copy n elements over to the new list
  for i = #shuffledList, 2 , -1 do
    if (#newList >= n) then
      return newList;
    end
    local j = math.random(i)
    shuffledList[i], shuffledList[j] = shuffledList[j], shuffledList[i]
    newList[i] = shuffledList[i];
  end

  return newList;
end

function ForgeObjectListContains(list, object)
  for k, value in ipairs(list) do
    if (AreSameObject(object, value)) then
      return true;
    end
  end

  return false;
end

function ForgeObjectListUnion(listA, listB)
  local unionList = listA;

  for k, object in ipairs(listB) do
    local alreadyContained = false;
    for i, containedObject in ipairs(listA) do
      if (AreSameObject(object, containedObject)) then
        alreadyContained = true;
        break;
      end
    end
    if (alreadyContained == false) then
      unionList[#unionList+1] = object;
    end
  end

  return unionList;
end

function ForgeObjectListIntersection(listA, listB)
  local intersectList = {};

  for k, objectA in ipairs(listA) do
    for i, objectB in ipairs(listB) do
      if (AreSameObject(objectA, objectB)) then
        intersectList[#intersectList+1] = objectA;
        break;
      end
    end
  end

  return intersectList;
end

function ForgeObjectListDifference(listA, listB)
  local differenceList = {};

  for k, objectA in ipairs(listA) do
    local existsInB = false;
    for i, objectB in ipairs(listB) do
      if (AreSameObject(objectA, objectB)) then
        existsInB = true;
        break;
      end
    end
    if (existsInB == false) then
      differenceList[#differenceList+1] = objectA;
    end
  end

  for k, objectB in ipairs(listB) do
    local existsInA = false;
    for i, objectA in ipairs(listA) do
      if (AreSameObject(objectA, objectB)) then
        existsInA = true;
        break;
      end
    end
    if (existsInA == false) then
      differenceList[#differenceList+1] = objectB;
    end
  end

  return differenceList;
end

function ForgeListCount(list:table):number
  local count:number = 0;
  if (list ~= nil) then
    for key, value in ipairs(list) do 
      count = count + 1;
    end
  end
  return count;
end

-- nil team will return all active players
function ForgeObjectListGetPlayersOnTeam(team)
  local players = {};
  for k, player in ipairs(PLAYERS.active) do
    if (team == nil or Player_GetMultiplayerTeam(player) == team) then
      players[#players+1] = InitializeObjectReferenceFromPlayer(player);
    end
  end

  return players;
end

-- Gets a table of all players on a team.  Passing 'nil' for team will return a table of all players.
-- IMPORTANT: This is for use for internal functions that call things on lots of players
-- If returning a list of all players to nodegraph, use ForgeObjectListGetPlayersOnTeam()
function ForgeGetPlayersOnTeam(team:mp_team):table
  local players = {};
  for k, player in ipairs(PLAYERS.active) do
    if(team == nil or Player_GetMultiplayerTeam(player) == team) then
      players[#players+1] = player;
    end
  end

  return players;
end

function ForgeObjectListGetObjectsInGroup(object)
  local groupList = {};
  local entries = Forge_GetObjectsInGroup(object.EntryIndex);

  for k, entry in ipairs(entries) do
    groupList[#groupList+1] = InitializeObjectReferenceFromMvarId(entry);
  end

  -- If the object isn't in a group, just return it alone.
  if (#groupList == 0) then
    groupList[1] = object;
  end

  return groupList;
end

-- Adjusts grenades by the given amount, guarding against underflow/overflow.
-- Valid grenade range is 0 to 255 (one byte)
function ForgeAdjustPlayerGrenades(player, grenadeType, adjustmentAmount):void
  local maxGrenadesBeforeOverflow = 255;
  local integerAdjustmentAmount = math.floor(adjustmentAmount);
  local currentGrenadeCount = Unit_GetGrenadeCount(player, grenadeType);

  -- Player loses all held grenades if adjustment would create negative amount.
  if ((currentGrenadeCount + integerAdjustmentAmount) < 0) then
    Unit_AddGrenadeInventory(player, grenadeType, (-1*currentGrenadeCount) );
  -- Player receives enough grenades to max if adjustment would overflow
  elseif ((currentGrenadeCount + integerAdjustmentAmount) > maxGrenadesBeforeOverflow) then
    Unit_AddGrenadeInventory(player, grenadeType, (maxGrenadesBeforeOverflow-currentGrenadeCount) );
  -- Make the requested adjustment
  else
    Unit_AddGrenadeInventory(player, grenadeType, integerAdjustmentAmount);
  end
end

-- Return a player from a random index of the All Players list.
function ForgeGetRandomPlayer():object
  local allPlayers = ForgeObjectListGetPlayersOnTeam(nil);
  local randomIndex = math.random(#allPlayers);
  return allPlayers[randomIndex];
end

--
-- NAVMARKER HELPERS
--

global ForgeNavMarkerInfo = 
{
  navpointPresentationType = "mp_forge_objective",
  
  -- Icon state
  -- Icon order should match the enum nav_marker_icon in Data Types.json and the corresponding forge.forge_globals field
  -- values should match the state entries in mp_forge_objective.navpointpresentation
  iconNames = {
    "alpha",
    "bravo",
    "charlie",
    "delta",
    "echo",
    "foxtrot"
  },
  iconStateGroupName = "icon_state",
    
  -- Ownership state
  ownershipStateGroupName = "ownership_state",
  ownershipStateDefault = "neutral",
  ownershipStateFriendly = "friendly",
  ownershipStateEnemy = "enemy"
}

function ForgeCreateNavMarker():table
  local navMarker = {
    navpointPresentation = Navpoint_Create(ForgeNavMarkerInfo.navpointPresentationType);
  };
  
  local navpointPresentation = navMarker.navpointPresentation;
  
  -- Visibility
  Navpoint_SetEnabled(navpointPresentation, false);
  Navpoint_SetPositionOffset(navpointPresentation, vector(0, 0, 0));
  Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(navpointPresentation, true);
  
  -- Icon state
  local iconStateName = ForgeNavMarkerInfo.iconStateGroupName;
  navMarker[iconStateName] = Navpoint_VisualStates_CreateState(navpointPresentation);
  Navpoint_VisualStates_SetStateGroupName(navpointPresentation, navMarker[iconStateName], iconStateName);
  Navpoint_VisualStates_SetStateUnfilteredName(navpointPresentation, navMarker[iconStateName], ForgeNavMarkerInfo.iconNames[1]);

  -- Ownership state
  local ownershipStateName = ForgeNavMarkerInfo.ownershipStateGroupName;
  navMarker[ownershipStateName] = Navpoint_VisualStates_CreateState(navpointPresentation);
  Navpoint_VisualStates_SetStateGroupName(navpointPresentation, navMarker[ownershipStateName], ownershipStateName);
  Navpoint_VisualStates_SetStateUnfilteredName(navpointPresentation, navMarker[ownershipStateName], ForgeNavMarkerInfo.ownershipStateDefault);
  
  return navMarker;
end

function ForgeSetNavMarkerIcon(navMarker, iconIndex:number)
  Navpoint_VisualStates_SetStateUnfilteredName(navMarker.navpointPresentation, navMarker[ForgeNavMarkerInfo.iconStateGroupName], ForgeNavMarkerInfo.iconNames[iconIndex]);
end

function ForgeClearNavMarkerFriendlyTeamFilter(navMarker)
  local ownershipStateGroupName = ForgeNavMarkerInfo.ownershipStateGroupName;
  local navpointPresentation = navMarker.navpointPresentation;
  if (navMarker.allyFilter ~= nil)then
    Navpoint_VisualStates_RemoveFilter(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.allyFilter);
  end
  if (navMarker.enemyFilter ~= nil)then
    Navpoint_VisualStates_RemoveFilter(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.enemyFilter);
  end
end

function ForgeSetNavMarkerFriendlyTeamFilter(navMarker, team)
  ForgeClearNavMarkerFriendlyTeamFilter(navMarker);
  
  local ownershipStateGroupName = ForgeNavMarkerInfo.ownershipStateGroupName;
  local navpointPresentation = navMarker.navpointPresentation;
  local teamDesignator = Team_GetTeamDesignator(team);
  
  navMarker.allyFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(navpointPresentation, navMarker[ownershipStateGroupName]);
  Navpoint_VisualStateFilter_SetTeamDesignator(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.allyFilter, teamDesignator);
  Navpoint_VisualStateFilter_SetStateFilteredName(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.allyFilter, ForgeNavMarkerInfo.ownershipStateFriendly);

  navMarker.enemyFilter = Navpoint_VisualStates_CreateTeamDesignatorFilter(navpointPresentation, navMarker[ownershipStateGroupName]);
  Navpoint_VisualStateFilter_SetTeamDesignator(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.enemyFilter, teamDesignator);
  Navpoint_VisualStateFilter_SetNegate(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.enemyFilter, true);
  Navpoint_VisualStateFilter_SetStateFilteredName(navpointPresentation, navMarker[ownershipStateGroupName], navMarker.enemyFilter, ForgeNavMarkerInfo.ownershipStateEnemy);

end

function ForgeClearNavMarkerVisibilityFilter(navMarker)
  if (navMarker.visibilityFilter ~= nil)then
    Navpoint_VisibilityFilter_RemoveFilter(navMarker.navpointPresentation, navMarker.visibilityFilter);
  end
  Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(navMarker.navpointPresentation, true);
end

function ForgeSetNavMarkerTeamVisibilityFilter(navMarker, team, isNegate)
  if (navMarker.visibilityFilter ~= nil)then
    Navpoint_VisibilityFilter_RemoveFilter(navMarker.navpointPresentation, navMarker.visibilityFilter);
  end
  navMarker.visibilityFilter = Navpoint_VisibilityFilter_CreateTeamDesignatorFilter(navMarker.navpointPresentation);
  Navpoint_VisibilityFilter_SetTeamDesignator(navMarker.navpointPresentation, navMarker.visibilityFilter, Team_GetTeamDesignator(team));
  Navpoint_VisibilityFilter_SetNegate(navMarker.navpointPresentation, navMarker.visibilityFilter, isNegate);
end

function ForgeSetNavMarkerText(navMarker, navText:string_id):void
  if (navText ~= nil) then
    Navpoint_SetDisplayText(navMarker.navpointPresentation, navText);
  else
    Navpoint_SetDisplayText(navMarker.navpointPresentation, "");
  end
end


---
--- Print to Killfeed nodes -> Response Lua defined in D:\Mars\Shiva\P4Main\tags\multiplayer\lua\gamemodes\forge\forge.lua
---
function ForgePrintBooleanToKillfeed(booleanToPrint:boolean):void
  if ( booleanToPrint ~= nil) then
    
    if (booleanToPrint) then
      MPLuaCall("__OnPrintTrueBooleanToKillfeed");
    else
      MPLuaCall("__OnPrintFalseBooleanToKillfeed");
    end

  else
    MPLuaCall("__OnPrintNilToKillfeed");
  end
end

function ForgePrintNumberToKillfeed(numberToPrint:number):void
  -- TODO
  -- The value of this number will be unexpectedly off due to the way floats are converted
  -- For example, if you pass 1.5, killfeed will contain 1.499869
  -- CL 3696540 had a fix for the %i integer parsing.  Will be publish new iteration on this
  -- after speaking with Nick Harrison when he returns.
  --
  -- Fallback plan is to convert the float into 3 integers and use integer parameters to format:
  --    MPLuaCall("_OnPrintNumberToKillFeed", numWhole,numFirstDecimal,numSecondDecimal);
  --    Forge.txt: forge_ngs_rounded_float_example = "Debug: %i.%i%i"
  if (numberToPrint ~= nil) then
    MPLuaCall("__OnPrintNumberToKillfeed", numberToPrint);
  else
    MPLuaCall("__OnPrintNilToKillfeed");
  end
end

function ForgePrintPlayerToKillfeed(player):void
  if (player ~= nil) then
    MPLuaCall("__OnPrintPlayerToKillfeed", player);
  else
    MPLuaCall("__OnPrintNilToKillfeed");
  end
end

function ForgePrintVectorToKillfeed(vectorToPrint:vector):void
    -- TODO
  -- The value of this number will be unexpectedly off due to the way floats are converted
  -- For example, if you pass 1.5, killfeed will contain 1.499869
  -- CL 3696540 had a fix for the %i integer parsing.  Will be publish new iteration on this
  -- after speaking with Nick Harrison when he returns.
  --
  -- Fallback plan is to convert the float into 3 integers and use integer parameters to format:
  --    MPLuaCall("_OnPrintNumberToKillFeed", numWhole,numFirstDecimal,numSecondDecimal);
  --    Forge.txt: forge_ngs_rounded_float_example = "Debug: %i.%i%i"
  if (vectorToPrint ~= nil) then
    MPLuaCall("__OnPrintVectorToKillfeed", vectorToPrint.x, vectorToPrint.y, vectorToPrint.z);
  else
    MPLuaCall("__OnPrintNilToKillfeed");
  end
end


--Wrapper function for Unit_GetInventoryWeapons() that clamps.
function ForgeGetUnitInventoryWeaponsAtIndex(player, i):object
  --Players should only be able to hold a primary & secondary weapon, so clamp to 1 or 2.
  if ( (i < 1) or (i > 2) ) then
    return nil;
  end
  
  local playerWeaponInventory = Unit_GetInventoryWeapons(player);
  return playerWeaponInventory[i];
end

---
--- Forge UI Messages
---

-- A template is made up of a template name and three functions that retrieve parameters from the ForgeUIMessageParameters struct.
-- This is the what the schema returns for the "message_template" data type.
--
-- Because the UI parses string_id tokens in order, we need to provide the parameters in a different
-- order for each template.  The Data_Type schema entry for each template must define its own function
-- on how to access the first parameter, another for how to access the second parameter, and a third for 
-- how to access the third parameter.  The functions are provided when it calls the constructor.
-- We do this to avoid a nasty switch-case where we order each set of parameters based on template name.
-- This abstraction should make it easy to add a new template because we only have to add:
--   -> The string and label in forge_nodegraph.txt
--   -> The Data Types enum for message templates that defines the functions
hstructure ForgeUIMessageTemplate
  name : string_id;
  
  get_template_param1 : ifunction;
  get_template_param2 : ifunction;
  get_template_param3 : ifunction;
end


function ForgeCreateUIMessageTemplate(messageTemplateName:string_id, param1:ifunction, param2:ifunction, param3:ifunction):ForgeUIMessageTemplate
  local messageTemplate:ForgeUIMessageTemplate = hmake ForgeUIMessageTemplate
  {
    name = messageTemplateName;

    get_template_param1 = param1;
    get_template_param2 = param2;
    get_template_param3 = param3;
  };
  return messageTemplate;
end



-- This is what the Create UI Message node stores its input parameters in to couple with a template.
-- As such, this struct is tightly coupled to the pins on the Create UI Message node.
-- If those input pin data types change, need to change these. Also need to change the functions in the schema that retrieve them.
--
-- The parameters struct doesn't care about order because we use the ForgeUIMessageTemplate to abstract order.
hstructure ForgeUIMessageParameters
  string_id1 : string_id;
  string_id2 : string_id;
  player : object;
end

function ForgeCreateUIMessageParameters(strid1:string_id, strid2:string_id, playerForgeObject:object):ForgeUIMessageParameters
  -- Player is only optionally provided by the node (since not all templates require a player), so avoid indexing nil
  local p = nil;
  if (playerForgeObject ~= nil) then
    p = playerForgeObject.PlayerIndex;
  end

  local messageParameters:ForgeUIMessageParameters = hmake ForgeUIMessageParameters
  {
    string_id1 = strid1;
    string_id2 = strid2;
    player = p;
  };

  return messageParameters;
end



-- One final struct to combine both a template and params.  
-- This struct offers a simple contract for consuming functions because it handles handles the ordering and thus the most efficient use of a node's input pins.
-- Uses the special "any" data type so that it doesn't need to change if the Create UI Message node does.
-- Sample expressionBlock for the node: "ForgeCreateUIMessage(@Message Template$, ForgeCreateUIMessageParameters(@String 1$, @String 2$, @Player$))"
hstructure ForgeUIMessage
  templateName : string_id;
  
  arg_1 : any;
  arg_2 : any;
  arg_3 : any;
end

function ForgeCreateUIMessage(template:ForgeUIMessageTemplate, params:ForgeUIMessageParameters):ForgeUIMessage

  -- Parameters that are nil will fill in with the missingInputPin.  
  local messageArg_1 = template.get_template_param1(params) or 'forge_ngs_messages_template_missinginputpin';
  local messageArg_2 = template.get_template_param2(params) or 'forge_ngs_messages_template_missinginputpin';
  local messageArg_3 = template.get_template_param3(params) or 'forge_ngs_messages_template_missinginputpin';
  
  local message:ForgeUIMessage = hmake ForgeUIMessage
  {
    templateName = template.name;

    arg_1 = messageArg_1;
    arg_2 = messageArg_2;
    arg_3 = messageArg_3;
  };
  return message;
end


---
--- Forge Splash Messages
---

-- Splash banner animation minimum is ~2.2 seconds, so clamp duration to provide a comfortable floor for the animation to finish if the user picks a lower value.
function ForgePushSplashToPlayer(targetPlayer:object, duration:number, message:ForgeUIMessage):void
  local clampedDuration = math.max(duration, 2.5); 
  Splash_PushToPlayer(targetPlayer, clampedDuration, message.templateName, message.arg_1, message.arg_2, message.arg_3);
end

-- Helper function for the PushSplashToPlayersOnTeam node.  Doesn't map to a player-facing node.
function ForgePushSplashToPlayers(players:table, duration:number, message:ForgeUIMessage):void
  for i, player in ipairs(players) do
    ForgePushSplashToPlayer(player, duration, message);
  end
end

-- Get the players on the given team and use the helper function to push a splash to each of them.
-- Passing 'nil' for the team will push splash to all players.
function ForgePushSplashToPlayersOnTeam(team:mp_team, duration:number, message:ForgeUIMessage):void
  local playersOnTeam:table = ForgeGetPlayersOnTeam(team);
  ForgePushSplashToPlayers(playersOnTeam, duration, message);
end

-- Get the players on all teams and push a splash to each team.
function ForgePushSplashToAllPlayers(duration:number, message:ForgeUIMessage):void
  ForgePushSplashToPlayersOnTeam(nil, duration, message);
end


---
--- Tag Combos to represent Weapons, Vehicles, and Equipment
---

-- Weapons, vehicles, and equipment are all combinations of a definition tag and a config tag.
hstructure ForgeTagDefinitionConfigComboStruct
  definition : tag;
  configuration : tag;
end

function ForgeCreateTagDefinitionConfigComboStruct(definitionTag:tag, configurationTag:tag):ForgeTagDefinitionConfigComboStruct
  local vehicle:ForgeTagDefinitionConfigComboStruct = hmake ForgeTagDefinitionConfigComboStruct
  {
    definition = definitionTag,
    configuration = configurationTag,
  };

  return vehicle;
end

-- If the definitions are nil, OR the defintion + config match, then we've got the same item type.
function ForgeAreSameTagComboType(objectA:ForgeTagDefinitionConfigComboStruct, objectB:ForgeTagDefinitionConfigComboStruct):boolean
  return  ( objectA.definition == nil and objectB.definition == nil ) or
          ( 
            ( objectA.definition == objectB.definition and objectA.definition ~= nil ) and
            ( objectA.configuration == objectB.configuration and objectA.configuration ~= nil )
          );
end

---
--- Vehicle Types
---

function ForgeGetForgeVehicleType(vehicle:object):ForgeTagDefinitionConfigComboStruct
  local vehicleDefinition:tag = Vehicle_GetDefinition(vehicle);
  local vehicleConfiguration:tag = Vehicle_GetConfigDefinition(vehicle);

  return ForgeCreateTagDefinitionConfigComboStruct(vehicleDefinition, vehicleConfiguration);
end

---
--- Set Spawn In Vehicle
---

-- Causes a player to respawn in the vehicle defintion/configuration combo given if true, sets player to spawn as infantry if false.
function ForgeSetSpawnInVehicleForPlayer(enabled:boolean, player:object, vehicleDefinitionTag:tag, vehicleConfigurationTag:tag):void
  print("Set to Spawn...");
  print(vehicleDefinitionTag);
  print(vehicleConfigurationTag);  
  if (enabled) then
      Player_SetSpawnInVehicle(player, vehicleDefinitionTag, vehicleConfigurationTag);
    else
      Player_SetSpawnInVehicle(player, nil, nil);
    end
end

-- Helper function for the Set Spawn in Vehicle For Player node.  Doesn't map to a player-facing node.
function ForgeSetSpawnInVehicleForPlayers(enabled:boolean, players:table, vehicleDefinitionTag:tag, vehicleConfigurationTag:tag):void
  for i, player in ipairs(players) do
    ForgeSetSpawnInVehicleForPlayer(enabled, player, vehicleDefinitionTag, vehicleConfigurationTag);
  end
end

-- Get the players on the given team and use the helper function to Set Spawn in Vehicle for each of them.
function ForgeSetSpawnInVehicleForTeam(enabled:boolean, team:mp_team, vehicleDefinitionTag:tag, vehicleConfigurationTag:tag):void
  local playersOnTeam:table = ForgeGetPlayersOnTeam(team);
  ForgeSetSpawnInVehicleForPlayers(enabled, playersOnTeam, vehicleDefinitionTag, vehicleConfigurationTag);
end

-- Get all players and Set Spawn in Vehicle for each of them.
function ForgeSetSpawnInVehicleForAllPlayers(enabled:boolean, vehicleDefinitionTag:tag, vehicleConfigurationTag:tag):void
  ForgeSetSpawnInVehicleForTeam(enabled, nil, vehicleDefinitionTag, vehicleConfigurationTag);
end