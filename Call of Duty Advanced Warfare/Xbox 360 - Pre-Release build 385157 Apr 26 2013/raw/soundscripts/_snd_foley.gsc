#include soundscripts\_audio;
#include maps\_shg_debug;

kVM2_InchesPerSecPerMPH			= 17.6;

snd_foley_init()
{
/#
	SetDvarIfUninitialized( "snd_foley_old_footstep", 0 );
#/

	level._snd.foley_envs = [];
	level._snd.foley_envs["prone_envelop"] =
	[	
		[0.000,  0.000],
		[0.800,  0.250],
		[1.000,  0.500],
		[1.600,  1.000]
	]; 
	level._snd.foley_envs["crouch_envelop"] =
	[	
		[0.000,  0.000],
		[3.000,  0.125],
		[4.500,  0.500],
		[7.000,  1.000]
	]; 
	level._snd.foley_envs["run_envelop"] =
	[	
		[0.000,  0.000],
		[5.000,  0.125],
		[7.000,  0.500],
		[10.000, 1.000]
	]; 
		
	level.player.leftfoot=true;
	thread snd_foley_footstep_handler();
}

snd_foley_footstep_handler()
{
	level.player endon( "death" );

	oldFootstep = 0;
	
	while(1)
	{
		level.player waittill( "foley", eventType, surfaceType, isQuiet );
		speed = Length(level.player GetVelocity()) / kVM2_InchesPerSecPerMPH;

/#
		snd_foley_debug_print( "footstep_type_hud", eventType );
		snd_foley_debug_print( "footstep_surface_hud", surfaceType );
		snd_foley_debug_print( "footstep_isquiet_hud", isQuiet );

		oldFootstep = GetDebugDvarInt( "snd_foley_old_footstep" );
#/

		switch(eventType)
		{
			case "stationarycrouchscuff":
				if ( oldFootstep == 0 )
				{
					scuffalias = "step_scrape_plr_" + surfaceType + "_lr";
					if(SoundExists(scuffalias))
					{
						level.player PlaySound( scuffalias );
					}
				}

				if (level.player.leftfoot==true)
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_l";
					gearalias = "gear_rattle_plr_crchwalk_l";
				}
				else
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_r";
					gearalias = "gear_rattle_plr_crchwalk_r";
				}
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_walk_plr_" + surfaceType;
				if(oldFootstep ||!SoundExists(gearalias))
					gearalias = "gear_rattle_plr_walk";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "stationaryscuff":
				if ( oldFootstep == 0 )
				{
					scuffalias = "step_scrape_plr_" + surfaceType + "_lr";
					if(SoundExists(scuffalias))
					{
						level.player PlaySound( scuffalias );
					}
				}

				if (level.player.leftfoot==true)
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_l";
					gearalias = "gear_rattle_plr_walk_l";
				}
				else
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_r";
					gearalias = "gear_rattle_plr_walk_r";
				}
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_walk_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_walk";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "pronescuff":
			break;

			case "crouchscuff":
				if ( oldFootstep == 0 )
				{
					scuffalias = "step_scrape_plr_" + surfaceType + "_lr";
					if(SoundExists(scuffalias))
					{
						level.player PlaySound( scuffalias );
					}
				}
			break;

			case "runscuff":
				if ( oldFootstep == 0 )
				{
					scuffalias = "step_scrape_plr_" + surfaceType + "_lr";
					if(SoundExists(scuffalias))
					{
						level.player PlaySound( scuffalias );
					}
				}
			break;

			case "sprintscuff":
				if ( oldFootstep == 0 )
				{
					scuffalias = "step_scrape_plr_" + surfaceType + "_lr";
					if(SoundExists(scuffalias))
					{
						level.player PlaySound( scuffalias );
					}
				}
			break;

			case "prone":
				if (level.player.leftfoot==true)
				{
					footstepalias = "step_prone_plr_" + surfaceType + "_l";
					gearalias = "gear_rattle_plr_prone_l";
				}
				else
				{
					footstepalias = "step_prone_plr_" + surfaceType + "_r";
					gearalias = "gear_rattle_plr_prone_r";
				}
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_prone_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_prone";

				volume = aud_map2(speed, level._snd.foley_envs["prone_envelop"]);
				level.player play_sound_if_exists( footstepalias, volume );
				level.player play_sound_if_exists( gearalias, volume );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "crouch":
				if (level.player.leftfoot==true)
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_l";
					gearalias = "cloth_mvmnt_plr_crchwalk_l";
				}
				else
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_r";
					gearalias = "gear_rattle_plr_crchwalk_r";
				}
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_walk_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_walk";

				volume = aud_map2(speed, level._snd.foley_envs["crouch_envelop"]);
				level.player play_sound_if_exists( footstepalias, volume );
				level.player play_sound_if_exists( gearalias, volume );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "walk":
				if (level.player.leftfoot==true)
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_l";
					gearalias = "cloth_mvmnt_plr_walk_l";
				}
				else
				{
					footstepalias = "step_crchwalk_plr_" + surfaceType + "_r";
					gearalias = "cloth_mvmnt_plr_walk_r";
				}
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_walk_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_walk";

				volume = aud_map2(speed, level._snd.foley_envs["run_envelop"]);
				level.player play_sound_if_exists( footstepalias, volume );
				level.player play_sound_if_exists( gearalias, volume );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "run":
				if (level.player.leftfoot==true)
				{
					footstepalias = "step_run_plr_" + surfaceType + "_l";
					gearalias = "cloth_mvmnt_plr_run_l";
				}
				else
				{
					footstepalias = "step_run_plr_" + surfaceType + "_r";
					gearalias = "cloth_mvmnt_plr_run_r";
				}
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_run_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_run";

				volume = aud_map2(speed, level._snd.foley_envs["run_envelop"]);
				level.player play_sound_if_exists( footstepalias, volume );
				level.player play_sound_if_exists( gearalias, volume );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "sprint":
				if (level.player.leftfoot==true)
				{
					footstepalias = "step_sprint_plr_" + surfaceType + "_l";
					gearalias = "cloth_mvmnt_plr_sprint_l";
				}
				else
				{
					footstepalias = "step_sprint_plr_" + surfaceType + "_r";
					gearalias = "cloth_mvmnt_plr_sprint_r";
				}

				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_sprint_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_sprint";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );

				level.player.leftfoot = !level.player.leftfoot;
			break;

			case "jump":
				footstepalias = "step_jump_plr_" + surfaceType + "_lr";
				gearalias = "gear_rattle_plr_jump_lr";
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "step_run_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_walk";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );
			break;

			case "lightland":
				footstepalias = "step_land_plr_" + surfaceType + "_lt_lr";
				gearalias = "gear_rattle_plr_land_lt_lr";
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "land_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_land";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );
			break;

			case "mediumland":
				footstepalias = "step_land_plr_" + surfaceType + "_med_lr";
				gearalias = "gear_rattle_plr_land_med_lr";
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "land_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_land";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );
			break;

			case "heavyland":
				footstepalias = "step_land_plr_" + surfaceType + "_med_lr";
				gearalias = "gear_rattle_plr_land_hv_lr";
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "land_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_land";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );
			break;

			case "damageland":
				footstepalias = "step_land_plr_" + surfaceType + "_dmg_lr";
				gearalias = "gear_rattle_plr_land_dmg_lr";
					
				if(oldFootstep || !SoundExists(footstepalias))
					footstepalias = "land_plr_" + surfaceType;
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_land";

				level.player play_sound_if_exists( footstepalias );
				level.player play_sound_if_exists( gearalias );
				level.player play_sound_if_exists( "land_plr_damage" );
			break;

			case "mantleuphigh":
				gearalias = "gear_rattle_plr_mantle";
					
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_mantle";

				level.player play_sound_if_exists( gearalias );
			break;

			case "mantleupmedium":
				gearalias = "gear_rattle_plr_mantle";
					
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_mantle";

				level.player play_sound_if_exists( gearalias );
			break;

			case "mantleuplow":
				gearalias = "gear_rattle_plr_mantle";
					
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_mantle";

				level.player play_sound_if_exists( gearalias );
			break;

			case "mantleoverhigh":
				gearalias = "gear_rattle_plr_mantle";
					
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_mantle";

				level.player play_sound_if_exists( gearalias );
			break;

			case "mantleovermedium":
				gearalias = "gear_rattle_plr_mantle";
					
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_mantle";

				level.player play_sound_if_exists( gearalias );
			break;

			case "mantleoverlow":
				gearalias = "gear_rattle_plr_mantle";
					
				if(oldFootstep || !SoundExists(gearalias))
					gearalias = "gear_rattle_plr_mantle";

				level.player play_sound_if_exists( gearalias );
			break;
		}
	}
}

