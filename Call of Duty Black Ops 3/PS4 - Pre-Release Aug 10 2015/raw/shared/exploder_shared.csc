#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace exploder;

function autoexec __init__sytem__() {     system::register("exploder",&__init__,undefined,undefined);    }

function __init__()
{
	if( SessionModeIsCampaignGame() )
	{
		callback::on_localclient_connect( &player_init );
	}
}

function player_init( clientnum )
{
	//println("*** Init exploders...");	
	script_exploders = []; 

	ents = struct::get_array( "script_brushmodel", "classname" );
	//println("Client : s_bm " + ents.size);
	
	smodels = struct::get_array( "script_model", "classname" ); 
	//println("Client : sm " + smodels.size);

	for( i = 0; i < smodels.size; i++ )
	{
		ents[ents.size] = smodels[i]; 
	}

	for( i = 0; i < ents.size; i++ )
	{
		if( isdefined( ents[i].script_prefab_exploder ) )
		{
			ents[i].script_exploder = ents[i].script_prefab_exploder; 
		}
	}

	potentialExploders = struct::get_array( "script_brushmodel", "classname" ); 
	//println("Client : Potential exploders from script_brushmodel " + potentialExploders.size);
	
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( isdefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder; 
		}
			
		if( isdefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i]; 
		}
	}

	potentialExploders = struct::get_array( "script_model", "classname" ); 
	//println("Client : Potential exploders from script_model " + potentialExploders.size);
	
	for( i = 0; i < potentialExploders.size; i++ )
	{
		if( isdefined( potentialExploders[i].script_prefab_exploder ) )
		{
			potentialExploders[i].script_exploder = potentialExploders[i].script_prefab_exploder; 
		}

		if( isdefined( potentialExploders[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = potentialExploders[i]; 
		}
	}

	// Also support script_structs to work as exploders
	for( i = 0; i < level.struct.size; i++ )
	{
		if( isdefined( level.struct[i].script_prefab_exploder ) )
		{
			level.struct[i].script_exploder = level.struct[i].script_prefab_exploder; 
		}

		if( isdefined( level.struct[i].script_exploder ) )
		{
			script_exploders[script_exploders.size] = level.struct[i]; 
		}
	}

	if( !isdefined( level.createFXent ) )
	{
		level.createFXent = []; 
	}
	
	acceptableTargetnames = []; 
	acceptableTargetnames["exploderchunk visible"] = true; 
	acceptableTargetnames["exploderchunk"] = true; 
	acceptableTargetnames["exploder"] = true; 
	
	exploder_id = 1;
	
	for( i = 0; i < script_exploders.size; i++ )
	{
		exploder = script_exploders[i]; 
		ent = createExploder( exploder.script_fxid ); 
		ent.v = []; 
		
		//if(!isdefined(exploder.origin))
		//{
		//	println("************** NO EXPLODER ORIGIN." + i);
		//}
		
		ent.v["origin"] = exploder.origin; 
		ent.v["angles"] = exploder.angles; 
		ent.v["delay"] = exploder.script_delay; 
		ent.v["firefx"] = exploder.script_firefx; 
		ent.v["firefxdelay"] = exploder.script_firefxdelay; 
		ent.v["firefxsound"] = exploder.script_firefxsound; 
		ent.v["firefxtimeout"] = exploder.script_firefxtimeout; 
		ent.v["trailfx"] = exploder.script_trailfx; 
		ent.v["trailfxtag"] = exploder.script_trailfxtag; 
		ent.v["trailfxdelay"] = exploder.script_trailfxdelay; 
		ent.v["trailfxsound"] = exploder.script_trailfxsound; 
		ent.v["trailfxtimeout"] = exploder.script_firefxtimeout; 
		ent.v["earthquake"] = exploder.script_earthquake; 
		ent.v["rumble"] = exploder.script_rumble; 
		ent.v["damage"] = exploder.script_damage; 
		ent.v["damage_radius"] = exploder.script_radius; 
		ent.v["repeat"] = exploder.script_repeat; 
		ent.v["delay_min"] = exploder.script_delay_min; 
		ent.v["delay_max"] = exploder.script_delay_max; 
		ent.v["target"] = exploder.target; 
		ent.v["ender"] = exploder.script_ender; 
		ent.v["physics"] = exploder.script_physics; 
		ent.v["type"] = "exploder"; 
//		ent.v["worldfx"] = true; 

		if( !isdefined( exploder.script_fxid ) )
		{
			ent.v["fxid"] = "No FX"; 
		}
		else
		{
			ent.v["fxid"] = exploder.script_fxid; 
		}
		ent.v["exploder"] = exploder.script_exploder; 
	//	assert( isdefined( exploder.script_exploder ), "Exploder at origin " + exploder.origin + " has no script_exploder" ); 

		if( !isdefined( ent.v["delay"] ) )
		{
			ent.v["delay"] = 0; 
		}

		// MikeD( 4/14/2008 ): Attempt to use the fxid as the sound reference, this way Sound can add sounds to anything
		// without the scripter needing to modify the map
		if( isdefined( exploder.script_sound ) )
		{
			ent.v["soundalias"] = exploder.script_sound; 
		}
		else if( ent.v["fxid"] != "No FX"  )
		{
			if( isdefined( level.scr_sound ) && isdefined( level.scr_sound[ent.v["fxid"]] ) )
			{
				ent.v["soundalias"] = level.scr_sound[ent.v["fxid"]]; 
			}
		}		

		fixup_set = false;

		if(isdefined(ent.v["target"]))
		{					
			ent.needs_fixup = exploder_id;
			exploder_id++;
			fixup_set = true;
			
/*			temp_ent = GetEnt(0, ent.v["target"], "targetname" ); 
 * if( isdefined( temp_ent ) )
			{
				org = temp_ent.origin; 
			}
			else */
			{
				temp_ent = struct::get( ent.v["target"], "targetname" );
				if (isdefined(temp_ent) )
				{
					org = temp_ent.origin; 
				}
			}

			if(isdefined(org))
			{
				ent.v["angles"] = VectorToAngles( org - ent.v["origin"] ); 	
			}
			//else		
			//{
					//println("*** Client : Exploder " + exploder.script_fxid + " Failed to find target ");
			//}
			
			if(isdefined(ent.v["angles"]))
			{
				ent fx::set_forward_and_up_vectors();
			}
			//else
			//{
				//println("*** Client " + exploder.script_fxid + " has no angles.");
			//}

		}
		
		
		// this basically determines if its a brush/model exploder or not
		if( (isdefined(exploder.classname) && exploder.classname == "script_brushmodel") || isdefined( exploder.model ) )
		{
			//if(isdefined(exploder.model))
			//{
				//println("*** exploder " + exploder_id + " model " + exploder.model);
			//}
			ent.model = exploder; 
			//ent.model.disconnect_paths = exploder.script_disconnectpaths; 
			if(fixup_set == false)
			{
				ent.needs_fixup = exploder_id;
				exploder_id++;
			}
		}
		
		if( isdefined( exploder.targetname ) && isdefined( acceptableTargetnames[exploder.targetname] ) )
		{
			ent.v["exploder_type"] = exploder.targetname; 
		}
		else
		{
			ent.v["exploder_type"] = "normal"; 
		}		
	}

	level.createFXexploders = [];

	for(i = 0; i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[i];
		
		if(ent.v["type"] != "exploder")
			continue;
			
		ent.v["exploder_id"] = exploder::getexploderid( ent );
		
		if(!isdefined(level.createFXexploders[ent.v["exploder"]]))
		{
			level.createFXexploders[ent.v["exploder"]] = [];
		}
		
		level.createFXexploders[ent.v["exploder"]][level.createFXexploders[ent.v["exploder"]].size] = ent;
		
	}
	
	reportexploderids();
	
	
//	println("*** Client : " + script_exploders.size + " exploders.");	
}

function getExploderId( ent )
{
	if(!isdefined(level._exploder_ids))
	{
		level._exploder_ids = [];
		level._exploder_id = 1;
	}

	if(!isdefined(level._exploder_ids[ent.v["exploder"]]))
	{
		level._exploder_ids[ent.v["exploder"]] = level._exploder_id;
		level._exploder_id ++;
	}

	return level._exploder_ids[ent.v["exploder"]];
}

function reportExploderIds()
{
	if(!isdefined(level._exploder_ids))
		return;
		
	keys = GetArrayKeys( level._exploder_ids ); 

	//println("Client Exploder dictionary : ");
	//for( i = 0; i < keys.size; i++ )
	//{
	//	println(keys[i] + " : " + level._exploder_ids[keys[i]]);
	//}
}

function exploder( exploder_id )
{
	if( IsInt( exploder_id ) )
	{
		activate_exploder( exploder_id );
	}
	else//This is a radiant exploder
	{
		activate_radiant_exploder( exploder_id );
	}	
}

function activate_exploder( num )
{
	num = int( num ); 
	
	if(isdefined(level.createFXexploders) && isdefined(level.createFXexploders[num]))	
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			level.createFXexploders[num][i] activate_individual_exploder();
		}
	}
	
	if(exploder_is_lightning_exploder(num))
	{
		if(isdefined(level.lightningNormalFunc) && isdefined(level.lightningFlashFunc))
		{
			thread fx::lightning(level.lightningNormalFunc, level.lightningFlashFunc);
		}
	}
	
}

