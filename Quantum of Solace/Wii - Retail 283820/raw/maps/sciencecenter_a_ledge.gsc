#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\sciencecenter_a_util;


ledge_main()
{

	
	level thread turn_on_spotlight();
	level thread roof_ledge_save();
	level thread force_cover_initializer();
	level thread back_spawn_ledge_thugs();
	

}





roof_ledge_save()
{
	trigger = getent ( "roof_ledge_save", "targetname" );
	trigger waittill ( "trigger" );
	
	thread roof_ledge_dialog();
	
	level notify("alley_done");
	
	
	level thread maps\sciencecenter_a_rooftop::rooftop_main();
	level notify("heli_wire_loop_start");
	

	thread maps\_autosave::autosave_now("MiamiScienceCenter");
}
roof_ledge_dialog()
{
	
	level.player play_dialogue("SCS1_SciAG_028A", true); 
	wait(0.5);
	level.player play_dialogue("RMR1_SciAG_029A", true); 
	wait(0.5);
	level.player play_dialogue("SCS1_SciAG_030A", true); 
}
turn_on_spotlight()
{
	trigger = getent ( "start_spotlight_trig", "targetname" );
	trigger waittill ( "trigger" );

	
	level.player play_dialogue("SCSM_SciAG_900A", true); 
	
	wait(1.0);

	
	level thread roof_spotlight_tracker();
}



force_cover_initializer()
{
	enter_trigger = getEnt( "trigger_go_into_cover", "targetname" );
 	exit_trigger = getEnt( "trigger_exit_cover", "targetname" );
	
	enter_trigger waittill ( "trigger" );
	maps\_utility::holster_weapons();
	thread special_spotlight_ledge_crawl();

	level notify("catwalk");

	
	

	exit_trigger waittill ( "trigger" );
	maps\_utility::unholster_weapons();

}
 




