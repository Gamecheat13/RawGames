#using scripts\shared\array_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#using scripts\mp\gametypes\_rank;

#using scripts\mp\bots\_bot;





	
#namespace bot_loadout;	

function init()
{
	level endon( "game_ended" );

	level.bot_banned_killstreaks = Array ( 	"KILLSTREAK_RCBOMB",
											"KILLSTREAK_QRDRONE",
											"KILLSTREAK_REMOTE_MISSILE",
											"KILLSTREAK_REMOTE_MORTAR",
											"KILLSTREAK_HELICOPTER_GUNNER" );
	for ( ;; )
	{
		level waittill( "connected", player );

		if ( !player IsTestClient() )
		{
			continue;
		}

		player thread on_bot_connect();
	}
}

function on_bot_connect()
{
	self endon( "disconnect" );

	if ( isdefined( self.pers[ "bot_loadout" ] ) )
	{
		return;
	}

	wait( 0.10 );

	if ( self GetEntityNumber() % 2 == 0 )
	{
		{wait(.05);};
	}
		
	self bot::set_rank();
	
	self BotSetRandomCharacterCustomization();

	if ( level.onlineGame && !SessionModeIsPrivate() )
	{
		self BotSetDefaultClass( 5, "class_assault" );
		self BotSetDefaultClass( 6, "class_smg" );
		self BotSetDefaultClass( 7, "class_lmg" );
		self BotSetDefaultClass( 8, "class_cqb" ); 
		self BotSetDefaultClass( 9, "class_sniper" );
	}
	else
	{
		self BotSetDefaultClass( 5, "class_assault" );
		self BotSetDefaultClass( 6, "class_smg" );
		self BotSetDefaultClass( 7, "class_lmg" );
		self BotSetDefaultClass( 8, "class_cqb" ); 
		self BotSetDefaultClass( 9, "class_sniper" );
	}

	max_allocation = 10;

	for ( i = 1; i <= 3; i++ )
	{
		if ( self IsItemLocked( rank::GetItemIndex( "feature_allocation_slot_" + i ) ) )
		{
			max_allocation--;
		}
	}

	self construct_loadout( max_allocation );
	self.pers[ "bot_loadout" ] = true;
}

function construct_loadout( allocation_max )
{
	if ( self IsItemLocked( rank::GetItemIndex( "feature_cac" ) ) )
	{
		// cac still locked
		return;
	}

	pixbeginevent( "bot_construct_loadout" );

	item_list = build_item_list();

//	item_list["primary"] = [];
//	item_list["primary"][0] = "WEAPON_RIOTSHIELD";

	construct_class( 0, item_list, allocation_max );
	construct_class( 1, item_list, allocation_max );
	construct_class( 2, item_list, allocation_max );
	construct_class( 3, item_list, allocation_max );
	construct_class( 4, item_list, allocation_max );

	killstreaks = item_list["killstreak1"];

	if ( isdefined( item_list["killstreak2"] ) )
	{
		killstreaks = ArrayCombine( killstreaks, item_list["killstreak2"], true, false );
	}

	if ( isdefined( item_list["killstreak3"] ) )
	{
		killstreaks = ArrayCombine( killstreaks, item_list["killstreak3"], true, false );
	}
		
	if ( isdefined( killstreaks ) && killstreaks.size )
	{
		choose_weapon( 0, killstreaks );
		choose_weapon( 0, killstreaks );
		choose_weapon( 0, killstreaks );
	}

	self.claimed_items = undefined;
	pixendevent();
}

function construct_class( constructclass, items, allocation_max )
{
	allocation = 0;

	claimed_count = build_claimed_list( items );
	self.claimed_items = [];

	// primary
	weapon = choose_weapon( constructclass, items["primary"] );
	claimed_count["primary"]++;
	allocation++;

	// secondary
	weapon = choose_weapon( constructclass, items["secondary"] );
	choose_weapon_option( constructclass, "camo", 1 );
}

function make_choice( chance, claimed, max_claim )
{
	return ( claimed < max_claim && RandomInt( 100 ) < chance );
}

