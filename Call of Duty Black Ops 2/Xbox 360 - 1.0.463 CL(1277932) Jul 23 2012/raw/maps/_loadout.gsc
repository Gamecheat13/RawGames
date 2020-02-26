#include common_scripts\utility;
#include maps\_utility;

init_loadout()
{
	// MikeD (7/30/2007): New method of precaching/giving weapons.
	// Set the level variables.
	if( !IsDefined( level.player_loadout ) )
	{
		level.player_loadout = [];
		level.player_loadout_options = [];
		level.player_loadout_slots = [];
	}
	if( !IsDefined( level.player_perks ) )
	{
		level.player_perks = [];
	}

	// CODER MOD
	// With the player joining later now we need to precache all weapons for the level
	animscripts\assign_weapon::assign_weapon_init();
	init_models_and_variables_loadout();
	
	players = get_players("all");
	for ( i = 0; i < players.size; i++ )
	{
		players[i] give_loadout();
		players[i].pers["class"] = "closequarters";
	}
	level.loadoutComplete = true;
	level notify("loadout complete");
	
	
	//TODO: this is where we add in other player types, besides US Marine
	
}

init_melee_weapon()
{
	if(  level.script == "frontend" )
	{
	}
	else if( level.script == "angola" || level.script == "angola_2" )
	{
		add_weapon( "machete_sp" );
	}
	else
	{
		add_weapon( "knife_sp" );
	}
}

