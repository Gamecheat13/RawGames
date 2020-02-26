#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

#define ENT_FLAG(__self,__message) (__self.ent_flag[__message])

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
	
	#define DEFAULT_PLAYER_MELEE_RANGE		64
	#define DEFAULT_PLAYER_MELEE_HEIGHT		10
	#define DEFAULT_PLAYER_MELEE_WIDTH		10
	
	#using_animtree( "horse" );

main() // self == horse
{
	self UseAnimTree( #animtree );
	self build_horse_anims();
	
	self.dismount_enabled = true;
	self.disable_make_useable = false;
	self.disable_weapon_changes = false;
	
	if ( !isdefined( level.horse_in_combat ) )
	{
		build_aianims( ::setanims );
	}
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
	}

	// horse model is specified in Radiant
	if ( isdefined( self.script_string ) )
	{
		self setmodel( self.script_string );
	}
	else
	{
		idx = RandomInt( level.horse_model_variants.size );
		self setmodel( level.horse_model_variants[ idx ] );
	}

	self choose_sprint_anim();

	//precache_fx();

	self ent_flag_init( "mounting_horse" );
	self ent_flag_init( "dismounting_horse" );
	self ent_flag_init( "pause_animation" );
	self ent_flag_init( "playing_scripted_anim" );
	
	self thread watch_mounting();
	//self thread watch_brake();
	self thread horse_animating();
	//self thread horse_breathing();

	self.overrideVehicleDamage = ::HorseCallback_VehicleDamage;
	
	//self thread debug_horse();
}

choose_sprint_anim()
{
	self.sprint_anim = level.horse_sprint_anims[ level.horse_sprint_idx ];
	level.horse_sprint_idx++;
	if ( level.horse_sprint_idx > 3 )
	{
		level.horse_sprint_idx = 0;
	}
}

precache_models()
{
	level.player_viewmodel_noleft = "c_usa_mason_afgan_noleft_viewhands";

	precachemodel( "anim_horse1_black_fb" );
	precachemodel( "anim_horse1_brown_black_fb" );
	precachemodel( "anim_horse1_brown_spots_fb" );
	precachemodel( "anim_horse1_grey_fb" );
	precachemodel( "anim_horse1_light_brown_fb" );
	precachemodel( "anim_horse1_white_fb" );
	precachemodel( "anim_horse1_white02_fb" );

	precachemodel( "viewmodel_horse1_fb" );
	precachemodel( "viewmodel_horse1_black_fb" );
	precachemodel( "viewmodel_horse1_brown_black_fb" );
	precachemodel( "viewmodel_horse1_brown_spots_fb" );
	precachemodel( "viewmodel_horse1_grey_fb" );
	precachemodel( "viewmodel_horse1_light_brown_fb" );
	precachemodel( "viewmodel_horse1_white_fb" );
	precachemodel( "viewmodel_horse1_white02_fb" );

	precachemodel( level.player_viewmodel_noleft );
	//precachemodel( "fx_axis_createfx" );
}

