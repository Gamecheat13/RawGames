#include maps\_utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "mig29", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_mig29_desert" );
	
	//special for mig29/////
	level._effect[ "afterburner" ]			= loadfx( "fire/jet_afterburner" );
	level._effect[ "contrail" ]					= loadfx( "smoke/jet_contrail" );
	////////////////////////

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_rumble( "mig_rumble", .1,     .2,         11300,         .05,          .05 );
	build_team( "allies" );
}

init_local()
{
	thread playAfterBurner();
	thread playConTrail();
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	ropemodel = "rope_test";
	precachemodel( ropemodel );
	/*
	positions[ 0 ].vehicle_getinanim = %tigertank_hatch_open;
	positions[ 1 ].vehicle_getoutanim = %tigertank_hatch_open;
	*/
	return positions;
}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	for( i=0;i<1;i++ )
		positions[ i ] = spawnstruct();
		
	return positions;
}

playAfterBurner()
{
	//After Burners are pretty much like turbo boost. They don't use them all the time except when 
	//bursts of speed are needed. Needs a cool sound when they're triggered. Currently, they are set
	//to be on all the time, but it would be cool to see them engauge as they fly away.
	burnerDelay= 0.1;
	
	for( ;; )
	{
		if( !isdefined( self ) )
			return;
		if( !isalive( self ) )
			return;
		playfxontag( level._effect[ "afterburner" ], self, "tag_engine_right" );
		playfxontag( level._effect[ "afterburner" ], self, "tag_engine_left" );
		wait burnerDelay;
	}
}

playConTrail()
{
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	playfxontag( level._effect[ "contrail" ], self, "tag_right_wingtip" );
	playfxontag( level._effect[ "contrail" ], self, "tag_left_wingtip" );
}


playerisclose( other )
{
	infront = playerisinfront( other );
	if( infront )
		dir = 1;
	else
		dir = -1;
	a = flat_origin( other.origin );
	b = a+vector_multiply( anglestoforward( flat_angle( other.angles ) ), ( dir*100000 ) );
	point = pointOnSegmentNearestToPoint( a, b, level.player.origin );
	dist = distance( a, point );
	if( dist < 3000 )
		return true;
	else
		return false;
}

playerisinfront( other )
{
		forwardvec = anglestoforward( flat_angle( other.angles ) );
		normalvec = vectorNormalize( flat_origin( level.player.origin )-other.origin );
		dot = vectordot( forwardvec, normalvec ); 
		if( dot > 0 )
			return true;
		else
			return false;
}

plane_sound_node()
{
		self waittill( "trigger", other );
		other endon( "death" );
		self thread plane_sound_node(); // spawn new thread for next plane that passes through this pathnode
		other thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
		while( playerisinfront( other ) )
			wait .05;
		wait .5; // little delay for the boom
		other thread play_sound_in_space( "veh_mig29_sonic_boom" );
		other waittill( "reached_end_node" );
		other stop_sound( "veh_mig29_dist_loop" );
		other delete();
}

stop_sound( alias )
{
	self notify( "stop sound"+alias );
}
