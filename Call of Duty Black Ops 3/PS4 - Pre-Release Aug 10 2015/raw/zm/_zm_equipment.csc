#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                             
                                                                                                                               

#namespace zm_equipment;

function autoexec __init__sytem__() {     system::register("zm_equipment",&__init__,undefined,undefined);    }

function __init__()
{
	level._equip_activated_callbacks = [];
	
	level.buildable_piece_count = 24;
	
	if(!( isdefined( level._no_equipment_activated_clientfield ) && level._no_equipment_activated_clientfield ))
	{
		clientfield::register( "scriptmover", "equipment_activated", 1, 4, "int", &equipment_activated_clientfield_cb, true, !true );
	}
}

function add_equip_activated_callback_override(model, func)
{
	level._equip_activated_callbacks[model] = func;
}

function equipment_activated_clientfield_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(isdefined(self.model) && isdefined(level._equip_activated_callbacks[self.model]))
	{
		[[level._equip_activated_callbacks[self.model]]](localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump);
	}
	
	if(!newVal)
	{
		if(isdefined(self._equipment_activated_fx))
		{
			for(i = 0; i < self._equipment_activated_fx.size; i ++)
			{
				for(j = 0; j < self._equipment_activated_fx[i].size; j ++)
				{
					DeleteFX(i, self._equipment_activated_fx[i][j]);
				}
			}
			
			self._equipment_activated_fx = undefined;
		}
	}
}

function play_fx_for_all_clients(fx, tag, storeHandles = false, forward = undefined)
{
	numLocalPlayers = GetLocalPlayers().size;

	if(!isdefined(self._equipment_activated_fx))
	{
		self._equipment_activated_fx = [];
		
		for(i = 0; i < numLocalPlayers; i ++)
		{
			self._equipment_activated_fx[i] = [];
		}
	}

	
	if(isdefined(tag))
	{
		for(i = 0; i < numLocalPlayers; i ++)
		{
			if(storeHandles)
			{
				self._equipment_activated_fx[i][self._equipment_activated_fx[i].size] = PlayFXOnTag( i, fx, self, tag);
			}
			else
			{
				self_for_client = GetEntByNum( i, self GetEntityNumber() );
				if (IsDefined(self_for_client))
				{
					PlayFXOnTag( i, fx, self_for_client, tag);
				}
			}
		}
	}
	else
	{
		for(i = 0; i < numLocalPlayers; i ++)
		{
			if(storeHandles)
			{
				if(isdefined(forward))
				{
					self._equipment_activated_fx[i][self._equipment_activated_fx[i].size] = PlayFX( i, fx, self.origin, forward);
				}
				else
				{
					self._equipment_activated_fx[i][self._equipment_activated_fx[i].size] = PlayFX( i, fx, self.origin);
				}
			}
			else
			{			
				if(isdefined(forward))
				{
					PlayFX( i, fx, self.origin, forward);
				}
				else
				{
					PlayFX( i, fx, self.origin);
				}
			}
		}		
	}
}

function is_included( equipment )
{
	if ( !isdefined( level._included_equipment ) )
	{
		return false;
	}

	return IsDefined( level._included_equipment[equipment.rootWeapon] );
}


function include( equipment_name )
{
	if ( !isdefined( level._included_equipment ) )
	{
		level._included_equipment = [];
	}

	equipment = GetWeapon( equipment_name );
	level._included_equipment[equipment] = equipment;
}
