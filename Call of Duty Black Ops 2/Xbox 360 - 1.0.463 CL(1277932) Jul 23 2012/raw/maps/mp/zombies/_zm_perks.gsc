#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

#insert raw\maps\mp\zombies\_zm_utility.gsh;

init()
{
	place_additionalprimaryweapon_machine();

	//sets up spawned perk machines.
	perk_machine_spawn_init();	

	vending_weapon_upgrade_trigger = [];

	// Perks-a-cola vending machine use triggers
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	for( i = 0; i < vending_triggers.size; i++ )
	{
		if(IsDefined(vending_triggers[i].script_noteworthy) && vending_triggers[i].script_noteworthy ==  "specialty_weapupgrade")
		{
			vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = vending_triggers[i];
			ArrayRemoveValue(vending_triggers,vending_triggers[i]);
		}	
	}
	
	// Add old style pack machines if necessary.
	old_packs = GetEntArray( "zombie_vending_upgrade", "targetname" );
	for( i = 0; i < old_packs.size; i++ )
	{
		vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = old_packs[i];
	}
	flag_init("pack_machine_in_use");
	//flag_init( "solo_game" );

	if( level.mutators["mutator_noPerks"] )
	{
		for( i = 0; i < vending_triggers.size; i++ )
		{
			vending_triggers[i] disable_trigger();
		}
		for( i = 0; i < vending_weapon_upgrade_trigger.size; i++ )
		{
			vending_weapon_upgrade_trigger[i] disable_trigger();
		}
		return;
	}
	
	if ( vending_triggers.size < 1 )
	{
		return;
	}
	
	if ( vending_weapon_upgrade_trigger.size >= 1 )
	{
		array_thread( vending_weapon_upgrade_trigger, ::vending_weapon_upgrade );;
	}
	
	//Perks machine
	if( !isDefined( level.custom_vending_precaching ) )
	{
		level.custom_vending_precaching = ::default_vending_precaching;
	}
	[[ level.custom_vending_precaching ]]();

	if( !isDefined( level.packapunch_timeout ) )
	{
		level.packapunch_timeout = 15;
	}

	set_zombie_var( "zombie_perk_cost",					2000 );
	if( level.mutators["mutator_susceptible"] )
	{
		set_zombie_var( "zombie_perk_juggernaut_health",	80 );
		set_zombie_var( "zombie_perk_juggernaut_health_upgrade",	95 );
	}
	else
	{
		set_zombie_var( "zombie_perk_juggernaut_health",	160 );
		set_zombie_var( "zombie_perk_juggernaut_health_upgrade",	190 );
	}

	array_thread( vending_triggers, ::vending_trigger_think );
	array_thread( vending_triggers, ::electric_perks_dialog );

	level thread turn_doubletap_on();
	if ( is_true( level.zombiemode_using_marathon_perk ) )
	{
		level thread turn_marathon_on();
	}
	if ( is_true( level.zombiemode_using_divetonuke_perk ) )
	{
		level thread turn_divetonuke_on();

		// set the behavior function
		level.zombiemode_divetonuke_perk_func = ::divetonuke_explode;

		// precache the effect
		level._effect["divetonuke_groundhit"] = loadfx("maps/zombie/fx_zmb_phdflopper_exp");

		// tweakable variables
		set_zombie_var( "zombie_perk_divetonuke_radius", 300 ); // WW (01/12/2011): Issue 74726:DLC 2 - Zombies - Cosmodrome - PHD Flopper - Increase the radius on the explosion (Old: 150)
		set_zombie_var( "zombie_perk_divetonuke_min_damage", 1000 );
		set_zombie_var( "zombie_perk_divetonuke_max_damage", 5000 );
	}
	level thread turn_jugger_on();
	level thread turn_revive_on();
	level thread turn_sleight_on();
	
	// WW (02-02-11): Deadshot perk
	if( is_true( level.zombiemode_using_deadshot_perk ) )
	{
		level thread turn_deadshot_on();
	}
	
	if ( is_true( level.zombiemode_using_tombstone_perk ) )
	{
		level thread turn_tombstone_on();
	}

	if ( is_true( level.zombiemode_using_additionalprimaryweapon_perk ) )
	{
		level thread turn_additionalprimaryweapon_on();
	}

	level thread turn_PackAPunch_on();

	if ( isdefined( level.quantum_bomb_register_result_func ) )
	{
		[[level.quantum_bomb_register_result_func]]( "give_nearest_perk", ::quantum_bomb_give_nearest_perk_result, 10, ::quantum_bomb_give_nearest_perk_validation );
	}
}


place_additionalprimaryweapon_machine()
{
	if ( !isdefined( level.zombie_additionalprimaryweapon_machine_origin ) )
	{
		return;
	}

	machine = Spawn( "script_model", level.zombie_additionalprimaryweapon_machine_origin );
	machine.angles = level.zombie_additionalprimaryweapon_machine_angles;
	machine SetModel( "zombie_vending_three_gun" );
	machine.targetname = "vending_additionalprimaryweapon";

	machine_trigger = Spawn( "trigger_radius_use", level.zombie_additionalprimaryweapon_machine_origin + (0, 0, 30), 0, 20, 70 );
	machine_trigger.targetname = "zombie_vending";
	machine_trigger.target = "vending_additionalprimaryweapon";
	machine_trigger.script_noteworthy = "specialty_additionalprimaryweapon";

	if ( isdefined( level.zombie_additionalprimaryweapon_machine_clip_origin ) )
	{
		machine_clip = spawn( "script_model", level.zombie_additionalprimaryweapon_machine_clip_origin );
		machine_clip.angles = level.zombie_additionalprimaryweapon_machine_clip_angles;
		machine_clip SetModel( "collision_geo_64x64x256" );
		machine_clip Hide();
	}

	if ( isdefined( level.zombie_additionalprimaryweapon_machine_monkey_origins ) )
	{
		machine.target = "vending_additionalprimaryweapon_monkey_structs";
		for ( i = 0; i < level.zombie_additionalprimaryweapon_machine_monkey_origins.size; i++ )
		{
			machine_monkey_struct = SpawnStruct();
			machine_monkey_struct.origin = level.zombie_additionalprimaryweapon_machine_monkey_origins[i];
			machine_monkey_struct.angles = level.zombie_additionalprimaryweapon_machine_monkey_angles;
			machine_monkey_struct.script_int = i + 1;
			machine_monkey_struct.script_notetworthy = "cosmo_monkey_additionalprimaryweapon";
			machine_monkey_struct.targetname = "vending_additionalprimaryweapon_monkey_structs";

			if ( !IsDefined( level.struct_class_names["targetname"][machine_monkey_struct.targetname] ) )
			{
				level.struct_class_names["targetname"][machine_monkey_struct.targetname] = [];
			}
			
			size = level.struct_class_names["targetname"][machine_monkey_struct.targetname].size;
			level.struct_class_names["targetname"][machine_monkey_struct.targetname][size] = machine_monkey_struct;
		}
	}

	level.zombiemode_using_additionalprimaryweapon_perk = true;
}


