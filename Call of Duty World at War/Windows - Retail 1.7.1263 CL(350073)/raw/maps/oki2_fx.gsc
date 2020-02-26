/*-----------------------------------------------------
Effects used for Okinawa 2
-----------------------------------------------------*/
#include common_scripts\utility;
#include maps\_utility;

main()
{
	//setExpFog(0, 4000, 0.566, 0.549, 0.467, 0);
	maps\createart\oki2_art::main();
	precachefx();
	spawnfx();
	footsteps();
	level thread water_drops_init( 50 );
	
	thread weather_settings();
}

// Global Wind Settings
weather_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "0 -220 0" );
	SetSavedDvar( "wind_global_low_altitude", -1000 );
	SetSavedDvar( "wind_global_hi_altitude", 1000 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.1 );

	// Add a while loop to vary the strength of the wind over time.
}

footsteps()
{
    animscripts\utility::setFootstepEffect( "asphalt",   	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "brick",       	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "carpet",     	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "cloth",       	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "concrete", 	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "dirt",         LoadFx( "bio/player/fx_footstep_sand" ) );
    animscripts\utility::setFootstepEffect( "foliage",    	LoadFx( "bio/player/fx_footstep_sand" ) );
    animscripts\utility::setFootstepEffect( "gravel",     	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "grass",      	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "ice",         	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "metal",      	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "mud",       	LoadFx( "bio/player/fx_footstep_mud" ) );
    animscripts\utility::setFootstepEffect( "paper",      	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "plaster",    	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "rock",       	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "sand",       	LoadFx( "bio/player/fx_footstep_sand" ) );
    animscripts\utility::setFootstepEffect( "water",      	LoadFx( "bio/player/fx_footstep_water" ) );
    animscripts\utility::setFootstepEffect( "wood",      	LoadFx( "bio/player/fx_footstep_dust" ) );
    animscripts\utility::setFootstepEffect( "fire",      	LoadFx( "bio/player/fx_footstep_fire" ) );
}

