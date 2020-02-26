#include maps\mp\_utility;


create(team, phoneWeapon)
{
	cinematic = spawnstruct();

	if( isDefined(team) )
		cinematic.team = team;

	cinematic.phone = isDefined(phoneWeapon);
	cinematic.phoneWeapon = phoneWeapon;
	cinematic.duration = 0;
	cinematic.frames = [];
	cinematic.cameras = [];
	cinematic.allowexit = false;
	return cinematic;
}


allowexit(allowed)
{
	self.allowexit = allowed;
}


extend(frame, duration)
{
	if( self.duration < frame + duration )
		self.duration = frame + duration;
}


getframe(time)
{
	if( !isDefined(self.frames[time]) )
	{
		self.frames[time] = spawnstruct();
		self.frames[time].time = time;
	}

	return self.frames[time];
}


kf_setclientdvar(time, dvar, val)
{
	extend(time, 0);
	frame = getframe(time);
	frame.dvar_name = dvar;
	frame.dvar_val = val;
}


kf_setVision(time, vision, duration)
{
	extend(time, duration);
	frame = getframe(time);
	frame.vision_name = vision;
	frame.vision_duration = duration;
}


kf_setOverlay(time, overlay, duration)
{
	extend(time, duration);
	frame = getframe(time);
	frame.show_overlay[overlay] = duration;
}


kf_hideOverlay(time, overlay, duration)
{
	extend(time, duration);
	frame = getframe(time);
	frame.hide_overlay[overlay] = duration;
}


kf_lerptospin(time, duration)
{
	extend(time, duration);
	frame = getframe(time);
	frame.lerptospin = duration;
}


kf_spinin(time, duration)
{
	extend(time, duration);
	frame = getframe(time);
	frame.spinin = duration;
}


kf_camera(time, origin, angles, duration)
{
	extend(time, duration);
	frame = getframe(time);
	frame.cam_origin = origin;
	frame.cam_angles = angles;
	frame.cam_duration = duration;
}


kf_dialog(time, text)
{
	extend(time, 0);
	frame = getframe(time);
	frame.text = text;
}


getsortedkeys(array)
{
	keys = getarraykeys(array);
	sorted = [];
	for(i=0; i<keys.size; i++)
	{
		val = keys[i];
		idx = 0;
		for( ; (idx < sorted.size) && (val > sorted[idx]); idx++ ) {}

		for( j=sorted.size-1; j>=idx; j-- )
		{
			sorted[j+1] = sorted[j];
		}

		sorted[idx] = val;
	}

	return sorted;
}


checkMovement(origin, angles)
{
	player = self;

	player endon( "disconnect" );
	player endon( "cinematic_ending" );
	player endon( "cinematic_cancelled" );

	for(;;)
	{
		wait(0.05);

		if( player.origin != origin )
			break;

		if( self attackButtonPressed() || self fragButtonPressed() || self secondaryOffhandButtonPressed() )
			break;

//		if( player.angles != angles )
//			break;
	}

	player notify("movement");
}


checkCancel(cinematic)
{
	player = self;

	player endon( "disconnect" );
	player endon( "cinematic_ending" );

	origin = player.origin;
	angles = player.angles;

	wait(2.0);

	if( cinematic.phone )
	{
		weapon = player getCurrentWeapon();
		if( weapon == cinematic.phoneWeapon )
		{
			player thread checkMovement(origin, angles);
			player waittill_any_mp("bullethit", "begin_firing", "weapon_change", "movement");
		}
		else
		{
			// player has already switched weapons, so fall through to cinematic end
		}
	}
	else
	{
		player thread checkMovement(origin, angles);
		player waittill("movement");
	}

	player notify( "cinematic_cancelled" );
	player playLocalSound("NULL_VO");
	cleanup(cinematic);
}


hackresetspawnweapon(weapon)
{
	wait 0.05;
	self setspawnweapon(weapon, true);
}


