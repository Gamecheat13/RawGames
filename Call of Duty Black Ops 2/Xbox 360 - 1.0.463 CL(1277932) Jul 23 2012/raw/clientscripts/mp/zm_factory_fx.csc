#include clientscripts\mp\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

main()
{
	clientscripts\mp\createfx\zm_factory_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}

/*	
	level thread trap_fx_monitor("warehouse_trap","warehouse"); 
	level thread trap_fx_monitor("wuen_trap", "wuen");
	level thread trap_fx_monitor("bridge_trap", "bridge");
	
	level thread perk_wire_fx( "pw0", "pad_0_wire", "t01" );
	level thread perk_wire_fx( "pw1", "pad_1_wire", "t11" );
	level thread perk_wire_fx( "pw2", "pad_2_wire", "t21" );

	// Threads controlling the lights on the maps in the Teleporter rooms
	level thread teleporter_map_light( "sm_light_tp_0", "t01" );
	level thread teleporter_map_light( "sm_light_tp_1", "t11" );
	level thread teleporter_map_light( "sm_light_tp_2", "t21" );
	level.map_light_receiver_on = false;
	level thread teleporter_map_light_receiver();

	level thread dog_start_monitor();
	level thread dog_stop_monitor();
	level thread level_fog_init();
	
	level thread light_model_swap( "smodel_light_electric",				"lights_indlight_on" );
	level thread light_model_swap( "smodel_light_electric_milit",		"lights_milit_lamp_single_int_on" );
	level thread light_model_swap( "smodel_light_electric_tinhatlamp",	"lights_tinhatlamp_on" );

	level thread flytrap_lev_objects();
*/	
}

/*
trap_fx_monitor(name,side)
{
	
	while(1)
	{
		level waittill(name);

		fire_points = getstructarray(name,"targetname");

		for(i=0;i<fire_points.size;i++)
		{
			fire_points[i] thread electric_trap_fx(name,side);		
		}

	}
	
}

electric_trap_fx(name,side)
{
	
	ang = self.angles;
	forward = anglestoforward(ang);
	up = anglestoup(ang);
	
	if ( isdefined( self.loopFX ) )
	{
		for(i = 0; i < self.loopFX.size; i ++)
		{
			self.loopFX[i] delete();
		}
		
		self.loopFX = [];
	}

	if(!isdefined(self.loopFX))
	{
		self.loopFX = [];
	}	
	
	players = getlocalplayers();
	
	for(i = 0; i < players.size; i++)
	{
		self.loopFX[i] = SpawnFx( i, level._effect["zapper"], self.origin, 0,forward,up);
		triggerfx(self.loopFX[i]);
	}
	
	level waittill(side + "off");
	//wait(30 );

	for(i = 0; i < self.loopFX.size; i ++)
	{
		self.loopFX[i] delete();
	}
	
	self.loopFX = [];

}
*/
precache_scripted_fx()
{
	//level._effect["zombie_grain"]	             = LoadFx( "misc/fx_zombie_grain_cloud" );
	level._effect["electric_short_oneshot"]    = loadfx("env/electrical/fx_elec_short_oneshot");
	level._effect["switch_sparks"]             = loadfx ("env/electrical/fx_elec_wire_spark_burst");
	
	level._effect["zapper_fx"]                 = loadfx("maps/zombie/fx_zombie_zapper_powerbox_on");
	level._effect["zapper_wall"]               = loadfx("maps/zombie/fx_zombie_zapper_wall_control_on");
	level._effect["elec_trail_one_shot"]       = loadfx("maps/zombie/fx_zombie_elec_trail_oneshot");
	
	level._effect["zapper_light_ready"]        = loadfx("maps/zombie/fx_zombie_light_glow_green");
	level._effect["zapper_light_notready"]     = loadfx("maps/zombie/fx_zombie_light_glow_red");
	level._effect["wire_sparks_oneshot"]       = loadfx("electrical/fx_elec_wire_spark_dl_oneshot");

	level._effect["wire_spark"]                = loadfx("maps/zombie/fx_zombie_wire_spark");
	level._effect["eye_glow"]                  = LoadFx( "misc/fx_zombie_eye_single" );
	level._effect["powerup_on"] 				       = loadfx( "misc/fx_zombie_powerup_on" );

	level._effect["headshot"] 					       = LoadFX( "impacts/fx_flesh_hit" );
	level._effect["headshot_nochunks"] 			   = LoadFX( "misc/fx_zombie_bloodsplat" );
	level._effect["bloodspurt"] 				       = LoadFX( "misc/fx_zombie_bloodspurt" );
	level._effect["animscript_gib_fx"] 		     = LoadFx( "weapon/bullet/fx_flesh_gib_fatal_01" ); 
	level._effect["animscript_gibtrail_fx"] 	 = LoadFx( "trail/fx_trail_blood_streak" ); 	
}

