#using scripts\shared\callbacks_shared;
#using scripts\shared\destructible_cover_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\player_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\cp\gametypes\_save;

#using scripts\cp\_ammo_cache;
#using scripts\cp\_elevator;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_vehicle_platform;

#using scripts\cp\cp_mi_cairo_lotus_fx;
#using scripts\cp\cp_mi_cairo_lotus_sound;
#using scripts\cp\lotus_security_station;
#using scripts\cp\lotus_start_riot;

#using scripts\cp\voice\voice_lotus1;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

function main()
{
	savegame::set_mission_name("lotus");
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		level.giveCustomLoadout = &giveCustomLoadout;
		level.weaponRiotshield = GetWeapon( "lefthand_shield" );
		level.laststandweaponoverride = &riotshield_check;
		level.laststandweapongivenoverride = &riotshield_check_given;
		level.laststandweaponreturnedoverride = &riotshield_check_returned;
		level.overrideActorDamage = &riotshield_melee_damage;
		level.overridePlayerDamage = &override_player_damage;
		level.overrideAmmoDropTeam3 = true;
	
		callback::on_actor_killed( &check_riotshield_kill );
		callback::on_spawned( &on_player_spawned );
	}

	//visionset_mgr::register_info( "overlay", "shotgun_electric", VERSION_SHIP, 60, 15, true, &visionset_mgr::duration_lerp_thread_per_player, false );
	
	voice_lotus1::init_voice();
		
	precache();
	init_variables();
	setup_skiptos();
	
	cp_mi_cairo_lotus_fx::main();
	cp_mi_cairo_lotus_sound::main();
	
	lotus_start_riot::init();
	lotus_security_station::init();
	
	load::main();
	
	skipto::set_skip_safehouse();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function init_variables()
{	
	// only global level variables should be place here
}

//*****************************************************************************
// SKIPTOS
//*****************************************************************************
function setup_skiptos()
{	
	// Events 1 - 5
	skipto::add( "plan_b", 					&lotus_start_riot::plan_b_main,							"Plan B", 						&lotus_start_riot::plan_b_done );
	skipto::add( "start_the_riots", 		&lotus_start_riot::main,								"Start the Riots",				&lotus_start_riot::start_the_riots_done );
	skipto::add( "general_hakim", 			&lotus_start_riot::general_hakim_main,					"General Hakim",				&lotus_start_riot::general_hakim_done );
	skipto::add( "apartments",				&lotus_security_station::main, 							"Apartments",					&lotus_security_station::apartments_done );
	skipto::add( "atrium_battle",			&lotus_security_station::atrium_battle,					"Atrium Battle",				&lotus_security_station::atrium_battle_done );
	skipto::add( "to_security_station",		&lotus_security_station::to_security_station, 			"To Security Station",			&lotus_security_station::to_security_station_done );
	skipto::add( "hack_the_system", 		&lotus_security_station::hack_the_system_main,			"Hack the System",				&lotus_security_station::hack_the_system_done );
	
	// Events 6 - 10
	skipto::add( "prometheus_otr",			&skipto_lotus_2 );
	skipto::add( "vtol_hallway",			&skipto_lotus_2 );
	skipto::add( "mobile_shop_ride2",		&skipto_lotus_2 );
	skipto::add( "bridge_battle",			&skipto_lotus_2 );
	skipto::add( "up_to_detention_center",	&skipto_lotus_2 );
	skipto::add( "detention_center",		&skipto_lotus_2 );
	skipto::add( "stand_down", 				&skipto_lotus_2 );
	skipto::add( "pursuit", 				&skipto_lotus_2 );
	skipto::add( "industrial_zone", 		&skipto_lotus_2 );
	skipto::add( "sky_bridge1", 			&skipto_lotus_2 );
	skipto::add( "sky_bridge2", 			&skipto_lotus_2 );
	
	// Events 11 - 17
	skipto::add( "tower_2_ascent", 			&skipto_lotus_3 );
	skipto::add( "prometheus_intro",		&skipto_lotus_3 );
	skipto::add( "boss_battle", 			&skipto_lotus_3 );
	skipto::add( "old_friend", 				&skipto_lotus_3 );
	
	/#
	skipto::add_billboard( "plan_b", "1. Plan B", "IGC", "Short", "Alpha" );
	skipto::add_billboard( "start_the_riots", "2. Start The Riots", "Combat", "Medium", "Alpha" );
	skipto::add_billboard( "general_hakim", "3. General Hakim", "IGC", "Short", "Alpha" );
	skipto::add_billboard( "apartments", "4. Apartments", "Combat", "Short", "Alpha" );
	skipto::add_billboard( "atrium_battle", "4. Atrium Battle", "Combat", "Short", "Alpha" );
	skipto::add_billboard( "to_security_station", "4. To Security Station", "Combat", "Short", "Alpha" );
	skipto::add_billboard( "hack_the_system", "5. Hack The Sytem", "Pacing", "Short", "Alpha" );
	#/
}