/#
debug_horse()
{
	self endon( "death" );
	recordEnt( self );

	while ( 1 )
	{
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

		wait( 0.05 );
	}
}
#/

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
	level.REARBACK = 13;
	level.TURN_180 = 14;

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

	/#
	level.horse_idles[STAND_IDLE].ai_animnames = [];
	level.horse_idles[STAND_IDLE].ai_animnames[0] = "ai_horse_rider_stand_idle";
	level.horse_idles[STAND_IDLE].ai_animnames[1] = "ai_horse_rider_stand_idle_twitch_a";
	level.horse_idles[STAND_IDLE].ai_animnames[2] = "ai_horse_rider_stand_idle_to_right_idle";
	level.horse_idles[STAND_IDLE].ai_animnames[3] = "ai_horse_rider_stand_idle_to_forward_idle";
	level.horse_idles[STAND_IDLE].ai_animnames[4] = "ai_horse_rider_stand_idle_to_wide_idle";
	level.horse_idles[STAND_IDLE].ai_animnames[5] = "ai_horse_rider_stand_idle_to_eat_idle";
	#/
		
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

	/#
	level.horse_idles[RIGHT_IDLE].ai_animnames = [];
	level.horse_idles[RIGHT_IDLE].ai_animnames[0] = "ai_horse_rider_right_idle";
	level.horse_idles[RIGHT_IDLE].ai_animnames[1] = "ai_horse_rider_right_idle_to_stand_idle";
	level.horse_idles[RIGHT_IDLE].ai_animnames[2] = "ai_horse_rider_right_idle_to_forward_idle";
	#/
		
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

	/#
	level.horse_idles[FORWARD_IDLE].ai_animnames = [];
	level.horse_idles[FORWARD_IDLE].ai_animnames[0] = "ai_horse_rider_forward_idle";
	level.horse_idles[FORWARD_IDLE].ai_animnames[1] = "ai_horse_rider_forward_idle_to_right_idle";
	level.horse_idles[FORWARD_IDLE].ai_animnames[2] = "ai_horse_rider_forward_idle_to_stand_idle";
	level.horse_idles[FORWARD_IDLE].ai_animnames[3] = "ai_horse_rider_forward_idle_to_eat_idle";
	#/
		
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

	/#
	level.horse_idles[WIDE_IDLE].ai_animnames = [];
	level.horse_idles[WIDE_IDLE].ai_animnames[0] = "ai_horse_rider_wide_idle";
	level.horse_idles[WIDE_IDLE].ai_animnames[1] = "ai_horse_rider_wide_idle_twitch_a";
	level.horse_idles[WIDE_IDLE].ai_animnames[2] = "ai_horse_rider_wide_idle_to_forward_idle";
	level.horse_idles[WIDE_IDLE].ai_animnames[3] = "ai_horse_rider_wide_idle_to_frisky_idle";
	level.horse_idles[WIDE_IDLE].ai_animnames[4] = "ai_horse_rider_wide_idle_to_right_idle";
	#/
		
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

	/#
		level.horse_idles[FRISKY_IDLE].ai_animnames = [];
	level.horse_idles[FRISKY_IDLE].ai_animnames[0] = "ai_horse_rider_frisky_idle";
	level.horse_idles[FRISKY_IDLE].ai_animnames[1] = "ai_horse_rider_frisky_idle_twitch_a";
	level.horse_idles[FRISKY_IDLE].ai_animnames[2] = "ai_horse_rider_frisky_idle_twitch_b";
	level.horse_idles[FRISKY_IDLE].ai_animnames[3] = "ai_horse_rider_frisky_idle_twitch_c";
	level.horse_idles[FRISKY_IDLE].ai_animnames[4] = "ai_horse_rider_frisky_idle_to_wide_idle";
	#/
		
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

	/#
	level.horse_idles[EAT_IDLE].ai_animnames = [];
	level.horse_idles[EAT_IDLE].ai_animnames[0] = "ai_horse_rider_eat_idle";
	level.horse_idles[EAT_IDLE].ai_animnames[1] = "ai_horse_rider_eat_idle_twitch_a";
	level.horse_idles[EAT_IDLE].ai_animnames[2] = "ai_horse_rider_eat_idle_twitch_b";
	level.horse_idles[EAT_IDLE].ai_animnames[3] = "ai_horse_rider_eat_idle_to_eat_idle_b";
	level.horse_idles[EAT_IDLE].ai_animnames[4] = "ai_horse_rider_eat_idle_to_stand_idle";
	level.horse_idles[EAT_IDLE].ai_animnames[5] = "ai_horse_rider_eat_idle_to_wide_idle";
	#/
		
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

	/#
	level.horse_idles[EAT_IDLE_B].ai_animnames = [];
	level.horse_idles[EAT_IDLE_B].ai_animnames[0] = "ai_horse_rider_eat_idle_b";
	level.horse_idles[EAT_IDLE_B].ai_animnames[1] = "ai_horse_rider_eat_idle_b_twitch_a";
	level.horse_idles[EAT_IDLE_B].ai_animnames[2] = "ai_horse_rider_eat_idle_b_twitch_b";
	level.horse_idles[EAT_IDLE_B].ai_animnames[3] = "ai_horse_rider_eat_idle_b_twitch_c";
	level.horse_idles[EAT_IDLE_B].ai_animnames[4] = "ai_horse_rider_eat_idle_b_to_eat_idle";
	level.horse_idles[EAT_IDLE_B].ai_animnames[5] = "ai_horse_rider_eat_idle_b_to_stand_idle";
	#/

		
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
	level.horse_anims[level.REARBACK] = %a_horse_rearback_nofall;
	
	level.horse_anims[level.TURN_180] = %a_horse_turn180_r;

	level.horse_sprint_anims = [];
	level.horse_sprint_anims[0] = %a_horse_sprint_f;
	level.horse_sprint_anims[1] = %a_horse_sprint_f_alt_a;
	level.horse_sprint_anims[2] = %a_horse_sprint_f_alt_b;
	level.horse_sprint_anims[3] = %a_horse_sprint_f_alt_c;

	level.horse_sprint_anims = array_randomize( level.horse_sprint_anims );
	level.horse_sprint_idx = 0;

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

	level.horse_ai_anims[level.MOUNT][0] = %generic_human::ai_horse_rider_get_on_leftside;
	level.horse_ai_anims[level.MOUNT][1] = %generic_human::ai_horse_rider_get_on_rightside;
	level.horse_ai_anims[level.DISMOUNT][0] = %generic_human::ai_horse_rider_get_off_leftside;
	level.horse_ai_anims[level.DISMOUNT][1] = %generic_human::ai_horse_rider_get_off_rightside;

	level.horse_ai_anims[COMBAT_MOUNT][0] = %generic_human::ai_horse_rider_get_on_combat_leftside;
	level.horse_ai_anims[COMBAT_MOUNT][1] = %generic_human::ai_horse_rider_get_on_combat_rightside;
	level.horse_ai_anims[COMBAT_DISMOUNT][0] = %generic_human::ai_horse_rider_get_off_combat_leftside;
	level.horse_ai_anims[COMBAT_DISMOUNT][1] = %generic_human::ai_horse_rider_get_off_combat_rightside;

	level.horse_ai_anims[HITWALL] = %generic_human::ai_horse_rider_hitwall;
	level.horse_ai_anims[level.REARBACK] = %generic_human::ai_horse_rider_rearback_nofall;
	
	level.AIM_F = 0;
	level.AIM_L = 1;
	level.AIM_R = 2;
	level.PISTOL_PULLOUT = 3;
	level.PISTOL_PUTAWAY = 4;
	level.RIFLE_PULLOUT = 5;
	level.RIFLE_PUTAWAY = 6;

	level.FIRE = 0;

	level.horse_ai_aim_anims[level.IDLE] = [];
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F] = [];
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F][2] = %generic_human::ai_horse_rider_aim_f_2;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F][4] = %generic_human::ai_horse_rider_aim_f_4;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F][5] = %generic_human::ai_horse_rider_aim_f_5;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F][6] = %generic_human::ai_horse_rider_aim_f_6;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F][8] = %generic_human::ai_horse_rider_aim_f_8;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_F][level.FIRE] = %generic_human::ai_horse_rider_aim_f_fire;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L] = [];
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L][2] = %generic_human::ai_horse_rider_aim_l_2;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L][4] = %generic_human::ai_horse_rider_aim_l_4;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L][5] = %generic_human::ai_horse_rider_aim_l_5;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L][6] = %generic_human::ai_horse_rider_aim_l_6;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L][8] = %generic_human::ai_horse_rider_aim_l_8;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_L][level.FIRE] = %generic_human::ai_horse_rider_aim_l_fire;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R] = [];
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R][2] = %generic_human::ai_horse_rider_aim_r_2;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R][4] = %generic_human::ai_horse_rider_aim_r_4;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R][5] = %generic_human::ai_horse_rider_aim_r_5;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R][6] = %generic_human::ai_horse_rider_aim_r_6;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R][8] = %generic_human::ai_horse_rider_aim_r_8;
	level.horse_ai_aim_anims[level.IDLE][level.AIM_R][level.FIRE] = %generic_human::ai_horse_rider_aim_r_fire;
	level.horse_ai_aim_anims[level.IDLE][level.PISTOL_PULLOUT] = %generic_human::ai_horse_rider_pistol_pullout;
	level.horse_ai_aim_anims[level.IDLE][level.PISTOL_PUTAWAY] = %generic_human::ai_horse_rider_pistol_putaway;
	level.horse_ai_aim_anims[level.IDLE][level.RIFLE_PULLOUT] = %generic_human::ai_horse_rider_rifle_pullout;
	level.horse_ai_aim_anims[level.IDLE][level.RIFLE_PUTAWAY] = %generic_human::ai_horse_rider_rifle_putaway;

	level.horse_ai_aim_anims[level.WALK] = [];
	level.horse_ai_aim_anims[level.WALK][level.AIM_F] = [];
	level.horse_ai_aim_anims[level.WALK][level.AIM_F][2] = %generic_human::ai_horse_rider_walk_aim_f_2;
	level.horse_ai_aim_anims[level.WALK][level.AIM_F][4] = %generic_human::ai_horse_rider_walk_aim_f_4;
	level.horse_ai_aim_anims[level.WALK][level.AIM_F][5] = %generic_human::ai_horse_rider_walk_aim_f_5;
	level.horse_ai_aim_anims[level.WALK][level.AIM_F][6] = %generic_human::ai_horse_rider_walk_aim_f_6;
	level.horse_ai_aim_anims[level.WALK][level.AIM_F][8] = %generic_human::ai_horse_rider_walk_aim_f_8;
	level.horse_ai_aim_anims[level.WALK][level.AIM_F][level.FIRE] = %generic_human::ai_horse_rider_walk_aim_f_fire;
	level.horse_ai_aim_anims[level.WALK][level.AIM_L] = [];
	level.horse_ai_aim_anims[level.WALK][level.AIM_L][2] = %generic_human::ai_horse_rider_walk_aim_l_2;
	level.horse_ai_aim_anims[level.WALK][level.AIM_L][4] = %generic_human::ai_horse_rider_walk_aim_l_4;
	level.horse_ai_aim_anims[level.WALK][level.AIM_L][5] = %generic_human::ai_horse_rider_walk_aim_l_5;
	level.horse_ai_aim_anims[level.WALK][level.AIM_L][6] = %generic_human::ai_horse_rider_walk_aim_l_6;
	level.horse_ai_aim_anims[level.WALK][level.AIM_L][8] = %generic_human::ai_horse_rider_walk_aim_l_8;
	level.horse_ai_aim_anims[level.WALK][level.AIM_L][level.FIRE] = %generic_human::ai_horse_rider_walk_aim_l_fire;
	level.horse_ai_aim_anims[level.WALK][level.AIM_R] = [];
	level.horse_ai_aim_anims[level.WALK][level.AIM_R][2] = %generic_human::ai_horse_rider_walk_aim_r_2;
	level.horse_ai_aim_anims[level.WALK][level.AIM_R][4] = %generic_human::ai_horse_rider_walk_aim_r_4;
	level.horse_ai_aim_anims[level.WALK][level.AIM_R][5] = %generic_human::ai_horse_rider_walk_aim_r_5;
	level.horse_ai_aim_anims[level.WALK][level.AIM_R][6] = %generic_human::ai_horse_rider_walk_aim_r_6;
	level.horse_ai_aim_anims[level.WALK][level.AIM_R][8] = %generic_human::ai_horse_rider_walk_aim_r_8;
	level.horse_ai_aim_anims[level.WALK][level.AIM_R][level.FIRE] = %generic_human::ai_horse_rider_walk_aim_r_fire;
	level.horse_ai_aim_anims[level.WALK][level.PISTOL_PULLOUT] = %generic_human::ai_horse_rider_walk_pistol_pullout;
	level.horse_ai_aim_anims[level.WALK][level.PISTOL_PUTAWAY] = %generic_human::ai_horse_rider_walk_pistol_putaway;
	level.horse_ai_aim_anims[level.WALK][level.RIFLE_PULLOUT] = %generic_human::ai_horse_rider_walk_rifle_pullout;
	level.horse_ai_aim_anims[level.WALK][level.RIFLE_PUTAWAY] = %generic_human::ai_horse_rider_walk_rifle_putaway;

	level.horse_ai_aim_anims[level.TROT] = [];
	level.horse_ai_aim_anims[level.TROT][level.AIM_F] = [];
	level.horse_ai_aim_anims[level.TROT][level.AIM_F][2] = %generic_human::ai_horse_rider_trot_aim_f_2;
	level.horse_ai_aim_anims[level.TROT][level.AIM_F][4] = %generic_human::ai_horse_rider_trot_aim_f_4;
	level.horse_ai_aim_anims[level.TROT][level.AIM_F][5] = %generic_human::ai_horse_rider_trot_aim_f_5;
	level.horse_ai_aim_anims[level.TROT][level.AIM_F][6] = %generic_human::ai_horse_rider_trot_aim_f_6;
	level.horse_ai_aim_anims[level.TROT][level.AIM_F][8] = %generic_human::ai_horse_rider_trot_aim_f_8;
	level.horse_ai_aim_anims[level.TROT][level.AIM_F][level.FIRE] = %generic_human::ai_horse_rider_trot_aim_f_fire;
	level.horse_ai_aim_anims[level.TROT][level.AIM_L] = [];
	level.horse_ai_aim_anims[level.TROT][level.AIM_L][2] = %generic_human::ai_horse_rider_trot_aim_l_2;
	level.horse_ai_aim_anims[level.TROT][level.AIM_L][4] = %generic_human::ai_horse_rider_trot_aim_l_4;
	level.horse_ai_aim_anims[level.TROT][level.AIM_L][5] = %generic_human::ai_horse_rider_trot_aim_l_5;
	level.horse_ai_aim_anims[level.TROT][level.AIM_L][6] = %generic_human::ai_horse_rider_trot_aim_l_6;
	level.horse_ai_aim_anims[level.TROT][level.AIM_L][8] = %generic_human::ai_horse_rider_trot_aim_l_8;
	level.horse_ai_aim_anims[level.TROT][level.AIM_L][level.FIRE] = %generic_human::ai_horse_rider_trot_aim_l_fire;
	level.horse_ai_aim_anims[level.TROT][level.AIM_R] = [];
	level.horse_ai_aim_anims[level.TROT][level.AIM_R][2] = %generic_human::ai_horse_rider_trot_aim_r_2;
	level.horse_ai_aim_anims[level.TROT][level.AIM_R][4] = %generic_human::ai_horse_rider_trot_aim_r_4;
	level.horse_ai_aim_anims[level.TROT][level.AIM_R][5] = %generic_human::ai_horse_rider_trot_aim_r_5;
	level.horse_ai_aim_anims[level.TROT][level.AIM_R][6] = %generic_human::ai_horse_rider_trot_aim_r_6;
	level.horse_ai_aim_anims[level.TROT][level.AIM_R][8] = %generic_human::ai_horse_rider_trot_aim_r_8;
	level.horse_ai_aim_anims[level.TROT][level.AIM_R][level.FIRE] = %generic_human::ai_horse_rider_trot_aim_r_fire;
	level.horse_ai_aim_anims[level.TROT][level.PISTOL_PULLOUT] = %generic_human::ai_horse_rider_trot_pistol_pullout;
	level.horse_ai_aim_anims[level.TROT][level.PISTOL_PUTAWAY] = %generic_human::ai_horse_rider_trot_pistol_putaway;
	level.horse_ai_aim_anims[level.TROT][level.RIFLE_PULLOUT] = %generic_human::ai_horse_rider_trot_rifle_pullout;
	level.horse_ai_aim_anims[level.TROT][level.RIFLE_PUTAWAY] = %generic_human::ai_horse_rider_trot_rifle_putaway;

	level.horse_ai_aim_anims[level.RUN] = [];
	level.horse_ai_aim_anims[level.RUN][level.AIM_F] = [];
	level.horse_ai_aim_anims[level.RUN][level.AIM_F][2] = %generic_human::ai_horse_rider_canter_aim_f_2;
	level.horse_ai_aim_anims[level.RUN][level.AIM_F][4] = %generic_human::ai_horse_rider_canter_aim_f_4;
	level.horse_ai_aim_anims[level.RUN][level.AIM_F][5] = %generic_human::ai_horse_rider_canter_aim_f_5;
	level.horse_ai_aim_anims[level.RUN][level.AIM_F][6] = %generic_human::ai_horse_rider_canter_aim_f_6;
	level.horse_ai_aim_anims[level.RUN][level.AIM_F][8] = %generic_human::ai_horse_rider_canter_aim_f_8;
	level.horse_ai_aim_anims[level.RUN][level.AIM_F][level.FIRE] = %generic_human::ai_horse_rider_canter_aim_f_fire;
	level.horse_ai_aim_anims[level.RUN][level.AIM_L] = [];
	level.horse_ai_aim_anims[level.RUN][level.AIM_L][2] = %generic_human::ai_horse_rider_canter_aim_l_2;
	level.horse_ai_aim_anims[level.RUN][level.AIM_L][4] = %generic_human::ai_horse_rider_canter_aim_l_4;
	level.horse_ai_aim_anims[level.RUN][level.AIM_L][5] = %generic_human::ai_horse_rider_canter_aim_l_5;
	level.horse_ai_aim_anims[level.RUN][level.AIM_L][6] = %generic_human::ai_horse_rider_canter_aim_l_6;
	level.horse_ai_aim_anims[level.RUN][level.AIM_L][8] = %generic_human::ai_horse_rider_canter_aim_l_8;
	level.horse_ai_aim_anims[level.RUN][level.AIM_L][level.FIRE] = %generic_human::ai_horse_rider_canter_aim_l_fire;
	level.horse_ai_aim_anims[level.RUN][level.AIM_R] = [];
	level.horse_ai_aim_anims[level.RUN][level.AIM_R][2] = %generic_human::ai_horse_rider_canter_aim_r_2;
	level.horse_ai_aim_anims[level.RUN][level.AIM_R][4] = %generic_human::ai_horse_rider_canter_aim_r_4;
	level.horse_ai_aim_anims[level.RUN][level.AIM_R][5] = %generic_human::ai_horse_rider_canter_aim_r_5;
	level.horse_ai_aim_anims[level.RUN][level.AIM_R][6] = %generic_human::ai_horse_rider_canter_aim_r_6;
	level.horse_ai_aim_anims[level.RUN][level.AIM_R][8] = %generic_human::ai_horse_rider_canter_aim_r_8;
	level.horse_ai_aim_anims[level.RUN][level.AIM_R][level.FIRE] = %generic_human::ai_horse_rider_canter_aim_r_fire;
	level.horse_ai_aim_anims[level.RUN][level.PISTOL_PULLOUT] = %generic_human::ai_horse_rider_canter_pistol_pullout;
	level.horse_ai_aim_anims[level.RUN][level.PISTOL_PUTAWAY] = %generic_human::ai_horse_rider_canter_pistol_putaway;
	level.horse_ai_aim_anims[level.RUN][level.RIFLE_PULLOUT] = %generic_human::ai_horse_rider_canter_rifle_pullout;
	level.horse_ai_aim_anims[level.RUN][level.RIFLE_PUTAWAY] = %generic_human::ai_horse_rider_canter_rifle_putaway;

	level.horse_ai_aim_anims[level.SPRINT] = [];
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F] = [];
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F][2] = %generic_human::ai_horse_rider_sprint_aim_f_2;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F][4] = %generic_human::ai_horse_rider_sprint_aim_f_4;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F][5] = %generic_human::ai_horse_rider_sprint_aim_f_5;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F][6] = %generic_human::ai_horse_rider_sprint_aim_f_6;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F][8] = %generic_human::ai_horse_rider_sprint_aim_f_8;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_F][level.FIRE] = %generic_human::ai_horse_rider_sprint_aim_f_fire;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L] = [];
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L][2] = %generic_human::ai_horse_rider_sprint_aim_l_2;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L][4] = %generic_human::ai_horse_rider_sprint_aim_l_4;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L][5] = %generic_human::ai_horse_rider_sprint_aim_l_5;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L][6] = %generic_human::ai_horse_rider_sprint_aim_l_6;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L][8] = %generic_human::ai_horse_rider_sprint_aim_l_8;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_L][level.FIRE] = %generic_human::ai_horse_rider_sprint_aim_l_fire;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R] = [];
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R][2] = %generic_human::ai_horse_rider_sprint_aim_r_2;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R][4] = %generic_human::ai_horse_rider_sprint_aim_r_4;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R][5] = %generic_human::ai_horse_rider_sprint_aim_r_5;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R][6] = %generic_human::ai_horse_rider_sprint_aim_r_6;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R][8] = %generic_human::ai_horse_rider_sprint_aim_r_8;
	level.horse_ai_aim_anims[level.SPRINT][level.AIM_R][level.FIRE] = %generic_human::ai_horse_rider_sprint_aim_r_fire;
	level.horse_ai_aim_anims[level.SPRINT][level.PISTOL_PULLOUT] = %generic_human::ai_horse_rider_sprint_pistol_pullout;
	level.horse_ai_aim_anims[level.SPRINT][level.PISTOL_PUTAWAY] = %generic_human::ai_horse_rider_sprint_pistol_putaway;
	level.horse_ai_aim_anims[level.SPRINT][level.RIFLE_PULLOUT] = %generic_human::ai_horse_rider_sprint_rifle_pullout;
	level.horse_ai_aim_anims[level.SPRINT][level.RIFLE_PUTAWAY] = %generic_human::ai_horse_rider_sprint_rifle_putaway;

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
	level.horse_player_anims[level.SPRINT][3] = %player::int_horse_player_sprint_boost;
	
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
	level.horse_player_anims[level.REARBACK] = %player::int_horse_player_rearback_nofall;
	level.horse_player_anims[level.TURN_180] = %player::int_horse_player_turn180_r;

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

	level.horse_deaths_explosive = [];
	//level.horse_deaths_explosive[0] = SpawnStruct();
	//level.horse_deaths_explosive[0].animation = %a_horse_sprint_explosive_death_fly_back_a;
	//level.horse_deaths_explosive[0].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_back_a;
	//level.horse_deaths_explosive[1] = SpawnStruct();
	//level.horse_deaths_explosive[1].animation = %a_horse_sprint_explosive_death_fly_back_b;
	//level.horse_deaths_explosive[1].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_back_b;
	level.horse_deaths_explosive[0] = SpawnStruct();
	level.horse_deaths_explosive[0].animation = %a_horse_sprint_explosive_death_fly_forward_a;
	level.horse_deaths_explosive[0].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_a;
	level.horse_deaths_explosive[1] = SpawnStruct();
	level.horse_deaths_explosive[1].animation = %a_horse_sprint_explosive_death_fly_forward_b;
	level.horse_deaths_explosive[1].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_b;
	level.horse_deaths_explosive[2] = SpawnStruct();
	level.horse_deaths_explosive[2].animation = %a_horse_sprint_explosive_death_fly_forward_c;
	level.horse_deaths_explosive[2].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_c;
	level.horse_deaths_explosive[3] = SpawnStruct();
	level.horse_deaths_explosive[3].animation = %a_horse_sprint_explosive_death_fly_forward_d;
	level.horse_deaths_explosive[3].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_d;
	level.horse_deaths_explosive[4] = SpawnStruct();
	level.horse_deaths_explosive[4].animation = %a_horse_sprint_explosive_death_fly_forward_e;
	level.horse_deaths_explosive[4].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_e;
	level.horse_deaths_explosive[5] = SpawnStruct();
	level.horse_deaths_explosive[5].animation = %a_horse_sprint_explosive_death_fly_forward_f;
	level.horse_deaths_explosive[5].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_f;
	//level.horse_deaths_explosive[8] = SpawnStruct();
	//level.horse_deaths_explosive[8].animation = %a_horse_sprint_explosive_death_fly_left_a;
	//level.horse_deaths_explosive[8].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_left_a;
	//level.horse_deaths_explosive[9] = SpawnStruct();
	//level.horse_deaths_explosive[9].animation = %a_horse_sprint_explosive_death_fly_right_a;
	//level.horse_deaths_explosive[9].ai_animation = %generic_human::ai_horse_rider_sprint_explosive_death_fly_right_a;

	level.horse_model_variants = [];
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_black_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_brown_black_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_brown_spots_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_grey_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_light_brown_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_white_fb";
	level.horse_model_variants[ level.horse_model_variants.size ] = "anim_horse1_white02_fb";
	
	level.horse_viewmodel_variants = [];
	level.horse_viewmodel_variants[ "anim_horse1_fb" ] = "viewmodel_horse1_fb";
	level.horse_viewmodel_variants[ "anim_horse1_black_fb" ] = "viewmodel_horse1_black_fb";
	level.horse_viewmodel_variants[ "anim_horse1_brown_black_fb" ] = "viewmodel_horse1_brown_black_fb";
	level.horse_viewmodel_variants[ "anim_horse1_brown_spots_fb" ] = "viewmodel_horse1_brown_spots_fb";
	level.horse_viewmodel_variants[ "anim_horse1_grey_fb" ] = "viewmodel_horse1_grey_fb";
	level.horse_viewmodel_variants[ "anim_horse1_light_brown_fb" ] = "viewmodel_horse1_light_brown_fb";
	level.horse_viewmodel_variants[ "anim_horse1_white_fb" ] = "viewmodel_horse1_white_fb";
	level.horse_viewmodel_variants[ "anim_horse1_white02_fb" ] = "viewmodel_horse1_white02_fb";
}

