
#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	// Initialize tables of loadouts per personality and per difficulty
	
	level.botClassFile = "mp/botClassTable.csv";

	level.botLoadoutSets = [];
	fieldArray = bot_loadout_fields();
	column = 0;

	for(;;)
	{
		column++;
		
		strPers = tableLookup( level.botClassFile, 0, "botPersonalities", column );
		strDiff = tableLookup( level.botClassFile, 0, "botDifficulties", column );
		
		if ( !isDefined( strPers ) || (strPers == "") )
			break;
		
		if ( !isDefined( strDiff ) || (strDiff == "") )
			break;
		
		loadoutValues = [];				
		foreach ( field in fieldArray )	
		{
			loadoutValues[field] = tableLookup( level.botClassFile, 0, field, column );	
			/#
			if ( (loadoutValues[field] != "none") && loadoutValues[field] != "specialty_null" && string_starts_with( field, "loadoutStreak" ) && !IsDefined( level.killstreak_botfunc[ loadoutValues[field] ] ) )
			{
				error( "_bots_loadout::init() invalid killstreak <" + loadoutValues[field] + "> in loadout for <" + strDiff + ", " + strPers + ">" );
				loadoutValues[field] = "none";
			}
			#/
		}
		
		personalities = StrTok( strPers, "| " );
		difficulties = StrTok( strDiff, "| " );

		foreach ( personality in personalities )
		{
			foreach ( difficulty in difficulties )
			{
				loadoutSet = bot_loadout_set( personality, difficulty, true );
				loadout = SpawnStruct();
				loadout.loadoutValues = loadoutValues;
				loadoutSet.loadouts[loadoutSet.loadouts.size] = loadout;
			}
		}
	}
}

bot_loadout_fields()
{
	result = [];
	result[result.size] = "loadoutPrimary";
	result[result.size] = "loadoutPrimaryBuff";
	result[result.size] = "loadoutPrimaryAttachment";
	result[result.size] = "loadoutPrimaryAttachment2";
	result[result.size] = "loadoutPrimaryAttachment3";
	result[result.size] = "loadoutPrimaryCamo";
	result[result.size] = "loadoutPrimaryReticle";
	result[result.size] = "loadoutSecondary";
	result[result.size] = "loadoutSecondaryBuff";
	result[result.size] = "loadoutSecondaryAttachment";
	result[result.size] = "loadoutSecondaryAttachment2";
	result[result.size] = "loadoutSecondaryAttachment3";
	result[result.size] = "loadoutSecondaryCamo";
	result[result.size] = "loadoutSecondaryReticle";
	result[result.size] = "loadoutEquipment";
	result[result.size] = "loadoutPerk1";
	result[result.size] = "loadoutPerk2";
	result[result.size] = "loadoutPerk3";
	result[result.size] = "loadoutPerk4";
	result[result.size] = "loadoutPerk5";
	result[result.size] = "loadoutPerk6";
	result[result.size] = "loadoutOffhand";
	result[result.size] = "loadoutStreak1";
	result[result.size] = "loadoutStreak2";
	result[result.size] = "loadoutStreak3";
	result[result.size] = "loadoutStreaktype";
	result[result.size] = "loadoutCharacterType";
	result[result.size] = "loadoutCharacterImage";
	result[result.size] = "loadoutActiveAbility";
	result[result.size] = "loadoutPassiveAbility";
	return result;
}

bot_loadout_set( personality, difficulty, createIfNeeded )
{
	setName = difficulty + "_" + personality;

	if ( !isDefined( level.botLoadoutSets ) )
		level.botLoadoutSets = [];
	
	if ( !isDefined( level.botLoadoutSets[setName] ) && createIfNeeded )
	{
		level.botLoadoutSets[setName] = SpawnStruct();
		level.botLoadoutSets[setName].loadouts = [];
	}
	
	if ( isDefined( level.botLoadoutSets[setName] ) )
		return level.botLoadoutSets[setName];
}

bot_loadout_pick( personality, difficulty )
{
	loadoutSet = bot_loadout_set( personality, difficulty, false );	
	if ( IsDefined( loadoutSet ) && isDefined( loadoutSet.loadouts ) && loadoutSet.loadouts.size > 0 )
	{
		loadoutChoice = RandomInt( loadoutSet.loadouts.size );
		return loadoutSet.loadouts[loadoutChoice].loadoutValues;
	}
}

