#include clientscripts\_utility; 

#define CF_PLAYER_AIMING		0
#define CF_PLAYER_AIMING_ADS	1

#define TURRET_SPAN_LEFT		50
#define TURRET_SPAN_RIGHT		50
#define TURRET_SPAN_UP			60
#define TURRET_SPAN_DOWN		30

#using_animtree("vehicles");

//SELF = Player Horse
autoexec init()
{
	println("*** Client : _horse_ride running...");
	
	clientscripts\_driving_fx::add_vehicletype_callback( "horse_player", ::horse_player_setup );
	clientscripts\_driving_fx::add_vehicletype_callback( "horse", ::horse_setup );
	
	clientscripts\_footsteps::registerVehicleFootStepCallback( "horse_player", ::horse_feet );
	clientscripts\_footsteps::registerVehicleFootStepCallback( "horse", ::horse_feet );
	
	// horse
	level.horseFootstepBones = [];
	level.horseFootstepBones[ "step_front_left_idle"  ]		= "Bone_H_Hand_L";
	level.horseFootstepBones[ "step_front_right_idle" ]		= "Bone_H_Hand_R";
	level.horseFootstepBones[ "step_rear_left_idle"   ]		= "Bone_H_Foot_L";
	level.horseFootstepBones[ "step_rear_right_idle"  ]		= "Bone_H_Foot_R";
	
	level.horseFootstepBones[ "step_front_left_walk"  ]		= "Bone_H_Hand_L";
	level.horseFootstepBones[ "step_front_right_walk" ]		= "Bone_H_Hand_R";
	level.horseFootstepBones[ "step_rear_left_walk"   ]		= "Bone_H_Foot_L";
	level.horseFootstepBones[ "step_rear_right_walk"  ]		= "Bone_H_Foot_R";
	
	level.horseFootstepBones[ "step_front_left_trot"  ]		= "Bone_H_Hand_L";
	level.horseFootstepBones[ "step_front_right_trot" ]		= "Bone_H_Hand_R";
	level.horseFootstepBones[ "step_rear_left_trot"   ]		= "Bone_H_Foot_L";
	level.horseFootstepBones[ "step_rear_right_trot"  ]		= "Bone_H_Foot_R";
	
	level.horseFootstepBones[ "step_front_left_canter"  ]	= "Bone_H_Hand_L";
	level.horseFootstepBones[ "step_front_right_canter" ]	= "Bone_H_Hand_R";
	level.horseFootstepBones[ "step_rear_left_canter"   ]	= "Bone_H_Foot_L";
	level.horseFootstepBones[ "step_rear_right_canter"  ]	= "Bone_H_Foot_R";
	
	level.horseFootstepBones[ "step_front_left_sprint"  ]	= "Bone_H_Hand_L";
	level.horseFootstepBones[ "step_front_right_sprint" ]	= "Bone_H_Hand_R";
	level.horseFootstepBones[ "step_rear_left_sprint"   ]	= "Bone_H_Foot_L";
	level.horseFootstepBones[ "step_rear_right_sprint"  ]	= "Bone_H_Foot_R";
	
	//if( !IsDefined( level._effect ) )
	//	level._effect = [];
		
	level._effect["horse_step"]									= loadFX("vehicle/treadfx/fx_afgh_treadfx_horse_hoof_impact");

	//level.player_gunModel = "t6_wpn_pistol_m1911_view";
	level.player_gunModel = "t5_weapon_uzi_viewmodel";

	register_clientflag_callbacks();
}

register_clientflag_callbacks()
{
	register_clientflag_callback( "scriptmover", CF_PLAYER_AIMING, clientscripts\_horse_ride::player_aiming_toggle );
	register_clientflag_callback( "scriptmover", CF_PLAYER_AIMING_ADS, clientscripts\_horse_ride::player_aiming_ads_toggle );
}

