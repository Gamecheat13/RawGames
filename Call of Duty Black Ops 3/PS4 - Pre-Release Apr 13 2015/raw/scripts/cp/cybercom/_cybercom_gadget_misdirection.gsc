#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                     
#using scripts\shared\system_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\lui_shared;
#using scripts\cp\_util;

                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;








#namespace cybercom_gadget_misdirection;

function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2,	(1<<5));
	
	level.cybercom.misdirection = spawnstruct();
	level.cybercom.misdirection._is_flickering  = &_is_flickering;
	level.cybercom.misdirection._on_flicker 	= &_on_flicker;
	level.cybercom.misdirection._on_give 		= &_on_give;
	level.cybercom.misdirection._on_take 		= &_on_take;
	level.cybercom.misdirection._on_connect 	= &_on_connect;
	level.cybercom.misdirection._on 			= &_on;
	level.cybercom.misdirection._off 			= &_off;
	level.cybercom.misdirection._is_primed 		= &_is_primed;
}


function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	self.cybercom.weapon 					= weapon;
	self.cybercom.misdirection_lifetime 	= GetDvarInt( "scr_misdirection_lifetime", 20 )*1000;
	self.cybercom.misdirection_range 		= GetDvarInt( "scr_misdirection_max_distance", 1024 );
	if(self hasCyberComAbility("cybercom_misdirection")  == 2)
	{
		self.cybercom.misdirection_lifetime = GetDvarInt( "scr_misdirection_upgraded_lifetime", 30 )*1000;
		self.cybercom.misdirection_range 	= GetDvarInt( "scr_misdirection_max_distance", 1500 );
	}
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;	
}

function _on_take( slot, weapon )
{
	self _off(slot, weapon);
	self.cybercom.weapon	= undefined;
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	self thread _activate_misdirection( weapon );
	self _off(slot, weapon);
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
	self.cybercom.is_primed = undefined;
}

function _is_primed( slot, weapon )
{
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		self.cybercom.is_primed = true;
		self thread _create_range_target();
	}
}

function private _create_range_target()
{
	self.cybercom.rangeTarget = Spawn( "script_model", self.origin );
	self.cybercom.rangeTarget SetModel( "tag_origin" );

	self cybercom::weapon_lock_ClearSlots();
	self cybercom::weapon_lock_SetTargetToSlot(0,self.cybercom.rangeTarget);
	
	while(( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		// Trace to where the player is looking
		direction_vec 	= AnglesToForward( self GetPlayerAngles() );
		eye 		  	= self GetEye();
		trace 			= BulletTrace( eye, eye + VectorScale( direction_vec, self.cybercom.misdirection_range ), true, self );

		//find ground
		start = trace["position"] - (24*direction_vec);//move a little away from collide point
		end   = start - (0,0,99999);
		trace = BulletTrace( start, end, true, self );
			
		//traceNormal 	=  trace["normal"];
		//traceDist = int( Distance( eye, tracePoint ) );  // just need an int, thanks
		self.cybercom.rangeTarget.origin = trace["position"];
		{wait(.05);};
	}

	if(isDefined(self.cybercom.rangeTarget))
	{
		self cybercom::weapon_lock_ClearSlots();
		self.cybercom.rangeTarget delete();
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree ("generic_human");

function private _activate_misdirection( weapon )
{
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");

	misDirectionObject = Spawn( "script_model", self.cybercom.rangeTarget.origin );
	misDirectionObject SetModel( "cybercom_misdirection_hologram" );
	self.cybercom.is_primed = undefined;
	misDirectionObject MakeSentient();
	misDirectionObject.team = self.team;
	misDirectionObject.health = 100;
	//misDirectionObject SetThreatBiasGroup(misDirectionObject.team);
	level notify("cybercom_decoy_released",misDirectionObject);

	
	misDirectionObject UseAnimTree( #animtree );
	expireTime = GetTime() + self.cybercom.misdirection_lifetime;
	while(GetTime()<expireTime)
	{
		misDirectionObject AnimScripted( "loop_anim", misDirectionObject.origin, misDirectionObject.angles, "ai_base_rifle_stn_pillar_idle" );		
		misDirectionObject waittillmatch( "loop_anim", "end" );
	}
	misDirectionObject delete();
}
