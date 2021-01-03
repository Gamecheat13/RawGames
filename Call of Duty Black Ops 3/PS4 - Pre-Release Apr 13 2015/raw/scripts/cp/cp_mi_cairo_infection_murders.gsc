#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                               	                                                          	              	                                                                                           
                                                           

#using scripts\cp\_dialog;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_infection_util;

#precache( "string", "cp_infection_fs_blackstation" );

#namespace blackstation_murders;

// replace this when event scripting is ready
function cleanup( str_objective, b_starting, b_direct, player )
{

}

function main()
{
	init_clientfields();
}	

// replace this when event scripting is ready
function murders_main( str_objective, b_starting )
{
	setup_scenes();

	//force to black wait for streamers
	util::screen_fade_out( 0, "black" );
	
	if ( b_starting )
	{
		util::screen_fade_out( 0, "black" );
		util::set_streamer_hint( 2 );
		//util::set_streamer_hint( SARAH_VIGNETTE_03 );
		util::screen_fade_in( 0.5, "black" );
	}

	skipto::teleport_players( str_objective );

	level flag::wait_till( "all_players_spawned" );

	//Init to spawn ceiling tiles.
	level clientfield::set("black_station_ceiling_fxanim", 1);

	players_enter_black_station();

	array::thread_all(level.players, &infection_util::player_enter_cinematic );
	
	black_station_murders_scene();

	level thread util::clear_streamer_hint();
	
	ceiling_panels_fly_away();
	
	wait 4; // Let players wander around a little bit before we force them to fly through the ceiling.

	array::thread_all(level.players, &infection_util::player_leave_cinematic );
	
	players_fly_through_ceiling();

	level thread skipto::objective_completed( str_objective );
}

function init_clientfields()
{
	clientfield::register("world", "black_station_ceiling_fxanim", 1, 2, "int" );
}	

function setup_scenes()
{
// Comment out scripter vo upon request by animator. Should delete the scripter vo for good soon.
//	scene::add_scene_func( "cin_inf_08_03_blackstation_vign_aftermath", &vo_aftermath, "play" );

	scene::add_scene_func( "cin_inf_08_03_blackstation_vign_aftermath", &scene_aftermath_start, "play" );
	scene::add_scene_func( "cin_inf_08_03_blackstation_vign_aftermath", &scene_aftermath_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh010", &scene_3rd_sh010_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh010", &scene_3rd_sh010_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh020", &scene_3rd_sh020_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh020", &scene_3rd_sh020_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh030", &scene_3rd_sh030_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh030", &scene_3rd_sh030_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh040", &scene_3rd_sh040_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh040", &scene_3rd_sh040_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh050", &scene_3rd_sh050_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh050", &scene_3rd_sh050_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh060", &scene_3rd_sh060_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh060", &scene_3rd_sh060_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh070", &scene_3rd_sh070_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh070", &scene_3rd_sh070_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh080", &scene_3rd_sh080_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh080", &scene_3rd_sh080_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh090", &scene_3rd_sh090_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh090", &scene_3rd_sh090_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh100", &scene_3rd_sh100_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh100", &scene_3rd_sh100_done, "done" );
	
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh110", &scene_3rd_sh110_play, "play" );
	scene::add_scene_func( "cin_inf_08_blackstation_3rd_sh110", &scene_3rd_sh110_done, "done" );
	
	scene::add_scene_func( "cin_inf_09_01_flippingworld_1st_risefal", &scene_risefal, "play" );
}

function players_enter_black_station( str_objective )
{	
	level thread util::screen_fade_in( 1, "black" );	

	level scene::play( "cin_inf_07_04_sarah_vign_03" );

	util::screen_fade_out( 0, "black" );
	
	level thread util::screen_fade_in( 1, "black" );	
}

function black_station_murders_scene()
{
	level thread scene::play( "cin_inf_08_blackstation_3rd_sh010" );
	
	level waittill( "cin_inf_08_blackstation_3rd_sh100_done" );
	
	level thread util::screen_fade_in( 1, "black" );
	level scene::play( "cin_inf_08_03_blackstation_vign_aftermath" );
}

function ceiling_panels_fly_away()
{
	//playsoundatposition ("evt_ceiling_flyaway", (0,0,0));
	//ceiling tiles fly away (play).
	level clientfield::set("black_station_ceiling_fxanim", 2);	
}

function players_fly_through_ceiling()
{
	level scene::play( "cin_inf_09_01_flippingworld_1st_risefal" );
}

