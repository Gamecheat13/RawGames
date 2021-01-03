
#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\weapons\grapple;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_devgui;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_powerup_beast_mana;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;


#using scripts\zm\_zm_altbody;

	

































	


//#define BEAST_FX_OOZE_EXPLODE			"zombie/fx_bmode_ooze_explo_bounce_zmb"
//#define BEAST_FX_OOZE_PUDDLE			"zombie/fx_bmode_ooze_decal_fume_zmb"












//#define BEAST_WEAPON_OOZE				BEAST_WEAPON_OOZE_GRENADE




//#define BEAST_WEAPON_GRAPPLE			BEAST_WEAPON_GRAPPLE_PRIMARY










#precache( "fx", "zombie/fx_bmode_transition_zmb" );
#precache( "fx", "zombie/fx_bmode_transition_zmb" );
//#precache( "fx", BEAST_FX_OOZE_EXPLODE );
//#precache( "fx", BEAST_FX_OOZE_PUDDLE );
#precache( "fx", "zombie/fx_tesla_shock_zmb" );
#precache( "fx", "zombie/fx_bmode_bolt_impact_zod_zmb" );
#precache( "fx", "zombie/fx_bmode_attack_grapple_zod_zmb" );
#precache( "fx", "zombie/fx_bmode_attack_grapple_zod_zmb" );
	
#namespace zm_altbody_beast;

function autoexec __init__sytem__() {     system::register("zm_altbody_beast",&__init__,&__main__,undefined);    }

function __init__()
{
	clientfield::register( "missile", "bminteract", 1, 1, "int" );
	clientfield::register( "scriptmover", "bminteract", 1, 1, "int" );
	clientfield::register( "scriptmover", "bm_players_allowed", 1, 4, "int" );
	
	grapple = GetWeapon("zombie_beast_grapple_dwr");
	loadout = array("zombie_beast_grapple_dwr", "zombie_beast_melee", "zombie_beast_lightning_dwl" ); 
	if ( grapple.isgrenadeweapon )
	{
		loadout = array("zombie_beast_melee", "zombie_beast_grapple_dwr", "zombie_beast_lightning_dwl" ); 
	}
	if ( grapple.isdualwield )
	{
		loadout = array("zombie_beast_grapple_dwr", "zombie_beast_melee", "zombie_beast_lightning_dwl" ); 
	}
	loadout = array("zombie_beast_grapple_dwr", "zombie_beast_lightning_dwl" ); 
	
	beastmode_loadout = zm_weapons::create_loadout( loadout );
	
	zm_altbody::init( "beast_mode", 
	                 "trig_beast_mode_kiosk", 
	                 &"ZM_ZOD_ENTER_BEAST_MODE", 
	                 "zombie_beast", 
	                 123, 
					 beastmode_loadout,
	                 "c_zom_test_beastmode_fb", 
	                 "c_zom_beastmode_test_viewarms", 
					 &player_enter_beastmode,
					 &player_exit_beastmode, 
					 &player_allow_beastmode,
					 "trig_beast_mode_kiosk_unavailable",
					 &"ZM_ZOD_CANT_ENTER_BEAST_MODE" );
	
	callback::on_spawned( &player_on_spawned );
	callback::on_player_killed( &player_on_killed);

	level._effect["human_disappears"] 		= "zombie/fx_bmode_transition_zmb";
	level._effect["zombie_disappears"] 		= "zombie/fx_bmode_transition_zmb";
	//level._effect["ooze_explode"]	= BEAST_FX_OOZE_EXPLODE;
	//level._effect["ooze_splatter"]		= BEAST_FX_OOZE_PUDDLE;
	level._effect["beast_shock"]			= "zombie/fx_tesla_shock_zmb";
	level._effect["beast_shock_box"]		= "zombie/fx_bmode_bolt_impact_zod_zmb";
	level._effect["beast_melee_kill"] 		= "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_grapple_kill"] 	= "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_return_aoe"]		= "zombie/fx_bmode_attack_grapple_zod_zmb";
	level._effect["beast_return_aoe_kill"]	= "zombie/fx_bmode_attack_grapple_zod_zmb";

	level.grapple_valid_target_check = &grapple_valid_target_check;
	level.get_grapple_targets = &get_grapple_targets;

	zm_spawner::register_zombie_damage_callback( &lightning_zombie_damage_response );
	zm_spawner::register_zombie_death_event_callback( &beast_mode_death_watch );
	
	/#
		thread beastmode_devgui(); 
		//SetDvar( "scr_debugOoze", 1 );
	#/
	
}

function __main__()
{
	thread watch_round_start_mana();
	thread hide_ooze_triggers();
	thread kiosk_cooldown();
	
	zm_spawner::add_custom_zombie_spawn_logic( &zombie_on_spawn );
}

function player_cover_transition( extra_time = 0 )
{
	self thread hud::fade_to_black_for_x_sec( 0, 0.15 + extra_time , 0.05, 0.10 );
	wait 0.1;
}

function player_disappear_in_flash(washuman)
{
	if (washuman)
		PlayFX( level._effect[ "human_disappears" ], self.origin );
	else
	{
		PlayFX( level._effect[ "zombie_disappears" ], self.origin );
		playsoundatposition( "zmb_player_disapparate", self.origin );
	}
	
	self ghost();
}


