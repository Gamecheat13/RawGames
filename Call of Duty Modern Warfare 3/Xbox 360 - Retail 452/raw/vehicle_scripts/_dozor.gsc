#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );


/*QUAKED script_vehicle_dozor (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_dozor::main( "russian_dozor_600", undefined, "script_vehicle_dozor" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_dozor

defaultmdl="russian_dozor_600"
default:"vehicletype" "dozor"
default:"script_team" "axis"
*/


main( model, type, classname )
{
	build_template( "dozor", model, type, classname );
	build_localinit( ::init_local );

	build_deathmodel( "russian_dozor_600" );

	//special for ucav/////
	level._effect[ "jettrail" ]					 = loadfx( "smoke/jet_contrail" );
	////////////////////////

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_mainturret();
}

init_local()
{
	thread playJetTrail();
	
	self.missileTags[ 0 ] = "tag_missile_left";
	self.missileTags[ 1 ] = "tag_missile_right";
	self.nextMissileTag = 0;
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for ( i = 0;i < 1;i++ )
		positions[ i ] = spawnstruct();

	return positions;
}

playJetTrail()
{
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	playfxontag( level._effect[ "jettrail" ], self, "TAG_JET_TRAIL" );
}

plane_sound_node()
{
	self waittill( "trigger", other );
	other endon( "death" );
	self thread plane_sound_node();// spawn new thread for next plane that passes through this pathnode
	
	other thread play_sound_on_entity( "veh_uav_flyby" );
}

fire_missile_node()
{
	self waittill( "trigger", other );
	other endon( "death" );
	self thread fire_missile_node();
	
	// set the weapon and get the missile target
	other setVehWeapon( "ucav_sidewinder" );
	eTarget = self get_linked_ent();
	
	// fire weapon
	other fireWeapon( other.missileTags[ other.nextMissileTag ], eTarget, ( 0, 0, 0 ) );
	
	// advance to the next missile tag for the next shot
	other.nextMissileTag++;
	if ( other.nextMissileTag >= other.missileTags.size )
		other.nextMissileTag = 0;
}