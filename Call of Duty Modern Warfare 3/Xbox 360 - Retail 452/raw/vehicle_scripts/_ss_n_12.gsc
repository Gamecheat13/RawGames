#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "ss_n_12", model, type, classname );
	build_localinit( ::init_local );

	build_deathmodel( model );

	//special for ss_n_12/////
	level._effect[ "engineeffect" ]				= loadfx( "fire/jet_afterburner" );
//	level._effect[ "afterburner" ]				= loadfx( "fire/jet_afterburner_ignite" );
	level._effect[ "contrail" ]					= loadfx( "smoke/smoke_geotrail_ssnMissile_trail" );
	level._effect[ "contrail12" ]					= loadfx( "smoke/smoke_geotrail_ssnMissile12_trail" );
	////////////////////////

	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand", undefined, undefined, undefined, undefined, undefined, undefined, 0 );
	build_life( 999, 500, 1500 );
	build_rumble( "mig_rumble", 0.1, 0.2, 11300, 0.05, 0.05 );
	build_team( "allies" );

/*
	randomStartDelay = randomfloatrange( 0, 1 );
	lightmodel = get_light_model( model, classname );
	build_light( lightmodel, "wingtip_green", 	"TAG_LEFT_WINGTIP", 	"misc/aircraft_light_wingtip_green", 	"running", 		randomStartDelay );
	build_light( lightmodel, "tail_green", 		"TAG_LEFT_TAIL", 		"misc/aircraft_light_wingtip_green", 	"running", 		randomStartDelay );
	build_light( lightmodel, "wingtip_red", 		"TAG_RIGHT_WINGTIP", 	"misc/aircraft_light_wingtip_red", 		"running", 		randomStartDelay );
	build_light( lightmodel, "tail_red", 		"TAG_RIGHT_TAIL", 		"misc/aircraft_light_wingtip_red", 		"running", 		randomStartDelay );
	build_light( lightmodel, "white_blink", 		"TAG_LIGHT_BELLY", 		"misc/aircraft_light_white_blink", 		"running", 		randomStartDelay );
	build_light( lightmodel, "landing_light01", 	"TAG_LIGHT_LANDING01", 	"misc/light_mig29_landing", 			"landing", 		0.0 );
*/
}

init_local()
{
	if (self.classname == "script_vehicle_s300_pmu2")
		self.tag = "tag_fx";
	thread playEngineEffects();
	thread handle_death();
	thread playConTrail12();
	maps\_vehicle::lights_on( "running" );
}