function activate_individual_exploder()
{
	if(!isdefined(self.v["angles"]))
	{
		self.v["angles"] = (0,0,0);
		self fx::set_forward_and_up_vectors();
	}	
	
	if( isdefined( self.v[ "firefx" ] ) )
		self thread fire_effect();

	if( isdefined( self.v[ "fxid" ] ) && self.v[ "fxid" ] != "No FX" )
		self thread cannon_effect();

	if( isdefined( self.v[ "earthquake" ] ) )
	{
		self thread exploder_earthquake();
	}
}

//TODO T7 - update this if other functionality comes online for the new system
function activate_radiant_exploder( string )
{
	for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
	{
		PlayRadiantExploder( localClientNum, string );
	}	
}

function stop_exploder( exploder_id )
{
	//println("*** Client : Delete exploder " + num);
	if( IsString( exploder_id ) )
	{
		for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
		{
			StopRadiantExploder( localClientNum, exploder_id );
		}
		return;
	}	
	
	num = int( exploder_id );
	
	if(isdefined(level.createFXexploders[exploder_id]))	
	{
		for(i = 0; i < level.createFXexploders[exploder_id].size; i ++)
		{
			ent = level.createFXexploders[exploder_id][i];

			if( isdefined(ent.loopFX) )
			{
				for(j = 0; j < ent.loopFX.size; j ++)
				{
					if( isdefined( ent.loopFX[j] ) )
					{
						StopFX( j, ent.loopFX[j] );
						ent.loopFX[j] = undefined;
					}
				}
				
				ent.loopFX = [];
			}
		}
	}
}

