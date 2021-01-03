#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

#using scripts\cp\_oed;
#using scripts\cp\_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       







#precache( "material", "t7_hud_prompt_pickup_64" );
#precache( "string", "COOP_AMMO_REFILL" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_HACK_SYSTEM" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_GRAB_SHOTGUN" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_OPEN_GRATE" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_GRAB_WEAPONS" );
#precache( "triggerstring", "Take Weapon" );
#precache( "model", "p7_zm_teddybear" );
#precache( "model", "wpn_t7_smg_ap9_world" );
#precache( "model", "wpn_t7_ar_m8a4_world" );
#precache( "model", "wpn_t7_lmg_ares_world" );
#precache( "model", "wpn_t7_sniper_locus_world" );
#precache( "model", "wpn_t7_pistol_triton_world" );
#precache( "model", "wpn_t7_shotgun_spartan_world" );


function override_ammo_caches()
{	
	level thread _weaponboxzm::init_weaponboxzm_crate_from_ammocrates( "ammo_cache" );
}

function init_weaponboxzm_crate_from_ammocrates_lotus( struct_name )
{
	ammo_cache = GetEnt( struct_name, "targetname" );
	ammo_cache.doublehigh = true;

	e_trigger = GetEnt( "weapon_crate_trigger", "targetname" );
	e_trigger SetInvisibleToAll();

	level thread init_zombie_crate_weapons();
	init_weaponboxzm_crate_internal( ammo_cache );
}

function init_weaponboxzm_crate_from_ammocrates( struct_name )
{
	a_mdl_ammo_cache = GetEntArray( struct_name, "script_noteworthy" );

	level thread init_zombie_crate_weapons();

	foreach ( ammo_cache in a_mdl_ammo_cache )
	{
		init_weaponboxzm_crate_internal( ammo_cache );
	}
}

function init_weaponboxzm_crate_internal( e_visual )
{
	//e_visual = GetEnt( ent_tn, "targetname" );
	e_visual DisconnectPaths();

	//e_trigger = GetEnt( trig_tn, "targetname" );
	e_trigger = Spawn( "trigger_radius_use", e_visual.origin + ( 0, 0, 3 ), 0, 94, 64 );
	e_trigger TriggerIgnoreTeam();
	e_trigger SetVisibleToAll();
	e_trigger SetTeamForTrigger( "none" );
	e_trigger UseTriggerRequireLookAt();
	e_trigger SetCursorHint( "HINT_NOICON" );
	e_trigger.a_players_cooldown = [];
	e_trigger.a_n_players_cooldown = [];

	s_ammo_cache_object = gameobjects::create_use_object( "any", e_trigger, Array( e_visual ), ( 0, 0, 64 ) );

	s_ammo_cache_object gameobjects::allow_use( "any" );
	s_ammo_cache_object gameobjects::set_use_time( 0 );
	s_ammo_cache_object gameobjects::set_use_text( &"COOP_WEAPONSEL_ZM" );
	s_ammo_cache_object gameobjects::set_use_hint_text( &"COOP_WEAPONGRAB_ZM" );
	s_ammo_cache_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_pickup_64" ); //gets in the way
	s_ammo_cache_object gameobjects::set_visible_team( "any" );
	s_ammo_cache_object.onUse = &activate_weapons_crate;
	s_ammo_cache_object.onBeginUse = &give_back_weapons_start; //unused in this case
	s_ammo_cache_object.onEndUse = &give_back_weapons_end; //unused in this case
	s_ammo_cache_object.useWeapon = undefined;
	s_ammo_cache_object.num_pulls = 0;
	s_ammo_cache_object.doublehigh = 0;

	if( isdefined(e_visual.doublehigh) )
	{
		s_ammo_cache_object.doublehigh = 1;
	}

	level flag::wait_till( "all_players_connected" );
	s_ammo_cache_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 42*20, true );
	
	e_weapon_crate = GetEnt( "keyline_crate", "targetname" );
	if( isdefined( e_weapon_crate ) )
	{	
		e_weapon_crate thread oed::enable_keyline( true );
	}				
}

