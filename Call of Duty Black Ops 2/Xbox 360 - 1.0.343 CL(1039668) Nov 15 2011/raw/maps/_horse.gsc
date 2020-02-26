#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

#define ENT_FLAG(__self,__message) (__self.ent_flag[__message])

#define CF_PLAYER_AIMING		0

#define STAND_IDLE				0
#define RIGHT_IDLE				1
#define FORWARD_IDLE			2
#define WIDE_IDLE				3
#define FRISKY_IDLE				4
#define EAT_IDLE				5
#define EAT_IDLE_B				6

#define COMBAT_MOUNT			10
#define COMBAT_DISMOUNT			11
#define HITWALL					12
	
#using_animtree( "horse" );

main() // self == horse
{
	self UseAnimTree( #animtree );
	self build_horse_anims();
	
	build_aianims( ::setanims );
	build_unload_groups( ::unload_groups );	
	
	// Setup the death anim thread
	level.vehicle_death_thread[ self.vehicleType] = ::horse_death;

	// Set up ride anim custom thread
	//level.vehicle_aianimthread[ "ride" ] = ::ride_anim_custom;
	
	// Shawn J - Sound - adding entity to tag
	//self.soundsnout = spawn ("script_origin", (0,0,0)); 
	//self.soundsnout LinkTo( self, "J_Nose", (0,0,0), (0,0,0) );
	
	// used in client script
	LoadFX("vehicle/treadfx/fx_afgh_treadfx_horse_hoof_impact");

	if ( self.vehicletype == "horse_player" )
	{
		level._effect[ "player_dust_riding_trot" ]	 	= LoadFX( "maps/afghanistan/fx_afgh_dust_riding_trot" );
		level._effect[ "player_dust_riding_gallup" ]	= LoadFX( "maps/afghanistan/fx_afgh_dust_riding_gallup" );

		self thread maps\_horse_player::init();
	}
	
	//precache_rumble();
	//precache_fx();

	self ent_flag_init( "mounting_horse" );
	self ent_flag_init( "dismounting_horse" );
	self ent_flag_init( "playing_scripted_anim" );
	self ent_flag_init( "rearback" );
	
	self thread watch_mounting();
	self thread horse_animating();
	//self thread horse_breathing();

	//self thread debug_horse();
}

precache_models()
{
	precachemodel( "t5_weapon_uzi_viewmodel" );
	//precachemodel( "fx_axis_create_fx" );
}

debug_horse()
{
	self endon( "death" );
	recordEnt( self );

	while ( 1 )
	{
		// Play the animation on the player body
		/*
		org = self gettagOrigin( "tag_driver" );
		angles = self gettagAngles( "tag_driver" );

		if ( !isdefined( self.bone_fxaxis ) )
		{
			self.bone_fxaxis = spawn( "script_model", org );
			self.bone_fxaxis SetModel( "fx_axis_createfx" );
			recordEnt( self.bone_fxaxis );
		}

		if ( isdefined( self.bone_fxaxis ) )
		{
			self.bone_fxaxis.origin = org;
			self.bone_fxaxis.angles = angles;
		}
		*/

		player = get_players()[0];
		is_rearback = ENT_FLAG( self, "rearback" ); 

		if ( player ActionSlotTwoButtonPressed() && !is_rearback )
		{
			self horse_rearback();
		}

		/*
		driver = self get_driver();
		if ( isdefined( driver ) )
		{
			//org = driver gettagOrigin( "tag_weapon" );
			//angles = driver gettagAngles( "tag_weapon" );		

			if ( !isdefined( driver.bone_fxaxis ) )
			{
				driver.bone_fxaxis = spawn( "script_model", org );
				driver.bone_fxaxis SetModel( "fx_axis_createfx" );
				recordEnt( driver.bone_fxaxis );
			}

			if ( isdefined( driver.bone_fxaxis ) )
			{
				driver.bone_fxaxis.origin = org;
				driver.bone_fxaxis.angles = angles;
			}
		}
		*/

		wait( 0.05 );
	}
}


ride_anim_custom( guy, pos )
{
	guy animCustom(::rider_anim_custom_internal);
}

rider_anim_custom_internal()
{
	self endon( "exit_vehicle" );
	
	self.currentAnimation = undefined;
	self.nextAnimation = undefined;
	self.nextAnimBlendTime = 0.2;
	self.nextAnimWeight = 1;
	self.nextAnimRate = 1;
	
	// Temp solution until we have time to support shooting
	while ( 1 ) 
	{
		if ( IsDefined( self.nextAnimation ) )
		{
			play_anim = false;
			if ( IsDefined( self.currentAnimation ) )
			{
				if ( self.currentAnimation != self.nextAnimation )
					play_anim = true;
			}
			else 
			{
				play_anim = true;
			}
			
			if ( play_anim )
			{
				self SetAnimKnobAll( self.nextAnimation, %generic_human::root, self.nextAnimWeight, self.nextAnimBlendTime, self.nextAnimRate );
				self.currentAnimation = self.nextAnimation;
				self.nextAnimation = undefined;
			}				
		}
		
		wait( 0.05 );
	}
}


build_horse_anims() // self == horse
{
	level.REVERSE = 1;
	level.IDLE = 2;
	level.WALK = 3;
	level.TROT = 4;
	level.RUN = 5;
	level.SPRINT = 6;
	level.JUMP = 7;
	level.MOUNT = 8;
	level.DISMOUNT = 9;
	
	self.in_air = false;
	self.idle_state = 0;
	self.idle_anim_finished_state = 0; // the state the horse will be in once the current idle animation is done
	self.current_anim_speed = level.IDLE;
	self.is_horse = true;

	if( IsDefined( level.horse_anims_inited ) )
	{
		return;
	}
		
	level.horse_anims_inited = true;
	
	level.horse_speeds = [];
	level.horse_speeds[level.REVERSE-1] = -5000;
	level.horse_speeds[level.REVERSE] = -2.5;
	level.horse_speeds[level.IDLE] = 0;
	level.horse_speeds[level.WALK] = 3;
	level.horse_speeds[level.TROT] = 8;
	level.horse_speeds[level.RUN] = 16;
	level.horse_speeds[level.SPRINT] = 20;
	level.horse_speeds[level.SPRINT+1] = 5000;
	
	// this is the turn speed at which to fully blend in the turn animations
	level.horse_turn_speeds[level.WALK] = 1;
	level.horse_turn_speeds[level.TROT] = 1;
	level.horse_turn_speeds[level.RUN] = 1;
	level.horse_turn_speeds[level.SPRINT] = 1;
	
	level.horse_anims = [];
	level.horse_ai_anims = [];
	level.horse_player_anims = [];

	level.horse_idles = [];
	level.horse_idles[STAND_IDLE] = SpawnStruct();
	level.horse_idles[STAND_IDLE].animations = [];
	level.horse_idles[STAND_IDLE].ai_animations = [];	
	level.horse_idles[STAND_IDLE].player_animations = [];	
	level.horse_idles[STAND_IDLE].transitions = [];
	level.horse_idles[STAND_IDLE].animations[0] = %a_horse_stand_idle;
	level.horse_idles[STAND_IDLE].animations[1] = %a_horse_stand_idle_twitch_a;
	level.horse_idles[STAND_IDLE].animations[2] = %a_horse_stand_idle_to_right_idle;
	level.horse_idles[STAND_IDLE].ai_animations[0] = %generic_human::ai_horse_rider_stand_idle;
	level.horse_idles[STAND_IDLE].ai_animations[1] = %generic_human::ai_horse_rider_stand_idle_twitch_a;
	level.horse_idles[STAND_IDLE].ai_animations[2] = %generic_human::ai_horse_rider_stand_idle_to_right_idle;
	level.horse_idles[STAND_IDLE].player_animations[0] = %player::int_horse_player_stand_idle;
	level.horse_idles[STAND_IDLE].player_animations[1] = %player::int_horse_player_stand_idle_twitch_a;
	level.horse_idles[STAND_IDLE].player_animations[2] = %player::int_horse_player_stand_idle_to_right_idle;	
	level.horse_idles[STAND_IDLE].transitions[2] = RIGHT_IDLE;
	level.horse_idles[STAND_IDLE].animations[3] = %a_horse_stand_idle_to_forward_idle;
	level.horse_idles[STAND_IDLE].ai_animations[3] = %generic_human::ai_horse_rider_stand_idle_to_forward_idle;	
	level.horse_idles[STAND_IDLE].player_animations[3] = %player::int_horse_player_stand_idle_to_forward_idle;		
	level.horse_idles[STAND_IDLE].transitions[3] = FORWARD_IDLE;
	level.horse_idles[STAND_IDLE].animations[4] = %a_horse_stand_idle_to_wide_idle;
	level.horse_idles[STAND_IDLE].ai_animations[4] = %generic_human::ai_horse_rider_stand_idle_to_wide_idle;	
	level.horse_idles[STAND_IDLE].player_animations[4] = %player::int_horse_player_stand_idle_to_wide_idle;	
	level.horse_idles[STAND_IDLE].transitions[4] = WIDE_IDLE;
	level.horse_idles[STAND_IDLE].animations[5] = %a_horse_stand_idle_to_eat_idle;
	level.horse_idles[STAND_IDLE].ai_animations[5] = %generic_human::ai_horse_rider_stand_idle_to_eat_idle;	
	level.horse_idles[STAND_IDLE].player_animations[5] = %player::int_horse_player_stand_idle_to_eat_idle;		
	level.horse_idles[STAND_IDLE].transitions[5] = EAT_IDLE;
	
	level.horse_idles[RIGHT_IDLE] = SpawnStruct();
	level.horse_idles[RIGHT_IDLE].animations = [];
	level.horse_idles[RIGHT_IDLE].ai_animations = [];
	level.horse_idles[RIGHT_IDLE].player_animations = [];	
	level.horse_idles[RIGHT_IDLE].transitions = [];
	level.horse_idles[RIGHT_IDLE].animations[0] = %a_horse_right_idle;
	level.horse_idles[RIGHT_IDLE].animations[1] = %a_horse_right_idle_to_stand_idle;
	level.horse_idles[RIGHT_IDLE].ai_animations[0] = %generic_human::ai_horse_rider_right_idle;
	level.horse_idles[RIGHT_IDLE].ai_animations[1] = %generic_human::ai_horse_rider_right_idle_to_stand_idle;
	level.horse_idles[RIGHT_IDLE].player_animations[0] = %player::int_horse_player_right_idle;
	level.horse_idles[RIGHT_IDLE].player_animations[1] = %player::int_horse_player_right_idle_to_stand_idle;
	level.horse_idles[RIGHT_IDLE].transitions[1] = STAND_IDLE;
	level.horse_idles[RIGHT_IDLE].animations[2] = %a_horse_right_idle_to_forward_idle;
	level.horse_idles[RIGHT_IDLE].ai_animations[2] = %generic_human::ai_horse_rider_right_idle_to_forward_idle;
	level.horse_idles[RIGHT_IDLE].player_animations[2] = %player::int_horse_player_right_idle_to_forward_idle;	
	level.horse_idles[RIGHT_IDLE].transitions[2] = FORWARD_IDLE;
	
	level.horse_idles[FORWARD_IDLE] = SpawnStruct();
	level.horse_idles[FORWARD_IDLE].animations = [];
	level.horse_idles[FORWARD_IDLE].ai_animations = [];	
	level.horse_idles[FORWARD_IDLE].player_animations = [];		
	level.horse_idles[FORWARD_IDLE].transitions = [];
	level.horse_idles[FORWARD_IDLE].animations[0] = %a_horse_forward_idle;
	level.horse_idles[FORWARD_IDLE].animations[1] = %a_horse_forward_idle_to_right_idle;
	level.horse_idles[FORWARD_IDLE].ai_animations[0] = %generic_human::ai_horse_rider_forward_idle;
	level.horse_idles[FORWARD_IDLE].ai_animations[1] = %generic_human::ai_horse_rider_forward_idle_to_right_idle;	
	level.horse_idles[FORWARD_IDLE].player_animations[0] = %player::int_horse_player_forward_idle;
	level.horse_idles[FORWARD_IDLE].player_animations[1] = %player::int_horse_player_forward_idle_to_right_idle;	
	level.horse_idles[FORWARD_IDLE].transitions[1] = RIGHT_IDLE;
	level.horse_idles[FORWARD_IDLE].animations[2] = %a_horse_forward_idle_to_stand_idle;
	level.horse_idles[FORWARD_IDLE].ai_animations[2] = %generic_human::ai_horse_rider_forward_idle_to_stand_idle;
	level.horse_idles[FORWARD_IDLE].player_animations[2] = %player::int_horse_player_forward_idle_to_stand_idle;	
	level.horse_idles[FORWARD_IDLE].transitions[2] = STAND_IDLE;
	level.horse_idles[FORWARD_IDLE].animations[3] = %a_horse_forward_idle_to_eat_idle;
	level.horse_idles[FORWARD_IDLE].ai_animations[3] = %generic_human::ai_horse_rider_forward_idle_to_eat_idle;
	level.horse_idles[FORWARD_IDLE].player_animations[3] = %player::int_horse_player_forward_idle_to_eat_idle;	
	level.horse_idles[FORWARD_IDLE].transitions[3] = EAT_IDLE;
	
	level.horse_idles[WIDE_IDLE] = SpawnStruct();
	level.horse_idles[WIDE_IDLE].animations = [];
	level.horse_idles[WIDE_IDLE].ai_animations = [];	
	level.horse_idles[WIDE_IDLE].player_animations = [];		
	level.horse_idles[WIDE_IDLE].transitions = [];
	level.horse_idles[WIDE_IDLE].animations[0] = %a_horse_wide_idle;
	level.horse_idles[WIDE_IDLE].animations[1] = %a_horse_wide_idle_twitch_a;
	level.horse_idles[WIDE_IDLE].animations[2] = %a_horse_wide_idle_to_forward_idle;
	level.horse_idles[WIDE_IDLE].ai_animations[0] = %generic_human::ai_horse_rider_wide_idle;
	level.horse_idles[WIDE_IDLE].ai_animations[1] = %generic_human::ai_horse_rider_wide_idle_twitch_a;
	level.horse_idles[WIDE_IDLE].ai_animations[2] = %generic_human::ai_horse_rider_wide_idle_to_forward_idle;
	level.horse_idles[WIDE_IDLE].player_animations[0] = %player::int_horse_player_wide_idle;
	level.horse_idles[WIDE_IDLE].player_animations[1] = %player::int_horse_player_wide_idle_twitch_a;
	level.horse_idles[WIDE_IDLE].player_animations[2] = %player::int_horse_player_wide_idle_to_forward_idle;
	level.horse_idles[WIDE_IDLE].transitions[2] = FORWARD_IDLE;
	level.horse_idles[WIDE_IDLE].animations[3] = %a_horse_wide_idle_to_frisky_idle;
	level.horse_idles[WIDE_IDLE].ai_animations[3] = %generic_human::ai_horse_rider_wide_idle_to_frisky_idle;
	level.horse_idles[WIDE_IDLE].player_animations[3] = %player::int_horse_player_wide_idle_to_frisky_idle;	
	level.horse_idles[WIDE_IDLE].transitions[3] = FRISKY_IDLE;
	level.horse_idles[WIDE_IDLE].animations[4] = %a_horse_wide_idle_to_right_idle;
	level.horse_idles[WIDE_IDLE].ai_animations[4] = %generic_human::ai_horse_rider_wide_idle_to_right_idle;
	level.horse_idles[WIDE_IDLE].player_animations[4] = %player::int_horse_player_wide_idle_to_right_idle;	
	level.horse_idles[WIDE_IDLE].transitions[4] = RIGHT_IDLE;
	
	level.horse_idles[FRISKY_IDLE] = SpawnStruct();
	level.horse_idles[FRISKY_IDLE].animations = [];
	level.horse_idles[FRISKY_IDLE].ai_animations = [];	
	level.horse_idles[FRISKY_IDLE].player_animations = [];		
	level.horse_idles[FRISKY_IDLE].transitions = [];
	level.horse_idles[FRISKY_IDLE].animations[0] = %a_horse_frisky_idle;
	level.horse_idles[FRISKY_IDLE].animations[1] = %a_horse_frisky_idle_twitch_a;
	level.horse_idles[FRISKY_IDLE].animations[2] = %a_horse_frisky_idle_twitch_b;
	level.horse_idles[FRISKY_IDLE].animations[3] = %a_horse_frisky_idle_twitch_c;
	level.horse_idles[FRISKY_IDLE].animations[4] = %a_horse_frisky_idle_to_wide_idle;
	level.horse_idles[FRISKY_IDLE].ai_animations[0] = %generic_human::ai_horse_rider_frisky_idle;
	level.horse_idles[FRISKY_IDLE].ai_animations[1] = %generic_human::ai_horse_rider_frisky_idle_twitch_a;
	level.horse_idles[FRISKY_IDLE].ai_animations[2] = %generic_human::ai_horse_rider_frisky_idle_twitch_b;
	level.horse_idles[FRISKY_IDLE].ai_animations[3] = %generic_human::ai_horse_rider_frisky_idle_twitch_c;
	level.horse_idles[FRISKY_IDLE].ai_animations[4] = %generic_human::ai_horse_rider_frisky_idle_to_wide_idle;
	level.horse_idles[FRISKY_IDLE].player_animations[0] = %player::int_horse_player_frisky_idle;
	level.horse_idles[FRISKY_IDLE].player_animations[1] = %player::int_horse_player_frisky_idle_twitch_a;
	level.horse_idles[FRISKY_IDLE].player_animations[2] = %player::int_horse_player_frisky_idle_twitch_b;
	level.horse_idles[FRISKY_IDLE].player_animations[3] = %player::int_horse_player_frisky_idle_twitch_c;
	level.horse_idles[FRISKY_IDLE].player_animations[4] = %player::int_horse_player_frisky_idle_to_wide_idle;
	level.horse_idles[FRISKY_IDLE].transitions[4] = WIDE_IDLE;
	
	level.horse_idles[EAT_IDLE] = SpawnStruct();
	level.horse_idles[EAT_IDLE].animations = [];
	level.horse_idles[EAT_IDLE].ai_animations = [];	
	level.horse_idles[EAT_IDLE].player_animations = [];		
	level.horse_idles[EAT_IDLE].transitions = [];
	level.horse_idles[EAT_IDLE].animations[0] = %a_horse_eat_idle;
	level.horse_idles[EAT_IDLE].animations[1] = %a_horse_eat_idle_twitch_a;
	level.horse_idles[EAT_IDLE].animations[2] = %a_horse_eat_idle_twitch_b;
	level.horse_idles[EAT_IDLE].animations[3] = %a_horse_eat_idle_to_eat_idle_b;
	level.horse_idles[EAT_IDLE].ai_animations[0] = %generic_human::ai_horse_rider_eat_idle;
	level.horse_idles[EAT_IDLE].ai_animations[1] = %generic_human::ai_horse_rider_eat_idle_twitch_a;
	level.horse_idles[EAT_IDLE].ai_animations[2] = %generic_human::ai_horse_rider_eat_idle_twitch_b;
	level.horse_idles[EAT_IDLE].ai_animations[3] = %generic_human::ai_horse_rider_eat_idle_to_eat_idle_b;
	level.horse_idles[EAT_IDLE].player_animations[0] = %player::int_horse_player_eat_idle;
	level.horse_idles[EAT_IDLE].player_animations[1] = %player::int_horse_player_eat_idle_twitch_a;
	level.horse_idles[EAT_IDLE].player_animations[2] = %player::int_horse_player_eat_idle_twitch_b;
	level.horse_idles[EAT_IDLE].player_animations[3] = %player::int_horse_player_eat_idle_to_eat_idle_b;	
	level.horse_idles[EAT_IDLE].transitions[3] = EAT_IDLE_B;
	level.horse_idles[EAT_IDLE].animations[4] = %a_horse_eat_idle_to_stand_idle;
	level.horse_idles[EAT_IDLE].ai_animations[4] = %generic_human::ai_horse_rider_eat_idle_to_stand_idle;
	level.horse_idles[EAT_IDLE].player_animations[4] = %player::int_horse_player_eat_idle_to_stand_idle;	
	level.horse_idles[EAT_IDLE].transitions[4] = STAND_IDLE;
	level.horse_idles[EAT_IDLE].animations[5] = %a_horse_eat_idle_to_wide_idle;
	level.horse_idles[EAT_IDLE].ai_animations[5] = %generic_human::ai_horse_rider_eat_idle_to_wide_idle;
	level.horse_idles[EAT_IDLE].player_animations[5] = %player::int_horse_player_eat_idle_to_wide_idle;	
	level.horse_idles[EAT_IDLE].transitions[5] = WIDE_IDLE;
	
	level.horse_idles[EAT_IDLE_B] = SpawnStruct();
	level.horse_idles[EAT_IDLE_B].animations = [];
	level.horse_idles[EAT_IDLE_B].ai_animations = [];	
	level.horse_idles[EAT_IDLE_B].player_animations = [];		
	level.horse_idles[EAT_IDLE_B].transitions = [];
	level.horse_idles[EAT_IDLE_B].animations[0] = %a_horse_eat_idle_b;
	level.horse_idles[EAT_IDLE_B].animations[1] = %a_horse_eat_idle_b_twitch_a;
	level.horse_idles[EAT_IDLE_B].animations[2] = %a_horse_eat_idle_b_twitch_b;
	level.horse_idles[EAT_IDLE_B].animations[3] = %a_horse_eat_idle_b_twitch_c;
	level.horse_idles[EAT_IDLE_B].animations[4] = %a_horse_eat_idle_b_to_eat_idle;
	level.horse_idles[EAT_IDLE_B].ai_animations[0] = %generic_human::ai_horse_rider_eat_idle_b;
	level.horse_idles[EAT_IDLE_B].ai_animations[1] = %generic_human::ai_horse_rider_eat_idle_b_twitch_a;
	level.horse_idles[EAT_IDLE_B].ai_animations[2] = %generic_human::ai_horse_rider_eat_idle_b_twitch_b;
	level.horse_idles[EAT_IDLE_B].ai_animations[3] = %generic_human::ai_horse_rider_eat_idle_b_twitch_c;
	level.horse_idles[EAT_IDLE_B].ai_animations[4] = %generic_human::ai_horse_rider_eat_idle_b_to_eat_idle;		
	level.horse_idles[EAT_IDLE_B].player_animations[0] = %player::int_horse_player_eat_idle_b;
	level.horse_idles[EAT_IDLE_B].player_animations[1] = %player::int_horse_player_eat_idle_b_twitch_a;
	level.horse_idles[EAT_IDLE_B].player_animations[2] = %player::int_horse_player_eat_idle_b_twitch_b;
	level.horse_idles[EAT_IDLE_B].player_animations[3] = %player::int_horse_player_eat_idle_b_twitch_c;
	level.horse_idles[EAT_IDLE_B].player_animations[4] = %player::int_horse_player_eat_idle_b_to_eat_idle;	
	level.horse_idles[EAT_IDLE_B].transitions[4] = EAT_IDLE;
	level.horse_idles[EAT_IDLE_B].animations[5] = %a_horse_eat_idle_b_to_stand_idle;
	level.horse_idles[EAT_IDLE_B].ai_animations[5] = %generic_human::ai_horse_rider_eat_idle_b_to_stand_idle;
	level.horse_idles[EAT_IDLE_B].player_animations[5] = %player::int_horse_player_eat_idle_b_to_stand_idle;	
	level.horse_idles[EAT_IDLE_B].transitions[5] = STAND_IDLE;

	
	//-----------------------------------------------------------------	


	level.horse_anims[level.REVERSE] = %a_horse_walk_b;

	level.horse_anims[level.IDLE] = [];
	level.horse_anims[level.IDLE][0] = %a_horse_stand_idle;
	level.horse_anims[level.IDLE][1] = %a_horse_idle_turn_l;
	level.horse_anims[level.IDLE][2] = %a_horse_idle_turn_r;
	
	level.horse_anims[level.WALK] = [];
	level.horse_anims[level.WALK][0] = %a_horse_walk_f;
	level.horse_anims[level.WALK][1] = %a_horse_walk_left;
	level.horse_anims[level.WALK][2] = %a_horse_walk_right;

	level.horse_anims[level.TROT] = [];
	level.horse_anims[level.TROT][0] = %a_horse_trot_f;
	level.horse_anims[level.TROT][1] = %a_horse_trot_left;
	level.horse_anims[level.TROT][2] = %a_horse_trot_right;
	
	level.horse_anims[level.RUN] = [];
	level.horse_anims[level.RUN][0] = %a_horse_canter_f;
	level.horse_anims[level.RUN][1] = %a_horse_canter_left;
	level.horse_anims[level.RUN][2] = %a_horse_canter_right;

	level.horse_anims[level.SPRINT] = [];
	level.horse_anims[level.SPRINT][0] = %a_horse_sprint_f;
	level.horse_anims[level.SPRINT][1] = %a_horse_sprint_left;
	level.horse_anims[level.SPRINT][2] = %a_horse_sprint_right;
	
	level.horse_anims[level.JUMP][0] = %a_horse_jump_init;
	level.horse_anims[level.JUMP][1] = %a_horse_jump_midair;
	level.horse_anims[level.JUMP][2] = %a_horse_jump_land_from_above;
	
	level.horse_anims[level.MOUNT][0] = %a_horse_get_on_leftside;
	level.horse_anims[level.MOUNT][1] = %a_horse_get_on_rightside;	
	level.horse_anims[level.DISMOUNT][0] = %a_horse_get_off_leftside;
	level.horse_anims[level.DISMOUNT][1] = %a_horse_get_off_rightside;

	level.horse_anims[COMBAT_MOUNT][0] = %a_horse_get_on_combat_leftside;
	level.horse_anims[COMBAT_MOUNT][1] = %a_horse_get_on_combat_rightside;
	level.horse_anims[COMBAT_DISMOUNT][0] = %a_horse_get_off_combat_leftside;
	level.horse_anims[COMBAT_DISMOUNT][1] = %a_horse_get_off_combat_rightside;
	
	level.horse_anims[HITWALL] = %a_horse_hitwall;

	// AI Anims -------------------------------------------------------	
	
	
	level.horse_ai_anims[level.REVERSE] = %generic_human::ai_horse_rider_walk_b;

	level.horse_ai_anims[level.IDLE] = [];
	level.horse_ai_anims[level.IDLE][0] = %generic_human::ai_horse_rider_stand_idle;
	level.horse_ai_anims[level.IDLE][1] = %generic_human::ai_horse_rider_idle_turn_l;
	level.horse_ai_anims[level.IDLE][2] = %generic_human::ai_horse_rider_idle_turn_r;
	
	level.horse_ai_anims[level.WALK] = [];
	level.horse_ai_anims[level.WALK][0] = %generic_human::ai_horse_rider_walk_f;
	level.horse_ai_anims[level.WALK][1] = %generic_human::ai_horse_rider_walk_left;
	level.horse_ai_anims[level.WALK][2] = %generic_human::ai_horse_rider_walk_right;

	level.horse_ai_anims[level.TROT] = [];
	level.horse_ai_anims[level.TROT][0] = %generic_human::ai_horse_rider_trot_f;
	level.horse_ai_anims[level.TROT][1] = %generic_human::ai_horse_rider_trot_left;
	level.horse_ai_anims[level.TROT][2] = %generic_human::ai_horse_rider_trot_right;
	
	level.horse_ai_anims[level.RUN] = [];
	level.horse_ai_anims[level.RUN][0] = %generic_human::ai_horse_rider_canter_f;
	level.horse_ai_anims[level.RUN][1] = %generic_human::ai_horse_rider_canter_left;
	level.horse_ai_anims[level.RUN][2] = %generic_human::ai_horse_rider_canter_right;

	level.horse_ai_anims[level.SPRINT] = [];
	level.horse_ai_anims[level.SPRINT][0] = %generic_human::ai_horse_rider_sprint_f;
	level.horse_ai_anims[level.SPRINT][1] = %generic_human::ai_horse_rider_sprint_left;
	level.horse_ai_anims[level.SPRINT][2] = %generic_human::ai_horse_rider_sprint_right;
	
	level.horse_ai_anims[level.JUMP][0] = %generic_human::ai_horse_rider_jump_init;
	level.horse_ai_anims[level.JUMP][1] = %generic_human::ai_horse_rider_jump_midair;
	level.horse_ai_anims[level.JUMP][2] = %generic_human::ai_horse_rider_jump_land_from_above;	

	level.horse_ai_anims[HITWALL] = %generic_human::ai_horse_rider_hitwall;
	
	// Player Anims ---------------------------------------------------
	
	
	level.horse_player_anims[level.REVERSE] = %player::int_horse_player_walk_b;

	level.horse_player_anims[level.IDLE] = [];
	level.horse_player_anims[level.IDLE][0] = %player::int_horse_player_stand_idle;
	level.horse_player_anims[level.IDLE][1] = %player::int_horse_player_idle_turn_l;
	level.horse_player_anims[level.IDLE][2] = %player::int_horse_player_idle_turn_r;
	
	level.horse_player_anims[level.WALK] = [];
	level.horse_player_anims[level.WALK][0] = %player::int_horse_player_walk_f;
	level.horse_player_anims[level.WALK][1] = %player::int_horse_player_walk_left;
	level.horse_player_anims[level.WALK][2] = %player::int_horse_player_walk_right;

	level.horse_player_anims[level.TROT] = [];
	level.horse_player_anims[level.TROT][0] = %player::int_horse_player_trot_f;
	level.horse_player_anims[level.TROT][1] = %player::int_horse_player_trot_left;
	level.horse_player_anims[level.TROT][2] = %player::int_horse_player_trot_right;
	
	level.horse_player_anims[level.RUN] = [];
	level.horse_player_anims[level.RUN][0] = %player::int_horse_player_canter_f;
	level.horse_player_anims[level.RUN][1] = %player::int_horse_player_canter_left;
	level.horse_player_anims[level.RUN][2] = %player::int_horse_player_canter_right;

	level.horse_player_anims[level.SPRINT] = [];
	level.horse_player_anims[level.SPRINT][0] = %player::int_horse_player_sprint_f;
	level.horse_player_anims[level.SPRINT][1] = %player::int_horse_player_sprint_left;
	level.horse_player_anims[level.SPRINT][2] = %player::int_horse_player_sprint_right;
	
	level.horse_player_anims[level.JUMP][0] = %player::int_horse_player_jump_init;
	level.horse_player_anims[level.JUMP][1] = %player::int_horse_player_jump_midair;
	level.horse_player_anims[level.JUMP][2] = %player::int_horse_player_jump_land_from_above;
	
	level.horse_player_anims[level.MOUNT][0] = %player::int_horse_player_get_on_leftside;
	level.horse_player_anims[level.MOUNT][1] = %player::int_horse_player_get_on_rightside;	
	level.horse_player_anims[level.DISMOUNT][0] = %player::int_horse_player_get_off_leftside;
	level.horse_player_anims[level.DISMOUNT][1] = %player::int_horse_player_get_off_rightside;	
	
	level.horse_player_anims[COMBAT_MOUNT][0] = %player::int_horse_player_get_on_combat_leftside;
	level.horse_player_anims[COMBAT_MOUNT][1] = %player::int_horse_player_get_on_combat_rightside;
	level.horse_player_anims[COMBAT_DISMOUNT][0] = %player::int_horse_player_get_off_combat_leftside;
	level.horse_player_anims[COMBAT_DISMOUNT][1] = %player::int_horse_player_get_off_combat_rightside;
	
	level.horse_player_anims[HITWALL] = %player::int_horse_rider_hitwall;

	//-----------------------------------------------------------------		

	
	const GALLOPING = 0;
	const GALLOPING_FACE_PLANT = 1;
	const STANDING_SLOW = 2;
	const STANDING_FAST = 3;
	
	level.horse_deaths = [];
	level.horse_deaths[GALLOPING] = SpawnStruct();
	level.horse_deaths[GALLOPING].animation = %a_horse_death_galloping;
	level.horse_deaths[GALLOPING].ai_animation = %generic_human::ai_horse_rider_death_galloping;
	level.horse_deaths[GALLOPING].player_animation = %player::int_horse_player_death_galloping;
	
	level.horse_deaths[GALLOPING_FACE_PLANT] = SpawnStruct();
	level.horse_deaths[GALLOPING_FACE_PLANT].animation = %a_horse_death_galloping_faceplant;
	level.horse_deaths[GALLOPING_FACE_PLANT].ai_animation = %generic_human::ai_horse_rider_death_galloping_faceplant;
	level.horse_deaths[GALLOPING_FACE_PLANT].player_animation = %player::int_horse_player_death_galloping_faceplant;
	
	level.horse_deaths[STANDING_SLOW] = SpawnStruct();
	level.horse_deaths[STANDING_SLOW].animation = %a_horse_death_standing_slow;
	level.horse_deaths[STANDING_SLOW].ai_animation = %generic_human::ai_horse_rider_death_standing_slow;
	level.horse_deaths[STANDING_SLOW].player_animation = %player::int_horse_player_death_standing_slow;
	
	level.horse_deaths[STANDING_FAST] = SpawnStruct();
	level.horse_deaths[STANDING_FAST].animation = %a_horse_death_standing_fast;
	level.horse_deaths[STANDING_FAST].ai_animation = %generic_human::ai_horse_rider_death_standing_fast;
	level.horse_deaths[STANDING_FAST].player_animation = %player::int_horse_player_death_standing_fast;	
}

set_vehicle_anims( positions )
{   
	
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "driver" ] = [];

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	
	group = "driver";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
}

