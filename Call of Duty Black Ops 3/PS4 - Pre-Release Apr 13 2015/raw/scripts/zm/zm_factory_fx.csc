#using scripts\codescripts\struct;

#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       



#precache( "client_fx", "zombie/fx_glow_eye_orange" );

//#precache( "client_fx", "misc/fx_zombie_grain_cloud" );
#precache( "client_fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
#precache( "client_fx", "electric/fx_elec_sparks_directional_orange" );

#precache( "client_fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
	
#precache( "client_fx", "maps/zombie/fx_zombie_light_glow_green" );
#precache( "client_fx", "maps/zombie/fx_zombie_light_glow_red" );
#precache( "client_fx", "electrical/fx_elec_wire_spark_dl_oneshot" );

#precache( "client_fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );
#precache( "client_fx", "zombie/fx_glow_eye_orange" );
#precache( "client_fx", "zombie/fx_powerup_on_green_zmb" );

#precache( "client_fx", "zombie/fx_bul_flesh_head_fatal_zmb" );
#precache( "client_fx", "zombie/fx_bul_flesh_head_nochunks_zmb" );
#precache( "client_fx", "zombie/fx_bul_flesh_neck_spurt_zmb" );
#precache( "client_fx", "zombie/fx_blood_torso_explo_zmb" ); 
#precache( "client_fx", "trail/fx_trail_blood_streak" ); 	
/*
#precache( "client_fx", "maps/zombie_old/fx_mp_battlesmoke_thin_lg" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_150x150_tall_distant" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_150x600_tall_distant" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_small_detail" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_window_smk_rt" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_window_smk_lf" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_window" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_rubble_small" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_rubble_md_smk" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_rubble_md_lowsmk" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_rubble_detail_grp" );
#precache( "client_fx", "maps/zombie_old/fx_mp_ray_fire_thin" );
//#precache( "client_fx", "maps/mp_maps/fx_mp_fire_column_sm" );
#precache( "client_fx", "maps/mp_maps/fx_mp_fire_column_lg" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_furnace" );
	
#precache( "client_fx", "maps/zombie_old/fx_mp_smoke_fire_column" );
#precache( "client_fx", "maps/zombie_old/fx_mp_smoke_plume_lg" );
#precache( "client_fx", "maps/zombie_old/fx_mp_smoke_hall" );
#precache( "client_fx", "maps/zombie_old/fx_mp_ash_falling_large" );
#precache( "client_fx", "maps/zombie_old/fx_mp_light_glow_indoor_short_loop" );
#precache( "client_fx", "maps/zombie_old/fx_mp_light_glow_outdoor_long_loop" );
#precache( "client_fx", "maps/zombie_old/fx_mp_insects_lantern" );
#precache( "client_fx", "maps/zombie_old/fx_mp_fire_torch_noglow" );
	*/
#precache( "client_fx", "env/fire/fx_embers_falling_sm" );
	
//#precache( "client_fx", "maps/ber3/fx_tracers_flak88_amb" );
//#precache( "client_fx", "maps/mp_maps/fx_mp_flak_field" );
//#precache( "client_fx", "maps/mp_maps/fx_mp_flak_field_flash" );

//#precache( "client_fx", "destructibles/fx_dest_fire_vert" );
//#precache( "client_fx", "maps/zombie_old/fx_mp_light_lamp" );
#precache( "client_fx", "zombie/fx_smk_stack_burning_zmb" );
#precache( "client_fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );	
#precache( "client_fx", "zombie/fx_elec_gen_idle_zmb" );
#precache( "client_fx", "zombie/fx_moon_eclipse_zmb" );	
#precache( "client_fx", "zombie/fx_clock_hand_zmb" );
#precache( "client_fx", "zombie/fx_elec_pole_terminal_zmb" );	
#precache( "client_fx", "electric/fx_elec_sparks_burst_sm_circuit_os" );	
//#precache( "client_fx", "maps/zombie_old/fx_mp_light_lamp_no_eo" );													

#precache( "client_fx", "zombie/fx_elec_trap_zmb" );


// load fx used by util scripts
function precache_util_fx()
{	

}

