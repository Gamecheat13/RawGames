#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\_load::main();
	level.player takeallweapons();
	if (getdvar("debug_angle") == "")
		setdvar("debug_angle", "-1");
	if (getdvar("debug_x") == "")
		setdvar("debug_x", "");
	if (getdvar("debug_y") == "")
		setdvar("debug_y", "");
	if (getdvar("debug_dest_x") == "")
		setdvar("debug_dest_x", "");
	if (getdvar("debug_dest_y") == "")
		setdvar("debug_dest_y", "");
	if (getdvar("debug_running") == "")
		setdvar("debug_running", "");
	if (getdvar("debug_quickkill") == "")
		setdvar("debug_quickkill", "");
	if (getdvar("debug_pose") == "")
		setdvar("debug_pose", "");

	if (getdvar("debug_painreset") != "")
	{
		setdvar("debug_angle", "-1");
		setdvar("debug_x", "");
		setdvar("debug_y", "");
		setdvar("debug_dest_x", "");
		setdvar("debug_dest_y", "");
		setdvar("debug_running", "");
		setdvar("debug_quickkill", "");
		setdvar("debug_tag", "off");
		setdvar("debug_painreset", "");
	}
	else
		setdvar("debug_painreset", "");
	
		
	wait (0.15);	
	println ("--------------");
	println ("^5 Use the dvars debug_angle, debug_x, debug_y, debug_tag, debug_running (on and off)");
	println ("^5 debug_pose, and debug_quickkill (on and off) to customize death");
//	wait (1.25);	
	level.player.ignoreme = true;
	hitme = getent ("hitme","targetname");
	hitme thread shootMe();
}

shootMe()
{
	left = getnode("left","targetname").origin[0];
	bottom = getnode("bottom","targetname").origin[1];
	y = getnode("top","targetname").origin[1] - bottom;
	x = getnode("right","targetname").origin[0] - left;
	
	z = self.origin[2];
	
	for (;;)
	{
		level.lastAngle = -1;
		println (" ");
		xoff = int(randomfloat(x));
		yoff = int(randomfloat(y));
		if (getdvar("debug_x") != "")
			xoff = getdvarint("debug_x");
		if (getdvar("debug_y") != "")
			yoff = getdvarint("debug_y");
		self.origin = (left + xoff, bottom + yoff, z);	
		println ("^5Preparing AI at Origin: ", xoff, "," , yoff);
		
		self.count = 1;
		
		spawn = self stalingradspawn();
		if (spawn_failed(spawn))
		{
			wait (1);
			continue;
		}

		spawn.script_nohealth = true;
		spawn getShot();
		println ("^1DEAD!");
		wait (2);
		level.gun delete();
	}
}

faceAngle()
{
	if (!isdefined (self.faceAngle))
		self.faceAngle = randomint(360);
	if (getdvarint("debug_angle") != -1)
		self.faceAngle = getdvarint("debug_angle");
	
	if (level.lastAngle != self.faceAngle)
		println ("^5Using angle: " , self.faceAngle);
	level.lastAngle = self.faceAngle;
	self OrientMode( "face angle", self.faceAngle );
}

runrun()
{
	self animMode ( "gravity" ); // Unlatch the feet
	self animscripts\run::MoveStandNoncombatNormal();
}