horse_setup( localClientNum )
{
	self thread clientscripts\_driving_fx::collision_thread( localClientNum );
	//self thread clientscripts\_driving_fx::jump_landing_thread( localClientNum );
	self thread clientscripts\_horse_ride_audio::init();

	self thread horse_mount();
}

horse_player_setup( localClientNum )
{
	self horse_setup( localClientNum );
}

getFootOrigin( note )
{
	assert( IsDefined(level.horseFootstepBones) );

	boneOrigin = (0,0,0);

	boneName = level.horseFootstepBones[ note ];

	if( IsDefined(boneName) )
		boneOrigin = self GetTagOrigin( boneName );

	// bone not found
	if( !IsDefined(boneOrigin) )
		boneOrigin = self.origin;
	else
		boneOrigin -= (0,0,2);

	return boneOrigin;
}

getFootEffect( ground_type )
{
	return level._effect["horse_step"];
}

horse_feet( localClientNum, note, ground_type )
{
	origin = getFootOrigin( note );
	
	sound_alias = "fly_" + note; //+ "_" + ground_type;
	
	if ( self IsLocalClientDriver( localClientNum ) )
	{
		sound_alias += "_plr";
	}
	
	else
	{
		sound_alias += "_npc";
	}	
	
	sound_alias = sound_alias + "_" + ground_type;	
		
	PlaySound( localClientNum, sound_alias, origin );
	
	effect = getFootEffect( ground_type );
	
	if( IsDefined(effect) )
	{
		PlayFX( localClientNum, effect, origin, (0,0,1) );
	}
}

horse_mount( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );

	while ( 1 )
	{
		self waittill( "enter_vehicle", user );

		if ( user isplayer() )
		{
			level.player_horse = self;
			wait( 0.5 );	// to prevent getting an early exit notify

			self waittill( "exit_vehicle" );

			level.player_horse = undefined;
		}
	}
}

player_aiming_toggle( localClientNum, set, newEnt )
{
	player = getlocalplayer( localClientNum );

	if ( !isdefined( level.gunModel ) )
	{
		level.gunModel = Spawn( localClientNum, player.origin, "script_model" );
		level.gunModel SetModel( level.player_gunModel );
		level.gunModel UseWeaponHideTags( "uzi_sp" );
	}

	if ( set )
	{
		self.player_aim = true;
		self thread update_player_aiming( player );
		self thread update_player_shooting( player );
	}
	else
	{
		self.player_aim = false;
		self thread stop_player_aiming( player );
		self notify( "stop_shooting" );
	}
}

#using_animtree("player");

player_aiming_ads_toggle( localClientNum, set, newEnt )
{
	player = getlocalplayer( localClientNum );

	if ( set )
	{
		player.is_ads = true;
	}
	else
	{
		player.is_ads = false;
	}
}

add_player_weapon()
{
}

