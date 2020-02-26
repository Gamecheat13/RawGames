#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

// ---------------------------------------------------------------------------------
//	Rapelling AI
// ---------------------------------------------------------------------------------
player_seek_stages()
{
	self endon( "death" );
	
	stages[ 0 ] = 2000;
	stages[ 1 ] = 1500;
	stages[ 2 ] = 1000;
	
	if ( isdefined( self.script_vehicleride ) )
	{
		self waittill( "jumpedout" );
		wait 0.5;
	}
	
	self setgoalentity( level.players[ 0 ] );
	
	foreach( iRadius in stages )
	{
		self.goalradius = iRadius;
		wait 15.0;
	}
}

ai_rappel_think( playerSeek )
{
	self endon( "death" );

	self.animname = "generic";
	self.oldhealth = self.health;
	self.health = 3;
	self hide();

	reference = self.spawner;
	reference anim_first_frame_solo( self, self.animation );

	wait( 0.5 );
	wait randomfloat( 4 );

	eRopeOrg = spawn( "script_origin", reference.origin );
	eRopeOrg.angles = reference.angles;

	eRope = spawn( "script_model", eRopeOrg.origin );
	eRope setmodel( "coop_bridge_rappelrope" );
	eRope.animname = "rope";
	eRope assign_animtree();
	
	eRopeOrg anim_first_frame_solo( eRope, "coop_ropedrop_01" );
	eRopeOrg anim_single_solo( eRope, "coop_ropedrop_01" );

	self show();
	self.allowdeath = true;
	self thread ai_rappel_death();

	eRopeOrg thread anim_single_solo( eRope, "coop_" + self.animation );
	reference thread anim_generic( self, self.animation );

	self waittill( "over_solid_ground" );

	self.health = self.oldhealth;
	if ( isdefined( playerSeek ) && playerSeek )
	{
		self thread player_seek_stages();
	}
	else
	{
		self.goalradius = 500;
		self setGoalPos( self.origin );
	}
}

ai_rappel_death()
{
	self endon( "over_solid_ground" );
	if ( !isdefined( self ) )
	{
		return;
	}

	self set_deathanim( "fastrope_fall" );
	self waittill( "death" );

	if ( IsDefined( self ) )
	{
		self thread play_sound_in_space( "generic_death_falling" );
	}
}

ai_rappel_over_ground_death_anim( guy )
{
	guy endon( "death" );
	guy notify( "over_solid_ground" );
	guy clear_deathanim();
}

// ---------------------------------------------------------------------------------
//	Scripted Destructions
// ---------------------------------------------------------------------------------
missile_taxi_moves()
{
	taxi = getent( "missile_taxi", "script_noteworthy" );
	taxi.finalOrg = taxi.origin;
	taxi.finalAng = taxi.angles;
	
	taxi.origin += ( 80, 200, 0 );
	taxi.angles = ( 0, 180, 0 );
	
	wait 3;
	
	for(;;)
	{
		taxi waittill( "damage", amount, attacker );
		if ( !isdefined( attacker ) )
			continue;
		if ( !isdefined( attacker.classname ) )
			continue;
		if ( attacker.classname == "script_vehicle" )
			break;
	}
	
	taxi thread destructible_force_explosion();
	moveTime = 1.0;
	taxi moveTo( taxi.finalOrg, moveTime, 0, moveTime / 2 );
	taxi rotateTo( taxi.finalAng, moveTime, 0, moveTime / 2 );
}

// ---------------------------------------------------------------------------------
//	Attack Helicopter
// ---------------------------------------------------------------------------------
attack_heli()
{
	trigger_wait( "attack_heli", "targetname" );
	attack_heli = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "kill_heli" );
	thread maps\_attack_heli::begin_attack_heli_behavior( attack_heli );
	assert( isdefined( attack_heli ) );
}

// ---------------------------------------------------------------------------------
//	Bridge Collapsing
// ---------------------------------------------------------------------------------
BRIDGE_COLLAPSE_SPEED = 1.0;

collapsed_section_shakes()
{
	trigger = getent( "collapsed_bridge_effects", "targetname" );
	targets = getentarray( trigger.target, "targetname" );

	trigger waittill( "trigger" );

	foreach ( eTarget in targets )
	{
		//playfx( <effect id >, <position of effect>, <forward vector>, <up vector> )
		playfx( getfx( "dust_ceiling_fall" ), eTarget.origin );
	}
}