//
//	Precaches all machines
//
//	"weapon" - 1st person Bottle when drinking
//	icon - Texture for when perk is active
//	model - Perk Machine on/off versions
//	fx - machine on
//	sound
default_vending_precaching()
{
	//PACK-A-PUNCH
	if ( is_true( level.zombiemode_using_pack_a_punch ) )
	{
		PrecacheItem( "zombie_knuckle_crack" );
		PrecacheModel("zombie_vending_packapunch");
		PrecacheModel("zombie_vending_packapunch_on");
		PrecacheString( &"ZOMBIE_PERK_PACKAPUNCH" );
		level._effect["packapunch_fx"] = loadfx("maps/zombie/fx_zombie_packapunch");
	}
	
	//PERKS
	if ( is_true( level.zombiemode_using_additionalprimaryweapon_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_additionalprimaryweapon" );
		PrecacheShader( "specialty_extraprimaryweapon_zombies" );
		PrecacheModel("zombie_vending_three_gun");
		PrecacheModel("zombie_vending_three_gun_on");
		PrecacheString( &"ZOMBIE_PERK_ADDITIONALWEAPONPERK" );
		level._effect["additionalprimaryweapon_light"] = loadfx("misc/fx_zombie_cola_arsenal_on");
	}
	if( is_true( level.zombiemode_using_deadshot_perk ) )
	{
		PreCacheItem( "zombie_perk_bottle_deadshot" );	
		PrecacheShader( "specialty_ads_zombies" );
		PrecacheModel("zombie_vending_ads");
		PrecacheModel("zombie_vending_ads_on");
		PrecacheString( &"ZOMBIE_PERK_DEADSHOT" );
		level._effect["deadshot_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
	}
	if ( is_true( level.zombiemode_using_divetonuke_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_nuke" );
		PrecacheShader( "specialty_divetonuke_zombies" );
		PrecacheModel("zombie_vending_nuke");
		PrecacheModel("zombie_vending_nuke_on");
		PrecacheString( &"ZOMBIE_PERK_DIVETONUKE" );
		level._effect["divetonuke_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
	}
	if ( is_true( level.zombiemode_using_doubletap_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_doubletap" );
		PrecacheShader( "specialty_doubletap_zombies" );
		PrecacheModel("zombie_vending_doubletap");
		PrecacheModel("zombie_vending_doubletap_on");
		PrecacheString( &"ZOMBIE_PERK_DOUBLETAP" );
		level._effect["doubletap_light"] = loadfx("misc/fx_zombie_cola_dtap_on");
	}
	if ( is_true( level.zombiemode_using_juggernaut_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_jugg" );
		PrecacheShader( "specialty_juggernaut_zombies" );
		PreCacheModel("zombie_vending_jugg");
		PreCacheModel("zombie_vending_jugg_on");
		PrecacheString( &"ZOMBIE_PERK_JUGGERNAUT" );
		level._effect["jugger_light"] = loadfx("misc/fx_zombie_cola_jugg_on");
	}
	if ( is_true( level.zombiemode_using_marathon_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_marathon" );
		PrecacheShader( "specialty_marathon_zombies" );
		PrecacheModel("zombie_vending_marathon");
		PrecacheModel("zombie_vending_marathon_on");
		PrecacheString( &"ZOMBIE_PERK_MARATHON" );
		level._effect["marathon_light"] = loadfx("maps/zombie/fx_zmb_cola_staminup_on");
	}
	if ( is_true( level.zombiemode_using_revive_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_revive" );
		PrecacheShader( "specialty_quickrevive_zombies" );
		PrecacheModel("zombie_vending_revive");
		PrecacheModel("zombie_vending_revive_on");
		PrecacheString( &"ZOMBIE_PERK_QUICKREVIVE" );
		level._effect["revive_light"] = loadfx("misc/fx_zombie_cola_revive_on");
		level._effect["revive_light_flicker"] = loadfx("maps/zombie/fx_zmb_cola_revive_flicker");
	}
	if ( is_true( level.zombiemode_using_sleightofhand_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_sleight" );
		PrecacheShader( "specialty_fastreload_zombies" );
		PrecacheModel("zombie_vending_sleight");
		PrecacheModel("zombie_vending_sleight_on");
		PrecacheString( &"ZOMBIE_PERK_FASTRELOAD" );
		level._effect["sleight_light"]			= loadfx("misc/fx_zombie_cola_on");
	}
	if ( is_true( level.zombiemode_using_tombstone_perk ) )
	{
		PrecacheItem( "zombie_perk_bottle_tombstone" );
		PrecacheShader( "specialty_tombstone_zombies" );
		PrecacheModel( "zombie_vending_tombstone" );
		PrecacheModel( "zombie_vending_tombstone_on" );
		PrecacheModel( "ch_tombstone1" );
		PrecacheString( &"ZOMBIE_PERK_TOMBSTONE" );
		level._effect["tombstone_light"]			= loadfx("misc/fx_zombie_cola_on");
	}
}

third_person_weapon_upgrade( current_weapon, origin, angles, packa_rollers, perk_machine, trigger )
{
	level endon("Pack_A_Punch_off");

	forward = anglesToForward( angles );
	interact_pos = origin + (forward*-25);
	PlayFx( level._effect["packapunch_fx"], origin+(0,1,-34), forward );
	
	trigger.worldgun = spawn( "script_model", interact_pos );
	trigger.worldgun.angles  = self.angles;
	trigger.worldgun SetModel( GetWeaponModel( current_weapon ) );
	trigger.worldgun useweaponhidetags( current_weapon );
	trigger.worldgun rotateto( angles+(0,90,0), 0.35, 0, 0 );

	offsetdw = ( 3, 3, 3 );
	worldgundw = undefined;
	if ( maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield( current_weapon ) )
	{
		worldgundw = spawn( "script_model", interact_pos + offsetdw );
		worldgundw.angles  = self.angles;

		worldgundw SetModel( maps\mp\zombies\_zm_magicbox::get_left_hand_weapon_model_name( current_weapon ) );
		worldgundw useweaponhidetags( current_weapon );
		worldgundw rotateto( angles+(0,90,0), 0.35, 0, 0 );
	}
	trigger.worldgun.worldgundw = worldgundw;

	wait( 0.5 );

	trigger.worldgun moveto( origin, 0.5, 0, 0 );
	if ( isdefined( worldgundw ) )
	{
		worldgundw moveto( origin + offsetdw, 0.5, 0, 0 );
	}

	self playsound( "zmb_perks_packa_upgrade" );
	if( isDefined( perk_machine.wait_flag ) )
	{
		perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles+(179, 0, 0), 0.25, 0, 0 );
	}
	wait( 0.35 );

	trigger.worldgun delete();
	if ( isdefined( worldgundw ) )
	{
		worldgundw delete();
	}

	wait( 3 );

	if ( IsDefined( self ) )
	{
		self playsound( "zmb_perks_packa_ready" );
	}

	trigger.worldgun = spawn( "script_model", origin );
	trigger.worldgun.angles  = angles+(0,90,0);
	trigger.worldgun SetModel( GetWeaponModel( level.zombie_weapons[current_weapon].upgrade_name ) );
	trigger.worldgun useweaponhidetags( level.zombie_weapons[current_weapon].upgrade_name );
	trigger.worldgun moveto( interact_pos, 0.5, 0, 0 );

	worldgundw = undefined;
	if ( maps\mp\zombies\_zm_magicbox::weapon_is_dual_wield( level.zombie_weapons[current_weapon].upgrade_name ) )
	{
		worldgundw = spawn( "script_model", origin + offsetdw );
		worldgundw.angles  = angles+(0,90,0);

		worldgundw SetModel( maps\mp\zombies\_zm_magicbox::get_left_hand_weapon_model_name( level.zombie_weapons[current_weapon].upgrade_name ) );
		worldgundw useweaponhidetags( level.zombie_weapons[current_weapon].upgrade_name );
		worldgundw moveto( interact_pos + offsetdw, 0.5, 0, 0 );
	}
	trigger.worldgun.worldgundw = worldgundw;

	if( isDefined( perk_machine.wait_flag ) )
	{
		perk_machine.wait_flag rotateto( perk_machine.wait_flag.angles-(179, 0, 0), 0.25, 0, 0 );
	}

	wait( 0.5 );

	trigger.worldgun moveto( origin, level.packapunch_timeout, 0, 0);
	if ( isdefined( worldgundw ) )
	{
		worldgundw moveto( origin + offsetdw, level.packapunch_timeout, 0, 0);
	}

	return trigger.worldgun;
}


vending_machine_trigger_think()
{
	self endon("death");
	
	while(1)
	{
		players = GET_PLAYERS();
		
		for(i = 0; i < players.size; i ++)
		{
			if ( players[i] hacker_active() )
			{
				self SetInvisibleToPlayer( players[i], true );
			}
			else
			{
				self SetInvisibleToPlayer( players[i], false );
			}		
		}
		wait(0.1);
	}
}

//
//	Pack-A-Punch Weapon Upgrade
//
vending_weapon_upgrade()
{
	level endon("Pack_A_Punch_off");

	perk_machine = GetEnt( self.target, "targetname" );
	perk_machine_sound = GetEntarray ( "perksacola", "targetname");
	packa_rollers = spawn("script_origin", self.origin);
	packa_timer = spawn("script_origin", self.origin);
	packa_rollers LinkTo( self );
	packa_timer LinkTo( self );
	
	if( isDefined( perk_machine.target ) )
	{
		perk_machine.wait_flag = GetEnt( perk_machine.target, "targetname" );
	}

	pap_is_buildable = self is_buildable();		
	if ( pap_is_buildable )
	{
		self trigger_off();
		perk_machine Hide();
		
		if ( IsDefined( perk_machine.wait_flag ) )
		{
			perk_machine.wait_flag Hide();
		}
		
		build_trig = GetEnt( "pap_buildable_trigger", "targetname" );
		
		playerWhoBuilt = build_trig maps\mp\zombies\_zm_buildables::buildable_think( "pap" ); // Waits for it to be built
		
		self trigger_on();
		perk_machine Show();
		
		if ( IsDefined( perk_machine.wait_flag ) )
		{
			perk_machine.wait_flag Show();
		}
		
		build_trig Delete();
	}

	self UseTriggerRequireLookAt();
	self SetHintString( &"ZOMBIE_NEED_POWER" );
	self SetCursorHint( "HINT_NOICON" );
	
	if ( !flag( "power_on" ) || is_true(self.emp_disabled) )
	{
		level waittill("Pack_A_Punch_on");
	}
	
	self thread vending_machine_trigger_think();
	
	self thread maps\mp\zombies\_zm_magicbox::decide_hide_show_hint("Pack_A_Punch_off");
	
	self thread destroy_weapon_in_blackout();

	perk_machine playloopsound("zmb_perks_packa_loop");
	self thread shutOffPAPSounds( perk_machine, packa_rollers, packa_timer );

	self thread vending_weapon_upgrade_cost();
	
	for( ;; )
	{
		self waittill( "trigger", player );		
				
		index = maps\mp\zombies\_zm_weapons::get_player_index(player);	
		plr = "zmb_vox_plr_" + index + "_";
		current_weapon = player getCurrentWeapon();
		
		if ( "microwavegun_zm" == current_weapon )
		{
			current_weapon = "microwavegundw_zm";
		}

		if( !player maps\mp\zombies\_zm_magicbox::can_buy_weapon() ||
			player maps\mp\zombies\_zm_laststand::player_is_in_laststand() ||
			is_true( player.intermission ) ||
			player isThrowingGrenade() ||
			player maps\mp\zombies\_zm_weapons::is_weapon_upgraded( current_weapon ) )
		{
			wait( 0.1 );
			continue;
		}
		
		if( is_true(level.pap_moving)) //can't use the pap machine while it's being lowered or raised
		{
			continue;
		}
		
 		if( player isSwitchingWeapons() )
 		{
 			wait(0.1);
 			continue;
 		}

		if ( !IsDefined( level.zombie_include_weapons[current_weapon] ) )
		{
			continue;
		}

		if ( player.score < self.cost )
		{
			//player iprintln( "Not enough points to buy Perk: " + perk );
			self playsound("deny");
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
			continue;
		}
		
		flag_set("pack_machine_in_use");
		
		player maps\mp\zombies\_zm_score::minus_to_player_score( self.cost ); 
		sound = "evt_bottle_dispense";
		playsoundatposition(sound, self.origin);
		
		//TUEY TODO: Move this to a general init string for perk audio later on
		self thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger("mus_perks_packa_sting");
		player maps\mp\zombies\_zm_audio::create_and_play_dialog( "weapon_pickup", "upgrade_wait" );
		
		origin = self.origin;
		angles = self.angles;
		
		if( isDefined(perk_machine))
		{
			origin = perk_machine.origin+(0,0,35);
			angles = perk_machine.angles+(0,90,0);
		}
		
		self disable_trigger();
		
		player thread do_knuckle_crack();

		// Remember what weapon we have.  This is needed to check unique weapon counts.
		self.current_weapon = current_weapon;
											
		weaponmodel = player third_person_weapon_upgrade( current_weapon, origin, angles, packa_rollers, perk_machine, self );
		
		self enable_trigger();
		self SetHintString( &"ZOMBIE_GET_UPGRADED" );
		if ( IsDefined( player ) )
		{
			self setvisibletoplayer( player );
		
			self thread wait_for_player_to_take( player, current_weapon, packa_timer );
		}
		self thread wait_for_timeout( current_weapon, packa_timer );
		
		self waittill_either( "pap_timeout", "pap_taken" );
		
		self.current_weapon = "";
		if ( isdefined( weaponmodel.worldgundw ) )
		{
			weaponmodel.worldgundw delete();
		}
		weaponmodel delete();
		self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH", self.cost );
		self setvisibletoall();
		flag_clear("pack_machine_in_use");

	}
}

shutOffPAPSounds( ent1, ent2, ent3 )
{
	while(1)
	{
		level waittill( "Pack_A_Punch_off" );
		level thread turnOnPAPSounds( ent1 );
		ent1 stoploopsound( .1 );
		ent2 stoploopsound( .1 );
		ent3 stoploopsound( .1 );
	}
}

turnOnPAPSounds( ent )
{
	level waittill( "Pack_A_Punch_on" );
	ent playloopsound( "zmb_perks_packa_loop" );
}

vending_weapon_upgrade_cost()
{
	level endon("Pack_A_Punch_off");
	while ( 1 )
	{
		self.cost = 5000;
		self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH", self.cost );

		level waittill( "powerup bonfire sale" );

		self.cost = 1000;
		self SetHintString( &"ZOMBIE_PERK_PACKAPUNCH", self.cost );

		level waittill( "bonfire_sale_off" );
	}
}


//	
//
wait_for_player_to_take( player, weapon, packa_timer )
{
	Assert( IsDefined( level.zombie_weapons[weapon] ), "wait_for_player_to_take: weapon does not exist" );
	Assert( IsDefined( level.zombie_weapons[weapon].upgrade_name ), "wait_for_player_to_take: upgrade_weapon does not exist" );
	
	upgrade_weapon = level.zombie_weapons[weapon].upgrade_name;
	
	self endon( "pap_timeout" );
	level endon( "Pack_A_Punch_off" );
	while( true )
	{
		packa_timer playloopsound( "zmb_perks_packa_ticktock" );
		self waittill( "trigger", trigger_player );
		packa_timer stoploopsound(.05);
		if( trigger_player == player ) 
		{
			current_weapon = player GetCurrentWeapon();
/#
if ( "none" == current_weapon )
{
	iprintlnbold( "WEAPON IS NONE, PACKAPUNCH RETRIEVAL DENIED" );
}
#/
			if( is_player_valid( player ) && !IS_DRINKING(player.is_drinking) && !is_placeable_mine( current_weapon )  && !is_equipment( current_weapon ) && level.revive_tool != current_weapon && "none" != current_weapon  && !player hacker_active())
			{
				self notify( "pap_taken" );
				player notify( "pap_taken" );
				player.pap_used = true;

				weapon_limit = 2;
				if ( player HasPerk( "specialty_additionalprimaryweapon" ) )
				{
					weapon_limit = 3;
				}

				player maps\mp\zombies\_zm_weapons::take_fallback_weapon();

				primaries = player GetWeaponsListPrimaries();
				if( isDefined( primaries ) && primaries.size >= weapon_limit )
				{
					player maps\mp\zombies\_zm_weapons::weapon_give( upgrade_weapon );
				}
				else
				{
					player GiveWeapon( upgrade_weapon, 0, player maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon ) );
					player GiveStartAmmo( upgrade_weapon );
				}
				
				player SwitchToWeapon( upgrade_weapon );
				player maps\mp\zombies\_zm_weapons::play_weapon_vo(upgrade_weapon);
				return;
			}
		}
		wait( 0.05 );
	}
}


//	Waiting for the weapon to be taken
//
wait_for_timeout( weapon, packa_timer )
{
	self endon( "pap_taken" );
	
	wait( level.packapunch_timeout );
	
	self notify( "pap_timeout" );
	packa_timer stoploopsound(.05);
	packa_timer playsound( "zmb_perks_packa_deny" );

	maps\mp\zombies\_zm_weapons::unacquire_weapon_toggle( weapon );
}


destroy_weapon_in_blackout()
{		
	self endon( "pap_timeout" );
	self endon( "pap_taken" );

	level waittill("Pack_A_Punch_off");

	if ( isdefined( self.worldgun ) )
	{
		self.worldgun rotateto( self.worldgun.angles+(randomint(90)-45,0,randomint(360)-180), 1.5, 0, 0 );

		wait( 1.5 );

		if ( isdefined( self.worldgun.worldgundw ) )
		{
			self.worldgun.worldgundw delete();
		}
		self.worldgun delete();
	}

}



//	Weapon has been inserted, crack knuckles while waiting
//
do_knuckle_crack()
{
	gun = self upgrade_knuckle_crack_begin();
	
	self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	self upgrade_knuckle_crack_end( gun );
	
}


//	Switch to the knuckles
//
upgrade_knuckle_crack_begin()
{
	self increment_is_drinking();
	
	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowCrouch( true );
	self AllowProne( false );
	self AllowMelee( false );
	
	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	primaries = self GetWeaponsListPrimaries();

	gun = self GetCurrentWeapon();
	weapon = "zombie_knuckle_crack";
	
	if ( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
	{
		self notify( "zmb_lost_knife" );
		self TakeWeapon( gun );
	}
	else
	{
		return;
	}

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}

//	Anim has ended, now switch back to something
//
upgrade_knuckle_crack_end( gun )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != "zombie_perk_bottle_marathon" );
	assert( gun != "zombie_perk_bottle_nuke" );
	assert( gun != "zombie_perk_bottle_deadshot" );
	assert( gun != "zombie_perk_bottle_additionalprimaryweapon" );
	assert( gun != "zombie_perk_bottle_tombstone" );
	assert( gun != level.revive_tool );

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = "zombie_knuckle_crack";

	// TODO: race condition?
	if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( self.intermission ) )
	{
		self TakeWeapon(weapon);
		return;
	}

	self decrement_is_drinking();

	self TakeWeapon(weapon);
	primaries = self GetWeaponsListPrimaries();
	if( IS_DRINKING(self.is_drinking) )
	{
		return;
	}
	else if( isDefined( primaries ) && primaries.size > 0 )
	{
		self SwitchToWeapon( primaries[0] );
	}
	else if ( self HasWeapon( level.laststandpistol ) )
	{
		self SwitchToWeapon( level.laststandpistol );
	}
	else
	{
		self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
	}
}

// PI_CHANGE_BEGIN
//	NOTE:  In the .map, you'll have to make sure that each Pack-A-Punch machine has a unique targetname
turn_PackAPunch_on()
{
	vending_weapon_upgrade_trigger = GetEntArray( "specialty_weapupgrade", "script_noteworthy" );
	for(i=0; i<vending_weapon_upgrade_trigger.size; i++ )
	{
		perk = getent(vending_weapon_upgrade_trigger[i].target, "targetname");
		if(isDefined(perk))
		{
			perk SetModel("zombie_vending_packapunch");
		}
	}

	for (;;)
	{
		level waittill("Pack_A_Punch_on");

		for(i=0; i<vending_weapon_upgrade_trigger.size; i++ )
		{
			perk = getent(vending_weapon_upgrade_trigger[i].target, "targetname");
			if(isDefined(perk))
			{
				perk thread activate_PackAPunch();
			}
		}

		level waittill("Pack_A_Punch_off");
			
		for(i=0; i<vending_weapon_upgrade_trigger.size; i++ )
		{
			perk = getent(vending_weapon_upgrade_trigger[i].target, "targetname");
			if(isDefined(perk))
			{
				perk thread deactivate_PackAPunch();
			}
		}
	}
}

activate_PackAPunch()
{
	self SetModel("zombie_vending_packapunch_on");
	self playsound("zmb_perks_power_on");
	self vibrate((0,-100,0), 0.3, 0.4, 3);
	/*
	self.flag = spawn( "script_model", machine GetTagOrigin( "tag_flag" ) );
	self.angles = machine GetTagAngles( "tag_flag" );
	self.flag setModel( "zombie_sign_please_wait" );
	self.flag linkto( machine );
	self.flag.origin = (0, 40, 40);
	self.flag.angles = (0, 0, 0);
	*/
	timer = 0;
	duration = 0.05;
	//level notify( "Carpenter_On" );
}

deactivate_PackAPunch()
{
	self SetModel("zombie_vending_packapunch");
	//self playsound("zmb_perks_power_on");
	//self vibrate((0,-100,0), 0.3, 0.4, 3);
}
// PI_CHANGE_END



//############################################################################
//		P E R K   M A C H I N E S
//############################################################################

//
//	Threads to turn the machines to their ON state.
//


// Speed Cola / Sleight of Hand
//
turn_sleight_on()
{
	while ( true )
	{
		machine = getentarray("vending_sleight", "targetname");
		machine_triggers = GetEntArray( "vending_sleight", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_sleight");
			
		array_thread( machine_triggers, ::set_power_on, false );
		
		level waittill("sleight_on");
	
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_sleight_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "sleight_light" );
			machine[i] thread play_loop_on_machine();
		}
		
		array_thread( machine_triggers, ::set_power_on, true );
	
		level notify( "specialty_fastreload_power_on" );
		
		level waittill("sleight_off");
		
		array_thread( machine, ::turn_perk_off );
	}
}

// Quick Revive
//
turn_revive_on()
{
	machine = getentarray("vending_revive", "targetname");
	machine_model = undefined;
	machine_clip = undefined;
	
	flag_wait( "start_zombie_round_logic" );
	players = GET_PLAYERS();
	if ( players.size == 1 )
	{
		for( i = 0; i < machine.size; i++ )
		{
			if(IsDefined(machine[i].script_noteworthy) && machine[i].script_noteworthy == "clip")
			{
				machine_clip = machine[i];
			}
			else // then the model
			{	
				machine[i] SetModel("zombie_vending_revive_on");
				machine[i] thread play_loop_on_machine();
				machine_model = machine[i];
			}
		}
		wait_network_frame();
		if ( isdefined( machine_model ) && IsDefined(machine_clip))
		{
			machine_model thread revive_solo_fx(machine_clip);
		}
	}
	else
	{
		while ( true )
		{
			machine = getentarray("vending_revive", "targetname");
			machine_triggers = GetEntArray( "vending_revive", "target" );
			
			for( i = 0; i < machine.size; i++ )
				machine[i] SetModel("zombie_vending_revive");
				
			array_thread( machine_triggers, ::set_power_on, false );
				
			level waittill("revive_on");
	
			for( i = 0; i < machine.size; i++ )
			{
				if(IsDefined(machine[i].classname) && machine[i].classname == "script_model")
				{
					machine[i] SetModel("zombie_vending_revive_on");
					machine[i] playsound("zmb_perks_power_on");
					machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
					machine[i] thread perk_fx( "revive_light" );
					machine[i] thread play_loop_on_machine();
				}
			}
			
			array_thread( machine_triggers, ::set_power_on, true );
			
			level notify( "specialty_quickrevive_power_on" );
			
			level waittill("revive_off");
				
			for( i = 0; i < machine.size; i++ )
			{
				if(IsDefined(machine[i].classname) && machine[i].classname == "script_model")
				{
					machine[i] turn_perk_off();
				}
			}
		}
	}
}


revive_solo_fx(machine_clip)
{
	flag_init( "solo_revive" );

	self.fx = Spawn( "script_model", self.origin );
	self.fx.angles = self.angles;
	self.fx SetModel( "tag_origin" );
	self.fx LinkTo(self);

	playfxontag( level._effect[ "revive_light" ], self.fx, "tag_origin" );
	playfxontag( level._effect[ "revive_light_flicker" ], self.fx, "tag_origin" );

	flag_wait( "solo_revive" );

	if ( isdefined( level.revive_solo_fx_func ) )
	{
		level thread [[ level.revive_solo_fx_func ]]();
	}
	
	//DCS: make revive model fly away like a magic box.
	//self playsound("zmb_laugh_child");

	wait(2.0);

	self playsound("zmb_box_move");

	playsoundatposition ("zmb_whoosh", self.origin );
	//playsoundatposition ("zmb_vox_ann_magicbox", self.origin );

	self moveto(self.origin + (0,0,40),3);

	if( isDefined( level.custom_vibrate_func ) )
	{
		[[ level.custom_vibrate_func ]]( self );
	}
	else
	{
	   direction = self.origin;
	   direction = (direction[1], direction[0], 0);
	   
	   if(direction[1] < 0 || (direction[0] > 0 && direction[1] > 0))
	   {
            direction = (direction[0], direction[1] * -1, 0);
       }
       else if(direction[0] < 0)
       {
            direction = (direction[0] * -1, direction[1], 0);
       }
	   
        self Vibrate( direction, 10, 0.5, 5);
	}
	
	self waittill("movedone");
	PlayFX(level._effect["poltergeist"], self.origin);
	playsoundatposition ("zmb_box_poof", self.origin);

    level clientNotify( "drb" );

	//self SetModel("zombie_vending_revive");
	self.fx Unlink();
	self.fx delete();	
	self Delete();

	// DCS: remove the clip.
	machine_clip trigger_off();
	machine_clip ConnectPaths();	
	machine_clip Delete();
}

// Jugger-nog / Juggernaut
//
turn_jugger_on()
{
	while ( true )
	{
		machine = getentarray("vending_jugg", "targetname");
		machine_triggers = GetEntArray( "vending_jugg", "target" );
		
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_jugg");
			
		array_thread( machine_triggers, ::set_power_on, false );
	
		level waittill("juggernog_on");
	
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_jugg_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "jugger_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_armorvest_power_on" );
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("juggernog_off");
			
		array_thread( machine, ::turn_perk_off );
	}
}

// Double-Tap
//
turn_doubletap_on()
{
	while ( true )
	{
		machine = getentarray("vending_doubletap", "targetname");
		machine_triggers = GetEntArray( "vending_doubletap", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_doubletap");
		array_thread( machine_triggers, ::set_power_on, false );
		level waittill("doubletap_on");
		
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_doubletap_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "doubletap_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_rof_power_on" );
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("doubletap_off");
		
		array_thread( machine, ::turn_perk_off );
	}
}

// Marathon
//
turn_marathon_on()
{
	while ( true )
	{
		machine = getentarray("vending_marathon", "targetname");
		machine_triggers = GetEntArray( "vending_marathon", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_marathon");
		array_thread( machine_triggers, ::set_power_on, false );
		level waittill("marathon_on");
		
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_marathon_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "marathon_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_longersprint_power_on" );
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("marathon_off");
			
		array_thread( machine, ::turn_perk_off );
	}
}

// Divetonuke
//
turn_divetonuke_on()
{
	while ( true )
	{
		machine = getentarray("vending_divetonuke", "targetname");
		machine_triggers = GetEntArray( "vending_divetonuke", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_nuke");
		array_thread( machine_triggers, ::set_power_on, false );
		level waittill("divetonuke_on");
		
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_nuke_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "divetonuke_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_flakjacket_power_on" );
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("divetonuke_off");
			
		array_thread( machine, ::turn_perk_off );
	}
}

divetonuke_explode( attacker, origin )
{
	// tweakable vars
	radius = level.zombie_vars["zombie_perk_divetonuke_radius"];
	min_damage = level.zombie_vars["zombie_perk_divetonuke_min_damage"];
	max_damage = level.zombie_vars["zombie_perk_divetonuke_max_damage"];

	// radius damage
	RadiusDamage( origin, radius, max_damage, min_damage, attacker, "MOD_GRENADE_SPLASH" );

	// play fx
	PlayFx( level._effect["divetonuke_groundhit"], origin );

	// play sound
	attacker playsound("zmb_phdflop_explo");
	
	// WW (01/12/11): start clientsided effects - These client flags are defined in _zombiemode.gsc & _zombiemode.csc
	// Used for zombie_dive2nuke_visionset() in _zombiemode.csc
	attacker SetClientFlag( level._ZOMBIE_PLAYER_FLAG_DIVE2NUKE_VISION );
	wait_network_frame();
	wait_network_frame();
	attacker ClearClientFlag( level._ZOMBIE_PLAYER_FLAG_DIVE2NUKE_VISION );
}

// WW (02-02-11): Deadshot
turn_deadshot_on()
{
	while ( true )
	{
		machine = getentarray("vending_deadshot", "targetname");
		machine_triggers = GetEntArray( "vending_deadshot", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_ads");
			array_thread( machine_triggers, ::set_power_on, false );
		level waittill("deadshot_on");
		
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_ads_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "deadshot_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_deadshot_power_on" );
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("deadshot_off");
			
		array_thread( machine, ::turn_perk_off );
	}
}

turn_tombstone_on()
{
	while ( true )
	{
		machine = getentarray("vending_tombstone", "targetname");
		machine_triggers = GetEntArray( "vending_tombstone", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_tombstone");
		array_thread( machine_triggers, ::set_power_on, false );
		level waittill("tombstone_on");
		
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_tombstone_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "tombstone_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_scavenger_power_on" ); //t6.5todo: Temp Replacement For "tombstone"
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("tombstone_off");
			
		array_thread( machine, ::turn_perk_off );
	}
}

// additionalprimaryweapon
//
turn_additionalprimaryweapon_on()
{
	while ( true )
	{
		machine = getentarray("vending_additionalprimaryweapon", "targetname");
		machine_triggers = GetEntArray( "vending_additionalprimaryweapon", "target" );
		for( i = 0; i < machine.size; i++ )
			machine[i] SetModel("zombie_vending_three_gun");
		array_thread( machine_triggers, ::set_power_on, false );
	//	level waittill("additionalprimaryweapon_on");
		if ( "zombie_cod5_prototype" != level.script && "zombie_cod5_sumpf" != level.script )
		{
			flag_wait( "power_on" );
		}
		//wait ( 3 );
		
		for( i = 0; i < machine.size; i++ )
		{
			machine[i] SetModel("zombie_vending_three_gun_on");
			machine[i] vibrate((0,-100,0), 0.3, 0.4, 3);
			machine[i] playsound("zmb_perks_power_on");
			machine[i] thread perk_fx( "additionalprimaryweapon_light" );
			machine[i] thread play_loop_on_machine();
		}
		level notify( "specialty_additionalprimaryweapon_power_on" );
		
		array_thread( machine_triggers, ::set_power_on, true );
		
		level waittill("additionalprimaryweapon_off");
			
		array_thread( machine, ::turn_perk_off );
	}
}

//
//
set_power_on( state )
{
	self.power_on = state;
}

//
//
turn_perk_off()
{	
	self notify( "stop_loopsound" );
	
	newMachine = Spawn( "script_model", self.origin );
	newMachine.angles = self.angles;
	newMachine.targetname = self.targetname;
	
	self Delete();
}

play_loop_on_machine()
{
	sound_ent = spawn( "script_origin", self.origin );
	sound_ent playloopsound("zmb_perks_machine_loop");
	self waittill( "stop_loopsound" );
	sound_ent delete();
}

//	
//
perk_fx( fx )
{
	wait(3);
	if ( IsDefined( self ) )
	{
		playfxontag( level._effect[ fx ], self, "tag_origin" );
	}
}




electric_perks_dialog()
{
	//TODO  TEMP Disable Revive in Solo games
	flag_wait( "start_zombie_round_logic" );
	players = GET_PLAYERS();
	if ( players.size == 1 )
	{
		return;
	}
	
	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = GET_PLAYERS();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer = 0;
				continue;
			}
			if(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer ++;
			}
			if(dist < 70*70 && timer == 3)
			{
				
				players[i] thread do_player_vo("vox_start", 5);	
				wait(3);				
				self notify ("warning_dialog");
				/#
				iprintlnbold("warning_given");
				#/
			}
		}
	}
}


