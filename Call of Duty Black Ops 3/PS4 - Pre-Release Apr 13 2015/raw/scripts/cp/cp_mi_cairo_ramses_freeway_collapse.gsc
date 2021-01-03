#using scripts\codescripts\struct;

//shareds
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\codescripts\struct;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_vehicle;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\vehicles\_raps;

#using scripts\shared\exploder_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses3_fx;
#using scripts\cp\cp_mi_cairo_ramses3_sound;
#using scripts\cp\cp_mi_cairo_ramses_dead_event;

#namespace freeway_collapse;

function freeway_collapse_main()
{
	precache();

	level thread freeway_collapse();
}

function precache()
{
	// DO ALL PRECACHING HERE
}

//self == level - rumbles, screenshakes and flagsets
function freeway_notetrack( str_notetrack )
{
	self waittill( str_notetrack );
	
	//rumble and screenshake on players 
	foreach( e_player in level.players )
	{
		//earthquale and rumble
		e_player PlayRumbleOnEntity( "tank_damage_heavy_mp" );
		Earthquake( 0.65, 0.7, e_player.origin, 128.0 );
	}
}

function freeway_collapse()
{
	level scene::init( "p7_fxanim_cp_ramses_freeway_collapse_bundle" ); // Spawn 
	
	//rumble notetracks on freeway collapse
	level thread freeway_notetrack( "freeway_rumble_1" );
	level thread freeway_notetrack( "freeway_rumble_2" );
	level thread freeway_notetrack( "freeway_rumble_3" );
		
	trigger::wait_till( "trig_start_freeway_collapse" );
	
	level thread cp_mi_cairo_ramses_dead_event::initial_reinforcements();
	level thread scene::play( "p7_fxanim_cp_ramses_freeway_collapse_bundle" );
	
	str_freeway_exploder = "fx_exploder_freeway_collapse_";
	n_exploder = 1;
	
	e_sound_ent = GetEnt( "freeway_sound_ent", "targetname" );
	
	while ( 1 )
	{
		exploder::exploder( str_freeway_exploder + n_exploder );
		e_sound_ent playsound ("evt_freeway_explos");
		n_exploder++;		
		
		if ( isdefined( e_sound_ent.target ) )
		{
			e_sound_ent = GetEnt( e_sound_ent.target, "targetname" );
	    }
	
		if ( n_exploder == 6 )
		{
			break;	
		}
		
		wait 1;	
	}
	
	skipto::objective_completed( "freeway_collapse" );
}