get_explosive_death_horse()
{
	if ( !isdefined( level.explosive_death_index ) )
	{
		level.horse_deaths_explosive = array_randomize( level.horse_deaths_explosive );
		level.explosive_death_index = 0;
	}
	else
	{
		level.explosive_death_index++;
		if ( level.explosive_death_index == level.horse_deaths_explosive.size )
		{
			level.horse_deaths_explosive = array_randomize( level.horse_deaths_explosive );
			level.explosive_death_index = 0;
		}
	}

	death_anim = level.horse_deaths_explosive[ level.explosive_death_index ].animation;
	return death_anim;
}

get_explosive_death_ai()
{
	if ( isdefined( level.explosive_death_index ) )
	{
		death_anim = level.horse_deaths_explosive[ level.explosive_death_index ].ai_animation;
		return death_anim;
	}
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

		if ( is_true( self.is_panic ) )
		{
			idle_struct = level.horse_idles[ FRISKY_IDLE ];
			anim_index = RandomInt( idle_struct.animations.size );
		}

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


		self.current_anim = idle_anim;
		self.rider_nextAnimation = idle_ai_anim;
		self SetAnimKnobAllRestart( idle_anim, %horse::root, 1, 0.2, 1 );
		
		if ( IsDefined( driver ) && IsDefined( driver.update_idle_anim ) )
		{
			driver [[ driver.update_idle_anim ]]( idle_struct, anim_index );
		}
	}
	
	self.current_anim_speed = level.IDLE;
}