function player_enter_beastmode( name, trigger )
{
	assert( !( isdefined( self.beastmode ) && self.beastmode ) );

	self notify( "clear_red_flashing_overlay" );

	self player_give_mana( 1.0 );
	self player_take_lives( 1 );
	
	self.beast_mode_return_origin = self.origin;
	self.beast_mode_return_angles = self.angles;
	
	self thread player_cover_transition();
	
	self playsound( "evt_beastmode_enter" );
	
	self player_disappear_in_flash(true);

	self.overridePlayerDamage_original = self.overridePlayerDamage; 
	self.overridePlayerDamage = &player_damage_override_beast_mode; 
	self.get_revive_time = &player_get_revive_time; 
	
	self.ignoreme = 1;
	self.beastmode = 1;
	self.inhibit_scoring_from_zombies = 1;
	
	self AllowStand( 1 );
	self AllowProne( 0 );
	self AllowCrouch( 0 );
	self AllowAds( 0 );
	self AllowJump( 1 );
	//self AllowDoubleJump( 1 );
	self AllowSlide( 0 );
	self DisableWeaponCycling();
	
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );
	
	self player_update_beast_mode_objects( true );
	
	self zm_utility::increment_is_drinking();
	self EnableOffhandWeapons();
	
	self StopShellShock();

	self SetPerk( "specialty_playeriszombie" );
	self SetPerk( "specialty_unlimitedsprint" );
	self SetPerk( "specialty_fallheight" );
	self SetPerk( "specialty_lowgravity" );
	
	wait 0.1;
	
	self Show();
	
	self thread player_watch_melee();
	self thread player_watch_melee_juke();
	self thread player_watch_melee_power();
	self thread player_watch_melee_charge();
	self thread player_watch_lightning();
	self thread player_watch_grapple();
	self thread player_watch_grappled_zombies();
	self thread player_watch_grappled_object();
	self thread player_kill_grappled_zombies();
	self thread player_watch_grapple_traverse();
	self thread player_watch_cancel();
}



function player_exit_beastmode( name, trigger )
{
	assert( ( isdefined( self.beastmode ) && self.beastmode ) );
	
	self notify( "clear_red_flashing_overlay" );
	
	self thread player_cover_transition( 0 );
	
	self player_disappear_in_flash( false );
	
	self player_update_beast_mode_objects( false );

	if ( self IsThrowingGrenade() )
	{
		self ForceGrenadeThrow();
	}

	if ( 0 > 0.0 )
		wait 0;
		
	self notify( "player_exit_beastmode" );
	
	self zm_utility::decrement_is_drinking();
	self thread wait_invulnerable( 2 ); 
	self thread wait_enable_offhand_weapons( 3 ); 

	while ( self IsThrowingGrenade() || self IsGrappling() )
	{
		{wait(.05);};
	}
	
	self unsetPerk( "specialty_playeriszombie" );
	self unsetPerk( "specialty_unlimitedsprint" );
	self unsetPerk( "specialty_fallheight" );
	self unsetPerk( "specialty_lowgravity" );

	self setMoveSpeedScale( 1.0 );
	
	self EnableWeaponCycling();
	self AllowStand( 1 );
	self AllowProne( 1 );
	self AllowCrouch( 1 );
	self AllowAds( 1 );
	self AllowJump( 1 );
	self AllowDoubleJump( 0 );
	self AllowSlide( 1 );

	self StopShellShock();

	self.inhibit_scoring_from_zombies = 0;
	self.beastmode = 0;

	self.get_revive_time = undefined; 
	self.overridePlayerDamage = self.overridePlayerDamage_original; 
	self.overridePlayerDamage_original = undefined; 
	
	self thread wait_and_appear();
}

function wait_and_appear()
{
	self SetOrigin( self.beast_mode_return_origin );
	self FreezeControls( true );
	
	v_return_pos = self.beast_mode_return_origin + ( 0, 0, 60 );
			
	a_ai = GetAIArray();
	a_closest = [];
	ai_closest = undefined;
	
	if ( a_ai.size )
	{
		// face the closest zombie
		a_closest = ArraySortClosest( a_ai, self.beast_mode_return_origin );
		
		foreach ( ai in a_closest )
		{
			n_trace_val = ai SightConeTrace( v_return_pos, self );
			
			if ( n_trace_val > .2 )
			{
				ai_closest = ai;
				break;
			}
		}
		
		if ( isdefined( ai_closest ) )
		{
			self SetPlayerAngles( VectorToAngles( ai_closest GetCentroid() - v_return_pos ) );
		}
	}
	
	if ( !isdefined( ai_closest ) )
	{
		self SetPlayerAngles( self.beast_mode_return_angles );
	}
	
	wait ( 0 + .5 ); // short time after teleporting to play FX
	
	self Show();
	self PlaySound( "evt_beastmode_exit" );
	
	PlayFX( level._effect[ "human_disappears" ], self.beast_mode_return_origin );
	PlayFX( level._effect[ "beast_return_aoe" ], self.beast_mode_return_origin );
	
	a_ai = GetAIArray();
	a_aoe_ai = ArraySortClosest( a_ai, self.beast_mode_return_origin, a_ai.size, 0, 400 );
	foreach ( ai in a_aoe_ai )
	{
		if ( IsActor( ai ) )
		{
			PlayFX( level._effect[ "beast_return_aoe_kill" ], ai GetTagOrigin( "j_spineupper" ) );
			ai Delete();
		}
	}
	
	wait .2;
		
	self FreezeControls( false );
	
	wait 3;
	
	self.ignoreme = false;
}

function wait_invulnerable( time ) 
{
	was_inv = self EnableInvulnerability();
	wait time;
	if (IsDefined(self) && !( isdefined( was_inv ) && was_inv ))
		self DisableInvulnerability();
}