bot_validate_weapon( weaponName, attachment, attachment2  )
{
	/*
	weaponAttachmentTable = "mp/attachmenttable_" + weaponName + ".csv";
	attachmentComboTable = "mp/attachmentcombos.csv";
	
	if ( TableLookupRowNum( weaponAttachmentTable, 0, attachment ) < 0 )
		return false;
	
	if ( TableLookupRowNum( weaponAttachmentTable, 0, attachment2 ) < 0 )
		return false;	

	attachmentRow = TableLookupRowNum( attachmentComboTable, 0, attachment );
	if ( attachmentRow >= 0 )
	{
		columnHeader = "no";
		column = 0;
		
		while ( columnHeader != "" )
		{
			columnHeader = TableLookupByRow( attachmentComboTable, 0, column );
			if ( columnHeader == attachment2 )
			{
				allowed = TableLookupByRow( attachmentComboTable, attachmentRow, column );
				if ( allowed == "no" )
					return false;
				else
					return true;
			}
			column++;
		}
	}
	*/
	return true;
}

bot_loadout_valid_choice( loadoutValueArray, loadoutValueName, choice )
{
  valid = true;
  
  switch ( loadoutValueName )
  {
    case "loadoutPrimaryBuff":
	    valid = maps\mp\gametypes\_class::isValidWeaponBuff( choice, loadoutValueArray["loadoutPrimary"] );
	    break;
    case "loadoutPrimaryAttachment":
	    valid = bot_validate_weapon( loadoutValueArray["loadoutPrimary"], choice, "none" );
	    break;
    case "loadoutPrimaryAttachment2":
	    valid = bot_validate_weapon( loadoutValueArray["loadoutPrimary"], loadoutValueArray["loadoutPrimaryAttachment"], choice );
	    break;
	    
    case "loadoutSecondaryBuff":
	    valid = maps\mp\gametypes\_class::isValidWeaponBuff( choice, loadoutValueArray["loadoutSecondary"] );
	    break;
    case "loadoutSecondaryAttachment":
	    valid = bot_validate_weapon( loadoutValueArray["loadoutSecondary"], choice, "none" );
	    break;
    case "loadoutSecondaryAttachment2":
	    valid = bot_validate_weapon( loadoutValueArray["loadoutSecondary"], loadoutValueArray["loadoutSecondaryAttachment"], choice );
	    break;
    case "loadoutPrimaryCamo":
	    valid = (!IsDefined( self.botLoadoutFavoriteCamo ) || (choice == self.botLoadoutFavoriteCamo));
	    break;
  };

  return valid;
}

bot_loadout_choose_values( loadoutValueArray )
{
	foreach( loadoutValueName, loadoutValue in loadoutValueArray )
	{
		valueChoices = StrTok( loadoutValue, "| " );		
		validCount = 0.0;
		chosenValue = "none";
		
		foreach ( choice in valueChoices )
		{
			if ( bot_loadout_valid_choice( loadoutValueArray, loadoutValueName, choice ) )
			{
				validCount = validCount + 1.0;
				if ( RandomFloat( 1.0 ) <= (1.0 / validCount) )
					chosenValue = choice;
			}
		}
		
/#
		debugLoadoutValue = GetDvar( "bot_Debug" + loadoutValueName, "" );
		if ( IsDefined( debugLoadoutValue ) && debugLoadoutValue != "" )
			chosenValue = debugLoadoutValue;
#/		

		loadoutValueArray[loadoutValueName] = chosenValue;	
	}
	
	return loadoutValueArray;
}