horse_rearback()
{
	self endon( "death" );

	self ent_flag_set( "pause_animation" );

	driver = self get_driver();
	if ( IsDefined( driver ) && IsDefined( driver.update_rearback_anim ) )
	{
		driver thread [[ driver.update_rearback_anim ]]( self );
	}

	self SetAnimKnobAllRestart( level.horse_anims[level.REARBACK], %horse::root, 1, 0.2, 1 );
	len = GetAnimLength( level.horse_anims[level.REARBACK] );
	wait( len );

	self.idle_end_time = gettime();

	self ent_flag_clear( "pause_animation" );
}

play_horse_anim( animname )
{
	self endon( "death" );

	self SetAnimKnobAll( animname, %horse::root, 1, 0.2, 1 );
	wait( GetAnimLength( animname ) );
}

horse_panic()
{
	//iprintln( "horse panic" );
	self.is_panic = true;
	self notify( "panic" );
}

horse_stop()
{
	self endon( "death" );

	self ent_flag_set( "pause_animation" );

	driver = self get_driver();
	if ( IsDefined( driver ) && IsDefined( driver.update_stop_anim ) )
	{
		driver thread [[ driver.update_stop_anim ]]();
	}

	stop_in = %a_horse_short_stop_init;
	stop_out = %a_horse_short_stop_finish;

	self play_horse_anim( stop_in );
	self play_horse_anim( stop_out );

	self.idle_end_time = gettime();
	self ent_flag_clear( "pause_animation" );
}

