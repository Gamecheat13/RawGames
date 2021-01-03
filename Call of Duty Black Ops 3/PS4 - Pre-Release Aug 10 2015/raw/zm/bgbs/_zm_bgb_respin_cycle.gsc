#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;

          

                                                                 
                                                                                                                               

#namespace zm_bgb_respin_cycle;


function autoexec __init__sytem__() {     system::register("zm_bgb_respin_cycle",&__init__,undefined,"bgb");    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_respin_cycle", "activated", 2, undefined, undefined, &validation, &activation );

	clientfield::register( "zbarrier", ("zm_bgb_respin_cycle"), 1, 1, "counter" ); 
}


function validation()
{
	for ( i = 0; i < level.chests.size; i++ )
	{
		chest = level.chests[i];

		if ( IsDefined( chest.zbarrier.weapon_model ) && IsDefined( chest.chest_user ) && self == chest.chest_user )
		{
			return true;
		}
	}

	return false;
}


function activation()
{
	self endon( "disconnect" );

	for ( i = 0; i < level.chests.size; i++ )
	{
		chest = level.chests[i];

		if ( IsDefined( chest.zbarrier.weapon_model ) && IsDefined( chest.chest_user ) && self == chest.chest_user )
		{
			chest thread respin_chest_thread( self );
		}
	}

	self bgb::do_one_shot_use();
}


function respin_chest_thread( player )
{
	self.zbarrier clientfield::increment( ("zm_bgb_respin_cycle") );

	if ( IsDefined( self.zbarrier.weapon_model ) )
	{
		self.zbarrier.weapon_model notify( "kill_respin_think_thread" );
	}
	
	self.no_fly_away = true;
	
	self.zbarrier notify( "box_hacked_respin" );
	self.zbarrier playsound( "zmb_bgb_powerup_respin" );
	self thread zm_unitrigger::unregister_unitrigger( self.unitrigger_stub );
	zm_utility::play_sound_at_pos( "open_chest", self.zbarrier.origin );
	zm_utility::play_sound_at_pos( "music_chest", self.zbarrier.origin );
	self.zbarrier thread zm_magicbox::treasure_chest_weapon_spawn( self, player );
	self.zbarrier waittill( "randomization_done" );
	
	self.no_fly_away = undefined;
	
	if ( !level flag::get( "moving_chest_now" ) )
	{
		self.grab_weapon_hint = true;
		self.grab_weapon = self.zbarrier.weapon;
		self thread zm_unitrigger::register_static_unitrigger( self.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think );

		self thread zm_magicbox::treasure_chest_timeout();
	}
}