precache_rumble()
{
	PreCacheRumble("horse_gallop_h");
	PreCacheRumble("horse_gallop_l");	
}

precache_fx()
{
	// getting this ready for if someone wants to change it, it needs to be precached
	level._effect["player_wind"] = LoadFX("bio/animals/fx_horse_riding_wind");
}

set_wind_effect(fx_name)
{
	assert(IsDefined(fx_name), "Please specify an fx name.");
	level._effect["player_wind"] = LoadFX(fx_name);
}

set_visionset_idle(visionset_name, visionset_fade) // self == horse
{
	assert(IsDefined(visionset_name), "Please specify a vision set name.");
	assert(IsDefined(visionset_fade), "Please specify a vision set fade time.");
	self.visionset_idle = visionset_name;
	self.visionset_idle_fade = visionset_fade;
}

set_visionset_run(visionset_name, visionset_fade) // self == horse
{
	assert(IsDefined(visionset_name), "Please specify a vision set name.");
	assert(IsDefined(visionset_fade), "Please specify a vision set fade time.");
	self.visionset_run = visionset_name;
	self.visionset_run_fade = visionset_fade;
}

// Shawn J Sound - Using the horse's speed to scale the wait time between hoof hits

scale_wait(x1,x2,y1,y2,z)
{
	if ( z < x1)
		z = x1;
	if ( z > x2)
		z = x2;

	dx = x2 - x1;
	n = ( z - x1) / dx;
	dy = y2 - y1;
	w = (n*dy + y1);

	return w;
}