bot_loadout_choose_attributes( loadoutValueArray )
{
	weapClass = getWeaponClass( loadoutValueArray["loadoutPrimary"] );
	
  	switch ( weapClass )
  	{
  		case "weapon_sniper":
  			loadoutValueArray["loadoutAttributePower"] 		= "100";
			loadoutValueArray["loadoutAttributeRange"] 		= "100";
			loadoutValueArray["loadoutAttributeMobility"] 	=  "70";
  			break;
  		case "weapon_shotgun":
			loadoutValueArray["loadoutAttributePower"] 		=  "90";
			loadoutValueArray["loadoutAttributeRange"] 		=  "10";
			loadoutValueArray["loadoutAttributeMobility"] 	= "100";
  			break;
  		default:
			loadoutValueArray["loadoutAttributePower"] 		=  "60";
			loadoutValueArray["loadoutAttributeRange"] 		=  "70";
			loadoutValueArray["loadoutAttributeMobility"] 	=  "50";
  			break;
  	}
  	
  	return loadoutValueArray;
}

bot_loadout_class_callback()
{   	
	// temp soultion to maually set a class on a bot for siege mode
	if( IsDefined( self.siege_ai_type) && (self.siege_ai_type == 0) )
	{
		loadoutValueArray["loadoutPrimary"] 				= "riotshield";
		loadoutValueArray["loadoutPrimaryAttachment"] 		= "none";
		loadoutValueArray["loadoutPrimaryAttachment2"] 		= "none";
		loadoutValueArray["loadoutPrimaryBuff"] 			= "specialty_null";
		loadoutValueArray["loadoutPrimaryCamo"] 			= "none";
		loadoutValueArray["loadoutPrimaryReticle"] 			= "none";
		loadoutValueArray["loadoutSecondary"] 				= "none";		
		loadoutValueArray["loadoutSecondaryAttachment"] 	= "none";
		loadoutValueArray["loadoutSecondaryAttachment2"] 	= "none";
		loadoutValueArray["loadoutSecondaryBuff"] 			= "specialty_null";
		loadoutValueArray["loadoutSecondaryCamo"] 			= "none";
		loadoutValueArray["loadoutSecondaryReticle"] 		= "none";
		loadoutValueArray["loadoutEquipment"] 				= "frag_grenade_mp";
		loadoutValueArray["loadoutOffhand"] 				= "smoke_grenade_mp";
		loadoutValueArray["loadoutActiveAbility"] 			= "specialty_null";
		loadoutValueArray["loadoutPassiveAbility"] 			= "specialty_null";
		loadoutValueArray["loadoutPerk1"] 					= "specialty_null";
		loadoutValueArray["loadoutPerk2"] 					= "specialty_null";
		loadoutValueArray["loadoutPerk3"] 					= "specialty_null";
		loadoutValueArray["loadoutStreakType"]				= "streaktype_assault";
		loadoutValueArray["loadoutStreak1"]					= "none";
		loadoutValueArray["loadoutStreak2"]					= "none";
		loadoutValueArray["loadoutStreak3"]					= "none";
		
		return loadoutValueArray;
	}
	
	personality = self BotGetPersonality();
	difficulty = self BotGetDifficulty();

	// If bot already has a loadout, stick with it most of the time
	if ( IsDefined( self.botLastLoadout ) && (self.botLastLoadoutDifficulty == difficulty) && (self.botLastLoadoutPersonality == personality) )
	{
		if ( RandomFloat( 1.0 ) > 0.25 )
			return self.botLastLoadout;
	}

	loadoutValueArray = self bot_loadout_pick( personality, difficulty );
	loadoutValueArray = self bot_loadout_choose_values( loadoutValueArray );
	loadoutValueArray = self bot_loadout_choose_attributes( loadoutValueArray );
		
	self.botLastLoadout = loadoutValueArray;
	self.botLastLoadoutDifficulty = difficulty;
	self.botLastLoadoutPersonality = personality;
	
	if ( IsDefined( loadoutValueArray["loadoutPrimaryCamo"] ) && loadoutValueArray["loadoutPrimaryCamo"] != "none" )
		self.botLoadoutFavoriteCamo = loadoutValueArray["loadoutPrimaryCamo"];
	
	return loadoutValueArray;
}

bot_setup_loadout_callback()
{
	personality = self BotGetPersonality();
	difficulty = self BotGetDifficulty();
	
	loadoutSet = bot_loadout_set( personality, difficulty );
	if ( IsDefined( loadoutSet ) && isDefined( loadoutSet.loadouts ) && loadoutSet.loadouts.size > 0 )
	{
		self.classCallback = ::bot_loadout_class_callback;
		return true;
	}
	
	self.classCallback = undefined;
	return false;
}

