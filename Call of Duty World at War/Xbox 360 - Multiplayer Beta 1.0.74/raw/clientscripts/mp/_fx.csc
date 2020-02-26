
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

set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}

create_triggerfx(clientNum)
{
	self.looper = spawnFx_wrapper( clientNum, self.v["fxid"], self.v["origin"], self.v["delay"], self.v["forward"], self.v["up"] );

	create_loopsound(clientNum);
}

create_looper(clientNum)
{
	//assert (isdefined(self.looper));
	self.loopFX = spawnfakeent(clientNum);
	playLoopedFx( clientNum, self.loopFX, level._effect[self.v["fxid"]], self.v["delay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);
	create_loopsound(clientNum);
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

oneshotfxthread(clientNum)
{
//	maps\_spawner::waitframe();

	// This assumes that client scripts start at beginning of level - will need to take
	// hot join into account (and possibly restart from checkpoint...)

	if ( self.v["delay"] > 0 )	
	    wait self.v["delay"];
	  
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
	assertEx( IsDefined( level._effect[fx_id] ), "Missing level._effect[\"" + fx_id + "\"]. You did not setup the fx before calling it in createFx." );
#/
	fx_object = SpawnFx( clientNum, level._effect[fx_id], origin, delay, forward, up );
	return fx_object;	// returns pointer to FX object - not an entity.....
}