horse_transition( start )
{
	self endon( "death" );

	self ent_flag_set( "pause_animation" );

	self.state_loco = level.LOCO_TRANS;

	driver = self get_driver();
	if ( IsDefined( driver ) && IsDefined( driver.update_transition_anim ) )
	{
		driver thread [[ driver.update_transition_anim ]]( start, self.current_anim_speed );
	}

	if ( is_true( start ) )
	{
		trans_anim = %a_horse_idle_to_walk;
	}
	else
	{
		if ( self.current_anim_speed == level.TROT )
		{
			trans_anim = %a_horse_trot_to_idle;
		}
		else if ( self.current_anim_speed == level.RUN )
		{
			trans_anim = %a_horse_canter_to_idle;
		}
		else if ( self.current_anim_speed == level.SPRINT )
		{
			trans_anim = %a_horse_sprint_to_idle;
		}
		else
		{
			trans_anim = %a_horse_walk_to_idle;
		}
	}

	self play_horse_anim( trans_anim );
	self.idle_end_time = gettime();
	self ent_flag_clear( "pause_animation" );
}

/*
watch_brake()
{
	self endon( "death" );

	wait( .5 );

	while ( true )
	{
		if ( ENT_FLAG( self, "pause_animation" ) )
		{
			wait_network_frame();
			continue;
		}

		speed = self GetSpeedMPH();
		if ( speed > 0.05 )
		{
			brake = self GetBrake();
			handbrake = self GetHandBrake();
			scriptbrake = self GetScriptBrake();
			if ( brake > 0 || handbrake > 0 || scriptbrake > 0 )
			{
				self thread horse_stop();
			}
		}

		wait( 0.05 );
	}
}
 */

horse_animating() // self == horse
{
	self endon("death");

	wait .5;
	
	self.idle_end_time = 0;

	level.LOCO_IDLE = 0;
	level.LOCO_TRANS = 1;
	level.LOCO_MOTION = 2;

	self.state_loco = level.LOCO_IDLE;

	while( true )
	{
		speed = self GetSpeedMPH();
		angular_velocity = self GetAngularVelocity();
		turning_speed = abs( angular_velocity[2] );
		
		//iprintlnbold( "Speed: " + speed + " Avel: " + angular_velocity[2] );

		/#
			if ( isdefined( self.horse_animating_override ) )
		{
			self thread [[ self.horse_animating_override ]]();
			return;
		}
		#/

			if ( isdefined( self.current_anim ) )
		{
			self.current_time = self GetAnimTime( self.current_anim );
		}
		
		//-- made ENT_FLAG macro at the top of the file, since this runs so often
		if( ENT_FLAG( self, "mounting_horse" ) || ENT_FLAG( self, "dismounting_horse" ) || ENT_FLAG( self, "playing_scripted_anim" )
		   || ENT_FLAG( self, "pause_animation" ) )
		{
		}
		else if( speed < -0.05 )	// reverse
		{
			self.current_anim_speed = level.REVERSE;
			
			anim_rate = speed / level.horse_speeds[self.current_anim_speed];
			anim_rate = clamp( anim_rate, 0.5, 1.5 );

			self.current_anim = level.horse_anims[level.REVERSE];
			self SetAnimKnobAll( level.horse_anims[level.REVERSE], %horse::root, 1, 0.2, anim_rate );
			
			driver = self get_driver();
			if( IsDefined( driver ) && IsDefined( driver.update_reverse_anim ) )
			{
				driver [[ driver.update_reverse_anim ]]( anim_rate );
			}
		}
		else if( speed < 2 && turning_speed > 0.2 )	// turning idle
		{
			anim_rate = turning_speed;
			anim_index = 1;
			//anim_rate = 1;
			if( angular_velocity[2] <= 0 )
			{
				anim_index = 2;
			}

			self.current_anim = level.horse_anims[level.IDLE][anim_index];
			self SetAnimKnobAll( level.horse_anims[level.IDLE][anim_index], %horse::root, 1, 0.2, anim_rate );
			
			driver = self get_driver();
			if( IsDefined( driver ) && IsDefined( driver.update_turn_anim ) )
			{
				driver [[ driver.update_turn_anim ]]( anim_rate, anim_index );
			}

			self.current_anim_speed = level.IDLE;
			self.idle_end_time = 0;
		}
		else if( speed < 0.05 )	// Idle
		{
			//if ( self.state_loco == level.LOCO_MOTION )
			//{
			//	self thread horse_transition( false );
			//}
			//else
			{
				self.state_loco = level.LOCO_IDLE;
				update_idle_anim();
			}
		}
		else	// Running
		{
			//if ( self.state_loco == level.LOCO_IDLE )
			//{
			//	self thread horse_transition( true );
			//}
			//else
			{
				self.state_loco = level.LOCO_MOTION;
				self update_run_anim( speed );
			}
		}
		
		wait(0.05);
	}
}

update_run_anim( speed )
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
	self.current_anim = level.horse_anims[self.current_anim_speed][0];

	// check for sprint variation
	if ( self.current_anim_speed == level.SPRINT && isdefined( self.sprint_anim ) )
	{
		self.current_anim = self.sprint_anim;
	}

	self SetAnimKnobAll( self.current_anim, get_horse_root(), 1, 0.2, anim_rate );
	
	driver = self get_driver();
	if( IsDefined( driver ) && IsDefined( driver.update_run_anim ) )
	{
		driver [[ driver.update_run_anim ]]( anim_rate, self );
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
	//self endon( "death_finished" );
	self.script_crashtypeoverride = "horse";
	self.ignore_death_jolt = true;

	//self CancelAIMove();
	//self ClearVehGoalPos();
	//self SetBrake( true );
	self NotSolid();
	self SetVehicleAvoidance( false );
	
	if ( IS_TRUE( self.delete_on_death ) )
		return;

	self.dontfreeme = true;
	
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
			death_anim = get_explosive_death_horse();
			death_ai_anim = get_explosive_death_ai();
		}
		else
		{
			death_anim = get_explosive_death_horse();
			death_ai_anim = get_explosive_death_ai();
		}
	}

	/#
		if ( IsDefined( self.death_anim ) )
	{
		death_anim = self.death_anim;
	}
	#/
		
		if ( IsDefined( death_anim ) )
	{
		self SetFlaggedAnimKnobAll( "horse_death", death_anim, %horse::root, 1, 0.2, 1 );
		
		driver = self get_driver();
		if( IsDefined( driver ) )
		{
			if ( IsAI( driver ) )
			{
				driver.explosion_death_override = death_ai_anim;
			}
		}

		self waittillmatch( "horse_death", "stop" );
		if ( self.classname == "script_vehicle" )
		{
			self vehicle_setspeed( 0, 25, "Dead" );
		}
	}

	self.dontfreeme = undefined;
}