function init_zombie_crate_weapons()
{
	if( !isdefined(level.zombie_crate_weapons) )
	{
		level.zombie_crate_weapons = [];

		level.zombie_crate_weapons[0] = "smg_standard";
		level.zombie_crate_weapons[1] = "ar_standard";
		level.zombie_crate_weapons[2] = "lmg_light";
		level.zombie_crate_weapons[3] = "sniper_powerbolt";
		level.zombie_crate_weapons[4] = "pistol_standard";
		level.zombie_crate_weapons[5] = "shotgun_pump";
		level.zombie_crate_weapons[6] = "smaw";
		level.zombie_crate_weapons[7] = "p7_zm_teddybear"; //keep the teddy as last
	}
}

function get_weapon_model( str_weapon )
{	
	switch ( str_weapon )
	{
		case "smg_standard":
			return "wpn_t7_smg_ap9_world";
			break;
		
		case "ar_standard":
			return "wpn_t7_ar_m8a4_world";
			break;
			
		case "lmg_light":
			return "wpn_t7_lmg_ares_world";
			break;

		case "sniper_powerbolt":
			return "wpn_t7_sniper_locus_world";
			break;
			
		case "pistol_standard":
			return "wpn_t7_pistol_triton_world";
			break;			

		case "shotgun_pump":
			return "wpn_t7_shotgun_spartan_world";
			break;		
			
		case "smaw":
			return "wpn_t7_shotgun_spartan_world";
			break;					

		case "p7_zm_teddybear":
			return "p7_zm_teddybear";
			break;			
			
		default:
			return "wpn_t7_pistol_triton_world";
			break;
	}
}

function give_back_weapons_start( player )
{
}

function give_back_weapons_end( team, player, success )
{
}

function randomize_weapon_selection()
{
	float_height = 20;

	if( self.doublehigh==1 )
		float_height = 40;

	float_time = 5;
	change_time = 0.25;
	self.e_weapon = util::spawn_model( "wpn_t7_pistol_triton_world", self.origin + ( 0, 0, 20 ), self.angles ); 
	self.e_weapon MoveZ( float_height, float_time /3 );
	self.e_weapon thread rotate_weapon();

	self.e_weapon clientfield::set("powerup_on_fx", 1);

	start_time = GetTime();
	time_passed	= 0;
	
	//will randomly go through all weapon options, even show teddy at all pulls
	while( time_passed < float_time )
	{
		str_weapon = array::random( level.zombie_crate_weapons );
		str_model = get_weapon_model( str_weapon );
		self.e_weapon SetModel( str_model );

		wait( change_time );
		time_passed = ( GetTime() - start_time ) / 1000.0;
	}

	//if 5 or less no teddy 
	if(	self.num_pulls <= 5 && ( str_weapon == "p7_zm_teddybear" ) )
	{
		//exclude teddy, pick another
		str_weapon = level.zombie_crate_weapons[ RandomInt( level.zombie_crate_weapons.size - 1 ) ];
		str_model = get_weapon_model( str_weapon );
		self.e_weapon SetModel( str_model );
	}
	//at 9 pulls guaranteed teddy 
	else if( self.num_pulls >= 9 )
	{
		str_weapon = "p7_zm_teddybear";
		str_model = get_weapon_model( str_weapon );
		self.e_weapon SetModel( str_model );
	}		
	
	//if teddy play laugh, remove weapon box.
	if( str_weapon == "p7_zm_teddybear" )
	{
		wait 2;
		self.e_weapon Delete();	
		self gameobjects::destroy_object( true, true );
		
		return undefined;
	}
	
	self thread weapon_select_watcher();		
	
	return str_weapon;
}

function rotate_weapon()
{
	while ( isdefined( self ) )
	{
		self RotateYaw( 360, 3 );

		wait( 3 - 0.1 );
	}
}	

function weapon_select_watcher()
{	
	level util::waittill_either( "weapon_selected", "weapon_timed_out" );

	if( isdefined( self.e_weapon ) )
	{	
		self.e_weapon clientfield::set("powerup_on_fx", 0);
			
		util::wait_network_frame();	
			
		self.e_weapon Delete();	
	}

	//reactivate gameobject trigger
	self.trigger SetVisibleToAll();
}
	