function wait_enable_offhand_weapons( time ) 
{
	self DisableOffhandWeapons();
	wait time;
	if (IsDefined(self))
		self EnableOffhandWeapons();
	if ( ( isdefined( self.beast_grenades_missed ) && self.beast_grenades_missed ) )
	{
		lethal_grenade = self zm_utility::get_player_lethal_grenade();
		if( !self HasWeapon( lethal_grenade ) )
		{
			self GiveWeapon( lethal_grenade );	
			self SetWeaponAmmoClip( lethal_grenade, 0 );
		}

		frac = self GetFractionMaxAmmo( lethal_grenade );
		if ( frac < .25 )
		{
			self SetWeaponAmmoClip( lethal_grenade, 2 );
		}
		else if ( frac < .5 )
		{
			self SetWeaponAmmoClip( lethal_grenade, 3 );
		}
		else
		{
			self SetWeaponAmmoClip( lethal_grenade, 4 );
		}
	}
	self.beast_grenades_missed = false;
	
}

function player_allow_beastmode( name, kiosk )
{
	if ( !level flagsys::get( "start_zombie_round_logic" ) )
	{
		return false; 
	}
	
	if ( ( isdefined( self.beastmode ) && self.beastmode ) )
	{
		return false; 
	}
	
	if ( isdefined( kiosk ) && !kiosk_allowed( kiosk ) )
	{
		return false;
	}
	
	return ( self.beastlives >= 1 ); 
}

function kiosk_allowed( kiosk )
{
	return ( !( isdefined( kiosk.is_cooling_down ) && kiosk.is_cooling_down ) );
}

function player_on_spawned()
{
	level flag::wait_till( "initial_players_connected" );
	
	self.beastmana = 1.0;
	
	if ( level flag::get( "solo_game" ) )
		self.beastlives = 3;
	else
		self.beastlives = 1;
	
	self thread update_kiosk_effects();
	
	self thread player_watch_mana();
	self player_update_beast_mode_objects( false );
}

function update_kiosk_effects()
{
	self endon( "death" );
	
	a_kiosks = GetEntArray( "beast_mode_kiosk", "script_noteworthy" );
	
	while ( true )
	{
 		n_ent_num = self GetEntityNumber();
 		
		foreach ( kiosk in a_kiosks )
		{
			n_players_allowed = kiosk clientfield::get( "bm_players_allowed" );
				
			if ( kiosk_allowed( kiosk ) )
			{
				// Set bit representing this player
				n_players_allowed |= ( 1 << n_ent_num );
			}
			else
			{
				// Clear bit representing this player
				n_players_allowed &= ~( 1 << n_ent_num );
			}
			
			kiosk clientfield::set( "bm_players_allowed", n_players_allowed );
		}
		
		{wait(.05);};
	}
}

function kiosk_cooldown()
{
	while ( true )
	{
		level waittill( "kiosk_used", e_kiosk );
		e_kiosk thread _kiosk_cooldown();
	}
}

function _kiosk_cooldown()
{
	self endon( "death" );
	
	self.is_cooling_down = true;
	
	n_start_round = level.round_number;
	while ( level.round_number - n_start_round < 1 )
	{
		level waittill( "start_of_round" );
	}
	
	self.is_cooling_down = false;
}

function player_watch_cancel()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );

	if (!( isdefined( self.beast_cancel_shown ) && self.beast_cancel_shown ) )
	{
		self thread beast_cancel_hint();
	}
	self.beast_cancel_timer = 0; 
	while(IsDefined(self))
	{
		if ( self StanceButtonPressed() )
		{
			self notify("hide_equipment_hint_text");
			self player_stance_hold_think();
		}
		{wait(.05);};
	}
}



function beast_cancel_hint()
{
	hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT";
	/#	
		primary = level.altbody_loadouts["beast_mode"].current;
		if ( !( isdefined( primary.grappleWeapon ) && primary.grappleWeapon ) )
		{
			hint = "Press [{+smoke}] to grapple\nPress [{+frag}] to shoot ooze\nPress [{+melee}] or [{+attack}] to melee\nHold [{+stance}] to Exit Beast Mode";
		}
		else if ( primary.isdualwield )
		{
			hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT_DW";
		}
		else
		{
			hint = &"ZM_ZOD_EXIT_BEAST_MODE_HINT";
		}
	#/		

	self.beast_cancel_shown=1;
	zm_equipment::show_hint_text( hint, 5 );
}




function player_stance_hold_think()
{
	self thread player_stance_hold_think_internal();
	retval = self util::waittill_any_return("exit_succeed","exit_failed");
	if ( retval == "exit_succeed")
	{
		self notify("altbody_end"); 
		return true;
	}
	self.beast_cancel_timer = 0; 
	return false;
}
	
function player_continue_cancel()
{
	if( self isThrowingGrenade() )
		return false;
	if (!self StanceButtonPressed())
		return false;
	return true;
}

function player_stance_hold_think_internal()
{
	{wait(.05);};
	if (!isdefined(self))
	{
		self notify("exit_failed");
		return;
	}
	self.beast_cancel_timer = GetTime();
	build_time = 1.0 * 1000.0;
	
	self thread player_beast_cancel_bar( self.beast_cancel_timer, build_time );
	
	while( isdefined(self) && self player_continue_cancel() && getTime()-self.beast_cancel_timer < build_time )
	{
		{wait(.05);};
	}

	if ( isdefined(self) && self player_continue_cancel() && getTime()-self.beast_cancel_timer >= build_time )
	{
		self notify("exit_succeed");
	}
	else
	{
		self notify("exit_failed");
	}
}
	
