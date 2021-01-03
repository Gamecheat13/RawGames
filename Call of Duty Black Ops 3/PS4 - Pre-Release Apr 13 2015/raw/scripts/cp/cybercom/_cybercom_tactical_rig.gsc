    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     

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

#using scripts\cp\cybercom\_cybercom_tactical_rig_proximitydeterrent;
#using scripts\cp\cybercom\_cybercom_tactical_rig_emergencyreserve;
#using scripts\cp\cybercom\_cybercom_tactical_rig_repulsorarmor;
#using scripts\cp\cybercom\_cybercom_tactical_rig_sensorybuffer;
#using scripts\cp\cybercom\_cybercom_tactical_rig_playermovement;
#using scripts\cp\cybercom\_cybercom_tactical_rig_copycat;
#using scripts\cp\cybercom\_cybercom_tactical_rig_multicore;




#namespace cybercom_tacrig;

function init()
{
	cybercom_tacrig_sensorybuffer::init();
	cybercom_tacrig_emergencyreserve::init();
	cybercom_tacrig_proximitydeterrent::init();	
	cybercom_tacrig_respulsorarmor::init();
	cybercom_tacrig_playermovement::init();
	cybercom_tacrig_copycat::init();
	cybercom_tacrig_multicore::init();
}

function main()
{
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	cybercom_tacrig_sensorybuffer::main();
	cybercom_tacrig_emergencyreserve::main();
	cybercom_tacrig_proximitydeterrent::main();	
	cybercom_tacrig_respulsorarmor::main();
	cybercom_tacrig_playermovement::main();
	cybercom_tacrig_copycat::main();
	cybercom_tacrig_multicore::main();
}
//---------------------------------------------------------
function on_player_connect()
{	
}
function on_player_spawned()
{
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function register_cybercom_rig_ability( name, type )
{
	if(!isdefined(level._cybercom_rig_ability))level._cybercom_rig_ability=[];

	if ( !IsDefined( level._cybercom_rig_ability[ name ] ) )
	{
		level._cybercom_rig_ability[ name ] = spawnstruct();
		level._cybercom_rig_ability[ name ].name = name;
		level._cybercom_rig_ability[ name ].type = type;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function register_cybercom_rig_possession_callbacks( name, on_give, on_take )
{
	assert(isDefined(level._cybercom_rig_ability[ name ]));
	
	if(!isdefined(level._cybercom_rig_ability[ name ].on_give))level._cybercom_rig_ability[ name ].on_give=[];
	if(!isdefined(level._cybercom_rig_ability[ name ].on_take))level._cybercom_rig_ability[ name ].on_take=[];
	if ( IsDefined(on_give) )
	{
		if ( !isdefined( level._cybercom_rig_ability[ name ].on_give ) ) level._cybercom_rig_ability[ name ].on_give = []; else if ( !IsArray( level._cybercom_rig_ability[ name ].on_give ) ) level._cybercom_rig_ability[ name ].on_give = array( level._cybercom_rig_ability[ name ].on_give ); level._cybercom_rig_ability[ name ].on_give[level._cybercom_rig_ability[ name ].on_give.size]=on_give;;
	}
	if ( IsDefined(on_take) )
	{
		if ( !isdefined( level._cybercom_rig_ability[ name ].on_take ) ) level._cybercom_rig_ability[ name ].on_take = []; else if ( !IsArray( level._cybercom_rig_ability[ name ].on_take ) ) level._cybercom_rig_ability[ name ].on_take = array( level._cybercom_rig_ability[ name ].on_take ); level._cybercom_rig_ability[ name ].on_take[level._cybercom_rig_ability[ name ].on_take.size]=on_take;;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function register_cybercom_rig_activation_callbacks( name, turn_on, turn_off )
{
	assert(isDefined(level._cybercom_rig_ability[ name ]));

	if(!isdefined(level._cybercom_rig_ability[ name ].turn_on))level._cybercom_rig_ability[ name ].turn_on=[];
	if(!isdefined(level._cybercom_rig_ability[ name ].turn_off))level._cybercom_rig_ability[ name ].turn_off=[];
	if ( IsDefined(turn_on) )
	{
		if ( !isdefined( level._cybercom_rig_ability[ name ].turn_on ) ) level._cybercom_rig_ability[ name ].turn_on = []; else if ( !IsArray( level._cybercom_rig_ability[ name ].turn_on ) ) level._cybercom_rig_ability[ name ].turn_on = array( level._cybercom_rig_ability[ name ].turn_on ); level._cybercom_rig_ability[ name ].turn_on[level._cybercom_rig_ability[ name ].turn_on.size]=turn_on;;
	}
	if ( IsDefined(turn_off) )
	{
		if ( !isdefined( level._cybercom_rig_ability[ name ].turn_off ) ) level._cybercom_rig_ability[ name ].turn_off = []; else if ( !IsArray( level._cybercom_rig_ability[ name ].turn_off ) ) level._cybercom_rig_ability[ name ].turn_off = array( level._cybercom_rig_ability[ name ].turn_off ); level._cybercom_rig_ability[ name ].turn_off[level._cybercom_rig_ability[ name ].turn_off.size]=turn_off;;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function rigAbilityGiven(type,upgraded)
{
	if ( !IsDefined( level._cybercom_rig_ability[ type ] ))
		return;
		
	if ( IsDefined( level._cybercom_rig_ability[type].on_give) ) 
	{
		foreach( on_give in level._cybercom_rig_ability[ type ].on_give )
			self [[on_give]]( type );
	}	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function giveRigAbility( type, upgraded=false )
{
	if ( !IsDefined( level._cybercom_rig_ability[ type ] ))
		return false;

	self SetCybercomRig(type, upgraded );
	self cybercom::updateCybercomFlags();
	self rigAbilityGiven(type);

	return true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _take_rig_ability( type )
{
	if ( !IsDefined( level._cybercom_rig_ability[ type ] ))
		return false;
		
	if ( IsDefined( level._cybercom_rig_ability[ type ] ) && IsDefined( level._cybercom_rig_ability[type].on_take) ) 
	{
		foreach( on_take in level._cybercom_rig_ability[ type ].on_take )
			self [[on_take]]( type );
	}
	self notify ("take_ability_"+type);	
	self ClearCybercomRig(type);
	self cybercom::updateCybercomFlags();
	return true;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function takeAllRigAbilities()
{
	foreach (ability in level._cybercom_rig_ability)
	{
		if ( self HasCyberComRig(ability.name) != 0 )
			_take_rig_ability(ability.name);
	}
	self cybercom::updateCybercomFlags();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function giveAllRigAbilities()
{
	foreach (ability in level._cybercom_rig_ability)
	{
		status = self HasCyberComRig(ability.name);
		if ( status != 0 )
			self giveRigAbility(ability.name, (status==2) );
	}
	self cybercom::updateCybercomFlags();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function turn_rig_ability_on( type )
{	    
	if (( isdefined( level._cybercom_rig_ability[ type ].activated ) && level._cybercom_rig_ability[ type ].activated ))
		return;
	reserveAbility = self HasCyberComRig(type);
	if ( reserveAbility == 0 )
		return;
		
	level._cybercom_rig_ability[ type ].activated = true;
		
	
	if ( IsDefined( level._cybercom_rig_ability[ type] ) && IsDefined( level._cybercom_rig_ability[ type ].turn_on )  )
	{
		foreach( turn_on in level._cybercom_rig_ability[ type ].turn_on )
			self [[turn_on]]( type );
	}
	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function turn_rig_ability_off( type )
{	
	if (!( isdefined( level._cybercom_rig_ability[ type ].activated ) && level._cybercom_rig_ability[ type ].activated ))
		return;
	level._cybercom_rig_ability[ type ].activated = undefined;
		
	reserveAbility = self HasCyberComRig(type);
	if ( reserveAbility == 0 )
		return;
	
	if ( IsDefined( level._cybercom_rig_ability[ type] ) && IsDefined( level._cybercom_rig_ability[ type ].turn_off )  )
	{
		foreach( turn_off in level._cybercom_rig_ability[ type ].turn_off )
			self [[turn_off]]( type );
	}
}