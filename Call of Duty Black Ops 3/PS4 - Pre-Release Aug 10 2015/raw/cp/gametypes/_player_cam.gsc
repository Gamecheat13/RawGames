#using scripts\shared\abilities\_ability_power;
#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_weapon_utils;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\clientfield_shared;

#using scripts\shared\flag_shared;

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_loadout;
#using scripts\cp\gametypes\_deathicons;
#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_spawn;
#using scripts\cp\gametypes\_globallogic_ui;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_globallogic_vehicle;
#using scripts\cp\gametypes\_killcam;
#using scripts\cp\gametypes\_save;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\cp\gametypes\_spectating;
#using scripts\cp\gametypes\_weapon_utils;
#using scripts\cp\gametypes\_weapons;
#using scripts\shared\lui_shared;

#using scripts\shared\_burnplayer;
#using scripts\cp\_challenges;
#using scripts\cp\_flashgrenades;
#using scripts\cp\_gamerep;
#using scripts\cp\_hazard;
#using scripts\cp\_laststand;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\_vehicle;
#using scripts\cp\killstreaks\_killstreak_weapons;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_straferun;
#using scripts\cp\teams\_teams;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\_bb;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace cp_player_cam;

function autoexec main()
{
	//bubbles
	clientfield::register( "toplayer", "player_cam_bubbles", 1, 1, "int" );

	//fire
	clientfield::register( "toplayer", "player_cam_fire_init", 1, 1, "int" );
	clientfield::register( "toplayer", "player_cam_fire", 1, 7, "float" );
}

function Apply_FirstPerson_Player_Cam(eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon("disconnect");
	
	if(GetDvarInt("test_cam") > 0)
	{
		value = GetDvarInt("test_cam");
		
		if(value == 1)
		{
			sMeansOfDeath = "MOD_BULLET";
		}
		else if(value == 2)
		{
			sMeansOfDeath = "MOD_EXPLOSIVE";
		}
		else if(value == 3)
		{
			sMeansOfDeath = "MOD_BURNED";
		}
		else if(value == 4)
		{
			sMeansOfDeath = "MOD_DROWN";
		}
	}
	
	if(sMeansOfDeath === "MOD_EXPLOSIVE" ||
	        sMeansOfDeath === "MOD_PROJECTILE" ||
	        sMeansOfDeath === "MOD_PROJECTILE_SPLASH" ||
	       	sMeansOfDeath === "MOD_GRENADE" ||
	       	sMeansOfDeath === "MOD_GRENADE_SPLASH"
	       )
	{
		self thread FirstPerson_Player_Cam_Explosion(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc);
	}
	else if(sMeansOfDeath === "MOD_BULLET" || sMeansOfDeath === "MOD_RIFLE_BULLET")
	{
		self thread FirstPerson_Player_Cam_Bullet(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc);
	}
	else if(sMeansOfDeath === "MOD_BURNED")
	{
		self thread FirstPerson_Player_Cam_Burned(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc);
	}
	else if(sMeansOfDeath === "MOD_DROWN")
	{
		self thread FirstPerson_Player_Cam_Bubbles(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc);
	}
	else if(isdefined(attacker) && attacker.classname == "trigger_hurt" && isdefined(attacker.script_noteworthy) && attacker.script_noteworthy == "fall_death")
	{
		self thread FirstPerson_Player_Cam_Fall(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc);
	}
	else if(sMeansOfDeath === "MOD_MELEE")
	{
		self thread FirstPerson_Player_Cam_Melee(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc);
	}
	else
	{
		self thread FirstPerson_Player_Cam_Suicide(eInflictor, attacker, iDamage, weapon, undefined, sHitLoc);
	}
}

function Is_Valid_new_Pos(old_position, new_position)
{
	size = 10;
	height = size * 2;
	mins = (-1 * size, -1 * size, 0 );
	maxs = ( size, size, height );
	
	trace = physicstrace( old_position, new_position, mins, maxs, self);

	if ( trace["fraction"] < 1 )
	{
		return false;
	}
	
	return true;
}