// Shawn J Sound - Setting the values & parameters of the linear step function

get_wait()
{
	const min_speed = 1;
	const max_speed = 50;
	const min_wait = .088;
	const max_wait = .2;

	speed = self GetSpeedMPH();
	abs_speed = abs(int(speed));
	wait_time = scale_wait(min_speed, max_speed, max_wait, min_wait, abs_speed);
	// iprintlnbold( "Wait: " + wait_time + " Speed: " + abs_speed );
	return wait_time;
}

// Shawn J Sound - Gallop sound

gallop_driving() // self == horse
{
	self endon("death");
	self endon("no_driver");

	while(1)
	{
		if(abs(self GetSpeed()) < 0.1)
		{
			wait 0.01;
		}
		else if(abs(self GetSpeed()) >= 0.1)
		{
			if((self GetSpeedMPH()) < 22)
				// Shawn J Sound - Trot
			{
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_t_plr_01" );
				}
				wait( ( self get_wait() * 1.3) );
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_t_plr_02" );
				}
				wait( ( self get_wait() * 1.3) );
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_t_plr_03" );
				}
				wait( ( self get_wait() * 1.3) );			
				//iprintlnbold( "Trotting!" );					
			}		

			else if((self GetSpeedMPH() >= 22))
				// Shawn J Sound - Gallop
			{
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_g_plr_01" );
				}
				wait( ( self get_wait() ) );
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_g_plr_02" );
				}
				wait( ( self get_wait() ) );
				if (!self.isjumping)
				{
					self playsound( "fly_gear_run_plr" );
				}
				if (!self.isjumping)
				{
					self playsound( "fly_horse_hoofhit_g_plr_03" );
				}
				wait( ( self get_wait() ) * 2 );
			}
		}
	}
}

