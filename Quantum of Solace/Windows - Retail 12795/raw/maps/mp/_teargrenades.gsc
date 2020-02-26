main()
{
	level.tearradius = 240;
	level.tearheight = 128;
	level.teargasfillduration = 10; // time until gas fills the area specified
	level.teargasduration = 18; // duration gas remains in area
	level.tearsufferingduration = 2; // (duration after leaving area of effect)
	
	level.teargrenadetimer = 2; // should match time to appearance of effect
	
	// Tear grenade damage scales between these two values:
	level.teargrenadedamageatcenter = 25; // Damage per interval, if you're at the center.
	level.teargrenadedamageatedge = 10; // Damage per interval, if you're at the edge.
	
	level.teargrenadedamageinterval = 0.75; // Damage is applied once per second if you are inside the radius.
	
	precacheShellShock("teargas");
	
	fgmonitor = maps\mp\gametypes\_perplayer::init("tear_grenade_monitor", ::startMonitoringTearUsage, ::stopMonitoringTearUsage);
	maps\mp\gametypes\_perplayer::enable(fgmonitor);
}

startMonitoringTearUsage()
{
	self thread monitorTearUsage();
}

stopMonitoringTearUsage(disconnected)
{
	self notify("stop_monitoring_tear_usage");
}

monitorTearUsage()
{
	self endon("stop_monitoring_tear_usage");

	while( 1 )
	{
		self waittill( "teargas", tear_position );

		ent = spawnstruct();
		ent thread tear( tear_position, self );
	}
}

tear(pos, playersource)
{
	self.pos = pos;
	self.playersource = playersource;
	trig = spawn("trigger_radius", pos, 0, level.tearradius, level.tearheight);
	
	//thread drawcylinder(pos, level.tearradius, level.tearheight);
	
	starttime = gettime();
	
	self thread teartimer();
	//self thread teardamage();
	self endon("tear_timeout");
	
	while(1)
	{
		trig waittill("trigger", player);
		
		if ( isDefined( player.sessionstate ) && player.sessionstate != "playing")
			continue;
		
		time = (gettime() - starttime) / 1000;
		
		currad = level.tearradius;
		curheight = level.tearheight;
		if (time < level.teargasfillduration) {
			currad = currad * (time / level.teargasfillduration);
			curheight = curheight * (time / level.teargasfillduration);
		}
		
		offset = (player.origin + (0,0,32)) - pos;
		offset2d = (offset[0], offset[1], 0);
		if (lengthsquared(offset2d) > currad*currad)
			continue;
		if (player.origin[2] - pos[2] > curheight)
			continue;	
		
		player.teargasstarttime = gettime(); // purposely overriding old value
		if (!isdefined(player.teargassuffering))
			player thread teargassuffering();
	}
}
teartimer()
{
	wait level.teargasduration;
	self notify("tear_timeout");
}

/*teardamage()
{
	self.playersource endon("disconnect");
	teargaselapsed = 0;
	while ( teargaselapsed < level.teargasduration )
	{
		if ( isDefined( self.playersource ) && !isRemovedEntity( self.playersource ) )
		{
			
			self.pos2 = self.pos + (0,0,1);
						
			radiusdamage( self.pos2, level.tearradius, level.teargrenadedamageatcenter, level.teargrenadedamageatedge, self.playersource, "MOD_EXPLOSIVE", "tear_grenade_mp"  );
		}
		wait level.teargrenadedamageinterval;
		teargaselapsed += level.teargrenadedamageinterval;
	}
}*/

teargassuffering()
{
	self endon("death");
	self endon("disconnect");
	
	self.teargassuffering = true;
	
	self shellshock("teargas", 60);
	
	while(1)
	{
		if (gettime() - self.teargasstarttime > level.tearsufferingduration * 1000)
			break;
		
		wait 1;
	}
	
	self shellshock("teargas", 1);
	
	self.teargassuffering = undefined;
}

drawcylinder(pos, rad, height)
{
	time = 0;
	while(1)
	{
		currad = rad;
		curheight = height;
		if (time < level.teargasfillduration) {
			currad = currad * (time / level.teargasfillduration);
			curheight = curheight * (time / level.teargasfillduration);
		}
		
		for (r = 0; r < 20; r++)
		{
			theta = r / 20 * 360;
			theta2 = (r + 1) / 20 * 360;
			
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta2) * currad, sin(theta2) * currad, 0));
			line(pos + (cos(theta) * currad, sin(theta) * currad, curheight), pos + (cos(theta2) * currad, sin(theta2) * currad, curheight));
			line(pos + (cos(theta) * currad, sin(theta) * currad, 0), pos + (cos(theta) * currad, sin(theta) * currad, curheight));
		}
		time += .05;
		if (time > level.teargasduration)
			break;
		wait .05;
	}
}