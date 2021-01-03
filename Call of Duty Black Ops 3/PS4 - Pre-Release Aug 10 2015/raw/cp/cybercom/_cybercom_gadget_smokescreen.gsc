
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
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
#using scripts\cp\cybercom\_cybercom_dev;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_gadget_system_overload;
#using scripts\cp\cybercom\_cybercom_gadget_sensory_overload;






	// How wide of an arc the smokescreen makes.
	// How far forward the arc is shifted in front of the player.
	// This is the radius of the arc. 

 //How far around the smoke screen to force a refresh of sentient vis cache
	

#namespace cybercom_gadget_smokescreen;


function init()
{
}

function main()
{
	cybercom_gadget::registerAbility(1, (1<<0));

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
	self.cybercom.targetLockCB = undefined;
	self.cybercom.targetLockRequirementCB = undefined;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
}

function _on_take( slot, weapon )
{
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	// excecutes when the gadget is turned on
	cybercom::cybercomAbilityTurnedONNotify(weapon,true);
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
	weapon		= (upgraded?GetWeapon("smoke_cybercom_upgraded"):GetWeapon("smoke_cybercom"));
	
	forward 	= Anglestoforward( owner.angles );
	center		= 40*forward+owner.origin;
	frontspot	= 140*forward+center;
	owner thread _cloudCreate(frontspot,weapon,upgraded);
	
	playsoundatposition( "gdt_cybercore_smokescreen", frontspot );
	
	rotated 	= RotateForwardXY(forward, 23);
	rightspot1 	= (rotated * 140) + center;
	rotated 	= RotateForwardXY(forward, 2*23);
	rightspot2 	= (rotated * 140) + center;
	rotated 	= RotateForwardXY(forward, 3*23);
	rightspot3 	= (rotated * 140) + center;
	owner thread _cloudCreate(rightspot1,weapon,upgraded);
	owner thread _cloudCreate(rightspot2,weapon,upgraded);
	owner thread _cloudCreate(rightspot3,weapon,upgraded);

	rotated 	= RotateForwardXY(forward, -23);
	leftspot1 	= (rotated * 140) + center;
	rotated 	= RotateForwardXY(forward, -2*23);
	leftspot2 	= (rotated * 140) + center;
	rotated 	= RotateForwardXY(forward, -3*23);
	leftspot3 	= (rotated * 140) + center;
	owner thread _cloudCreate(leftspot1,weapon,upgraded);
	owner thread _cloudCreate(leftspot2,weapon,upgraded);
	owner thread _cloudCreate(leftspot3,weapon,upgraded);
	owner thread _ResetSentientVisCache(center);
}	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _cloudCreate(origin,weapon,createIONfield)
{//self == player
	timeStep = 2;

	
	cloud = _createNoSightCloud(origin,GetDvarInt( "scr_smokescreen_duration", 7 ), weapon);
	cloud thread _deleteAfterTime(GetDvarInt( "scr_smokescreen_duration", 7 ));
	cloud thread _scaleOverTime(GetDvarInt( "scr_smokescreen_duration", 7 ),1,2);
	cloud SetTeam( self.team );
	if(isPlayer(self))
	{
		cloud SetOwner( self );
	}
	cloud.durationLeft = GetDvarInt( "scr_smokescreen_duration", 7 );
	if(createIONfield)
	{
		cloud thread _ionizedHazard(self,timeStep);
	}
	if ( GetDvarInt( "scr_smokescreen_debug",0) )
	{
		cloud thread _debug_cloud(GetDvarInt( "scr_smokescreen_duration", 7 ));
		level thread cybercom_dev::debugPoint(cloud.origin,GetDvarInt( "scr_smokescreen_duration", 7 ),16,(1,0,0));
	}
	//BadPlace_Cylinder("", SMOKESCREEN_DURATION, cloud.origin, 100, cloud.currentRadius,"all" );

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
		
		self.trigger =	spawn( "trigger_radius", self.origin, 1+8+16, self.currentRadius, self.currentRadius );	
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
	
		if(!isDefined(cloud))
		{
			return;
		}
		
		if(!isDefined(guy))
			continue;
			
		if ( !IsAlive(guy) )
			continue;
		
		if ( ( isdefined( guy.is_disabled ) && guy.is_disabled ) )//this flag gets set if dude is already cybercom'd with something else.  stacking an effect could be troublesome
			return false;
	
		if(!( isdefined( guy.takedamage ) && guy.takedamage ))
			return false;
		
		if (isDefined(guy._ai_melee_opponent))
			return false;	
	
		if(( isdefined( guy.is_disabled ) && guy.is_disabled ))
			continue;
			
		if( guy cybercom::cybercom_AICheckOptOut("cybercom_smokescreen")) 
			continue;

		if ( ( isdefined( guy.magic_bullet_shield ) && guy.magic_bullet_shield ))
			continue;
	
	    if( IsActor( guy ) && guy IsInScriptedState() )
	    	continue;
	    	
	    if(isDefined(guy.allowdeath) && !guy.allowdeath)
	    	continue;
		
		if(isVehicle(guy))
		{
			guy thread cybercom_gadget_system_overload::system_overload(player,cloud.durationLeft*1000);
		}
		
		if(isDefined(guy.archetype))
		{
			switch(guy.archetype)
			{
				case "robot":
					guy thread cybercom_gadget_system_overload::system_overload(player,cloud.durationLeft*1000);
				break;
				case "human":
				case "human_riotshield":
					guy thread cybercom_gadget_sensory_overload::sensory_overload(player);
				break;
			}
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
function ai_activateSmokescreen(doCast=true,upgraded=false)
{
	if(( isdefined( doCast ) && doCast ))
	{
		type =self cybercom::getAnimPrefixForPose();
		self OrientMode( "face default" );
		self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );		
		self waittillmatch( "ai_cybercom_anim", "fire" );
	}
	level thread spawn_smokescreen(self,upgraded);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _ResetSentientVisCache(origin)
{
	self endon("death");
	resetFrequencySec = 1;
	timeLeft = GetDvarInt( "scr_smokescreen_duration", 7 );
	while (timeLeft > 0)
	{
		ResetVisibilityCacheWithinRadius(origin, 1000);		
		wait resetFrequencySec;
		timeLeft = timeLeft - resetFrequencySec;
	}
}