horse_rumble() 
{
	self endon("death");
	self endon("no_driver");
	
	rumble_wait_time = [];
	rumble_wait_time[ level.IDLE ] = -1;
	rumble_wait_time[ level.WALK ] = 0.5;
	rumble_wait_time[ level.TROT ] = 0.5;	
	rumble_wait_time[ level.RUN ] = 0.5;		
	rumble_wait_time[ level.SPRINT ] = 0.5;			
	
	while( 1 )
	{
		if ( self.current_anim_speed <= level.sprint && self.current_anim_speed > level.IDLE )
		{
			wait_time = rumble_wait_time[ self.current_anim_speed ];
			
			self.driver PlayRumbleOnEntity("damage_light");			
			//Earthquake(0.14, 0.3, self.origin, 200, self);			
			
			wait(wait_time);			
		}
		else
		{
			wait(0.05);
		}
	}
}

wind_driving() // self == horse
{
	self endon("death");
	self endon("no_driver");
	
	player_offset = (0, 0, 56);

	while(true)
	{
		while((self GetSpeedMPH()) >= self.speed_run)
		{
			PlayFX(level._effect["player_wind"], self.driver.origin + player_offset);
			wait(0.3);
		}

		wait(0.05);
	}
}

horse_breathing() // self == horse
{
	self endon("death");

	// toggle exhaust on/off to look like breathing
	while(true)
	{
		// get the speed and scale the breathing time for running and idle
		speed = self GetSpeedMPH();
		if(speed <= self.speed_idle)
		{
			speed = 1;
		}

		wait_time = 1.5 / speed;
		wait(wait_time);
		self veh_toggle_exhaust_fx(1);
		//Shawn J - Sound - adding sound to breath - harder breathing for faster speed
		if(wait_time >= 1.5)
		{
			self.soundsnout playsound ("chr_horse_breath_i_mono");	
		}	
		else if(wait_time < 1.5)
		{
			self.soundsnout playsound ("chr_horse_breath_t_mono");	
		}						
		// stop the breathing earlier so it looks more realistic
		wait(1);
		self veh_toggle_exhaust_fx(0);
	}
}