function MoveCamera( vDir, tweenSpeed, max_f_length, max_z_length, position_f_speed, position_z_speed, cameraPitch, cameraRoll)
{
	self endon("disconnect");
	self endon("camera_move_done");
	
	original_position = self GetPlayerCameraPos();
	position = original_position;
	
	angles = self GetPlayerAngles();
	angles = ( 0, AbsAngleClamp360(angles[1]), AbsAngleClamp360(angles[2]) );
	
	forwardDir = anglesToForward(angles);
	vector = position + forwardDir;
	
	self CameraSetPosition(position);
	self CameraSetLookAt(vector);
	self CameraActivate( true );
	
////////set parameters
	if(isdefined(vDir))
	{
		vDir = (-vDir[0], -vDir[1], -vDir[2]);
		target_angles = VectorToAngles(vDir);
	}
	else
	{
		vDir = (forwardDir[0], forwardDir[1], forwardDir[2]);
		target_angles = VectorToAngles(vDir);
		
		vDir = (forwardDir[0], forwardDir[1], -1);
		vDir = VectorNormalize(vDir);
	}
	
	
	if(!isdefined(cameraPitch))
	{
		cameraPitch = AbsAngleClamp360(target_angles[0]);
	}
	
	if(!isdefined(cameraRoll))
	{
		cameraRoll = AbsAngleClamp360(target_angles[2]);
	}
	
	target_angles = (cameraPitch, AbsAngleClamp360(target_angles[1]), cameraRoll);
	
	if(tweenSpeed > 0)
	{
		self StartCameraTween( tweenSpeed );
	}
	
	if(isdefined(max_f_length) && vDir[0] != 0)
	{
		b_position_f = false;
	}
	else
	{
		b_position_f = true;
	}
	
	if(isdefined(max_z_length) && vDir[2] != 0)
	{
		b_position_z = false;
	}
	else
	{
		b_position_z = true;
	}
	
	
////////set camera angles
	angles = (AbsAngleClamp360(target_angles[0]), AbsAngleClamp360(target_angles[1]), AbsAngleClamp360(target_angles[2]));
	self CameraSetAngles(target_angles);
	
	
///////logic
	forwardVec = (vDir[0], vDir[1], 0);
	forwardVec = VectorNormalize(forwardVec);

	while(!(( isdefined( b_position_f ) && b_position_f ) && ( isdefined( b_position_z ) && b_position_z )))
	{
		if(!( isdefined( b_position_f ) && b_position_f ))
		{
			added_vect = VectorScale(forwardVec, position_f_speed);
			added_length = Length(added_vect);
	
			diff_forward_pos = position - original_position;
			
			current_forward_length = Length( (diff_forward_pos[0], diff_forward_pos[1], 0) );
			
			if((current_forward_length + added_length) >= max_f_length)
			{
				added_length = max_f_length - current_forward_length;
				b_position_f = true;
			}
			
			new_position = position - VectorScale(forwardVec, added_length);
			
			if(Is_Valid_new_Pos(position, new_position))
			{
				position = new_position;
				self CameraSetPosition(position, angles);
			}
			else
			{
				b_position_f = true;
			}
		}

		
		if(!( isdefined( b_position_z ) && b_position_z ))
		{
			subtracted_height = position_z_speed;
			
			current_z_length = abs(original_position[2] - position[2]);
			
			if((current_z_length + subtracted_height) >= max_z_length)
			{
				subtracted_height = max_z_length - current_z_length;
				b_position_z = true;
			}
			
			new_position = (position[0], position[1], position[2] - subtracted_height);
			
			if(Is_Valid_new_Pos(position, new_position))
			{
				position = new_position;
				self CameraSetPosition(position, angles);
			}
			else
			{
				b_position_z = true;
			}
		}
		
		wait 0.05;
	}
}

function FirstPerson_Player_Cam_Bullet(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
	
	SetDvar("r_blurAndTintEnable", true);
	
	//values
	position_z_speed = GetDvarFloat("cam_bullet_position_z_speed", 8);
	position_f_speed = GetDvarFloat("cam_bullet_position_f_speed", 10);
	
	max_z_length = GetDvarFloat("cam_bullet_max_z_length", 50);
	max_f_length = GetDvarFloat("cam_bullet_max_f_length", 50);
	
	end_wait = GetDvarFloat("cam_bullet_end_wait", 2);
	
	MoveCamera(vDir, 0.2, max_f_length, max_z_length, position_f_speed, position_z_speed, undefined, 40);
	self PlayRumbleOnEntity( "damage_heavy" );
	
	wait end_wait;
	
	self notify("cp_playercam_ended");
}

function FirstPerson_Player_Cam_Melee(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
	
	SetDvar("r_blurAndTintEnable", true);
	
	//values
	position_z_speed = GetDvarFloat("cam_bullet_position_z_speed", 8);
	position_f_speed = GetDvarFloat("cam_bullet_position_f_speed", 10);
	
	max_z_length = GetDvarFloat("cam_bullet_max_z_length", 50);
	max_f_length = GetDvarFloat("cam_bullet_max_f_length", 50);
	
	end_wait = GetDvarFloat("cam_bullet_end_wait", 2);
	
	self PlayRumbleOnEntity( "damage_heavy" );
	MoveCamera(vDir, 0.2, max_f_length, max_z_length, position_f_speed, position_z_speed, undefined, 40);
	
	wait end_wait;
	
	self notify("cp_playercam_ended");
}