function skipto_lotus_2( str_objective, b_starting )
{	
	SwitchMap_Load( "cp_mi_cairo_lotus2" );
	
	wait 0.05;
	
	SwitchMap_Switch();
}

function skipto_lotus_3( str_objective, b_starting )
{	
	SwitchMap_Load( "cp_mi_cairo_lotus3" );
	
	wait 0.05;
	
	SwitchMap_Switch();
}

function on_player_spawned()
{
	self thread player_watch_melee_charge();
}

function giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	if ( !level flag::get( "apartments_completed" ) )
	{	
		player::take_weapons();
		
		if ( level flag::get( "plan_b_completed" ) )
		{
			currentWeapon = level.weaponRiotshield;
		
			self giveWeapon( currentWeapon );
			self switchToWeapon( currentWeapon );
		}
	}
		
	return currentWeapon;
}

function riotshield_melee_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{
	if ( weapon.name == "lefthand_shield" )
	{
		eAttacker.is_charged_riotshield = true;//HACK - make this active all the time until a decision is made on what is really wanted
		return self.health;
	}
	
	return iDamage;
}

function check_riotshield_kill()
{
	if( ( isdefined( self.attacker.is_charged_riotshield ) && self.attacker.is_charged_riotshield ) )
	{
		direction_forward = AnglesToForward( self.attacker.angles );
		direction_vector = VectorScale( direction_forward, 256 );
		
		self StartRagdoll();
		self LaunchRagdoll( ( direction_vector / 3 ) + ( 0, 0, 30 ) );
	}
}

function riotshield_check()
{
	if( self.lastActiveWeapon == GetWeapon( "lefthand_shield" ) )
	{
		self.laststandpistol = GetWeapon( "lefthand_shield_laststand" );;//special case weapon, ADS ability removed
		self.laststandshieldhealth = self.weaponHealth; 
	}
}
function riotshield_check_given()
{
	if( self.lastActiveWeapon == GetWeapon( "lefthand_shield" ) )
	{
		self.weaponHealth = self.laststandshieldhealth; 
	}
}
function riotshield_check_returned()
{
	if( self.lastActiveWeapon == GetWeapon( "lefthand_shield" ) )
	{
		self.weaponHealth = self.laststandshieldhealth; 
	}
}

function player_watch_melee_charge()
{
	self endon ( "death" );
	
	while( true )
	{
		self waittill( "weapon_melee_charge", weapon );//TODO - fires too late to be used
		
		if( weapon == GetWeapon( "lefthand_shield" ) )
		{
			self.is_charged_riotshield = true;
			wait ( weapon.meleechargetime );
			self.is_charged_riotshield = undefined;
		}
	}
}

function override_player_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	if( weapon == GetWeapon( "shotgun_pump_taser" ) )//TODO do nothing until we get a design pass on this
	{
		//visionset_mgr::activate( "overlay", "shotgun_electric", self, 1.25, 1.25 );
		//self ShellShock("electrocution", 2.5);
		//self ShellShock( "emp_shock", 1 );
	}
	
	return iDamage;
}