update_idle_anim()
{
	if( self.current_anim_speed != level.IDLE )
	{
		self.idle_state = 0;
	}
		
	if( self.current_anim_speed != level.IDLE || gettime() >= self.idle_end_time )
	{
		if( self.current_anim_speed == level.IDLE )
		{
			self.idle_state = self.idle_anim_finished_state;
		}
		
		idle_struct = level.horse_idles[ self.idle_state ];
		anim_index = RandomInt( idle_struct.animations.size );

		// if the player is riding the horse only choose stand_idle or wide_idle
		driver = self get_driver();
		if ( isdefined( driver ) )
		{
			if ( !IsAI( driver ) )
			{
				if ( RandomInt( 100 ) > 50 )
				{
					idle_struct = level.horse_idles[ STAND_IDLE ];
				}
				else
				{
					idle_struct = level.horse_idles[ WIDE_IDLE ];
				}
				anim_index = 0;
			}
		}

		/*
		if ( true )
		{
			if ( RandomInt( 100 ) > 50 )
			{
				idle_struct = level.horse_idles[ STAND_IDLE ];
			}
			else
			{
				idle_struct = level.horse_idles[ WIDE_IDLE ];
			}
			anim_index = 3;
		}
		*/

		idle_anim = idle_struct.animations[ anim_index ];
		idle_ai_anim = idle_struct.ai_animations[ anim_index ];
		idle_player_anim = idle_struct.player_animations[ anim_index ];
		
		if( IsDefined( idle_struct.transitions[ anim_index ] ) )
		{
			self.idle_anim_finished_state = idle_struct.transitions[ anim_index ];
		}
		else
		{
			self.idle_anim_finished_state = self.idle_state;
		}
		
		self.idle_end_time = gettime() + GetAnimLength( idle_anim ) * 1000;
		
		self SetAnimKnobAllRestart( idle_anim, %horse::root, 1, 0.2, 1 );
		
		if ( IsDefined( driver ) )
		{
			if ( !IsAI( driver ) )
			{
				//driver SetAnimKnobAllRestart( idle_player_anim, %player::root, 1, 0.2, 1 );
				driver.nextAnimation = idle_player_anim;
			}
			else 
			{
				// So that anim custom can switch anims
				driver.nextAnimation = idle_ai_anim;
				driver.nextAnimRate = 1;
			}
		}
		else
		{
			self.rider_nextAnimation= idle_ai_anim;
			self.player_nextAnimation = idle_player_anim;
		}
	}
	
	self.current_anim_speed = level.IDLE;
}