function main()
{
	//zm_factory_fx::main();
	//_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}

	// use this array to convert a teleport_pad index to a, b, or c
	level.teleport_pad_names = [];
	level.teleport_pad_names[0] = "a";
	level.teleport_pad_names[1] = "c";
	level.teleport_pad_names[2] = "b";
	
	level thread perk_wire_fx( "pw0", "pad_0_wire", "t01" );
	level thread perk_wire_fx( "pw1", "pad_1_wire", "t11" );
	level thread perk_wire_fx( "pw2", "pad_2_wire", "t21" );

	// Threads controlling the lights on the maps in the Teleporter rooms
	level thread teleporter_map_light( 0, "t01" );
	level thread teleporter_map_light( 1, "t11" );
	level thread teleporter_map_light( 2, "t21" );
	level.map_light_receiver_on = false;
	level thread teleporter_map_light_receiver();

	level thread dog_start_monitor();
	level thread dog_stop_monitor();
//	level thread level_fog_init();
	
	level thread light_model_swap( "smodel_light_electric",				"lights_indlight_on" );
	level thread light_model_swap( "smodel_light_electric_milit",		"lights_milit_lamp_single_int_on" );
	level thread light_model_swap( "smodel_light_electric_tinhatlamp",	"lights_tinhatlamp_on" );

//	level thread flytrap_lev_objects();
}

function precache_scripted_fx()
{
	/*Need light exploder for the following old fx settings
	"zapper_fx" fx_zombie_zapper_powerbox_on 
	"zapper_wall" fx_zombie_zapper_wall_control_on
	*/
	//level._effect["zombie_grain"]					= "misc/fx_zombie_grain_cloud";
	level._effect["electric_short_oneshot"]			= "electrical/fx_elec_sparks_burst_sm_circuit_os";
	level._effect["switch_sparks"]					= "electric/fx_elec_sparks_directional_orange";
	
	level._effect["elec_trail_one_shot"]			= "electric/fx_elec_sparks_burst_sm_circuit_os";
	
	level._effect["zapper_light_ready"]				= "maps/zombie/fx_zombie_light_glow_green";
	level._effect["zapper_light_notready"]			= "maps/zombie/fx_zombie_light_glow_red";
	level._effect["wire_sparks_oneshot"]			= "electrical/fx_elec_wire_spark_dl_oneshot";

	level._effect["wire_spark"]						= "electric/fx_elec_sparks_burst_sm_circuit_os";

	level._effect["eye_glow"]				= "zombie/fx_glow_eye_orange";
	level._effect["headshot"]				= "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"]		= "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"]				= "zombie/fx_bul_flesh_neck_spurt_zmb";

	level._effect["powerup_on"]						= "zombie/fx_powerup_on_green_zmb";

	level._effect["animscript_gib_fx"]				= "zombie/fx_blood_torso_explo_zmb"; 
	level._effect["animscript_gibtrail_fx"]			= "trail/fx_trail_blood_streak"; 	
}