bridge_collapse_prep()
{
	wait 0.1;
	
	thread road_piece_1();
	thread road_piece_2();
	thread road_piece_3();
	thread road_piece_4();
	thread road_piece_5();
	thread road_piece_6();
	thread road_piece_7();
	thread road_piece_8();
	thread bridge_collapse_van();
	thread bridge_collapse_suv();
	thread bridge_collapse_truck_1();
	thread bridge_collapse_truck_2();
	thread bridge_collapse_sedan_1();
	
	thread reveal_details();
	
	//bridge_collapse_smashed_car_1
	
	thread view_tilt();
	thread car_slide( "slide_car_1", "slide_car_start_1" );
	thread car_slide( "slide_car_2", "slide_car_start_2" );
	thread car_slide( "slide_car_3", "slide_car_start_3" );
	thread car_slide( "slide_car_4", "slide_car_start_4" );
	
	level waittill( "bridge_collapse" );

	if ( isdefined( level.player_sprint_scale ) )
		setSavedDvar( "player_sprintSpeedScale", level.default_sprint );
	
	// start earthquake now, bridge is tilting and cars are sliding
	earthquake( 0.25, 15, level.player.origin, 1000000 );
	
	wait 4;
	
	// start sound, needs 2 seconds to play before bridge comes down
	bridge_collapse_sound = getent( "bridge_collapse_sound", "targetname" );
	assert( isdefined( bridge_collapse_sound ) );
	bridge_collapse_sound thread play_sound_on_entity( "scn_bridge_collapse" );
	
	wait 2;
	
	// bridge begins to fall
	level notify( "bridge_collapse_start" );
	
	thread exploder( 1 );
	
	//setblur( 1.0, 0.5 );
	wait 6 * BRIDGE_COLLAPSE_SPEED;
	//setblur( 0, 0.5 );

	if ( isdefined( level.player_sprint_scale ) )
		setSavedDvar( "player_sprintSpeedScale", level.player_sprint_scale );
}

reveal_details()
{
	// bridge destroyed details that dont move, they just spawn in after the collapse and are hidden by the smoke
	bridge_collapse_details = getentarray( "bridge_collapse_detail", "targetname" );
	thread array_call( bridge_collapse_details, ::hide );
	
	// these destroyed bridge details spawn in also but need to slide into position because they are less hidden by the smoke
	/*
	bridge_collapse_detail_slide_origin = getent( "bridge_collapse_detail_slide_origin", "targetname" ).origin;
	bridge_collapse_detail_slide = getentarray( "bridge_collapse_detail_slide", "targetname" );
	
	foreach( part in bridge_collapse_detail_slide )
	{
		part.finalOrigin = part.origin;
		part.origin = ( part.origin[ 0 ], bridge_collapse_detail_slide_origin[ 1 ], bridge_collapse_detail_slide_origin[ 2 ] );
		part hide();
	}
	*/
	level waittill( "bridge_collapse_start" );
	
	wait 1;
	/*
	foreach( part in bridge_collapse_detail_slide )
	{
		part show();
		part thread reveal_details_slide();
	}
	*/
	wait 1.5;
	
	thread array_call( bridge_collapse_details, ::show );
}

reveal_details_slide()
{
	self show();
	self moveto( self.finalOrigin, 2.0, 0.0, 0.5 );
	wait 2.0;
	self.origin = self.finalOrigin;
}