precache_createfx_fx()
{
	
	level._effect["mp_battlesmoke_lg"]								= loadfx("maps/zombie_old/fx_mp_battlesmoke_thin_lg");
	level._effect["mp_fire_distant_150_150"]					= loadfx("maps/zombie_old/fx_mp_fire_150x150_tall_distant");
	level._effect["mp_fire_distant_150_600"]					= loadfx("maps/zombie_old/fx_mp_fire_150x600_tall_distant");
	level._effect["mp_fire_static_small_detail"]			= loadfx("maps/zombie_old/fx_mp_fire_small_detail");
	level._effect["mp_fire_window_smk_rt"]						= loadfx("maps/zombie_old/fx_mp_fire_window_smk_rt");
	level._effect["mp_fire_window_smk_lf"]						= loadfx("maps/zombie_old/fx_mp_fire_window_smk_lf");
	level._effect["mp_fire_window"]										= loadfx("maps/zombie_old/fx_mp_fire_window");
	level._effect["mp_fire_rubble_small"]							= loadfx("maps/zombie_old/fx_mp_fire_rubble_small");
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/zombie_old/fx_mp_fire_rubble_md_smk");
	level._effect["mp_fire_rubble_md_lowsmk"]					= loadfx("maps/zombie_old/fx_mp_fire_rubble_md_lowsmk");
	level._effect["mp_fire_rubble_detail_grp"]				= loadfx("maps/zombie_old/fx_mp_fire_rubble_detail_grp");
	level._effect["mp_ray_fire_thin"]									= loadfx("maps/zombie_old/fx_mp_ray_fire_thin");
//	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_fire_column_lg"]								= loadfx("maps/mp_maps/fx_mp_fire_column_lg");
	level._effect["mp_fire_furnace"]							  	= loadfx("maps/zombie_old/fx_mp_fire_furnace");
	
//	level._effect["mp_ray_light_xsm"]									= loadfx("maps/mp_maps/fx_mp_ray_moon_xsm");
	level._effect["mp_ray_light_sm"]									= loadfx("maps/zombie_old/fx_mp_ray_moon_sm");
//	level._effect["fx_mp_flare_md"]								  	= loadfx("maps/mp_maps/fx_mp_flare_md");
	level._effect["mp_ray_light_md"]									= loadfx("maps/zombie_old/fx_mp_ray_moon_md");
	level._effect["mp_ray_light_lg"]									= loadfx("maps/zombie_old/fx_mp_ray_moon_lg");
	level._effect["fx_mp_ray_fire_ribbon"]						= loadfx("maps/zombie_old/fx_mp_ray_fire_ribbon");
	level._effect["fx_mp_ray_fire_ribbon_med"]		  	= loadfx("maps/zombie_old/fx_mp_ray_fire_ribbon_med");				
	level._effect["mp_ray_light_lg_1sd"]							= loadfx("maps/zombie_old/fx_mp_ray_moon_lg_1sd");
	
	level._effect["mp_smoke_fire_column"]							= loadfx("maps/zombie_old/fx_mp_smoke_fire_column");
	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/zombie_old/fx_mp_smoke_plume_lg");
	level._effect["mp_smoke_hall"]										= loadfx("maps/zombie_old/fx_mp_smoke_hall");
	level._effect["mp_ash_and_embers"]								= loadfx("maps/zombie_old/fx_mp_ash_falling_large");
	level._effect["mp_light_glow_indoor_short"]				= loadfx("maps/zombie_old/fx_mp_light_glow_indoor_short_loop");
	level._effect["mp_light_glow_outdoor_long"]				= loadfx("maps/zombie_old/fx_mp_light_glow_outdoor_long_loop");
	level._effect["mp_insects_lantern"]								= loadfx("maps/zombie_old/fx_mp_insects_lantern");
	level._effect["fx_mp_fire_torch_noglow"]				  = loadfx("maps/zombie_old/fx_mp_fire_torch_noglow");
	
	level._effect["a_embers_falling_sm"]							= loadfx("env/fire/fx_embers_falling_sm");
	
//	level._effect["a_tracers_flak88_amb"]							= loadfx("maps/ber3/fx_tracers_flak88_amb");
//	level._effect["mp_flak_field"]										= loadfx("maps/mp_maps/fx_mp_flak_field");
//	level._effect["mp_flak_field_flash"]							= loadfx("maps/mp_maps/fx_mp_flak_field_flash");

	level._effect["transporter_beam"]				          = loadfx("maps/zombie/fx_transporter_beam");
	level._effect["transporter_pad_start"]				    = loadfx("maps/zombie/fx_transporter_pad_start");
	level._effect["transporter_start"]				        = loadfx("maps/zombie/fx_transporter_start");		
	level._effect["transporter_ambient"]				      = loadfx("maps/zombie/fx_transporter_ambient");		
	level._effect["zombie_mainframe_link_all"]				= loadfx("maps/zombie/fx_zombie_mainframe_link_all");
	level._effect["zombie_mainframe_link_single"]			= loadfx("maps/zombie/fx_zombie_mainframe_link_single");
	level._effect["zombie_mainframe_linked"]			    = loadfx("maps/zombie/fx_zombie_mainframe_linked");
	level._effect["zombie_mainframe_beam"]			      = loadfx("maps/zombie/fx_zombie_mainframe_beam");	
	level._effect["zombie_mainframe_flat"]			      = loadfx("maps/zombie/fx_zombie_mainframe_flat");		
	level._effect["zombie_mainframe_flat_start"]		  = loadfx("maps/zombie/fx_zombie_mainframe_flat_start");		
	level._effect["zombie_mainframe_beam_start"]		  = loadfx("maps/zombie/fx_zombie_mainframe_beam_start");		
	level._effect["zombie_flashback_american"]		    = loadfx("maps/zombie/fx_zombie_flashback_american");		
	level._effect["gasfire2"] 				                = LoadFx("destructibles/fx_dest_fire_vert");
	level._effect["mp_light_lamp"] 			              = Loadfx("maps/zombie_old/fx_mp_light_lamp");
	level._effect["zombie_difference"]		            = loadfx("maps/zombie/fx_zombie_difference");
	level._effect["zombie_mainframe_steam"]		        = loadfx("maps/zombie/fx_zombie_mainframe_steam");
	level._effect["zombie_heat_sink"]		              = loadfx("maps/zombie/fx_zombie_heat_sink");
	level._effect["mp_smoke_stack"] 			            = loadfx("maps/zombie_old/fx_mp_smoke_stack");
//	level._effect["mp_elec_spark_fast_random"] 			  = loadfx("maps/mp_maps/fx_mp_elec_spark_fast_random");	
	level._effect["zombie_elec_gen_idle"] 		    	  = loadfx("maps/zombie/fx_zombie_elec_gen_idle");
	level._effect["zombie_moon_eclipse"]		          = loadfx("maps/zombie/fx_zombie_moon_eclipse");	
	level._effect["zombie_clock_hand"]		            = loadfx("maps/zombie/fx_zombie_clock_hand");
	level._effect["zombie_elec_pole_terminal"]		    = loadfx("maps/zombie/fx_zombie_elec_pole_terminal");	
	level._effect["mp_elec_broken_light_1shot"] 	    = loadfx("maps/zombie_old/fx_mp_elec_broken_light_1shot");	
	level._effect["mp_light_lamp_no_eo"] 	  		      = loadfx("maps/zombie_old/fx_mp_light_lamp_no_eo");													

	level._effect["zombie_packapunch"]		            = loadfx("maps/zombie/fx_zombie_packapunch");		
	level._effect["zapper"]							              = loadfx("maps/zombie/fx_zombie_electric_trap");

}


