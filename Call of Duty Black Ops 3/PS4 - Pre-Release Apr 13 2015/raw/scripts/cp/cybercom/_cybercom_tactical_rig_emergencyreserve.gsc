    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

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






#namespace cybercom_tacrig_emergencyreserve;

function init()
{
	clientfield::register( "toplayer", "emergencyReserve", 1, 1, "int" );
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
//  Standard: Upon player death, allow player to move(stay alive) 5 seconds so that player can reach safe spot
//  Upgraded: 8 second duration
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveGive(type)
{
		//ui
		//vision set?
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveTake(type)
{
		//ui
		//vision set?
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveActivate(type)
{
	self clientfield::set_to_player( "emergencyReserve", 1 );
	//ui
	//vision set?
	
	self thread PutPlayerInEmergencyReserve(type);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function EmergencyReserveDeactivate(type)
{
	//ui
	//vision set?

	self clientfield::set_to_player( "emergencyReserve", 0 );
	self SetLowReady( false );
	self AllowJump( true );	
	self DisableInvulnerability();
	self.ignoreme = false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _EmergencyReserveReviveWatcher(type)
{
	self endon("disconnect");
	self endon("take_ability_"+type);
	self util::waittill_any("player_revived","spawned_player");
	if(( isdefined( self.cybercom.emergency_reserve ) && self.cybercom.emergency_reserve ))
	{
		self notify("killTimer");
		cybercom_tacrig::turn_rig_ability_off(type);
		self.cybercom.emergency_reserve = undefined;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function PutPlayerInEmergencyReserve(type, eAttacker, eInflictor)
{
	if( ( isdefined( self.cybercom.tacrigs_disabled ) && self.cybercom.tacrigs_disabled ))
		return;		


	self endon("disconnect");
	self endon("take_ability_"+type);
	self endon("player_revived");
	self SetLowReady( true );
	self AllowJump( false );	
	self EnableInvulnerability();
	self.cybercom.emergency_reserve = true;
	self.ignoreme = true;
	self thread _EmergencyReserveReviveWatcher(type);
	
	time = (self HasCyberComRig(type)==2?GetDvarInt( "scr_emergency_reserve_timer_upgraded" ):GetDvarInt( "scr_emergency_reserve_timer" ));
	self lui::timer( time ); 
	
	cybercom_tacrig::turn_rig_ability_off(type);
	if(isDefined(eAttacker) && isDefined(eInflictor) )
	{
		self kill(self.origin,eAttacker,eInflictor);
	}
	else
	{
		self kill(self.origin);
	}
	self.emergency_reserve = undefined;
	
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



