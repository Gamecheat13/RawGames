#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace fx;
	
function autoexec __init__sytem__() {     system::register("fx",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_localclient_connect( &player_init );
}

function player_init(clientNum)
{		
	if(!isdefined(level.createFXent))
		return;

	creatingExploderArray = false;

	if(!isdefined(level.createFXexploders))
	{
		creatingExploderArray = true;
		
		level.createFXexploders = [];
	}		

	for ( i=0; i<level.createFXent.size; i++ )
	{
		ent = level.createFXent[i];
		
		// This code my be executed for multiple local clients - only set the
		// axis up once.
		if(!isdefined(level._createfxforwardandupset))
		{
			// This code my be executed for multiple local clients - only set the
			// axis up once.
			if(!isdefined(level._createfxforwardandupset))
			{
				ent set_forward_and_up_vectors();
			}
		}

		if (ent.v["type"] == "loopfx")
		{
			ent thread loop_thread(clientNum);
		}
		if (ent.v["type"] == "oneshotfx")
		{
			ent thread oneshot_thread(clientNum);
		}
		if (ent.v["type"] == "soundfx")
		{
			ent thread loop_sound(clientNum);
		}
		
		if(creatingExploderArray && ent.v["type"] == "exploder")
		{
			if(!isdefined(level.createFXexploders[ent.v["exploder"]]))
			{
				level.createFXexploders[ent.v["exploder"]] = [];
			}
			
			ent.v["exploder_id"] = exploder::getExploderId( ent );
			
			level.createFXexploders[ent.v["exploder"]][level.createFXexploders[ent.v["exploder"]].size] = ent;
		}
	}
	
	level._createfxforwardandupset = true;	
}

function validate( fxId, origin )
{
/#
	if ( !isdefined( level._effect[fxId] ) )
	{
		assertmsg( "FX Not Precached: '" + fxId + "' at: " + origin );
	}
#/
}

function create_loop_sound()
{
	ent = spawnStruct();
	if (!isdefined(level.createFXent))
		level.createFXent = [];
	
	level.createFXent[level.createFXent.size] = ent;
	ent.v = [];
	ent.v["type"] = "soundfx";
	ent.v["fxid"] = "No FX";
	ent.v["soundalias"] = "nil";
	ent.v["angles"] = (0,0,0);
	ent.v["origin"] = (0,0,0);
	ent.drawn = true;
	return ent;
}

function create_effect( type, fxid )
{
	ent = spawnStruct();
	if (!isdefined(level.createFXent))
		level.createFXent = [];
	
	level.createFXent[level.createFXent.size] = ent;
	ent.v = [];
	ent.v["type"] = type;
	ent.v["fxid"] = fxid;
	ent.v["angles"] = (0,0,0);
	ent.v["origin"] = (0,0,0);
	ent.drawn = true;
	return ent;
}

function create_oneshot_effect( fxid )
{
	ent = create_effect( "oneshotfx", fxid ); 
	ent.v[ "delay" ] = -15;
	return ent; 
}

function create_loop_effect( fxid )
{
	ent = create_effect( "loopfx", fxid ); 
	ent.v[ "delay" ] = 0.5;
	return ent; 
}

function set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}

function oneshot_thread(clientNum)
{
	// This assumes that client scripts start at beginning of level - will need to take
	// hot join into account (and possibly restart from checkpoint...)

	if ( self.v["delay"] > 0 )
	{	
	    waitrealtime(self.v["delay"]);
	}
	  
	fx::create_trigger(clientNum);
}

function report_num_effects()
{
/#
	//if(isdefined(level.createFXent))
	//{
	//	println("*** ClientScripts : Added " + level.createFXent.size + " effects.");
	//}
	//else
	//{
	//	println("*** ClientScripts : Added no effects.");
	//}
#/	
}

function loop_sound(clientNum)
{	
	if(clientNum != 0)
		return;
		
	self notify( "stop_loop" );
	
	// Note : 
	// Unlike the server side implementation of this - self.looper will contain an fx id, and not an entity
	// so no threading things on it.
	
	if ( isdefined( self.v["soundalias"] ) && ( self.v["soundalias"] != "nil" ) )
	{
		if ( isdefined( self.v[ "stopable" ] ) && self.v[ "stopable" ] )
		{
			thread sound::loop_fx_sound( clientNum, self.v["soundalias"], self.v["origin"], "stop_loop" );
		}
		else
		{
			thread sound::loop_fx_sound( clientNum, self.v["soundalias"], self.v["origin"] );
		}
	}

}