#using_animtree("fxanim_searchlight");
roof_spotlight_tracker()
{
	light_cone = getent ( "fxanim_searchlight", "targetname" );
	playfxontag ( level._effect["science_lightbeam04"], light_cone, "light_bulb_1" );

	
	light_cone playsound("searchlight_on");
	light_cone playloopsound( "searchlight_run" );


	level.dyn_spot_light rotatepitch ( 15, .5 );
	level.dyn_spot_light setlightintensity ( 4 );

	level thread back_spot_light_01();
	level thread back_spot_light_02();
	level thread back_spot_light_03();

	
	searchlight = getent( "fxanim_searchlight", "targetname" );
	searchlight UseAnimTree (#animtree);
	searchlight animscripted( "back_spot_rotate", searchlight .origin, searchlight.angles, %fxanim_searchlight );

	level.dyn_spot_light thread back_spot_light_loop_track( light_cone );
	
}



back_spot_light_01()
{
	light_origin = getent ( "fxanim_searchlight", "targetname" );
	playfxontag ( level._effect["science_lightbeam04"], light_origin, "light_bulb_2" );
}



back_spot_light_02()
{
	light_origin = getent ( "fxanim_searchlight", "targetname" );
	playfxontag ( level._effect["science_lightbeam04"], light_origin, "light_bulb_3" );
}



back_spot_light_03()
{
	light_origin = getent ( "fxanim_searchlight", "targetname" );
	playfxontag ( level._effect["science_lightbeam04"], light_origin, "light_bulb_4" );
}



back_spot_light_loop_track( light_cone )
{
	
	
	while ( 1 )
	{
		wait( .15 );
		spot_org = light_cone gettagorigin( "spotlight_wall" );
		spot_ang = light_cone gettagangles( "spotlight_wall" );

		self MoveTo ( spot_org, 0.15 );
		self RotateTo ( spot_ang, 0.15 );
		if ( level.roof_start != 0 )
		{
			break;
		}
	}
}




special_spotlight_ledge_crawl()
{
	level endon("reached_roof");
	
	level.dyn_spot_light setlightintensity(0);

	thread remove_special_spotlight_ledge_crawl();

	ledge_light_start = getent ( "ledge_spotlight_start", "targetname" );
	ledge_light_stop = getent ( "ledge_spotlight_stop", "targetname" );
	
	level.spotlight_ledge MoveTo(ledge_light_start.origin, 0.05);
	level.spotlight_ledge waittill ( "movedone" );
	level.spotlight_ledge setlightintensity(4);

	

		
	while(true)
	{
		level.spotlight_ledge moveto(ledge_light_stop.origin, 11.0);
		
		wait(12.0);
		level.spotlight_ledge moveto(ledge_light_start.origin, 11.0);
		wait(12.0);
	}
}	
remove_special_spotlight_ledge_crawl()
{
	level waittill("reached_roof");
	
	level.dyn_spot_light setlightintensity(4);
	level.spotlight_ledge setlightintensity(0);
}	
getting_caught_spotlight()
{
	level endon ( "kill_spotlight_tracker" );
	while( true )
	{
		vCamera_origin = level.spotlight_ledge.origin;
		vTarget_origin = level.player GetEye();

		if( !sightTracePassed( vCamera_origin, vTarget_origin, false, undefined ) )
		{
				wait( 0.15 );
		}

		vNormal = vectorNormalize( vTarget_origin - vCamera_origin );
		vCamera_forward = anglesToForward( level.spotlight_ledge.angles );
		fDot = vectorDot( vCamera_forward, vNormal );
		if ( fDot >= 0.96 )
		{
			level notify ( "spotlight_trigger" );
			return;
		}
		wait( 0.15 );
	}
}




light_spotting_bond( light_cone )
{
	level endon ( "kill_spotlight_tracker" );
	while( true )
	{
		vCamera_origin = light_cone gettagorigin( "spotlight_wall" );
		vTarget_origin = level.player GetEye();

		if( !sightTracePassed( vCamera_origin, vTarget_origin, false, undefined ) )
		{
				wait( 0.15 );
		}

		vNormal = vectorNormalize( vTarget_origin - vCamera_origin );
		vCamera_forward = anglesToForward( light_cone gettagangles( "spotlight_wall" ) );
		fDot = vectorDot( vCamera_forward, vNormal );
		if ( fDot >= 0.96 )
		{
			level notify ( "spotlight_trigger" );
			return;
		}
		wait( 0.15 );
	}
}



back_spawn_ledge_thugs()
{	
	trigger = getent ( "trigger_ai_lose_sense", "targetname" );
	trigger waittill ( "trigger" );
	mantel = getent ( "ledge_mantel_brush", "targetname" );
	mantel movez ( -5000, .5 );
	thug_1 = getent ("roof_shooters_01", "targetname")  stalingradspawn( "thug_1" );
	thug_1 waittill( "finished spawning" );
	thug_1.goalradius = 12;	

	thug_1 thread ledge_make_ai_leave();
	thug_1 setenablesense( false );
	
	thug_2 = getent ("roof_shooters_02", "targetname")  stalingradspawn( "thug_2" );
	thug_2 waittill( "finished spawning" );
	thug_2.goalradius = 12;	

	thug_2 thread ledge_make_ai_leave();
	thug_2 setenablesense( false );
	wait( 1 );
	level thread global_ai_lose_sense();

	
	if ( isdefined ( thug_1 ))
	{
		thug_1 startpatrolroute ( "roof_shooter_patrol_01" );
	}
	if ( isdefined ( thug_2 ))
	{
		thug_2 startpatrolroute ( "roof_shooter_patrol_02" );
	}

	level thread remove_thugs(thug_1, thug_2);
	
	level waittill( "spotlight_trigger" );

	thread kill_bond_fast();

	
	if ( isdefined ( thug_1 ))
	{
		level.player play_dialogue( "BMR2_SciAG_022A", true ); 
		wait( 2 );
	}
	if ( isdefined ( thug_2 ))
	{
		level.player play_dialogue( "SCS1_SciAG_039A", true ); 
	}
	

}


remove_thugs(thug_1, thug_2) {
	level waittill("reached_rooftop");
	if (isdefined(thug_1)) thug_1 delete();
	if (isdefined(thug_2)) thug_2 delete();
}



global_ai_lose_sense()
{
	thug = getaiarray("axis");
	
	for (i=0; i<thug.size; i++)
	{
		if( isdefined ( thug[i].targetname )) 
		{
			thug[i] setenablesense( false );
		}
	}
}

kill_bond_fast()
{
	thug = getaiarray("axis");

	for (i=0; i<thug.size; i++)
{
		thug[i] thread fire_at_ledge();
	}
}

fire_at_ledge()
		{
	self endon("death");
	level endon("reached_roof");

	self setenablesense( true );
	self setalertstatemin("alert_red");	
	self setperfectsense(true);
	self addengagerule("tgtperceive");
	
	while(IsDefined(self))
		{
		xtime = randomfloatrange( 1.0, 2.5 );
		self cmdshootatentityxtimes( level.player, false, 2, 0.8 );		
		self cmdaimatentity( level.player, false, -1);

		wait( xtime );
		self stopallcmds();
	}
		}





roof_command_node_01()
{
	self CmdAction ( "fidget" );
}






ledge_camera()
{	
	
	level thread ledge_main_crop();
	level thread ledge_main_move();
	
	
	level thread ledge_pip();
}


ledge_main_crop()
{
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 4);		

	level.player animatepip( 1000, 1, -1, -1, 1, 0.5, 0, 0);
	wait(1);
		
	level notify( "window_crop" );
		
	level waittill( "window_up" );

	level.player animatepip( 1000, 1, -1, -1, 1, 1, 0, 0);
	wait(1);
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	

}


ledge_main_move()
{
	
	level waittill( "window_crop" );
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );

	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



ledge_pip()
{
	
	setdvar("ui_hud_showstanceicon", "0");

	ledge_pip_ent = getent ( "ledge_pip_up", "targetname" );
	trig = getent( "trigger_exit_cover", "targetname" );

	
	
	SetDVar("r_pipSecondaryX", -0.2 );						
	SetDVar("r_pipSecondaryY", -0.13);						
	SetDVar("r_pipSecondaryAnchor", 4);						
	SetDVar("r_pipSecondaryScale", "1 0.55 1.0 0");		
	SetDVar("r_pipSecondaryAspect", false);					
	level waittill( "window_down" );
		
	cameraID_ledge = level.player securityCustomCamera_Push("world", level.player, ledge_pip_ent.origin + (0, 0, -4), ( -8,0,0 ), 0.0);
	
	
	SetDVar("r_pipSecondaryMode", 5);						
	SetDVar("r_lodBias", -500);

	level.player animatepip( 500, 0, 0.25, -1 );
	wait(0.5);

	trig waittill( "trigger" );
	
	level.player animatepip( 500, 0, 1, -1 );
	wait(0.5);
	
	level notify( "off_ledge" );
	
	
	SetDVar("r_pipSecondaryMode", 0);						
	SetDVar("r_lodBias", 0);
	level.player securityCustomCamera_Pop(cameraID_ledge);

	
	setdvar("ui_hud_showstanceicon", "1");	
}
