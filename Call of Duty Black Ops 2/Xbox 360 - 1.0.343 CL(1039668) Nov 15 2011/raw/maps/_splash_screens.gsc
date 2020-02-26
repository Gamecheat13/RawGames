// splash screen

#include maps\_utility;

main()
{
	wait(0.05);
	
	const production_build = false;
	
	//TODO: Glocke (9/4/09)- Fix this because it's a hack and we need to know which levels do or do not use splash screens... Are the GL levels using the intro screen system?
	if( !production_build || level.script == "creek_1" || level.script == "crossroads" || level.script == "flashpoint" || level.script == "fullahead" || level.script == "quagmire" || level.script == "collateral_damage" )
	{
		return;
	}

	freeze_players();
	create_screen_generic();
	create_splash_hudelems();

	// custom text per level
	switch(level.script)
	{
	case "creek_1":
		set_text_creek_1();
		break;
	case "crossroads":
		set_text_crossroads();
		break;	
	case "flashpoint":
		set_text_flashpoint();
		break;
	case "fullahead":
		set_text_fullahead();
		break;
	case "quagmire":
		set_text_quagmire();
		break;
	case "inc_squad_urban":
		set_text_inc_squad_urban();
		break;
	default:
		break;
	}	

	wait_for_x_press();
	destroy_all();
	unfreeze_players();
}

freeze_players()
{
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(true);
	}
}

unfreeze_players()
{
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(false);
	}
}

wait_for_x_press()
{
	wait(5);
	breakme = false;
	while(!breakme)
	{
		players = get_players();
		for(i = 0; i < players.size; i++)
		{
			if(players[i] UseButtonPressed())
			{
				breakme = true;
			}
		}
		wait(0.05);
	}
}

create_screen_generic()
{
	level.screen_generic = NewHudElem(); 
	level.screen_generic.x = 0; 
	level.screen_generic.y = 0; 
	level.screen_generic.horzAlign = "fullscreen"; 
	level.screen_generic.vertAlign = "fullscreen"; 
	level.screen_generic SetShader( "black", 640, 480 ); 
	level.screen_generic.alpha = 1;
	level.screen_generic.sort = 1;
}

create_hudelem( x, y, alignX, alignY, horzAlign, vertAlign, foreground, alpha, fontscale)
{
	new_elem = NewHudElem(); 
	new_elem.x = x;
	new_elem.y = y;
	new_elem.alignX = alignX;
	new_elem.alignY = alignY;
	new_elem.horzAlign = horzAlign;
	new_elem.vertAlign = vertAlign;
	new_elem.foreground = foreground;
	new_elem.alpha = alpha;
	new_elem.fontscale = fontscale;

	return new_elem;
}

