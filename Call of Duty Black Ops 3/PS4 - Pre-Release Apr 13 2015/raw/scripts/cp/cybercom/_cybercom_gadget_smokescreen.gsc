
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
#using scripts\codescripts\struct;
#using scripts\shared\system_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;

                                                                                                                                                     
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
                                                                                                      	                       	     	                                                                     
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;
#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;






	// How wide of an arc the smokescreen makes.
	// How far forward the arc is shifted in front of the player.
	// This is the radius of the arc. Controls how deep the "pocket" is.
	

#namespace cybercom_gadget_smokescreen;


function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(2, (1<<4));

	level.cybercom.smokescreen = spawnstruct();
	level.cybercom.smokescreen._is_flickering = &_is_flickering;
	level.cybercom.smokescreen._on_flicker 	= &_on_flicker;
	level.cybercom.smokescreen._on_give 	= &_on_give;
	level.cybercom.smokescreen._on_take 	= &_on_take;
	level.cybercom.smokescreen._on_connect 	= &_on_connect;
	level.cybercom.smokescreen._on 			= &_on;
	level.cybercom.smokescreen._off		 	= &_off;
	level.cybercom.smokescreen._is_primed 	= &_is_primed;
}

function _is_flickering( slot )
{
	// returns true when the gadget is flickering
}

function _on_flicker( slot, weapon )
{
	// excuted when the gadget flickers
}

function _on_give( slot, weapon )
{
	// executed when gadget is added to the players inventory
	self.cybercom.weapon 	= weapon;
}

function _on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
	self.cybercom.weapon	= undefined;
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	// excecutes when the gadget is turned on
	self notify(weapon.name+"_fired");
	level notify(weapon.name+"_fired");
	level thread spawn_smokescreen(self,(self hasCyberComAbility("cybercom_smokescreen")  == 2) );
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
}

function _is_primed( slot, weapon )
{
	//self thread gadget_flashback_start( slot, weapon );
}