function kill_exploder( exploder_id )
{
	//println("*** Client : Delete exploder " + num);
	if( IsString( exploder_id ) )
	{
		for ( localClientNum = 0; localClientNum < level.localPlayers.size; localClientNum++ )
		{
			KillRadiantExploder( localClientNum, exploder_id );
		}
		return;
	}
	assertmsg( "unhandled exploder type, only radiant exploders are handled: " + exploder_id );
}

function exploder_delay()
{
	if( !isdefined( self.v[ "delay" ] ) )
		self.v[ "delay" ] = 0;

	min_delay = self.v[ "delay" ];
	max_delay = self.v[ "delay" ] + 0.001;// cant randomfloatrange on the same #
	if( isdefined( self.v[ "delay_min" ] ) )
		min_delay = self.v[ "delay_min" ];

	if( isdefined( self.v[ "delay_max" ] ) )
		max_delay = self.v[ "delay_max" ];

	if( min_delay > 0 )
		waitrealtime( randomfloatrange( min_delay, max_delay ) );
}

function exploder_playSound()
{
	if( !isdefined( self.v[ "soundalias" ] ) || self.v[ "soundalias" ] == "nil" )
		return;
	
	sound::play_in_space( 0, self.v[ "soundalias" ], self.v[ "origin" ] );
}

function exploder_earthquake()
{
	self exploder_delay();
	eq = level.earthquake[ self.v[ "earthquake" ] ];
	
	if(isdefined(eq))
	{
		GetLocalPlayers()[0] earthquake( eq[ "magnitude" ], eq[ "duration" ], self.v[ "origin" ], eq[ "radius" ] );
	}
}

function exploder_is_lightning_exploder(num)
{
	if (isdefined(level.lightningExploder))
	{
		for(i = 0; i < level.lightningExploder.size; i ++)
		{
			if(level.lightningExploder[i] == num)
			{
				return true;
			}
		}
	}
		
	return false;
}