precacheFX()
{
	level.mortar = loadfx("weapon/mortar/fx_mortar_exp_mud_medium");
	
	//level._effect["arty_strike_mud"] = loadfx("weapon/mortar/fx_mortar_exp_mud_medium");		//This isn't used anymore.
	level._effect["tracerfire"] = loadfx("weapon/tracer/fx_tracer_flak_single_noExp");
	level._effect["falling_rocks"] = loadfx("maps/oki2/fx_artillery_strike_falling_rocks");
	level._effect["arty_strike_rock"] = loadfx("weapon/artillery/fx_artillery_exp_strike_rock");
	level._effect["rain"] = loadfx("env/weather/fx_rain_lght");
	//level._effect["battleship_muzzle"]		=	loadfx("weapon/ship/fx_ship_battle_14in");			//This isn't used anymore.
	//level._effect["ship_backlight"] = loadfx("maps/oki2/fx_glow_ship_backlight");						//This isn't used anymore.
	//level._effect["artillery_geotrail"] =  loadfx("weapon/rocket/fx_lci_rocket_geotrail"); //This isn't used anymore.
	//level._effect["artillery_slide"] =  loadfx("maps/oki2/fx_artillery_slide");         //This isn't used anymore.
	level._effect["gunsmoke"] = loadfx("env/smoke/thin_black_smoke_M");
	level._effect["gunflash"] = loadfx("weapon/artillery/fx_artillery_jap_200mm_no_smoke");
	level._effect["flesh_hit"] = LoadFX( "impacts/flesh_hit" );
	
	// for the sniper tree
	level._effect["sniper_leaf_loop"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf01");	
	level._effect["sniper_leaf_canned"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf02");
	
	// flamethrower stuff
    level._effect["character_fire_pain_sm"]              		= loadfx( "env/fire/fx_fire_player_sm_1sec" );
    level._effect["character_fire_death_sm"]             		= loadfx( "env/fire/fx_fire_player_md" );
    level._effect["character_fire_death_torso"] 				= loadfx( "env/fire/fx_fire_player_torso" );
    
   	// rocket barrage
   	level._effect["rocket_launch"]								= loadfx("weapon/rocket/fx_LCI_rocket_ignite_launch");
   	level._effect["rocket_trail"]								= loadfx("weapon/rocket/fx_lci_rocket_geotrail");
   	//level._effect["lci_rocket_impact"]							= loadfx("weapon/rocket/fx_LCI_rocket_explosion_beach");
   	level._effect["lci_rocket_impact"]							= loadfx("weapon/rocket/fx_lci_rocket_explosion_mud");
   	
   	// bombers in event1
   	level._effect["default_explosion"]							= loadfx("explosions/default_explosion");
		
	
	level._effect["flame_death1"] = loadfx("env/fire/fx_fire_player_sm");
	level._effect["flame_death2"] = loadfx("env/fire/fx_fire_player_torso");
	level._effect["flame_death3"] = loadfx("env/fire/fx_fire_player_sm");	
	
  	
//////////////////////////////////////////////////////////////////////////////////////
///////////////////////DALE'S SECTION	////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

	level._effect["a_cave_drip"]					= loadfx("maps/oki2/fx_rain_drip_cave_tunnel");
	level._effect["a_entrance_drip"]			= loadfx("maps/oki2/fx_drip_entrance");
	level._effect["a_cave_entrance_drip"] = loadfx("maps/oki2/fx_rain_drip_cave_entrance");
	level._effect["a_wtrfall_sm"]					= loadfx("env/water/fx_wtrfall_sm");
	level._effect["a_wtrfall_splash_sm"]	= loadfx("env/water/fx_wtrfall_splash_sm");
	level._effect["a_wtrfall_splash_sm_puddle"]	= loadfx("env/water/fx_wtrfall_splash_sm_puddle");
	level._effect["a_wtrfall_md"]					= loadfx("env/water/fx_wtrfall_md");
	level._effect["a_wtr_spill_sm"]				= loadfx("env/water/fx_wtr_spill_sm");
	level._effect["a_wtr_spill_sm_int"]				= loadfx("env/water/fx_wtr_spill_sm_int");
	level._effect["a_wtr_spill_sm_splash"]	= loadfx("env/water/fx_wtr_spill_sm_splash");
	level._effect["a_wtr_spill_sm_splash_puddle"]	= loadfx("env/water/fx_wtr_spill_sm_splash_puddle");
	level._effect["a_wtr_flow_sm"]				= loadfx("env/water/fx_wtr_flow_sm");
	level._effect["a_wtr_flow_md"]				= loadfx("env/water/fx_wtr_flow_md");
	level._effect["a_water_wake_flow_sm"]	= loadfx("env/water/fx_water_wake_flow_sm");
	level._effect["a_water_wake_flow_md"]	= loadfx("env/water/fx_water_wake_flow_md");
	level._effect["a_water_ripple"]				= loadfx("env/water/fx_water_splash_ripple_puddle");
	level._effect["a_water_ripple_md"]		= loadfx("env/water/fx_water_splash_ripple_puddle_med");
	level._effect["a_water_ripple_aisle"]	= loadfx("env/water/fx_water_splash_ripple_puddle_aisle");
	level._effect["a_water_ripple_line"]	= loadfx("env/water/fx_water_splash_ripple_line");
	level._effect["a_rain_cave_ceiling_hole"]	= loadfx("maps/oki2/fx_rain_cave_ceiling_hole");
	
	level._effect["bunker_explosion"] =				loadfx("maps/oki2/fx_explo_bunker_window");
	level._effect["bunker_side_explosion"] =	loadfx("maps/oki2/fx_explo_bunker_side");
	level._effect["cave_flame_gout"] =				loadfx("maps/oki2/fx_bunker_cave_flame_gout");
	level._effect["bunker_explosion_big"]		= loadfx("maps/oki2/fx_explo_bunker_big");
	
	//level._effect["a_godray_xsm"]	= loadfx("env/light/fx_light_godray_overcast_xsm");
	level._effect["a_godray_sm"]	= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["a_godray_md"]	= loadfx("env/light/fx_light_godray_overcast_md");
	level._effect["a_godray_lg"]	= loadfx("env/light/fx_light_godray_overcast_lg");
	//level._effect["a_godray_sm_1side"]	= loadfx("env/light/fx_light_godray_overcast_sm_1sd");
	level._effect["a_godray_md_1side"]	= loadfx("env/light/fx_light_godray_overcast_md_1sd");
	level._effect["a_godray_lg_1side"]	= loadfx("env/light/fx_light_godray_overcast_lg_1sd");
	
	level._effect["a_fire_smoke_med"] = loadfx("env/fire/fx_fire_house_md_jp");
	level._effect["a_fire_smoke_med_dist"] = loadfx("env/fire/fx_fire_smoke_md_dist_jp");
	level._effect["a_fire_smoke_sm_dist"] = loadfx("env/fire/fx_fire_smoke_sm_dist_jp");
	level._effect["a_fire_smoke_med_int"] = loadfx("env/fire/fx_fire_md_low_smk_jp");
	level._effect["a_fire_brush_smldr_sm"] = loadfx("env/fire/fx_fire_brush_smolder_sm_jp");
	//level._effect["a_fire_brush_smldr_md"] = loadfx("env/fire/fx_fire_brush_smolder_md_jp");
	level._effect["a_fire_rubble_sm_jp"]	= loadfx("env/fire/fx_fire_rubble_sm_jp");
	level._effect["a_fire_rubble_detail_md"]	= loadfx("env/fire/fx_fire_rubble_detail_md_jp");
	level._effect["a_fire_rubble_smolder_sm_jp"]	= loadfx("env/fire/fx_fire_rubble_smolder_sm_jp");
	//level._effect["a_fire_tree_smldr_sm"] = loadfx("env/fire/fx_fire_tree_smolder_sm_jp");
	//level._effect["a_fire_tree_sm"] = loadfx("env/fire/fx_fire_tree_sm_jp");
	level._effect["a_fire_brush_detail"] = loadfx("env/fire/fx_fire_rubble_detail_jp");
	level._effect["a_fire_150x600_distant"]	= loadfx("env/fire/fx_fire_150x600_tall_distant_jp");
	
	level._effect["a_ground_fog"]					= loadfx("env/smoke/fx_battlefield_smokebank_ling_foggy_w");
	level._effect["a_ground_smoke"]					= loadfx("env/smoke/fx_battlefield_smokebank_ling_foggy");
	level._effect["a_cratersmoke"]				= loadfx("env/smoke/fx_smoke_crater_w");
	level._effect["a_smoke_smolder"]			= loadfx("env/smoke/fx_smoke_impact_smolder");
	level._effect["a_background_smoke"]		= loadfx("maps/oki2/fx_smoke_slow_black_windblown");
	level._effect["a_smk_column_md_blk_dir"]		= loadfx("env/smoke/fx_smk_column_md_blk_dir");
	level._effect["a_smoke_plume_lg_slow_def"]	= loadfx("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["a_smoke_smolder_md_gry"]	= loadfx("env/smoke/fx_smoke_smolder_md_gry");
	//level._effect["artillery_ling_smoke"]		= loadfx ("maps/oki2/fx_smoke_artillery_barrage");
	level._effect["a_rainbow"]	= loadfx("env/weather/fx_rainbow");
	
}

spawnFX()
{
	
	maps\createfx\oki2_fx::main();
	
}



/*------------------------------------
Play the rain effect <--- TEMP 
------------------------------------*/
player_rain()
{
	self endon("death");
	self endon("disconnect");
	
	for (;;)
	{
		if(getdvar("oki2_rain") == "" )
		{
			playfx ( level._effect["rain"], self.origin + (0,0,0));
		}
		wait (0.1);
	}
}

cliffside_ambient_fire()
{
	level endon("stop cliffside fire");
	
	level thread cliff_fire("grotto_gun_upper","upper");
	level thread cliff_fire("grotto_gun_1","1");
	level thread cliff_fire("grotto_gun_2","2");
	level thread cliff_fire("grotto_gun_4","4");
	
	
	level thread battleship_artillery_fire();
	//level thread ship_tracerfire();	
}

/*------------------------------------
Ambient battleship stuff
------------------------------------*/
battleship_artillery_fire( )
{
	
	level endon ("stop firing");	
	fire_starts = getstructarray("14inch","targetname");
	
	for (i = 0; i < fire_starts.size; i++)
	{
		level.battleship_firing_states[i] = "not_firing";
	}
	
		
	// loop forever
	while (1)
	{		
		// grab the start point
		start_num = randomint(fire_starts.size);
		fire_point = fire_starts[start_num];
		start_point = fire_point;
		
		
		while (	level.battleship_firing_states[start_num] == "firing" )
		{
			// grab the start point again if its already firing
			start_num = randomint(fire_starts.size);
			fire_point = fire_starts[start_num];
			start_point = fire_point;
			wait (0.05);
		}
		level.battleship_firing_states[start_num] = "firing";

		// how many times the ship will fire
		firetimes = randomint (3) + 1;		
				
		// fire up to 3 times
		for (i = 0; i < firetimes; i++)
		{
			fire_point = start_point;
						
			// play all the muzzle on the ship at once
			while (1)
			{		
				//playfx(	level._effect["battleship_muzzle"], fire_point.origin , (0, -90, 0));//(-0,360,0) );
				//playfx( level._effect["ship_backlight"],fire_point.origin + (-500,0,100) ,(0,-90,0) );
				thread fire_arty_gun(fire_point.origin);
				//thread play_fire_sound(fire_point.origin);
				
				// get the next in line and play again
				if (isdefined(fire_point.target))
				{
					fire_point = getstruct(fire_point.target,"targetname");
				}
				else
				{
					break;		// break if there are no more in the chain
				}
				wait(randomfloatrange(.1,.5));
				//snd delete();
			}

			// wait between salvos on the ship
			wait (1.5);
		}
		level.battleship_firing_states[start_num] = "not_firing";
						
		// wait to select a new ship
		wait (randomintrange (1, 5));
	}
}

/*------------------------------------
fires a rocket from the ship
------------------------------------*/
fire_arty_gun(org)
{
	thread play_fire_sound(org);
	
	//ent = spawn("script_model",org + (randomintrange(-500,500),randomintrange(-500,500),randomintrange(-500,500) ));
	//ent setmodel("weapon_ger_panzershreck_rocket");
	//ent.angles = (0,289,0);
	thread arty_launch();

}

/*------------------------------------

------------------------------------*/
arty_launch()
{
	
	targets = getstructarray("ridge_arty","targetname");
	target = targets[randomint(targets.size)];
	
	if(target.script_fxid != "rock" && level.event_1_finished )
	{
		return;
	}
	
	ent = spawn("script_model",target.origin + (randomintrange(-100,100),randomintrange(-100,100),0 ));

	//only play smoke trails on 40% of the incoming shells
	//i'm thinking this is kind of expensive, so might need to take it out
//	if(randomint(100) > 70 && target.script_fxid == "rock")
//	{
//		playfxontag(level._effect["artillery_geotrail"] , self ,"TAG_ORIGIN");
//		self moveto(target.origin + ( randomintrange(-100,100),0,randomint(20)),5);
//	}
//	else
//	{
		//self moveto(target.origin + ( randomintrange(-100,100),randomintrange(-100,100),0),5);
	//}	
	
	//wait 2 seconds, then play an incoming sound
	//wait(2);
	//self playsound ("naval_gun_incoming");
	
	//wait until the 
	//self waittill("movedone");
	
	wait(randomfloatrange(4,5));
	
		
	if(target.script_fxid == "rock")
	{
		playfx(level._effect["arty_strike_rock"],ent.origin);
	
	}
	else
	{
		//playfx(level._effect["arty_strike_mud"],self.origin);
		playfx(level.mortar,ent.origin);
	}
		
	ent do_earthquake();
	
	ent playsound("naval_gun_impact");	
	
	if(target.script_fxid == "Rock")
	{
		wait(.5);
		playfx(level._effect["falling_rocks"], ent.origin);
	}
	
	wait(1);

	ent delete();
}

/*------------------------------------
shake the camera when the naval shells impact the cliff
------------------------------------*/
do_earthquake()
{
	
	players = get_players();
	close = false;
	
	for(i=0;i<players.size;i++)
	{
		if(distancesquared(players[i].origin, self.origin) < (10000))
		{
			close = true;
		}		
	}
	
	// shake the camera a bit more if the impacts are closer to the player,unless event 1 has been finished
	if(close && (!level.event_1_finished))
	{
		earthquake(randomfloatrange(.20,.35),3,self.origin, 10000);
	}
	else
	{
		earthquake(randomfloatrange(.05,.15),3,self.origin, 10000);
	}
	
}

/*------------------------------------
the distant firing sounds of the battleships
------------------------------------*/
play_fire_sound(org)
{

	ent = spawn("script_model",org);
	wait(.1);
	ent playsound("naval_gun_fire","fired");
	ent waittill("fired");
	ent delete();

}

/*------------------------------------
tracerfire coming from battleships
 - currently not using
------------------------------------*/
//ship_tracerfire()
//{
//	targs = getstructarray("14inch","targetname");
//	
//	while(1)
//	{
//		targ = targs[randomint(targs.size)];
//		targ.angles = (randomintrange(225,270), 0,0);
//		for(i=0;i<5;i++)
//		{
//			playfx(level._effect["tracerfire"],targ.origin);
//			wait(randomfloatrange(.1,.3));
//		}
//		wait(randomint(4));
//	}
//}

/*------------------------------------
ambient 200mm guns firing from cliffs 
------------------------------------*/
cliff_fire(fx_firepoint,gun)
{
	level endon("stop_" + gun);
	
	while(1)
	{
		thread model3_tracerfire(fx_firepoint,gun);
		wait(randomfloatrange(2,5));			
	}

}

model3_tracerfire(fx_firepoint,gun)
{
	
	//ents[0] = getstruct("grotto_gun_upper","targetname");
	//ents[1] = getstruct("grotto_gun_1","targetname");
	//ents[2] = getstruct("grotto_gun_2","targetname");
	//ents = getstructarray("cliff_return_fire","targetname");
	
	ent = getstruct(fx_firepoint,"targetname");
	
	playfx( level._effect["gunflash"],ent.origin,AnglesToForward( ent.angles ));
	snd = spawn("script_model",ent.origin);
	wait(.1);	
	snd playsound("model3_fire","firedone");
	snd waittill("firedone");
	snd delete();

}

water_drops_init( startCount )
{
	trigs = GetEntArray( "trigger_water_drops", "targetname" );
	ASSERTEX( IsDefined( trigs ) && trigs.size > 0, "Can't find any water drop fx triggers." );
	
	array_thread( trigs, ::water_drops_trigger_think );
	
	if( IsDefined( startCount ) && startCount > 0 )
	{
		// wait for everyone to connect, and start them with water on the lens
		level waittill("introscreen_complete");
	
		array_thread( get_players(), ::scr_set_water_drops, startCount );
	}
}

water_drops_trigger_think()
{
	if( !IsDefined( self.script_int ) )
	{
		ASSERTMSG( "Water drop fx trigger at origin " + self.origin + " does not have script_int set.  You need to set this to specify the amount of water drops that will be generated." );
		return;
	}
	
	while( 1 )
	{
		self waittill( "trigger", player );
		
		if( IsPlayer( player ) )
		{
			player SetWaterDrops( self.script_int );
		}
	}
}

scr_set_water_drops( count )
{
	if( IsDefined( self ) )
	{
		self SetWaterDrops( count );
	}
}