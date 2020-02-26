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
		realwait( randomfloatrange( min_delay, max_delay ) );
}

fire_effect()
{
	forward = self.v[ "forward" ];
	up = self.v[ "up" ];

	org = undefined;

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

	players = getlocalplayers();
	
	for(i = 0; i < players.size; i ++)
	{
		println("fire fx " + level._effect[ firefx ]);
		playfx( i, level._effect[ firefx ], self.v[ "origin" ], forward, up );
	}

// 	loopfx( 				fxId, 	fxPos, 	waittime, 	fxPos2, 	fxStart, 	fxStop, 	timeout )
// 	maps\_fx::loopfx( 	firefx, 	origin, 	delay, 		org, 	undefined, 	ender, 	timeout );
}

trail_effect()
{
	self exploder_delay();

//	self.trailfx_looper = PlayLoopedFx( level._effect[self.v["trailfx"]], self.v["trailfxdelay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);

	if( !IsDefined( self.v["trailfxtag"] ) )
	{
		self.v["trailfxtag"] = "tag_origin";
	}
	

	if(isdefined(self.v["target"]))
	{					
		
		println("*** Client Trail : target defined.");
		
		temp_ent = GetEnt(0, self.v["target"], "targetname" ); 
		if( IsDefined( temp_ent ) )
		{
			
			println("*** Client : Trail found target ent.");
			
			org = temp_ent.origin; 
		}
		else
		{
			temp_ent = GetStruct( self.v["target"], "targetname" ); 
			org = temp_ent.origin; 
//			structinfo(temp_ent);
		}

		if(isdefined(org))
			self.v["angles"] = VectorToAngles( org - self.v["origin"] ); 	
		else		
				println("*** Client : Exploder " + self.v["trailfx"] + " Failed to find target " + self.v["target"]);

	}
	else
	{
		println("Client trail : target not defined.");
	}

	
	if(!isdefined(self.model))
	{
		println("*** Client : Trail effect has no model.");
//		structinfo(self);
		keys = getarraykeys(self.v);
		
		for(i = 0; i < keys.size; i ++)
		{
			println(keys[i] + " " + self.v[keys[i]]);
		}
		return;
	}
	else
	{
		println("*** Client : I should be a " + self.v["trailfx"] + " trail, connected to " + self.model + " by the " + self.v["trailfxtag"]);
	}

	
//		temp_ent LinkTo( self.model );
	//PlayFxOnTag( level._effect[self.v["trailfx"]], temp_ent, self.v["trailfxtag"] );
	
/*	ent = GetEnt(0, self.model, "targetname");
	if(!isdefined(ent))
		return;

	temp_ent = Spawn( "script_model", ent.origin );
	temp_ent SetModel( "*5" );
/*	temp_ent LinkTo( self.model );
	PlayFxOnTag( level._effect[self.v["trailfx"]], temp_ent, self.v["trailfxtag"] );

//	self.trailfx_looper LinkTo( self, self.v["trailfxtag"] );
	
	if( IsDefined( self.v["trailfxsound"] ) )
	{
//		self.trailfx_looper PlayLoopSound( self.v["trailfxsound"] );
//		self PlayLoopSound( self.v["trailfxsound"] );
		temp_ent PlayLoopSound( self.v["trailfxsound"] );
	}

	if( IsDefined( self.v[ "ender" ] ) )
	{
//		level thread trail_effect_ender( self.trailfx_looper, self.v[ "ender" ] );
	}

	if( !IsDefined( self.v["trailfxtimeout"] ) )
	{
		return;
	}

	wait( self.v["trailfxtimeout"] );
//	self.trailfx_looper Delete();

	temp_ent Delete();*/
	
	
}

exploder_playSound()
{
	if( !isdefined( self.v[ "soundalias" ] ) || self.v[ "soundalias" ] == "nil" )
		return;
	
	play_sound_in_space( 0, self.v[ "soundalias" ], self.v[ "origin" ] );
	println("***Client: Exploder plays sound " + self.v["soundalias"]);
}