horse_rearback()
{
	self endon( "death" );

	self ent_flag_set( "rearback" );

	driver = self get_driver();
	if ( IsDefined( driver ) )
	{
		if ( !IsAI( driver ) )
		{
			driver thread maps\_horse_player::player_rearback( level.horse_player_anims[HITWALL] );
		}
	}

	self SetAnimKnobAll( level.horse_anims[HITWALL], %horse::root, 1, 0.2, 1 );
	len = GetAnimLength( level.horse_anims[HITWALL] );
	wait( len );

	self.idle_end_time = gettime();

	self ent_flag_clear( "rearback" );
}

horse_animating() // self == horse
{
	self endon("death");

	wait .5;
	
	self.idle_end_time = 0;

	while( true )
	{
		speed = self GetSpeedMPH();
		angular_velocity = self GetAngularVelocity();
		turning_speed = abs( angular_velocity[2] );
		
		//iprintlnbold( "Speed: " + speed + " Avel: " + angular_velocity[2] );
		
		//-- made ENT_FLAG macro at the top of the file, since this runs so often
		if( ENT_FLAG( self, "mounting_horse" ) || ENT_FLAG( self, "dismounting_horse" ) || ENT_FLAG( self, "playing_scripted_anim") ||
			ENT_FLAG( self, "rearback" ) )
		{   	
		}
		else if( self.in_air )	// jump or fall, jump thread will take care of animating this
		{
		}
		else if( speed < -0.05 )	// reverse
		{
			self.current_anim_speed = level.REVERSE;
		
			anim_rate = speed / level.horse_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.5, 1.5 );
			
			self SetAnimKnobAll( level.horse_anims[level.REVERSE], %horse::root, 1, 0.2, anim_rate );
			
			driver = self get_driver();
			if( IsDefined( driver ) )
			{
				if ( !IsAI( driver ) )
				{
					//driver SetAnimKnobAll( level.horse_player_anims[level.REVERSE], %player::root, 1, 0.2, anim_rate );
					driver.nextAnimation = level.horse_player_anims[level.REVERSE];
				}
				else
				{
					driver.nextAnimation = level.horse_ai_anims[level.REVERSE];
				}
			}
				
		}
		else if( speed < 2 && turning_speed > 0.2 )	// turning idle
		{
			anim_rate = turning_speed;
			//anim_rate = 1;
			if( angular_velocity[2] > 0 )
			{
				self SetAnimKnobAll( level.horse_anims[level.IDLE][1], %horse::root, 1, 0.2, anim_rate );
			
				driver = self get_driver();
				if( IsDefined( driver ) )
				{
					if ( !IsAI( driver ) )
					{
						//driver SetAnimKnobAll( level.horse_player_anims[level.IDLE][1], %player::root, 1, 0.2, anim_rate );
						driver.nextAnimation = level.horse_player_anims[level.IDLE][1];
					}
					else
					{
						driver.nextAnimation = level.horse_ai_anims[level.IDLE][1];
					}
				}				
			}
			else
			{
				self SetAnimKnobAll( level.horse_anims[level.IDLE][2], %horse::root, 1, 0.2, anim_rate );
				
				driver = self get_driver();
				if( IsDefined( driver ) )
				{
					if ( !IsAI( driver ) )
					{
						//driver SetAnimKnobAll( level.horse_player_anims[level.IDLE][2], %player::root, 1, 0.2, anim_rate );
						driver.nextAnimation = level.horse_player_anims[level.IDLE][2];
					}
					else
					{
						driver.nextAnimation = level.horse_ai_anims[level.IDLE][2];
					}
				}					
			}
			self.current_anim_speed = level.IDLE;
			self.idle_end_time = 0;
		}
		else if( speed < 0.05 )	// Idle
		{	
			update_idle_anim();
		}
		else	// Running
		{
			next_anim_delta = level.horse_speeds[self.current_anim_speed + 1] - level.horse_speeds[self.current_anim_speed];
			next_anim_speed = level.horse_speeds[self.current_anim_speed] + next_anim_delta * 0.6;
			
			prev_anim_delta = level.horse_speeds[self.current_anim_speed] - level.horse_speeds[self.current_anim_speed - 1];
			prev_anim_speed = level.horse_speeds[self.current_anim_speed] - prev_anim_delta * 0.6;

			if( speed > next_anim_speed )
			{
				self.current_anim_speed++;
			}
			else if( speed < prev_anim_speed )
			{
				self.current_anim_speed--;
			}
		
			if( self.current_anim_speed	<= level.IDLE )
			{
				self.current_anim_speed = level.WALK;
			}
			
			anim_rate = speed / level.horse_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.5, 1.35 );
				
			//self.current_anim_speed = 4;
			//anim_rate = 1;
			//iprintlnbold( "Horse anim: " + self.current_anim_speed + " Rate: " + anim_rate );
			
			/* 
			// Turn anims
			anim_turn_rate = level.horse_turn_speeds[self.current_anim_speed];
			
			center_weight = 1;
			left_weight = 0;
			right_weight = 0;
			
			if( angular_velocity[2] > 0.01 ) // turning left
			{
				left_weight = angular_velocity[2] / anim_turn_rate;
				left_weight = clamp( left_weight, 0.0, 1.0 );
				center_weight = 1.0 - left_weight;
			}
			else if( angular_velocity[2] < -0.01 ) // turning right
			{
				right_weight = -angular_velocity[2] / anim_turn_rate;
				right_weight = clamp( right_weight, 0.0, 1.0 );
				center_weight = 1.0 - right_weight;
			}
			
			self SetAnimKnobAll( level.horse_anims[self.current_anim_speed][0], %root, center_weight, 0.2, anim_rate );
			self SetAnim( level.horse_anims[self.current_anim_speed][1], left_weight, 0.2, anim_rate );
			self SetAnim( level.horse_anims[self.current_anim_speed][2], right_weight, 0.2, anim_rate );
			*/
			self SetAnimKnobAll( level.horse_anims[self.current_anim_speed][0], get_horse_root(), 1, 0.2, anim_rate );
			
			driver = self get_driver();
			if( IsDefined( driver ) )
			{
				// Player
				if ( !IsAI( driver ) )
				{
					//driver SetAnimKnobAll( level.horse_player_anims[self.current_anim_speed][0], %player::root, 1, 0.2, anim_rate );
					driver.nextAnimation = level.horse_player_anims[self.current_anim_speed][0];

					//driver thread update_horse_fx( self.current_anim_speed );
				}
				else
				{
					driver.nextAnimation = level.horse_ai_anims[self.current_anim_speed][0];
					driver.nextAnimRate = anim_rate;
				}
			}
		}
		
		wait(0.05);
	}
}

update_horse_fx( speed )
{
	if ( !isdefined( self.current_fx_speed ) )
	{
		self.current_fx_speed = speed;
	}
	else
	{
		if ( self.current_fx_speed == speed )
		{
			return;
		}
		else
		{
			self.current_fx_speed = speed;
		}
	}

	player = get_players()[0];
	if ( speed == level.TROT )
	{
		player thread horse_fx( "player_dust_riding_trot" );
	}
	else if ( speed == level.RUN || speed == level.SPRINT )
	{
		player thread horse_fx( "player_dust_riding_gallup");
	}
	else
	{
		player thread horse_fx();
	}

}

