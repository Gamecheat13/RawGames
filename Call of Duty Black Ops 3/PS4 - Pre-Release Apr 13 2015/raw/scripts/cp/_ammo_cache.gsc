#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;

#using scripts\cp\sidemissions\_sm_ui_worldspace;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

	// How long the player's gun is down for when picking up ammo.
	// How long the player's gun is down for when picking up ammo.

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

	foreach ( s_ammo_cache in a_s_ammo_cache )
	{
		ammo_cache = new cAmmoCrate();
		[[ ammo_cache ]]->spawn_ammo_cache( s_ammo_cache.origin, s_ammo_cache.angles );
	}
	
	SetDvar("AmmoBoxPickupTime", 1.0);
}

class cAmmoCrate
{
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
		e_trigger SetTeamForTrigger( "none" );
		e_trigger SetCursorHint( "HINT_INTERACTIVE_PROMPT" );
		e_trigger SetHintString( &"COOP_REFILL_AMMO" );
		
		if( IsDefined( mdl_ammo_cache.script_linkto ) )
		{
			moving_platform = GetEnt( mdl_ammo_cache.script_linkto, "targetname" );
			mdl_ammo_cache LinkTo( moving_platform );
			e_trigger EnableLinkTo();
			e_trigger LinkTo( moving_platform );
		}	
		mdl_ammo_cache oed::enable_keyline( true );
				
		//single use is an ammo box
		if( mdl_ammo_cache.script_string === "single_use" )
		{
			s_ammo_cache_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_ammo_cache ), ( 0, 0, 32 ), &"cp_ammo_box" );
			s_ammo_cache_object gameobjects::allow_use( "any" );
			s_ammo_cache_object gameobjects::set_use_time( 0.5 );
			s_ammo_cache_object gameobjects::set_use_text( &"COOP_AMMO_REFILL" );
			s_ammo_cache_object gameobjects::set_owner_team( "allies" );
			s_ammo_cache_object gameobjects::set_visible_team( "any" );
			s_ammo_cache_object.onUse = &onUse;
			s_ammo_cache_object.onBeginUse = &onBeginUse;
			s_ammo_cache_object.useWeapon = undefined;
			s_ammo_cache_object.single_use = true;
			
			// Set origin/angles so it can be used as an objective target.
			s_ammo_cache_object.origin = mdl_ammo_cache.origin;
			s_ammo_cache_object.angles = s_ammo_cache_object.angles;
		
			if( !IsDefined( mdl_ammo_cache.script_linkto ) )
			{
				s_ammo_cache_object EnableLinkTo();
				s_ammo_cache_object LinkTo( e_trigger );
			}
			
		}	
		//otherwise it is an ammo crate
		else
		{
			s_ammo_cache_object = gameobjects::create_use_object( "any", e_trigger, Array( mdl_ammo_cache ), ( 0, 0, 32 ), &"cp_ammo_crate" );
			s_ammo_cache_object gameobjects::allow_use( "any" );
			s_ammo_cache_object gameobjects::set_use_time( 1.0 );
			s_ammo_cache_object gameobjects::set_use_text( &"COOP_AMMO_REFILL" );
			s_ammo_cache_object gameobjects::set_owner_team( "allies" );
			s_ammo_cache_object gameobjects::set_visible_team( "any" );
			s_ammo_cache_object.onUse = &onUse;
			s_ammo_cache_object.onBeginUse = &onBeginUse;
			s_ammo_cache_object.useWeapon = undefined;
			s_ammo_cache_object.single_use = false;
		
			// Set origin/angles so it can be used as an objective target.
			s_ammo_cache_object.origin = mdl_ammo_cache.origin;
			s_ammo_cache_object.angles = s_ammo_cache_object.angles;
		
			if( !IsDefined( mdl_ammo_cache.script_linkto ) )
			{
				s_ammo_cache_object EnableLinkTo();
				s_ammo_cache_object LinkTo( e_trigger );
			}
			
			mdl_ammo_cache DisconnectPaths();
		}
		
		mdl_ammo_cache.gameobject = s_ammo_cache_object;
	}
	
	function spawn_ammo_cache( origin, angles )
	{
		e_visual = util::spawn_model( "p6_ammo_resupply_future_01", origin, angles, 1 );
		e_visual DisconnectPaths();
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

		e_player notify ( "ammo_refilled" );

		//if this was an ammo box remove it from the world
		if ( self.single_use )
		{
			//this objective was set through the game object scripts and bypasses the objective CP scripts
			Objective_ClearEntity( self.objectiveID );
			self gameobjects::destroy_object( true);
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
} // class cRaidSupplyAmmoCrate

function hide_waypoint( e_player )
{
	self.gameobject gameobjects::hide_waypoint( e_player );
}

function show_waypoint( e_player )
{
	self.gameobject gameobjects::show_waypoint( e_player );
}
