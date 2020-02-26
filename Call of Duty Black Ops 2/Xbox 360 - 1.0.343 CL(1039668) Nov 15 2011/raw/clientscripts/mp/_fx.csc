#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

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
	ent.v["delay"] = 0;
	ent.v["exploder_type"] = "normal";
	return ent;
}

set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}

create_triggerfx(clientNum)
{
/#
	if( GetDvarint( "debug_fx" ) > 0 )
	{
		println("self.v['fxid'] " + self.v["fxid"]);
	}
#/
	self.looperFX = playFx( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"] );
	
	create_loopsound(clientNum);
}

create_looper(clientNum)
{
	self thread loopfx(clientNum);
	create_loopsound(clientNum);
}

loopfx(clientNum)
{
	self.looperFX = playFx( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"], self.v["delay"] );
	
	while( 1 )
	{
		if( isdefined(self.v["delay"]) )
		{
			if (!serverwait( clientNum, self.v["delay"], 0.25 ))
				continue;	// wait was unsucessful, so loop around
		}
			
		while( isfxplaying( clientNum, self.looperFX ) )
			wait 0.25;
			
		self.looperFX = playFx( clientNum, level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"] );
	}
}

loopfxStop (clientNum, timeout)
{
	self endon("death");
	wait(timeout);
	
	if(isdefined(self.looper))
		deletefx(clientNum, self.looper);	

	if(isdefined(self.loopFX))
	{
		deletefakeent(clientNum, self.loopFX); 
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
			deletefx(clientNum, self.looper);

		if (isdefined (self.fxStart))
			level waittill ("start fx" + self.fxStart);
		else
			return;
	}
}

playLightLoopExploder( exploderIndex )
{
	entArray = getExploderEntArray( exploderIndex );
	for( entArrayCount = 0; entArrayCount < entArray.size; entArrayCount++ )
	{
		ent = entArray[entArrayCount];
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

stopLightLoopExploder( exploderIndex )
{
	entArray = getExploderEntArray( exploderIndex );
	for( entArrayCount = 0; entArrayCount < entArray.size; entArrayCount++ )
	{
		ent = entArray[entArrayCount];
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
	}

	ent.looperFX = [];
}

oneshotfxthread(clientNum)
{
	// This assumes that client scripts start at beginning of level - will need to take
	// hot join into account (and possibly restart from checkpoint...)

	if ( self.v["delay"] > 0 )	
	    wait self.v["delay"];
	  
	create_triggerfx(clientNum);
}

exploder( clientNum, num )
{
	entArray = getExploderEntArray( num );
	for( entArrayCount = 0; entArrayCount < entArray.size; entArrayCount++ )
	{
		entArray[entArrayCount] playExploderFX( clientNum );
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
	return playfx( clientNum, level._effect[ self.v[ "fxid" ] ], self.v[ "origin" ], self.v[ "forward" ], self.v[ "up" ] );
}

getExploderEntArray( num )
{
	num = int( num );
	entArray = [];

	if ( !isdefined( level.lightsFXExploder ) ) 
	{
		level.lightsFXExploder = [];
	}
	if ( !isdefined( level.lightsFXExploder[num] ) )
	{
		for( i = 0;i < level.createFXent.size;i ++ )
		{
			ent = level.createFXent[ i ];
			if( !isdefined( ent ) )
				continue;
		
			if( ent.v[ "type" ] != "exploder" )
				continue;	
		
			// make the exploder actually removed the array instead?
			if( !isdefined( ent.v[ "exploder" ] ) )
				continue;
	
			if( ent.v[ "exploder" ] != num )
				continue;
	
			entArray[entArray.size] = ent;
		}
		level.lightsFXExploder[num] = entArray;
	}
	else
	{
		entArray = level.lightsFXExploder[num];
	}

	return entArray;
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
			thread clientscripts\mp\_utility::loop_fx_sound( clientNum, self.v["soundalias"], self.v["origin"], "stop_loop" );
		}
		else
		{
			thread clientscripts\mp\_utility::loop_fx_sound( clientNum, self.v["soundalias"], self.v["origin"] );
		}
	}

}

fx_init(clientNum)
{
	clientscripts\mp\_lights::init_lights(clientNum);

	// if the FX editor is running currently, then all fx are server side.

	if(level.createFX_enabled)
	{
		println("*** ClientScripts : _CreateFX enabled.  Not creating client side effects.");
		return;
	}

	if(!isdefined(level.createFXent))
		return;

	for ( i=0; i<level.createFXent.size; i++ )
	{
		ent = level.createFXent[i];
		
		// This code my be executed for multiple local clients - only set the
		// axis up once.
		if(!isdefined(level._createfxforwardandupset))
		{
			ent set_forward_and_up_vectors();
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
	assert( IsDefined( level._effect[fx_id] ), "Missing level._effect[\"" + fx_id + "\"]. You did not setup the fx before calling it in createFx." );
#/
	fx_object = SpawnFx( clientNum, level._effect[fx_id], origin, delay, forward, up );
	return fx_object;	// returns pointer to FX object - not an entity.....
}

blinky_light( localClientNum, tagName, friendlyfx, enemyfx ) // self == equipment
{
	self endon( "entityshutdown" );
	self endon( "stop_blinky_light" );

	self.lightTagName = tagName;

	self waittill_dobj(localClientNum);
	
	self thread blinky_emp_wait(localClientNum);

	while( true )
	{
		if( IsDefined( self.stunned ) && self.stunned )
		{
			wait( 0.1 );
			continue;
		}

		if ( friendNotFoe(localClientNum) )
		{
			self.blinkyLightFx = PlayFXOnTag( localClientNum, friendlyfx, self, self.lightTagName );
		}
		else
		{
			self.blinkyLightFx = PlayFXOnTag( localClientNum, enemyfx, self, self.lightTagName );
		}

		serverWait( localClientNum, 0.5, 0.01 );
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