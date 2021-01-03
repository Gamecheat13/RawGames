#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_safehouse;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\cp\cp_sh_cairo_fx;
#using scripts\cp\cp_sh_cairo_sound;
#using scripts\shared\music_shared;

function main()
{
	cp_sh_cairo_fx::main();
	cp_sh_cairo_sound::main();
	
	load::main();
	
	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass
	
	level thread start_music_underscore();
	level thread set_ambient_state();
	level thread setup_vignettes();
	
	callback::on_connect( &on_player_connect );
}

function set_ambient_state()
{
	level flag::wait_till( "all_players_connected" );
		
	if( isdefined( world.next_map ) )
	{
		switch( world.next_map )
		{
			case "cp_mi_cairo_aquifer":
				level util::set_lighting_state( 1 );
				break;
			default:
				break;
		}
	}
}

function setup_vignettes()
{
	const N_MIN_VIGN = 4;
	const N_MAX_VIGN = 6;
	
	a_str_scenes[0] = "cin_saf_ram_armory_vign_repair_3dprinter";
	a_str_scenes[1] = "cin_saf_ram_armory_vign_tech_bunk";
	a_str_scenes[2] = "cin_saf_ram_armory_vign_tech_inspect";
	a_str_scenes[3] = "cin_saf_ram_armory_vign_tech_mop";
	a_str_scenes[4] = "cin_saf_ram_armory_vign_tech_diagnostics";
	a_str_scenes[5] = "cin_saf_ram_armory_vign_tech_readipad";
	a_str_scenes[6] = "cin_saf_ram_armory_vign_tech_firerange";
	a_str_scenes[7] = "cin_saf_ram_armory_vign_tech_datavault";
	
	//randomize and pick a certain number of vignettes to play
	a_str_scenes = array::randomize( a_str_scenes );
	n_vign_total = RandomIntRange( N_MIN_VIGN, N_MAX_VIGN );
	for( n_vign_index = 0; n_vign_index < n_vign_total; n_vign_index++ )
	{
		level thread scene::play( a_str_scenes[ n_vign_index ] );
	}
	
	//bonus round for scaffolding guy
	if( math::cointoss() )
	{
		level thread vignette_scaffold_logic();
	}
}

function vignette_scaffold_logic()
{
	//he stares at it for a bit
	for( n_times = 0; n_times < 3; n_times++ )
	{
		scene::play( "cin_saf_ram_armory_vign_repair_scafolding_inspect" );
	}
	
	//when will he finally climb up? only math_shared knows	
	while( true )
	{
		scene::play( "cin_saf_ram_armory_vign_repair_scafolding_inspect" );
		if( math::cointoss() )
		{
			level thread scene::play( "cin_saf_ram_armory_vign_repair_scafolding_climb" );
			return;
		}
	}
}

function start_music_underscore()
{
	wait (2);
	//music::setmusicstate ("INTRO"); (removing for milestone because of issue with UI\Music interaction)
	music_ent = spawn("script_origin", (0,0,0));
	music_ent playloopsound ("mus_underscore");
}

function on_player_connect()
{
	self endon( "disconnect" );
	
	//wait a frame before setting menus
	wait 0.05;
	
	self SetClientUIVisibilityFlag( "hud_visible", 0 );
	
	//TODO remove once select class is gone
	fade_to_black_menu = self OpenLUIMenu( "FadeToBlack" );
	self flagsys::wait_till( "loadout_given" );
	fullscreen_black_menu = self OpenLUIMenu( "FullscreenBlack" );
		
	//TODO need to put the align struct in each bunk prefab and align the animation to the correct bunk
	self thread scene::play( "cin_saf_ram_bunk_1st_getup", self );

	//get into the animation for a bit
	wait 0.5;
	
	//Close both to get the fade out effect
	self CloseLUIMenu( fullscreen_black_menu );
	self CloseLUIMenu( fade_to_black_menu );
	
	//don't boot HUD up immediately
	wait 2;
	
	self SetClientUIVisibilityFlag( "hud_visible", 1 );
}