/*
// borrowed this func from asylum
perk_wire_fx(notify_wait, init_targetname, done_notify )
{
	level waittill(notify_wait);
	
	players = getlocalplayers();
	for(i = 0; i < players.size;i++)
	{
		players[i] thread perk_wire_fx_client( i, init_targetname, done_notify );
	}
}


//
//	Actually Plays the FX along the wire
perk_wire_fx_client( clientnum, init_targetname, done_notify )
{
	println( "perk_wire_fx_client for client #"+clientnum );
	targ = getstruct(init_targetname,"targetname");
	if ( !IsDefined( targ ) )
	{
		return;
	}
	
	mover = Spawn( clientnum, targ.origin, "script_model" );
	mover SetModel( "tag_origin" );	
	fx = PlayFxOnTag( clientnum, level._effect["wire_spark"], mover, "tag_origin" );
	
	fake_ent = spawnfakeent(0);
	setfakeentorg(0, fake_ent, mover.origin);
	playsound( 0, "tele_spark_hit", mover.origin );
	playloopsound( 0, fake_ent, "tele_spark_loop");
	mover thread tele_spark_audio_mover(fake_ent);

	while(isDefined(targ))
	{
		if(isDefined(targ.target))
		{
			println( "perk_wire_fx_client#"+clientnum+" next target: "+targ.target );
			target = getstruct(targ.target,"targetname");
			
//			PlayFx( clientnum, level._effect["wire_spark"], mover.origin );
			mover MoveTo( target.origin, 0.1 );
			wait( 0.1 );

			targ = target;
		}
		else
		{
			break;
		}		
	}
	level notify( "spark_done" );
	mover Delete();
	deletefakeent(0,fake_ent);

	// Link complete, light is green
	level notify( done_notify );
}

tele_spark_audio_mover(fake_ent)
{
	level endon( "spark_done" );

	while (1)
	{
		waitrealtime(0.05);
		setfakeentorg(0, fake_ent, self.origin);
	}
}

//
// Pulls the fog in
dog_start_monitor()
{
	while( 1 )
	{
	level waittill( "dog_start" );

//set up for the new bsp/and compensation for bloom
	start_dist = 229;
	half_dist = 200;
	half_height = 380;
	base_height = 200;
	fog_r = 0.0117647;
	fog_g = 0.0156863;
	fog_b = 0.0235294;
	fog_scale = 5.5;
	sun_col_r = 0.0313726;
	sun_col_g = 0.0470588;
	sun_col_b = 0.0823529;
	sun_dir_x = -0.1761;
	sun_dir_y = 0.689918;
	sun_dir_z = 0.702141;
	sun_start_ang = 0;
	sun_stop_ang = 49.8549;
	time = 7;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	}
}

//
// Pushes fog out
dog_stop_monitor()
{
	while( 1 )
	{
		level waittill( "dog_stop" );

		start_dist = 440;
		half_dist = 3200;
		half_height = 225;
		base_height = 64;
		fog_r = 0.533;
		fog_g = 0.717;
		fog_b = 1;
		fog_scale = 1;
	sun_col_r = 0.0313726;
	sun_col_g = 0.0470588;
	sun_col_b = 0.0823529;
	sun_dir_x = -0.1761;
	sun_dir_y = 0.689918;
	sun_dir_z = 0.702141;
		sun_start_ang = 0;
		sun_stop_ang = 0;
		time = 7;
		max_fog_opacity = 1;
		
	
		setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	}
}
level_fog_init()
{
	start_dist = 440;
	half_dist = 3200;
	half_height = 225;
	base_height = 64;
	fog_r = 0.219608;
	fog_g = 0.403922;
	fog_b = 0.686275;
	fog_scale = 1;
	sun_col_r = 0.0313726;
	sun_col_g = 0.0470588;
	sun_col_b = 0.0823529;
	sun_dir_x = -0.1761;
	sun_dir_y = 0.689918;
	sun_dir_z = 0.702141;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
}	

//
//  Replace the light models when the lights turn on and off
light_model_swap( name, model )
{
		level waittill( "pl1" );	// Power lights on

		players = getlocalplayers();
		for ( p=0; p<players.size; p++ )
		{
			lamps = GetEntArray( p, name, "targetname" );
			for ( i=0; i<lamps.size; i++ )
			{
				lamps[i] SetModel( model );
			}
		}

}


//
//	This is some crap to get around my inability to get usable angles from a model in a prefab
get_guide_struct_angles( ent )
{
	guide_structs = GetStructArray( "map_fx_guide_struct", "targetname" );
	if ( guide_structs.size > 0 )
	{
		guide = guide_structs[0];
		dist = DistanceSquared(ent.origin, guide.origin);
		for ( i=1; i<guide_structs.size; i++ )
		{
			new_dist = DistanceSquared(ent.origin, guide_structs[i].origin);
			if ( new_dist < dist )
			{
				guide = guide_structs[i];
				dist = new_dist;
			}
		}
		
		return guide.angles;
	}

	return (0, 0, 0);
}


//
//	Controls the lights on the teleporters
//		client-sided in case we do any flashing/blinking
teleporter_map_light( light_name, on_msg )
{
	level waittill( "pl1" );	// power lights on

	players = getlocalplayers();
	for ( p=0; p<players.size; p++ )
	{
		lamps = GetEntArray( p, light_name, "targetname" );
		for ( i=0; i<lamps.size; i++ )
		{ 
			lamps[i] SetModel( "zombie_zapper_cagelight_red" );
			if(isDefined(lamps[i].fx))
			{
				lamps[i].fx delete();
			}

	angles = lamps[i].angles;
	println( light_name + "- model angles : "+angles[0]+", "+angles[1]+", "+angles[2] );
	//			playfxontag(p, level._effect["zapper_light_notready"],lamps[i].fx,"tag_origin");

			angles = get_guide_struct_angles( lamps[i] );			
			lamps[i].fx = SpawnFx( p, level._effect["zapper_light_notready"], lamps[i].origin, 0, AnglesToForward( angles ) );
			TriggerFX(lamps[i].fx);
		}
	}
	
	// wait until it is linked
	level waittill( on_msg );

	players = getlocalplayers();
	for ( p=0; p<players.size; p++ )
	{
		lamps = GetEntArray( p, light_name, "targetname" );
		for ( i=0; i<lamps.size; i++ )
		{
			lamps[i] SetModel( "zombie_zapper_cagelight_green" );
			if(isDefined(lamps[i].fx))
			{
				lamps[i].fx delete();
			}
			angles = get_guide_struct_angles( lamps[i] );			
			lamps[i].fx = SpawnFx( p, level._effect["zapper_light_ready"], lamps[i].origin, 0, AnglesToForward( angles ) );
			TriggerFX(lamps[i].fx);
		}
	}
}

//
//	The map light for the receiver is special.  It acts differently than the teleporter lights
//
teleporter_map_light_receiver()
{
	level waittill( "pl1" );	// power lights on

	level thread teleporter_map_light_receiver_flash();
	
	players = getlocalplayers();
	for ( p=0; p<players.size; p++ )
	{
		lamps = GetEntArray( p, "sm_light_tp_r", "targetname" );
		for ( i=0; i<lamps.size; i++ )
		{
			lamps[i] SetModel( "zombie_zapper_cagelight_red" );
			if(isDefined(lamps[i].fx))
			{
				lamps[i].fx delete();
			}
			angles = get_guide_struct_angles( lamps[i] );
			lamps[i].fx = SpawnFx( p, level._effect["zapper_light_notready"], lamps[i].origin, 0, AnglesToForward( angles ) );
			TriggerFX(lamps[i].fx);
		}
	}

	level waittill( "pap1" );	// Pack-a-Punch On
	wait( 1.5 );	// dramatic pause
	
	level.map_light_receiver_on = true;
	players = getlocalplayers();
	for ( p=0; p<players.size; p++ )
	{
		lamps = GetEntArray( p, "sm_light_tp_r", "targetname" );
		for ( i=0; i<lamps.size; i++ )
		{
			lamps[i] SetModel( "zombie_zapper_cagelight_green" );
			if(isDefined(lamps[i].fx))
			{
				lamps[i].fx delete();
			}
			angles = get_guide_struct_angles( lamps[i] );			
			lamps[i].fx = SpawnFx( p, level._effect["zapper_light_ready"], lamps[i].origin, 0, AnglesToForward( angles ) );
			TriggerFX(lamps[i].fx);
		}
	}
}


//
//	When the players try to link teleporters, we need to flash the light
//
teleporter_map_light_receiver_flash()
{
	level endon( "pap1" );	// Pack-A-Punch machine is on
	level waittill( "TRf" );	// Teleporter Receiver map light flash
	
	// After you have started, then you can end when you get a stop command.
	//	Putting it after you start prevents premature stopping 
	level endon( "TRs" );		// Teleporter receiver map light stop 
	level thread teleporter_map_light_receiver_stop();
	
	while (1)
	{
		players = getlocalplayers();
		for ( p=0; p<players.size; p++ )
		{
			lamps = GetEntArray( p, "sm_light_tp_r", "targetname" );
			for ( i=0; i<lamps.size; i++ )
			{
				lamps[i] SetModel( "zombie_zapper_cagelight_red" );
				if(isDefined(lamps[i].fx))
				{
					lamps[i].fx delete();
				}
				angles = get_guide_struct_angles( lamps[i] );
				lamps[i].fx = SpawnFx( p, level._effect["zapper_light_notready"], lamps[i].origin, 0, AnglesToForward( angles ) );
				TriggerFX(lamps[i].fx);
			}
		}
		wait( 0.5 );

		players = getlocalplayers();
		for ( p=0; p<players.size; p++ )
		{
			lamps = GetEntArray( p, "sm_light_tp_r", "targetname" );
			for ( i=0; i<lamps.size; i++ )
			{
				lamps[i] SetModel( "zombie_zapper_cagelight" );
				if(isDefined(lamps[i].fx))
				{
					lamps[i].fx delete();
				}
			}
		}
		wait( 0.5 );
	}
}


//
//	When you stop flashing, put the correct model back on
teleporter_map_light_receiver_stop()
{
	level endon( "pap1" );	// Pack-A-Punch machine is on

	level waittill( "TRs" );	// teleporter receiver light stop 

	players = getlocalplayers();
	for ( p=0; p<players.size; p++ )
	{
		lamps = GetEntArray( p, "sm_light_tp_r", "targetname" );
		for ( i=0; i<lamps.size; i++ )
		{
			lamps[i] SetModel( "zombie_zapper_cagelight_red" );
			if(isDefined(lamps[i].fx))
			{
				lamps[i].fx delete();
			}
			angles = get_guide_struct_angles( lamps[i] );
			lamps[i].fx = SpawnFx( p, level._effect["zapper_light_notready"], lamps[i].origin, 0, AnglesToForward( angles ) );
			TriggerFX(lamps[i].fx);
		}
	}

	// listen for another flash message
	level thread teleporter_map_light_receiver_flash();
}


//
// Float the objects and have them spin around and fly off
flytrap_lev_objects()
{
	level waittill( "ag1" );

	// Get the spots
	i = 0;
	hover_spots = [];
	hover_spots[i] = GetStruct( "trap_ag_spot0", "targetname" );
	while ( IsDefined( hover_spots[i].target ) )
	{
		hover_spots[i+1] = GetStruct( hover_spots[i].target, "targetname" );
		i++;
	}

	// Have them fly around
	players = getlocalplayers();
	for ( p=0; p<players.size; p++ )
	{
		floaters = GetEntArray( p, "ee_floaty_stuff", "targetname" );
		for ( k=0; k<floaters.size; k++ )
		{
			floaters[k] thread anti_grav_move( p, hover_spots, k );
		}
	}
}


//
//	Controls moving debris up and away!
anti_grav_move( clientnum, spots, start_index )
{
	sound_ent = spawnfakeent(0);
	setfakeentorg( 0, sound_ent, self.origin);
	playloopsound( 0, sound_ent, "flytrap_loop");
	self thread flytrap_audio_mover( sound_ent );
	
	playfxontag (clientnum, level._effect["powerup_on"], self, "tag_origin");
	// float up
	playsound( 0, "flytrap_spin", self.origin );
	self MoveTo( spots[start_index].origin, 4 );
	wait( 4 );

	// spin around
	stop_spinning = false;
	index = start_index;
	interval = 0.4;
	z_increment = 0;
	offset = 0;
	while( !stop_spinning )
	{
		index++;
		if ( index >= spots.size )
		{
			index = 0;
		}
		if ( index == start_index )
		{
			interval = interval - 0.1;
			z_increment = 15;
		}
		if ( interval <= 0.1 && index == 0 )
		{
			stop_spinning = true;
		}
		offset = offset + z_increment;
		self MoveTo( spots[index].origin+(0,0,offset), interval );
		wait( interval );
	}

	// now fly away
	end_spot = GetStruct( "trap_flyaway_spot", "targetname" );
	self MoveTo( end_spot.origin+(RandomFloatRange(-100,100),0,0), 5 );
	playsound( 0, "shoot_off", self.origin );
	wait( 4.7 );
	
	level notify( "delete_sound_ent" );
	deletefakeent(0,sound_ent);
	self delete();
}

flytrap_audio_mover( sound_ent )
{
	level endon( "delete_sound_ent" );

	while (1)
	{
		waitrealtime(0.05);
		setfakeentorg( 0, sound_ent, self.origin);
	}
}
*/