function chose_action( action1, chance1, action2, chance2, action3, chance3, action4, chance4 )
{
	chance1 = Int( chance1 / 10 );
	chance2 = Int( chance2 / 10 );
	chance3 = Int( chance3 / 10 );
	chance4 = Int( chance4 / 10 );

	actions = [];

	for( i = 0; i < chance1; i++ )
	{
		actions[ actions.size ] = action1;
	}

	for( i = 0; i < chance2; i++ )
	{
		actions[ actions.size ] = action2;
	}

	for( i = 0; i < chance3; i++ )
	{
		actions[ actions.size ] = action3;
	}

	for( i = 0; i < chance4; i++ )
	{
		actions[ actions.size ] = action4;
	}

	return array::random( actions );
}

function item_is_claimed( item )
{
	foreach( claim in self.claimed_items )
	{
		if ( claim == item )
		{
			return true;
		}
	}

	return false;
}

function choose_weapon( weaponclass, items )
{
	if ( !isdefined( items ) || !items.size )
	{
		return undefined;
	}

	start = RandomInt( items.size );

	for( i = 0; i < items.size; i++ )
	{
		weapon = items[ start ];

		if ( !item_is_claimed( weapon ) )
		{
			break;
		}

		start = ( start + 1 ) % items.size;
	}
		
	self.claimed_items[ self.claimed_items.size ] = weapon;
	
	self BotClassAddItem( weaponclass, weapon );
	return weapon;
}

function build_weapon_options_list( optionType )
{
	level.botWeaponOptionsId[optionType] = [];
	level.botWeaponOptionsProb[optionType] = [];

	csv_filename = "gamedata/weapons/common/attachmentTable.csv";
	prob = 0;
	for ( row = 0 ; row < 255 ; row++ )
	{
		if ( tableLookupColumnForRow( csv_filename, row, 1 ) == optionType )
		{
			index = level.botWeaponOptionsId[optionType].size;
			level.botWeaponOptionsId[optionType][index] = Int( tableLookupColumnForRow( csv_filename, row, 0 ) );
			prob += Int( tableLookupColumnForRow( csv_filename, row, 15 ) );
			level.botWeaponOptionsProb[optionType][index] = prob;
		}
	}
}

function choose_weapon_option( weaponclass, optionType, primary )
{
	if ( !isdefined( level.botWeaponOptionsId ) )
	{
		level.botWeaponOptionsId = [];
		level.botWeaponOptionsProb = [];

		build_weapon_options_list( "camo" );
		build_weapon_options_list( "reticle" );
	}

	// weapon options cannot be set in local matches
	if ( !level.onlineGame && !level.systemLink )
		return;

	// Increase the range of the probability to reduce the chances of picking the option when the bot's level is less than BOT_RANK_ALL_OPTIONS_AVAILABLE
	// (in system link all options are available)
	numOptions = level.botWeaponOptionsProb[optionType].size;
	maxProb = level.botWeaponOptionsProb[optionType][numOptions-1];
	if ( !level.systemLink && self.pers[ "rank" ] < 20 )
		maxProb += 4 * maxProb * ( ( 20 - self.pers[ "rank" ] ) / 20 );

	rnd = RandomInt( Int( maxProb ) );
	for (i=0 ; i<numOptions ; i++)
	{
		if ( level.botWeaponOptionsProb[optionType][i] > rnd )
		{
			self BotClassSetWeaponOption( weaponclass, primary, optionType, level.botWeaponOptionsId[optionType][i] );
			break;
		}
	}
}

