#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include maps\mp\zm_transit_utility;

#insert raw\common_scripts\utility.gsh;

#define TELEPORTER_DIST			( 64 * 64 )

//-------------------------------------------------------------------
// player brought the screecher to a green light
//-------------------------------------------------------------------
screecher_should_burrow( player )
{
	green_light = player.green_light;
	if ( isdefined( green_light ) )
	{
		if ( !is_true( green_light.burrow_active ) )
		{
			green_light thread check_teleport();
		}
		return true;
	}

	return false;
}

//-------------------------------------------------------------------
// player needs to jump into portal
//-------------------------------------------------------------------
check_teleport()
{
	self.burrow_active = true;

	portal_fx = Spawn( "script_model", self.origin );
	portal_fx SetModel( "tag_origin" );
	portal_fx playsound( "zmb_screecher_portal_spawn" );
	wait_network_frame();
	PlayFXOnTag( level._effect[ "screecher_portal" ], portal_fx, "tag_origin" );
	portal_fx playloopsound( "zmb_screecher_portal_loop", 2 );

	while ( 1 )
	{
		players = GET_PLAYERS();
		foreach( player in players )
		{
			if ( !player IsOnGround() )
			{
				dist = Distance2DSquared( player.origin, self.origin );
				if ( dist < TELEPORTER_DIST )
				{
					player playsoundtoplayer( "zmb_screecher_portal_warp_2d", player );
					self thread teleport_player( player );
					playsoundatposition( "zmb_screecher_portal_end", portal_fx.origin );
					portal_fx delete();
					self.burrow_active = false;
					return;
				}
			}
		}

		wait_network_frame();
	}
}

//-------------------------------------------------------------------
// send player to a random green light
//-------------------------------------------------------------------
teleport_player( player )
{
	lights = getstructarray( "screecher_escape", "targetname" );
	lights = array_randomize( lights );
	dest_light = lights[0];
	if ( dest_light == self )
	{
		dest_light = lights[1];
	}
	
	playsoundatposition( "zmb_screecher_portal_arrive", dest_light.origin );
	player SetOrigin( dest_light.origin );
}

