/* ---------------------------------------------------------------------------------
This script handles player swimming
-----------------------------------------------------------------------------------*/

#include clientscripts\_utility;
#include clientscripts\_audio;
#include clientscripts\_ambientpackage;
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

	self._swimming.is_swimming_enabled = true;

	level._swimming.is_overriding_swim_movement = false;
	level._swimming.override_swim_movement = (0,0,0);

	level._swimming.swim_anim_rate = 1.0;
}

main()
{
	if ( IsDefined( level.swimmingFeature ) && !level.swimmingFeature )
		return;

	if(level.createFX_enabled)
	{
		return;	// When createFX is running, don't do anything.
	}
	
	settings();

	fx();

	anims();
	
	set_default_water_for_settings();

	OnPlayerConnect_Callback(::on_player_connect);
	
	level thread underwater_ambient_package_setup(); //CA AUDIO: Sets up ambient package for Underwater 
}

/* ---------------------------------------------------------------------------------
Called from level script to set the level specific vision set that this script
should set when not under water.
-----------------------------------------------------------------------------------*/
/* DEAD CODE REMOVAL
set_default_vision_set(vision_set)
{
}

set_swimming_vision_set(vision_set)
{
	VisionSetUnderWater(self GetLocalClientNumber(), vision_set);

	if (!IsDefined(self._swimming))
	{
		self waittill("swimming_init");
	}

	self._swimming.swimming_vision_set = vision_set;
}
*/
/* ---------------------------------------------------------------------------------
Load the fx.
-----------------------------------------------------------------------------------*/
fx()
{
	// client fx - used on client, but need to be pre-loaded on the server too //

	level._effect["underwater"]				= LoadFX( "env/water/fx_water_particles_surface_fxr" );
	level._effect["deep"]					= LoadFX( "env/water/fx_water_particle_dp_spawner" );
	level._effect["drowning"]				= LoadFX( "bio/player/fx_player_underwater_bubbles_drowning" );
	level._effect["exhale"]					= LoadFX( "bio/player/fx_player_underwater_bubbles_exhale" );
	level._effect["hands_bubbles_left"]		= LoadFX( "bio/player/fx_player_underwater_bubbles_hand_fxr" );
	level._effect["hands_bubbles_right"]	= LoadFX( "bio/player/fx_player_underwater_bubbles_hand_fxr_right" );
	level._effect["hands_debris_left"]		= LoadFX( "bio/player/fx_player_underwater_hand_emitter");
	level._effect["hands_debris_right"]		= LoadFX( "bio/player/fx_player_underwater_hand_emitter_right");
	level._effect["sediment"]				= LoadFX( "bio/player/fx_player_underwater_sediment_spawner");
	level._effect["wake"]					= LoadFX( "bio/player/fx_player_water_swim_wake" );
	level._effect["ripple"] = LoadFX( "bio/player/fx_player_water_swim_ripple" );
}

/* ---------------------------------------------------------------------------------
Setup the animation array for swimming.
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
player connect callback
self = player
-----------------------------------------------------------------------------------*/
on_player_connect(clientNum)
{
	// Wait until we've got the whole picture
	while ( !ClientHasSnapshot(clientNum) )
	{
		wait 0.05;
	}
	wait( 0.05 );

	self init_player();
	self thread on_save_restore();

	PrintLn("^4_swimming - client: client player connect");

	self thread enable_swimming();
	self thread disable_swimming();

	self thread toggle_arms();
	self thread swimmingDrown();
	self thread waterLevelTag( clientNum );

	self thread dive_and_surface_audio(); //CA AUDIO: Plays Diving/Surfacing SFX and Vox
	self thread dry_land_tracker(); //CA AUDIO: Tracks player feet position, as some swim loops start before swimming starts

	self thread toggle_swimming();

	// if the players start in water we most probably already lost the swimming_begin notify that comes from the engine
	// so do a fail safe check to see if the player is in water
	if( self Swimming() )
	{
		self notify("swimming_begin");
	}
}

on_save_restore()
{
	while (true)
	{
		level waittill("save_restore");
		self._swimming.is_underwater = false;
		self notify("surface");

		PrintLn("^4_swimming - client: save restore");

		if( self Swimming() )
		{
			self notify("swimming_begin");
		}
	}
}

/* ---------------------------------------------------------------------------------
Initialize the player for swimming.
self = player
-----------------------------------------------------------------------------------*/
init_player()
{
	// Don't want to keep adding a SpawnStruct on reloads or map restarts
	if( !isdefined( self._swimming ) )
	{
		PrintLn("^4_swimming - client: defining self._swimming.");
		self._swimming = SpawnStruct();
	}

	// NOTE:  These variables need to be reinitialized here because on 
	//	a RESTART LEVEL, the _swimming struct is still defined, but
	//	these variables get wiped for some reason.
	self._swimming.is_arms_enabled = true;
	self._swimming.is_swimming = false;
	self._swimming.is_drowning = false;
	self._swimming.is_underwater = false;
	self._swimming.resetting_vision = false;
	self._swimming.surface_vox = "chr_swimming_vox_surface_default";  //CA AUDIO: Setting up a default value
	self._swimming.vec_movement = (0, 0, 0);
	self notify("swimming_init");
}