//
//
vending_trigger_think()
{
	self endon( "death" );
	//self thread turn_cola_off();
	perk = self.script_noteworthy;
	solo = false;
	//flag_init( "_start_zm_pistol_rank" );
	
	//TODO  TEMP Disable Revive in Solo games
	if ( IsDefined(perk) && 
		(perk == "specialty_quickrevive" || perk == "specialty_quickrevive_upgrade") )
	{
		flag_wait( "start_zombie_round_logic" );
		players = GET_PLAYERS();
		if ( players.size == 1 )
		{
			solo = true;
			flag_set( "solo_game" );
			level.solo_lives_given = 0;
			players[0].lives = 0;
			level maps\mp\zombies\_zm::zombiemode_solo_last_stand_pistol();
		}
	}
	
	flag_set( "_start_zm_pistol_rank" );

	if ( !solo )
	{
		self SetHintString( &"ZOMBIE_NEED_POWER" );
	}

	self SetCursorHint( "HINT_NOICON" );
	self UseTriggerRequireLookAt();

	cost = level.zombie_vars["zombie_perk_cost"];
	switch( perk )
	{
	case "specialty_armorvest_upgrade":
	case "specialty_armorvest":
		cost = 2500;
		break;

	case "specialty_quickrevive_upgrade":
	case "specialty_quickrevive":
		if( solo )
		{
			cost = 500;
		}
		else
		{
			cost = 1500;
		}
		break;

	case "specialty_fastreload_upgrade":
	case "specialty_fastreload":
		cost = 3000;
		break;

	case "specialty_rof_upgrade":
	case "specialty_rof":
		cost = 2000;
		break;
		
	case "specialty_longersprint_upgrade":
	case "specialty_longersprint":
		cost = 2000;
		break;
		
	case "specialty_flakjacket_upgrade":
	case "specialty_flakjacket":
		cost = 2000;
		break;
		
	case "specialty_deadshot_upgrade":
	case "specialty_deadshot":
		cost = 1500; // WW (02-03-11): Setting this low at first so more people buy it and try it (TEMP)
		break;
		
	case "specialty_additionalprimaryweapon_upgrade":
	case "specialty_additionalprimaryweapon":
		cost = 4000;
		break;

	}

	self.cost = cost;

	if ( !solo )
	{
		notify_name = perk + "_power_on";
		level waittill( notify_name );
	}

	if(!IsDefined(level._perkmachinenetworkchoke))
	{
		level._perkmachinenetworkchoke = 0;
	}
	else
	{
		level._perkmachinenetworkchoke ++;
	}
	
	for(i = 0; i < level._perkmachinenetworkchoke; i ++)
	{
		wait_network_frame();
	}
	
	//Turn on music timer
	self thread maps\mp\zombies\_zm_audio::perks_a_cola_jingle_timer();

	self thread check_player_has_perk(perk);
	
	switch( perk )
	{
	case "specialty_armorvest_upgrade":
	case "specialty_armorvest":
		self SetHintString( &"ZOMBIE_PERK_JUGGERNAUT", cost );
		break;

	case "specialty_quickrevive_upgrade":
	case "specialty_quickrevive":
		if( solo )
		{
			self SetHintString( &"ZOMBIE_PERK_QUICKREVIVE_SOLO", cost );
		}
		else
		{
			self SetHintString( &"ZOMBIE_PERK_QUICKREVIVE", cost );
		}
		break;

	case "specialty_fastreload_upgrade":
	case "specialty_fastreload":
		self SetHintString( &"ZOMBIE_PERK_FASTRELOAD", cost );
		break;

	case "specialty_rof_upgrade":
	case "specialty_rof":
		self SetHintString( &"ZOMBIE_PERK_DOUBLETAP", cost );
		break;
		
	case "specialty_longersprint_upgrade":
	case "specialty_longersprint":
		self SetHintString( &"ZOMBIE_PERK_MARATHON", cost );
		break;
		
	case "specialty_flakjacket_upgrade":
	case "specialty_flakjacket":
		self SetHintString( &"ZOMBIE_PERK_DIVETONUKE", cost );
		break;
		
	case "specialty_deadshot_upgrade":
	case "specialty_deadshot":
		self SetHintString( &"ZOMBIE_PERK_DEADSHOT", cost );
		break;
		
	case "specialty_additionalprimaryweapon_upgrade":
	case "specialty_additionalprimaryweapon":
		self SetHintString( &"ZOMBIE_PERK_ADDITIONALPRIMARYWEAPON", cost );
		break;
		
	case "specialty_scavenger_upgrade": //t6.5todo: Temp Replacement For "tombstone"
	case "specialty_scavenger": //t6.5todo: Temp Replacement For "tombstone"
		self SetHintString( &"ZOMBIE_PERK_TOMBSTONE", cost );
		break;

	default:
		self SetHintString( perk + " Cost: " + level.zombie_vars["zombie_perk_cost"] );
	}

	for( ;; )
	{
		self waittill( "trigger", player );
		
		index = maps\mp\zombies\_zm_weapons::get_player_index(player);
		
		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( player.intermission ) )
		{
			continue;
		}

		if(player in_revive_trigger())
		{
			continue;
		}
		
		if( player isThrowingGrenade() )
		{
			wait( 0.1 );
			continue;
		}
		
 		if( player isSwitchingWeapons() )
 		{
 			wait(0.1);
 			continue;
 		}

		if( IS_DRINKING(player.is_drinking) )
		{
			wait( 0.1 );
			continue;
		}

		if ( player HasPerk( perk ) || player has_perk_paused( perk ) )
		{
			cheat = false;

			/#
			if ( GetDvarInt( "zombie_cheat" ) >= 5 )
			{
				cheat = true;
			}
			#/

			if ( cheat != true )
			{
				//player iprintln( "Already using Perk: " + perk );
				self playsound("deny");
				player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 1 );

				
				continue;
			}
		}

		if ( player.score < cost )
		{
			//player iprintln( "Not enough points to buy Perk: " + perk );
			self playsound("evt_perk_deny");
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "perk_deny", undefined, 0 );
			continue;
		}

		if ( player.num_perks >= 4 )
		{
			//player iprintln( "Too many perks already to buy Perk: " + perk );
			self playsound("evt_perk_deny");
			// COLLIN: do we have a VO that would work for this? if not we'll leave it at just the deny sound
			player maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "sigh" );
			continue;
		}

		sound = "evt_bottle_dispense";
		playsoundatposition(sound, self.origin);
		player maps\mp\zombies\_zm_score::minus_to_player_score( cost );

		player.perk_purchased = perk;

		//if( player unlocked_perk_upgrade( perk ) )
		//{
		//	perk += "_upgrade";
		//}

		///bottle_dispense
		switch( perk )
		{
		case "specialty_armorvest_upgrade":
		case "specialty_armorvest":
			sound = "mus_perks_jugger_sting";
			break;

		case "specialty_quickrevive_upgrade":
		case "specialty_quickrevive":
			sound = "mus_perks_revive_sting";
			break;

		case "specialty_fastreload_upgrade":
		case "specialty_fastreload":
			sound = "mus_perks_speed_sting";
			break;

		case "specialty_rof_upgrade":
		case "specialty_rof":
			sound = "mus_perks_doubletap_sting";
			break;
			
		case "specialty_longersprint_upgrade":
		case "specialty_longersprint":
			sound = "mus_perks_phd_sting";
			break;
			
		case "specialty_flakjacket_upgrade":
		case "specialty_flakjacket":
			sound = "mus_perks_stamin_sting";
			break;
			
		case "specialty_deadshot_upgrade":
		case "specialty_deadshot":
			sound = "mus_perks_jugger_sting"; // WW TODO: Place new deadshot stinger
			break;
			
		case "specialty_additionalprimaryweapon_upgrade":
		case "specialty_additionalprimaryweapon":
			sound = "mus_perks_mulekick_sting";
			break;

		default:
			sound = "mus_perks_jugger_sting";
			break;
		}
		
		self thread maps\mp\zombies\_zm_audio::play_jingle_or_stinger (self.script_label);
	
		//		self waittill("sound_done");
		
		self thread vending_trigger_post_think( player, perk );
	}
}