function FirstPerson_Player_Cam_Suicide(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
	
	SetDvar("r_blurAndTintEnable", true);
	
	velocity = self GetVelocity();
	
	//values
	position_z_speed = GetDvarFloat("cam_bullet_position_z_speed", 8);
	position_f_speed = GetDvarFloat("cam_bullet_position_f_speed", 10);
	
	max_z_length = GetDvarFloat("cam_bullet_max_z_length", 50);
	max_f_length = GetDvarFloat("cam_bullet_max_f_length", 50);
	
	end_wait = GetDvarFloat("cam_bullet_end_wait", 2);
	
	MoveCamera(undefined, 0.2, max_f_length, max_z_length, position_f_speed, position_z_speed, undefined, 40);
	self PlayRumbleOnEntity( "damage_heavy" );
	
	wait end_wait;
	
	self notify("cp_playercam_ended");
}


function FirstPerson_Player_Cam_Explosion(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
		
	//values
	position_z_speed = GetDvarFloat("cam_explosion_position_z_speed", 8);
	position_f_speed = GetDvarFloat("cam_explosion_position_f_speed", 10);
	
	max_z_length = GetDvarFloat("cam_explosion_max_z_length", 50);
	max_f_length = GetDvarFloat("cam_explosion_max_f_length", 100);
	
	pitch_angle1 = GetDvarFloat("cam_explosion_pitch_angle1", -30);
	pitch_angle2 = GetDvarFloat("cam_explosion_pitch_angle2", -20);
	
	shake_vector_max = GetDvarFloat("cam_explosion_shake_vector_max", 1);
	

	second_fade_value = GetDvarFloat("cam_explosion_fade_value", 0);
	first_fade_time = GetDvarFloat("cam_explosion_first_fade_time", 0.4);
	second_fade_time = GetDvarFloat("cam_explosion_second_fade_time", 0.4);
	
	first_wait = GetDvarFloat("cam_explosion_first_wait", 0.8);
	second_wait = GetDvarFloat("cam_explosion_second_wait", 2);
	
	self thread lui::screen_fade( first_fade_time, 1, 0, "black" );
	
	//Move camera
	MoveCamera(vDir, 0.2, max_f_length, max_z_length, position_f_speed, position_z_speed, pitch_angle1, undefined);

	self PlayRumbleOnEntity( "damage_heavy" );
	
	wait first_wait;
	
	SetDvar("r_blurAndTintEnable", true);
	MoveCamera(vDir, 0, undefined, undefined, 0, 0, pitch_angle2, undefined);
	
	self lui::screen_close_menu();
	self thread lui::screen_fade( second_fade_time, second_fade_value, 1, "black" );
	
	wait second_wait;
	
	self notify("cp_playercam_ended");
}

function FirstPerson_Player_Cam_Burned(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
	
	self clientfield::set_to_player("player_cam_fire_init", 1);
	
	max_burn = GetDvarFloat("cam_burned_max_burn", 4);
	burn_increment = GetDvarFloat("cam_burned_burn_increment", 0.075);
	
	burn_increment = 0;
	while(burn_increment < max_burn)
	{
		self clientfield::set_to_player( "player_cam_fire", burn_increment );
		
		burn_increment+= 0.1;
		
		wait 0.05;
	}
	
	self.fade_to_white = true;
	self thread lui::screen_fade( 1, 1, 0, "white", false );
	
	wait 1;
	
	self clientfield::set_to_player("player_cam_fire_init", 0);
	
	self notify("cp_playercam_ended");
}

function FirstPerson_Player_Cam_Bubbles(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
	
	self clientfield::set_to_player("player_cam_bubbles", 1);
	
	bubbles_wait = GetDvarFloat("cam_bubbles_wait", 4);
	
	wait bubbles_wait;
	
	self clientfield::set_to_player("player_cam_bubbles", 0);
	
	self notify("cp_playercam_ended");
}


function FirstPerson_Player_Cam_Fall(eInflictor, attacker, iDamage, weapon, vDir, sHitLoc)
{
	self endon("disconnect");
	
	SetDvar("r_blurAndTintEnable", true);
	
	//values
	position_z_speed = GetDvarFloat("cam_fall_position_z_speed", 20);
	position_f_speed = GetDvarFloat("cam_fall_position_f_speed", 0);
	
	max_z_length = GetDvarFloat("cam_fall_max_z_length", 1000);
	max_f_length = GetDvarFloat("cam_fall_max_f_length", 0);
	
	end_wait = GetDvarFloat("cam_fall_end_wait", 4);
	
	self thread MoveCamera((0, 0, 1), 0.2, max_f_length, max_z_length, position_f_speed, position_z_speed, -88, 0);
	
	wait end_wait;
	
	self notify("camera_move_done");
	self notify("cp_playercam_ended");
}