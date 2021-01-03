    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               


                  

#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;


#precache( "client_fx", "weapon/fx_ability_firefly_attack");
#precache( "client_fx", "weapon/fx_ability_firefly_attack_damage");
#precache( "client_fx", "weapon/fx_ability_firefly_hunting");
#precache( "client_fx", "weapon/fx_ability_firefly_swarm_die");
#precache( "client_fx", "weapon/fx_ability_firefly_travel");

#precache( "client_fx", "weapon/fx_ability_firebug_attack");
#precache( "client_fx", "weapon/fx_ability_firebug_attack_damage");
#precache( "client_fx", "weapon/fx_ability_firebug_hunting");
#precache( "client_fx", "weapon/fx_ability_firebug_swarm_die");
#precache( "client_fx", "weapon/fx_ability_firebug_travel");


#namespace cybercom_firefly;


function init()
{
	init_clientfields();

	level._effect["swarm_attack"]				= "weapon/fx_ability_firefly_attack";
	level._effect["swarm_attack_dmg"]			= "weapon/fx_ability_firefly_attack_damage";
	level._effect["swarm_hunt"]					= "weapon/fx_ability_firefly_hunting";
	level._effect["swarm_hunt_trans_to_move"] 	= "weapon/fx_ability_firefly_travel";
	level._effect["swarm_die"]					= "weapon/fx_ability_firefly_swarm_die";
	level._effect["swarm_move"]					= "weapon/fx_ability_firefly_travel";

	level._effect["upgraded_swarm_attack"]				= "weapon/fx_ability_firebug_attack";
	level._effect["upgraded_swarm_attack_dmg"]			= "weapon/fx_ability_firebug_attack_damage";
	level._effect["upgraded_swarm_hunt"]				= "weapon/fx_ability_firebug_hunting";
	level._effect["upgraded_swarm_hunt_trans_to_move"] 	= "weapon/fx_ability_firebug_travel";
	level._effect["upgraded_swarm_die"]					= "weapon/fx_ability_firebug_swarm_die";
	level._effect["upgraded_swarm_move"]				= "weapon/fx_ability_firebug_travel";
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "vehicle", "firefly_state", 1, 4, "int", &firefly_state, !true, !true );
	clientfield::register( "actor", "firefly_state", 1, 4, "int", &actor_firefly_state, !true, !true );
}

//---------------------------------------------------------

function firefly_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if (newVal == 0 || newVal == oldVal )
		return;
		
	if(isDefined(self.fx))
	{
		StopFx(localClientNum,self.fx);
		self.fx = undefined;
	}
	switch(newVal)
	{
		case 1:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["swarm_hunt"], self ,"tag_origin");
		break;
		case 2:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["swarm_hunt_trans_to_move"], self ,"tag_origin");
		break;
		case 3:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["swarm_move"], self ,"tag_origin");
		break;
		case 5:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["swarm_die"], self ,"tag_origin");
		break;
		case 6:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["upgraded_swarm_hunt"], self ,"tag_origin");
		break;
		case 7:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["upgraded_swarm_hunt_trans_to_move"], self ,"tag_origin");
		break;
		case 8:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["upgraded_swarm_move"], self ,"tag_origin");
		break;
		case 10:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["upgraded_swarm_die"], self ,"tag_origin");
		break;
	}
	
	self.currentState = newVal;
}


function actor_firefly_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if (newVal == 0 || newVal == oldVal )
		return;
		
	if(isDefined(self.fx))
	{
		StopFx(localClientNum,self.fx);
		self.fx = undefined;
	}
	switch(newVal)
	{
		case 4:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["swarm_attack_dmg"], self,"j_neck");
		break;
		case 9:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["upgraded_swarm_attack_dmg"], self,"j_neck");
		break;
		case 5:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["swarm_die"], self,"j_neck");
		break;
		case 10:
			self.fx = PlayFxOnTag(	localClientNum, level._effect["upgraded_swarm_die"], self,"j_neck");
		break;
		default:
		break;
	}
	
	self.currentState = newVal;
}