vending_trigger_post_think( player, perk )
{
	// do the drink animation
	gun = player perk_give_bottle_begin( perk );
	player waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	// restore player controls and movement
	player perk_give_bottle_end( gun, perk );

	// TODO: race condition?
	if ( player maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( player.intermission ) )
	{
		return;
	}

	if ( isDefined( level.perk_bought_func ) )
	{
		player [[ level.perk_bought_func ]]( perk );
	}

	player.perk_purchased = undefined;

	player give_perk( perk, true );
	
	// Check If Perk Machine Was Powered Down While Drinking, Is So Pause The Perks
	//-----------------------------------------------------------------------------
	if ( is_false( self.power_on ) )
	{
		perk_pause( self.script_noteworthy );
	}

	//player iprintln( "Bought Perk: " + perk );
	bbPrint( "zombie_uses: playername %s playerscore %d round %d name %s x %f y %f z %f type perk",
		player.name, player.score, level.round_number, perk, self.origin );
}

// ww: tracks the player's lives in solo, once a life is used then the revive trigger is moved back in to position
solo_revive_buy_trigger_move( revive_trigger_noteworthy )
{
	self endon( "death" );
	
	revive_perk_trigger = GetEnt( revive_trigger_noteworthy, "script_noteworthy" );
	
	revive_perk_trigger trigger_off();
	
	if( level.solo_lives_given >= 3 )
	{
		if(IsDefined(level._solo_revive_machine_expire_func))
		{
			revive_perk_trigger [[level._solo_revive_machine_expire_func]]();
		}

		return;
	}
	
	while( self.lives > 0 )
	{
		wait( 0.1 );
	}
	
	revive_perk_trigger trigger_on();
}