// Rotates a direction vector about its Z axis by a given number of degrees.
// Returns vector rotated about its Z axis.
function RotateForwardXY(vToRotate, fAngleDegrees)
{
	x = vToRotate[0] * Cos(fAngleDegrees) + vToRotate[1] * Sin(fAngleDegrees);
	y = -1 * vToRotate[0] * Sin(fAngleDegrees) + vToRotate[1] * Cos(fAngleDegrees);
	z = vToRotate[2];
	
	return (x,y,z);
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function spawn_smokescreen(owner,upgraded=false)//self == player
{
	forward 	= Anglestoforward( owner.angles );
	center		= 70*forward+owner.origin;
	frontspot	= 150*forward+center;
	
	// Get right side emission point on the far right of the arc
	rotated = RotateForwardXY(forward, 50);
	rightspot = (rotated * 150) + center;
	
	// Left side emission point
	rotated = RotateForwardXY(forward, -50);
	leftspot = (rotated * 150) + center;
	
	// Emit smoke
	owner thread _cloudCreate(frontspot,(upgraded?GetWeapon("smoke_cybercom_upgraded"):GetWeapon("smoke_cybercom")),upgraded);
	owner thread _cloudCreate(rightspot,GetWeapon("smoke_cybercom_nofx"),upgraded);
	owner thread _cloudCreate(leftspot,GetWeapon("smoke_cybercom_nofx"),upgraded);
}	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _cloudCreate(origin,weapon,createIONfield)
{//self == player
	timeStep = 2;

	cloud = _createNoSightCloud(origin,GetDvarInt( "scr_smokescreen_duration", 9 ), weapon);
	cloud thread _deleteAfterTime(GetDvarInt( "scr_smokescreen_duration", 9 ));
	cloud thread _scaleOverTime(GetDvarInt( "scr_smokescreen_duration", 9 ),1,2);
	cloud SetTeam( self.team );
	if(isPlayer(self))
	{
		cloud SetOwner( self );
	}
	cloud.durationLeft = GetDvarInt( "scr_smokescreen_duration", 9 );
	if(createIONfield)
	{
		cloud thread _ionizedHazard(self,timeStep);
	}
	if ( GetDvarInt( "scr_smokescreen_debug",0) )
	{
		cloud thread _debug_cloud(GetDvarInt( "scr_smokescreen_duration", 9 ));
	}

	cloud endon("death");
	while(1)
	{
		FXBlockSight( cloud, cloud.currentRadius );
		cloud thread _moveInDirection((0,0,1), 12, timeStep);
		wait timeStep;
		cloud.durationLeft -= timeStep;
		if ( cloud.durationLeft < 0 )
			cloud.durationLeft = 0;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _ionizedHazard(player,timeStep)
{
	self endon("death");
	
	while(1)
	{
		if(isDefined(self.trigger))
			self.trigger delete();
		
		self.trigger =	spawn( "trigger_radius", self.origin, 1+8, self.currentRadius, self.currentRadius );	
		self.trigger thread _ionizedHazardThink(player,self);
		wait timeStep;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _ionizedHazardThink(player,cloud)
{//self = trigger
	self endon("death");
	while(1)
	{
		self waittill("trigger",guy);
		
		if(!isDefined(guy))
			continue;
			
		if ( !IsAlive(guy) )
			continue;
			
		if(( isdefined( guy.is_disabled ) && guy.is_disabled ))
			continue;
			
		if( guy cybercom::cybercom_AICheckOptOut("cybercom_smokescreen")) 
			continue;
	
	
		if(!isDefined(cloud))
		{
			return;
		}
	
		switch(guy.archetype)
		{
			case "robot":
				guy thread cybercom_gadget_system_overload::system_overload_robot(player,cloud.durationLeft*1000);
			break;
			case "human":
				guy thread cybercom_gadget_sensory_overload::sensory_overload(player,cloud.durationLeft*1000);
			break;
			default:
				if(isVehicle(guy))
				{
					curhealth = guy.health;
					guy DoDamage( 5, self.origin, self, self, "none", "MOD_RIFLE_BULLET", 0, GetWeapon("emp_grenade"),-1,true);
					if(isDefined(guy))
						guy.health = curhealth;
				}
			break;
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _moveInDirection(dir, unitsToMove, seconds)
{
	self endon("death");
	
	ticks  = seconds * 20;
	dxStep = (unitsToMove / ticks)*VectorNormalize(dir);
	while(ticks)
	{
		ticks--;
		self.origin += dxStep;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _createNoSightCloud(origin,duration,weapon)
{
	smokescreen = SpawnTimedFX(  weapon, origin, (0,0,1), duration);
	smokescreen.currentRadius = GetDvarInt( "scr_smokescreen_radius", 60 );
	smokescreen.currentScale = 1;

	return smokescreen;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _deleteAfterTime(time)
{
	self endon("death");
	wait time;
	if(isDefined(self.trigger))
		self.trigger delete();
	self delete();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _scaleOverTime(time,startScale,maxScale)
{
	self endon("death");
	
	if (maxScale < 1 )
		maxScale = 1;
		
	self.currentScale   = startScale;
	serverTicks= time*20;
	up = maxScale > startScale;
	if(up)
	{
		deltaScale = maxScale - startScale;
		deltaStep  = deltaScale/serverTicks;
	}
	else
	{
		deltaScale = startScale-maxScale;
		deltaStep  = -(deltaScale/serverTicks);
	}		
	
	while(serverTicks)
	{
		self.currentScale += deltaStep;
		if(self.currentScale > maxScale )
			self.currentScale = maxScale;
		if(self.currentScale < 1 )
			self.currentScale = 1;
		
		self.currentRadius = GetDvarInt( "scr_smokescreen_radius", 60 ) * self.currentScale;
		{wait(.05);};
		serverTicks--;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function private _debug_cloud(time)
{
	self endon("death");

	serverTicks= time*20;
	while(serverTicks)
	{
		serverTicks--;
		level thread cybercom::debug_sphere( self.origin, self.currentRadius );
		{wait(.05);};
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function ai_activateSmokescreen(upgraded=false)
{
	level thread spawn_smokescreen(self,upgraded);
}