road_piece_1()
{
	part = getent( "bridge_piece_1", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	details = getentarray( "road_piece_1_detail", "targetname" );
	thread array_call( details, ::hide );
	
	part.origin += ( 0, 0, 280 );
	part.angles = ( -3, 0, 0 );
	
	level waittill( "bridge_collapse_start" );
	
	nextPosOrigin = part.origin - ( 0, 0, 150 );
	nextPosAngle = part.angles + ( -2, 0, 20 );
	
	moveTime = 0.75 * BRIDGE_COLLAPSE_SPEED;
	
	part rotateTo( nextPosAngle, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0 * BRIDGE_COLLAPSE_SPEED );
	part moveTo( nextPosOrigin, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0 * BRIDGE_COLLAPSE_SPEED );
	wait moveTime;
	
	part rotateTo( part.landingSpotAng, moveTime, 0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	part moveTo( part.landingSpotOrg, moveTime, 0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	wait moveTime;
	
	thread array_call( details, ::show );
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_2()
{
	part = getent( "bridge_piece_2", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	details = getentarray( "road_piece_2_detail", "targetname" );
	thread array_call( details, ::hide );
	
	part.origin += ( 0, 0, 130 );
	part.angles = ( -15, 0, -22 );
	
	level waittill( "bridge_collapse_start" );
	
	moveTime = 1.5 * BRIDGE_COLLAPSE_SPEED;
	
	part rotateTo( part.landingSpotAng, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	part moveTo( part.landingSpotOrg, moveTime, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	wait moveTime;
	
	thread array_call( details, ::show );
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_3()
{
	PART_SPEED = 0.75;
	
	part = getent( "bridge_piece_3", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 90 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 2.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part rotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	
	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_4()
{
	PART_SPEED = 0.75;
	
	part = getent( "bridge_piece_4", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 30 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 3.0 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part rotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_5()
{
	PART_SPEED = 0.75;
	
	part = getent( "bridge_piece_5", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 20 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 2.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part rotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_6()
{
	PART_SPEED = 0.75;
	
	part = getent( "bridge_piece_6", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 40 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 1.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part rotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_7()
{
	PART_SPEED = 0.75;
	
	part = getent( "bridge_piece_7", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 40 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 2.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part rotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

road_piece_8()
{
	PART_SPEED = 0.75;
	
	part = getent( "bridge_piece_8", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 350 );
	part.angles = ( -30, 20, 40 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 1.5 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part rotateTo( part.landingSpotAng, 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED * PART_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED * PART_SPEED );
	
	wait 0.8 * BRIDGE_COLLAPSE_SPEED * PART_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

bridge_collapse_van()
{
	part = getent( "bridge_collapse_van", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( -80, 50, 280 );
	
	level waittill( "bridge_collapse_start" );
	
	nextPosOrigin = part.origin - ( 0, 0, 280 );
	part moveTo( nextPosOrigin, 1.4 * BRIDGE_COLLAPSE_SPEED, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	
	wait 1.4 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.2 * BRIDGE_COLLAPSE_SPEED, 0.7 * BRIDGE_COLLAPSE_SPEED, 0.5 * BRIDGE_COLLAPSE_SPEED );
}

bridge_collapse_suv()
{
	part = getent( "bridge_collapse_suv", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 200 );
	part.angles = ( 90, 90, 0 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 1.8 * BRIDGE_COLLAPSE_SPEED;
	
	nextPosOrigin = part.origin - ( 0, 0, 200 );
	part moveTo( nextPosOrigin, 0.5 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	
	wait 0.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 0.5 * BRIDGE_COLLAPSE_SPEED, 0.1 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	part rotateTo( part.landingSpotAng, 0.5 * BRIDGE_COLLAPSE_SPEED, 0.1 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
}

bridge_collapse_truck_1()
{
	part = getent( "bridge_collapse_truck_1", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 280 );
	part.angles = ( 90, 0, 90 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 2.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg + ( 0, 0, 80 ), 1.2 * BRIDGE_COLLAPSE_SPEED, 0.7 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	
	wait 1.2 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.5 * BRIDGE_COLLAPSE_SPEED );
	part rotateTo( part.landingSpotAng, 1.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	
	wait 1.0 * BRIDGE_COLLAPSE_SPEED;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

bridge_collapse_truck_2()
{
	part = getent( "bridge_collapse_truck_2", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( 0, 0, 380 );
	part.angles = ( 90, -30, 0 );
	
	level waittill( "bridge_collapse_start" );
	
	wait 0.5 * BRIDGE_COLLAPSE_SPEED;
	
	moveTime = 1.0 * BRIDGE_COLLAPSE_SPEED;
	part moveTo( part.landingSpotOrg + ( 0, 0, 80 ), moveTime, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	
	wait 0.2 * BRIDGE_COLLAPSE_SPEED;
	
	moveTime = 0.75 * BRIDGE_COLLAPSE_SPEED;
	part moveTo( part.landingSpotOrg, moveTime, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	part rotateTo( part.landingSpotAng, moveTime, 0.0 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	
	wait moveTime;
	
	part thread part_rummble( part.landingSpotOrg, part.landingSpotAng );
}

bridge_collapse_sedan_1()
{
	part = getent( "bridge_collapse_sedan_1", "targetname" );
	assert( isdefined( part ) );
	part.landingSpotOrg = part.origin;
	part.landingSpotAng = part.angles;
	
	part.origin += ( -50, 180, 150 );
	part.angles = ( 0, 330, 0 );	//26 330 13
	
	part setModel( "vehicle_coupe_gold" );
	
	level waittill( "bridge_collapse_start" );
	
	nextPosOrigin = part.origin - ( 0, 0, 50 );
	part moveTo( nextPosOrigin, 1.5 * BRIDGE_COLLAPSE_SPEED, 0.3 * BRIDGE_COLLAPSE_SPEED, 0.2 * BRIDGE_COLLAPSE_SPEED );
	part rotateTo( part.landingSpotAng, 1.5 * BRIDGE_COLLAPSE_SPEED, 0.1 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED );
	
	wait 1.5 * BRIDGE_COLLAPSE_SPEED;
	
	part moveTo( part.landingSpotOrg, 1.2 * BRIDGE_COLLAPSE_SPEED, 0.0 * BRIDGE_COLLAPSE_SPEED, 1.0 * BRIDGE_COLLAPSE_SPEED );
	
	wait 1.2 * BRIDGE_COLLAPSE_SPEED;
	
	part setModel( "vehicle_coupe_gold_destroyed" );
}

part_rummble( finalOrg, finalAng )
{
	// makes a part move around a bit after crashing down to make it seem less mechanical
	
	MAX_RUMBLE_ORG_OFFSET = 5;
	MAX_RUMBLE_ANG_OFFSET = 1;
	
	numMoves = randomintrange( 3, 5 );
	
	for( i = 0 ; i < numMoves ; i++ )
	{
		moveTime = randomfloatrange( 0.05, 0.2 ) * BRIDGE_COLLAPSE_SPEED;
		//accel_decel = randomfloatrange( 0.0, moveTime / 2 );
		accel_decel = 0 * BRIDGE_COLLAPSE_SPEED;
		
		offsetAng = ( randomintrange( 0, MAX_RUMBLE_ANG_OFFSET ) - ( MAX_RUMBLE_ANG_OFFSET / 2 ), randomintrange( 0, MAX_RUMBLE_ANG_OFFSET ) - ( MAX_RUMBLE_ANG_OFFSET / 2 ), randomintrange( 0, MAX_RUMBLE_ANG_OFFSET ) - ( MAX_RUMBLE_ANG_OFFSET / 2 ) );
		offsetOrg = ( randomintrange( 0, MAX_RUMBLE_ORG_OFFSET ) - ( MAX_RUMBLE_ORG_OFFSET / 2 ), randomintrange( 0, MAX_RUMBLE_ORG_OFFSET ) - ( MAX_RUMBLE_ORG_OFFSET / 2 ), randomintrange( 0, MAX_RUMBLE_ORG_OFFSET ) - ( MAX_RUMBLE_ORG_OFFSET / 2 ) );
		
		self rotateTo( self.angles + offsetAng, moveTime, accel_decel, accel_decel );
		self moveTo( self.origin + offsetOrg, moveTime, accel_decel, accel_decel );
		
		wait moveTime;
		
		self rotateTo( finalAng, moveTime, accel_decel, accel_decel );
		self moveTo( finalOrg, moveTime, accel_decel, accel_decel );
		
		wait moveTime;
	}
	
	self.origin = finalOrg;
	self.angles = finalAng;
}

view_tilt()
{
	view_angle_controller_entity = getent( "view_angle_controller_entity", "targetname" );
	assert( isdefined( view_angle_controller_entity ) );
	direction_ent = getent( view_angle_controller_entity.target, "targetname" );
	assert( isdefined( direction_ent ) );
	gravity_vec = vectorNormalize( direction_ent.origin - view_angle_controller_entity.origin );
	
	level waittill( "bridge_collapse" );
	
	setsaveddvar( "phys_gravityChangeWakeupRadius", 1600 );
	level.player playerSetGroundReferenceEnt( view_angle_controller_entity );
	if ( is_coop() )
		level.player2 playerSetGroundReferenceEnt( view_angle_controller_entity );
	
	moveTime = 2.0;
	view_angle_controller_entity rotatePitch( 10, moveTime, moveTime / 2, moveTime / 2 );
	wait moveTime;
	
	setPhysicsGravityDir( gravity_vec );
	
	moveTime = 1.0;
	view_angle_controller_entity rotatePitch( -3, moveTime, moveTime / 2, moveTime / 2 );
	wait moveTime;
	
	moveTime = 1.0;
	view_angle_controller_entity rotatePitch( 4, moveTime, moveTime / 2, moveTime / 2 );
	wait moveTime;
	
	moveTime = 2.0;
	view_angle_controller_entity rotatePitch( -11, moveTime, moveTime / 2, moveTime / 2 );
	wait moveTime;
	
	setPhysicsGravityDir( ( 0, 0, -1 ) );
}

car_slide( carName, startName )
{
	ents = getentarray( carName, "script_noteworthy" );
	car = undefined;
	foreach( ent in ents )
	{
		if ( ent.classname != "script_model" )
			continue;
		car = ent;
		break;
	}
	assert( isdefined( car ) );
	
	start = getent( startName, "script_noteworthy" );
	assert( isdefined( car ) );
	assert( isdefined( start ) );
	
	d = distance( car.origin, start.origin );
	moveTime = d / 50;
	accel_decel = moveTime / 4;
	
	car.finalOrg = car.origin;
	car.origin = start.origin;
	
	level waittill( "bridge_collapse" );
	
	wait 1;
	
	car moveto( car.finalOrg, moveTime, accel_decel, accel_decel );
}