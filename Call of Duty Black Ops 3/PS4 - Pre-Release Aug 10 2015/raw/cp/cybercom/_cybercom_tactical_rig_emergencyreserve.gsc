    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#using scripts\shared\math_shared;
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_tactical_rig_proximitydeterrent;






#namespace cybercom_tacrig_emergencyreserve;

function init()
{
	
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	SetDvar( "scr_emergency_reserve_timer",5 );
	SetDvar( "scr_emergency_reserve_timer_upgraded",8 );
	
	cybercom_tacrig::register_cybercom_rig_ability( "cybercom_emergencyreserve", 3 );
	cybercom_tacrig::register_cybercom_rig_possession_callbacks( "cybercom_emergencyreserve", &EmergencyReserveGive, &EmergencyReserveTake );
	cybercom_tacrig::register_cybercom_rig_activation_callbacks( "cybercom_emergencyreserve",  &EmergencyReserveActivate, &EmergencyReserveDeactivate);	
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
//  Tactical RIG - Emergency Reserve
//  
//  
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveGive(type)
{
	self.lives=1;	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveTake(type)
{
	self.lives=0;	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveActivate(type)
{
	if(level.players.size>1)
		self.lives=1;	
	
	if( self HasCyberComRig("cybercom_emergencyreserve")  == 2 )
	{
		level thread cybercom_tacrig_proximitydeterrent::radialProxyDischarge(self);
	}

	self cybercom_tacrig::turn_rig_ability_off("cybercom_emergencyreserve");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveDeactivate(type)
{
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ValidDeathTypesForEmergencyReserve(sMeansOfDeath)
{
	return (isSubStr(sMeansOfDeath,"_BULLET") 	||
			isSubStr(sMeansOfDeath,"_GRENADE") 	||			
			isSubStr(sMeansOfDeath,"_MELEE") 	||			
			sMeansOfDeath == "MOD_EXPLOSIVE" 	||
			sMeansOfDeath == "MOD_SUICIDE" 		||
			sMeansOfDeath == "MOD_HEAD_SHOT" );
}



