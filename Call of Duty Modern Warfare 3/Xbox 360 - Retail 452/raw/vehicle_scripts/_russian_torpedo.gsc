#include maps\_utility;
#include common_scripts\utility;
#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, classname )
{
	build_template( "russian_torpedo", model, type, classname );
	build_localinit( ::init_local );

	build_deathmodel( "russian_torpedo" );

	//special for russian_torpedo/////
	level._effect[ "engineeffect1" ]				= loadfx( "water/torpedo_wash" );
	level._effect[ "afterburner" ]				= loadfx( "fire/jet_afterburner_ignite" );
	level._effect[ "contrail1" ]					= loadfx( "water/torpedo_wash" );
	////////////////////////

	build_deathfx( "explosions/depth_charge_large", undefined, "explo_metal_rand", undefined, undefined, undefined, undefined, undefined, undefined, 0 );
	build_life( 999, 500, 1500 );
	build_rumble( "mig_rumble", 0.1, 0.2, 11300, 0.05, 0.05 );
	build_team( "axis" );
}

init_local()
{
//	thread playEngineEffects();
	thread handle_death();
	thread playConTrail();
}


playEngineEffects( tag )
{
	if (!isdefined(tag))
		tag = "tag_tail";
	self endon( "death" );
	self endon( "stop_engineeffects" );

	self ent_flag_init( "engineeffects" );
	self ent_flag_set( "engineeffects" );
	engineeffects = getfx( "engineeffect1" );
	//disabling this for now - may add in a detail bubble thing later - dl
	//for ( ;; )
	//{
	//	self ent_flag_wait( "engineeffect1s" );
	//	playfxontag( engineeffects, self, tag );
	//	self ent_flag_waitopen( "engineeffect1s" );
	//	StopFXOnTag( engineeffects, self, tag );
	//}
}

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

handle_death()
{
	self waittill("death");
	if (isdefined(self.tag1))
		self.tag1 Delete();
}

playConTrail( tag )
{
	if (!isdefined(tag))
		tag = "tag_propeller";
	
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	self.tag1 = add_contrail( tag );
	contrail = getfx( "contrail1" );
	
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
	
	
//	playfxontag( level._effect[ "contrail1" ], self, "tag_engine_right" );
//	playfxontag( level._effect[ "contrail1" ], self, "tag_engine_left" );
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


/*QUAKED script_vehicle_russian_torpedo (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_russian_torpedo::main( "russian_torpedo", undefined, "script_vehicle_russian_torpedo" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_russian_torpedo
sound,vehicle_russian_torpedo,vehicle_standard,all_sp


defaultmdl="russian_torpedo"
default:"vehicletype" "russian_torpedo"
default:"script_team" "axis"
*/