//--------------------------------------------------------------------------------------------------------------------------------
// The player's left arm and body is controlled by server script to stay in sync with the horse.
// The player's aiming and shooting needs to be in client script to run smooth.
//--------------------------------------------------------------------------------------------------------------------------------
update_player_aiming( player )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	self endon( "stop_aiming" );
	level endon( "save_restore" );
	level endon( "cease_aiming" );

	player.is_ads = false;

	horse = level.player_horse;
	if ( !isdefined( horse ) )
	{
		return;
	}

	wait( 0.1 );

	level.gunModel Linkto( self, "tag_weapon" );
	level.gunModel Show();

	self SetAnim( %int_horse_player_gun_aim_2, 1.0, 0.0, 1.0 );
	self SetAnim( %int_horse_player_gun_aim_4, 1.0, 0.0, 1.0 );
	self SetAnim( %int_horse_player_gun_aim_6, 1.0, 0.0, 1.0 );
	self SetAnim( %int_horse_player_gun_aim_8, 1.0, 0.0, 1.0 );

	self SetAnim( %int_horse_player_gun_aim_5, 1.0, 0.2, 1.0 );

	while ( 1 )
	{
		if ( player.is_ads )
		{
			self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_5, 1.0, 0.2, 1.0 );
		}
		else
		{
			self SetAnimKnobLimited( %int_horse_player_gun_aim_5, 1.0, 0.2, 1.0 );
		}

		player_angles = player GetPlayerAngles();
		horse_angles = horse.angles;

		yawOffset = AngleClamp180( horse_angles[1] - player_angles[1] );
		pitchOffset = AngleClamp180( horse_angles[0] - player_angles[0] );

		if ( yawOffset > 0 )
		{
			yawOffset = yawOffset / TURRET_SPAN_RIGHT;
		}
		else
		{
			yawOffset = yawOffset / TURRET_SPAN_LEFT;
		}

		if ( pitchOffset > 0 )
		{
			pitchOffset = pitchOffset / TURRET_SPAN_UP;
		}
		else
		{
			pitchOffset = pitchOffset / TURRET_SPAN_DOWN;
		}

		if ( yawOffset > 1 )
		{
			yawOffset = 1;
		}
		else if ( yawOffset < -1 )
		{
			yawOffset = -1;
		}

		if ( pitchOffset > 1 )
		{
			pitchOffset = 1;
		}
		else if ( pitchOffset < -1 )
		{
			pitchOffset = -1;
		}

		if ( yawOffset > 0 )
		{
			self SetAnimLimited( %horse_aim_6, yawOffset, 0.0, 1.0 );
			self SetAnimLimited( %horse_aim_4, 0, 0.0, 1.0 );

			if ( player.is_ads )
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_6, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_4, 0, 0.2, 1.0 );
			}
			else
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_6, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_4, 0, 0.2, 1.0 );
			}
		}
		else
		{
			weight = abs( yawOffset );
			self SetAnimLimited( %horse_aim_4, weight, 0.0, 1.0 );
			self SetAnimLimited( %horse_aim_6, 0, 0.0, 1.0 );

			if ( player.is_ads )
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_4, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_6, 0, 0.2, 1.0 );
			}
			else
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_4, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_6, 0, 0.2, 1.0 );
			}
		}

		if ( pitchOffset > 0 )
		{
			self SetAnimLimited( %horse_aim_8, pitchOffset, 0.0, 1.0 );
			self SetAnimLimited( %horse_aim_2, 0, 0.0, 1.0 );

			if ( player.is_ads )
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_8, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_2, 0, 0.2, 1.0 );
			}
			else
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_8, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_2, 0, 0.2, 1.0 );
			}
		}
		else
		{
			weight = abs( pitchOffset );
			self SetAnimLimited( %horse_aim_2, weight, 0.0, 1.0 );
			self SetAnimLimited( %horse_aim_8, 0, 0.0, 1.0 );

			if ( player.is_ads )
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_2, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_ads_8, 0, 0.2, 1.0 );
			}
			else
			{
				self SetAnimKnobLimited( %int_horse_player_gun_aim_2, 1.0, 0.2, 1.0 );
				self SetAnimKnobLimited( %int_horse_player_gun_aim_8, 0, 0.2, 1.0 );
			}
		}

		wait( 0.01 );
	}
}

stop_player_aiming( player )
{
	self notify( "stop_aiming" );

	level.gunModel Unlink();
	level.gunModel Hide();
}

update_player_shooting( player )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	self endon( "stop_shooting" );
	level endon( "save_restore" );

	wait( 0.1 );

	self SetAnim( %horse_fire, 1.0, 0.0, 1.0 );

	self.horse_fire = %int_horse_player_gun_fire;

	while ( 1 )
	{
		horse = level.player_horse;
		horse waittill( "weapon_fired" );

		fire_anim = self.horse_fire;
		self SetAnimLimitedRestart( fire_anim, 1.0, 0.2, 1.0 );
		len = GetAnimLength( fire_anim );
		wait( len );
		self ClearAnim( fire_anim, 0 );
	}
}