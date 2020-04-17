#include maps\_utility;
#include maps\_createfx;
#include common_scripts\Utility;




print_org (fxcommand, fxId, fxPos, waittime)
{
	if (getdvar("debug") == "1")
	{
		println ("{");
		println ("\"origin\" \"" + fxPos[0] + " " + fxPos[1] + " " + fxPos[2] + "\"");
		println ("\"classname\" \"script_model\"");
		println ("\"model\" \"fx\"");
		println ("\"script_fxcommand\" \"" + fxcommand + "\"");
		println ("\"script_fxid\" \"" + fxId + "\"");
		println ("\"script_delay\" \"" + waittime + "\"");
		println ("}");
	}
}

OneShotfx(fxId, fxPos, waittime, fxPos2)
{


}

OneShotfxthread ( )
{
	maps\_spawner::waitframe();

	
		
	
	if ( !isdefined( level.create_fx_menu ) && isDefined( self.v["targetname"] ))
	{
			self thread create_eventfx();
			return;
	}
	
	
	if ( self.v["delay"] > 0 )
	    wait self.v["delay"];
	    
	if ( isdefined( self.v[ "fire_range" ] ) )
	{
		thread fire_radius( self.v[ "origin" ], self.v[ "fire_range" ] );
	}

	create_triggerfx();
}	    