init_loadout_weapons()
{
	init_melee_weapon();

	if( level.script == "m202_sound_test" )
	{
		// SCRIPTER_MOD
		// MikeD (3/16/2007): Testmap for Coop
	
		//-- Kept in as an example
		add_weapon( "rpg_player_sp" );
		add_weapon( "m202_flash_sp" );
		add_weapon( "strela_sp" );
		add_weapon( "m220_tow_sp" );
		add_weapon( "china_lake_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "rpg_player_sp" );
		
		return;
	}
	// all test maps
	else if( GetSubStr( level.script, 0, 6 ) == "sp_t5_" )
	{
		add_weapon( "m16_sp" );
		add_weapon( "m1911_sp" );
		set_switch_weapon( "m16_sp" );
		
		set_laststand_pistol( "m1911_sp" );
		set_switch_weapon( "m16_sp" );
		
		return;		
	}
	else if( GetSubStr( level.script, 0, 6 ) == "sp_t6_")
	{
	}
	else if(  level.script == "frontend" )
	{
		set_laststand_pistol( "none" );
		
		return;		
	}
	else if ( level.script == "outro"  )
	{
		set_laststand_pistol( "none" );
		
		return;		
	}
	else if( IsSubStr( level.script, "intro_" ) ) // Support for the intro movies for the campaigns
	{
		return;
	}
	else if( GameModeIsMode( level.GAMEMODE_RTS ) || IsSubStr( level.script, "so_rts" ) )
	{
		animscripts\assign_weapon::assign_weapon_allow_random_attachments( true );
		animscripts\assign_weapon::build_weight_array_by_faction( "so", true, 40, 20, 50, 0, 20);
		//add the normal frag grenade because this it what th eplayer will return in some cases - even though not in his inventory
		PrecacheItem( "frag_grenade_sp" );
		
		return;
	}
	
	
	primary = GetLoadoutWeapon( "primary" );
	secondary = GetLoadoutWeapon( "secondary" );
	grenade = GetLoadoutItem( "primarygrenade" );
	specialgrenade = GetLoadoutItem( "specialGrenade" );

	for( i = 1; i <= 12; i++ )
	{
		perk = GetLoadoutItem( "specialty"+i );
		add_perk( perk );
	}
	
	add_weapon( primary );
	add_weapon( secondary );
	add_weapon( grenade, undefined, "primarygrenade" );
	add_weapon( specialGrenade, undefined, "specialgrenade" );
	
	if( primary != "weapon_null_sp" )
	{
		set_switch_weapon( primary );
	}
	else if( secondary != "weapon_null_sp" )
	{
		set_switch_weapon( secondary );
	}
	
	//add the normal frag grenade because this it what th eplayer will return in some cases - even though not in his inventory
	PrecacheItem( "frag_grenade_sp" );
	
}

init_viewmodels_and_campaign()
{
	if( level.script == "la_1" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		//set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "la_1b" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		//set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "la_2" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		//set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	if ( level.script == "blackout" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		set_player_interactive_hands( "c_usa_cia_masonjr_armlaunch_viewbody" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;
	}
	else if( level.script == "angola" || level.script == "angola_2" )
	{
		set_player_viewmodel( "c_usa_seal80s_mason_viewhands" );
		set_player_interactive_hands( "c_usa_seal80s_mason_viewbody" );
		set_player_interactive_model( "c_usa_seal80s_mason_viewbody" );
		level.campaign = "american";
		
		return;		
	}	
	else if( level.script == "monsoon" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		set_player_camo_viewmodel( "c_usa_cia_masonjr_viewhands_cl" );
		set_player_interactive_hands( "c_usa_cia_masonjr_armlaunch_viewbody" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "karma" || level.script == "karma_2" )
	{
		set_player_viewmodel( "c_usa_masonjr_karma_armlaunch_viewhands" );
		//set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
		set_player_interactive_model( "c_usa_masonjr_karma_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "panama" || level.script == "panama_2" || level.script == "panama_3" )
	{
		set_player_viewmodel( "c_usa_woods_panama_viewhands" );
		set_player_interactive_hands( "c_usa_woods_panama_viewbody" );
		set_player_interactive_model( "c_usa_woods_panama_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "so_cmp_afghanistan" )
	{
		set_player_viewmodel( "c_usa_mason_afgan_viewhands" );
		set_player_interactive_hands( "c_usa_mason_afgan_viewhands" );
		set_player_interactive_model( "c_usa_mason_afgan_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "yemen" )
	{
		set_player_viewmodel( "c_mul_yemen_farid_viewhands" );
		set_player_camo_viewmodel( "c_usa_cia_masonjr_viewhands_cl" );
		set_player_interactive_model( "c_mul_yemen_farid_viewbody" );
		level.campaign = "american";
		
		return;		
	}	
	else if( level.script == "pakistan" || level.script == "pakistan_2" || level.script == "pakistan_3" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		set_player_interactive_hands( "c_usa_cia_masonjr_armlaunch_viewhands" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;			
	}
	else if( level.script == "nicaragua" )
	{
		set_player_viewmodel( "c_mul_menendez_nicaragua_viewhands" );
		set_player_interactive_hands( "c_mul_menendez_nicaragua_viewhands" );
		set_player_interactive_model( "c_mul_menendez_nicaragua_viewbody" );
	}
	else if( level.script == "haiti" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		//set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		level.campaign = "american";
		
		return;		
	}
	else if( level.script == "m202_sound_test" )
	{
		set_player_viewmodel( "viewmodel_usa_marine_arms");
		set_player_interactive_hands( "viewhands_player_usmc");
		
		level.campaign = "american";
		return;
	}
	// all test maps
	else if( GetSubStr( level.script, 0, 6 ) == "sp_t5_" || GetSubStr( level.script, 0, 6 ) == "sp_t6_")
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		set_player_interactive_hands( "c_usa_cia_masonjr_viewhands" );
		
		level.campaign = "american";
		return;		
	}
	else if(  level.script == "frontend" )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_viewhands" );	
		set_player_interactive_hands( "c_usa_cia_masonjr_viewhands" );
		set_player_interactive_model( "c_usa_cia_masonjr_viewbody" );

		level.campaign = "none";
		return;		
	}	
	else if ( level.script == "outro"  )
	{
		set_laststand_pistol( "none" );

		level.campaign = "none";
		return;
	}
	else if( IsSubStr( level.script, "intro_" ) ) // Support for the intro movies for the campaigns
	{
		return;
	}
	else if( GameModeIsMode( level.GAMEMODE_RTS ) )
	{
		set_player_viewmodel( "c_usa_cia_masonjr_armlaunch_viewhands" );
		set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
		set_player_interactive_model( "c_usa_cia_masonjr_armlaunch_viewbody" );
		
		return;
	}

	set_player_viewmodel( "c_usa_cia_masonjr_viewhands" );
	set_player_interactive_hands( "viewmodel_usa_jungmar_player" );
	set_player_interactive_model( "c_usa_cia_masonjr_viewbody" );
	level.campaign = "american";
}

init_models_and_variables_loadout()
{
	init_loadout_weapons();
	init_viewmodels_and_campaign();
}

// This will precache any other weapon dependencies or secondary weapons required for the base weapon to work
do_additional_precaching( str_weapon_name )
{
	if( str_weapon_name == "titus6_sp" )
	{
		precacheitem("exptitus6_sp");	
		precacheitem("titus6_sp");	
		precacheitem("titus_explosive_dart_sp");
	}
//	if( str_weapon_name == "emp_grenade_sp" )
//	{
//		precacheitem("emp_grenade_stage2_sp");	
//	}
}

// This will precache and set the loadout rather than duplicating work.
add_weapon( weapon_name, options, slot_instructions )
{
	if( !IsDefined( weapon_name ) || weapon_name == "weapon_null_sp" )
	{
		return;
	}
	
	PrecacheItem( weapon_name );
	do_additional_precaching( weapon_name );
	level.player_loadout[level.player_loadout.size] = weapon_name;
	if( !isdefined( options ) )
	{
		options = -1;
	}
	level.player_loadout_options[level.player_loadout_options.size] = options;
	
	if( !IsDefined( slot_instructions ) )
	{
		slot_instructions = "";
	}
	level.player_loadout_slots[level.player_loadout_slots.size] = slot_instructions;
}

add_perk( perk_name )
{
	if( !IsDefined( perk_name ) || perk_name == "weapon_null_sp" || perk_name == "weapon_null" || perk_name == "specialty_null" )
	{
		return;
	}
	perk_specialties = strtok( perk_name, "|" );
	
	for( i = 0; i < perk_specialties.size; i++ )
	{
		level.player_perks[level.player_perks.size] = perk_specialties[i];
	}
}

// This sets the secondary offhand type when the player spawns in
set_secondary_offhand( weapon_name )
{
	level.player_secondaryoffhand = weapon_name;
}

// This sets the the switchtoweapon when the player spawns in
set_switch_weapon( weapon_name )
{
	level.player_switchweapon = weapon_name;
}

// This sets the the action slot for when the player spawns in
set_action_slot( num, option1, option2 )
{
	
	if( num < 2 || num > 4)
	{
		assertmsg( "_loadout.gsc: set_action_slot must be set with a number greater than 1 and less than 5" );
	}
	
	// Glocke 12/03/07 - added precaching of weapon type for action slot
	if(IsDefined(option1))
	{
		if(option1 == "weapon")
		{
			PrecacheItem(option2);
			level.player_loadout[level.player_loadout.size] = option2;
		}
	}

	if( !IsDefined( level.player_actionslots ) )
	{
		level.player_actionslots = [];
	}

	action_slot = SpawnStruct();
	action_slot.num = num;
	action_slot.option1 = option1;

	if( IsDefined( option2 ) )
	{
		action_slot.option2 = option2;
	}

	level.player_actionslots[level.player_actionslots.size] = action_slot;
}

set_player_viewmodel( model )
{
	PrecacheModel( model );
	level.player_viewmodel = model;
}

set_player_camo_viewmodel( model )
{
	PrecacheModel( model );
	level.player_camo_viewmodel = model;
}

// Sets the player's hand model used for "interactive" hands
set_player_interactive_hands( model )
{
	PrecacheModel( model ); 
	level.player_interactive_hands = model;
}

// this one has legs
set_player_interactive_model( model )
{
	PrecacheModel( model ); 
	level.player_interactive_model = model;
}

// Sets the player's laststand pistol
set_laststand_pistol( weapon )
{
	level.laststandpistol = weapon;
}

give_loadout(wait_for_switch_weapon)
{
	if( !IsDefined( game["gaveweapons"] ) )
	{
		game["gaveweapons"] = 0;
	}

	if( !IsDefined( game["expectedlevel"] ) )
	{
		game["expectedlevel"] = "";
	}
	
	if( game["expectedlevel"] != level.script )
	{
		game["gaveweapons"] = 0;		
	}

	if( game["gaveweapons"] == 0 )
	{
		game["gaveweapons"] = 1;
	}

	// MikeD (4/18/2008): In order to be able to throw a grenade back, the player first needs to at
	// least have a grenade in his inventory before doing so. So let's try to find out and give it to him
	// then take it away.
	gave_grenade = false;

	// First check to see if we are giving him a grenade, if so, skip this process.
	for( i = 0; i < level.player_loadout.size; i++ )
	{
		if( WeaponType( level.player_loadout[i] ) == "grenade" )
		{
			gave_grenade = true;
			break;
		}
	}
	
	// If we do not have a grenade then try to automatically assign one
	// If we can't automatically do this, then the scripter needs to do by hand in the level
	if( !gave_grenade )
	{
		if( IsDefined( level.player_grenade ) )
		{
			grenade = level.player_grenade;
			
		}
		else
		{
			grenade = "frag_grenade_sp";
		}
		
		self GiveWeapon( grenade );
		self SetWeaponAmmoClip( grenade, 0 );
		self SetWeaponAmmoStock( grenade, 0 );
		gave_grenade = true;
	}
	
	bMaxAmmo = false;
	if( !array_check_for_dupes( level.player_perks, "specialty_extraammo" ) )
	{
		bMaxAmmo = true;
	}
	                           

	for( i = 0; i < level.player_loadout.size; i++ )
	{
		if( isdefined(level.player_loadout_options[i]) && (level.player_loadout_options[i]!=-1) )
		{	
			weaponOptions = self calcweaponoptions( level.player_loadout_options[i] );
			self GiveWeapon( level.player_loadout[i], 0, weaponOptions );
		}
		else
		{
			self GiveWeapon( level.player_loadout[i] );
		}
		
		if( IsDefined( level.player_loadout_slots[i] ) && level.player_loadout_slots[i] != "" )
		{
			if( level.player_loadout_slots[i] == "primarygrenade" )
			{
				self SwitchToOffhand( level.player_loadout[i] );
				self setOffhandPrimaryClass( level.player_loadout[i] );
			}
			else if( level.player_loadout_slots[i] == "specialgrenade" )
			{
				self SwitchToOffhand( level.player_loadout[i] );
				self setOffhandSecondaryClass( level.player_loadout[i] );
			}
		}
		
		if( bMaxAmmo )
		{
			self GiveMaxAmmo( level.player_loadout[i] );
		}
	}
	
	for( i = 0; i < level.player_perks.size; i++ )
	{
		self SetPerk( level.player_perks[i] );
	}
	
	self SetActionSlot( 1, "" );
	self SetActionSlot( 2, "" );
	self SetActionSlot( 3, "altMode" );	// toggles between attached grenade launcher
	self SetActionSlot( 4, "" );

	if( IsDefined( level.player_actionslots ) )
	{
		for( i = 0; i < level.player_actionslots.size; i++ )
		{
			num = level.player_actionslots[i].num;
			option1 = level.player_actionslots[i].option1;

			if( IsDefined( level.player_actionslots[i].option2 ) )
			{
				option2 = level.player_actionslots[i].option2;
				self SetActionSlot( num, option1, option2 );
			}
			else
			{
				self SetActionSlot( num, option1 );
			}
		}
	}

	if( IsDefined( level.player_switchweapon ) )
	{
		// the wait was added to fix a revive issue with the host
		// for some reson the SwitchToWeapon message gets lost
		// this can be removed if that is ever resolved
		if ( isdefined(wait_for_switch_weapon) && wait_for_switch_weapon == true )
		{
			wait(0.5);
		}
		self SetSpawnWeapon( level.player_switchweapon );
		self SwitchToWeapon( level.player_switchweapon );
	}
	
	wait(0.5);
	
	self player_flag_set("loadout_given");
}

give_model()
{
	// BJoyal (6/1/09) Used to determine if it is player 1, 2, 3, or 4, to give the appropriate model.
	entity_num = self GetEntityNumber();
	
	// test maps here
	if (level.campaign == "none")
	{
		// GLOCKE: 7/7/10 - removed the 3rd person model from SP, shouldn't need to build any of these characters
	}
		
	// MikeD (3/28/2008): If specified, give the player his hands
	if( IsDefined( level.player_viewmodel ) )
	{
		self SetViewModel( level.player_viewmodel );
	}
}
