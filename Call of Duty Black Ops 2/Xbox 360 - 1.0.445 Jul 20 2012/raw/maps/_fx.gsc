#include maps\_utility;
#include maps\_createfx;
#include common_scripts\Utility;
/*
	****************************************************************************************************************
	OneShotfx: Fires an effect once.
	maps\_fx::OneShotfx( effectname, (x y z), predelay);

	Example:
	maps\_fx::OneShotfx(level.medFire,		// Medium fire effect
					(-701, -18361, 148),	// Origin
					5);						// Wait 5 seconds before doing effect
	****************************************************************************************************************


	****************************************************************************************************************
	Loopfx: Loops an effect with a waittime.
	maps\_fx::loopfx( effectname, (x y z), delay_between_shots);

	Example:
	maps\_fx::loopfx(level.medFire,			// Medium fire effect
					(-701, -18361, 148),	// Origin
					0.3);					// Wait 0.3 seconds between shots
	****************************************************************************************************************


	****************************************************************************************************************
	GunFireLoopfx: Simulates bursts of fire.
	maps\_fx::gunfireloopfx(fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)

	Example:
	maps\_fx::gunfireloopfx (level.medFire,			// Medium fire effect
							(-701, -18361, 148),	// Origin
							10, 15,					// 10 to 15 shots
							0.1, 0.3,				// 0.1 to 0.3 seconds between shots
							2.5, 9);				// 2.5 to 9 seconds between sets of shots.
	****************************************************************************************************************

	****************************************************************************************************************
	GrenadeExplosionfx: Creates a grenade explosion with view jitter.
	maps\_fx::GrenadeExplosionfx((x y z));

	Example:
	maps\_fx::GrenadeExplosionfx( (-701, -18361, 148) ); // origin
	****************************************************************************************************************
*/

/*
{
"origin" "-451 -14930 26"
"targetname" "auto1166"
"classname" "script_origin"
}
*/

OneShotfx(fxId, fxPos, waittime, fxPos2)
{
//	level thread print_org ("OneShotfx", fxId, fxPos, waittime);
//    level thread OneShotfxthread (fxId, fxPos, waittime, fxPos2);
}

OneShotfxthread ( )
{
	wait(0.05);

	if ( self.v["delay"] > 0 )
	    wait self.v["delay"];
	  
	/*  
	if ( isdefined( self.v[ "fire_range" ] ) )
	{
		thread fire_radius( self.v[ "origin" ], self.v[ "fire_range" ] );
	}
	*/

	create_triggerfx();
}	    

create_triggerfx()
{
	//assert (isdefined(self.looper));
	//self.looper = spawnFx( level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"] );
	self.looper = spawnFx_wrapper( self.v["fxid"], self.v["origin"], self.v["forward"], self.v["up"], self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ] );
	triggerFx( self.looper, self.v["delay"] );
	create_loopsound();
}

/*
OneShotfxthread ( fxId, fxPos, waittime, fxPos2 )
{
	wait(0.05);

	if ( waittime < 0 )
	{
	    if (isdefined (fxPos2))
	    {
			fxPos2 = vectornormalize (fxPos2 - fxPos);
			fxObj = spawnFx( level._effect[fxId], fxPos, fxPos2 );
			triggerFx( fxObj, waittime );
			
		}
		else
		{
			fxObj = spawnFx( level._effect[fxId], fxPos );
			triggerFx( fxObj, waittime );
		}
	}
	else
	{
	    wait waittime;
	    if (isdefined (fxPos2))
	    {
			fxPos2 = vectornormalize (fxPos2 - fxPos);
			playfx ( level._effect[fxId], fxPos, fxPos2 );	
		}
		else
		{
			playfx ( level._effect[fxId], fxPos);
		}
	}
}
*/

/*
loopfxRotate(fxId, fxPos, waittime, angle, fxStart, fxStop, timeout)
{
	level thread print_org ("loopfx", fxId, fxPos, waittime);
    level thread loopfxthread (fxId, fxPos, waittime, fxPos2, fxStart, fxStop, timeout);
}
*/


loopfx(fxId, fxPos, waittime, fxPos2, fxStart, fxStop, timeout)
{
	/#println("Loopfx is deprecated!");#/
	ent = createLoopEffect(fxId);
	ent.v["origin"] = fxPos;
	ent.v["angles"] = (0,0,0);
	if (isdefined(fxPos2))
	{
		ent.v["angles"] = vectortoangles(fxPos2 - fxPos);
	}
	ent.v["delay"] = waittime;
}