// unlocked_perk_upgrade( perk )
// {
// 	ch_ref = string(tablelookup( "mp/challengeTable_zmPerk.csv", 12, perk, 7 ));
// 	ch_max = int(tablelookup( "mp/challengeTable_zmPerk.csv", 12, perk, 4 ));
// 	ch_progress = self getdstat( "challengeStats", ch_ref, "challengeProgress" );
// 	
// 	if( ch_progress >= ch_max )
// 	{
// 		return true;
// 	}
// 	return false;
// }

give_perk( perk, bought )
{
	self SetPerk( perk );
	self.num_perks++;

	if ( is_true( bought ) )
	{
		//AUDIO: Ayers - Sending Perk Name over to audio common script to play VOX
		self thread maps\mp\zombies\_zm_audio::perk_vox( perk );
		self setblur( 4, 0.1 );
		wait(0.1);
		self setblur(0, 0.1);
		//earthquake (0.4, 0.2, self.origin, 100);

		self notify( "perk_bought", perk );
	}

	if(perk == "specialty_armorvest")
	{
		self.preMaxHealth = self.maxhealth;
		self SetMaxHealth( level.zombie_vars["zombie_perk_juggernaut_health"] );
	}
	else if(perk == "specialty_armorvest_upgrade")
	{
		self.preMaxHealth = self.maxhealth;
		self SetMaxHealth( level.zombie_vars["zombie_perk_juggernaut_health_upgrade"] );
	}
	
	// WW (02-03-11): Deadshot csc call
	if( perk == "specialty_deadshot" )
	{
		self SetClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
	}
	else if( perk == "specialty_deadshot_upgrade" )
	{
		self SetClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
	}
	
	if ( perk == "specialty_scavenger" ) //t6.5todo: Temp Replacement For "tombstone"
	{
		self.HasPerkSpecialtyTombstone = true;
	}

	// quick revive in solo gives an extra life
	players = GET_PLAYERS();
	if ( players.size == 1 && perk == "specialty_quickrevive" )
	{
		self.lives = 1;
		
		level.solo_lives_given++;
		
		if( level.solo_lives_given >= 3 )
		{
			flag_set( "solo_revive" );
		}
		
		self thread solo_revive_buy_trigger_move( perk );
		
		// self disable_trigger();
	}

	self perk_hud_create( perk );

	//stat tracking
	self maps\mp\zombies\_zm_stats::increment_client_stat( "perks_drank" );

	self thread perk_think( perk );
}

