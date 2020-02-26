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

plane_bomb_node()
{
		level._effect[ "plane_bomb_explosion1" ]			= loadfx( "explosions/javelin_explosion" );
		level._effect[ "plane_bomb_explosion2" ]			= loadfx( "explosions/helicopter_explosion" );
		self waittill( "trigger", other );
		other endon( "death" );
		self thread plane_bomb_node(); // spawn new thread for next plane that passes through this pathnode
		
		// get array of targets
		aBomb_targets = getentarray( self.script_linkTo, "script_linkname" );
		assertEx( isdefined( aBomb_targets ), "Plane bomb node at " + self.origin  + " needs to script_linkTo at least one script_origin to use as a bomb target");
		assertEx( aBomb_targets.size > 1, "Plane bomb node at " + self.origin  + " needs to script_linkTo at least one script_origin to use as a bomb target");
		
		//sort array of targets from nearest to furthest to determine order of bombing
		aBomb_targets = get_array_of_closest( self.origin , aBomb_targets , undefined , aBomb_targets.size );
		iExplosionNumber = 0;
		
		wait randomfloatrange( .3, .8 );
		for(i=0;i<aBomb_targets.size;i++)
		{
			iExplosionNumber++;
			if (iExplosionNumber == 3)
				iExplosionNumber = 1;
			aBomb_targets[i] thread play_sound_on_entity( "airstrike_explosion" );
			//aBomb_targets[i] thread play_sound_on_entity( "rocket_explode_sand" );
			playfx( level._effect[ "plane_bomb_explosion" +  iExplosionNumber], aBomb_targets[i].origin);
			wait randomfloatrange( .3, 1.2 );
		}
}

stop_sound( alias )
{
	self notify( "stop sound"+alias );
}
