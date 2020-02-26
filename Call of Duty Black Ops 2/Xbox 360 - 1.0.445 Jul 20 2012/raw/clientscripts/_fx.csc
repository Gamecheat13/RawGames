#include clientscripts\_utility;
#include clientscripts\_music;

createLoopSound()
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

createEffect( type, fxid )
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

exploder_delay()
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

fire_effect()
{
	forward = self.v[ "forward" ];
	up = self.v[ "up" ];

	//org = undefined;

	firefxSound = self.v[ "firefxsound" ];
	origin = self.v[ "origin" ];
	firefx = self.v[ "firefx" ];
	ender = self.v[ "ender" ];
	if( !isdefined( ender ) )
		ender = "createfx_effectStopper";
	timeout = self.v[ "firefxtimeout" ];

	fireFxDelay = 0.5;
	if( isdefined( self.v[ "firefxdelay" ] ) )
		fireFxDelay = self.v[ "firefxdelay" ];

	self exploder_delay();

	if( isdefined( firefxSound ) )	
		level thread clientscripts\_utility::loop_fx_sound( firefxSound, origin, ender, timeout );

	players = level.localPlayers;
	
	for(i = 0; i < players.size; i ++)
	{
		//println("fire fx " + level._effect[ firefx ]);
		playfx( i, level._effect[ firefx ], self.v[ "origin" ], forward, up, 0, self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	}

// 	loopfx( 				fxId, 	fxPos, 	waittime, 	fxPos2, 	fxStart, 	fxStop, 	timeout )
// 	maps\_fx::loopfx( 	firefx, 	origin, 	delay, 		org, 	undefined, 	ender, 	timeout );
}

exploder_playSound()
{
	if( !isdefined( self.v[ "soundalias" ] ) || self.v[ "soundalias" ] == "nil" )
		return;
	
	play_sound_in_space( 0, self.v[ "soundalias" ], self.v[ "origin" ] );
	//println("***Client: Exploder plays sound " + self.v["soundalias"]);
}

cannon_effect()
{
	if( isdefined( self.v[ "repeat" ] ) )
	{
		for( i = 0;i < self.v[ "repeat" ];i ++ )
		{
			players = level.localPlayers;	
			
			for(player = 0; player < players.size; player ++)
			{
				//println("cannon fx " + level._effect[ self.v[ "fxid" ] ]);
				PlayFX( player, level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
			}
//			exploder_playSound();
			self exploder_delay();
		}
		return;
	}
	
	self exploder_delay();

	players = level.localPlayers;	

	if ( isdefined( self.loopFX ) )
	{
		for(i = 0; i < self.loopFX.size; i ++)
		{
			//deletefx(i, self.loopFX[i]);
			//self.loopFX[i] delete();
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
//	for(i = 0; i < 1; i ++)
	{
		if( IsDefined( self.v["fxid"] ) )
		{
			self.loopFX[i] = PlayFX( i , level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
		}
	}
		
/*	self.looper = 
	triggerFx( self.looper );*/
	self exploder_playSound();
}

exploder_earthquake()
{
	self exploder_delay();
	eq = level.earthquake[ self.v[ "earthquake" ] ];
	
	if(isdefined(eq))
	{
		level.localPlayers[0] earthquake( eq[ "magnitude" ], eq[ "duration" ], self.v[ "origin" ], eq[ "radius" ] );
	}
	//else
	//{
	//	println("*** Client : Missing " + self.v[ "earthquake" ] + " from client side level object.");
	//}
}

activate_individual_exploder()
{
	if(!isdefined(self.v["angles"]))
	{
		self.v["angles"] = (0,0,0);
		self set_forward_and_up_vectors();
	}	
	
	if( isdefined( self.v[ "firefx" ] ) )
		self thread fire_effect();

	if( isdefined( self.v[ "fxid" ] ) && self.v[ "fxid" ] != "No FX" )
		self thread cannon_effect();
	//else
		//if( isdefined( self.v[ "soundalias" ] ) )
		//{
			//println("** Client : missing sound_effect");
			//self thread sound_effect(); 
		//}

	// Trail effects on server, still.

/*	if( IsDefined( self.v[ "trailfx" ] ) )
	{
		//	println("** Client : missing trail_effect");
		self thread trail_effect();
	} */

/*	if( isdefined( self.v[ "damage" ] ) )
		self thread exploder_damage();*/

	if( isdefined( self.v[ "earthquake" ] ) )
	{
//			println("*** client : missing exploder_earthquake();");

		self thread exploder_earthquake();
	}

	//if( isdefined( self.v[ "rumble" ] ) )
	//{
		//println("*** client : missing exploder_rumble");
		//self thread exploder_rumble(); 
	//}
}

deactivate_exploder(num)
{
	//println("*** Client : Delete exploder " + num);
	
	num = int( num );
	
/*	for( i = 0;i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[ i ];
		if( !IsDefined( ent ) )
			continue; 
	
		if( ent.v[ "type" ] != "exploder" )
			continue; 

		// make the exploder actually removed the array instead?
		if( !isdefined( ent.v[ "exploder" ] ) )
			continue;

		if( ent.v[ "exploder" ] != num )
			continue;
	
    if(IsDefined(ent.soundEnt))
    {
        deletefakeent(0, ent.soundEnt);
        ent.soundEnt = undefined;
    }
	        
		if(isdefined(ent.loopFX))
		{
			for(j = 0; j < ent.loopFX.size; j ++)
			{
				if(isdefined(ent.loopFX[j]))
				{
					ent.loopFX[j] delete();
					ent.loopFX[j] = undefined;
				}
			}
			
			ent.loopFX = [];
		}

	}	*/
	
	
	if(IsDefined(level.createFXexploders[num]))	
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			ent = level.createFXexploders[num][i];

		    if(IsDefined(ent.soundEnt))
		    {
		        deletefakeent(0, ent.soundEnt);
		        ent.soundEnt = undefined;
		    }
		        
			if( IsDefined(ent.loopFX) )
			{
				for(j = 0; j < ent.loopFX.size; j ++)
				{
					if( IsDefined( ent.loopFX[j] ) )
					{
						StopFX( j, ent.loopFX[j] );
						//ent.loopFX[j] delete();
						ent.loopFX[j] = undefined;
					}
				}
				
				ent.loopFX = [];
			}
		}
	}
}

lightning(normalFunc, flashFunc)
{
	[[flashFunc]]();
	
	// SRS 5/28/2008: updated to include a call back to the normal function
	waitrealtime(RandomFloatRange( 0.05, 0.1 ));
	[[normalFunc]]();	
}

exploder_is_lightning_exploder(num)
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

glass_exploder_watcher(num, dist, alias)
{
	ents = [];
	
	for( i = 0;i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[ i ];
		if( !IsDefined( ent ) )
			continue;
	
		if( ent.v[ "type" ] != "exploder" )
			continue; 	
	
		// make the exploder actually removed the array instead?
		if( !isdefined( ent.v[ "exploder" ] ) )
			continue; 

		if( ent.v[ "exploder" ] != num )
			continue; 

		//debugstar(ent.v["origin"], 100000, (1,0,0));

		ents[ents.size] = ent;		
	}	
	
	if(ents.size == 0)
	{
	//	PrintLn("*** : No glass exploder with id " + num + " found.");
		return;
	}
	
	dist_squared = dist * dist;
	
	while(1)
	{
		level waittill("glass_smash", pos, vec);
		
		for(i = 0; i < ents.size; i ++)
		{
			ds = DistanceSquared(pos, ents[i].v["origin"]);
			if( ds <= dist_squared)
			{
				exploder(num);
				
				if( IsDefined( alias ) )
				{
				    sound_ent = spawn( 0, pos, "script_origin" );
				    sound_ent PlayLoopSound( alias, .25 );
				    sound_ent thread delete_window_sound_ent();
				}
				
				return;
			}
	/*		else
			{
				PrintLn("*** Glass explo " + ds);
			}*/
		}
	}
}

exploder_is_glass_exploder(num, dist, alias)
{
	if(!IsDefined(dist))
	{
		dist = 24;
	}
	
	level thread glass_exploder_watcher(num, dist, alias);
}

delete_window_sound_ent()
{
    wait(30);
    self stoploopsound(2);
    wait(2);
    self Delete();
}

activate_exploder( num )
{
	num = int( num ); 
	
/*	for( i = 0;i < level.createFXent.size;i ++ )
	{
		ent = level.createFXent[ i ];
		if( !IsDefined( ent ) )
			continue;
	
		if( ent.v[ "type" ] != "exploder" )
			continue; 	
	
		// make the exploder actually removed the array instead?
		if( !isdefined( ent.v[ "exploder" ] ) )
			continue; 

		if( ent.v[ "exploder" ] != num )
			continue; 

		ent activate_individual_exploder();
	} */

	if(IsDefined(level.createFXexploders[num]))	
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
			thread lightning(level.lightningNormalFunc, level.lightningFlashFunc);
		}
	}
	
}	

exploder( num )
{
	activate_exploder(num);
}

createOneshotEffect( fxid )
{
	ent = createEffect( "oneshotfx", fxid ); 
	ent.v[ "delay" ] = -15;
	return ent; 
}

createLoopEffect( fxid )
{
	ent = createEffect( "loopfx", fxid ); 
	ent.v[ "delay" ] = 0.5;
	return ent; 
}

createExploder( fxid )
{
	ent = createEffect( "exploder", fxid ); 
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder_type" ] = "normal";
	return ent; 
}

set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}

