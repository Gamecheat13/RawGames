#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_audio_announcer;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

                                                                
                                                                                                                               

#precache( "material", "specialty_firesale_zombies");
#precache( "string", "ZOMBIE_POWERUP_MAX_AMMO" );

#namespace zm_powerup_fire_sale;

function autoexec __init__sytem__() {     system::register("zm_powerup_fire_sale",&__init__,undefined,undefined);    }


//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "fire_sale", &grab_fire_sale );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "fire_sale", "p7_zm_power_up_firesale", &"ZOMBIE_POWERUP_MAX_AMMO", &func_should_drop_fire_sale, !true, !true, !true, undefined, "powerup_fire_sale", "zombie_powerup_fire_sale_time", "zombie_powerup_fire_sale_on" );
	}
}

function grab_fire_sale( player )
{	
	level thread start_fire_sale( self );
	player thread zm_powerups::powerup_vo("firesale");
}


function start_fire_sale( item )
{
	if(level.zombie_vars["zombie_powerup_fire_sale_time"] > 0 && ( isdefined( level.zombie_vars["zombie_powerup_fire_sale_on"] ) && level.zombie_vars["zombie_powerup_fire_sale_on"] ) ) // firesale already going when a new one is picked up ..just add time
	{
		level.zombie_vars["zombie_powerup_fire_sale_time"] += 30;
		return;
	}

	level notify ("powerup fire sale");
	level endon ("powerup fire sale");
	
	level thread zm_audio::sndAnnouncerPlayVox("fire_sale");
    
	level.zombie_vars["zombie_powerup_fire_sale_on"] = true;
	level thread toggle_fire_sale_on();
	level.zombie_vars["zombie_powerup_fire_sale_time"] = 30;

	while ( level.zombie_vars["zombie_powerup_fire_sale_time"] > 0)
	{
		{wait(.05);};
		level.zombie_vars["zombie_powerup_fire_sale_time"] = level.zombie_vars["zombie_powerup_fire_sale_time"] - 0.05;
	}

	level.zombie_vars["zombie_powerup_fire_sale_on"] = false;
	level notify ( "fire_sale_off" );	
}

function toggle_fire_sale_on()
{
	level endon ("powerup fire sale");

	if( !isdefined ( level.zombie_vars["zombie_powerup_fire_sale_on"] ) )
	{
		return;
	}

	if( level.zombie_vars["zombie_powerup_fire_sale_on"] )
	{
		level thread sndFiresaleMusic_Start();
		
		for( i = 0; i < level.chests.size; i++ )
		{
			show_firesale_box = level.chests[i] [[level._zombiemode_check_firesale_loc_valid_func]]();
			
			if(show_firesale_box)
			{
				level.chests[i].zombie_cost = 10;

				if( level.chest_index != i )
				{
					level.chests[i].was_temp = true;
					if( ( isdefined( level.chests[i].hidden ) && level.chests[i].hidden ) )
					{
						level.chests[i] thread zm_magicbox::show_chest();
					}

					util::wait_network_frame();
				}
			}
		}
		
		level waittill( "fire_sale_off" );
		
		//allow other level logic to handle notify before removing the .was_temp value on chests
		waittillframeend;

		level thread sndFiresaleMusic_Stop();
		
		for( i = 0; i < level.chests.size; i++ )
		{
			show_firesale_box = level.chests[i] [[level._zombiemode_check_firesale_loc_valid_func]]();

			if(show_firesale_box)
			{
				if( level.chest_index != i && IsDefined(level.chests[i].was_temp))
				{
					level.chests[i].was_temp = undefined;
					level thread remove_temp_chest( i );
				}
				
				level.chests[i].zombie_cost = level.chests[i].old_cost;
			}
		}
	}
}

//	Bring the chests back to normal.
function remove_temp_chest( chest_index )
{
	while( isdefined( level.chests[chest_index].chest_user ) || (IsDefined(level.chests[chest_index]._box_open) && level.chests[chest_index]._box_open == true))
	{
		util::wait_network_frame();
	}
	
	if ( level.zombie_vars["zombie_powerup_fire_sale_on"] ) // Grabbed a second FireSale while temp box was open and original FireSale ended
	{
		level.chests[chest_index].was_temp = true;
		level.chests[chest_index].zombie_cost = 10;
		return;
	}
	
	for( i=0; i<chest_index; i++ )
	{
		util::wait_network_frame();
	}
	
	playfx(level._effect["poltergeist"], level.chests[chest_index].orig_origin);
	level.chests[chest_index].zbarrier playsound ( "zmb_box_poof_land" );
	level.chests[chest_index].zbarrier playsound( "zmb_couch_slam" );
	util::wait_network_frame();
	
	level.chests[chest_index] zm_magicbox::hide_chest();
}

function func_should_drop_fire_sale()
{
	if( level.zombie_vars["zombie_powerup_fire_sale_on"] == true || level.chest_moves < 1 || ( isdefined( level.disable_firesale_drop ) && level.disable_firesale_drop ))
	{
		return false;
	}
	return true;
}

function sndFiresaleMusic_Start()
{
	array = level.chests;
	
	foreach(struct in array)
	{
		if( !isdefined( struct.sndEnt ) )
		{
			struct.sndEnt = spawn( "script_origin", struct.origin+(0,0,100));
		}
		
		struct.sndEnt playloopsound( "mus_fire_sale", 1 );
	}
}
function sndFiresaleMusic_Stop()
{
	array = level.chests;
	
	foreach(struct in array)
	{
		if( isdefined( struct.sndEnt ) )
		{
			struct.sndEnt delete();
			struct.sndEnt = undefined;
		}
	}
}