check_player_has_perk(perk)
{
	self endon( "death" );
/#
	if ( GetDvarInt( "zombie_cheat" ) >= 5 )
	{
		return;
	}
#/

	dist = 128 * 128;
	while(true)
	{
		players = GET_PLAYERS();
		for( i = 0; i < players.size; i++ )
		{
			if(DistanceSquared( players[i].origin, self.origin ) < dist)
			{
				if(!players[i] hasperk(perk) && 
				   !players[i] has_perk_paused(perk) && 
				   !(players[i] in_revive_trigger()) && 
				   (!players[i] hacker_active()))
				{
					self setinvisibletoplayer(players[i], false);
				}
				else
				{
					self SetInvisibleToPlayer(players[i], true);
				}
			}
		}
		wait(0.1);

	}
}


vending_set_hintstring( perk )
{
	switch( perk )
	{
	case "specialty_armorvest_upgrade":
	case "specialty_armorvest":
		break;

	}
}

perk_think( perk )
{
/#
	if ( GetDvarInt( "zombie_cheat" ) >= 5 )
	{
		if ( IsDefined( self.perk_hud[ perk ] ) )
		{
			return;
		}
	}
#/

	perk_str = perk + "_stop";
	result = self waittill_any_return( "fake_death", "death", "player_downed", perk_str );

	do_retain = true;
	
	if( (GET_PLAYERS().size == 1) && perk == "specialty_quickrevive")
	{
		do_retain = false;
	}

	if(do_retain && IsDefined(self._retain_perks) && self._retain_perks)
	{
		return;
	}

	self UnsetPerk( perk );
	self.num_perks--;
	
	switch(perk)
	{
		case "specialty_armorvest":
			self SetMaxHealth( 100 );
			break;
		
		case "specialty_additionalprimaryweapon":
			if ( result == perk_str )
			{
				self maps\mp\zombies\_zm::take_additionalprimaryweapon();
			}
			break;
		
		case "specialty_deadshot":
			self ClearClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
			break;
		
		case "specialty_deadshot_upgrade":		
			self ClearClientFlag(level._ZOMBIE_PLAYER_FLAG_DEADSHOT_PERK);
			break;
	}
	
	self perk_hud_destroy( perk );
	self.perk_purchased = undefined;
	//self iprintln( "Perk Lost: " + perk );


	if ( IsDefined( level.perk_lost_func ) )
	{
		self [[ level.perk_lost_func ]]( perk );
	}

	self notify( "perk_lost" );
}


perk_hud_create( perk )
{
	if ( !IsDefined( self.perk_hud ) )
	{
		self.perk_hud = [];
	}

/#
	if ( GetDvarInt( "zombie_cheat" ) >= 5 )
	{
		if ( IsDefined( self.perk_hud[ perk ] ) )
		{
			return;
		}
	}
#/


	shader = "";

	switch( perk )
	{
	case "specialty_armorvest_upgrade":
		shader = "specialty_juggernaut_zombies_pro";
		break;
	case "specialty_armorvest":
		shader = "specialty_juggernaut_zombies";
		break;

	case "specialty_quickrevive_upgrade":
		shader = "specialty_quickrevive_zombies_pro";
		break;
	case "specialty_quickrevive":
		shader = "specialty_quickrevive_zombies";
		break;

	case "specialty_fastreload_upgrade":
		shader = "specialty_fastreload_zombies_pro";
		break;
	case "specialty_fastreload":
		shader = "specialty_fastreload_zombies";
		break;

	case "specialty_rof_upgrade":
	case "specialty_rof":
		shader = "specialty_doubletap_zombies";
		break;
		
	case "specialty_longersprint_upgrade":
	case "specialty_longersprint":
		shader = "specialty_marathon_zombies";
		break;
		
	case "specialty_flakjacket_upgrade":
	case "specialty_flakjacket":
		shader = "specialty_divetonuke_zombies";
		break;
		
	case "specialty_deadshot_upgrade":
	case "specialty_deadshot":
		shader = "specialty_ads_zombies"; 
		break;

	case "specialty_additionalprimaryweapon_upgrade":
	case "specialty_additionalprimaryweapon":
		shader = "specialty_extraprimaryweapon_zombies";
		break;
		
	case "specialty_scavenger_upgrade": //t6.5todo: Temp Replacement For "tombstone"
	case "specialty_scavenger": //t6.5todo: Temp Replacement For "tombstone"
		shader = "specialty_tombstone_zombies";
		break;
		
	default:
		shader = "";
		break;
	}

	hud = create_simple_hud( self );
	hud.foreground = true; 
	hud.sort = 1; 
	hud.hidewheninmenu = false; 
	hud.alignX = "left"; 
	hud.alignY = "bottom";
	hud.horzAlign = "user_left"; 
	hud.vertAlign = "user_bottom";
	hud.x = self.perk_hud.size * 30; 
	hud.y = hud.y - 70; 
	hud.alpha = 1;
	hud SetShader( shader, 24, 24 );

	self.perk_hud[ perk ] = hud;
}


perk_hud_destroy( perk )
{
	self.perk_hud[ perk ] destroy_hud();
	self.perk_hud[ perk ] = undefined;
}

perk_hud_grey( perk, grey_on_off )
{
	if ( grey_on_off )
		self.perk_hud[ perk ].alpha = 0.3;
	else
		self.perk_hud[ perk ].alpha = 1.0;
}

perk_hud_flash()
{
	self endon( "death" );

	self.flash = 1;
	self ScaleOverTime( 0.05, 32, 32 );
	wait( 0.3 );
	self ScaleOverTime( 0.05, 24, 24 );
	wait( 0.3 );
	self.flash = 0;
}

perk_flash_audio( perk )
{
    alias = undefined;
    
    switch( perk )
    {
        case "specialty_armorvest":
            alias = "zmb_hud_flash_jugga";
            break;
        
        case "specialty_quickrevive":
            alias = "zmb_hud_flash_revive";
            break;
            
        case "specialty_fastreload":
            alias = "zmb_hud_flash_speed";
            break;
        
        case "specialty_longersprint":
            alias = "zmb_hud_flash_stamina";
            break;
            
        case "specialty_flakjacket":
            alias = "zmb_hud_flash_phd";
            break;
        
        case "specialty_deadshot":
            alias = "zmb_hud_flash_deadshot";
            break;
        
        case "specialty_additionalprimaryweapon":
            alias = "zmb_hud_flash_additionalprimaryweapon";
            break;
    }
    
    if( IsDefined( alias ) )
        self PlayLocalSound( alias );
}

perk_hud_start_flash( perk )
{
	if ( self HasPerk( perk ) && isdefined( self.perk_hud ) )
	{
		hud = self.perk_hud[perk];
		if ( isdefined( hud ) )
		{
			if ( !is_true( hud.flash ) )
			{
				hud thread perk_hud_flash();
				self thread perk_flash_audio( perk );
			}
		}
	}
}