function player_beast_cancel_bar( start_time, build_time )
{
	self.useBar = self hud::createPrimaryProgressBar();
	self.useBarText = self hud::createPrimaryProgressBarText();
	self.useBarText setText( &"ZM_ZOD_EXIT_BEAST_MODE" );

	self player_progress_bar_update( start_time, build_time );
	
	self.useBarText hud::destroyElem();
	self.useBar hud::destroyElem();
	
}

function player_progress_bar_update( start_time, build_time )
{
	self endon("death");
	self endon("disconnect");
	self endon("player_exit_beastmode");
	self endon("exit_failed");
	
	while ( IsDefined(self) && getTime()-start_time < build_time )
	{
		progress = (getTime()-start_time) / build_time;
		if (progress < 0)
			progress = 0;
		if (progress > 1)
			progress = 1;
		self.useBar hud::updateBar( progress );
		{wait(.05);}; 
	}
}

function player_take_mana( mana )
{
	self.beastmana -= mana;
	if ( self.beastmana <= 0.0 )
	{
		self.beastmana = 0.0;  
		self notify("altbody_end"); 
	}
}
	
function player_give_lives( lives )
{
	self.beastlives += lives;
	
	if ( level flag::get( "solo_game" ) )
	{
		if (self.beastlives > 3) {     self.beastlives = 3;    };
	}
	else
	{
		if (self.beastlives > 1) {     self.beastlives = 1;    };
	}
}

function player_take_lives( lives )
{
	self.beastlives -= lives;
	if ( self.beastmana <= 0 )
	{
		self.beastlives = 0;  
	}
}
	
function player_give_mana( mana )
{
	self.beastmana += mana;
	if ( self.beastmana > 1.0 )
	{
		self.beastmana = 1.0;  
	}
}

function player_get_revive_time( player_being_revived ) 
{
	return 0.75;
}


function player_damage_override_beast_mode( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	if ( IsDefined(eAttacker) && ( ( isdefined( eAttacker.is_zombie ) && eAttacker.is_zombie ) || eAttacker == self ) )
	{
		return 0;
	}
	
	//iDamage = self check_player_damage_callbacks( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime );

	// ignore anything less that fatal damage amounts
	if ( iDamage < self.health )
	{
		return 0;
	}
	
	self notify("altbody_end"); 
	self player_take_mana( 1.0 );
	
	return 0;
}


function player_check_grenades()
{
	if ( ( isdefined( self.beastmode ) && self.beastmode ) )
	{
		self.beast_grenades_missed = true;
	}
}

function watch_round_start_mana()
{
	level waittill( "start_of_round" ); // skip the first round
	foreach( player in GetPlayers() )
	{
		player player_check_grenades();
	}
	while ( 1 )
	{
		level waittill( "start_of_round" );
		foreach( player in GetPlayers() )
		{
			if ( !( isdefined( player.beastmode ) && player.beastmode ) )
				player player_give_mana( 1.0 );
			player player_give_lives( 1 );
			player player_check_grenades();
		}
	}
}




	
function player_watch_mana()
{
	self notify("player_watch_mana");
	self endon("player_watch_mana");
	while ( IsDefined( self ) )
	{
		if ( ( isdefined( self.beastmode ) && self.beastmode ) )
		{
			self player_take_mana( ( ( 1.0 - 0.0 ) / ( 20.0 * 25 ) ) );
		}
		
		n_mapped_mana = math::linear_map( self.beastmana, 0.0, 1.0, 0, 1 );
		self clientfield::set_to_player( "player_afterlife_mana", n_mapped_mana );
		
		lives = self.beastlives; 
		if ( lives != self clientfield::get_to_player( "player_lives" ) )
		{
			player_give_lives( 0 );
			lives = self.beastlives; 
			self clientfield::set_to_player( "player_lives", lives );
		}

		{wait(.05);};
	}
}

function player_on_killed()
{
	self notify("altbody_end"); 
	self player_take_mana( 1.0 );
}


function hide_ooze_triggers()
{
	level flagsys::wait_till( "start_zombie_round_logic" ); 
	
	ooo = GetEntArray( "ooze_only", "script_noteworthy" );
	array::thread_all( ooo, &trigger_ooze_only );
	moo = GetEntArray( "beast_melee_only", "script_noteworthy" );
	array::thread_all( moo, &trigger_melee_only );
	goo = GetEntArray( "beast_grapple_only", "script_noteworthy" );
	array::thread_all( goo, &trigger_grapple_only );
}

function player_update_beast_mode_objects( onOff )
{
	bmo = GetEntArray( "beast_mode", "script_noteworthy" );
	if ( IsDefined(	level.get_beast_mode_objects ) ) 
	{
		more_bmo = [[level.get_beast_mode_objects]]();
		bmo = ArrayCombine( bmo, more_bmo, false, false );
	}
	array::run_all( bmo, &entity_set_visible, self, onOff );
	bmho = GetEntArray( "not_beast_mode", "script_noteworthy" );
	if ( IsDefined(	level.get_beast_mode_hide_objects ) ) 
	{
		more_bmho = [[level.get_beast_mode_hide_objects]]();
		bmho = ArrayCombine( bmho, more_bmho, false, false );
	}
	array::run_all( bmho, &entity_set_visible, self, !onOff );
}

function entity_set_visible( player, onOff )
{
	if ( onOff )
		self SetVisibleToPlayer( player );
	else
		self SetInvisibleToPlayer( player );
}






	
function player_watch_melee_charge()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );
	
	while( IsDefined(self) )
	{
		self waittill( "weapon_melee_charge", weapon );
		self notify( "weapon_melee", weapon );
	}
}

