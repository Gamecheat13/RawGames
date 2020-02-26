/* ---------------------------------------------------------------------------------
This script handles player swimming
-----------------------------------------------------------------------------------*/
#include maps\_utility;
#include common_scripts\utility;

#using_animtree("player");

/* ---------------------------------------------------------------------------------
THESE SETTINGS SHOULD MATCH ON THE CLIENT AND SERVER
-----------------------------------------------------------------------------------*/
settings()
{
	level._swimming = SpawnStruct();

	level._swimming.swim_times[0] = 0;
	level._swimming.swim_times[1] = 15;
	level._swimming.swim_times[2] = 25;
	level._swimming.swim_times[3] = 32;
	level._swimming.swim_times[4] = 37;

	level._swimming.num_phases = level._swimming.swim_times.size - 1;

	level._swimming.drown_reset_times[0] = 1;
	level._swimming.drown_reset_times[1] = 2;
	level._swimming.drown_reset_times[2] = 2;
	level._swimming.drown_reset_times[3] = 4;
	level._swimming.drown_reset_times[4] = 4;
	
	// DOF will not work if when the swimming distortion (sheeting) is enabled.

	//default depth of field settings if enabled
	//SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )	
	level._swimming.toggle_depth_of_field = false;
	level._swimming.dof_near_start = 10;
	level._swimming.dof_near_end = 60;
	level._swimming.dof_far_start = 341;
	level._swimming.dof_far_end = 2345;
	level._swimming.dof_near_blur = 6;
	level._swimming.dof_far_blur = 2.16;

	SetDvar("bg_bobAmplitudeSwimming", "2 2");
}

/* DEAD CODE REMOVAL
set_default_vision_set(vision_set)
{
}

set_swimming_vision_set(vision_set)
{
// 	VisionSetUnderWater(vision_set);
}
*/
main()
{
	if ( is_false(level.swimmingFeature) )
	{
		return;
	}

	// TODO: HACK!! DOF is hacked in so this is needed or else DOF
	// is still active when the level restarts.
	//SetDvar("r_dof_tweak", 0);

	settings();

	enable();

	anims();

	fx();

	SetDvar("player_swimTime", 1000);	// disable - handle drowning in script

	OnPlayerConnect_Callback(::on_player_connect);
	OnSaveRestored_Callback(::on_save_restored);
}

/* ---------------------------------------------------------------------------------
player connect callback
self = player
-----------------------------------------------------------------------------------*/
on_player_connect()
{
	PrintLn("^4_swimming - server: server player connect");

	init_player();

	wait 1; // Magic wait to let client catch up

	self thread swimmingTracker();
	self thread swimmingDrown();
	self thread underWaterFX();

	/#
		//test();
	#/
}

test()
{
	/#
		while (true)
		{
			show_swimming_arms();
			wait 5;
			hide_swimming_arms();
			wait 5;
		}
	#/
}

/* ---------------------------------------------------------------------------------
save restored callback
-----------------------------------------------------------------------------------*/
on_save_restored()
{
	wait 2;

	player = get_players()[0];
	eye_height = player get_eye()[2];
	water_height = GetWaterHeight( player.origin );
	player._swimming.current_depth = water_height - eye_height;

	if (player._swimming.current_depth > 0)
	{
		/#
		PrintLn("^4_swimming - server: save restore, underwater");
		#/
			
		player._swimming.is_underwater = true;
		player notify("underwater");

		player SetClientFlag(level.CF_PLAYER_UNDERWATER);				
	}
	else
	{
	/#
		PrintLn("^4_swimming - server: save restore, not underwater");
	#/
	}
}

disable()
{
	self._swimming.is_swimming_enabled = false;
	self ClientNotify("_swimming:disable");
}

enable()
{
	self._swimming.is_swimming_enabled = true;
	self ClientNotify("_swimming:enable");
}

