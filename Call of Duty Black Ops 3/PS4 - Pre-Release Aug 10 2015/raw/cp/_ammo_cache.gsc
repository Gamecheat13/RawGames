#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\trigger_shared;

#using scripts\cp\sidemissions\_sm_ui_worldspace;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

	// How long the player's gun is down for when picking up ammo.
	// How long the player's gun is down for when picking up ammo.

	// Minimum time that the Mobile armory needs to be open before closing

#namespace ammo_cache;

#precache( "string", "COOP_AMMO_REFILL" );
#precache( "triggerstring", "COOP_REFILL_AMMO" );
#precache( "objective", "cp_ammo_crate" );
#precache( "objective", "cp_ammo_box" );

function autoexec __init__sytem__() {     system::register("cp_supply_manager",&__init__,&__main__,undefined);    }

function __init__()
{
}

function __main__()
{
	//wait for the first frame to set any client fields
	wait(0.05);

	if( isdefined(level.override_ammo_caches) )
	{
		level thread [[level.override_ammo_caches]]();
		return;
	}
	
	level.n_ammo_cache_id = 31;
	
	// Ammo Cache
	//-----------

	a_mdl_ammo_cache = GetEntArray( "ammo_cache", "script_noteworthy" );		

	foreach ( mdl_ammo_cache in a_mdl_ammo_cache )
	{
		ammo_cache = new cAmmoCrate();
		[[ ammo_cache ]]->init_ammo_cache( mdl_ammo_cache );
	}
	
	a_s_ammo_cache = struct::get_array( "ammo_cache", "script_noteworthy" );
	
	// Ammo Cache (Old Style, left in for legacy support. Should delete?)
	//-----------

	//TODO: REMOVE THIS ONCE EVERYTHING HAS BEEN SWAPPED OVER
	foreach ( s_ammo_cache in a_s_ammo_cache )
	{
		ammo_cache = new cAmmoCrate();
		[[ ammo_cache ]]->spawn_ammo_cache( s_ammo_cache.origin, s_ammo_cache.angles );
	}
	SetDvar("AmmoBoxPickupTime", 1.0);
}

class cAmmoCrate
{
	var mdl_ammo_crate;
	constructor()
	{
	}

	destructor()
	{
	}