playOnClient(cinematic)
{
	player = self;

	player endon( "disconnect" );
	player endon( "cinematic_cancelled" );

	waittillframeend;

	keys = getsortedkeys(cinematic.frames);

	player setClientDvar( "ui_hud_showGPS", "0" );
	player setClientDvar( "ui_hud_showscore", "0" );
	player setClientDvar( "ui_hud_showweaponinfo", "0" );
	player setClientDvar( "ui_hud_showstanceicon", "0" );
	player setClientDvar( "ui_3dwaypointtext", "0" );

	if( isDefined(cinematic.camera) )
		player setcamera(cinematic.camera, cinematic.phone);

	player.pre_cinematic_weapon = undefined;
	if( cinematic.phone )
	{
		player.pre_cinematic_weapon = player getCurrentWeapon();
		player GiveWeapon( cinematic.phoneWeapon );
		player SwitchToWeapon( cinematic.phoneWeapon );

		// if not setSpawnWeapon, on 2nd round player will not have phone
		player setSpawnWeapon( cinematic.phoneWeapon );
		player thread hackresetspawnweapon(player.pre_cinematic_weapon);
	}

	if( cinematic.allowexit )
		player thread checkCancel(cinematic);
	else
		player freezeControls( true );

	for(k=0; k<keys.size; k++)
	{
		frame = cinematic.frames[keys[k]];
		elapsed = gettime() - cinematic.starttime;
		deltat = frame.time - elapsed / 1000;

		if( deltat > 0 )
		{
			wait(deltat);

			elapsed = gettime() - cinematic.starttime;
			deltat = frame.time - elapsed / 1000;
		}

		if( isDefined(frame.dvar_name) )
		{
			player setclientdvar(frame.dvar_name, frame.dvar_val);
		}

		if( isDefined(frame.show_overlay) && !cinematic.phone )
		{
			okeys = getarraykeys(frame.show_overlay);
			for(o=0; o<okeys.size; o++)
			{
				name = okeys[o];

				if( !isDefined(player.overlays) || !isDefined(player.overlays[name]) )
				{
					player.overlays[name] = newclienthudelem(player);
					player.overlays[name].x = 0;
					player.overlays[name].y = 0;
					player.overlays[name] setshader(name, 640, 480);
					player.overlays[name].alignX = "left";
					player.overlays[name].alignY = "top";
					player.overlays[name].horzAlign = "fullscreen";
					player.overlays[name].vertAlign = "fullscreen";
					player.overlays[name].alpha = 0;
				}

				duration = frame.show_overlay[name] + deltat;
				if( duration > 0 )
					player.overlays[name] fadeOverTime(duration);
				player.overlays[name].alpha = 1;
			}
		}

		if( isDefined(frame.hide_overlay) && !cinematic.phone )
		{
			okeys = getarraykeys(frame.hide_overlay);
			for(o=0; o<okeys.size; o++)
			{
				name = okeys[o];
				duration = frame.hide_overlay[name] + deltat;
				if( duration > 0 )
					player.overlays[name] fadeOverTime(duration);
				player.overlays[name].alpha = 0;
			}
		}

		closeEnough = true;

		if( deltat < -1 )
			closeEnough = false;
		else if( deltat > 1 )
			closeEnough = false;

		if( frame.time == 0 )
			closeEnough = true;

		if( isDefined(frame.text) && closeEnough )
		{
			player playLocalSound(frame.text);
		}

		if( isDefined(frame.lerptospin) && !cinematic.phone )
		{
			duration = frame.lerptospin + deltat;
			camera = undefined;

			if( !isDefined(cinematic.cameras[player.name]) )
			{
				camera = spawn("script_origin", (0,0,0));
				camera.origin = cinematic.camera.origin;
				camera.angles = cinematic.camera.angles;
				camera setbroadcast();
				player setcamera(camera, cinematic.phone);

				cinematic.cameras[player.name] = camera;
			}
			else
			{
				camera = cinematic.cameras[player.name];
			}

			angles = player getplayerangles();

			angles = combineangles(angles, (0, 180, 0));
			vec = anglestoforward(angles);

			origin = player gettagorigin("tag_camera") - ( getDvarFloat("cg_spinin_distance") * vec );
			angles = vectortoangles(vec);

			if( duration > 0 )
			{
				camera moveTo(origin, duration, 0, duration/4);
				camera rotateTo(angles, duration, 0, duration/4);
			}
			else
			{
				camera.origin = origin;
				camera.angles = angles;
			}
		}

		if( isDefined(frame.spinin) )
		{
			duration = frame.spinin + deltat;

			if( duration > 0 )
			{
				player spinin(gettime() + int(duration * 1000));
			}
		}
	}

	player notify ("cinematic_ending");

	cleanup(cinematic);
}