/* ---------------------------------------------------------------------------------
disables swimming.  Controlled by notify from server either for client or while level.
self = player
-----------------------------------------------------------------------------------*/
disable_swimming()
{
	self endon("disconnect");

	while (true)
	{
		level waittill("_swimming:disable");
		PrintLn("^4_swimming - client: swimming disabled");

		self notify("swimming_end");
		level._swimming.is_swimming_enabled = false;
	}
}

/* ---------------------------------------------------------------------------------
enables swimming.  Controlled by notify from server either for client or while level.
self = player
-----------------------------------------------------------------------------------*/
enable_swimming()
{
	self endon("disconnect");

	while (true)
	{
		level waittill("_swimming:enable");
		PrintLn("^4_swimming - client: swimming enabled");

		if (self Swimming())
		{
			self notify("swimming_begin");
		}

		level._swimming.is_swimming_enabled = true;
	}
}

/* ---------------------------------------------------------------------------------
hides swimming arms.  Controlled by notify from server either for client or while level.
self = player
-----------------------------------------------------------------------------------*/
hide_arms()
{
	self endon("disconnect");

	while (true)
	{
		level waittill("_swimming:hide_arms");
		self._swimming.is_arms_enabled = false;
		self notify("_swimming:hide_arms");

		PrintLn("^4_swimming - client: hide arms");
	}
}

/* ---------------------------------------------------------------------------------
shows swimming arms.  Controlled by notify from server either for client or while level.
self = player
-----------------------------------------------------------------------------------*/
show_arms()
{
	self endon("disconnect");

	while (true)
	{
		level waittill("_swimming:show_arms");
		self._swimming.is_arms_enabled = true;
		self notify("_swimming:show_arms");

		PrintLn("^4_swimming - client: show arms");
	}
}

/* ---------------------------------------------------------------------------------
set water for to default settings
self = player
-----------------------------------------------------------------------------------*/
set_default_water_for_settings()
{
//	SetWaterFog( -100, 83, 100, -900, 0/255, 64/255, 80/255 );

	SetWaterFog(
	0, //start dist 
	119.8, //halfway dist 
	0, //halfway height
	-70.13,//base height
	0.149, //red
	0.145, //green 
	0.118, //blue
	1.33, //fog scale
	0.212, //sun red
	0.2, //sun green
	0.157, //sun blue
	-0.269, //sun dir x 
	-0.506, //sun dir y 
	0.82, //sun dir z 
	0, //sun fog start angle
	91.86, //sun fog end angle 
	0.994 //max opacity
	);
}

/* ---------------------------------------------------------------------------------
handles all the main swimming threads
self = player
-----------------------------------------------------------------------------------*/
toggle_swimming()
{
	self endon("disconnect");

	while (true)
	{
		self waittill("swimming_begin");
		self._swimming.is_swimming = true;
		
		PrintLn("^4_swimming - client: swimming begin");

		self thread swimmingTracker();
		self swimmingFX();

		self waittill("swimming_end");
		self._swimming.is_swimming = false;

		PrintLn("^4_swimming - client: swimming end");
	}
}

toggle_arms()
{
	self endon("disconnect");
	
	self thread show_arms();
	self thread hide_arms();

	while (true)
	{
		waitforclient(0);
		self waittill_any("underwater", "_swimming:show_arms");
		self thread swimmingArms();
		self waittill_any("surface", "swimming_end", "_swimming:hide_arms");
	}
}

/* ---------------------------------------------------------------------------------
tracks where the player is in the water
self = player
-----------------------------------------------------------------------------------*/
swimmingTracker()
{
	self endon("disconnect");
	self endon("swimming_end");

	while (true)
	{
		waitforclient(0);
		if (level._swimming.is_swimming_enabled)
		{
			self._swimming.current_depth = get_swimming_depth();
		}
		else
		{
			self._swimming.current_depth = 0;
		}

		wait .05;
	}
}

underwater()
{
	if (!self._swimming.is_underwater)
	{
		self._swimming.reset_time = 0;
		self._swimming.is_underwater = true;
		self._swimming.surface_vox = "chr_swimming_vox_surface_default";  //CA AUDIO: Sets the surface vox to default; changes if player is drowning
		self notify("underwater");
		PrintLn("^4_swimming - client: underwater");
	}
}

surface()
{
	if (self._swimming.is_underwater)
	{
		self._swimming.is_underwater = false;
		self notify("surface");
		PrintLn("^4_swimming - client: surface");
	}
}

get_swimming_depth()
{
	eye_height = self get_eye()[2];
	water_height = GetWaterHeight( self.origin );
	return (water_height - eye_height);
}