getShot()
{
	self endon ("death");
	self.health = 200;
	self.grenadeammo = 0;
	self.dropWeapon = false;
	
	/*
	model = spawn("script_model",(0,0,0));
	model setmodel("xmodel/temp");
	model linkto (self, "J_Head", (0,0,0), (0,0,0));	
	*/

	set_all_exceptions(maps\pain::faceAngle);
	level.gun = spawn("script_model",(0,0,0));
	level.gun.origin = getent("gun","targetname").origin;
//	level.gun setmodel("xmodel/temp");
	start = level.gun.origin;
	
	tags = getTags();
	tags = array_randomize(tags);
	index = 0;
	
	pose = "stand";
	if ( randomint(2) == 0 )
		pose = "crouch";
	if ( randomint(6) == 0 )
		pose = "prone";
	
	if ( getdvar("debug_pose") != "" )
		pose = getdvar("debug_pose");
	
	self allowedStances( pose );
	
	for (;;)
	{
/*
		x = randomfloat(64) - 32;
		z = randomfloat(64) + 8;
		end = self.origin + (x, 500, z);
		for (;;)
		{
			x = randomfloat(64) - 32;
			z = randomfloat(64) + 8;
			end = self.origin + (x, 500, z);
			wait (0.05);
			trace = bulletTrace(start, end, true, level.player);
//			line (start, end, (0,0.3,1), 1);
			if (!isalive(trace["entity"]))
				continue;
			if (trace["entity"] != self)
				continue;
				
			angles = vectorToAngles(start, end);
			forward = anglesToForward(angles);
			forward = vectorScale(forward, 5);
			gun.origin = trace["position"] + forward;
			gun linkto (self);
			println ("entity " + trace["entity"].classname);
			break;
		}
*/
		index++;
		if (index >= tags.size)
			index = 0;
		println ("^5Shooting tag: ^7" + tags[index]);
		
		angles = (0,randomint(360),0);
		forward = anglesToForward(angles);
		back = vectorScale(forward, -32);
		forward = vectorScale(forward, 1000);
		end = self.origin + forward;
		trace = bulletTrace(self.origin + (0,0,8), end + (0,0,8), false, self);
		dest = trace["position"] + back;
		dest_x = int(dest[0]);
		dest_y = int(dest[1]);
		dest_z = self.origin[2];
		if (getdvar("debug_dest_x") != "" && getdvar("debug_dest_y") != "")
		{
			dest_x = getdvarint("debug_dest_x");
			dest_y = getdvarint("debug_dest_y");
		}
		
		run = (randomint(100) > 50);
		if ( pose != "stand" )
			run = false;
		if (getdvar("debug_running") == "on")
			run = true;
		if (getdvar("debug_running") == "off")
			run = false;
		
		quickKill = (randomint(100) > 50);
		if (getdvar("debug_quickkill") == "on")
			quickKill = true;
		if (getdvar("debug_quickkill") == "off")
			quickKill = false;

		runVar = "Yes";
		if (!run)
			runVar = "No";
		quickKillVar = "Yes";
		if (!quickKill)
			quickKillVar = "No";
		
		if (run)
			println ("^5Run: ^7" + runVar + " ^5to ^7" + dest_x + "," + dest_y + "   ^5Pose: ^7" + pose + "   ^5One Hit Kill: ^7" + quickKillVar);
		else
			println ("^5Run: ^7" + runVar + "   ^5Pose: ^7" + pose + "   ^5One Hit Kill: ^7" + quickKillVar);

		tag = tags[index];
		/#
		if (getdvar("debug_tag") != "off" && getdvar("debug_tag") != "")
			tag = getdvar("debug_tag");
		#/
		
		println ("Tag is " + tag);
		
		level.gun linkto (self, tag, (0,0,0), (0,0,0));	
		level.gun thread laserSight(start);
		set_all_exceptions(maps\pain::faceAngle);
	
		if (run)
		{
//			setexceptions(maps\pain::runrun);
//			self thread runrun();
			wait (1);
			self setgoalpos ((dest_x, dest_y, dest_z));
			self.goalradius = 64;
			wait (1);
		}
		else
			wait (2);
		
		if (quickKill)
		{
			for (;;)
			{
				self.health = 1;
				magicbullet("ak47", start, level.gun.origin);
				wait (1);
			}
		}
		else
		{
			self.health = 150;
			for (;;)
			{
				magicbullet("ak47", start, level.gun.origin);
				wait ( randomfloatrange(0.25, 1 ) );
			}
		}
	}	
}

laserSight(start)
{
	level notify ("new laser");
	level endon ("new laser");
	self endon ("death");
	for (;;)
	{
		trace = bulletTrace(start, self.origin, true, undefined);
		angles = vectorToAngles(start - self.origin);
		forward = anglesToForward(angles);
		forward = vectorScale(forward, -3);
		end = trace["position"] + forward;
		line (start, end, (0.7 +randomfloat(0.2999), randomfloat(0.3), randomfloat(0.2)), 1);
		wait (0.05);
	}
}

getTags()
{
	tags = [];
	tags[tags.size] = "J_CoatFront_LE";
	tags[tags.size] = "J_CoatFront_RI";
	tags[tags.size] = "J_WristTwist_RI";
	tags[tags.size] = "J_WristTwist_LE";
	tags[tags.size] = "J_Wrist_RI";
	tags[tags.size] = "J_Wrist_LE";
	tags[tags.size] = "J_ShoulderTwist_RI";
	tags[tags.size] = "J_ShoulderTwist_LE";
	tags[tags.size] = "J_Elbow_RI";
	tags[tags.size] = "J_Elbow_LE";
	tags[tags.size] = "J_Elbow_Bulge_RI";
	tags[tags.size] = "J_Elbow_Bulge_LE";
	tags[tags.size] = "J_Shoulder_RI";
	tags[tags.size] = "J_Shoulder_LE";
	tags[tags.size] = "J_Head";
	tags[tags.size] = "TAG_WEAPON_CHEST";
	tags[tags.size] = "J_ShoulderRaise_RI";
	tags[tags.size] = "J_ShoulderRaise_LE";
	tags[tags.size] = "J_Neck";
	tags[tags.size] = "J_Clavicle_RI";
	tags[tags.size] = "J_Clavicle_LE";
	tags[tags.size] = "J_Ball_RI";
	tags[tags.size] = "J_Ball_LE";
	tags[tags.size] = "J_Spine4";
	tags[tags.size] = "J_Knee_Bulge_RI";
	tags[tags.size] = "J_Knee_Bulge_LE";
	tags[tags.size] = "J_Ankle_RI";
	tags[tags.size] = "J_Ankle_LE";
	tags[tags.size] = "J_SpineUpper";
	tags[tags.size] = "J_Knee_RI";
	tags[tags.size] = "J_Knee_LE";
	tags[tags.size] = "J_HipTwist_RI";
	tags[tags.size] = "J_HipTwist_LE";
	tags[tags.size] = "J_SpineLower";
	tags[tags.size] = "J_Hip_RI";
	tags[tags.size] = "J_Hip_LE";
	tags[tags.size] = "J_CoatRear_RI";
	tags[tags.size] = "J_CoatRear_LE";
	tags[tags.size] = "J_MainRoot";
	return tags;
}