function choose_primary_attachments( weaponclass, weapon, allocation, allocation_max )
{
	attachments = weapon.supportedAttachments;
	remaining = allocation_max - allocation;

	if ( !attachments.size || !remaining )
	{
		return 0;
	}

	attachment_action = chose_action( "3_attachments", 25, "2_attachments", 35, "1_attachments", 35, "none", 5 );

	if ( remaining >= 4 && attachment_action == "3_attachments" )
	{
		a1 = array::random( attachments );
		self BotClassAddAttachment( weaponclass, weapon, a1, "primaryattachment1" );
		count = 1;

		attachments = GetWeaponAttachments( weapon, a1 );

		if ( attachments.size )
		{
			a2 = array::random( attachments );
			self BotClassAddAttachment( weaponclass, weapon, a2, "primaryattachment2" );
			count++;

			attachments = GetWeaponAttachments( weapon, a1, a2 );

			if ( attachments.size )
			{
				a3 = array::random( attachments );
				self BotClassAddItem( weaponclass, "BONUSCARD_PRIMARY_GUNFIGHTER" );
				self BotClassAddAttachment( weaponclass, weapon, a3, "primaryattachment3" );
				return 4;
			}
		}

		return count;
	}
	else if ( remaining >= 2 && attachment_action == "2_attachments" )
	{
		a1 = array::random( attachments );
		self BotClassAddAttachment( weaponclass, weapon, a1, "primaryattachment1" );

		attachments = GetWeaponAttachments( weapon, a1 );

		if ( attachments.size )
		{
			a2 = array::random( attachments );
			self BotClassAddAttachment( weaponclass, weapon, a2, "primaryattachment2" );
			return 2;
		}

		return 1;
	}
	else if ( remaining >= 1 && attachment_action == "1_attachments" )
	{
		a = array::random( attachments );
		self BotClassAddAttachment( weaponclass, weapon, a, "primaryattachment1" );
		return 1;
	}

	return 0;
}

function choose_secondary_attachments( weaponclass, weapon, allocation, allocation_max )
{
	attachments = weapon.supportedAttachments ;
	remaining = allocation_max - allocation;

	if ( !attachments.size || !remaining )
	{
		return 0;
	}

	attachment_action = chose_action( "2_attachments", 10, "1_attachments", 40, "none", 50, "none", 0 );

	if ( remaining >= 3 && attachment_action == "2_attachments" )
	{
		a1 = array::random( attachments );
		self BotClassAddAttachment( weaponclass, weapon, a1, "secondaryattachment1" );

		attachments = GetWeaponAttachments( weapon, a1 );

		if ( attachments.size )
		{
			a2 = array::random( attachments );
			self BotClassAddItem( weaponclass, "BONUSCARD_SECONDARY_GUNFIGHTER" );
			self BotClassAddAttachment( weaponclass, weapon, a2, "secondaryattachment2" );
			return 3;
		}

		return 1;
	}
	else if ( remaining >= 1 && attachment_action == "1_attachments" )
	{
		a = array::random( attachments );
		self BotClassAddAttachment( weaponclass, weapon, a, "secondaryattachment1" );
		return 1;
	}

	return 0;
}

function build_item_list()
{
	pixbeginevent( "bot_build_item_list" );

	items = [];
	
	for( i = 0; i < 256; i++ )
	{
		row = tableLookupRowNum( level.statsTableID, 0, i );

		if ( row > -1 )
		{
			slot = tableLookupColumnForRow( level.statsTableID, row, 13 );

			if ( slot == "" )
			{
				continue;
			}

			number = Int( tableLookupColumnForRow( level.statsTableID, row, 0 ) );
			
			if ( self IsItemLocked( number ) )
			{
				continue;
			}

			allocation = Int( tableLookupColumnForRow( level.statsTableID, row, 12 ) );

			if ( allocation < 0 )
			{
				continue;
			}

			name = tableLookupColumnForRow( level.statsTableID, row, 3 );

			if ( item_is_banned( slot, name ) )
			{
				continue;
			}

			if ( !isdefined( items[slot] ) )
			{
				items[slot] = [];
			}

			items[ slot ][ items[slot].size ] = name;
		}
	}

	pixendevent();
	return items;
}

function item_is_banned( slot, item )
{
	if ( item == "WEAPON_KNIFE_BALLISTIC" )
	{
		return true;
	}
		
	if ( GetDvarInt("tu6_enableDLCWeapons") == 0 && item == "WEAPON_PEACEKEEPER" )
	{
		return true;
	}
		
	if ( slot != "killstreak1" && slot != "killstreak2" && slot != "killstreak3" )
	{
		return false;
	}

	foreach( banned in level.bot_banned_killstreaks )
	{
		if ( item == banned )
		{
			return true;
		}
	}

	return false;
}

function build_claimed_list( items )
{
	claimed = [];
	keys = GetArrayKeys( items );

	foreach( key in keys )
	{
		claimed[ key ] = 0;
	}

	return claimed;
}