function player_watch_melee_power()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );
	
	while( IsDefined(self) )
	{
		self waittill( "weapon_melee_power", weapon );
		self notify( "weapon_melee", weapon );
	}
}




function player_watch_melee()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );
	
	while( IsDefined(self) )
	{
		//self waittill ( "weapon_fired", weapon );
		self waittill ( "weapon_melee", weapon );
		/#
			{
			    weapon = GetWeapon("zombie_beast_grapple_dwr");
			}
		#/
		if ( weapon == GetWeapon("zombie_beast_melee") || weapon == GetWeapon("zombie_beast_grapple_dwr") )
		{
			level notify( "beast_melee", self );
			self player_take_mana( 0.03 );
			forward = AnglesToForward(self GetPlayerAngles());
			up = AnglesToUp(self GetPlayerAngles());
			self RadiusDamage( self.origin + (15 * up) + (24 * forward), (12*3), 5000, 5000, self, "MOD_MELEE" );
		}
	}
}


function player_watch_melee_juke() // self == player
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );
	
	while( IsDefined(self) )
	{
		self waittill( "weapon_melee_juke", weapon );
		if ( weapon == GetWeapon("zombie_beast_melee") || weapon == GetWeapon("zombie_beast_grapple_dwr") )
		{
			player_beast_melee_juke(weapon);
		}
	}
}

function player_beast_melee_juke(weapon)
{
	self endon( "weapon_melee" );
	self endon( "weapon_melee_power" );
	self endon( "weapon_melee_charge" );
	
	start_time = GetTime(); 

	while( start_time + 3000 > GetTime() )
	{
		self PlayRumbleOnEntity( "zod_beast_juke" );
		wait 0.1;
	}
}




function trigger_melee_only()
{
	self endon("death");
	
	level flagsys::wait_till( "start_zombie_round_logic" ); 

	if (IsDefined(self.target))
	{
		target = GetEnt( self.target, "targetname" );
		if ( IsDefined( target) )
		{
			target EnableAimAssist();	
		}
	}
	
	//self EnableAimAssist();	
	self SetInvisibleToAll();
	while( IsDefined( self ) )
	{
		level waittill( "beast_melee", player );
		if ( IsDefined(self) && player IsTouching(self) )
		{
			self UseBy( player );
		}
	}
}

function player_watch_lightning()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );
	
	while( IsDefined(self) )
	{
		self waittill ( "weapon_fired", weapon );
		/#
			{
			    weapon = GetWeapon("zombie_beast_lightning_dwl");
			}
		#/
		if ( weapon == GetWeapon("zombie_beast_lightning_dwl") )
		{
			self player_take_mana( 0.0 );

		}
	}
}

function get_grapple_targets()
{
	if(!isdefined(level.beast_mode_targets))level.beast_mode_targets=[]; 
	return level.beast_mode_targets; 
}

function trigger_grapple_only()
{
	self endon("death");
	
	level flagsys::wait_till( "start_zombie_round_logic" ); 

	/*
	grapple_target = undefined;
	if(isdefined(self.target))
	{
		grapple_target = GetEnt(self.target, "targetname");
		if (IsDefined(grapple_target))
		{
			grapple_target SetGrapplableType( GRAPPLE_TYPE_TARGETONLY );
			array::add( level.beast_mode_targets, grapple_target, false );
		}
	}
	*/
	
	self SetInvisibleToAll();
	while( IsDefined( self ) )
	{
		level waittill( "grapple_hit", target, player );
		/*
		if ( IsDefined(	grapple_target ) )
		{
			if ( IsDefined(self) && target == grapple_target )
			{
				self UseBy( player );
			}
		}
		else
		*/
		{
			if ( IsDefined(self) && target IsTouching(self) )
			{
				self UseBy( player );
			}
		}
	}
}


function player_watch_grapple()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );

	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while( IsDefined(self) )
	{
		self waittill ( "grapple_fired", weapon );
		/#
			{
			    weapon = grapple;
			}
		#/
		if ( weapon == grapple )
		{
			if ( IsDefined(self.pivotentity) && !IsPlayer(self.pivotentity) )
			{
				//self.pivotentity clientfield::set("bminteract",1);
			}
	
			self player_take_mana( 0.0 );
		}
	}
}

function grapple_valid_target_check( ent ) 
{
	if( !IsVehicle( ent ) )
		if ( ( isdefined( ent.is_zombie ) && ent.is_zombie ) )
		{
			if ( !( isdefined( ent.completed_emerging_into_playable_area ) && ent.completed_emerging_into_playable_area ) )
			{
				return false;
			}
		}
	return true;
}

function zombie_on_spawn()
{
	self endon("death");
	self SetGrapplableType( 0 );
	if( !IsVehicle( self ) )
	{
		self waittill( "completed_emerging_into_playable_area" );
	}
	if (!IsDefined(self))
		return;
	self SetGrapplableType( 2 );
}


function player_watch_grappled_object()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );

	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while( IsDefined(self) )
	{
		self waittill ( "grapple_stick", weapon, target );
		/#
			{
			    weapon = grapple;
			}
		#/
		if ( weapon == grapple )
		{
			if ( IsDefined(self.pivotentity) && !IsPlayer(self.pivotentity) )
			{
				//self.pivotentity clientfield::set("bminteract",0);
			}
			level notify( "grapple_hit", target, self );
			playsoundatposition( "wpn_beastmode_grapple_imp", target.origin );
		}
	}
}