create_splash_hudelems()
{
	// press x text
	level.press_x_hud = create_hudelem(0, 360, "center", "top", "center", "top", true, 1, 2);
	level.press_x_hud setText( "Press X to Start" );

	// instructional text
	level.instructions_elem = create_hudelem(0, 100, "center", "top", "center", "top", true, 1, 2.7);
	level.instructions_elem2 = create_hudelem(0, 130, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem3 = create_hudelem(0, 150, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem4 = create_hudelem(0, 170, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem5 = create_hudelem(0, 200, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem6 = create_hudelem(0, 220, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem7 = create_hudelem(0, 240, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem8 = create_hudelem(0, 280, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem9 = create_hudelem(0, 300, "center", "top", "center", "top", true, 1, 1.5);
	level.instructions_elem10 = create_hudelem(0, 320, "center", "top", "center", "top", true, 1, 1.5);
}

destroy_all()
{
	level.screen_generic fadeOvertime( 3 );
	level.screen_generic.alpha = 0;
	level.instructions_elem destroy();
	level.instructions_elem2 destroy();
	level.instructions_elem3 destroy();
	level.instructions_elem4 destroy();
	level.instructions_elem5 destroy();
	level.instructions_elem6 destroy();
	level.instructions_elem7 destroy();
	level.instructions_elem8 destroy();
	level.instructions_elem9 destroy();
	level.instructions_elem10 destroy();
	level.press_x_hud destroy();
}

////////////
// custom text per level functions
////////////
set_text_creek_1()
{
	level.instructions_elem setText( "UP A CREEK" );	
	level.instructions_elem2 setText( "Scripting: 1st pass for beats 1, 2, 3, 5 and 6" );	
	level.instructions_elem3 setText( "Building: 1st pass rough out from beat 1 to beat 6" );	
	level.instructions_elem4 setText( "Key Event: Beat 4 - Boat Combat" );	
	level.instructions_elem5 setText( "Mission Synopsis: The NVA might be getting Nukes from Kusnetsov.  ");
	level.instructions_elem6 setText( "The squad proceeds up the river in search of Kusnetsov");
	level.instructions_elem7 setText( "Along the way the squad must survive ambushes and deserted villages...");
	level.instructions_elem8 setText( "Playable Feature: Hero Characters");
	level.instructions_elem9 setText( "Playable Feature: Drivable Boat/platform and Exploration");
	level.instructions_elem10 setText( "Playable Feature: Create A Class");
}

set_text_crossroads()
{
	level.instructions_elem setText( "CROSSROADS" );	
	level.instructions_elem2 setText( "Scripting: 1st pass for beats 1, 2, 3, 5 and 6" );	
	level.instructions_elem3 setText( "Building: 1st pass rough out from beat 1 to beat 5" );	
	level.instructions_elem4 setText( "Key Event: Beat 4 - Rooftops" );	
	level.instructions_elem5 setText( "Mission Synopsis: At a low key meeting in a Cairo bar, Reznov and the squad wait for the contact to arrive. ");
	level.instructions_elem6 setText( "The squad is ambushed and barely make it out of the bar.");
	level.instructions_elem7 setText( "The team must now fight over the roof tops of the city and escape with the informants intel...");
	level.instructions_elem8 setText( "Playable Feature: Hero Characters");
	level.instructions_elem9 setText( "Playable Feature: Core movement = Door Breaching");
	level.instructions_elem10 setText( "Playable Feature: Platform Bus Rail and Sonic Tracking");
}

set_text_flashpoint()
{
	level.instructions_elem setText( "FLASHPOINT" );	
	level.instructions_elem2 setText( "Scripting: 1st pass for beats 1 to 7" );	
	level.instructions_elem3 setText( "Building: 1st pass rough out from beat 1 to beat 7" );	
	level.instructions_elem4 setText( "Key Event: Beat 6 and 7 - Hanger, Rocket Takeoff" );	
	level.instructions_elem5 setText( "Mision Snyopsis: We need to extract a VIP - or so we think - ");
	level.instructions_elem6 setText( "The team must get through the rocket facility avoiding many test areas.");
	level.instructions_elem7 setText( "Once the rockets coordinates are sabotaged the team must get out alive...");
	level.instructions_elem8 setText( "Playable Feature: Hero Characters");
	level.instructions_elem9 setText( "");
	//level.instructions_elem9 setText( "Playable Feature: Core Movement - Slide, beat 2");
	level.instructions_elem10 setText( "Playable Feature: Zip Line, Beat 5");
}

set_text_fullahead()
{
	level.instructions_elem setText( "FULLAHEAD" );	
	level.instructions_elem2 setText( "Scripting: 1st pass from beat 2 to beat 8" );	
	level.instructions_elem3 setText( "Building: 1st pass rough out from beat 1 to beat 8" );	
	level.instructions_elem4 setText( "Mission Synopsis: The squad is trying to find the mysterious ghostship.");
	level.instructions_elem5 setText( "Once discovered, they learn its a floating super virus lab for the Dead Nazis.");
	level.instructions_elem6 setText( "However the men of Kusnetzov are also looking for the same boat...");
	level.instructions_elem7 setText( "Playable Feature: Hero Characters");
	level.instructions_elem8 setText( "Playable Feature: Core movement = SLIDING after Beat 2");
	level.instructions_elem9 setText( "Do you want to see Beat 1 geo?: Use - jump to Start - exterior");
	level.instructions_elem10 setText( "");
}

set_text_quagmire()
{
	level.instructions_elem setText( "QUAGMIRE" );	
	level.instructions_elem2 setText( "Scripting: 1st pass from beat 1 to beat 8" );	
	level.instructions_elem3 setText( "Building: 1st pass rough out from beat 1 to beat 8" );	
	level.instructions_elem4 setText( "Key Event: Beat 6 to 8 - Down to One, Street Fighter, High Low" );	
	level.instructions_elem5 setText( "Mission Synopsis: At the height of the TET offensive, the squad gets new orders. ");
	level.instructions_elem6 setText( "They must fight their way over and through Hue City to secure an American embassy.");
	level.instructions_elem7 setText( "Then they find an injured CIA agent and have to get out of dodge...");
	level.instructions_elem8 setText( "Playable Feature: Hero Characters");
	level.instructions_elem9 setText( "Playable Feature: Core movement = Door Breaching");
	level.instructions_elem10 setText( "Playable Feature: Helicopter platform");
}

set_text_inc_squad_urban()
{
	level.instructions_elem setText( "INCUBATOR: SQUAD CONTROL" );	
	level.instructions_elem2 setText( "Sprint: Week 3" );	
	level.instructions_elem3 setText( "" );	
	level.instructions_elem4 setText( "Player Controls:" );	
	level.instructions_elem5 setText( "Press LB to designate an area for the squad to move to, User will see YELLOW ringed marker to designate marker placement." );
	level.instructions_elem6 setText( "BLUE ringed markers are for AI node selection, these will remain on screen until AI is near" );
	level.instructions_elem7 setText( "GREY ringed markers signify areas that are too far for voice orders to be heard, RED signifies an attack or action order" );
	level.instructions_elem8 setText( "" );
	level.instructions_elem9 setText( "1st pass tank destruction event implemented, 1st pass dumpster/MG event implemented " );
	level.instructions_elem10 setText( "AI revive functioning, MACV Office from Quagmire ported over to warhouse interior (1st pass AI node placement also present)" );
}