create_triggerfx(clientNum)
{
	self.looperFX = playFx( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"], self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	
	create_loopsound(clientNum);
}

create_looper(clientNum)
{
	//assert (isdefined(self.looper));
	//self.looperFX = spawnfakeent(clientNum);
	//playLoopedFx( clientNum, self.looperFX, level._effect[self.v["fxid"]], self.v["delay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);
	self thread loopfx(clientNum);	
	create_loopsound(clientNum);
}

loopfx(clientNum)
{		
	self.looperFX = playFx( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"], self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	
	while( 1 )
	{
		if( isdefined(self.v["delay"]) )
			waitrealtime( self.v["delay"] );
			
		while( isfxplaying( clientNum, self.looperFX ) )
			wait 0.1;
			
		self.looperFX = playFx( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], 0, self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	}
}

loopfxStop (clientNum, timeout)
{
	self endon("death");
	waitrealtime(timeout);
	
	if(isdefined(self.looper))
		self.looper delete();	

	if(isdefined(self.looperFX))
		deletefx(clientNum, self.looperFX); 
}

loopfxthread(clientNum)
{
	if (isdefined (self.fxStart))
		level waittill ("start fx" + self.fxStart);

	while (1)
	{
		create_looper(clientNum);
		
		if (isdefined (self.timeout))
			thread loopfxStop(clientNum, self.timeout);
			
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

oneshotfxthread(clientNum)
{
//	wait(0.05);

	// This assumes that client scripts start at beginning of level - will need to take
	// hot join into account (and possibly restart from checkpoint...)

	if ( self.v["delay"] > 0 )	
	    waitrealtime(self.v["delay"]);
	  
	create_triggerfx(clientNum);
}

create_loopsound(clientNum)
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
			thread clientscripts\_utility::loop_fx_sound( clientNum, self.v["soundalias"], self.v["origin"], "stop_loop" );
		}
		else
		{
			thread clientscripts\_utility::loop_fx_sound( clientNum, self.v["soundalias"], self.v["origin"] );
		}
	}

}

fx_init(clientNum)
{

	clientscripts\_lights::init_lights(clientNum);

	if (!isdefined(level.createFX_enabled))
		return;
		
	clientscripts\_destructibles::init(clientNum);
	
	if(clientNum == 0)
	{
		clientscripts\_utility::init_exploders();		
	}
		
	// if the FX editor is running currently, then all fx are server side.
	if(level.createFX_enabled)
		return;

	if(!isdefined(level.createFXent))
		return;

	//println("*** Setting forward + up");

	for ( i=0; i<level.createFXent.size; i++ )
	{
		ent = level.createFXent[i];
		
		// This code my be executed for multiple local clients - only set the
		// axis up once.
		if(!isdefined(level._createfxforwardandupset))
		{
			if(!isdefined(level.needs_fixup))
			{
				if(isdefined(ent.v["angles"]))
					ent set_forward_and_up_vectors();
			}
		}

		if (ent.v["type"] == "loopfx")
			ent thread loopfxthread(clientNum); 
		if (ent.v["type"] == "oneshotfx")
			ent thread oneshotfxthread(clientNum);
		if (ent.v["type"] == "soundfx")
			ent thread create_loopsound(clientNum);
	}
	
	level._createfxforwardandupset = true;
}

reportNumEffects()
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

playLightLoopExploder( exploderIndex )
{
	num = Int(exploderIndex);
	
	if(IsDefined(level.createFXexploders[num]))	
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

// self is the exploder entity
playExploderFX( clientNum )
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

stopLightLoopExploder( exploderIndex )
{
	num = Int(exploderIndex);
	
	if(IsDefined(level.createFXexploders[num]))	
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

blinky_light( localClientNum, tagName, fx ) // self == equipment
{
	self endon( "entityshutdown" );
	self endon( "stop_blinky_light" );

	self.lightTagName = tagName;

	//self waittill_dobj(localClientNum);
	
	self thread blinky_emp_wait(localClientNum);

	while( true )
	{
		if( IsDefined( self.stunned ) && self.stunned )
		{
			wait( 0.1 );
			continue;
		}

		self.blinkyLightFx = PlayFXOnTag( localClientNum, fx, self, self.lightTagName );
		wait( 0.5 );
	}
}

stop_blinky_light(localClientNum)
{
	self notify( "stop_blinky_light" );
	
	if ( !IsDefined( self.blinkyLightFx ) )
		return;
		
	stopfx(localClientNum, self.blinkyLightFx);
	self.blinkyLightFx = undefined;
}

blinky_emp_wait(localClientNum)
{
	self endon( "entityshutdown" );
	self endon( "stop_blinky_light" );
	
	self waittill( "emp" );
	
	self stop_blinky_light( localClientNum );
}