#include clientscripts\_utility; 

#using_animtree("vehicles");

//SELF = Player Horse
autoexec init()
{
	/#println("*** Client : _horse_ride running...");#/
	
	clientscripts\_driving_fx::add_vehicletype_callback( "horse_player", ::horse_setup );
	clientscripts\_driving_fx::add_vehicletype_callback( "horse", ::horse_setup );
	
	clientscripts\_footsteps::registerVehicleFootStepCallback( "horse_player", ::horse_feet );
	clientscripts\_footsteps::registerVehicleFootStepCallback( "horse", ::horse_feet );
	
	// horse
	level.horseFootstepBones = [];
	level.horseFootstepBones[ "step_front_left_idle"  ]		= "Bone_H_HandEnd_L";
	level.horseFootstepBones[ "step_front_right_idle" ]		= "Bone_H_HandEnd_R";
	level.horseFootstepBones[ "step_rear_left_idle"   ]		= "Bone_H_FootEnd_L";
	level.horseFootstepBones[ "step_rear_right_idle"  ]		= "Bone_H_FootEnd_R";
	
	level.horseFootstepBones[ "step_front_left_walk"  ]		= "Bone_H_HandEnd_L";
	level.horseFootstepBones[ "step_front_right_walk" ]		= "Bone_H_HandEnd_R";
	level.horseFootstepBones[ "step_rear_left_walk"   ]		= "Bone_H_FootEnd_L";
	level.horseFootstepBones[ "step_rear_right_walk"  ]		= "Bone_H_FootEnd_R";
	
	level.horseFootstepBones[ "step_front_left_trot"  ]		= "Bone_H_HandEnd_L";
	level.horseFootstepBones[ "step_front_right_trot" ]		= "Bone_H_HandEnd_R";
	level.horseFootstepBones[ "step_rear_left_trot"   ]		= "Bone_H_FootEnd_L";
	level.horseFootstepBones[ "step_rear_right_trot"  ]		= "Bone_H_FootEnd_R";
	
	level.horseFootstepBones[ "step_front_left_canter"  ]	= "Bone_H_HandEnd_L";
	level.horseFootstepBones[ "step_front_right_canter" ]	= "Bone_H_HandEnd_R";
	level.horseFootstepBones[ "step_rear_left_canter"   ]	= "Bone_H_FootEnd_L";
	level.horseFootstepBones[ "step_rear_right_canter"  ]	= "Bone_H_FootEnd_R";
	
	level.horseFootstepBones[ "step_front_left_sprint"  ]	= "Bone_H_HandEnd_L";
	level.horseFootstepBones[ "step_front_right_sprint" ]	= "Bone_H_HandEnd_R";
	level.horseFootstepBones[ "step_rear_left_sprint"   ]	= "Bone_H_FootEnd_L";
	level.horseFootstepBones[ "step_rear_right_sprint"  ]	= "Bone_H_FootEnd_R";
	
	//if( !IsDefined( level._effect ) )
	//	level._effect = [];
		
	level._effect["horse_step"]									= loadFX("vehicle/treadfx/fx_afgh_treadfx_horse_hoof_impact");
}

horse_setup( localClientNum )
{
	self thread clientscripts\_driving_fx::collision_thread( localClientNum );
	//self thread clientscripts\_driving_fx::jump_landing_thread( localClientNum );
		
	self thread horse_mount();	
}

getFootOrigin( note )
{
	assert( IsDefined(level.horseFootstepBones) );

	boneOrigin = (0,0,0);

	boneName = level.horseFootstepBones[ note ];

	if( IsDefined(boneName) )
		boneOrigin = self GetTagOrigin( boneName );
	//else
	//	PrintLn( "missing note " + note );

	// bone not found
	if( !IsDefined(boneOrigin) )
	{
		//PrintLn( "missing bone " + boneName );
		boneOrigin = self.origin;
	}
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
	
	if ( self IsLocalClientDriver( localClientNum ) )
	{
		if ( note == "step_front_left_walk" || note == "step_rear_left_walk" || 
		    note == "step_front_left_trot" || note == "step_rear_left_trot"|| 
		    note == "step_front_left_run" || note == "step_rear_left_run" || 
		    note == "step_front_left_sprint" || note == "step_rear_left_sprint" )
		{
			player = getlocalplayer( localClientNum );	
			player PlayRumbleOnEntity( localClientNum, "pullout_small" );
			
			speed = self GetSpeed() / 17.6;
			speed = Abs( speed ) / 25.0;
			
			intensity = 0.065 + ( 0.065 * speed );
			player Earthquake(intensity, 0.3, self.origin, 200);
		}
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