function scene_risefal( a_ents )
{	
	a_ents[ "player 1"] waittill ( "start_fade" );		// nt set in the anim "pb_inf_09_01_flippingworld_1st_risefall_player"
	level thread util::screen_fade_out( 0.3, "white" );
}

function scene_aftermath_start( a_ents )
{
	// TODO: remove ignoreall calls when idle animation is available; otherwise AI shoot the player when the scene is done
	a_ents[ "sarah" ] ai::set_ignoreall( true );
	a_ents[ "prometheus" ] ai::set_ignoreall( true );
	a_ents[ "hyperion" ] ai::set_ignoreall( true );	
}

// clean up this area after player has left it
function scene_aftermath_done( a_ents )
{
	level flag::wait_till( "black_station_completed" );
	
	foreach ( ent in a_ents )
	{
		if ( isdefined( ent ) ) { ent Delete(); };
	}
}

// ----------------------------------------------------------------------------
// DIALOG IGC: BLACK STATION MURDERS VO
// TODO: this may be handled in cinematic ??
// ----------------------------------------------------------------------------
function vo_aftermath( a_ents )
{
	//TODO: currently the scene is not long enough to play all lines. it doesn't finish until you land in Foy.
	
	//sarah in your head.
	level.players[0] dialog::say( "hall_the_said_they_needed_0", 0.0 );//The said they needed to run a diagnostics check - but that wasn’t the truth...
	level.players[0] dialog::say( "hall_we_were_marked_for_t_0", 0.0 );//We were marked for termination.
	level.players[0] dialog::say( "hall_but_by_the_time_w_0", 0.0 );//But... by the time we got there, the staff were already dead - carved to pieces by a 54 immortals enforcer by the name of Jae Xiong.
	level.players[0] dialog::say( "hall_we_knew_they_d_send_0", 1.0 );//We knew they’d send a wetwork team after us. We had no choice but to cut a deal with immortals and get the hell out of Singapore.

	level dialog::player_say( "plyr_that_wasn_t_what_hap_0", 0.0 );//That wasn’t what happened, Sarah.
	level dialog::player_say( "plyr_we_saw_the_footage_f_0", 0.0 );//We saw the footage from the Data drives. You did it. You butchered them in cold blood and made it look like a ritualistic killing...
	level dialog::player_say( "plyr_you_denied_them_thei_0", 1.0 );//You denied them their reincarnation - Just like Jae Xiong. Why?

	level.players[0] dialog::say( "hall_oh_my_god_0", 0.0 );//I can't believe it...
}

function scene_3rd_sh010_play( a_ents )
{
	exploder::exploder( "inf_bs_shot010" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh010_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot010" );
}

function scene_3rd_sh020_play( a_ents )
{
	exploder::exploder( "inf_bs_shot020" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh020_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot020" );
}

function scene_3rd_sh030_play( a_ents )
{
	exploder::exploder( "inf_bs_shot030" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh030_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot030" );
}

function scene_3rd_sh040_play( a_ents )
{
	exploder::exploder( "inf_bs_shot040" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh040_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot040" );
}

function scene_3rd_sh050_play( a_ents )
{
	exploder::exploder( "inf_bs_shot050" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh050_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot050" );
}

function scene_3rd_sh060_play( a_ents )
{
	exploder::exploder( "inf_bs_shot060" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh060_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot060" );
}

function scene_3rd_sh070_play( a_ents )
{
	exploder::exploder( "inf_bs_shot070" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh070_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot070" );
}

function scene_3rd_sh080_play( a_ents )
{
	exploder::exploder( "inf_bs_shot080" );
	
	level thread shot_fader( a_ents );
}

function scene_3rd_sh080_done( a_ents )
{
	level thread util::screen_fade_in( 0, "black" );
	
	exploder::exploder_stop( "inf_bs_shot080" );
}

function scene_3rd_sh090_play( a_ents )
{
	exploder::exploder( "inf_bs_shot090" );
}

function scene_3rd_sh090_done( a_ents )
{
	exploder::exploder_stop( "inf_bs_shot090" );
}

function scene_3rd_sh100_play( a_ents )
{
	exploder::exploder( "inf_bs_shot100" );
}

function scene_3rd_sh100_done( a_ents )
{
	
}

function scene_3rd_sh110_play( a_ents )
{
	level thread shot_fader( a_ents );
}

function scene_3rd_sh110_done( a_ents )
{
	exploder::exploder_stop( "inf_bs_shot100" );
	level notify( "cin_inf_08_blackstation_3rd_sh100_done" );
}

function shot_fader( a_ents )
{
	level waittill ( "start_blackscreen" );
	level thread util::screen_fade_out( 0, "black" );
}