cannon_effect()
{
	if( isdefined( self.v[ "repeat" ] ) )
	{
		for( i = 0;i < self.v[ "repeat" ];i ++ )
		{

			players = getlocalplayers();	
			
			for(player = 0; player < players.size; player ++)
			{
				println("cannon fx " + level._effect[ self.v[ "fxid" ] ]);
				playfx( player, level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
			}
//			exploder_playSound();
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
			//deletefx(i, self.loopFX[i]);
			self.loopFX[i] delete();
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
		if(isdefined(self.v["fxid"]))
		{
			self.loopFX[i] = spawnFx( i, level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v["delay"], self.v[ "forward" ], self.v[ "up" ] );
			triggerfx(self.loopFX[i]);
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
		getlocalplayers()[0] earthquake( eq[ "magnitude" ], eq[ "duration" ], self.v[ "origin" ], eq[ "radius" ] );
	}
	else
	{
		println("*** Client : Missing " + self.v[ "earthquake" ] + " from client side level object.");
	}
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
	else
		if( isdefined( self.v[ "soundalias" ] ) )
		{
			println("** Client : missing sound_effect");
			//self thread sound_effect(); 
		}

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

	if( isdefined( self.v[ "rumble" ] ) )
	{
		println("*** client : missing exploder_rumble");
		//self thread exploder_rumble(); 
	}
}

deactivate_exploder(num)
{
	println("*** Client : Delete exploder " + num);
	
	num = int( num );
	
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

	}	
}

lightning(normalFunc, flashFunc)
{
	[[flashFunc]]();
	
	// SRS 5/28/2008: updated to include a call back to the normal function
	clientscripts\_music::realWait(RandomFloatRange( 0.05, 0.1 ));
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

activate_exploder( num )
{
	num = int( num ); 
	
	prof_begin( "client activate_exploder" );
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

		ent activate_individual_exploder();
	}
	
	if(exploder_is_lightning_exploder(num))
	{
		if(isdefined(level.lightningNormalFunc) && isdefined(level.lightningFlashFunc))
		{
			thread lightning(level.lightningNormalFunc, level.lightningFlashFunc);
		}
	}
	
	prof_end( "client activate_exploder" );
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
	self.looper = spawnFx_wrapper( clientNum, self.v["fxid"], self.v["origin"], self.v["delay"], self.v["forward"], self.v["up"] );

	triggerfx(self.looper, self.v["delay"]);

	create_loopsound(clientNum);
}

create_looper(clientNum)
{
	//assert (isdefined(self.looper));
	self.looperFX = spawnfakeent(clientNum);
	playLoopedFx( clientNum, self.looperFX, level._effect[self.v["fxid"]], self.v["delay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);
	create_loopsound(clientNum);
}

loopfxStop (clientNum, timeout)
{
	self endon("death");
	realwait(timeout);
	
	if(isdefined(self.looper))
		self.looper delete();	

	if(isdefined(self.looperFX))
	{
		deletefakeent(clientNum, self.looperFX); 
	}

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

		if (isdefined (self.looper))
			deletefakeent(clientNum, self.looper);

		if (isdefined (self.fxStart))
			level waittill ("start fx" + self.fxStart);
		else
			return;
	}
}

oneshotfxthread(clientNum)
{
//	maps\_spawner::waitframe();

	// This assumes that client scripts start at beginning of level - will need to take
	// hot join into account (and possibly restart from checkpoint...)

	if ( self.v["delay"] > 0 )	
	    realWait(self.v["delay"]);
	  
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
		
	// if the FX editor is running currently, then all fx are server side.
	if(level.createFX_enabled)
		return;

	if(!isdefined(level.createFXent))
		return;

	if(clientNum == 0)
	{
		clientscripts\_utility::init_exploders();		
	}

	println("*** Setting forward + up");

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
	if(isdefined(level.createFXent))
	{
		println("*** ClientScripts : Added " + level.createFXent.size + " effects.");
	}
	else
	{
		println("*** ClientScripts : Added no effects.");
	}
#/	
}

// MikeD (12/3/2007): Added some debug, incase we forget to actually setup the level._effect[...]
spawnFX_wrapper( clientNum, fx_id,  origin, delay, forward, up )
{
/#
	assertEx( IsDefined( level._effect[fx_id] ), "Missing level._effect[\"" + fx_id + "\"]. You did not setup the fx before calling it in createFx." );
#/
	fx_object = SpawnFx( clientNum, level._effect[fx_id], origin, delay, forward, up );
	return fx_object;	// returns entity.....
}