function player_watch_grapple_traverse()
{
	self endon( "player_exit_beastmode" );
	self endon( "death" );

	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while( IsDefined(self) )
	{
		self waittill ( "grapple_reelin", weapon, target );
		/#
			{
			    weapon = grapple;
			}
		#/
		if ( weapon == grapple )
		{
			origin = target.origin; 
			self thread player_watch_grapple_landing(origin);
			self playsound( "wpn_beastmode_grapple_pullin" );
		}
	}
}




function player_watch_grapple_landing( origin )
{
	self endon( "player_exit_beastmode" );
	self endon( "death" );
	self notify( "player_watch_grapple_landing" );
	self endon( "player_watch_grapple_landing" );

	self waittill ( "grapple_landed", weapon, target );
	if (Distance2DSquared(self.origin,origin) > ( 32 * 32 ) )
	{
		//self ForceTeleport(origin);
		self SetOrigin(origin + ( 0, 0, -60 ));
	}
}



function player_watch_grappled_zombies()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );

	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while( IsDefined(self) )
	{
		self waittill ( "grapple_pullin", weapon, target );
		/#
			{
			    weapon = grapple;
			}
		#/
		if ( weapon == grapple )
		{
			if ( IsDefined(target) && ( isdefined( target.is_zombie ) && target.is_zombie ) )
			{
				target zombie_gets_pulled( self );
			}
		}
	}
}

function player_kill_grappled_zombies()
{
	self endon( "player_exit_beastmode" );
	self endon ( "death" );

	grapple = GetWeapon("zombie_beast_grapple_dwr");
	while( IsDefined(self) )
	{
		self waittill ( "grapple_pulled", weapon, target );
		/#
			{
			    weapon = grapple;
			}
		#/
		if ( weapon == grapple )
		{
			if ( IsDefined(target) && ( isdefined( target.is_zombie ) && target.is_zombie ) )
			{
				target thread zombie_gets_eaten( self );
			}
		}
	}
}

function zombie_gets_pulled( player )
{
	/*
	if( level.round_number >= 15 && RandomInt(20) < level.round_number-15 )
	{
		self.grapple_is_fatal = false;
	}
	else
	{
		self.grapple_is_fatal = true;
		// we should put these guys in ragdoll, but that interferes with pulling them
		//self StartRagdoll();
	    //self SetPlayerCollision(0);	
	}
	*/
	// just kill them all - the player isn't getting credit for them
	self.grapple_is_fatal = true;

}

function zombie_gets_eaten( player )
{
	wait 0.15;
	if ( IsDefined(self) )
	{
		if ( !( isdefined( self.grapple_is_fatal ) && self.grapple_is_fatal ) )
		{
			self DoDamage( 1000, player.origin, player );
		}
		else
		{
			self DoDamage( self.health + 1000, player.origin, player );
			if( !IsVehicle( self ) )
			{
				//self zombie_utility::zombie_gut_explosion();
				self.marked_for_recycle = 1;
				self StartRagdoll();
			}
		}
	}

}

function lightning_zombie_damage_response( mod, hit_location, hit_origin, player, amount, weapon )
{
	if ( ( weapon === GetWeapon("zombie_beast_lightning_dwl") ) )
	{
		if ( amount > 0 )
			player thread lightning_slow_zombie( self );
		return true;
	}
	if ( ( weapon === GetWeapon("zombie_beast_grapple_dwr") ) )
	{
		if ( amount > 0 && IsDefined(player) )
		{
			player PlayRumbleOnEntity( "damage_heavy" );
			Earthquake( 1.0, 0.75, player.origin, 100 );
		}
		return true;
	}
	return false;
}

function watch_lightning_damage( triggers )
{
	self endon ( "delete" );
	self SetCanDamage( true );

	while ( true )
	{
		self waittill ( "damage", amount, attacker, direction, point, mod, tagName, modelName, partName, weapon );
		if ( ( weapon === GetWeapon("zombie_beast_lightning_dwl") ) && IsDefined(attacker) && amount > 0 )
		{
			if( IsDefined( level._effect[ "beast_shock_box" ] ) )
			{
				Playfx(level._effect["beast_shock_box"], self.origin);
			}
			if ( IsArray(triggers) )
			{
				foreach( trigger in triggers )
				{
					if ( IsDefined(trigger) )
						trigger UseBy( attacker );
				}
			}
			else
			{
				triggers UseBy( attacker );
			}
		}
	}
}


function beast_mode_death_watch()
{
	if ( ( self.damageweapon === GetWeapon("zombie_beast_lightning_dwl") ) )
	{
		self.marked_for_recycle = 1;
	}
	if ( ( self.damageweapon === GetWeapon("zombie_beast_grapple_dwr") ) )
	{
		self.marked_for_recycle = 1;
		if ( ( self.damagemod === "MOD_MELEE" ) )
		{
			player = self.attacker; 
			if ( IsDefined(player) )
			{
				player PlayRumbleOnEntity( "damage_heavy" );
				Earthquake( 1.0, 0.75, player.origin, 100 );
			}
			self Ghost();
			playfxontag( level._effect["beast_melee_kill"] , self , "j_spineupper" );
		}
		else
		{
			player = self.attacker; 
			if ( IsDefined(player) )
			{
				player PlayRumbleOnEntity( "damage_heavy" );
				Earthquake( 1.0, 0.75, player.origin, 100 );
			}
			self Ghost();
			playfxontag( level._effect["beast_grapple_kill"] , self , "j_spineupper" );
		}
	}
}