function precache_createfx_fx()
{
	/* Need light exploder
	 * "mp_ray_light_xsm" fx_mp_ray_moon_xsm
	 * "mp_ray_light_sm" fx_mp_ray_moon_sm
	 * "fx_mp_flare_md" fx_mp_flare_md
	 * "mp_ray_light_md" fx_mp_ray_moon_md
	 * "mp_ray_light_lg_1sd" fx_mp_ray_moon_lg_1sd
	 * "mp_ray_light_lg" fx_mp_ray_moon_lg
	 * "fx_mp_ray_fire_ribbon" fx_mp_ray_fire_ribbon
	 * "fx_mp_ray_fire_ribbon_med" fx_mp_ray_fire_ribbon_med
	 * */
	/*level._effect["mp_battlesmoke_lg"]				= "maps/zombie_old/fx_mp_battlesmoke_thin_lg";
	level._effect["mp_fire_distant_150_150"]		= "maps/zombie_old/fx_mp_fire_150x150_tall_distant";
	level._effect["mp_fire_distant_150_600"]		= "maps/zombie_old/fx_mp_fire_150x600_tall_distant";
	level._effect["mp_fire_static_small_detail"]	= "maps/zombie_old/fx_mp_fire_small_detail";
	level._effect["mp_fire_window_smk_rt"]			= "maps/zombie_old/fx_mp_fire_window_smk_rt";
	level._effect["mp_fire_window_smk_lf"]			= "maps/zombie_old/fx_mp_fire_window_smk_lf";
	level._effect["mp_fire_window"]					= "maps/zombie_old/fx_mp_fire_window";
	level._effect["mp_fire_rubble_small"]			= "maps/zombie_old/fx_mp_fire_rubble_small";
	level._effect["mp_fire_rubble_md_smk"]			= "maps/zombie_old/fx_mp_fire_rubble_md_smk";
	level._effect["mp_fire_rubble_md_lowsmk"]		= "maps/zombie_old/fx_mp_fire_rubble_md_lowsmk";
	level._effect["mp_fire_rubble_detail_grp"]		= "maps/zombie_old/fx_mp_fire_rubble_detail_grp";
	level._effect["mp_ray_fire_thin"]				= "maps/zombie_old/fx_mp_ray_fire_thin";
//	level._effect["mp_fire_column_sm"]				= "maps/mp_maps/fx_mp_fire_column_sm";
	level._effect["mp_fire_column_lg"]				= "maps/mp_maps/fx_mp_fire_column_lg";
	level._effect["mp_fire_furnace"]				= "maps/zombie_old/fx_mp_fire_furnace";
	
	level._effect["mp_smoke_fire_column"]			= "maps/zombie_old/fx_mp_smoke_fire_column";
	level._effect["mp_smoke_plume_lg"]				= "maps/zombie_old/fx_mp_smoke_plume_lg";
	level._effect["mp_smoke_hall"]					= "maps/zombie_old/fx_mp_smoke_hall";
	level._effect["mp_ash_and_embers"]				= "maps/zombie_old/fx_mp_ash_falling_large";
	level._effect["mp_light_glow_indoor_short"]		= "maps/zombie_old/fx_mp_light_glow_indoor_short_loop";
	level._effect["mp_light_glow_outdoor_long"]		= "maps/zombie_old/fx_mp_light_glow_outdoor_long_loop";
	level._effect["mp_insects_lantern"]				= "maps/zombie_old/fx_mp_insects_lantern";
	level._effect["fx_mp_fire_torch_noglow"]		= "maps/zombie_old/fx_mp_fire_torch_noglow";
	*/
	level._effect["a_embers_falling_sm"]			= "env/fire/fx_embers_falling_sm";
	
//	level._effect["a_tracers_flak88_amb"]			= "maps/ber3/fx_tracers_flak88_amb";
//	level._effect["mp_flak_field"]					= "maps/mp_maps/fx_mp_flak_field";
//	level._effect["mp_flak_field_flash"]			= "maps/mp_maps/fx_mp_flak_field_flash";
	
//	level._effect["gasfire2"]						= "destructibles/fx_dest_fire_vert";
//	level._effect["mp_light_lamp"]					= "maps/zombie_old/fx_mp_light_lamp";
	level._effect["mp_smoke_stack"]					= "zombie/fx_smk_stack_burning_zmb";
	level._effect["mp_elec_spark_fast_random"]		= "electric/fx_elec_sparks_burst_sm_circuit_os";	
	level._effect["zombie_elec_gen_idle"]			= "zombie/fx_elec_gen_idle_zmb";
	level._effect["zombie_moon_eclipse"]			= "zombie/fx_moon_eclipse_zmb";	
	level._effect["zombie_clock_hand"]				= "zombie/fx_clock_hand_zmb";
	level._effect["zombie_elec_pole_terminal"]		= "zombie/fx_elec_pole_terminal_zmb";	
	level._effect["mp_elec_broken_light_1shot"]		= "electric/fx_elec_sparks_burst_sm_circuit_os";	
//	level._effect["mp_light_lamp_no_eo"]			= "maps/zombie_old/fx_mp_light_lamp_no_eo";													

	level._effect["zapper"]							= "zombie/fx_elec_trap_zmb";
}

// borrowed this func from asylum
function perk_wire_fx(notify_wait, init_targetname, done_notify )
{
	level waittill(notify_wait);
	
	players = getlocalplayers();
	for(i = 0; i < players.size;i++)
	{
		players[i] thread perk_wire_fx_client( i, init_targetname, done_notify );
	}
}

//	Actually Plays the FX along the wire
function perk_wire_fx_client( clientnum, init_targetname, done_notify )
{
	/#println( "perk_wire_fx_client for client #"+clientnum );#/
	targ = struct::get(init_targetname,"targetname");
	if ( !IsDefined( targ ) )
	{
		return;
	}
	
	mover = spawn( clientnum, targ.origin, "script_model" );
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
			/#println( "perk_wire_fx_client#"+clientnum+" next target: "+targ.target );#/
			target = struct::get(targ.target,"targetname");
			
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

function tele_spark_audio_mover(fake_ent)
{
	level endon( "spark_done" );

	while (1)
	{
		waitrealtime(0.05);
		setfakeentorg(0, fake_ent, self.origin);
	}
}

function ramp_fog_in_out()
{
	for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
	{
		SetLitFogBank( localClientNum, -1, 1, -1 );
		SetWorldFogActiveBank( localClientNum, 2 );	
	}

	wait( 2.5 );

	for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
	{
		SetLitFogBank( localClientNum, -1, 0, -1 );
		SetWorldFogActiveBank( localClientNum, 1 );	
	}
}

// Pulls the fog in
function dog_start_monitor()
{
	while( 1 )
	{
		level waittill( "dog_start" );

		level thread ramp_fog_in_out();

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
	
		/*setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
			sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
			sun_stop_ang, time, max_fog_opacity);*/
	}
}

//
// Pushes fog out
function dog_stop_monitor()
{
	while( 1 )
	{
		level waittill( "dog_stop" );

		level thread ramp_fog_in_out();

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
		
	
		/*setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);*/
	}
}
function level_fog_init()
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

	/*setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);*/
}	

