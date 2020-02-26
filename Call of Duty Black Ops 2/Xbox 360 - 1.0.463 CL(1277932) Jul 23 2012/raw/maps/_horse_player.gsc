#include common_scripts\utility; 
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include animscripts\utility;

#using_animtree("player");

init()
{
	flag_wait( "all_players_connected" );

	player = get_players()[0];
	player spawn_player_body();

	SetSavedDvar( "player_disableWeaponsOnVehicle", "0" );
	SetSavedDvar( "player_lookAtEntityAllowChildren", "1" );
}

precache_models()
{
	level.player_reigns_model = "c_usa_mason_afgan_reigns_viewbody";

	precachemodel( level.player_reigns_model );
}

spawn_player_body()
{
	if( IsDefined( self.body ) )
	{
		return;
	}

	self.body = spawn( "script_model", self.origin );
	self.body.angles = self.angles;

	self.body SetModel( level.player_reigns_model );
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

	self.body setup_body_funcs();
}

// self == body
setup_body_funcs()
{
	self.update_idle_anim = ::player_idle_anim;
	self.update_reverse_anim = ::player_reverse_anim;
	self.update_turn_anim = ::player_turn_anim;
	self.update_run_anim = ::player_run_anim;
	self.update_transition_anim = ::player_transition;
	self.update_stop_anim = ::player_stop;
	self.update_rearback_anim = ::player_rearback;
}

player_idle_anim( idle_struct, anim_index )
{
	idle_anim = idle_struct.player_animations[ anim_index ];
	self SetAnimKnobAllRestart( idle_anim, %root, 1, 0.2, 1 );
}

player_reverse_anim( anim_rate )
{
	self SetAnimKnobAll( level.horse_player_anims[ level.REVERSE ], %root, 1, 0.2, anim_rate );
}

player_turn_anim( anim_rate, anim_index )
{
	self SetAnimKnobAll( level.horse_player_anims[ level.IDLE ][ anim_index ], %root, 1, 0.2, anim_rate );
}

player_run_anim( anim_rate, horse )
{
	sprint_index = 0;
	if ( horse.current_anim_speed == level.SPRINT && is_true( horse.is_boosting ) )
	{
		sprint_index = 3;
	}

	self SetAnimKnobAll( level.horse_player_anims[ horse.current_anim_speed ][ sprint_index ], %root, 1, 0.2, anim_rate );
}

// self == body
player_rearback( horse )
{
	self endon( "death" );
	self endon( "stop_player_ride" );

	player = get_players()[0];

	player FreezeControls( true );

	self.pause_animation = true;
	horse.dismount_enabled = false;

	self thread follow_horse_angles( horse );

	rearback_anim = level.horse_player_anims[ level.REARBACK ];

	self SetAnimKnobAllRestart( rearback_anim, %root, 1, 0.2, 1 );
	len = GetAnimLength( rearback_anim );
	wait( len );

	self notify( "stop_follow" );

	self.currAnimation = undefined;
	self.pause_animation = false;

	player FreezeControls( false );
}

follow_horse_angles( horse )
{
	//self endon( "stop_follow" );

	horse UseBy( horse.driver );
	horse MakeVehicleUnusable();
	horse.driver PlayerLinkToAbsolute( horse.driver.body, "tag_player" );

	self waittill( "stop_follow" );

	horse.driver Unlink();
	horse MakeVehicleUsable();
	horse UseBy( horse.driver );
	
	if(IS_TRUE(horse.disable_make_useable))
	{
		horse MakeVehicleUnusable();
	}
	
	wait_network_frame();
	horse.dismount_enabled = true;
}

player_play_anim( animname )
{
	self endon( "death" );
	self endon( "stop_player_ride" );

	self SetAnimKnobAll( animname, %root, 1, 0.2, 1 );
	wait( GetAnimLength( animname ) );
}

// self == body
player_stop()
{
	self endon( "death" );
	self endon( "stop_player_ride" );

	self.pause_animation = true;

	player_play_anim( %int_horse_player_short_stop_init );
	player_play_anim( %int_horse_player_short_stop_finish );

	self.currAnimation = undefined;
	self.pause_animation = false;
}

// self == body
player_transition( start, speed )
{
	self endon( "death" );
	self endon( "stop_player_ride" );

	self.pause_animation = true;

	if ( is_true( start ) )
	{
		self player_play_anim( %int_horse_player_idle_to_walk );
	}
	else
	{
		if ( speed == level.TROT )
		{
			self player_play_anim( %int_horse_player_trot_to_idle );
		}
		else if ( speed == level.RUN )
		{
			self player_play_anim( %int_horse_player_canter_to_idle );
		}
		else if ( speed == level.SPRINT )
		{
			self player_play_anim( %int_horse_player_sprint_to_idle );
		}
		else
		{
			self player_play_anim( %int_horse_player_walk_to_idle );
		}
	}

	self.currAnimation = undefined;
	self.pause_animation = false;
}