/* ---------------------------------------------------------------------------------
These anims are used on the client, but need to be referenced on the server to work
-----------------------------------------------------------------------------------*/
anims()
{
	level._swimming.anims["breaststroke"][0] = %viewmodel_swim_breaststroke_a;
	level._swimming.anims["breaststroke"][1] = %viewmodel_swim_breaststroke_b;
	level._swimming.anims["breaststroke"][2] = %viewmodel_swim_breaststroke_c;

	level._swimming.anims["backwards"][0] = %viewmodel_swim_backwards_a;
	level._swimming.anims["backwards"][1] = %viewmodel_swim_backwards_b;
	level._swimming.anims["backwards"][2] = %viewmodel_swim_backwards_c;

	level._swimming.anims["left"][0] = %viewmodel_swim_to_left;

	level._swimming.anims["right"][0] = %viewmodel_swim_to_right;

	level._swimming.anims["tread"][0] = %viewmodel_swim_tread_water;
}

/* ---------------------------------------------------------------------------------
Load the fx. They need to be loaded here even though they are used on the client.
self = player
-----------------------------------------------------------------------------------*/
fx()
{
	// client fx - used on client, but need to be pre-loaded on the server too
	level._effect["underwater"] = LoadFX( "env/water/fx_water_particles_surface_fxr" );
	level._effect["deep"] = LoadFX( "env/water/fx_water_particle_dp_spawner" );
	level._effect["drowning"] = LoadFX( "bio/player/fx_player_underwater_bubbles_drowning" );
	level._effect["exhale"] = LoadFX( "bio/player/fx_player_underwater_bubbles_exhale" );
	level._effect["hands_bubbles_left"] = LoadFX( "bio/player/fx_player_underwater_bubbles_hand_fxr" );
	level._effect["hands_bubbles_right"] = LoadFX( "bio/player/fx_player_underwater_bubbles_hand_fxr_right" );
	level._effect["hands_debris_left"] = LoadFX( "bio/player/fx_player_underwater_hand_emitter");
	level._effect["hands_debris_right"] = LoadFX( "bio/player/fx_player_underwater_hand_emitter_right");
	level._effect["sediment"] = LoadFX( "bio/player/fx_player_underwater_sediment_spawner");
	level._effect["wake"] = LoadFX( "bio/player/fx_player_water_swim_wake" );
	level._effect["ripple"] = LoadFX( "bio/player/fx_player_water_swim_ripple" );
}


/* ---------------------------------------------------------------------------------
Initialize the player for swimming.
self = player
-----------------------------------------------------------------------------------*/
init_player()
{
	self._swimming = SpawnStruct();
	self._swimming.is_swimming = false;
	self._swimming.is_underwater = false;
	self._swimming.is_swimming_enabled = true;
}

/* ---------------------------------------------------------------------------------
tracks where the player is in the water
self = player
-----------------------------------------------------------------------------------*/
swimmingTracker()
{
	self endon("death");
	self endon("disconnect");

	while (true)
	{
		if (self._swimming.is_swimming_enabled)
		{
			eye_height = self get_eye()[2];
			water_height = GetWaterHeight( self.origin );
			self._swimming.current_depth = water_height - eye_height;
		}
		else
		{
			self._swimming.current_depth = 0;
		}

		if (self._swimming.current_depth > 0)
		{
			if ( !self._swimming.is_underwater )
			{
				self._swimming.reset_time = 0;
				self._swimming.is_underwater = true;
				self notify("underwater");

				self SetClientFlag(level.CF_PLAYER_UNDERWATER);				
			}
		}
		else if (self._swimming.is_underwater)
		{
			self._swimming.is_underwater = false;
			self notify("surface");

			self ClearClientFlag(level.CF_PLAYER_UNDERWATER);
		}

		wait .05;
	}
}