function trigger_ooze_only()
{
	self endon("death");
	
	level flagsys::wait_till( "start_zombie_round_logic" ); 

	/*
	if (IsDefined(self.target))
	{
		target = GetEnt( self.target, "targetname" );
		if ( IsDefined( target) )
		{
			target thread watch_lightning_damage( self );
		}
	}
	*/
	
	self SetInvisibleToAll();
	while( IsDefined( self ) )
	{
		level waittill( "ooze_detonate", grenade, player );
		if ( IsDefined(self) && IsDefined(grenade) && grenade IsTouching(self) )
		{
			self UseBy( player );
		}
	}
}

function zombie_can_stick()
{
	if( ( isdefined( self.barricade_enter ) && self.barricade_enter ) )
	{
		return false;
	}
	
	if ( ( isdefined( self.is_traversing ) && self.is_traversing ) )
	{
		return false;
	}

	if( !( isdefined( self.completed_emerging_into_playable_area ) && self.completed_emerging_into_playable_area ) && !IsDefined( self.first_node ) )
	{
		return false;
	}

	if ( ( isdefined( self.is_leaping ) && self.is_leaping ) )
	{
		return false;
	}
	
	return true;
}
	









function lightning_slow_zombie( zombie )
{
	zombie endon("death");
	zombie notify("lightning_slow_zombie");
	zombie endon("lightning_slow_zombie");
	if ( !zombie zombie_can_stick() )
		return;
	num = zombie GetEntityNumber();
	if(!isdefined(zombie.beast_slow_count))zombie.beast_slow_count=0; 
	zombie.beast_slow_count++; 
	//zombie zombie_set_stuck(zombie.beast_slow_count > 0); 
	
	if(!isdefined(zombie.animation_rate))zombie.animation_rate=1.0; 

	zombie.slow_time_left = 8;

	zombie thread lightning_slow_zombie_fx( zombie );
	
	while( IsDefined(zombie) && isalive( zombie ) && zombie.animation_rate > 0.03 )
	{
		zombie.animation_rate -= ( (1.0-0.03) * (.05/1) ); 
		if (zombie.animation_rate < 0.03) {     zombie.animation_rate = 0.03;    };
		zombie ASMSetAnimationRate( zombie.animation_rate );
		zombie.slow_time_left -= .05; 
		{wait(.05);}; 
	}

	while( IsDefined(zombie) && isalive( zombie ) && zombie.slow_time_left > 0.5 )
	{
		zombie.slow_time_left -= .05; 
		{wait(.05);}; 
	}
	
	while( IsDefined(zombie) && isalive( zombie ) && zombie.animation_rate < 1.0 )
	{
		zombie.animation_rate += ( (1.0-0.03) * (.05/0.5) ); 
		if (zombie.animation_rate > 1.0) {     zombie.animation_rate = 1.0;    };
		zombie ASMSetAnimationRate( zombie.animation_rate );
		zombie.slow_time_left -= .05; 
		{wait(.05);}; 
	}

	zombie ASMSetAnimationRate( 1.0 );
	zombie.slow_time_left = 0; 
	
	if ( IsDefined(zombie) )
	{
		zombie.beast_slow_count--; 
		//zombie zombie_set_stuck(zombie.beast_slow_count > 0); 
	}
}

function lightning_slow_zombie_fx( zombie )
{
	tag = "J_SpineUpper";
	fx = "beast_shock";

	if ( ( isdefined( zombie.isdog ) && zombie.isdog ) )
	{
		tag = "J_Spine1";
	}

	while( IsDefined(zombie) && isalive( zombie ) && zombie.slow_time_left > 0 )
	{
		zombie zm_net::network_safe_play_fx_on_tag( "beast_slow_fx", 2, level._effect[fx], zombie, tag );
		wait 1;
	}
}



/#
function beastmode_devgui()
{
	level flagsys::wait_till( "start_zombie_round_logic" ); 

	wait 1;
	
	zm_devgui::add_custom_devgui_callback( &beastmode_devgui_callback );
	
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Beast Mode/Toggle Beast Mode:1\" \"zombie_devgui beast\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Beast Mode/Preserve Beast Mode:2\" \"zombie_devgui beastpreserve\" \n");

	AddDebugCommand( "devgui_cmd \"ZM/Power Ups/Now/Drop Beast Mana\" \"zombie_devgui beast_mana\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Power Ups/Zombie/Drop Beast Mana\" \"zombie_devgui next_beast_mana\" \n");

	AddDebugCommand( "devgui_cmd \"ZM/Zod/Beast Mode/Switch Control Scheme:10\" \"zombie_devgui beast_loadout\" \n");
	AddDebugCommand( "devgui_cmd \"ZM/Zod/Open Super Sesame\" \"zombie_devgui super_sesame\" \n");

	players = GetPlayers();
	for ( i=0; i<players.size; i++ )
	{
		ip1 = i+1;
		AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +players[i].name+ "/Toggle Beast Mode\" \"set zombie_devgui player" +ip1+ "_beast\" \n");
		AddDebugCommand( "devgui_cmd \"ZM/Players:1/" +players[i].name+ "/Preserve Beast Mode\" \"set zombie_devgui player" +ip1+ "_beastpreserve\" \n");
	}
	
	
}