perk_hud_stop_flash( perk, taken )
{
	if ( self HasPerk( perk ) && isdefined( self.perk_hud ) )
	{
		hud = self.perk_hud[perk];
		if ( isdefined( hud ) )
		{
			hud.flash = undefined;
			if ( isdefined( taken ) )
			{
				hud notify( "stop_flash_perk" );
			}
		}
	}
}

perk_give_bottle_begin( perk )
{
	self increment_is_drinking();
	
	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowCrouch( true );
	self AllowProne( false );
	self AllowMelee( false );

	wait( 0.05 );

	if ( self GetStance() == "prone" )
	{
		self SetStance( "crouch" );
	}

	gun = self GetCurrentWeapon();
	weapon = "";

	switch( perk )
	{
	case " _upgrade":
	case "specialty_armorvest":
		weapon = "zombie_perk_bottle_jugg";
		break;

	case "specialty_quickrevive_upgrade":
	case "specialty_quickrevive":
		weapon = "zombie_perk_bottle_revive";
		break;

	case "specialty_fastreload_upgrade":
	case "specialty_fastreload":
		weapon = "zombie_perk_bottle_sleight";
		break;

	case "specialty_rof_upgrade":
	case "specialty_rof":
		weapon = "zombie_perk_bottle_doubletap";
		break;
		
	case "specialty_longersprint_upgrade":
	case "specialty_longersprint":
		weapon = "zombie_perk_bottle_marathon";
		break;
		
	case "specialty_flakjacket_upgrade":
	case "specialty_flakjacket":
		weapon = "zombie_perk_bottle_nuke";
		break;
		
	case "specialty_deadshot_upgrade":
	case "specialty_deadshot":
		weapon = "zombie_perk_bottle_deadshot";
		break;
		
	case "specialty_additionalprimaryweapon_upgrade":
	case "specialty_additionalprimaryweapon":
		weapon = "zombie_perk_bottle_additionalprimaryweapon";
		break;
		
	case "specialty_scavenger_upgrade": //t6.5todo: Temp Replacement For "tombstone"
	case "specialty_scavenger": //t6.5todo: Temp Replacement For "tombstone"
		weapon = "zombie_perk_bottle_tombstone";
		break;
	}

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );

	return gun;
}


perk_give_bottle_end( gun, perk )
{
	assert( gun != "zombie_perk_bottle_doubletap" );
	assert( gun != "zombie_perk_bottle_jugg" );
	assert( gun != "zombie_perk_bottle_revive" );
	assert( gun != "zombie_perk_bottle_sleight" );
	assert( gun != "zombie_perk_bottle_marathon" );
	assert( gun != "zombie_perk_bottle_nuke" );
	assert( gun != "zombie_perk_bottle_deadshot" );
	assert( gun != "zombie_perk_bottle_additionalprimaryweapon" );
	assert( gun != "zombie_perk_bottle_tombstone" );
	assert( gun != level.revive_tool );

	self AllowLean( true );
	self AllowAds( true );
	self AllowSprint( true );
	self AllowProne( true );		
	self AllowMelee( true );
	weapon = "";
	switch( perk )
	{
	case "specialty_rof_upgrade":
	case "specialty_rof":
		weapon = "zombie_perk_bottle_doubletap";
		break;

	case "specialty_longersprint_upgrade":
	case "specialty_longersprint":
		weapon = "zombie_perk_bottle_marathon";
		break;
		
	case "specialty_flakjacket_upgrade":
	case "specialty_flakjacket":
		weapon = "zombie_perk_bottle_nuke";
		break;

	case "specialty_armorvest_upgrade":
	case "specialty_armorvest":
		weapon = "zombie_perk_bottle_jugg";
		self.jugg_used = true;
		break;

	case "specialty_quickrevive_upgrade":
	case "specialty_quickrevive":
		weapon = "zombie_perk_bottle_revive";
		break;

	case "specialty_fastreload_upgrade":
	case "specialty_fastreload":
		weapon = "zombie_perk_bottle_sleight";
		self.speed_used = true;
		break;
		
	case "specialty_deadshot_upgrade":
	case "specialty_deadshot":
		weapon = "zombie_perk_bottle_deadshot";
		break;

	case "specialty_additionalprimaryweapon_upgrade":
	case "specialty_additionalprimaryweapon":
		weapon = "zombie_perk_bottle_additionalprimaryweapon";
		break;

	}

	// TODO: race condition?
	if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || is_true( self.intermission ) )
	{
		self TakeWeapon(weapon);
		return;
	}

	self TakeWeapon(weapon);

	if( self is_multiple_drinking() )
	{
		self decrement_is_drinking();
		return;
	}
	else if( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
	{
		self SwitchToWeapon( gun );
		// ww: the knives have no first raise anim so they will never get a "weapon_change_complete" notify
		// meaning it will never leave this funciton and will break buying weapons for the player
		if( is_melee_weapon( gun ) )
		{
			self decrement_is_drinking();
			return;
		}
	}
	else 
	{
		// try to switch to first primary weapon
		primaryWeapons = self GetWeaponsListPrimaries();
		if( IsDefined( primaryWeapons ) && primaryWeapons.size > 0 )
		{
			self SwitchToWeapon( primaryWeapons[0] );
		}
	}

	self waittill( "weapon_change_complete" );

	if ( !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !is_true( self.intermission ) )
	{
		self decrement_is_drinking();
	}
}

give_random_perk()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	perks = [];
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		perk = vending_triggers[i].script_noteworthy;

		if ( isdefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}

		if ( !self HasPerk( perk ) && !self has_perk_paused( perk ) )
		{
			perks[ perks.size ] = perk;
		}
	}

	if ( perks.size > 0 )
	{
		perks = array_randomize( perks );
		self give_perk( perks[0] );
	}
}


lose_random_perk()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	perks = [];
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		perk = vending_triggers[i].script_noteworthy;

		if ( isdefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			continue;
		}

		if ( self HasPerk( perk ) || self has_perk_paused( perk ) )
		{
			perks[ perks.size ] = perk;
		}
	}

	if ( perks.size > 0 )
	{
		perks = array_randomize( perks );
		perk = perks[0];

		perk_str = perk + "_stop";
		self notify( perk_str );

		if ( flag( "solo_game" ) && perk == "specialty_quickrevive" )
		{
			self.lives--;
		}
	}
}

update_perk_hud()
{
	if ( isdefined( self.perk_hud ) )
	{
		keys = getarraykeys( self.perk_hud );
		for ( i = 0; i < self.perk_hud.size; i++ )
		{
			self.perk_hud[ keys[i] ].x = i * 30;
		}
	}
}

quantum_bomb_give_nearest_perk_validation( position )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	range_squared = 180 * 180; // 15 feet
	for ( i = 0; i < vending_triggers.size; i++ )
	{
		if ( DistanceSquared( vending_triggers[i].origin, position ) < range_squared )
		{
			return true;
		}
	}

	return false;
}


quantum_bomb_give_nearest_perk_result( position )
{
	[[level.quantum_bomb_play_mystery_effect_func]]( position );

	vending_triggers = GetEntArray( "zombie_vending", "targetname" );

	nearest = 0;
	for ( i = 1; i < vending_triggers.size; i++ )
	{
		if ( DistanceSquared( vending_triggers[i].origin, position ) < DistanceSquared( vending_triggers[nearest].origin, position ) )
		{
			nearest = i;
		}
	}

	players = GET_PLAYERS();
	perk = vending_triggers[nearest].script_noteworthy;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( player.sessionstate == "spectator" || player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			continue;
		}

		if ( !player HasPerk( perk ) && ( !isdefined( player.perk_purchased ) || player.perk_purchased != perk) && RandomInt( 5 ) ) // 80% chance
		{
			if( player == self )
			{
				self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "quant_good" );
			}
			
			player give_perk( perk );
			player [[level.quantum_bomb_play_player_effect_func]]();
		}
	}
}

perk_pause( perk )
{
	if (perk == "Pack_A_Punch" || perk == "specialty_weapupgrade")
		return;
		
	if ( ( perk == "specialty_quickrevive" || perk == "specialty_quickrevive_upgrade" ) && flag( "solo_game" ) )
	{
		return;
	}

	for ( j = 0; j < GET_PLAYERS().size; j++ )
	{
		player = GET_PLAYERS()[j];
		if (!isdefined(player.disabled_perks))
			player.disabled_perks=[];
		player.disabled_perks[perk] = is_true(player.disabled_perks[perk]) || player HasPerk( perk ); 
		if ( player.disabled_perks[perk] )
		{
			player UnsetPerk( perk );
			player perk_hud_grey( perk, true );
		}
	}
}

perk_unpause( perk )
{
	if (perk == "Pack_A_Punch")
		return;

	for ( j = 0; j < GET_PLAYERS().size; j++ )
	{
		player = GET_PLAYERS()[j];
		if ( isdefined(player.disabled_perks) && is_true(player.disabled_perks[perk]) )
		{
			player.disabled_perks[perk]=false;
			player perk_hud_grey( perk, false );
			player SetPerk( perk );
		}
	}
}

perk_pause_all_perks()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		maps\mp\zombies\_zm_perks::perk_pause(trigger.script_noteworthy);
	}
}


perk_unpause_all_perks()
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	foreach ( trigger in vending_triggers )
	{
		maps\mp\zombies\_zm_perks::perk_unpause(trigger.script_noteworthy);
	}