/* ---------------------------------------------------------------------------------
Handle any server-side underwater fx
self = player
-----------------------------------------------------------------------------------*/
underWaterFX()
{
	self endon("death");
	self endon("disconnect");
	self endon("swimming_end");

	while( true )
	{
		self waittill("underwater");

		if(level._swimming.toggle_depth_of_field == true)
		{
/#			
			PrintLn("^4_swimming - server: depth of field ON");
#/			
			self SetDepthOfField(level._swimming.dof_near_start
								,level._swimming.dof_near_end
								,level._swimming.dof_far_start
								,level._swimming.dof_far_end
								,level._swimming.dof_near_blur
								,level._swimming.dof_far_blur
								);
		}
		else
		{
			PrintLn("^4_swimming - server: depth of field is NOT used.");
		}

// 		self SetClientDvars("r_reviveFX_enable", "1",
// 							"r_reviveFX_edgeColorTemp", "6500",
// 							"r_reviveFX_edgeSaturation", "1.3",
// 							"r_reviveFX_edgeScale", "0.65 0.65 0.65",
// 							"r_reviveFX_edgeContrast", "1.62 1.62 1.62",
// 							"r_reviveFX_edgeOffset", "-0.72 -0.72 -0.72",
// 							"r_reviveFX_edgeMaskAdjust", "-0.63",
// 							"r_reviveFX_edgeAmount", "0.56"
// 							);

		self waittill("surface");

		if(level._swimming.toggle_depth_of_field == true)
		{
/#			
			PrintLn("^4_swimming - server: depth of field OFF");
#/
			
			//to turn off SetDepthOfField, _start value must be >= _end settings for both near and far.
			near_start = level._swimming.dof_near_end;
			far_start = level._swimming.dof_far_end;
			
			self SetDepthOfField(near_start
								,level._swimming.dof_near_end
								,far_start
								,level._swimming.dof_far_end
								,level._swimming.dof_near_blur
								,level._swimming.dof_far_blur
								);
		}

// 		self SetClientDvar("r_reviveFX_enable", "0");
	}
}

/* ---------------------------------------------------------------------------------
Track when the player should die from drowning.
self = player
-----------------------------------------------------------------------------------*/
swimmingDrown()
{
	self endon("death");
	self endon("disconnect");

	phase = 0;
	last_phase = 0;

	self._swimming.swim_time = 0;
	self._swimming.reset_time = 0;

	while ((phase < level._swimming.num_phases) || !self._swimming.is_underwater)
	{
		wait(.05);

		phase = self advance_drowning_phase(last_phase);

		if (phase != last_phase)
		{
			last_phase = phase;

			PrintLn("^4_swimming - server: phase " + phase);

			if (phase == level._swimming.num_phases)
			{
				wait 2;
			}
		}
	}

	self Suicide();
}

/* ---------------------------------------------------------------------------------
advance the drowning phase based on how much time the player has been in the water
self = player
-----------------------------------------------------------------------------------*/
advance_drowning_phase(phase)
{
	t_delta = swimming_get_time();

/#	
	if( IsGodMode( self ) )
	{
		return 0;
	}

	if(GetDvarint( "disable_drown") == 1)
	{
		return 0;
	}	
#/
	// special case for deep sea swimming       
	if( IsDefined(level.disable_drowning) && level.disable_drowning )
	{
		return 0;	
	}

	if (self._swimming.is_underwater)	// continue drowning
	{
		self._swimming.swim_time += t_delta;

		for (phase = level._swimming.num_phases; phase >= 0; phase--)
		{
			if (self._swimming.swim_time >= get_phase_time(phase))
			{
				return(phase);
			}
		}
	}
	else	// reset
	{
		self._swimming.reset_time += t_delta;

		if (self._swimming.reset_time >= get_reset_time(phase))
		{
			self._swimming.swim_time = 0;				
			return 0;
		}
	}

	return phase;
}

/* ---------------------------------------------------------------------------------
get the time delta from last time
self = player
-----------------------------------------------------------------------------------*/
swimming_get_time()
{
	t_now = GetTime();
	t_delta = 0;

	if (IsDefined(self._swimming.last_get_time))
	{
		t_delta = t_now - self._swimming.last_get_time;
	}

	self._swimming.last_get_time = t_now;
	return t_delta;
}

get_phase_time(phase)
{
	return (level._swimming.swim_times[phase] * 1000);
}

get_reset_time(phase)
{
	return (level._swimming.drown_reset_times[phase] * 1000);
}