cleanup(cinematic)
{
	player = self;

	if( isDefined(self.overlays) )
	{
		keys = getsortedkeys(self.overlays);
		for(k=0; k<keys.size; k++)
		{
			player.overlays[ keys[k] ] destroy();
		}
		self.overlays = undefined;
	}

	if( !cinematic.allowexit )
		player freezeControls( false );

	player notify("cinematic_over");
	//if( cinematic.phone )
	//	player TakeWeapon(cinematic.phoneWeapon);

	player setClientDvar( "ui_hud_showGPS", "1" );
	player setClientDvar( "ui_hud_showscore", "1" );
	player setClientDvar( "ui_hud_showweaponinfo", "1" );
	player setClientDvar( "ui_hud_showstanceicon", "1" );
	player setClientDvar( "ui_3dwaypointtext", "1" );

	// if player is holding grenade throw wait until he throws
	while( player fragButtonPressed() || player secondaryOffhandButtonPressed() )
	{
		wait 0.05;
	}

	weapon = player getCurrentWeapon();
	if( isDefined(player.pre_cinematic_weapon) && player.pre_cinematic_weapon != "none" /*&& weapon == cinematic.phoneWeapon*/ )
	{
		player SwitchToWeapon( player.pre_cinematic_weapon );
		player.pre_cinematic_weapon = undefined;
	}

	if( cinematic.phone )
	{
		// don't clear the camera immediately, as it take some time to put away
		wait(2);
	}

	player setcamera();
}



playOnLevel(cinematic)
{
	keys = getsortedkeys(cinematic.frames);

	for(k=0; k<keys.size; k++)
	{
		frame = cinematic.frames[keys[k]];
		elapsed = gettime() - cinematic.starttime;
		deltat = frame.time - elapsed / 1000;

		if( deltat > 0 )
		{
			wait(deltat);

			elapsed = gettime() - cinematic.starttime;
			deltat = frame.time - elapsed / 1000;
		}


		if( isDefined(frame.cam_origin) )
		{
			if( frame.cam_duration > 0 )
				cinematic.camera moveTo(frame.cam_origin, frame.cam_duration, 0, frame.cam_duration/5);
			else
				cinematic.camera.origin = frame.cam_origin;
		}

		if( isDefined(frame.cam_angles) )
		{
			if( frame.cam_duration > 0 )
				cinematic.camera rotateTo(frame.cam_angles, frame.cam_duration, 0, frame.cam_duration/5);
			else
				cinematic.camera.angles = frame.cam_angles;
		}

		if( isDefined(frame.vision_name) && !cinematic.phone )
		{
			if( cinematic.team == "allies" )
				visionSetAllied(frame.vision_name, frame.vision_duration);
			else if( cinematic.team == "axis" )
				visionSetAxis(frame.vision_name, frame.vision_duration);
			else
				visionSetNaked(frame.vision_name, frame.vision_duration);
		}
	}
}


init()
{
	keys = getsortedkeys(self.frames);
	for(k=0; k<keys.size; k++)
	{
		frame = self.frames[ keys[k] ];

		if( isDefined(frame.cam_origin) && !isDefined(self.camera) )
		{
			self.camera = spawn("script_origin", (0,0,0));
			self.camera setnobaseline();
			self.camera setbroadcast();
		}
	}

	self.starttime = gettime();

	level.introPlaying[self.team] = self;
	level.cinematicEndTime[self.team] = gettime() + int(self.duration * 1000);
}


shutdown()
{
	wait(self.duration + 0.05);

	level.cinematicEndTime[self.team] = undefined;
	level.introPlaying[self.team] = undefined;

	if( isDefined(self.camera) )
	{
		self.camera delete();
		self.camera = undefined;
	}

	keys = getarraykeys( self.cameras );
	for(k=0; k<keys.size; k++)
	{
		self.cameras[ keys[k] ] delete();
	}
	self.cameras = [];

	self.starttime = undefined;
}


play()
{
	init();

	level thread playOnLevel(self);

	players = getentarray("player", "classname");
	for(i=0; i<players.size; i++)
	{
		player = players[i];
		if( player.pers["team"] == self.team )
		{
			player thread playOnClient(self);
		}
	}

	self thread shutdown();

	return self.duration;
}


addClient(player)
{
	if( !isDefined(level.introPlaying) || !isDefined(level.introPlaying[player.pers["team"]]) )
		return;

	cinematic = level.introPlaying[player.pers["team"]];
	player thread playOnClient(cinematic);
}


waitForCinematic(team)
{
	if( isDefined(level.cinematicEndTime) && isDefined(level.cinematicEndTime[team]) && level.cinematicEndTime[team] > gettime() )
	{
		self waittill("cinematic_over");
	}
}


isPlaying(team)
{
	if( isDefined(level.cinematicEndTime) && isDefined(level.cinematicEndTime[team]) && level.cinematicEndTime[team] > gettime() )
	{
		return true;
	}
	else
	{
		return false;
	}
}