function activate_weapons_crate( player )
{	
	level endon( "weapon_selected" );
	
	//deactivate gameobject trigger
	self.trigger SetInvisibleToAll();
	self.num_pulls++;

  self.str_weapon = self randomize_weapon_selection();

	if( !isdefined( self.str_weapon ) )
	{
		return;
	}		

	n_timeout = 15;
	self.e_weapon thread magicbox_blink_timeout();
	
	t_weapon_select = Spawn( "trigger_radius_use", self.origin + ( 0, 0, 3 ), 0, 94, 64 );
	t_weapon_select TriggerIgnoreTeam();
	t_weapon_select SetVisibleToAll();
	t_weapon_select SetTeamForTrigger( "none" );
	t_weapon_select UseTriggerRequireLookAt();
	t_weapon_select SetCursorHint( "HINT_NOICON" );
	t_weapon_select SetHintString( "COOP_WEAPONTAKE_ZM" );
		
	self thread player_selects_weapon( player, t_weapon_select );

	wait( n_timeout );
	
	level notify( "weapon_timed_out" );
	
	if( isdefined( t_weapon_select ) )
	{
		t_weapon_select Delete();
	}		
}

function player_selects_weapon( player, trigger )
{
	level endon( "weapon_timed_out" );

	while( true )
	{
		trigger waittill( "trigger", who );
		
		if( IsPlayer( who ) )
		{
			level notify( "weapon_selected" );
			trigger Delete();

			got_weapon_to_switch = false;
			while( !got_weapon_to_switch )
			{
				weapon_to_give = level.zombie_crate_weapons[randomint(level.zombie_crate_weapons.size)];
				weapon = GetWeapon(weapon_to_give);
				
				primaryWeapons = player GetWeaponsListPrimaries();
				already_got = false;
				for( i=0; i<primaryWeapons.size; i++ )
				{
					//Do we already have this weapon?	
					if( weapon == primaryWeapons[i] )
					{
						//yes
						already_got = true;
						break;
					}
				}
				
				if( !already_got )
				{
					got_weapon_to_switch = true;
					//Do the swap
					//currentWeapon = player GetCurrentWeapon();
					
					//Give the new weapon
					player GiveWeapon( weapon );
					player SwitchToWeapon( weapon );
						
					//Remove the old if we are already carrying 2 weapons
					weapon_limit = 2;
					primaryWeapons = player GetWeaponsListPrimaries(); 
					if ( primaryWeapons.size >= weapon_limit )
					{
						player TakeWeapon( player.currentWeapon  );
					}
					player ammo_refill();
					break;
				}
			}
		}
	}	
}	


//self = player
function ammo_refill()
{
	a_w_weapons = self GetWeaponsList();

	foreach ( w_weapon in a_w_weapons )
	{
		self GiveMaxAmmo( w_weapon );
		self SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
	}
}

function magicbox_blink_timeout()
{
	level endon( "weapon_selected" );

	// three blinks: slow, medium, fast
	n_time_total = 15	;
	n_frames = ( n_time_total * 20 );
	n_section = Int( n_frames / 6 );
	
	// cutoff times
	n_flash_slow = n_section * 3;
	n_flash_medium = n_section * 4;
	n_flash_fast = n_section * 5;
	
	b_show = true;
	i = 0;
	
	while ( i < n_frames )
	{
		if ( i < n_flash_slow )
		{
			// solid full time
			n_multiplier = n_flash_slow;  // solid for first half of life
		}
		else if ( i < n_flash_medium )
		{
			// flash slowly
			n_multiplier = 10;  // 0.5 seconds
		}
		else if ( i < n_flash_fast )
		{
			// flash medium
			n_multiplier = 5;  // 0.25 seconds
		}
		else 
		{
			// flash quickly
			n_multiplier = 2;  // 0.1 seconds
		}
		
		if ( b_show )
		{
			self Show();
		}
		else 
		{
			self Ghost();
		}
		
		b_show = !b_show; // toggle
		i += n_multiplier;  // increment count
		wait 0.05 * n_multiplier;
	}
}