#include common_scripts\utility;
#include maps\_utility;
#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;
#define MSG_DISPLAY_TIME	8
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
preload()
{
	flag_init("rts_tutorial_not_ready");
}
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
init()
{
	level.rts.tutorials = [];
	level.rts.tutorials["quadrotor_pkg"] 	= ::tutorial_quadrotor_pkg;
	level.rts.tutorials["metalstorm_pkg"] 	= ::tutorial_asd_pkg;
	level.rts.tutorials["bigdog_pkg"] 		= ::tutorial_claw_pkg;
	
	
	level thread main();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
main()
{
	level endon( "rts_terminated" );
	flag_wait( "start_rts" );


	pkgs = maps\_so_rts_catalog::package_generateAvailable("allies",true);
	
	foreach (pkg in pkgs)
	{
		if ( pkg.squad_type == "mechanized")
		{
			if ( isDefined(level.rts.tutorials[pkg.ref]) )
			{
				level thread [[level.rts.tutorials[pkg.ref]]]();
			}
		}
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
tutorial_done()
{
	if (!isDefined(level.rts.active_tutorial))
		return;
		
	if (isDefined(level.rts.active_tutorial.msg))
	{
		level.rts.active_tutorial.msg maps\_hud_util::destroyElem();
		level.rts.active_tutorial.msg = undefined;
	}
	
	level.rts.active_tutorial = undefined;
	level notify("tutorial_done");
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
abort_tutorial_on_notify(ent,note,cb)
{
	level endon("tutorial_done");
	ent waittill(note);
	[[cb]]();
	level notify("tutorial_done");
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
tutorial_quadrotor_pkg()
{
	level waittill("takeover_quadrotor_pkg",entity);
	level endon("tutorial_done");

	while(flag("rts_tutorial_not_ready"))
	{
		wait 0.05;
	}
	

	assert(!isDefined(level.rts.active_tutorial),"Failed cleanup");

	level.rts.active_tutorial 		= spawnstruct();
	tutorial = level.rts.active_tutorial;
	
	tutorial.msg 	= NewHudElem();
	if (!isDefined(tutorial.msg))
	{
		tutorial_done();
		return;
	}
	
	level thread abort_tutorial_on_notify(entity,"death",::tutorial_done);
	level thread abort_tutorial_on_notify(level,"switch_and_takeover",::tutorial_done);
	level thread abort_tutorial_on_notify(level,"eye_in_the_sky",::tutorial_done);
	level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_TUTORIAL_QUADROTOR_PKG");
			
	tutorial.msg.alignX 		= "center";
	tutorial.msg.alignY 		= "middle";
	tutorial.msg.horzAlign		= "center";
	tutorial.msg.vertAlign		= "middle";
	tutorial.msg.y 	 	   	   -= 130;
	tutorial.msg.foreground 	= true;
	tutorial.msg.fontScale 		= 2;
	tutorial.msg.color 			= ( 1.0, 1.0, 1.0 );
	tutorial.msg.hidewheninmenu	= false;
	tutorial.msg.alpha 			= 0;
	tutorial.msg SetText( &"SO_RTS_TUTORIAL_QUADROTOR_PKG" );
	tutorial.msg FadeOverTime( 1 );
	tutorial.msg.alpha 			= 1;
	wait MSG_DISPLAY_TIME;
	tutorial.msg FadeOverTime( 2 );
	tutorial.msg.alpha 			= 0;

	tutorial_done();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
tutorial_asd_pkg()
{
	level waittill("takeover_metalstorm_pkg",entity);
	level endon("tutorial_done");

	while(flag("rts_tutorial_not_ready"))
	{
		wait 0.05;
	}

	assert(!isDefined(level.rts.active_tutorial),"Failed cleanup");

	level.rts.active_tutorial 		= spawnstruct();
	tutorial = level.rts.active_tutorial;
	
	tutorial.msg 	= NewHudElem();
	if (!isDefined(tutorial.msg))
	{
		tutorial_done();
		return;
	}

	level thread abort_tutorial_on_notify(entity,"death",::tutorial_done);
	level thread abort_tutorial_on_notify(level,"switch_and_takeover",::tutorial_done);
	level thread abort_tutorial_on_notify(level,"eye_in_the_sky",::tutorial_done);
	level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_TUTORIAL_METALSTORM_PKG");
			
	tutorial.msg.alignX 		= "center";
	tutorial.msg.alignY 		= "middle";
	tutorial.msg.horzAlign		= "center";
	tutorial.msg.vertAlign		= "middle";
	tutorial.msg.y 	 	   	   -= 130;
	tutorial.msg.foreground 	= true;
	tutorial.msg.fontScale 		= 2;
	tutorial.msg.color 			= ( 1.0, 1.0, 1.0 );
	tutorial.msg.hidewheninmenu	= false;
	tutorial.msg.alpha 			= 0;
	tutorial.msg SetText( &"SO_RTS_TUTORIAL_METALSTORM_PKG" );
	tutorial.msg FadeOverTime( 1 );
	tutorial.msg.alpha 			= 1;
	wait MSG_DISPLAY_TIME;
	tutorial.msg FadeOverTime( 2 );
	tutorial.msg.alpha 			= 0;

	tutorial_done();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
tutorial_claw_pkg()
{
	level waittill("takeover_bigdog_pkg",entity);
	level endon("tutorial_done");
	
	while(flag("rts_tutorial_not_ready"))
	{
		wait 0.05;
	}
	
	assert(!isDefined(level.rts.active_tutorial),"Failed cleanup");

	level.rts.active_tutorial 		= spawnstruct();
	tutorial = level.rts.active_tutorial;
	
	tutorial.msg 	= NewHudElem();
	if (!isDefined(tutorial.msg))
	{
		tutorial_done();
		return;
	}
	level thread abort_tutorial_on_notify(entity,"death",::tutorial_done);
	level thread abort_tutorial_on_notify(level,"switch_and_takeover",::tutorial_done);
	level thread abort_tutorial_on_notify(level,"eye_in_the_sky",::tutorial_done);
	level thread maps\_so_rts_support::create_hud_message(&"SO_RTS_TUTORIAL_BIGDOG_PKG");

	tutorial.msg.alignX 		= "center";
	tutorial.msg.alignY 		= "middle";
	tutorial.msg.horzAlign		= "center";
	tutorial.msg.vertAlign		= "middle";
	tutorial.msg.y 	 	   	   -= 130;
	tutorial.msg.foreground 	= true;
	tutorial.msg.fontScale 		= 2;
	tutorial.msg.color 			= ( 1.0, 1.0, 1.0 );
	tutorial.msg.hidewheninmenu	= false;
	tutorial.msg.alpha 			= 0;
	tutorial.msg SetText( &"SO_RTS_TUTORIAL_BIGDOG_PKG" );
	tutorial.msg FadeOverTime( 1 );
	tutorial.msg.alpha 			= 1;
	wait MSG_DISPLAY_TIME;
	tutorial.msg FadeOverTime( 2 );
	tutorial.msg.alpha 			= 0;
	
	tutorial_done();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	


