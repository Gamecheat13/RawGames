/*
 * Created by ScriptDevelop.
 * User: kdrew
 * Date: 4/5/2012
 * Time: 5:03 PM
*/

#include common_scripts\utility;
#include maps\_utility;

#insert raw\maps\_utility.gsh;

#define TITUS_WEAPON_NAME			"exptitus6_sp"
#define TITUS_FOV_ANGLE				45

//initializes everything needed for the weapon
autoexec init()
{

}

//self is the player, watches for a fire made by the titus and runs logic
_titus_fire_watcher()
{
	self endon( "death" );
	
	while( true )
	{
		self waittill ( "missile_fire", e_grenade, str_weapon );
		
		if( str_weapon == TITUS_WEAPON_NAME )
		{
			e_grenade thread _titus_locate_target();
		}
	}
}

//self is the original grenade
_titus_locate_target()
{
	self endon("death");
		
	self thread _titus_reset_grenade_fuse();
	
	while( 1 )
	{
		a_targets = ArrayCombine( GetAIArray( "axis" ), GetVehicleArray( "axis" ), false, false );
		a_targets = get_array_of_closest( self.origin, a_targets, undefined, undefined, 2000 );
		
		foreach( target in a_targets )
		{
			if ( within_fov( self.origin, self.angles, target.origin, cos( TITUS_FOV_ANGLE ) ) )
			{
				if( IsAI( target ) )
				{
					if ( !IsDefined( target.titusmarked ) )
					{
						self Missile_SetTarget(target, (0,0,40) );
						target thread _titus_marked();
						return;
					}
				}
				else if( target IsVehicle() && !IS_PLANE( target ) )
				{
					if ( !IsDefined( target.titusmarked ) )
					{
						self Missile_SetTarget(target);
						target thread _titus_marked();
						return;
					}
				}
			}
		}
		
		wait 0.25;
	}
}

//self is a marked target, either a vehicle or ai
_titus_marked()
{
	self endon( "death" );
	
	self.titusmarked = true;
	wait 1;
	self.titusmarked = undefined;
}

//self is the original grenade
_titus_reset_grenade_fuse( n_fuse_min = 1.5, n_fuse_max = 3.0 )
{
	self waittill( "death" );
	
	//doesn't seem to be a way to grab the spawned dart directly from the projectile weapon
	a_grenades = GetEntArray( "grenade", "classname" );
	foreach( e_grenade in a_grenades )
	{
		if( ( e_grenade.model == "t6_wpn_projectile_titus" ) && !IsDefined( e_grenade.fuse_reset ) )
		{
			e_grenade.fuse_reset = 1;
			e_grenade ResetMissileDetonationTime( RandomFloatRange( n_fuse_min, n_fuse_max ) );
			return;
		}
	}	
}