weapon_needs_left_hand_on_horse( weapon )
{
	switch( weapon )
	{
		case "minigun_sp":
		case "dsr50_sp":
		case "ballista_sp":
		case "barretm82_sp":
		case "ksg_sp":
		case "870mcs_sp":
		case "spas_sp":
		case "judge_sp":
		case "riotshield_sp":
		case "knife_ballistic_sp":
		case "hatchet_sp":
		case "satchel_charge_sp":
			return true;
		default:
			return false;
	}
	return false;
}

watch_for_weapon_switch_left_hand( driver ) // self == horse
{
	self endon("death");
	self endon("no_driver");
	driver.body endon("stop_player_ride");
	
	while( true )
	{
		//driver waittill( "weapon_switch_started", new_weapon );
		driver waittill( "weapon_change", new_weapon, old_weapon );
		
		needs_left = weapon_needs_left_hand_on_horse( new_weapon );
		
		driver thread update_view_hands( !needs_left );
		if( needs_left )
		{
			self.driver.body Hide();
		}
		else
		{
			self.driver.body Show();
		}
	}
}

sprint_start( driver )
{
	self.is_boosting = true;
	driver DisableWeapons();
	self.needs_sprint_release = true;
}

sprint_end( driver )
{
	self.is_boosting = false;
	self.needs_sprint_release = true;
	driver EnableWeapons();
}

horse_turn180()
{
	self endon( "death" );

	self SetBrake( 1 );
	self horse_waittill_no_roll();
	
	self ent_flag_set( "pause_animation" );

	driver = self get_driver();
	if ( IsDefined( driver ) && IsDefined( driver.update_turn180_anim ) )
	{
		driver thread [[ driver.update_turn180_anim ]]( self );
	}

	self AnimScripted( "horse_180turn", self.origin, self.angles, level.horse_anims[level.TURN_180] );
	//self SetAnimKnobAllRestart( level.horse_anims[level.REARBACK], %horse::root, 1, 0.2, 1 );
	len = GetAnimLength( level.horse_anims[level.TURN_180] );
	wait( len );

	self.idle_end_time = gettime();

	self ent_flag_clear( "pause_animation" );
	self SetBrake( 0 );
}

waitch_for_180turn( driver )
{
	self endon("death");
	self endon("no_driver");
	
	while( 1 )
	{
		if( driver JumpButtonPressed() )
		{
			self horse_turn180();
		}
		else
		{
			wait 0.05;
		}
	}
}