function lightning(normalFunc, flashFunc)
{
	[[flashFunc]]();
	
	// SRS 5/28/2008: updated to include a call back to the normal function
	waitrealtime(RandomFloatRange( 0.05, 0.1 ));
	[[normalFunc]]();	
}

function loop_thread(clientNum)
{
	if (isdefined (self.fxStart))
		level waittill ("start fx" + self.fxStart);

	while (1)
	{
		create_looper(clientNum);
		
		if (isdefined (self.timeout))
			thread loop_stop(clientNum, self.timeout);
			
		if (isdefined (self.fxStop))
			level waittill ("stop fx" + self.fxStop);
		else
			return;

		if (isdefined (self.looperFX))
			deletefx(clientNum, self.looperFX);

		if (isdefined (self.fxStart))
			level waittill ("start fx" + self.fxStart);
		else
			return;
	}
}

function loop_stop(clientNum, timeout)
{
	self endon("death");
	wait(timeout);
	
	if(isdefined(self.looper))
	{
		deletefx(clientNum, self.looper);
	}	

	if(isdefined(self.loopFX))
	{
		deletefakeent(clientNum, self.loopFX); 
	}
}

//T7 - SP version, check differences to make sure we have the proper checks
/*function loop_stop(clientNum, timeout)
{
	self endon("death");
	waitrealtime(timeout);
	
	if(isdefined(self.looper))
		self.looper delete();	

	if(isdefined(self.looperFX))
		DeleteFx(clientNum, self.looperFX); 
}*/

function create_looper(clientNum)
{
	//assert (isdefined(self.looper));
	//self.looperFX = spawnfakeent(clientNum);
	//playLoopedFx( clientNum, self.looperFX, level._effect[self.v["fxid"]], self.v["delay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);
	self thread fx::loop(clientNum);
	loop_sound(clientNum);
}

function loop(clientNum)
{		
	validate( self.v["fxid"], self.v["origin"] );

	self.looperFX = PlayFX( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"], self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	
	while( 1 )
	{
		if( isdefined(self.v["delay"]) )
		{
			waitrealtime( self.v["delay"] );//TODO T7 - MP version used serverwait, which is better?
			// Server wait is linked to the server time, this make it work with demos and killcams when the time gets slowed so does this
		}
			
		while( isfxplaying( clientNum, self.looperFX ) )
		{
			wait 0.25;//T7 - was 0.1 in SP
		}
			
		self.looperFX = PlayFX( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], 0, self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	}
}

function create_trigger(clientNum)
{
	validate( self.v["fxid"], self.v["origin"] );

	/#
	if( GetDvarint( "debug_fx" ) > 0 )
	{
		println("self.v['fxid'] " + self.v["fxid"]);
	}
	#/

	self.looperFX = PlayFX( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"], self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	
	loop_sound(clientNum);
}

function blinky_light( localClientNum, tagName, friendlyfx, enemyfx ) // self == equipment
{
	self endon( "entityshutdown" );
	self endon( "stop_blinky_light" );

	self.lightTagName = tagName;

	self util::waittill_dobj(localClientNum);
	
	self thread blinky_emp_wait(localClientNum);

	while( true )
	{
		if( isdefined( self.stunned ) && self.stunned )
		{
			wait( 0.1 );
			continue;
		}

		if ( isdefined( self ) )
		{
			if ( util::friend_not_foe(localClientNum) )
			{
				self.blinkyLightFx = PlayFXOnTag( localClientNum, friendlyfx, self, self.lightTagName );
			}
			else
			{
				self.blinkyLightFx = PlayFXOnTag( localClientNum, enemyfx, self, self.lightTagName );
			}
		}

		util::server_wait( localClientNum, 0.5, 0.01 );
	}
}

function stop_blinky_light(localClientNum)
{
	self notify( "stop_blinky_light" );
	
	if ( !isdefined( self.blinkyLightFx ) )
	{
		return;
	}
		
	stopfx(localClientNum, self.blinkyLightFx);
	self.blinkyLightFx = undefined;
}

function blinky_emp_wait(localClientNum)
{
	self endon( "entityshutdown" );
	self endon( "stop_blinky_light" );
	
	self waittill( "emp" );
	
	self stop_blinky_light( localClientNum );
}