function stopLightLoopExploder( exploderIndex )
{
	num = Int(exploderIndex);
	
	if(isdefined(level.createFXexploders[num]))	
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			ent = level.createFXexploders[num][i];

			if ( !isdefined( ent.looperFX ) ) 
			{
				ent.looperFX = [];
			}
	
	    for( clientNum = 0; clientNum < level.max_local_clients; clientNum++ )
	    {
		    if( localClientActive( clientNum ) )
		    {
					if ( isdefined( ent.looperFX[clientNum] ) )
					{
						for( looperFXCount = 0; looperFXCount < ent.looperFX[clientNum].size; looperFXCount++ )
						{
							deletefx( clientNum, ent.looperFX[clientNum][looperFXCount] );
						}
					}
				}
				
				ent.looperFX[clientNum] = [];
			}
			
			ent.looperFX = [];
		}
	}
}

function playLightLoopExploder( exploderIndex )
{
	num = Int(exploderIndex);
	
	if(isdefined(level.createFXexploders[num]))	
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			ent = level.createFXexploders[num][i];

			if ( !isdefined( ent.looperFX ) ) 
			{
				ent.looperFX = [];
			}

	    for( clientNum = 0; clientNum < level.max_local_clients; clientNum++ )
	    {
		    if( localClientActive( clientNum ) )
		    {
			    if ( !isdefined( ent.looperFX[clientNum] ) ) 
			    {
				    ent.looperFX[clientNum] = [];
			    }
					ent.looperFX[clientNum][ent.looperFX[clientNum].size] = ent playExploderFX( clientNum );
		    }
	    }
		}
	}
}

function createExploder( fxid )
{
	ent = fx::create_effect( "exploder", fxid );
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder_type" ] = "normal";
	return ent;
}

function cannon_effect()
{
	if( isdefined( self.v[ "repeat" ] ) )
	{
		for( i = 0;i < self.v[ "repeat" ];i ++ )
		{
			players = getlocalplayers();	
			
			for(player = 0; player < players.size; player ++)
			{
				PlayFX( player, level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
			}

			self exploder_delay();
		}
		return;
	}
	
	self exploder_delay();

	players = getlocalplayers();	

	if ( isdefined( self.loopFX ) )
	{
		for(i = 0; i < self.loopFX.size; i ++)
		{
			StopFX( i, self.loopFX[i] );
		}
		
		self.loopFX = [];
	}

	if(!isdefined(self.loopFX))
	{
		self.loopFX = [];
	}

	if(!isdefined(level._effect[self.v["fxid"]]))
	{
		assertmsg("*** Client : Effect " + self.v["fxid"] + " not precached in level_fx.csc.");
		return;
	}

	for(i = 0; i < players.size; i ++)
	{
		if( isdefined( self.v["fxid"] ) )
		{
			self.loopFX[i] = PlayFX( i , level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
		}
	}
		
	self exploder_playSound();
}

function fire_effect()
{
	forward = self.v[ "forward" ];
	if( !isdefined( forward ) )
	{
		forward = anglestoforward( self.v["angles"] );
	}
	up = self.v[ "up" ];
	if( !isdefined( up ) )
	{
		up = anglestoup( self.v["angles"] );
	}	

	//org = undefined;

	firefxSound = self.v[ "firefxsound" ];
	origin = self.v[ "origin" ];
	firefx = self.v[ "firefx" ];
	ender = self.v[ "ender" ];
	if( !isdefined( ender ) )
		ender = "createfx_effectStopper";

	fireFxDelay = 0.5;
	if( isdefined( self.v[ "firefxdelay" ] ) )
		fireFxDelay = self.v[ "firefxdelay" ];

	self exploder_delay();

	players = GetLocalPlayers();
	
	for(i = 0; i < players.size; i ++)
	{
		if( isdefined( firefxSound ) )
		{
			level thread sound::loop_fx_sound( i, firefxSound, origin, ender );
		}
		playfx( i, level._effect[ firefx ], self.v[ "origin" ], forward, up, 0, self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	}
}

// self is the exploder entity
function playExploderFX( clientNum )
{
/# 
	if ( !isdefined( self.v[ "origin" ] ) )
		return;	
	if ( !isdefined( self.v[ "forward" ] ) )
		return;
	if ( !isdefined( self.v[ "up" ] ) )
		return;
#/
	return playfx( clientNum, level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ], 0, self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
}


function stop_after_duration( name, duration )
{
	wait( duration );
	stop_exploder( name );
}


function exploder_duration( name, duration )
{
	if ( !( isdefined( duration ) && duration ) )
	{
		return;
	}

	exploder( name );
	
	level thread stop_after_duration( name, duration );
}