/* ---------------------------------------------------------------------------------
Basically a copy of the swimmingDrown function from the server.
Handles fx/vision/rumble/etc in the different drowning phases.
self = player
-----------------------------------------------------------------------------------*/
swimmingDrown()
{
	self endon("disconnect");

	phase = 0;
	last_phase = 0;

	self._swimming.swim_time = 0;
	self._swimming.reset_time = 0;

	while (true)
	{
		wait(.01);
		waitforclient(0);

		if (!self._swimming.is_underwater && !self._swimming.resetting_vision)
		{
			self._swimming.resetting_vision = true;
			self thread swimmingDrownVision(0, last_phase);
		}

		phase = self advance_drowning_phase(last_phase);

		if (phase != last_phase)
		{
			self notify( "drowning" );
			self thread swimming_drown_vox();
			self thread swimmingDrownDamage(phase);
			self thread swimmingDrownVision(phase, last_phase);
			self thread swimmingDrownFX(phase);
			self.drowning_phase = phase; //CA AUDIO: Added in a self value used for Drowning Vox

			last_phase = phase;

			PrintLn("^4_swimming - client: phase " + phase);
		}
	}
}

advance_drowning_phase(phase)
{
/#
	if(GetDvarInt("disable_drown") == 1)
	{
		return 0;
	}
#/
	// special case for deep sea swimming
	if( IsDefined(level._disable_drowning) && level._disable_drowning )
	{
		return 0;
	}

	t_delta = swimming_get_time();

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
get the time time delta from last time (ignoring anything > 500 ms to handle the game
being paused.
self = player
-----------------------------------------------------------------------------------*/
swimming_get_time()
{
	t_now = GetRealTime();
	t_delta = 0;

	if (IsDefined(self._swimming.last_get_time))
	{
		t_delta = t_now - self._swimming.last_get_time;
		if (t_delta >= 500)
		{
			PrintLn("^4_swimming - client: IGNORING TIME (" + t_delta + ")");
			t_delta = 0;
		}
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

/* ---------------------------------------------------------------------------------
Rumble to indicate damage as the player drowns
self = player
-----------------------------------------------------------------------------------*/
swimmingDrownDamage(phase)
{
	self endon("disconnect");
	self notify("stop_swimming_drown_damage");
	self endon("stop_swimming_drown_damage");
	self endon("surface");
	self endon("swimming_end");

	pause = 1;
	rumble = undefined;

	if (phase == 1 || phase == 2)
	{
		pause = 3;
		rumble = "damage_light";
	}
	else if (phase == 3)
	{
		rumble = "damage_heavy";
	}

	while (IsDefined(rumble))
	{
		// TODO: visual indication of damage, some kind of shader overlay (blood overlay)?
		self PlayRumbleOnEntity(self GetLocalClientNumber(), rumble);
		wait pause;
	}
}

/* ---------------------------------------------------------------------------------
Vision sets a blur to indicate drowning.
self = player
-----------------------------------------------------------------------------------*/
swimmingDrownVision(phase, last_phase)
{
	if (phase == 0)
	{
		PrintLn("^4_swimming - client: resetting client-side blur.");
		self SetBlur(0, level._swimming.drown_reset_times[last_phase]);

		if (self._swimming.is_drowning)
		{
			VisionSetUnderWater(self GetLocalClientNumber(), self._swimming.swimming_vision_set, 0);
			self._swimming.is_drowning = false;
		}
	}
	else
	{
		self._swimming.resetting_vision = false;
		
		if (phase == 2)
		{
			PrintLn("^4_swimming - client: setting client-side blur.");
			self SetBlur(10, level._swimming.swim_times[4] - level._swimming.swim_times[2]);
		}
		else if (phase == 3)
		{
			PrintLn("^4_swimming - client: setting drowning vision set.");
			VisionSetUnderWater(self GetLocalClientNumber(), "drown", level._swimming.swim_times[4] - level._swimming.swim_times[3]);
			self._swimming.is_drowning = true;
		}
	}
}

swimmingFX()
{
	self thread underWaterFX();
	//self thread onWaterFX();
}

waterLevelTag( clientNum )
{
	self endon("disconnect");

	self._swimming.water_level_fx_tag = Spawn(clientNum, self.origin, "script_model");
	self._swimming.water_level_fx_tag SetModel("tag_origin");

	while (true)
	{
		while( !ClientHasSnapshot(clientNum))
		{
			wait(0.1);
		}

		last_org = (0, 0, 0);
		while (self._swimming.is_swimming)
		{
			
			while( !ClientHasSnapshot(clientNum))
			{
				wait(0.1);
			}
			
			
			self._swimming.water_level_fx_tag.origin = ( self.origin[0], self.origin[1], GetWaterHeight( self.origin ) );
			new_org = self._swimming.water_level_fx_tag.origin;

			if ((last_org != (0, 0, 0)) && (new_org != last_org))
			{
				self._swimming.vec_movement = new_org - last_org;
				self._swimming.water_level_fx_tag.angles = VectorToAngles(self._swimming.vec_movement * -1);
			}
			else
			{
				self._swimming.is_stationary = true;
			}

			wait .01;
			last_org = new_org;
		}
		
		wait .01;
	}
}

/* ---------------------------------------------------------------------------------
Handle any client-side underwater fx
self = player
-----------------------------------------------------------------------------------*/
underWaterFX()
{
	self endon("swimming_end");

	fx_handle_underwater = undefined;
	fx_handle_deep = undefined;
	fx_handle_hand_le = undefined;
	fx_handle_hand_rt = undefined;

	while( true )
	{
		self waittill("swim_arms_spawned");

		self thread exhaleFX();
		self thread debrisFX();
		self thread sedimentFX();

		fx_handle_hand_le = PlayFXOnTag(self GetLocalClientNumber(), level._effect["hands_bubbles_left"], self._swimming_arms, "J_WristTwist_LE");
		fx_handle_hand_rt = PlayFXOnTag(self GetLocalClientNumber(), level._effect["hands_bubbles_right"], self._swimming_arms, "J_WristTwist_RI");

		if( self._swimming.current_depth > 500)
		{
			if (IsDefined(fx_handle_underwater))
			{
				DeleteFx( self GetLocalClientNumber(), fx_handle_underwater, true );
			}

			fx_handle_deep = PlayFXOnTag(self GetLocalClientNumber(), level._effect["deep"], self._swimming_arms, "tag_origin");
			PrintLn("^4_swimming - client: deep fx");
		}
		else
		{
			if (IsDefined(fx_handle_deep))
			{
				DeleteFx( self GetLocalClientNumber(), fx_handle_deep, false );
			}

			fx_handle_underwater = PlayFXOnTag(self GetLocalClientNumber(), level._effect["underwater"], self._swimming.water_level_fx_tag, "tag_origin");
			PrintLn("^4_swimming - client: underwater fx");
		}

		self thread underWaterFXDelete(fx_handle_underwater, fx_handle_deep, fx_handle_hand_le, fx_handle_hand_rt);
	}
}

underWaterFXDelete(fx_handle_underwater, fx_handle_deep, fx_handle_hand_le, fx_handle_hand_rt)
{
	self waittill_any("surface", "swimming_end");

	waitforclient(0);

	if (IsDefined(fx_handle_underwater))
	{
		DeleteFx( self GetLocalClientNumber(), fx_handle_underwater, true );
	}

	if (IsDefined(fx_handle_deep))
	{
		DeleteFx( self GetLocalClientNumber(), fx_handle_deep, false );
	}

	if (IsDefined(fx_handle_hand_le))
	{
		DeleteFx( self GetLocalClientNumber(), fx_handle_hand_le, true );
	}

	if (IsDefined(fx_handle_hand_rt))
	{
		DeleteFx( self GetLocalClientNumber(), fx_handle_hand_rt, true );
	}
}

/* ---------------------------------------------------------------------------------
looping fx of the player exhaling underwater
self = player
-----------------------------------------------------------------------------------*/
exhaleFX()
{
	self endon("disconnect");
	self endon("surface");
	self endon("swimming_end");
	self endon("drowning");

	wait 3;

	while (IsDefined(self._swimming_arms))
	{
		waitforclient(0);
		PlayFXOnTag(self GetLocalClientNumber(), level._effect["exhale"], self._swimming_arms, "tag_origin");
		//self PlaySound( 0, "chr_swimming_vox_bubble" );  //CA Audio: Bubble breath vox sync'd with the effect
		wait RandomFloatRange(2.5,3.5);
	}
}

/* ---------------------------------------------------------------------------------
particle fx to indicate drowning
self = player
-----------------------------------------------------------------------------------*/
swimmingDrownFX(phase)
{
	if (phase == 3)
	{
		if (IsDefined(self._swimming_arms))
		{
			PlayFXOnTag(self GetLocalClientNumber(), level._effect["drowning"], self._swimming_arms, "tag_origin");
		}
	}
}

/* ---------------------------------------------------------------------------------
looping fx of additional debris played off the player hands
self = player
-----------------------------------------------------------------------------------*/
debrisFX()
{
	self endon("disconnect");
	self endon("surface");
	self endon("swimming_end");

	while (IsDefined(self._swimming_arms))
	{
		fx_handle_hand_le = PlayFXOnTag(self GetLocalClientNumber(), level._effect["hands_debris_left"], self._swimming_arms, "J_WristTwist_LE");
		fx_handle_hand_rt = PlayFXOnTag(self GetLocalClientNumber(), level._effect["hands_debris_right"], self._swimming_arms, "J_WristTwist_RI");
		self thread killUnderWaterFX(fx_handle_hand_le, 3);
		self thread killUnderWaterFX(fx_handle_hand_rt, 3);
		wait 1.5;
	}
}

/* ---------------------------------------------------------------------------------
looping fx of sediment played off the player
self = player
-----------------------------------------------------------------------------------*/
sedimentFX()
{
	self endon("disconnect");
	self endon("surface");
	self endon("swimming_end");

	while (true)
	{
		player_angles = self GetPlayerAngles();
		player_forward = AnglesToForward(player_angles);

		fx_pos = self GetOrigin();

		fx_handle = PlayFx(self GetLocalClientNumber(), level._effect["sediment"], fx_pos );
		self thread killUnderWaterFX(fx_handle, 10);
		wait 1;
	}
}

/* ---------------------------------------------------------------------------------
delete and stop various underwater fx when on the surface
self = player
-----------------------------------------------------------------------------------*/
killUnderWaterFX(fx_handle, time_out)
{
	self endon("disconnect");

	endon_string = get_kill_fx_endon();

	self endon(endon_string);
	self thread notify_delay(endon_string, time_out);

	self waittill_any("surface", "swimming_end");

	waitforclient(0);

	if (IsDefined(fx_handle))
	{
		DeleteFx( self GetLocalClientNumber(), fx_handle, true );
	}
}

get_kill_fx_endon()
{
	if (!IsDefined(level._swimming.fx_num))
	{
		level._swimming.fx_num = 0;
	}
	else
	{
		level._swimming.fx_num++;
	}

	endon_string = "swimmin_fx_" + level._swimming.fx_num;
	return(endon_string);
}

onWaterFX()
{
	self endon("disconnect");
	self endon("swimming_end");
	
	while( true )
	{
		if (!self._swimming.is_underwater)
		{
			if (Length(self._swimming.vec_movement) > .4)
			{
				self onWaterWakeFXSpawn();
				self onWaterRippleFXDelete();
			}
			else
			{
				self onWaterWakeFXDelete();
				self onWaterRippleFXSpawn();
			}
		}
		
		wait .01;
	}
}

onWaterWakeFXSpawn()
{
	if (!IsDefined(self._swimming.fx_handle_wake))
	{
		self notify("new_on_water_fx");
		PrintLn("^4_swimming - client: spawning wake");
		self._swimming.fx_handle_wake = PlayFXOnTag(self GetLocalClientNumber(), level._effect["wake"], self._swimming.water_level_fx_tag, "tag_origin");
		self thread onWaterWakeFXDeleteWhenDone();
	}
}

onWaterWakeFXDeleteWhenDone()
{
	self endon("new_on_water_fx");
	self waittill_any("underwater", "swimming_end");
	self onWaterWakeFXDelete();
}

onWaterWakeFXDelete()
{
	if( IsDefined(self._swimming.fx_handle_wake) )
	{
		PrintLn("^4_swimming - client: deleting wake");
		DeleteFx( self GetLocalClientNumber(), self._swimming.fx_handle_wake, 0 );
		self._swimming.fx_handle_wake = undefined;
	}
}

onWaterRippleFXSpawn()
{
	if (!IsDefined(self._swimming.fx_handle_ripple))
	{
		self notify("new_on_water_fx");
		PrintLn("^4_swimming - client: spawning ripple");
		self._swimming.fx_handle_ripple = PlayFXOnTag(self GetLocalClientNumber(), level._effect["ripple"], self._swimming.water_level_fx_tag, "tag_origin");
		self thread onWaterRippleFXDeleteWhenDone();
	}
}

onWaterRippleFXDeleteWhenDone()
{
	self endon("new_on_water_fx");
	self waittill_any("underwater", "swimming_end");
	self onWaterRippleFXDelete();
}

onWaterRippleFXDelete()
{
	if( IsDefined(self._swimming.fx_handle_ripple) )
	{
		PrintLn("^4_swimming - client: deleting ripple");
		DeleteFx( self GetLocalClientNumber(), self._swimming.fx_handle_ripple, 0 );
		self._swimming.fx_handle_ripple = undefined;
	}
}

/* ---------------------------------------------------------------------------------
spawn and attach the arms model used for swimming
self = player
-----------------------------------------------------------------------------------*/
swimmingArmsSpawn()
{
	self endon("disconnect");
	self endon("swimming_end");
	self endon("surface");

	PrintLn("^4_swimming - client: swimmingArmsSpawn");
	if (!self._swimming.is_underwater)
	{
		self waittill("underwater");
	}

	if (!self._swimming.is_arms_enabled)
	{
		self waittill("_swimming:show_arms");
	}

	self thread swimmingArmsHide();

	//if (!IsDefined(self._swimming_arms))
	//{
		PrintLn("^4_swimming - client: spawning arms");
		self._swimming_arms = spawn_player_arms();
		wait( 0.2 );	// wait needed before setting animtree on newly spawned model
	//}

	PrintLn("^4_swimming - client: linking arms");
	self._swimming_arms UseAnimTree( #animtree );
	self._swimming_arms LinkToCamera();

	self notify("swim_arms_spawned");
}

/* ---------------------------------------------------------------------------------
hide arms when not swimming
self = player
-----------------------------------------------------------------------------------*/
swimmingArmsHide()
{
	self endon("disconnect");
	msg = self waittill_any_return("swimming_end", "surface", "_swimming:hide_arms");

	if (msg == "_swimming:hide_arms")
	{
		self endon("_swimming:show_arms");
	}
	else
	{
		self endon("underwater");
	}

	self._swimming_arms waittillmatch("swimming_anim", "end");

// 	if (IsDefined(self._swimming_arms))
// 	{
// 		PrintLn("^4_swimming - client: unlinking arms");
// 		self._swimming_arms UnlinkFromCamera();
// 		player_origin = self GetOrigin();
// 		self._swimming_arms.origin =  player_origin + ( 0, 0, -5000 );
// 
// 		if (IsDefined(self._swimming_arms.current_anim))
// 		{
// 			self._swimming_arms ClearAnim(self._swimming_arms.current_anim, 0.0);
// 		}
// 	}

	self._swimming_arms Delete();
}

/* ---------------------------------------------------------------------------------
animate the swimming arms
self = player
-----------------------------------------------------------------------------------*/
swimmingArms()
{
	self endon("disconnect");
	self endon("swimming_end");
	self endon("surface");

	self swimmingArmsSpawn();
	self._swimming_arms endon("death");

	const blendtime = 0.3;
	
	new_swim_state = 100; // -1 none; // 0 idle; // 1 forward; // // 2 backwards // 3 left; // 4 right 
	const new_rate = 1.0;

	while( 1 )
	{
		waitforclient(0);
		move = self GetNormalizedMovement();
		if (level._swimming.is_overriding_swim_movement)
		{
			move = level._swimming.override_swim_movement;
		}

		len = Length( move );

		old_swim_state = new_swim_state;
		
		if( len < 0.5 ) 
		{ // idle
			new_swim_state = 0;
		}
		else
		{
			if( abs( move[0] ) > abs( move[1] ) )
			{ 
				if( move[0] > 0 )
				{ // forward
					new_swim_state = 1;
				}
				else
				{ // backwards
					new_swim_state = 2;
				}
			}
			else
			{
				if( move[1] < 0 )
				{ // left
					new_swim_state = 3;
				}
				else
				{ // right
					new_swim_state = 4;
				}
			}
		}
		
		rand_anim = random(level._swimming.anims["tread"]);

		switch( new_swim_state )
		{
		case 100:
			break;

		case 0:
			PrintLn( "_swimming: swim idle" );
			rand_anim = random(level._swimming.anims["tread"]);
			break;

		case 1:
			PrintLn( "_swimming: swim forward" );
			rand_anim = random(level._swimming.anims["breaststroke"]);
			break;

		case 2:
			PrintLn( "_swimming: swim backwards" );
			rand_anim = random(level._swimming.anims["backwards"]);
			break;

		case 3:
			PrintLn( "_swimming: swim left" );
			rand_anim = random(level._swimming.anims["left"]);
			break;

		case 4:
			PrintLn( "_swimming: swim right" );
			rand_anim = random(level._swimming.anims["right"]);
			break;
		}

		self._swimming_arms.current_anim = rand_anim;
		self._swimming_arms SetFlaggedAnim("swimming_anim", rand_anim, 1, 0.2, level._swimming.swim_anim_rate);
		self._swimming_arms waittillmatch("swimming_anim", "end");

		self._swimming_arms ClearAnim(rand_anim, 0.0);
	}
}

//***AUDIO Specific Scripts***

//Changes the Ambient Room while underwater, also plays diving and surfacing audio
dive_and_surface_audio()
{
	self endon( "death" );
	
	if( !IsDefined( level.underwater_snapshot_override ) )
		level.underwater_snapshot_override = false;
	
	while (true)
	{
		self waittill( "underwater" );

		activateAmbientRoom( 0, "underwater", 50 );
		snd_set_snapshot( "spl_cmn_underwater" );
		self PlaySound( 0, "chr_swimming_dive_start_plr" ); //Diving Sound
		self PlaySound( 0, "chr_ear_fill" );
		    	
		self waittill( "surface" );

		deactivateAmbientRoom( 0, "underwater", 50 );
		snd_set_snapshot( "default" );
		self PlaySound( 0, self._swimming.surface_vox ); //Surfacing Vox
		self PlaySound( 0, "chr_swimming_surface_plr" ); //Surfacing Splashes
		self PlaySound( 0, "chr_ear_drain" );
	}
}

//Plays a Swimming and Idle loop, determined by Player Origin versus Water Height
swimming_loops_plr()
{
	self endon( "death" );
	
	swim_ent1 = Spawn( 0, (0,0,0), "script_origin" );
	swim_ent2 = Spawn( 0, (0,0,0), "script_origin" );
	
	while(1)
	{
		while( !self.is_on_dryland && !self._swimming.is_underwater && level._swimming.is_swimming_enabled )
		{
			if( self GetSpeed() > 50 )
			{
				swim_ent1 StopLoopSound( 1 );
				swim_ent2 PlayLoopSound( "chr_swimming_swim_loop_plr", 1 );
			}
			else
			{
				swim_ent2 StopLoopSound( 1 );
				swim_ent1 PlayLoopSound( "chr_swimming_float_loop_plr", 1 );
			}
			wait(.25);
		}
		swim_ent1 StopLoopSound( 1 );
		swim_ent2 StopLoopSound( 1 );
		wait(.25);
	}
}

//Plays a Swimming and Idle loop, determined by AI Origin versus Water Height
swimming_loops_ai()
{
	self endon( "death" );
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	
	while(1)
	{
		//self waittill( "!on_dryland" );
		while( self.is_on_dryland == true || !level._swimming.is_swimming_enabled )
		{
			wait( 0.25 );
		}
		
		real_ent1 = Spawn( 0, (0,0,0), "script_origin" );
		real_ent2 = Spawn( 0, (0,0,0), "script_origin" );
		real_ent1 LinkTo( self, "tag_origin" );
		real_ent2 LinkTo( self, "tag_origin" );
	
		self thread swimming_loop_delete( real_ent1, real_ent2 );
		self thread save_restore_ent_delete( real_ent1, real_ent2 );
		
		while( !self.is_on_dryland && level._swimming.is_swimming_enabled && IsDefined( real_ent1 ) && IsDefined( real_ent2 ) )
		{
			if( !IsDefined( self ) )
			{
				return;
			}
			
			if( self GetSpeed() > 50 )
			{
				real_ent2 StopLoopSound( 1 );
				real_ent1 PlayLoopSound( "chr_swimming_swim_loop_npc", 1 );
			}
			else
			{
				real_ent1 StopLoopSound( 1 );
				real_ent2 PlayLoopSound( "chr_swimming_float_loop_npc", 1 );
			}	
			wait(.25);
		}
		wait(.25);
	}
}

//Self = Player or Actors
dry_land_tracker()
{
	self endon( "death" );
	self endon( "entityshutdown" );
	
	self.is_on_dryland = true;
	const active_on_ai = true;  //Change to true if you want to run this on AI; deactivated currently due to issues
	
	if( !IsDefined( level._swimming ) )
		return;
	
	if( !level._swimming.is_swimming_enabled )
		return;
	
	if( self IsPlayer() == false )
	{  //Makes sure AI that are passed through this function thread the AI swimming function
		if( active_on_ai )
		{
			PrintLn( "***Swimming Threaded On AI***" );
			self thread swimming_loops_ai();
			self thread disable_ai_swimming();
			level endon( "save_restore" );
		}
		else
		{
			return;
		}
	}
	else
	{
		self thread swimming_loops_plr();
	}
	
	while(1)
	{
		while( level._swimming.is_swimming_enabled )
		{
			if( !IsDefined( self ) )
			{
				return;
			}
		
			//eye_height = self GetTagOrigin( "J_EyeBall_LE" );
			waitforclient(0);
			eye_height = self get_eye();
			self.foot_depth = (eye_height[2] - GetWaterHeight( self.origin )) - 40; //Value added so WADING will play audio

			if( self.foot_depth > 0 )
			{
				if ( self.is_on_dryland == false )
				{ 
					self.is_on_dryland = true;
					self notify( "on_dryland" );
				}
			}
			else if ( self.is_on_dryland == true )
			{
				self.is_on_dryland = false;
				self notify( "!on_dryland" );
			}	
			wait(.25);
		}
		wait(.25);
	}
}

//Run AI swimming loops; Deletes ents whenever they are on dryland, AI dies, or swimming is turned off
swimming_loop_delete( ent1, ent2 )
{
	level endon( "save_restore" );
	
	self waittill_any( "entityshutdown", "on_dryland", "swimming_end", "death" );

	ent1 delete();
	ent2 delete();
}

save_restore_ent_delete( ent1, ent2 )
{
	level waittill( "save_restore" );
	
	if( !IsDefined( ent1 ) || !IsDefined( ent2 ) )
		return;
	
	PrintLn( "*#*#*#*#* Deleting Ents on Save Restore" );
	
	ent1 delete();
	ent2 delete();
}

//Setup for the Ambient Room that activates whenever the player is underwater
underwater_ambient_package_setup()
{
	declareAmbientRoom( "underwater" );
 	setAmbientRoomTone( "underwater", "chr_swimming_underwater_amb", .25, .1 );
 	setAmbientRoomReverb ("underwater","UNDERWATER", 1, 1, 1 );
}

//Run on each AI, so they know when swimming ends
disable_ai_swimming()
{
	level endon( "save_restore" );
	
	while (true)
	{
		level waittill("_swimming:disable");
		
		if( !IsDefined( self ) )
			return;
		
		self notify("swimming_end");
	}
}

disable_underwater_snapshot( value )
{
	if( !IsDefined( level.underwater_snapshot_override ) )
		level.underwater_snapshot_override = false;
	
	level.underwater_snapshot_override = value;
}

//***************
// DROWNING AUDIO
//***************

swimming_drown_vox()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if( !IsDefined( level.is_drowning ) )
	    level.is_drowning = false;
	
	if( level.is_drowning || !self._swimming.is_underwater )
	    return;
	
	level.is_drowning = true;
	self thread audio_drowning_counter();
	self thread audio_drowning_loopers();
	self thread audio_drowning_vox();
	self waittill( "surface" );
	level.is_drowning = false;
	snd_set_snapshot( "default" );
}

audio_drowning_vox()
{
    self endon( "surface" );
    self endon( "death" );
    
    drown_vox = undefined;
    surface_vox = undefined;
    const drown_time_change = 12;
    
    while( self._swimming.is_underwater )
    {
        if( level.audio_swimming_counter <= drown_time_change )
        {
            drown_vox = "chr_swimming_vox_gulp_small";
            surface_vox = "chr_swimming_vox_surface_medium";
            waittime = RandomFloatRange( 2, 4 );
        }
        else
        {
            drown_vox = "chr_swimming_vox_gulp_large";
            surface_vox = "chr_swimming_vox_surface_large";
            waittime = RandomFloatRange( .5, 2 );
        }
        
        self PlaySound( 0, drown_vox );
		self._swimming.surface_vox = surface_vox;
		//IPrintLnBold( "Playing " + drown_vox + " with Surface " + surface_vox );
		wait waittime;
    }
}

audio_drowning_loopers()
{
    self endon( "surface" );
    self endon( "death" );
    
    if( !self._swimming.is_underwater )
        return;
    
    snd_set_snapshot( "spl_cmn_drowning" );
    
    ent1 = Spawn( 0, (0,0,0), "script_origin" );
    ent2 = Spawn( 0, (0,0,0), "script_origin" );
    
    self thread delete_ents_on_surface( ent1, ent2 );
    self thread drowning_heartbeat();
    
	ent1 playloopsound( "chr_swimming_drowning_loop", 10 );
    
    while( level.audio_swimming_counter < 14 )
    {
        wait(.1);
    }
    
    ent2 PlayLoopSound( "chr_shock_hfq", 1 );
}

audio_drowning_counter()
{
    self endon( "surface" );
    self endon( "death" );
    self endon( "disconnect" );
    
    if( !self._swimming.is_underwater )
        return;
    
    for( i=0; i<30; i++ )
    {
        level.audio_swimming_counter = i;
        waitrealtime(1);
    }
}

delete_ents_on_surface( ent1, ent2 )
{
    self waittill_any( "surface", "death" );
    ent1 stoploopsound( .25 );
    ent2 stoploopsound( .25 );
    wait(.25);
    ent1 Delete();
    ent2 Delete();
}

drowning_heartbeat()
{   
    self endon( "surface" );
    self endon( "death" );
    self endon( "disconnect" );
    
    wait1 = undefined;
    wait2 = undefined;
    
    while( self._swimming.is_underwater )
    {
        if( level.audio_swimming_counter >= 18 )
        {
            wait1 = .2;
            wait2 = .4;
        }
        else if( level.audio_swimming_counter >= 12 )
        {
            wait1 = .3;
            wait2 = .6;
        }
        else if( level.audio_swimming_counter > 6 )
        {
            wait1 = .4;
            wait2 = .8;
        }
        else if( level.audio_swimming_counter <= 6 )
        {
            wait1 = .5;
            wait2 = 1;
        }
        
        PlaySound( 0, "chr_shock_hb1", (0,0,0) );
        wait( wait1 );
        PlaySound( 0, "chr_shock_hb2", (0,0,0) );
        wait( wait2 );
    }
}

/*
swimming_drown_vox()
{
	self endon( "death" );
	
	while(1)
	{
		self waittill( "drowning" );
	
		pause = .75;
		vox = undefined;
		surface_vox = undefined;
	
		while( self._swimming.is_underwater && level._swimming.is_swimming_enabled )
		{
			if (self.drowning_phase == 1 || self.drowning_phase == 2)
			{
				pause = 2.75;
				vox = "chr_swimming_vox_gulp_small";
				surface_vox = "chr_swimming_vox_surface_medium";
			}
			else if (self.drowning_phase == 3)
			{
				pause = .75;
				vox = "chr_swimming_vox_gulp_large";
				surface_vox = "chr_swimming_vox_surface_large";
			}
		
			if( IsDefined( vox ) )
			{
				self PlaySound( 0, vox );
				self._swimming.surface_vox = surface_vox;
				//IPrintLnBold( "Playing " + vox + " with Surface " + surface_vox );
				wait pause;
			}
			wait(.25);
		}
	}
}
*/