create_eventfx()
{	
	if (self.v["targetname"] == "fx_OK")
	{
		if ( self.v["delay"] > 0 )
		    wait self.v["delay"];
		
		self.looper = spawnFx( level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"] );	
		triggerFx( self.looper );
		create_loopsound();
	}
	else
	{
		while (1)
		{
			
			level waittill(self.v["targetname"]);
			
			if ( self.v["delay"] > 0 )
				wait self.v["delay"];
		
			
			if (!IsDefined(self.looper))
			{
				
				
				
				self.looper = spawnFx( level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"] );
			}
						
			triggerFx( self.looper );
			
			
			
			
			
			create_loopsound();
		}
	}
}



create_triggerfx()
{
	
	self.looper = spawnFx( level._effect[self.v["fxid"]], self.v["origin"], self.v["forward"], self.v["up"] );
	triggerFx( self.looper );
	create_loopsound();
}


exploderfx(num, fxId, fxPos, waittime, fxPos2, fireFx, fireFxDelay, fireFxSound, fxSound, fxQuake, fxDamage, soundalias, repeat, delay_min, delay_max, damage_radius, fireFxTimeout, exploder_group)
{
	if (1)
	{
		ent = createExploder(fxId);
		ent.v["origin"] = fxPos;
		ent.v["angles"] = (0,0,0);
		if (isdefined(fxPos2))
			ent.v["angles"] = vectortoangles(fxPos2 - fxPos);
		ent.v["delay"] = waittime;
		ent.v["exploder"] = num;
		
		return;	
	}
	fx = spawn ("script_origin", (0,0,0));

	fx.origin = fxPos;
	fx.angles = vectortoangles (fxPos2 - fxPos);

	fx.script_exploder = num;
	fx.script_fxid = fxId;
	fx.script_delay = waittime;
	
	fx.script_firefx = fireFx;
	fx.script_firefxdelay = (fireFxDelay); 
	fx.script_firefxsound = fireFxSound;

	fx.script_sound = fxSound;
	fx.script_earthquake = fxQuake;
	fx.script_damage = (fxDamage);
	fx.script_radius = (damage_radius);
	fx.script_soundalias = soundalias;
	fx.script_firefxtimeout = (fireFxTimeout);
	fx.script_repeat = (repeat);
	fx.script_delay_min = (delay_min);
	fx.script_delay_max = (delay_max);
	fx.script_exploder_group = exploder_group;
	
	forward = anglestoforward (fx.angles);
	forward = vectorScale(forward, 150);
	fx.targetPos = fxPos + forward;
	
	if (!isdefined (level._script_exploders))
		level._script_exploders = [];
	level._script_exploders[level._script_exploders.size] = fx;
	
	maps\_createfx::createfx_showOrigin (fxid, fxPos, waittime, fxpos2, "exploderfx", fx, undefined, fireFx, fireFxDelay, 
	fireFxSound, fxSound, fxQuake, fxDamage, soundalias, repeat, delay_min, delay_max, damage_radius, fireFxTimeout);
}





loopfx(fxId, fxPos, waittime, fxPos2, fxStart, fxStop, timeout)
{
	println("Loopfx is deprecated!");
	ent = createLoopEffect(fxId);
	ent.v["origin"] = fxPos;
	ent.v["angles"] = (0,0,0);
	if (isdefined(fxPos2))
		ent.v["angles"] = vectortoangles(fxPos2 - fxPos);
	ent.v["delay"] = waittime;
}



create_looper()
{
	
	self.looper = playLoopedFx( level._effect[self.v["fxid"]], self.v["delay"], self.v["origin"], 0, self.v["forward"], self.v["up"]);
	create_loopsound();
}

create_loopsound()
{
	self notify( "stop_loop" );
	if ( isdefined( self.v["soundalias"] ) && ( self.v["soundalias"] != "nil" ) )
	{
		if ( isdefined( self.looper ) )
			self.looper thread maps\_utility::loop_fx_sound( self.v["soundalias"], self.v["origin"], "death" );
		else
			thread maps\_utility::loop_fx_sound( self.v["soundalias"], self.v["origin"], "stop_loop" );
	}
}

stop_loopsound()
{
	self notify( "stop_loop" );
}

loopfxthread ()
{
	maps\_spawner::waitframe();




	if (isdefined (self.fxStart))
		level waittill ("start fx" + self.fxStart);

	while (1)
	{
		
		create_looper();
		
		if (isdefined (self.timeout))
			thread loopfxStop(self.timeout);
			
		if (isdefined (self.fxStop))
			level waittill ("stop fx" + self.fxStop);
		else
			return;

		if (isdefined (self.looper))
			self.looper delete();

		if (isdefined (self.fxStart))
			level waittill ("start fx" + self.fxStart);
		else
			return;
	}
}

loopfxChangeID(ent)
{
	self endon ("death");
	ent waittill ("effect id changed", change);
}

loopfxChangeOrg(ent)
{
	self endon ("death");
	for (;;)
	{
		ent waittill ("effect org changed", change);
		self.origin = change;
	}
}

loopfxChangeDelay(ent)
{
	self endon ("death");
	ent waittill ("effect delay changed", change);
}

loopfxDeletion (ent)
{
	self endon ("death");
	ent waittill ("effect deleted");
	self delete();
}

loopfxStop (timeout)
{
	self endon("death");
	wait(timeout);
	self.looper delete();
}

loopSound(sound, Pos, waittime)
{

	level thread loopSoundthread (sound, Pos, waittime);
}

loopSoundthread ( sound, pos, waittime )
{
	org = spawn ("script_origin", (pos));

	org.origin = pos;

	org playLoopSound ( sound );
}

gunfireloopfx(fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
    thread gunfireloopfxthread (fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax);
}

gunfireloopfxthread (fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	level endon ("stop all gunfireloopfx");
	maps\_spawner::waitframe();

	if (betweenSetsMax < betweenSetsMin)
	{
		temp = betweenSetsMax;
		betweenSetsMax = betweenSetsMin;
		betweenSetsMin = temp;
	}

	betweenSetsBase = betweenSetsMin;
	betweenSetsRange = betweenSetsMax - betweenSetsMin;

	if (shotdelayMax < shotdelayMin)
	{
		temp = shotdelayMax;
		shotdelayMax = shotdelayMin;
		shotdelayMin = temp;
	}

	shotdelayBase = shotdelayMin;
	shotdelayRange = shotdelayMax - shotdelayMin;

	if (shotsMax < shotsMin)
	{
		temp = shotsMax;
		shotsMax = shotsMin;
		shotsMin = temp;
	}

	shotsBase = shotsMin;
	shotsRange = shotsMax - shotsMin;

	fxEnt = spawnFx( level._effect[fxId], fxPos );
    for (;;)
    {
		shotnum = shotsBase + randomint (shotsRange);
		for (i=0;i<shotnum;i++)
		{
			triggerFx( fxEnt );

			wait (shotdelayBase + randomfloat (shotdelayRange));
		}
        wait (betweenSetsBase + randomfloat(betweenSetsRange));
    }
}

gunfireloopfxVec(fxId, fxPos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
    thread gunfireloopfxVecthread (fxId, fxPos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax);
}

gunfireloopfxVecthread (fxId, fxPos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	level endon ("stop all gunfireloopfx");
	maps\_spawner::waitframe();

	if (betweenSetsMax < betweenSetsMin)
	{
		temp = betweenSetsMax;
		betweenSetsMax = betweenSetsMin;
		betweenSetsMin = temp;
	}

	betweenSetsBase = betweenSetsMin;
	betweenSetsRange = betweenSetsMax - betweenSetsMin;

	if (shotdelayMax < shotdelayMin)
	{
		temp = shotdelayMax;
		shotdelayMax = shotdelayMin;
		shotdelayMin = temp;
	}

	shotdelayBase = shotdelayMin;
	shotdelayRange = shotdelayMax - shotdelayMin;

	if (shotsMax < shotsMin)
	{
		temp = shotsMax;
		shotsMax = shotsMin;
		shotsMin = temp;
	}

	shotsBase = shotsMin;
	shotsRange = shotsMax - shotsMin;

	fxPos2 = vectornormalize (fxPos2 - fxPos);

	fxEnt = spawnFx ( level._effect[fxId], fxPos, fxPos2 );

	for (;;)
	{
		shotnum = shotsBase + randomint (shotsRange);
		for (i=0;i<int(shotnum/level.fxfireloopmod);i++)
		{
			triggerFx( fxEnt );
			delay =((shotdelayBase + randomfloat (shotdelayRange))*level.fxfireloopmod);
			if(delay < .05)
				delay = .05;
			wait delay;
		}
		wait (shotdelayBase + randomfloat (shotdelayRange));
		wait (betweenSetsBase + randomfloat(betweenSetsRange));
	}
}

setfireloopmod( value )
{
	level.fxfireloopmod = 1/value;
}

setup_fx()
{
	if ((!isdefined (self.script_fxid)) || (!isdefined (self.script_fxcommand)) || (!isdefined (self.script_delay)))
	{





		return;
	}


	if (isdefined (self.model))
		if (self.model == "toilet")
		{
			self thread burnville_paratrooper_hack();
			return;
		}

	org = undefined;
	if (isdefined (self.target))
	{
		ent = getent (self.target,"targetname");
		if (isdefined (ent))
			org = ent.origin;
	}

	fxStart = undefined;
	if (isdefined (self.script_fxstart))
		fxStart = self.script_fxstart;

	fxStop = undefined;
	if (isdefined (self.script_fxstop))
		fxStop = self.script_fxstop;

	if (self.script_fxcommand == "OneShotfx")
		OneShotfx(self.script_fxId, self.origin, self.script_delay, org);
	if (self.script_fxcommand == "loopfx")
		loopfx(self.script_fxId, self.origin, self.script_delay, org, fxStart, fxStop);
	if (self.script_fxcommand == "loopsound")
		loopsound(self.script_fxId, self.origin, self.script_delay);

	self delete();
}

burnville_paratrooper_hack()
{
	normal = (0, 0, self.angles[1]);

	id = level._effect[self.script_fxId];
	origin = self.origin;




	wait 1;
	level thread burnville_paratrooper_hack_loop(normal, origin, id);
	self delete();
}

burnville_paratrooper_hack_loop(normal, origin, id)
{
	while (1)
	{
	

		playfx (id, origin);
		wait (30 +randomfloat (40));
	}
}

script_print_fx()
{
	if ((!isdefined (self.script_fxid)) || (!isdefined (self.script_fxcommand)) || (!isdefined (self.script_delay)))
	{
		println ("Effect at origin ", self.origin," doesn't have script_fxid/script_fxcommand/script_delay");
		self delete();
		return;
	}

	if (isdefined (self.target))
		org = getent (self.target).origin;
	else
		org = "undefined";


	if (self.script_fxcommand == "OneShotfx")
		println ("maps\_fx::OneShotfx(\"" + self.script_fxid + "\", " + self.origin + ", " + self.script_delay + ", " + org + ");");

	if (self.script_fxcommand == "loopfx")
		println ("maps\_fx::LoopFx(\"" + self.script_fxid + "\", " + self.origin + ", " + self.script_delay + ", " + org + ");");

	if (self.script_fxcommand == "loopsound")
		println ("maps\_fx::LoopSound(\"" + self.script_fxid + "\", " + self.origin + ", " + self.script_delay + ", " + org + ");");
}

script_playfx ( id, pos, pos2 )
{
	if (!id)
		return;

	if (isdefined (pos2))
		playfx (id,pos,pos2);
	else
		playfx (id,pos);
}

script_playfxontag ( id, ent, tag )
{
	if (!id)
		return;

	playfxontag (id,ent,tag);
}

GrenadeExplosionfx(pos)
{
	playfx (level._effect["mechanical explosion"], pos);
	earthquake(0.15, 0.5, pos, 250);
	

}


soundfx(fxId, fxPos, endonNotify)
{
	org = spawn ("script_origin",(0,0,0));
	org.origin = fxPos;
	org playloopsound (fxId);
	if (isdefined(endonNotify))
		org thread soundfxDelete(endonNotify);

	
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
	
	

}

rainLoop (hardRain, lightRain)
{

	self endon ("death");
	blend = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	blend.origin = self.origin;
	self thread blendDelete(blend);
	
	blend2 = spawn( "sound_blend", ( 0.0, 0.0, 0.0 ) );
	blend2.origin = self.origin;
	self thread blendDelete(blend2);
	


	blend setSoundBlend( lightRain+"_null", lightRain, 0);
	blend2 setSoundBlend( hardRain+"_null", hardRain, 1);
	rain = "hard";
	blendTime = undefined;
	for (;;)
	{
		level waittill ("rain_change", change, blendTime);
		blendTime *= 20; 
		assert (change == "hard" || change == "light" || change == "none");
		assert (blendtime > 0);
		
		if (change == "hard")
		{
			if (rain == "none")
			{
				blendTime *= 0.5; 
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
				blendTime *= 0.5; 
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


play_igcEffect(noteEntity, playEntity, noteName, effectID, bone, playCount)
{
	
	
	if (playCount == -1)
	{
		while( isdefined(noteEntity) && isdefined(playEntity) )
		{	
			noteEntity waittillmatch( "anim_notetrack", noteName );
			
			playfxontag ( level._effect[effectID], playEntity, bone );
		}
	}
	else
	{
		while( playCount > 0 && isdefined(noteEntity) && isdefined(playEntity) )
		{	
			noteEntity waittillmatch( "anim_notetrack", noteName );
			
			playfxontag ( level._effect[effectID], playEntity, bone );
			playCount--;
		}
	}
	
	
}

quick_kill_fx_on()
{
	auto_createfx_smodels();
	
	
	
	
	
	
	level._effect["qkill_hit_blood_r"] 			= loadfx ("impacts/qkill_hit_blood_r");
	level._effect["qkill_hit_blood1"] 			= loadfx ("impacts/qkill_hit_blood1");
	level._effect["qkill_hit_blood2"] 			= loadfx ("impacts/qkill_hit_blood2");
	level._effect["qkill_hit_sweat1"] 			= loadfx ("impacts/qkill_hit_sweat1");
	
	level._effect["qkill_dust"] 				= loadfx("impacts/qkill_hit_dust");
	
	
	wait_count = 1;
	
	while( !isDefined(level.player) && wait_count < 10 )
	{		
		wait( 0.1 );
		wait_count++;
		
	}	

	
	level thread play_igcEffect(level.player, level.player, "fx_r_wrist_blood", "qkill_hit_blood1", "R_Wrist", -1);
	level thread play_igcEffect(level.player, level.player, "fx_l_wrist_blood", "qkill_hit_blood1", "L_Wrist", -1);
	level thread play_igcEffect(level.player, level.player, "fx_r_wrist_sweat", "qkill_hit_sweat1", "R_Wrist", -1);
	level thread play_igcEffect(level.player, level.player, "fx_l_wrist_sweat", "qkill_hit_sweat1", "L_Wrist", -1);
	level thread play_igcEffect(level.player, level.player, "fx_spinelower_impact", "qkill_dust", "SpineLower", -1);
	level thread play_igcEffect(level.player, level.player, "fx_spinemid_impact", "qkill_dust", "SpineMid", -1);
	level thread play_igcEffect(level.player, level.player, "fx_spineupper_impact", "qkill_dust", "SpineUpper", -1);
	level thread play_igcEffect(level.player, level.player, "fx_head_end_blood", "qkill_hit_blood1", "Head", -1);
	level thread play_igcEffect(level.player, level.player, "fx_head_end_sweat", "qkill_hit_sweat1", "Head", -1);	
	level thread play_igcEffect(level.player, level.player, "qk_front_headbutt_bond_a", "qkill_hit_blood_r", "Head", -1);
}


auto_createfx_smodels()
{
	
	level._effect["cctv_red_light"] = loadfx ("props/cctv_panel_light");
	level._effect["lcd_screen"] 	= loadfx ("misc/mp_glow");

	smodels = getentarray( "script_model","classname" );
	
	
	if (IsDefined(smodels)) 
	{
		for (i = 0; i < smodels.size; i++)
		{
			
			if (smodels[i].model == "p_msc_phone_pickup" )
			{
				
				level thread link_fx_to_ent( smodels[i], "lcd_screen", (0,0,0), (-90,0,0), 1 );
			}
			
			
			
			
		}
	}
}


link_fx_to_ent(ent, effect, offset, rotation, delay)
{
	ent_tag = Spawn("script_model", ent.origin + offset);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = (ent.angles + rotation);
	ent_tag LinkTo(ent);
	
	
	
	if (delay > 0)
	{
		while( isdefined(ent) && isdefined(ent_tag) )
		{					
			PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
			wait( delay );
		}
	}
	else
	{
		PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
	}
}