// brute force
/*
	perk_unpause("specialty_armorvest_upgrade");
	perk_unpause("specialty_armorvest");
	perk_unpause("specialty_quickrevive_upgrade");
	perk_unpause("specialty_quickrevive");
	perk_unpause("specialty_fastreload_upgrade");
	perk_unpause("specialty_fastreload");
	perk_unpause("specialty_rof_upgrade");
	perk_unpause("specialty_rof");
	perk_unpause("specialty_longersprint_upgrade");
	perk_unpause("specialty_longersprint");
	perk_unpause("specialty_flakjacket_upgrade");
	perk_unpause("specialty_flakjacket");
	perk_unpause("specialty_deadshot_upgrade");
	perk_unpause("specialty_deadshot");
	perk_unpause("specialty_additionalprimaryweapon_upgrade");
	perk_unpause("specialty_additionalprimaryweapon");
	perk_unpause("specialty_scavenger_upgrade");
	perk_unpause("specialty_scavenger");
*/
}

has_perk_paused( perk ) // self = player
{
	if ( isdefined(self.disabled_perks) && isdefined(self.disabled_perks[perk]) && self.disabled_perks[perk] )
	{
		return true;
	}
	return false;
}


getVendingMachineNotify()
{
	switch ( self.script_noteworthy )
	{
		case "specialty_armorvest_upgrade":
		case "specialty_armorvest":
		return "juggernog";
		break;

		case "specialty_quickrevive_upgrade":
		case "specialty_quickrevive":
		return "revive";
		break;

		case "specialty_fastreload_upgrade":
		case "specialty_fastreload":
		return "sleight";
		break;

		case "specialty_rof_upgrade":
		case "specialty_rof":
		return "doubletap";
		break;

		case "specialty_longersprint_upgrade":
		case "specialty_longersprint":
		return "marathon";
		break;

		case "specialty_flakjacket_upgrade":
		case "specialty_flakjacket":
		return "divetonuke";
		break;

		case "specialty_deadshot_upgrade":
		case "specialty_deadshot":
		return "deadshot";
		break;

		case "specialty_additionalprimaryweapon_upgrade":
		case "specialty_additionalprimaryweapon":
		return "additionalprimaryweapon";
		break;

		case "specialty_scavenger_upgrade": //t6.5todo: Temp Replacement For "tombstone"
		case "specialty_scavenger": //t6.5todo: Temp Replacement For "tombstone"
		return "tombstone";
		break;

		case "specialty_weapupgrade":
		return "Pack_A_Punch";

		default:
		return undefined;
	}
}

//=====================================================================
// Simple utility to remove a perk machine and replace it with a model.
//=====================================================================
perk_machine_removal(machine, replacement_model)
{
	if(!IsDefined(machine))
	{
		return;
	}	

	trig = GetEnt(machine, "script_noteworthy");
	machine_model = undefined;

	if(IsDefined(trig))
	{
		// remove from vending array.
		trig notify ("warning_dialog");

		if(IsDefined(trig.target))
		{
			parts = GetEntArray(trig.target, "targetname");
			for ( i = 0; i < parts.size; i++ )
			{
				if(IsDefined(parts[i].classname) && parts[i].classname == "script_model")
				{
					machine_model = parts[i];
				}
				else if(IsDefined(parts[i].script_noteworthy && parts[i].script_noteworthy == "clip"))
				{
					model_clip = parts[i];
				}	
				else
				{
					parts[i] Delete();
				}		
			}
		}
		
		// If a replacement model is not specified it will just delete the perk machine.
		if(IsDefined(replacement_model) && IsDefined(machine_model))
		{
			machine_model SetModel(replacement_model);
		}
		else if(!IsDefined(replacement_model) && IsDefined(machine_model))
		{
			machine_model Delete();
			if(IsDefined(model_clip))
				model_clip Delete();
			if(IsDefined(trig.clip)) //from spawned perk clip.
				trig.clip Delete();
		}
		
		if(IsDefined(trig.bump))
			trig.bump Delete();
	
		trig Delete();		
	}
}	
//=====================================================================
// Simple utility to Add a perk machine.
// model and script_noteworthy need to be set on struct.
//=====================================================================
perk_machine_spawn_init()
{
	match_string = "";

	location = level.scr_zm_map_start_location;
	if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
	{
		location = level.default_start_location;
	}		

	match_string = level.scr_zm_ui_gametype + "_perks_" + location;

	pos = [];
	structs = getstructarray("zm_perk_machine", "targetname");
	foreach(struct in structs)
	{
		if(IsDefined(struct.script_string) )
		{
			tokens = strtok(struct.script_string," ");
			foreach(token in tokens)
			{
				if(token == match_string )
				{
					pos[pos.size] =	struct;
				}
			}
		}
	}			
		
	if(!IsDefined(pos) || pos.size == 0)
		return;
		
	PreCacheModel("zm_collision_perks1");

	for ( i = 0; i < pos.size; i++ )
	{
		perk = pos[i].script_noteworthy;
		if(IsDefined(perk) && IsDefined(pos[i].model))
		{
			use_trigger = Spawn( "trigger_radius_use", pos[i].origin + (0, 0, 30), 0, 40, 70 );
			use_trigger.targetname = "zombie_vending";			
			use_trigger.script_noteworthy = perk;
			use_trigger TriggerIgnoreTeam();
			//use_trigger thread debug_spot();
	
			perk_machine = Spawn("script_model", pos[i].origin);
			perk_machine.angles = pos[i].angles;
			perk_machine SetModel(pos[i].model);
				
			bump_trigger = Spawn( "trigger_radius", pos[i].origin, 0, 35, 64);
			bump_trigger.script_activated = 1;
			bump_trigger.script_sound = "fly_bump_bottle";
			bump_trigger.targetname = "audio_bump_trigger";
				
			collision = Spawn("script_model", pos[i].origin, 1);
			collision.angles = pos[i].angles;
			collision SetModel("zm_collision_perks1");
			collision.script_noteworthy = "clip";
			collision DisconnectPaths();
			
			// Connect all of the pieces for easy access.
			use_trigger.clip = collision;
			use_trigger.machine = perk_machine;
			use_trigger.bump = bump_trigger;

			switch( perk )
			{
				case "specialty_quickrevive_upgrade":
				case "specialty_quickrevive":
					use_trigger.script_sound = "mus_perks_revive_jingle";
					use_trigger.script_string = "revive_perk";
					use_trigger.script_label = "mus_perks_revive_sting";
					use_trigger.target = "vending_revive";
					perk_machine.script_string = "revive_perk";
					perk_machine.targetname = "vending_revive"; 
					bump_trigger.script_string = "revive_perk";
					//collision.targetname = "vending_revive";
					break;
						
				case "specialty_fastreload_upgrade":
				case "specialty_fastreload":
					use_trigger.script_sound = "mus_perks_speed_jingle";
					use_trigger.script_string = "speedcola_perk";
					use_trigger.script_label = "mus_perks_speed_sting";
					use_trigger.target = "vending_sleight";
					perk_machine.script_string = "speedcola_perk";
					perk_machine.targetname = "vending_sleight"; 
					bump_trigger.script_string = "speedcola_perk";
					break;
		
				case "specialty_longersprint_upgrade":
				case "specialty_longersprint":
					use_trigger.script_sound = "mus_perks_stamin_jingle";
					use_trigger.script_string = "marathon_perk";
					use_trigger.script_label = "mus_perks_stamin_sting";
					use_trigger.target = "vending_marathon";
					perk_machine.script_string = "marathon_perk";
					perk_machine.targetname = "vending_marathon"; 
					bump_trigger.script_string = "marathon_perk";
					break;
					
				case "specialty_armorvest_upgrade":
				case "specialty_armorvest":
					use_trigger.script_sound = "mus_perks_jugganog_jingle";
					use_trigger.script_string = "jugg_perk";
					use_trigger.script_label = "mus_perks_jugganog_sting";
					use_trigger.target = "vending_jugg";
					perk_machine.script_string = "jugg_perk";
					perk_machine.targetname = "vending_jugg"; 
					bump_trigger.script_string = "jugg_perk";
					break;
					
				case "specialty_scavenger_upgrade":
				case "specialty_scavenger":
					use_trigger.script_sound = "mus_perks_speed_jingle";
					use_trigger.script_string = "tombstone_perk";
					use_trigger.script_label = "mus_perks_speed_sting";
					use_trigger.target = "vending_tombstone";
					perk_machine.script_string = "tombstone_perk";
					perk_machine.targetname = "vending_tombstone"; 
					bump_trigger.script_string = "tombstone_perk";
					break;										

				case "specialty_rof_upgrade":
				case "specialty_rof":
					use_trigger.script_sound = "mus_perks_doubletap_jingle";
					use_trigger.script_string = "tap_perk";
					use_trigger.script_label = "mus_perks_doubletap_sting";
					use_trigger.target = "vending_doubletap";
					perk_machine.script_string = "tap_perk";
					perk_machine.targetname = "vending_doubletap"; 
					bump_trigger.script_string = "tap_perk";
					break;
					
				case "specialty_weapupgrade":
					use_trigger.target = "vending_packapunch";
					perk_machine.targetname = "vending_packapunch";
					flag_pos = getstruct(pos[i].target, "targetname");
					if(IsDefined(flag_pos))
					{
						perk_machine_flag = Spawn("script_model", flag_pos.origin);
						perk_machine_flag.angles = flag_pos.angles;
						perk_machine_flag SetModel(flag_pos.model);			
						perk_machine_flag.targetname = "pack_flag";
						perk_machine.target = "pack_flag";
					}	
					bump_trigger.script_string = "perks_rattle";
					//pack_struct.script_sound = "mx_packa_jingle";
					//pack_struct.targetname = "perksacola";
					break;										
					
				default:
					use_trigger.script_sound = "mus_perks_speed_jingle";
					use_trigger.script_string = "speedcola_perk";
					use_trigger.script_label = "mus_perks_speed_sting";
					use_trigger.target = "vending_sleight";
					perk_machine.script_string = "speedcola_perk";
					perk_machine.targetname = "vending_sleight"; 
					bump_trigger.script_string = "speedcola_perk";
					break;			
			}
		}
	}	
}	