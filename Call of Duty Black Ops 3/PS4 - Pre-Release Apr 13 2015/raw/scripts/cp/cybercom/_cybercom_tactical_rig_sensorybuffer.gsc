    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

#using scripts\shared\math_shared;
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_tactical_rig;


#namespace cybercom_tacrig_sensorybuffer;


function init()
{
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	cybercom_tacrig::register_cybercom_rig_ability( "cybercom_sensorybuffer", 4 );
	cybercom_tacrig::register_cybercom_rig_possession_callbacks( "cybercom_sensorybuffer", &SensoryBufferGive, &SensoryBufferTake );
	cybercom_tacrig::register_cybercom_rig_activation_callbacks( "cybercom_sensorybuffer",  &SensoryBufferActivate, &SensoryBufferDeactivate);	
}

//---------------------------------------------------------
function on_player_connect()
{
}
function on_player_spawned()
{
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Tactical RIG - Sensory Buffer
// Standard: Flinch less when hit by damage; 
// Upgraded: Take less explosive damage 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function SensoryBufferGive(type)
{
	//ui
	//vision set?
	self thread cybercom_tacrig::turn_rig_ability_on(type);//this rig is passive, just turn on by default
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function SensoryBufferTake(type)
{
	self thread cybercom_tacrig::turn_rig_ability_off(type);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function SensoryBufferActivate(type)
{
	self SetPerk("specialty_bulletflinch");
	if ( self HasCyberComRig(type) ==  2  )
	{
		self SetPerk("specialty_flakjacket");
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function SensoryBufferDeactivate(type)
{
	self UnSetPerk("specialty_bulletflinch");
	if ( self HasCyberComRig(type) ==  2  )
	{
		self UnSetPerk("specialty_flakjacket");
	}
}