#using_animtree( "vehicles" );
set_vehicle_anims( positions )
{
	ropemodel = "rope_test";
	precachemodel( ropemodel );
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

playEngineEffects( tag )
{
	if (isdefined(self.tag))
		tag = self.tag;
	if (!isdefined(tag))
		tag = "tag_tail";
	self endon( "death" );
	self endon( "stop_engineeffects" );

	self ent_flag_init( "engineeffects" );
	self ent_flag_set( "engineeffects" );
	engineeffects = getfx( "engineeffect" );

	for ( ;; )
	{
		self ent_flag_wait( "engineeffects" );
		playfxontag( engineeffects, self, tag );
		self ent_flag_waitopen( "engineeffects" );
		StopFXOnTag( engineeffects, self, tag );
	}
}

/*
playAfterBurner()
{
	//After Burners are pretty much like turbo boost. They don't use them all the time except when 
	//bursts of speed are needed. Needs a cool sound when they're triggered. Currently, they are set
	//to be on all the time, but it would be cool to see them engauge as they fly away.
	self endon( "death" );
	self endon( "stop_afterburners" );

	self ent_flag_init( "afterburners" );
	self ent_flag_set( "afterburners" );
	afterburners = getfx( "afterburner" );

	for ( ;; )
	{
		self ent_flag_wait( "afterburners" );
		playfxontag( afterburners, self, "tag_tail_left" );
		playfxontag( afterburners, self, "tag_tail_right" );
		self ent_flag_waitopen( "afterburners" );
		StopFXOnTag( afterburners, self, "tag_tail_left" );
		StopFXOnTag( afterburners, self, "tag_tail_right" );
	}
}
*/
handle_death()
{
	self waittill("death");
	// cleanup
	if (isdefined(self.tag1))
		self.tag1 Delete();
}

playConTrail( tag )
{
	if (isdefined(self.tag))
		tag = self.tag;
	if (!isdefined(tag))
		tag = "tag_tail";
	
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	self.tag1 = add_contrail( tag );
	contrail = getfx( "contrail" );
	
	self endon( "death" );	


	ent_flag_init( "contrails" );	
	ent_flag_set( "contrails" );
	for ( ;; )
	{
		ent_flag_wait( "contrails" );
		wait(.65);
		playfxontag( contrail, self.tag1, "tag_origin" );
		ent_flag_waitopen( "contrails" );
		stopfxontag( contrail, self.tag1, "tag_origin" );
	}
	
	
//	playfxontag( level._effect[ "contrail" ], self, "tag_engine_right" );
//	playfxontag( level._effect[ "contrail" ], self, "tag_engine_left" );
}


playConTrail12( tag )
{
	if (isdefined(self.tag))
		tag = self.tag;
	if (!isdefined(tag))
		tag = "tag_tail";
	
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	self.tag1 = add_contrail( tag );
	contrail = getfx( "contrail12" );
	
	self endon( "death" );	


	ent_flag_init( "contrails" );	
	ent_flag_set( "contrails" );
	for ( ;; )
	{
		ent_flag_wait( "contrails" );
		wait(.65);
		playfxontag( contrail, self.tag1, "tag_origin" );
		ent_flag_waitopen( "contrails" );
		stopfxontag( contrail, self.tag1, "tag_origin" );
	}
	
	
//	playfxontag( level._effect[ "contrail" ], self, "tag_engine_right" );
//	playfxontag( level._effect[ "contrail" ], self, "tag_engine_left" );
}

add_contrail( fx_tag_name )
{
	// translate the posts into the proper positions for the effect
	fx_tag = spawn_tag_origin();
	fx_tag.origin = self getTagOrigin( fx_tag_name );
	fx_tag.angles = self getTagAngles( fx_tag_name );
	ent = spawnstruct();
	ent.entity = fx_tag;
	ent.forward = 0;
	ent.up = 0;
	ent.right = 0;
	ent.yaw = 0;
	ent.pitch = 0;
	ent translate_local();
	fx_tag LinkTo( self, fx_tag_name );
	return fx_tag;
}

playerisclose( other )
{
	infront = playerisinfront( other );
	if ( infront )
		dir = 1;
	else
		dir = -1;
	a = flat_origin( other.origin );
	b = a + ( anglestoforward( flat_angle( other.angles ) ) * ( dir * 100000 ) );
	point = pointOnSegmentNearestToPoint( a, b, level.player.origin );
	dist = distance( a, point );
	if ( dist < 3000 )
		return true;
	else
		return false;
}

playerisinfront( other )
{
	forwardvec = anglestoforward( flat_angle( other.angles ) );
	normalvec = vectorNormalize( flat_origin( level.player.origin ) - other.origin );
	dot = vectordot( forwardvec, normalvec );
	if ( dot > 0 )
		return true;
	else
		return false;
}

plane_sound_node()
{
	self waittill( "trigger", other );
	other endon( "death" );
	self thread plane_sound_node();// spawn new thread for next plane that passes through this pathnode
	other thread play_loop_sound_on_entity( "veh_f15_dist_loop" );
	while ( playerisinfront( other ) )
		wait .05;
	wait .5;// little delay for the boom
	other thread play_sound_in_space( "veh_f15_sonic_boom" );
	other waittill( "reached_end_node" );
	other stop_sound( "veh_f15_dist_loop" );
	other delete();
}



stop_sound( alias )
{
	self notify( "stop sound" + alias );
}


/*QUAKED script_vehicle_ss_n_12 (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_ss_n_12::main( "ss_n_12_missile", undefined, "script_vehicle_ss_n_12" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_ss_n_12
sound,vehicle_ss_n_12,vehicle_standard,all_sp


defaultmdl="ss_n_12_missile"
default:"vehicletype" "ss_n_12"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_s300_pmu2 (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_ss_n_12::main( "vehicle_s300_pmu2", undefined, "script_vehicle_s300_pmu2" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_s300_pmu2
sound,vehicle_ss_n_12,vehicle_standard,all_sp


defaultmdl="vehicle_s300_pmu2"
default:"vehicletype" "ss_n_12"
default:"script_team" "allies"
*/