horse_fx( fx_name )
{
	if ( isdefined( self.current_fx ) )
	{
		self.current_fx unlink();
		self.current_fx delete();
	}

	if ( isdefined( fx_name ) )
	{
		self.current_fx = Spawn( "script_model", self.origin );
		self.current_fx.angles = self.angles;
		self.current_fx LinkTo( self );
		self.current_fx SetModel( "tag_origin" );
		PlayFxOnTag( level._effect[ fx_name ], self.current_fx, "tag_origin" );
	}
}

horse_death()
{
	self endon( "death_finished" );

	self CancelAIMove();
	self ClearVehGoalPos();
	
	death_anim = undefined;
	death_ai_anim = undefined;
	if ( IsDefined( self.current_anim_speed ) )
	{
		if ( self.current_anim_speed == level.IDLE )
		{
			if ( RandomIntRange( 1, 100 ) < 50 )
			{
				death_anim = level.horse_deaths[2].animation;
				death_ai_anim = level.horse_deaths[2].ai_animation;
			}
			else 
			{
				death_anim = level.horse_deaths[3].animation;		
				death_ai_anim = level.horse_deaths[3].ai_animation;
			}
		}
		else if ( self.current_anim_speed < level.SPRINT )
		{
			death_anim = level.horse_deaths[0].animation;
			death_ai_anim = level.horse_deaths[0].ai_animation;
		}
		else 
		{
			death_anim = level.horse_deaths[1].animation;			
			death_ai_anim = level.horse_deaths[1].ai_animation;			
		}
	}
	
	if ( IsDefined( death_anim ) )
	{
		self SetAnimKnobAll( death_anim, %horse::root, 1, 0.2, 1 );
		
		driver = self get_driver();
		if( IsDefined( driver ) )
		{
			// Player
			if ( IsAI( driver ) )
			{
				driver.nextAnimation = death_ai_anim;
				driver.nextAnimRate = 1;
			}
		}	
	}
	
	self SetBrake( true );
	
	speed = self GetSpeedMPH();
	while ( speed > 2 && IsDefined(self) )
	{
		forward = AnglesToForward( self.angles );
		self LaunchVehicle( forward * -200 * 0.05 );
		speed = self GetSpeedMPH();
		
		wait( 0.05 );
	}
}

check_for_landing()
{
	self waittill( "veh_landed" );
	self.already_landed = true;
}

watch_for_jump() // self == horse
{
	self endon("death");
	self endon("no_driver");

	while( true )
	{
		if( self.driver JumpButtonPressed() && !self.in_air )
		{
			if( self.current_anim_speed >= level.TROT )
			{
				self.in_air = true;
				//self.soundsnout playsound( "chr_horse_exert_plr" );

				self LaunchVehicle( (0, 0, 270), (0,0,0), 1 );
				
				self.already_landed = false;
				
				const anim_rate = 1;
				self SetAnimKnobAll( level.horse_anims[level.JUMP][0], %horse::root, 1, 0.1, anim_rate );
					
				driver = self get_driver();
				if ( IsDefined( driver ) )
				{
					self SetAnimKnobAll( level.horse_player_anims[level.JUMP][0], %player::root, 1, 0.1, anim_rate );
				}				
				
				self waittill( "veh_landed" );
				
				self SetAnimKnobAll( level.horse_anims[level.JUMP][2], %horse::root, 1, 0.1, anim_rate );
				
				driver = self get_driver();
				if ( IsDefined( driver ) )
				{
					self SetAnimKnobAll( level.horse_player_anims[level.JUMP][2], %player::root, 1, 0.1, anim_rate );
				}					
				
				anim_length = GetAnimLength( level.horse_anims[level.JUMP][2] );
				wait( anim_length * 0.5 );

				//Shawn J - Sound - adding a member to the horse struct - yeah, that's better - and playing sounds
				self.in_air = false;
				//self playsound( "fly_horse_hoofhit_g_plr_02" );
				//self playsound( "fly_horse_hoofhit_g_plr_03" );
			}
		}

		wait(0.05);
	}
}

watch_for_fall()
{
	while( true )
	{
		self waittill( "veh_inair" );
		if( !self.in_air )
		{
			self.in_air = true;
			self SetAnimKnobAll( level.horse_anims[level.JUMP][1], %horse::root, 1, 0.1, 1 );
			
			driver = self get_driver();
			if ( IsDefined( driver ) )
			{
				if ( !IsAI( driver ) )
				{
					//driver SetAnimKnobAll( level.horse_player_anims[level.JUMP][1], %player::root, 1, 0.1, 1 );
					driver.nextAnimation = level.horse_player_anims[level.JUMP][1];
				}
				else
				{
					driver.nextAnimation = level.horse_ai_anims[level.JUMP][1];
				}
			}				
			
			self waittill( "veh_landed" );
				
			self SetAnimKnobAll( level.horse_anims[level.JUMP][2], %horse::root, 1, 0.1, 1 );
			
			driver = self get_driver();
			if ( IsDefined( driver ) )
			{
				if ( !IsAI( driver ) )
				{
					//driver SetAnimKnobAll( level.horse_player_anims[level.JUMP][2], %player::root, 1, 0.1, 1 );
					driver.nextAnimation = level.horse_player_anims[level.JUMP][2];
				}
				else
				{
					driver.nextAnimation = level.horse_ai_anims[level.JUMP][2];
				}
			}				
			
			anim_length = GetAnimLength( level.horse_anims[level.JUMP][2] );
			wait( anim_length * 0.5 );

			self.in_air = false;
		}
		else
		{
			self waittill( "veh_landed" );
		}
	}
}

watch_for_sprint() // self == horse
{
	self endon("death");
	self endon("no_driver");

	self.max_speed = 25.0; //self GetMaxSpeed( true ) / 17.6;
	self.max_sprint_speed = self.max_speed * 1.5;
	self.min_sprint_speed = self.max_speed * 0.75;
	
	self.sprint_meter = 100;
	self.sprint_meter_max = 100;
	self.sprint_meter_min = self.sprint_meter_max * 0.25;
	self.sprint_time = 4;
	self.sprint_recover_time = 10;
		
	bPressingSprint = false;
	bMeterEmpty = false;	
	sprint_drain_rate = self.sprint_meter_max / self.sprint_time;
	sprint_recover_rate = self.sprint_meter_max / self.sprint_recover_time;
	
	while( true )
	{
		speed = self GetSpeedMPH();
		forward = AnglesToForward( self.angles );		
		//IPrintLn( speed );
		
		bCanSprint = ( bMeterEmpty == false ) && ( speed > self.min_sprint_speed );
		bPressingSprint = self.driver SprintButtonPressed();

		if ( bCanSprint && bPressingSprint )
		{
			self.sprint_meter -= sprint_drain_rate * 0.05; 
			
			// Check for a completely drained sprint meter
			if ( self.sprint_meter < 0 )
			{
				self.sprint_meter = 0;
				bMeterEmpty = true;	
			}
			else
			{
				self SetVehMaxSpeed( self.max_sprint_speed );

				// Speed me up
				if ( speed < self.max_sprint_speed )
					self LaunchVehicle( forward * 400 * 0.05 );
			}
		}
		else
		{
			self.sprint_meter += sprint_recover_rate * 0.05;
			
			// If the meter was completely drained...don't allow sprint
			// until we've recovered the minimum amount
			if ( bMeterEmpty )
			{
				if ( self.sprint_meter > self.sprint_meter_min )
					bMeterEmpty = false;
			}
			
			if ( self.sprint_meter > self.sprint_meter_max )
				self.sprint_meter = self.sprint_meter_max;

			self SetVehMaxSpeed( self.max_speed );

			// Slow me down
			if ( speed > self.max_speed )
				self LaunchVehicle( forward * -200 * 0.05 );
		}	
		
		//IPrintLnBold( "Sprint Meter: " + self.sprint_meter );
		
		wait(0.05);
	}
}

use_horse( user )	// self == horse
{
	self notify( "trigger", user );
}

delay_body()
{
	self endon( "death" );

	wait( 0.1 );
	self.driver.body Show();
}