play_sound_if_exists(soundalias, volume)
{
	if(!SoundExists(soundalias))
	{
		IPrintLn("missing sound, need to add  sound,foley_common,your_levelname_here,!all_sp  to your zone source.  alias: " + soundalias);
		return;
	}
	if (IsDefined(volume) )
	{
		ent = spawn( "script_origin", self.origin );
		ent linkto( self );
		ent PlaySound(soundalias, "sounddone");
		ent ScaleVolume(volume);
		ent thread delete_ent_on_sounddone();
	}
	else
	{
		self PlaySound(soundalias);
	}
}

delete_ent_on_sounddone()
{
	self endon( "death" );

	self waittill( "sounddone" );

	if ( !IsDefined( self ) )
	{
		return;
	}

	self Delete();
}

/#
snd_foley_debug_print( hud_item, value )
{
	SetDvarIfUninitialized( "snd_foley_debug", 0 );
	dvar = GetDebugDvarInt( "snd_foley_debug" );

	if ( dvar == 1 )
	{
		if ( !IsDefined( level._snd.foley_debug ) )
		{
			fontsize = 1.5;
			label_color = ( 0.4, 0.6, 0.9 );
			x = 525;
			y = 150;
			create_debug_text_hud( "footstep_type_hud", x, y, label_color, "Footstep Type: ", fontsize );
			y = y + 20;
			create_debug_text_hud( "footstep_surface_hud", x, y, label_color, "Surface Type: ", fontsize );
			y = y + 20;
			create_debug_text_hud( "footstep_isquiet_hud", x, y, label_color, "Is Quiet: ", fontsize );
			level._snd.foley_debug = 1;
		}

		print_debug_text_string_hud( hud_item, value );
	}
	else if ( dvar == 0 )
	{
		if ( IsDefined( level._snd.foley_debug ) )
		{
			delete_debug_text_hud( "footstep_type_hud" );
			delete_debug_text_hud( "footstep_surface_hud" );
			delete_debug_text_hud( "footstep_isquiet_hud" );
			level._snd.foley_debug = undefined;
		}
	}
}
#/