/*
loopfx(fxId, fxPos, waittime, fxPos2, fxStart, fxStop, timeout)
{
	level thread print_org ("loopfx", fxId, fxPos, waittime);
    level thread loopfxthread (fxId, fxPos, waittime, fxPos2, fxStart, fxStop, timeout);
}
*/

create_looper()
{
	//assert (isdefined(self.looper));
	self.looper = playLoopedFx( level._effect[self.v["fxid"]], self.v["delay"], self.v["origin"], 0, self.v["forward"], self.v["up"], self.v[ "primlightfrac" ], self.v[ "lightoriginoffs" ]);
	create_loopsound();
}

create_loopsound()
{
	self notify( "stop_loop" );
	if ( isdefined( self.v["soundalias"] ) && ( self.v["soundalias"] != "nil" ) )
	{
		if ( isdefined( self.v[ "stopable" ] ) && self.v[ "stopable" ] )
		{
			if ( isdefined( self.looper ) )
			{
				self.looper thread maps\_utility::loop_fx_sound( self.v["soundalias"], self.v["origin"], "death" );
			}
			else
			{
				thread maps\_utility::loop_fx_sound( self.v["soundalias"], self.v["origin"], "stop_loop" );
			}
		}
		else
		{
			if ( isdefined( self.looper ) )
			{
				self.looper thread maps\_utility::loop_fx_sound( self.v["soundalias"], self.v["origin"] );
			}
			else
			{
				thread maps\_utility::loop_fx_sound( self.v["soundalias"], self.v["origin"] );
			}
		}
	}
}

stop_loopsound()
{
	self notify( "stop_loop" );
}

loopfxthread ()
{
	wait(0.05);
//	println ( "fx testing running Id: ", fxId );
//    if ((isdefined (level.scr_sound)) && (isdefined (level.scr_sound[fxId])))
//	   loopSound(level.scr_sound[fxId], fxPos);

	if (isdefined (self.fxStart))
	{
		level waittill ("start fx" + self.fxStart);
	}

	while (1)
	{
		/*
		if (isdefined (ent.org2))
		{
			fxAngle = vectorNormalize (ent.org2 - ent.org);
			looper = playLoopedFx( level._effect[fxId], ent.delay, ent.org, 0, fxAngle );
		}
		else
			looper = playLoopedFx( level._effect[fxId], ent.delay, ent.org, 0 );
		*/
		create_looper();
		
		if (isdefined (self.timeout))
		{
			thread loopfxStop(self.timeout);
		}
			
		if (isdefined (self.fxStop))
		{
			level waittill ("stop fx" + self.fxStop);
		}
		else
		{
			return;
		}

		if (isdefined (self.looper))
		{
			self.looper delete();
		}

		if (isdefined (self.fxStart))
		{
			level waittill ("start fx" + self.fxStart);
		}
		else
		{
			return;
		}
	}
}

loopfxStop (timeout)
{
	self endon("death");
	wait(timeout);
	self.looper delete();
}

loopSound(sound, Pos, waittime)
{
//	level thread print_org ("loopSound", sound, Pos, waittime);
	level thread loopSoundthread (sound, Pos, waittime);
}

loopSoundthread ( sound, pos, waittime )
{
	org = spawn ("script_origin", (pos));

	org.origin = pos;
//	println ("hello1 ", org.origin, sound);
	org playLoopSound ( sound );
}

setup_fx()
{
	if ((!isdefined (self.script_fxid)) || (!isdefined (self.script_fxcommand)) || (!isdefined (self.script_delay)))
	{
//		println (self.script_fxid);
//		println (self.script_fxcommand);
//		println (self.script_delay);
//		println ("Effect at origin ", self.origin," doesn't have script_fxid/script_fxcommand/script_delay");
//		self delete();
		return;
	}

//	println ("^a Command:", self.script_fxcommand, " Effect:", self.script_fxID, " Delay:", self.script_delay, " ", self.origin);

	org = undefined;
	if (isdefined (self.target))
	{
		ent = getent (self.target,"targetname");
		if (isdefined (ent))
		{
			org = ent.origin;
		}
	}

	fxStart = undefined;
	if (isdefined (self.script_fxstart))
	{
		fxStart = self.script_fxstart;
	}

	fxStop = undefined;
	if (isdefined (self.script_fxstop))
	{
		fxStop = self.script_fxstop;
	}

	if (self.script_fxcommand == "OneShotfx")
	{
		OneShotfx(self.script_fxId, self.origin, self.script_delay, org);
	}
	if (self.script_fxcommand == "loopfx")
	{
		loopfx(self.script_fxId, self.origin, self.script_delay, org, fxStart, fxStop);
	}
	if (self.script_fxcommand == "loopsound")
	{
		loopsound(self.script_fxId, self.origin, self.script_delay);
	}

	self delete();
}