watch_for_sprint( driver ) // self == horse
{
	self endon("death");
	self endon("no_driver");

	//self.max_speed = 25.0; //self GetMaxSpeed( true ) / 17.6;
	self.max_speed = self GetMaxSpeed() / 17.6;
	self.max_sprint_speed = self.max_speed * 1.5;
	self.min_sprint_speed = self.max_speed * 0.65;
	self.min_sprint_start_speed = self.max_speed * 0.8;
	
	self.sprint_meter = 100;
	self.sprint_meter_max = 100;
	self.sprint_meter_min = self.sprint_meter_max * 0.25;
	self.sprint_time = 20;
	self.sprint_recover_time = 10;

	self.is_boosting = false;
	self.needs_sprint_release = false;	// sprint button needs to be released and pressed again
	
	bPressingSprint = false;
	bMeterEmpty = false;
//	bWeaponsDisabled = false;

	sprint_drain_rate = self.sprint_meter_max / self.sprint_time;
	sprint_recover_rate = self.sprint_meter_max / self.sprint_recover_time;
	
	while( true )
	{
		speed = self GetSpeedMPH();
		forward = AnglesToForward( self.angles );
		//IPrintLn( speed );

		stick = driver GetNormalizedMovement();
		//throttle = self GetThrottle();
		
		bCanStartSprint = ( bMeterEmpty == false ) && ( speed > self.min_sprint_start_speed ) && stick[0] > 0.85;
		bPressingSprint = self.driver SprintButtonPressed();

		if ( is_true( self.needs_sprint_release ) )
		{
			if ( !bPressingSprint )
			{
				self.needs_sprint_release = false;
			}
		}
		
		if ( bCanStartSprint && bPressingSprint && is_sprint_allowed() && !self.is_boosting && !self.needs_sprint_release )
		{
			self sprint_start( driver );
		}

		if ( self.is_boosting )
		{
			if ( !is_true( level.horse_sprint_unlimited ) )
			{
				self.sprint_meter -= sprint_drain_rate * 0.05;
			}
			
			throttle = self GetThrottle();
			
			// Check for a completely drained sprint meter
			if ( self.sprint_meter < 0 )
			{
				self.sprint_meter = 0;
				bMeterEmpty = true;

				self sprint_end( driver );
			}
			else if ( throttle < 0.3 || 
			         self.driver AttackButtonPressed() || 
			         speed < self.min_sprint_speed || 
			         self.driver ADSButtonPressed() || 
			         self.driver ChangeSeatButtonPressed() || // switch weapons
			         ( !self.needs_sprint_release && bPressingSprint ) )	// letting off the gas or trying to shoot stops sprint
			{
				if( self.driver ChangeSeatButtonPressed() )	// if switch weapons wait a bit, we just want it to pull out our current weapon first and don't allow the switch.  It pops and looks bad.
				{
					wait 0.1;
				}
				self sprint_end( driver );
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
			if ( !is_true( level.horse_sprint_unlimited ) )
			{
				self.sprint_meter += sprint_recover_rate * 0.05;
			}
			
			// If the meter was completely drained...don't allow sprint
			// until we've recovered the minimum amount
			if ( bMeterEmpty )
			{
				if ( self.sprint_meter > self.sprint_meter_min )
					bMeterEmpty = false;
			}
			
			if ( self.sprint_meter > self.sprint_meter_max )
				self.sprint_meter = self.sprint_meter_max;

			if( isdefined( level.horse_override_max_speed ) )
			{
				self SetVehMaxSpeed( level.horse_override_max_speed );
				// Slow me down
				if ( speed > level.horse_override_max_speed )
					self LaunchVehicle( forward * -200 * 0.05 );
			}
			else
			{
				max_speed = self.max_speed;
				self SetVehMaxSpeed( max_speed );
				
				if( driver PlayerADS() > 0.3 )
				{
					max_speed *= 0.65;
					if( speed > max_speed + 2 )
					{
						self SetVehMaxSpeed( self.max_speed * 0.8 );
					}
				}
				
				// Slow me down
				if ( speed > max_speed )
					self LaunchVehicle( forward * -200 * 0.05 );
			}
		}
		
		//IPrintLnBold( "Sprint Meter: " + self.sprint_meter );
		
		wait(0.05);
	}
}

is_sprint_allowed()
{
	if( isdefined( level.horse_allow_sprint ) )
	{
		return level.horse_allow_sprint;
	}
	else
	{
		return true;
	}
}

allow_horse_sprint( b_allow_sprint )
{
	assert( isdefined( b_allow_sprint ), "Must pass in a value for allow_horse_sprint()" );
	
	level.horse_allow_sprint = b_allow_sprint;
}

//Pass in new value to cap base horse speed. Pass in undefined to reset
override_player_horse_speed( n_speed )
{
	level.horse_override_max_speed = n_speed;
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

horse_waittill_no_roll()
{
	max_time = 1;
	while( max_time > 0 )
	{
		if( Abs( self.angles[2] ) < 5 )
		{
			break;
		}
		wait 0.05;
		max_time -= 0.05;
	}
}

horse_is_exit_position_ok()
{
	right = AnglesToRight( self.angles );
	
	start = self.origin + (0,0,15) + right * -10;
	end = start + right * -15;
	
	results = PhysicsTraceEx( start, end, (-14,-14,0), (14,14,60), self );
	
	if( results["fraction"] == 1 )
	{
		return true;
	}
	
	return false;
}

cant_dismount_hint()
{
	screen_message_create( &"SCRIPT_HINT_CANT_DISMOUNT_HERE" );
	wait 3;
	screen_message_delete();
}

watch_mounting() // self == horse
{
	self endon("death");
	
	flag_wait( "all_players_connected" );

	if( !self.disable_make_useable)
	{
		self MakeVehicleUsable();
	}

	self SetVehicleAvoidance( true );
	self.ignore_death_jolt = true;

	while(true)
	{
		self waittill( "trigger", useEnt );
		
		if( !IsPlayer( useEnt ) )
		{
			continue;
		}

		while ( 1 )
		{
			if ( !useEnt IsSwitchingWeapons() )
			{
				break;
			}
			wait( 0.05 );
		}
		
		self.driver = useEnt;
		self.driver set_mount_direction( self, self.driver.origin );

		self.driver AllowJump( false ); //DT 8141 Jump will be scripted
		
		self NotSolid();
		self ClearVehGoalPos();
		self CancelAIMove();

		need_left_hand = weapon_needs_left_hand_on_horse( self.driver GetCurrentWeapon() );
		self.driver thread update_view_hands( !need_left_hand );
		
		if( IS_TRUE( self.disable_mount_anim ) )
		{
			/#println("horse mounting anim disabled");#/
			wait_network_frame();
			
			if( !self.disable_weapon_changes )
			{
				self.driver DisableWeapons();
			}

			self.driver.body Unlink();
			
			wait_network_frame();
			if( !self.disable_weapon_changes )
			{
				self.driver EnableWeapons();
			}

			mount_anim = level.horse_player_anims[COMBAT_MOUNT][self.driver.side];
			org = GetStartOrigin( self.origin, self.angles, mount_anim );
			angles = self.angles;
			delta = GetCycleOriginOffset( angles, mount_anim );

			self.driver.body.origin = org + delta;
			self.driver.body.angles = angles;
			self.driver.body LinkTo( self, "tag_origin" );

			wait_network_frame();

			self horse_update_reigns( true );
		}
		else
		{
			self.driver.is_on_horse = false;
			self.driver mount( self );
		}
		
		if( need_left_hand )
		{
			self.driver.body Hide();
		}
		else
		{
			self.driver.body Show();
		}
		
		self MakeVehicleUsable();
		self UseBy( self.driver );
		
		wait( 0.1 );
		
		self.driver SetPlayerViewRateScale( 120 );
		self Solid();
		
		self thread watch_for_sprint( self.driver );
		//self thread waitch_for_180turn( self.driver );

		self thread watch_for_weapon_switch_left_hand( self.driver );
		
		// reset the horses idle anim after mounting
		self.idle_end_time = 0;

		//self thread wind_driving();
		self thread horse_fx();

		if ( is_true( self.disable_mount_anim ) )
		{
			self thread delay_body();
		}
		
		if( !self.disable_make_useable)
		{
			self MakeVehicleUsable();
		}

		while( true )
		{
			self waittill( "trigger", useEnt );
			if( useEnt == self.driver && self.dismount_enabled )
			{
				self SetBrake( 1 );
				self horse_waittill_no_roll();
				if( self horse_is_exit_position_ok() )
				{
					break;
				}
				else
				{
					//IPrintLnBold( "Can't dismount here" );
					level thread cant_dismount_hint();
					self SetBrake( 0 );
				}
			}
		}

		if ( is_true( self.is_boosting ) )	// stop sprinting before dismounting
		{
			self sprint_end( self.driver );
			wait_network_frame();
		}

		self.driver.body.rearback = false;	// in case the player was in the middle of a rearback
		self.driver.body notify( "stop_player_ride" );
		
		self UseBy( self.driver );

		self.driver AllowJump(true);
		
		self.driver ResetPlayerViewRateScale();
		
		self.driver.body Show();
		self.driver thread update_view_hands( false );
		
		if( IS_TRUE( self.disable_mount_anim ) )
		{
			/#println("horse mounting anim disabled");#/
			if( !self.disable_weapon_changes )
			{
				self.driver DisableWeapons();
			}
			self.driver Unlink();
			self.driver.body Unlink();
			self.driver.body Hide();
			self.driver.body.origin = self.driver.origin;
			self.driver.body.anlges = self.driver.angles;
			self.driver.body LinkTo( self.driver );
			wait_network_frame();
			
			if( !self.disable_weapon_changes )
			{
				self.driver EnableWeapons();
			}

			self horse_update_reigns( false );
		}
		else
		{
			self.driver dismount( self );
		}
		
		if( !self.disable_make_useable)
		{
			self MakeVehicleUsable();
		}
		
		self SetBrake( 0 );
		self notify("no_driver");
		self.driver.body.pause_animation = false;
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

update_view_hands( no_left )
{
	//wait( 0.5 );

	if ( no_left )
	{
		self SetViewModel( level.player_viewmodel_noleft );
	}
	else
	{
		self SetViewModel( level.player_viewmodel );
		//iprintln( "restore original viewmodel" );
	}
}

ready_horse()
{
	if ( is_true( level.horse_in_combat ) )
	{
		self SetFlaggedAnimKnobAllRestart( "mount_horse", level.horse_anims[COMBAT_MOUNT][0], %horse::root, 1, 0.2, 0 );
	}
	else
	{
		self SetFlaggedAnimKnobAllRestart( "mount_horse", level.horse_anims[COMBAT_MOUNT][0], %horse::root, 1, 0.2, 0 );
		//self SetFlaggedAnimKnobAllRestart( "mount_horse", level.horse_anims[level.MOUNT][0], %horse::root, 1, 0.2, 0 );
	}
}

horse_update_reigns( hide )
{
	if ( is_true( hide ) )
	{
		self.old_model = self.model;
		self SetModel( level.horse_viewmodel_variants[ self.model ] );
	}
	else
	{
		self SetModel( self.old_model );
	}

	wait( .1 );
}

horse_wait_for_reigns( notifyname, hide )
{
	self endon( "death" );

	self waittillmatch( notifyname, "horse_switch" );

	self horse_update_reigns( hide );
}

mount( horse )
{
	horse ent_flag_set( "mounting_horse" );
	
	if( !horse.disable_weapon_changes )
	{
		self DisableWeapons();
	}
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

	// Play the animation on the player body
	mount_anim = level.horse_player_anims[level.MOUNT][self.side];
	if ( is_true( level.horse_in_combat ) )
	{
		mount_anim = level.horse_player_anims[COMBAT_MOUNT][self.side];
	}

	self.body SetAnim( mount_anim, 1, 0, 0 );
	self PlayerLinkToAbsolute( self.body, "tag_player" );

	wait( 0.05 );

	horse_mount_anim = level.horse_anims[level.MOUNT][self.side];
	if ( is_true( level.horse_in_combat ) )
	{
		horse_mount_anim = level.horse_anims[COMBAT_MOUNT][self.side];
	}
	horse SetFlaggedAnimKnobAllRestart( "mount_horse", horse_mount_anim, %horse::root, 1, 0, 1 );
	horse thread horse_wait_for_reigns( "mount_horse", true );

	self.body animscripted( "mount", horse.origin, horse.angles, mount_anim, "normal", %generic_human::root, 1, 0, 0.65 );
	self.body Show();

	self.body waittillmatch( "mount", "end" );
	self.body StopAnimScripted();

	self Unlink();
	if( !horse.disable_weapon_changes )
	{
		self EnableWeapons();
	}
	
	self.body LinkTo( horse, "tag_origin" );
	//self thread watch_for_horse_melee(horse);//We might not need this
	
	//self SetClientDvar( "cg_fov", 85 );
	
	//self HideViewModel();
	self FreezeControls( false );
	
	
	self.is_on_horse = true;//Set self as mounted. Use to see if entity is on horseback or not.
	if( IsPlayer( self ) )
	{
		self.my_horse = horse;
		self thread set_horseback_melee_values();//Set player melee values used while on horseback
	}
	horse ent_flag_clear( "mounting_horse" );
}

dismount( horse )
{
	horse ent_flag_set( "dismounting_horse" );
	
	if ( self.health <= 0 )
		return;
	
	if( !horse.disable_weapon_changes )
	{
		self DisableWeapons();
	}
	self PlayerLinkToAbsolute( self.body, "tag_player" );
	
	// Play the animation on the horse
	horse_dismount_anim = level.horse_anims[level.DISMOUNT][0];
	if ( is_true( level.horse_in_combat ) )
	{
		horse_dismount_anim = level.horse_anims[COMBAT_DISMOUNT][0];
	}
	horse SetFlaggedAnimKnobAll( "horse_dismount", horse_dismount_anim, %horse::root, 1, 0.2, 1 );
	horse thread horse_wait_for_reigns( "horse_dismount", false );

	player_dismount_anim = level.horse_player_anims[level.DISMOUNT][0];
	if ( is_true( level.horse_in_combat ) )
	{
		player_dismount_anim = level.horse_player_anims[COMBAT_DISMOUNT][0];
	}

	// animate the player body model
	level.dismount_time = GetTime();
	self.body animscripted( "dismount", horse.origin, horse.angles, player_dismount_anim, "normal", %generic_human::root, 1, 0.2 );
	self.body waittillmatch( "dismount", "unlink" );
	self.body Unlink();
	self.body waittillmatch( "dismount", "end" );
	
	self.body StopAnimScripted();
	
	horse NotSolid();
	
	self Unlink();
	self ShowViewModel();
	
	if( !horse.disable_weapon_changes )
	{
		self EnableWeapons();
	}
	
	self.body Unlink();
	self.body Hide();
	self.body.origin = self.origin;
	self.body.angles = self.angles;
	self.body LinkTo( self );
	self.body ClearAnim( %player::root, 0 );
	
	horse Solid();
	
	horse MakeVehicleUsable();
	
	self.is_on_horse = false;//Set user as dismounted. Used for on horseback checks.
	if( IsPlayer( self ) )
	{
		self thread reset_player_melee_values();
		self.my_horse = undefined;
	}
	horse ent_flag_clear( "dismounting_horse" );
}

get_driver()
{
	if ( IsDefined( self.driver ) && IsDefined( self.driver.body ) )
		return self.driver.body;
	else if ( IsDefined( self.riders ) && self.riders.size > 0 && ( !IsDefined( self.unloadque ) || self.unloadque.size == 0 ) )
		return self.riders[0];
	
	return undefined;
}

is_on_horseback()
{
	if( !isdefined( self.is_on_horse ) )
	{
		return false;
	}
	
	return self.is_on_horse;
}

watch_for_horse_melee(horse)
{
	//endon
	while(1)
	{
		if( level.player meleebuttonpressed() )
		{
			
		}
		wait 0.05;
	}
}

//Set override values for player melee while on horseback
set_horseback_melee_values()
{
	SetSavedDvar( "player_meleerange", 110 );
	SetSavedDvar( "player_meleeheight", 100 );
	SetSavedDvar( "player_meleewidth", 100 );
}

//Set Distance, Height and Width values for the player's melee back to default values ( 64, 10, 10 )
reset_player_melee_values()
{
	SetSavedDvar( "player_meleerange", DEFAULT_PLAYER_MELEE_RANGE );
	SetSavedDvar( "player_meleeheight", DEFAULT_PLAYER_MELEE_HEIGHT );
	SetSavedDvar( "player_meleewidth", DEFAULT_PLAYER_MELEE_WIDTH );
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

	// Deaths
	positions[0].explosion_death = %generic_human::ai_horse_rider_sprint_explosive_death_fly_forward_a;

	return positions;
}

set_horse_in_combat( is_combat )
{
	level.horse_in_combat = is_combat;

	wait( 0.5 );

	if ( is_combat )
	{
		level.vehicle_aianims[ "horse" ][0].getin = %generic_human::ai_horse_rider_get_on_combat_leftside;
		level.vehicle_aianims[ "horse" ][0].getout = %generic_human::ai_horse_rider_get_off_combat_leftside;
		level.vehicle_aianims[ "horse_player" ][0].getin = %generic_human::ai_horse_rider_get_on_combat_leftside;
		level.vehicle_aianims[ "horse_player" ][0].getout = %generic_human::ai_horse_rider_get_off_combat_leftside;
	}
	else
	{
		level.vehicle_aianims[ "horse" ][0].getin = %generic_human::ai_horse_rider_get_on_leftside;
		level.vehicle_aianims[ "horse" ][0].getout = %generic_human::ai_horse_rider_get_off_leftside;
		level.vehicle_aianims[ "horse_player" ][0].getin = %generic_human::ai_horse_rider_get_on_leftside;
		level.vehicle_aianims[ "horse_player" ][0].getout = %generic_human::ai_horse_rider_get_off_leftside;
	}
}

horse_actor_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( self.health > 0 && !is_true( self.magic_bullet_shield ) )
	{
		if ( isdefined( eInflictor.vehicletype ) && ( eInflictor.vehicletype == "horse_player" || eInflictor.vehicletype == "horse" ) && sMeansOfDeath == "MOD_CRUSH" )
		{
			bones = [];
			bones[0] = "J_SpineUpper";
			bones[1] = "J_Ankle_LE";
			bones[2] = "J_Knee_LE";
			bones[3] = "J_Head";
			bones = array_randomize( bones );

			const multiplier = 5;
			speed = eInflictor GetSpeedMPH() * multiplier;
			up = RandomFloatRange( 0.15, 0.35 );

			velocity = ( vDir[0], vDir[1], up );
			velocity *= speed;

			self StartRagdoll();
			self LaunchRagdoll( velocity, bones[0] );

			player = getplayers()[0];
			player PlayRumbleOnEntity( "damage_heavy" );
			
			if( isplayer( eattacker ) )
			{
				eattacker playsound( "evt_horse_trample_ai" );
				
				if ( self.team == "axis" && !IsDefined( self.killed_by_horse ) )
				{
				    self.killed_by_horse = true;  // only send notify once per guy
					level notify( "player_trampled_ai_with_horse" );  // used for challenge in afghanistan
				}
			}
			
			Earthquake( 0.5, 0.3, player.origin, 150 );

			return self.health;
		}
	}
	
	return iDamage;
}

horse_damage_panic()
{
	self endon( "death" );
	self endon( "panic" );

	if ( is_true( self.is_panic ) )
		return;
	
	self.is_panic = true;
	wait 12;
	self.is_panic = false;
}

HorseCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	self horse_damage_panic();
	
	if( sMeansOfDeath == "MOD_CRUSH" ) // Run over by a vehicle
	{
		driver = self GetSeatOccupant( 0 );
		if( IsDefined( driver ) )
		{
			if( Abs( self.angles[2] ) > 35 )
			{
				damage = iDamage;
				if( damage < 30 )
					damage = 30;
				driver DoDamage( damage, eAttacker.origin, eAttacker );
			}
		}
	}
	
	return iDamage;
}