//
//  Replace the light models when the lights turn on and off
function light_model_swap( name, model )
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
function get_guide_struct_angles( ent )
{
	guide_structs = struct::get_array( "map_fx_guide_struct", "targetname" );
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

//	Controls the lights on the teleporters
//		client-sided in case we do any flashing/blinking
function teleporter_map_light( index, on_msg )
{
	level waittill( "pl1" );	// power lights on

	exploder::exploder( "map_lgt_" + level.teleport_pad_names[index] + "_red" );

	// wait until it is linked
	level waittill( on_msg );

	exploder::stop_exploder( "map_lgt_" + level.teleport_pad_names[index] + "_red" );
	exploder::exploder( "map_lgt_" + level.teleport_pad_names[index] + "_green" );
	
	level thread scene::play( "fxanim_diff_engine_zone_" + level.teleport_pad_names[index] + "1", "targetname" );
	level thread scene::play( "fxanim_diff_engine_zone_" + level.teleport_pad_names[index] + "2", "targetname" );

	level thread scene::play( "fxanim_powerline_" + level.teleport_pad_names[index], "targetname" );
}

//
//	The map light for the receiver is special.  It acts differently than the teleporter lights
//
function teleporter_map_light_receiver()
{
	level waittill( "pl1" );	// power lights on

	level thread teleporter_map_light_receiver_flash();

	exploder::exploder( "map_lgt_pap_red" );

	level waittill( "pap1" );	// Pack-a-Punch On
	wait( 1.5 );	// dramatic pause

	exploder::stop_exploder( "map_lgt_pap_red" );
	exploder::stop_exploder( "map_lgt_pap_flash" );
	exploder::exploder( "map_lgt_pap_green" );
}


//
//	When the players try to link teleporters, we need to flash the light
//
function teleporter_map_light_receiver_flash()
{
	level endon( "pap1" );	// Pack-A-Punch machine is on
	level waittill( "TRf" );	// Teleporter Receiver map light flash
	
	// After you have started, then you can end when you get a stop command.
	//	Putting it after you start prevents premature stopping 
	level endon( "TRs" );		// Teleporter receiver map light stop 
	level thread teleporter_map_light_receiver_stop();
	
	exploder::stop_exploder( "map_lgt_pap_red" );
	exploder::exploder( "map_lgt_pap_flash" );
}


//
//	When you stop flashing, put the correct model back on
function teleporter_map_light_receiver_stop()
{
	level endon( "pap1" );	// Pack-A-Punch machine is on

	level waittill( "TRs" );	// teleporter receiver light stop 

	exploder::stop_exploder( "map_lgt_pap_flash" );
	exploder::exploder( "map_lgt_pap_red" );

	// listen for another flash message
	level thread teleporter_map_light_receiver_flash();
}


//
// Float the objects and have them spin around and fly off
/*function flytrap_lev_objects()
{
	level waittill( "ag1" );

	// Get the spots
	i = 0;
	hover_spots = [];
	hover_spots[i] = struct::get( "trap_ag_spot0", "targetname" );
	while ( IsDefined( hover_spots[i].target ) )
	{
		hover_spots[i+1] = struct::get( hover_spots[i].target, "targetname" );
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
function anti_grav_move( clientnum, spots, start_index )
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
	end_spot = struct::get( "trap_flyaway_spot", "targetname" );
	self MoveTo( end_spot.origin+(RandomFloatRange(-100,100),0,0), 5 );
	playsound( 0, "shoot_off", self.origin );
	wait( 4.7 );
	
	level notify( "delete_sound_ent" );
	deletefakeent(0,sound_ent);
	self delete();
}

function flytrap_audio_mover( sound_ent )
{
	level endon( "delete_sound_ent" );

	while (1)
	{
		waitrealtime(0.05);
		setfakeentorg( 0, sound_ent, self.origin);
	}
}*/