soundfx(fxId, fxPos, endonNotify)
{
	org = spawn ("script_origin",(0,0,0));
	org.origin = fxPos;
	org playloopsound (fxId);
	if (isdefined(endonNotify))
	{
		org thread soundfxDelete(endonNotify);
	}

	/*
	ent = level thread maps\_createfx::createfx_showOrigin ( fxId, fxPos, undefined, undefined, "soundfx" );
	ent.delay = 0;
	ent endon ("effect deleted");
	ent.soundfx = org;
	*/
}

soundfxDelete(endonNotify)
{
	level waittill (endonNotify);
	self delete();
}


rainfx(fxId, fxId2, fxPos)
{
	org = spawn ("script_origin",(0,0,0));
	org.origin = fxPos;
	org thread rainLoop(fxId, fxId2);
	
	/*
	ent = level thread maps\_createfx::createfx_showOrigin ( fxId, fxPos, undefined, undefined, "rainfx", undefined, fxId2 );
	ent.delay = 0;
	ent endon ("effect deleted");
	ent.soundfx = org;
	*/

}

rainLoop (hardRain, lightRain)
{
//	org playloopsound (fxId);
	self endon ("death");
	blend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	blend.origin = self.origin;
	self thread blendDelete(blend);
	
	blend2 = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	blend2.origin = self.origin;
	self thread blendDelete(blend2);
	

// lerp of 0 will play _null only
	blend setSoundBlend( lightRain+"_null", lightRain, 0);
	blend2 setSoundBlend( hardRain+"_null", hardRain, 1);
	rain = "hard";
	blendTime = undefined;
	for (;;)
	{
		level waittill ("rain_change", change, blendTime);
		blendTime *= 20; // internal framerate
		assert (change == "hard" || change == "light" || change == "none");
		assert (blendtime > 0);
		
		if (change == "hard")
		{
			if (rain == "none")
			{
				blendTime *= 0.5; // gotta do 2 blends to go from none to hard
				for (i=0;i<blendtime;i++)
				{
					blend setSoundBlend( lightRain+"_null", lightRain, i/blendtime );
					wait (0.05);
				}
				rain = "light";
			}
			if (rain == "light")
			{
				for (i=0;i<blendtime;i++)
				{
					blend setSoundBlend( lightRain+"_null", lightRain, 1-(i/blendtime) );
					blend2 setSoundBlend( hardRain+"_null", hardRain, i/blendtime );
					wait (0.05);
				}
			}
		}
		if (change == "none")
		{
			if (rain == "hard")
			{
				blendTime *= 0.5; // gotta do 2 blends to go from hard to none
				for (i=0;i<blendtime;i++)
				{
					blend setSoundBlend( lightRain+"_null", lightRain, (i/blendtime) );
					blend2 setSoundBlend( hardRain+"_null", hardRain, 1-( i/blendtime ));
					wait (0.05);
				}
				rain = "light";
			}
			if (rain == "light")
			{
				for (i=0;i<blendtime;i++)
				{
					blend setSoundBlend( lightRain+"_null", lightRain, 1-(i/blendtime) );
					wait (0.05);
				}
			}
		}
		if (change == "light")
		{
			if (rain == "none")
			{
				for (i=0;i<blendtime;i++)
				{
					blend setSoundBlend( lightRain+"_null", lightRain, i/blendtime );
					wait (0.05);
				}
			}
			if (rain == "hard")
			{
				for (i=0;i<blendtime;i++)
				{
					blend setSoundBlend( lightRain+"_null", lightRain, i/blendtime );
					blend2 setSoundBlend( hardRain+"_null", hardRain, 1-(i/blendtime) );
					wait (0.05);
				}
			}
		}

		rain = change;
	}
}

blendDelete(blend)
{
	self waittill ("death");
	blend delete();
}

// MikeD (12/3/2007): Added some debug, incase we forget to actually setup the level._effect[...]
spawnFX_wrapper( fx_id, origin, forward, up, primlightfrac, lightoriginoffs )
{
/#
	assert( IsDefined( level._effect[fx_id] ), "Missing level._effect[\"" + fx_id + "\"]. You did not setup the fx before calling it in createFx." );
#/
	fx_object = SpawnFx( level._effect[fx_id], origin, forward, up, primlightfrac, lightoriginoffs );
	return fx_object;
}