function beastmode_devgui_callback( cmd)
{
	players = GetPlayers();
	retval = false;
	switch ( cmd )
	{
	case "beast_mana":
		zm_devgui::zombie_devgui_give_powerup( cmd, true );
		break;
	case "next_beast_mana":
		zm_devgui::zombie_devgui_give_powerup( GetSubStr( cmd, 5 ), false );
		break;
		
	case "beast_loadout":
		devgui_toggle_beast_loadout();
		break;
		
	case "beast":
		array::thread_all( players, &player_zombie_devgui_beast_mode );
		retval = true;
		break;
		
	case "super_sesame":
		a_trigs = GetEntArray( "ooze_only", "script_noteworthy" );
		foreach( e_trig in a_trigs )
		{
			e_trig UseBy( level.players[0] );
		}
		
		a_trigs = GetEntArray( "beast_melee_only", "script_noteworthy" );
		foreach( e_trig in a_trigs )
		{
			e_trig UseBy( level.players[0] );
		}
		
		zm_devgui::zombie_devgui_open_sesame();
		
		break;
		
	case "player1_beast":
		if ( players.size >= 1 )
			players[0] thread player_zombie_devgui_beast_mode();	
		retval = true;
		break;
	case "player2_beast":
		if ( players.size >= 2 )
			players[1] thread player_zombie_devgui_beast_mode();	
		retval = true;
		break;
	case "player3_beast":
		if ( players.size >= 3 )
			players[2] thread player_zombie_devgui_beast_mode();	
		retval = true;
		break;
	case "player4_beast":
		if ( players.size >= 4 )
			players[3] thread player_zombie_devgui_beast_mode();	
		retval = true;
		break;
		
	case "beastpreserve":
		array::thread_all( players, &player_zombie_devgui_beast_mode_preserve );
		retval = true;
		break;
	case "player1_beastpreserve":
		if ( players.size >= 1 )
			players[0] thread player_zombie_devgui_beast_mode_preserve();	
		retval = true;
		break;
	case "player2_beastpreserve":
		if ( players.size >= 2 )
			players[1] thread player_zombie_devgui_beast_mode_preserve();	
		retval = true;
		break;
	case "player3_beastpreserve":
		if ( players.size >= 3 )
			players[2] thread player_zombie_devgui_beast_mode_preserve();	
		retval = true;
		break;
	case "player4_beastpreserve":
		if ( players.size >= 4 )
			players[3] thread player_zombie_devgui_beast_mode_preserve();	
		retval = true;
		break;
		
	}
	return retval;
}

function devgui_toggle_beast_loadout()
{
	if ( self detect_reentry() )
		return; 
	
	if(!isdefined(level.zombie_beast_loadout))level.zombie_beast_loadout=0;

	level.zombie_beast_loadout = (level.zombie_beast_loadout + 1 ) % 3;
 
	if ( level.zombie_beast_loadout == 0 )
	{

		if ( "zombie_beast_lightning_dwl"	== "zombie_beast_lightning_dwl" )
		{
			loadout = array("zombie_beast_grapple_dwr", "zombie_beast_melee", "zombie_beast_lightning_dwl" );
		}
		else
		{
			loadout = array("zombie_beast_grapple", "zombie_beast_melee", "zombie_beast_ooze" ); 
		}
	}
	else if ( level.zombie_beast_loadout == 1 )
	{
		if ( "zombie_beast_lightning_dwl"	== "zombie_beast_lightning_dwl" )
		{
			loadout = array("zombie_beast_grapple", "zombie_beast_melee", "zombie_beast_ooze" ); 
		}
		else
		{
			loadout = array("zombie_beast_grapple_dwr", "zombie_beast_melee", "zombie_beast_lightning_dwl" );
		}
	}
	else
	{
		loadout = array("zombie_beast_melee", "zombie_beast_grapple_grenade", "zombie_beast_ooze" ); 
	}

	beastmode_loadout = zm_weapons::create_loadout( loadout );

	level.altbody_loadouts["beast_mode"]=beastmode_loadout;
	
	foreach( player in GetPlayers() )
	{
		player notify("altbody_end"); 
		player.beast_cancel_shown=0;
		player player_give_mana( 1.0 );
	}
	
}

function player_zombie_devgui_beast_mode()
{
	if ( self detect_reentry() )
		return; 
	
	if ( !( isdefined( self.beastmode ) && self.beastmode ) )
	{
		PrintLn("DEVGUI: player "+self.name+" placed in beast mode");
		iPrintLnBold("DEVGUI: player "+self.name+" placed in beast mode");
		self player_give_mana( 1.0 );
		self thread zm_altbody::devgui_start_altbody( "beast_mode" ); 
	}
	else
	{
		self notify("altbody_end"); 
	}
}

function detect_reentry()
{
	if (IsDefined(self.devgui_preserve_time))
	{
		if ( self.devgui_preserve_time == GetTime() )
			return true;
	}
	self.devgui_preserve_time = GetTime();
	return false; 
}
	
function player_zombie_devgui_beast_mode_preserve()
{
	if ( self detect_reentry() )
		return; 
	
	self notify("zombie_devgui_beast_mode_preserve");
	self endon("zombie_devgui_beast_mode_preserve");
	
	self.devgui_preserve_beast_mode = !( isdefined( self.devgui_preserve_beast_mode ) && self.devgui_preserve_beast_mode );
	
	PrintLn("DEVGUI: player "+self.name+" beast mode preservation " + ( self.devgui_preserve_beast_mode ? "on" : "off" ));
	iPrintLnBold("DEVGUI: player "+self.name+" beast mode preservation " + ( self.devgui_preserve_beast_mode ? "on" : "off" ));
	if ( self.devgui_preserve_beast_mode )
	{
		while( isDefined(self) )
		{
			self player_give_lives( 3 );
			self player_give_mana( 1.0 );
			{wait(.05);};
		}
	}
}



#/