watch_mounting() // self == horse
{
	self endon("death");
	
	flag_wait( "all_players_connected" );
	//players = get_players();
	//for( i = 0; i < players.size; i++ )
	//{
	//	players[i] spawn_player_body();
	//}

	self MakeVehicleUsable();

	while(true)
	{
		self waittill( "trigger", useEnt );
		
		if ( IS_TRUE( self.disable_mount ) )
		{
			continue;
		}
		
		if( !IsPlayer( useEnt ) )
		{
			continue;
		}
		
		self.driver = useEnt;
		self.driver set_mount_direction( self, self.driver.origin );

		self.driver AllowJump(false); //DT 8141 Jump will be scripted
	
		self NotSolid();
		
		if( IS_TRUE( self.disable_mount_anim ) )
		{
			println("horse mounting anim disabled");
		}
		else
		{
			self.driver mount( self );
		}
		
		self MakeVehicleUsable();
		self UseBy( self.driver );
		wait( 0.1 );
		self Solid();
		
		//self thread watch_for_jump();  DT 8141 Remove Player Horse Jump
		self thread watch_for_fall();
		self thread watch_for_sprint();

		self.driver thread maps\_horse_player::update_player_ride( self );
		self.driver.body SetClientFlag( CF_PLAYER_AIMING );

		//self thread horse_rumble();
		//self thread wind_driving();
		self thread horse_fx();

		if ( is_true( self.disable_mount_anim ) )
		{
			self thread delay_body();
		}
		
		self MakeVehicleUsable();

		while( true )
		{
			self waittill( "trigger", useEnt );
			if( useEnt == self.driver )
			{
				break;
			}
		}

		self UseBy( self.driver );
		self.driver.body notify( "stop_player_ride" );
		self.driver.body ClearClientFlag( CF_PLAYER_AIMING );

		self.driver AllowJump(true);  //DT 8141
		
		if ( IS_TRUE( self.disable_mount ) )
		{
			continue;
		}

		if( IS_TRUE( self.disable_mount_anim ) )
		{
			println("horse mounting anim disabled");
			self.driver.body Unlink();
			self.driver.body Hide();
			self.driver.body.origin = self.driver.origin;
			self.driver.body.anlges = self.driver.angles;
			self.driver.body LinkTo( self.driver );
		}
		else
		{
			self.driver dismount( self );
		}
		
		self MakeVehicleUsable();
		
		self notify("no_driver");
		self.driver = undefined;
	}
}

set_mount_direction( horse, mount_org )
{
	// figure out which side the player is on
	horse_facing = VectorNormalize( AnglesToRight( horse.angles ) );

	horse_player = mount_org - horse.origin;
	horse_player = ( horse_player[0], horse_player[1], 0 );
	horse_player = VectorNormalize( horse_player );

	side = 0;
	dot = VectorDot( horse_facing, horse_player );
	if ( dot > 0 )
	{
		side = 1;
	}

	self.side = side;
}

#using_animtree( "player" );
spawn_player_body( horse, mount_org )
{
	if( IsDefined( self.body ) )
	{
		return;
	}

	self.body = spawn( "script_model", self.origin );
	self.body.angles = self.angles;

	self.body SetModel( level.player_interactive_model );
	self.body UseAnimTree( #animtree );
	self.body NotSolid();
	self.body Hide();
	
	/#
	recordEnt( self.body );
	#/

	wait( 0.05 );

	self.body.origin = self.origin;
	self.body.angles = self.angles;
	self.body LinkTo( self );
}

ready_horse()
{
	if ( is_true( level.horse_in_combat ) )
	{
		self SetFlaggedAnimKnobAllRestart( "mount_horse", level.horse_anims[COMBAT_MOUNT][0], %horse::root, 1, 0.2, 0 );
	}
	else
	{
		self SetFlaggedAnimKnobAllRestart( "mount_horse", level.horse_anims[level.MOUNT][0], %horse::root, 1, 0.2, 0 );
	}
}

mount( horse )
{
	horse ent_flag_set( "mounting_horse" );
	
	self DisableWeapons();
	self FreezeControls( true );
	
	if( self GetStance() != "stand" )
	{
		self SetStance( "stand" );
		while( self GetStance() != "stand" )
		{
			wait( 0.05 );
		}
	}
	// Play the horse animation
	horse thread ready_horse();

	self.body Unlink();
	wait( 0.05 );
	self.body.origin = self.origin;
	self.body.angles = self.angles;

	//tag_org = horse GetTagOrigin( "BONE_H_Saddle" );
	//tag_angles = horse GetTagAngles( "BONE_H_Saddle" );

	// Play the animation on the player body
	mount_anim = level.horse_player_anims[level.MOUNT][self.side];
	if ( is_true( level.horse_in_combat ) )
	{
		mount_anim = level.horse_player_anims[COMBAT_MOUNT][self.side];
	}

	self.body SetAnim( mount_anim, 1, 0, 0 );
	self PlayerLinkToAbsolute( self.body, "tag_player" );

	wait( 0.05 );

	horse_mount_anim = level.horse_anims[level.MOUNT][0];
	if ( is_true( level.horse_in_combat ) )
	{
		horse_mount_anim = level.horse_anims[COMBAT_MOUNT][0];
	}
	horse SetFlaggedAnimKnobAllRestart( "mount_horse", horse_mount_anim, %horse::root, 1, 0, 1 );

	self.body animscripted( "mount", horse.origin, horse.angles, mount_anim, "normal", %generic_human::root, 1, 0, 0.65 );
	self.body Show();

	self.body waittillmatch( "mount", "end" );
	self.body StopAnimScripted();

	self Unlink();
	self EnableWeapons();
	
	self.body LinkTo( horse, "tag_origin" );
	
	//self SetClientDvar( "cg_fov", 85 );
	
	self HideViewModel();
	self FreezeControls( false );
	
	horse ent_flag_clear( "mounting_horse" );	
}

dismount( horse )
{
	horse ent_flag_set( "dismounting_horse" );
	
	if ( self.health <= 0 )
		return;
	
	self DisableWeapons();
	self PlayerLinkToAbsolute( self.body, "tag_player" ); 
	
	// Play the animation on the horse
	horse_dismount_anim = level.horse_anims[level.DISMOUNT][0];
	if ( is_true( level.horse_in_combat ) )
	{
		horse_dismount_anim = level.horse_anims[COMBAT_DISMOUNT][0];
	}
	horse SetAnimKnobAll( horse_dismount_anim, %horse::root, 1, 0.2, 1 );

	player_dismount_anim = level.horse_player_anims[level.DISMOUNT][0];
	if ( is_true( level.horse_in_combat ) )
	{
		player_dismount_anim = level.horse_player_anims[COMBAT_DISMOUNT][0];
	}

	// animate the player body model
	self.body Unlink();
	self.body animscripted( "dismount", horse.origin, horse.angles, player_dismount_anim );
	self.body waittillmatch( "dismount", "end" );
	
	self.body StopAnimScripted();
	
	horse NotSolid();
	
	self Unlink();
	self ShowViewModel();
	self EnableWeapons();
	self.body Unlink();
	self.body Hide();
	self.body.origin = self.origin;
	self.body.angles = self.angles;
	self.body LinkTo( self );
	self.body ClearAnim( %player::root, 0 );
	
	horse Solid();
	
	horse MakeVehicleUsable();
	
	//self SetClientDvar( "cg_fov", GetDvarInt( "cg_fov_default" ) );
	
	horse ent_flag_clear( "dismounting_horse" );		
}

get_driver()
{
	if ( IsDefined( self.driver ) && IsDefined( self.driver.body ) )
		return self.driver.body;
	else if ( self.riders.size > 0 && self.unloadque.size == 0 )
		return self.riders[0];
	
	return undefined;
}

#using_animtree( "generic_human" );
get_generic_human_root()
{
	return %root;	
}

#using_animtree( "horse" );
get_horse_root()
{
	return %root;	
}

setanims()
{
	positions = [];
	for(i = 0; i < 1; i++)
	{
		positions[i] = spawnstruct();
	}

	// Tags
	positions[0].sittag = "tag_driver";			// driver

	// Get in
	positions[0].getin = %generic_human::ai_horse_rider_get_on_leftside;	
	
	// Get out
	positions[0].getout = %generic_human::ai_horse_rider_get_off_leftside;

	return positions;
}