	function init_ammo_cache( mdl_ammo_cache )
	{
		e_trigger = Spawn( "trigger_radius_use", mdl_ammo_cache.origin + ( 0, 0, 3 ), 0, 94, 64 );
		e_trigger TriggerIgnoreTeam();
		e_trigger SetVisibleToAll();
		e_trigger UseTriggerRequireLookAt();
		e_trigger SetTeamForTrigger( "none" );
		e_trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		e_trigger SetHintString( &"COOP_REFILL_AMMO" );
		
		if( isdefined( mdl_ammo_cache.script_linkto ) )
		{
			moving_platform = GetEnt( mdl_ammo_cache.script_linkto, "targetname" );
			mdl_ammo_cache LinkTo( moving_platform );
		}
		e_trigger EnableLinkTo();
		e_trigger LinkTo( mdl_ammo_cache );	
		mdl_ammo_cache oed::enable_keyline( true );
		
		//single use is an ammo box
		if( mdl_ammo_cache.script_string === "single_use" )
		{		
			s_ammo_cache_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_ammo_cache ), ( 0, 0, 32 ), &"cp_ammo_box" );
		}
		else
		{
			s_ammo_cache_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_ammo_cache ), ( 0, 0, 32 ), &"cp_ammo_crate" );
		}
		
		s_ammo_cache_object gameobjects::allow_use( "any" );			
		s_ammo_cache_object gameobjects::set_use_text( &"COOP_AMMO_REFILL" );
		s_ammo_cache_object gameobjects::set_owner_team( "allies" );
		s_ammo_cache_object gameobjects::set_visible_team( "any" );
		s_ammo_cache_object.onUse = &onUse;
		s_ammo_cache_object.useWeapon = undefined;
		
		// Set origin/angles so it can be used as an objective target.
		s_ammo_cache_object.origin = mdl_ammo_cache.origin;
		s_ammo_cache_object.angles = s_ammo_cache_object.angles;		
		
		//single use is an ammo box
		if( mdl_ammo_cache.script_string === "single_use" )
		{
			s_ammo_cache_object gameobjects::set_use_time( 0.5 );
			s_ammo_cache_object.onBeginUse = &onBeginUse;
			s_ammo_cache_object.single_use = true;
		}	
		//otherwise it is an ammo crate
		else
		{
			s_ammo_cache_object gameobjects::set_use_time( 1.0 );
			s_ammo_cache_object.single_use = false;
			
			mdl_ammo_cache.gameobject = s_ammo_cache_object;
			mdl_ammo_crate = mdl_ammo_cache;
			mdl_ammo_crate.b_is_animating = false;			
						
			radius_trigger = Spawn( "trigger_radius", e_trigger.origin, 0, 94, 64 );
			radius_trigger SetVisibleToAll();
			radius_trigger SetTeamForTrigger( "allies" );
			radius_trigger EnableLinkTo();
			radius_trigger LinkTo( mdl_ammo_cache );
			radius_trigger thread animate_on_trigger( mdl_ammo_crate );
		}
		
		mdl_ammo_cache.gameobject = s_ammo_cache_object;
	}
	
	function spawn_ammo_cache( origin, angles )
	{
		e_visual = util::spawn_model( "p6_ammo_resupply_future_01", origin, angles, 1 );
		init_ammo_cache( e_visual );
	}
	
	function onBeginUse( e_player )
	{
		e_player PlaySound( "fly_ammo_crate_refill" );
	}
	
	function onUse( e_player )
	{
		a_w_weapons = e_player GetWeaponsList();

		foreach ( w_weapon in a_w_weapons )
		{
			if ( _is_banned_refill_weapon( w_weapon ) )
			{
				continue;
			}

			e_player GiveMaxAmmo( w_weapon );
			e_player SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
		}

		e_player notify( "ammo_refilled" );
		
		e_player PlayRumbleOnEntity( "damage_light" );
		
		//if this was an ammo box remove it from the world
		if ( self.single_use )
		{
			//this objective was set through the game object scripts and bypasses the objective CP scripts
			Objective_ClearEntity( self.objectiveID );
			self gameobjects::destroy_object( true, undefined, true );
		}
	}

	function _is_banned_refill_weapon( w_weapon )
	{
		switch ( w_weapon.name )
		{
			case "minigun_warlord_raid":
			{
				return true;
			} break;
		}

		return false;
	}

	function animate_on_trigger( mdl_ammo_crate )
	{
		while( true )
		{
			self waittill( "trigger", entity );
			
			if( !IsDefined( mdl_ammo_crate )  )
			{
				break;
			}
			if( IsPlayer( entity ) )
			{
				animate_ammo_cache( mdl_ammo_crate );
			}
		}
	}
	
	function animate_ammo_cache( mdl_ammo_crate )
	{
		mdl_ammo_crate endon ( "death" );
		
		if( mdl_ammo_crate.b_is_animating )
		{
			return;	//only allow 1 of these threads to run
		}
		
		mdl_ammo_crate.b_is_animating = true;
		
		mdl_ammo_crate scene::play( "p7_fxanim_gp_ammo_resupply_02_open_bundle", mdl_ammo_crate );
		
		wait 1.0;
		
		//do not close while players are near
		num_players_near = 1;
		
		while( num_players_near > 0 )
		{
			num_players_near = 0;
			foreach( e_player in level.players )
			{
				dist_sq = DistanceSquared( e_player.origin, mdl_ammo_crate.origin );
				if( dist_sq <= 14400 )
				{
					num_players_near++;
				}
			}
			
			wait 0.5; //do not need to cycle this every frame
		}
		
		mdl_ammo_crate scene::play( "p7_fxanim_gp_ammo_resupply_02_close_bundle", mdl_ammo_crate );
		
		mdl_ammo_crate.b_is_animating = false;
	}
} // class cRaidSupplyAmmoCrate

function hide_waypoint( e_player )
{
	self.gameobject gameobjects::hide_waypoint( e_player );
}

function show_waypoint( e_player )
{
	self.gameobject gameobjects::show_waypoint( e_player );
}
