#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\animation_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
            	      	   	    	           	        	        	                                    	                                                                                                                               	              	                                                                                                                            	          	         	                        
                                                                                                             	     	                                                                                                                                                                

#using scripts\shared\system_shared;
#using scripts\shared\math_shared;

#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
                  
           
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;



	//enemy within n feet will cause a swarm split












	


#namespace cybercom_gadget_firefly;
//#precache( "model", "p7_fxanim_gp_ability_firefly_launch_mod" );


function init()
{
	clientfield::register( "vehicle", "firefly_state", 1, 4, "int" );
	clientfield::register( "actor", "firefly_state", 1, 4, "int" );
	
	scene::add_scene_func( "p7_fxanim_gp_ability_firefly_launch_bundle", &on_scene_firefly_launch, "play" );
	scene::add_scene_func( "p7_fxanim_gp_ability_firebug_launch_bundle", &on_scene_firefly_launch, "play" );
}

function main()
{
	cybercom_gadget::registerAbility(2, (1<<3), true);

	level.cybercom.firefly_swarm = spawnstruct();
	level.cybercom.firefly_swarm._is_flickering = &_is_flickering;
	level.cybercom.firefly_swarm._on_flicker 	= &_on_flicker;
	level.cybercom.firefly_swarm._on_give 		= &_on_give;
	level.cybercom.firefly_swarm._on_take 		= &_on_take;
	level.cybercom.firefly_swarm._on_connect 	= &_on_connect;
	level.cybercom.firefly_swarm._on 			= &_on;
	level.cybercom.firefly_swarm._off		 	= &_off;
	level.cybercom.firefly_swarm._is_primed 	= &_is_primed;
	
	

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
	self.cybercom.targetLockCB = &_get_valid_targets;
	self.cybercom.targetLockRequirementCB = &_lock_requirement;
	self thread cybercom::weapon_AdvertiseAbility(weapon);
	
	self  cybercom::seedAnimationVariant("base_rifle",2);
	self  cybercom::seedAnimationVariant("fem_rifle",2);
	self  cybercom::seedAnimationVariant("riotshield",2);
	
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
	self thread spawn_firefly_swarm(self hasCyberComAbility("cybercom_fireflyswarm")  == 2);
	self notify( "bhtn_action_notify", "firefly_deploy" );
}

function _off( slot, weapon )
{
	// excecutes when the gadget is turned off`
}

function _is_primed( slot, weapon )
{

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#using_animtree( "generic" );
function ai_activateFireFlySwarm(target, doCast=true, upgraded=true )//self is a human AI
{
	if(self.archetype != "human" ) 
		return;

	if(( isdefined( doCast ) && doCast ))
	{
		type =self cybercom::getAnimPrefixForPose();
		self OrientMode( "face default" );
		self AnimScripted( "ai_cybercom_anim", self.origin, self.angles, "ai_base_rifle_"+type+"_exposed_cybercom_activate" );	
		self playsound( "gdt_firefly_activate_npc" );
		self waittillmatch( "ai_cybercom_anim", "fire" );
	}
	
	
	if(isArray(target))
	{
		foreach(guy in target)
		{	
			if(isDefined(guy.archetype) && (guy.archetype == "human" || guy.archetype == "human_riotshield" || guy.archetype == "zombie") )
				self thread spawn_firefly_swarm(upgraded, guy, 1);
		}
	}
	else
	{
		if(isDefined(target.archetype) && (target.archetype == "human" || target.archetype =="human_riotshield" || target.archetype == "zombie"))
			self thread spawn_firefly_swarm(upgraded, target);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function on_scene_firefly_launch( a_ents )
{
	anim_model = a_ents[ "ability_firefly_launch" ];
	anim_model waittill("firefly_launch_vehicle");
	
	if(isDefined(anim_model))
	{
		origin = anim_model GetTagOrigin("tag_fx_01_end_jnt");
		angles = anim_model GetTagAngles("tag_fx_01_end_jnt");
		anim_model delete();
	}
	if(isDefined(self.owner))
	{
		if(!isDefined(origin))
			origin = self.owner.origin + (0,0,72);
		if(!isDefined(angles))
			angles = self.owner.angles;
			
		self.owner notify ("firefly_intro_done",origin,angles);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function spawn_firefly_swarm(upgraded, targetEnt,swarms=GetDvarInt( "scr_firefly_swarm_count", 3 ), swarmSplits=GetDvarInt( "scr_firefly_swarm_split_count", 0 ))
{
	self endon("death");
	lifetime 	= GetDvarInt( "scr_firefly_swarm_lifetime", 20 );
	splitsLeft  = swarmSplits;
	offspring	= false;
	firebugs	= 0;
	fovTargets	= [];
	
	if (isDefined(targetEnt) && ( isdefined( targetEnt.is_disabled ) && targetEnt.is_disabled ) )
		targetEnt = undefined;
	
	if ( !isVehicle(self))
	{
		s_anim_pos = SpawnStruct();
		s_anim_pos.owner = self;

		if ( IsPlayer( self ) )
		{
			origin = self GetEye();
			angles = self GetPlayerAngles();
		}
		else
		{
			origin = self GetTagOrigin( "tag_eye" );
			angles = self GetTagAngles( "tag_eye" );
		}
	
		frontGoal = origin + (anglestoforward(angles)*120);	// Lets see if we've got 10 feet to play the FXAnim intro;  If not, then just spawn at player origin
		trace = BulletTrace( origin, frontGoal, false, undefined );
		
		if( trace["fraction"] == 1 )
		{
			s_anim_pos.origin = origin;
			s_anim_pos.angles = angles;
			if(upgraded)
			{
				s_anim_pos thread scene::play( "p7_fxanim_gp_ability_firebug_launch_bundle" );
			}
			else
			{
				s_anim_pos thread scene::play( "p7_fxanim_gp_ability_firefly_launch_bundle" );
			}
			self waittill("firefly_intro_done", origin,angles );
		}
		else
		{
			origin = self.origin+(0,0,72);
			angles = self.angles;
		}

		if(upgraded)
		{
			//swarms 		= SWARM_UPGRADED_SWARM_COUNT;
			lifetime 	= GetDvarInt( "scr_firefly_swarm_upgraded_lifetime", 26 );
			firebugs	= GetDvarInt( "scr_firefly_swarm_firebug_count", 1 );
		}
		lifetime   *= 1000; //mSec convert
		shelfLife 	= GetTime() + lifetime;
		fovTargets  = self get_swarm_targetswithinFOV(self.origin,self.angles);
	}
	else
	{
		shelfLife 	= self.lifetime;
		swarms	 	= 1;
		splitsLeft 	= 0;
		offspring	= true;
		firebugs	= (isDefined(self.fireBugCount)?self.fireBugCount:0);
		origin	 	= self.origin;
		angles		= self.angles;
	}

	
	while(swarms)
	{
		swarm = SpawnVehicle( "spawner_bo3_cybercom_firefly", origin, angles,"firefly_swarm");
		if(isDefined(swarm))
		{
			
			swarm.threatbias = -300;

			if(!isDefined(targetEnt))
			{
				if(fovTargets.size)
				{
					targetEnt = cybercom::getClosestTo(swarm.origin,fovTargets);			//closest guy within FOV
					ArrayRemoveValue(fovTargets,targetEnt,false);
				}
			}
			swarm.swarm_ID 		= level.cybercom.swarms_released;
			swarm.owner 		= self;
			swarm.team			= self.team;
			swarm.lifetime 		= shelfLife;
			swarm.splitsLeft	= splitsLeft;
			swarm.targetEnt 	= targetEnt;	//set this if you want an initial target
			swarm.isOffspring	= offspring;
			swarm.fireBugCount	= firebugs;
			
			swarm.debug				= spawnstruct();
			swarm.debug.main		= 0;
			swarm.debug.attack		= 0;
			swarm.debug.hunt		= 0;
			swarm.debug.move		= 0;
			swarm.debug.dead		= 0;
			
			swarm.state_machine = statemachine::create( "brain", swarm, "swarm_change_state" );
			swarm.state_machine statemachine::add_state( "init", 	&swarm_state_enter, &swarm_init, 		&swarm_state_cleanup );
			swarm.state_machine statemachine::add_state( "main", 	&swarm_state_enter, &swarm_main_think, 	&swarm_state_cleanup );
			swarm.state_machine statemachine::add_state( "move", 	&swarm_state_enter, &swarm_move_think, 	&swarm_state_cleanup );
			swarm.state_machine statemachine::add_state( "attack", 	&swarm_state_enter, &swarm_attack_think,&swarm_state_cleanup );
			swarm.state_machine statemachine::add_state( "hunt", 	&swarm_state_enter, &swarm_hunt_think, 	&swarm_state_cleanup );
			swarm.state_machine statemachine::add_state( "dead", 	&swarm_state_enter, &swarm_dead_think, 	&swarm_state_cleanup );
			swarm.state_machine statemachine::set_state( "init" );
			targetEnt = undefined;
		}
	
		level notify("cybercom_swarm_released",swarm);
		swarms--;
		level.cybercom.swarms_released += 1;
	}
	//turn off ??
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//this section contains lower level functions that make the swarm vehicle reach its goal positions
//the swarm either uses forced goal set by the controlling functions, or a wander behavior if no goal is specified 
function swarm_movement_update()
{
	self endon( "death" );
	// allow script to set goalpos and whatever else before moving
	wait .1;
	
	for( ;; )
	{
		self SetSpeed( self.settings.defaultMoveSpeed );

		self.current_pathto_pos = GetNextMovePosition_tactical();

		if ( IsDefined( self.current_pathto_pos ) )
		{
			usePathfinding = true;
			if ( self.isOnNav === false )
			{
				usePathfinding = false;
			}
					
			if ( self SetVehGoalPos( self.current_pathto_pos, true, usePathfinding ) )
			{
				self thread path_update_interrupt();
				self vehicle_ai::waittill_pathing_done();	
			}
		}
		wait 0.5;
	}
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	wait 1;
	
	while( 1 )
	{
		if( isdefined( self.current_pathto_pos ) )
		{
			if( distance2dSquared( self.current_pathto_pos, self.goalpos ) > ( (self.goalradius) * (self.goalradius) ) )
			{
				wait 0.2;
				self notify( "near_goal" );
			}
		}
		wait 0.2;
	}
}

function GetNextMovePosition_tactical()
{
	if( self.goalforced )
	{
		goalpos = self GetClosestPointOnNavVolume( self.goalpos, 100 );
		if ( isdefined( goalpos ) )
		{
			if ( DistanceSquared( goalpos, self.goalpos ) > ( (50) * (50) ) )
			{
				self.isOnNav = false;
			}
			return goalpos;
		}
		return self.goalpos;
	}
	
	queryMultiplier = 1;

	queryResult = PositionQuery_Source_Navigation( self.origin, 80, 500 * queryMultiplier, 500, 3 * self.radius * queryMultiplier, self, self.radius * queryMultiplier );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );

	self.isOnNav = queryResult.centerOnNav;

	best_point = undefined;
	best_score = -999999;

	foreach ( point in queryResult.data )
	{
		randomScore = randomFloatRange( 0, 100 );
		distToOriginScore = point.distToOrigin2D * 0.2;

		point.score += randomScore + distToOriginScore;
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "distToOrigin" ] = distToOriginScore;    #/    point.score += distToOriginScore;;
		
		if ( point.score > best_score )
		{
			best_score = point.score;
			best_point = point;
		}
	}

	self vehicle_ai::PositionQuery_DebugScores( queryResult );

	if( !isdefined( best_point ) )
	{
		return undefined;
	}

	return best_point.origin;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_state_cleanup( params )
{
	if(isDefined(self.badplace))
	{
		badplace_delete("swarmBP_"+self.swarm_ID);
		self.badplace = undefined;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_state_enter( params )
{
	{wait(.05);};
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function GetEnemyTeam()
{
	if(self.team === "axis")
	{
		return "allies";
	}
	else
	{
		return "axis";
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_init( params )
{
	self setmodel("tag_origin");

	self notsolid();
	self.notsolid = true;
	self.vehAirCraftCollisionEnabled = false;
	self notify( "end_nudge_collision" );

	self.ignoreall 	= true;
	self.takedamage = false;
	self.goalradius = 36;
	self.goalheight = 36;
	self.good_melee_target = true;
	self SetNearGoalNotifyDist( 48 );
	
	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	
	if(GetDvarInt( "scr_firefly_swarm_debug", 0))
	{
		self thread cybercom::drawOriginForever();
	}
	self thread swarm_movement_update();
	self thread swarm_death_wait();
	self thread swarm_split_monitor();
	self.sndEnt = spawn( "script_origin", self.origin );
	self.sndEnt linkto( self );
	self clearforcedgoal();
	self SetGoal( self.origin, true, self.goalradius );	//set the goal for swarm

	if(!( isdefined( self.isOffspring ) && self.isOffspring ))
	{
		enemies = self _get_valid_targets();
		closeTargets = ArraySortClosest(enemies, self.origin,enemies.size,0,512);	//if no nearby targets, lets move out from our current position in the direction player was looking
		if(closeTargets.size == 0 )
		{
			//Move the swarm out and away frmo FXAnim ending spot
			//this will cause the swarm to move out towards locatoin player was observing
			//We do this to get the swarm closer to targets that the player was looking at.
			angles = (self.angles[0],self.angles[1],0);
			frontGoal = self.origin + (anglestoforward( angles)*240);					//max 512 units out
			a_trace = BulletTrace( self.origin,frontGoal, false, undefined, true );
			hitp 	= a_trace[ "position" ];			//but lets check that we can go that far, if not, take the trace point
			
			queryResult = PositionQuery_Source_Navigation(hitp,	0,	72,	72,	20,	self );	//can swarm find node around where it wants to go?
			if( queryResult.data.size > 0 )
			{
				pathSuccess = self FindPath(	self.origin, queryResult.data[0].origin, true, false );		//can swarm path to that location?
				if ( pathSuccess )
				{
					if(GetDvarInt( "scr_firefly_swarm_debug", 0))
					{
						level thread cybercom::debug_Circle( queryResult.data[0].origin, 16, 10, (1,0,0) );
					}	
					self clearforcedgoal();
					self SetGoal( queryResult.data[0].origin, true, self.goalradius );	//set the goal for swarm
					
					if(!self.fireBugCount)
						self clientfield::set("firefly_state",2);
					else
						self clientfield::set("firefly_state",7);
					
					self util::waittill_any_timeout( 5, "near_goal" ); 
				}
			}
		}
	}
	
	if(isDefined(self.targetEnt) && isAlive(self.targetEnt) )
	{
		self.targetEnt.swarm = self;
		self.state_machine statemachine::set_state( "move" );
	}
	else
	{
		self.state_machine statemachine::set_state( "hunt" );
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_split_monitor()
{
	self endon ("swarm_is_dead");
	self endon("death");
	wait 3;
	while(self.splitsLeft > 0 )
	{
		wait 0.5;
		nearEnt = self swarm_find_good_target(GetDvarInt( "scr_firefly_swarm_split_radius", (72*12) ));
		if(isDefined(nearEnt)  )
		{
			self thread spawn_firefly_swarm(false,nearEnt);
			self.splitsLeft--;
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_attackHumanTarget(target)
{
	reactionAnims = [];
	
	base = "base_rifle";
	if((isdefined(self.voicePrefix) && ( GetSubStr(self.voicePrefix,7) == "f" )))
		base ="fem_rifle";
	else
	if(target.archetype === "human_riotshield")
		base = "riotshield";
	

	type = target cybercom::getAnimPrefixForPose();
	if(type=="")
	{
		target.swarm = undefined;
		self.targetEnt = undefined; 
		target.swarm_failure_time = GetTime()+1000;//hmm, not crouch or stand? something slipped through our valid target check somehow.  Forget this guy for 1 seconds
		self.state_machine statemachine::set_state( "main" );
		return;
	}
	
	self thread swarm_monitorTargetDeath(target);
	self clientfield::set("firefly_state",1);		//swarming
	variant = self.owner cybercom::getAnimationVariant(base);
		
	if(self.fireBugCount > 0 )
	{
		self.fireBugCount--;
		//fire deaths
		reactionAnims["intro"] 	= "ai_"+base+"_"+type+"_exposed_swarm_upg_react_intro"+variant;
		target thread _fireBombTarget(self,reactionAnims,GetWeapon("gadget_firefly_swarm_upgraded"));
		target notify( "bhtn_action_notify", "fireflyAttack" );
		target clientfield::set("firefly_state",9);
	}
	else
	{
		//swarm reaction animations
		if(target.archetype === "human" )
		{
			reactionAnims["intro"] 	= "ai_"+base+"_"+type+"_exposed_swarm_react_intro"+variant;
			reactionAnims["outro"] 	= "ai_"+base+"_"+type+"_exposed_swarm_react_outro"+variant;
		}
		else
		{
			reactionAnims = [];
		}
		target clientfield::set("firefly_state",4);
		target thread _reactToSwarm(self,reactionAnims,	GetWeapon("gadget_firefly_swarm"));
		target notify( "bhtn_action_notify", "fireflyAttack" );
	}
	self waittill("attack_stopped");
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_attackZombieTarget(target)
{
	assert(IsDefined(target));
	
	if(!self.fireBugCount)
	{
		target clientfield::set("firefly_state",4);		
	}
	else
	{
		target clientfield::set("firefly_state",9);
	}
	if(self.fireBugCount > 0 )
	{
		self.fireBugCount--;
		target clientfield::set("arch_actor_fire_fx", 1);
		target.health = 1;
	}
	wait 1;
	if(isDefined(target))
	{
		target.swarm = undefined;
	}
			
	wait RandomIntRange( 3, 7 );
	
	if( IsDefined( target ) && IsAlive( target ) )
	{
		target DoDamage( target.health, target.origin, undefined, undefined, "none", "MOD_BURNED");
	}
}

function swarm_attackWarlordTarget(target)
{
	assert(IsDefined(target));
	
	if(!self.fireBugCount)
	{
		target clientfield::set("firefly_state",4);		
	}
	else
	{
		target clientfield::set("firefly_state",9);
	}
	
	self thread swarm_monitorTargetDeath(target);
	self clientfield::set("firefly_state",1);		//swarming
	
	reactionAnims = [];
	if(self.fireBugCount > 0 && target.health <= GetDvarInt( "scr_firefly_swarm_warlord_hitpoint_allowed_thresh", 400 ) )
	{
		self.fireBugCount--;
		target thread _fireBombTarget(self,reactionAnims,GetWeapon("gadget_firefly_swarm_upgraded"));
		target notify( "bhtn_action_notify", "fireflyAttack" );
		target clientfield::set("firefly_state",9);
	}
	else
	{
		target clientfield::set("firefly_state",4);
		target thread _reactToSwarm(self,reactionAnims,	GetWeapon("gadget_firefly_swarm"));
		target notify( "bhtn_action_notify", "fireflyAttack" );		
	}
	self waittill("attack_stopped");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_attackPlayerTarget(target)
{
	self thread fireflyPlayerEffect(target);

	if(isdefined(self.owner))
	{
		attacker = self.owner;
	}
	else
	{
		attacker = self;
	}
	target DoDamage( GetDvarInt( "scr_swarm_player_damage", 50 ), target.origin, attacker, self, "none", "MOD_UNKNOWN", 0, GetWeapon("gadget_firefly_swarm_upgraded"));
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_attack_think( params )
{
	self endon ("swarm_is_dead");
	self endon("death");
	
	self.debug.attack++;
		
	self clientfield::set("firefly_state",1);
	
	if( isdefined( self.sndEnt ) )
	{
		if( !self.fireBugCount )
		{
			self.sndEnt playloopsound( "gdt_firefly_attack_lp", 1 );
		}
		else
		{
			self.sndEnt playloopsound( "gdt_firefly_attack_fire_lp", 1 );
		}
	}
	
	target = self.targetEnt;
	if(!isDefined(target) || !isAlive(target))
	{
		self.targetEnt = undefined;
		self.state_machine statemachine::set_state( "main" );
		return;
	}
	
	target notify("cybercom_action",GetWeapon("gadget_firefly_swarm"),self.owner);
	if(!self.fireBugCount)
	{
		target clientfield::set("firefly_state",4);
	}
	else
	{
		target clientfield::set("firefly_state",9);
	}
		
	
	if(isDefined(target.archetype))
	{
		if(target.archetype == "human" || target.archetype == "human_riotshield" )
		{
			self SetGoal( self.targetEnt.origin + (0,0,48), true, self.goalradius );
			BadPlace_Cylinder( "swarmBP_"+self.swarm_ID, 0, target.origin, 256, 80, "axis" ); 
			self.badplace = true;
			self swarm_attackHumanTarget(target);
		}
		else
		if(target.archetype == "zombie")
		{
			self swarm_attackZombieTarget(target);
		}
		else
		if(target.archetype == "warlord")
		{
			self swarm_attackWarlordTarget(target);
		}
	}
	else
	if(isPlayer(target))
	{
		self SetGoal( self.targetEnt.origin + (0,0,48), true, self.goalradius );
		BadPlace_Cylinder( "swarmBP_"+self.swarm_ID, 0, target.origin, 256, 80, "axis" ); 
		self.badplace = true;
		self swarm_attackPlayerTarget(target);
	}
	
	if( isdefined( self.sndEnt ) )
		self.sndEnt stoploopsound( .5 );

	self.targetEnt		= undefined;
	self.state_machine statemachine::set_state( "main" );
	self.debug.attack--;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_monitorTargetDeath(target)
{
	self endon("death");
	self endon("attack_stopped");
	target waittill("death");
	self notify("attack_stopped");
}


#using_animtree( "generic" );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _fireBombTargetPain(swarm, reactionAnims, weapon)
{
	self endon("death");
	self DoDamage( 5, self.origin, swarm.owner, swarm, "none", "MOD_BURNED", 0, weapon,-1,true);
	if (!self cybercom::isInstantKill())
	{
		self waittillmatch("bhtn_action_terminate", "specialpain" ); 		
	}
	self notify("firebug_time_to_die");
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _fireBombTargetCorpseListener()
{
	self waittill("actor_corpse", corpse);
	corpse clientfield::set("arch_actor_fire_fx", 2);
}
function private _fireBombTarget(swarm,reactionAnims,weapon)
{
	self endon("death");

 	self.ignoreall		= true;
	self.is_disabled 	= true;
	killFast 			= false;
	self notify("firebug_attack_sequence",swarm);
	level notify("firebug_attack_sequence",self,swarm);
	
	if(self cybercom::isLinked())
	{
		self unlink();
		killFast = true;
	}
	if(!( isdefined( killFast ) && killFast ) && isDefined( reactionAnims["intro"] ) )
	{
		self AnimScripted( "swarm_intro_anim", self.origin, self.angles, reactionAnims["intro"] );		
		self waittillmatch( "swarm_intro_anim", "end" );
	}

	self clientfield::set("arch_actor_fire_fx", 1);
	self thread _fireBombTargetCorpseListener();
	if(!( isdefined( killFast ) && killFast ))
	{
		self thread _fireBombTargetPain(swarm,reactionAnims,weapon);
		self util::waittill_any_timeout(GetDvarInt( "scr_firefly_swarm_human_burn_duration", 10 ), "firebug_time_to_die");
	}
	self clientfield::set("firefly_state",10);
	if(isDefined(swarm))
	{
		swarm notify("attack_stopped");
		if( isdefined( self.voicePrefix ) && isdefined( self.bcVoiceNumber ) )
		{
			self playsound( self.voicePrefix + self.bcVoiceNumber + "_exert_firefly_burning" );
		}
		swarm.owner notify( "firefly_killed_human_ai" );
		self DoDamage( self.health, self.origin, swarm.owner, swarm, "none", "MOD_BURNED", 0, weapon,-1,true);
	}
	else
	{
		if( isdefined( self.voicePrefix ) && isdefined( self.bcVoiceNumber ) )
		{
			self playsound( self.voicePrefix + self.bcVoiceNumber + "_exert_firefly_burning" );
		}
		self DoDamage( self.health, self.origin, undefined, undefined, "none", "MOD_BURNED", 0, weapon,-1,true);
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _deathListener(swarm)
{
//	self endon("death");
	while(isDefined(swarm))
	{
		self util::waittill_any_timeout( 1, "damage");
		if(IsDefined(self) && self.health<=0)
		{
			self clientfield::set("firefly_state",10);
			return;
		}
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _corpseWatcher(swarm)
{
	swarm endon("death");
 	self waittill("actor_corpse", corpse);
	corpse clientfield::set("firefly_state", 10);	
}

function notifyMeOnMatch(match,note,notetoSend,end)
{
	self endon("death");
	if(isDefined(end))
	{
		self endon(end);
		while(1)
		{
			if(isDefined(match))
			{
				self waittillmatch(match, note ); 
			}
			else
			{
				self waittill(note);
			}
			self notify(notetoSend);
		}
	}
	else
	{
		if(isDefined(match))
		{
			self waittillmatch(match, note ); 
		}
		else
		{
			self waittill(note);
		}
		self notify(notetoSend);
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _reactToSwarm(swarm,reactionAnims,weapon)
{
	self endon("death");
	
//	self thread _deathListener(swarm);
	self thread  _corpseWatcher(swarm);
	oldAware = self.badplaceawareness;
	self.badplaceawareness = .1;
	self.is_disabled = true;
	self OrientMode( "face point", swarm.origin );
	self notify("firefly_attack_sequence",swarm);
	level notify("firefly_attack_sequence",self,swarm);

	if (self cybercom::isInstantKill() )
	{
		//Usage: <entity> DoDamage( <health>, <source position>, [attacker], [inflictor], [hitloc], [mod], [dflags], [weapon], [infdestructible_piece_indexlictor], [forcePain] )
		self Kill(self.origin, (isDefined(swarm.owner)?swarm.owner:undefined));
		if(isDefined(swarm))
		{
			swarm notify("attack_stopped");
		}
		return;
	}	
	
	if(!isAlive(self) || self isRagdoll())
		return;
	
	if(isDefined(reactionAnims["intro"]))
	{
		self AnimScripted( "swarm_intro_anim", self.origin, self.angles, reactionAnims["intro"] );		
		self thread cybercom::stopAnimScriptedOnNotify("damage","swarm_intro_anim");
		self waittillmatch( "swarm_intro_anim", "end" );
	}

	attack = true;
	
//	self thread notifyMeOnMatch("bhtn_action_terminate","specialpain","damagepain","attack_stopped");
//	self thread notifyMeOnMatch(undefined,"damage","damagepain","attack_stopped");
	while (attack && isDefined(swarm))
	{
		self DoDamage( 5, self.origin, swarm.owner, swarm, "none", "MOD_UNKNOWN", 0, weapon,-1,true);
		{wait(.05);};
		self waittillmatch("bhtn_action_terminate","specialpain");
		attack =   (isDefined(swarm) && !( isdefined( swarm.dying_out ) && swarm.dying_out ) && DistanceSquared(self.origin+(0,0,48),swarm.origin) < (GetDvarInt( "scr_firefly_swarm_attack_radius", 110 )*GetDvarInt( "scr_firefly_swarm_attack_radius", 110 )) && isAlive(self) );
	}
	
	self notify("attack_stopped");
	if(isAlive(self) && !(self isRagdoll()) )
	{
		self clientfield::set("firefly_state",5);
		self.badplaceawareness = oldAware;
		self.swarm = undefined;
		self OrientMode( "face default" );
		
		if(isDefined(reactionAnims["outro"]))
		{
			self AnimScripted( "swarm_outro_anim", self.origin, self.angles, reactionAnims["outro"] );	
			self thread cybercom::stopAnimScriptedOnNotify("damage","swarm_outro_anim");
			self waittillmatch( "swarm_outro_anim", "end" );
		}
		self.is_disabled = undefined;
	}
	if(isDefined(swarm))
	{
		swarm notify("attack_stopped");
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_delete()
{
	if (isDefined(self))
	{
		self notify ("swarm_is_dead");
		if(isDefined(self.targetEnt) && !isPlayer(self.targetEnt) )
		{
			self.targetEnt clientfield::set("firefly_state",5);
			self.targetEnt.swarm = undefined;
			self.targetEnt.swarm_cooloffTime = GetTime() + 2000;
		}
		if(isDefined(self.sndEnt))
			self.sndEnt delete();
			
		self swarm_state_cleanup();
		self delete();
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_death_wait()
{
	self endon("death");
	while(GetTime()< self.lifetime)
	{
		wait 1;
	}
	self.dying_out = 1;
	
	//failsafe
	self playsound( "gdt_firefly_die" );
	
	if( isdefined( self.sndEnt ) )
		self.sndEnt stoploopsound( .5 );
	
	wait 5;
	self swarm_delete();
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_dead_think( params )
{
	self notify("swarm_is_dead");
	self endon("death");

	self clearforcedgoal();
	if(!self.fireBugCount)
	{
		self clientfield::set("firefly_state",5);
	}
	else
	{
		self clientfield::set("firefly_state",10);
	}
	
	if(isDefined(self.targetEnt) && !isPlayer(self.targetEnt) )
	{
		self.targetEnt clientfield::set("firefly_state",5);
		self.targetEnt.swarm = undefined;
		self.targetEnt.swarm_cooloffTime = GetTime() + 2000;
	}
	
	self vehicle::toggle_sounds( 0 );
	self playsound( "gdt_firefly_die" );
	
	if( isdefined( self.owner ) )
	{
		self.owner notify( "bhtn_action_notify", "firefly_end" );
	}
	
	if( isdefined( self.sndEnt ) )
		self.sndEnt stoploopsound( .5 );
	
	wait 3;
	self swarm_delete();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_main_think( params )
{
	self endon ("swarm_is_dead");
	self endon("death");
	if (( isdefined( self.dying_out ) && self.dying_out ))
	{
		self.state_machine statemachine::set_state( "dead" );
		return;
	}
	
	self.debug.main++;

	if(!isDefined(self.targetEnt))
	{
		self.state_machine statemachine::set_state( "hunt" );
	}
	else
	if ( DistanceSquared(self.targetEnt.origin+(0,0,48),self.origin) > (GetDvarInt( "scr_firefly_swarm_attack_radius", 110 )*GetDvarInt( "scr_firefly_swarm_attack_radius", 110 )) )
	{
		self.state_machine statemachine::set_state( "move" );
	}
	else
	{
		self.state_machine statemachine::set_state( "attack" );
	}
	self.debug.main--;

}
function private _get_valid_targets()
{
	humans  = ArrayCombine(GetAISpeciesArray( self GetEnemyTeam(), "human" ),GetAISpeciesArray( "team3", "human" ),false,false);
	zombies = ArrayCombine(GetAISpeciesArray( self GetEnemyTeam(), "zombie" ),GetAISpeciesArray( "team3", "zombie" ),false,false);
	return ArrayCombine(humans,zombies,false,false);	//check to see if there are any nearby targets
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _lock_requirement(target)
{
	if (isDefined(self.owner) && !(self.owner cybercom::targetIsValid(target)) )
		return false;
	
	if ( target.archetype != "human" && target.archetype != "human_riotshield" &&  target.archetype != "zombie"  &&  target.archetype != "warlord" )
		return false;

	if( target cybercom::cybercom_AICheckOptOut("cybercom_fireflyswarm")) 
		return false;

	if (isDefined(target.swarm))
		return false;

	if (isDefined(target.swarm_failure_time))
	{
		if( target.swarm_failure_time > GetTime())
			return false;
		
		target.swarm_failure_time = undefined;
	}

	if (isDefined(target.swarm_cooloffTime) && GetTime()<target.swarm_cooloffTime)
		return false;
	
	if(isActor(target) && target cybercom::getEntityPose() != "stand" && target cybercom::getEntityPose() !="crouch" )
		return false;
		
	return true;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function get_swarm_targetswithinFOV(origin,angles, distToCheck=GetDvarInt( "scr_firefly_swarm_hunt_radius", (128*12) ),nFor=Cos(45))
{
	enemies = self _get_valid_targets();
	closeTargets = ArraySortClosest(enemies,origin,enemies.size,0,distToCheck);
	fovTargets   = [];
	foreach(guy in closeTargets)
	{
		if (!_lock_requirement(guy))
			continue;
		
		if ( util::within_fov( origin, angles, guy.origin, nFor ) )				
			fovTargets[fovTargets.size] = guy;
	}

	return fovTargets;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_find_good_target(distToCheck=GetDvarInt( "scr_firefly_swarm_hunt_radius", (128*12) ))
{
	self endon ("swarm_is_dead");
	self endon("death");
	
	//get enemies
	enemies = self _get_valid_targets();
	
	closeTargets = ArraySortClosest(enemies,self.origin,enemies.size,0,distToCheck);
	closest = undefined;
	while ( closeTargets.size > 0 )
	{
		//filter for good target
		closest = cybercom::getClosestTo(self.origin,closeTargets,distToCheck);
		if (!_lock_requirement(closest) )
		{
			ArrayRemoveValue(closeTargets,closest,false);
			closest = undefined;
			{wait(.05);};
			continue;
		}
		if(!isDefined(closest))
		{
			break;
		}
		
		pathSuccess = false;
		queryResult = PositionQuery_Source_Navigation(closest.origin,	0,	128,	128,	20,	self );
		if( queryResult.data.size > 0 )
		{
			pathSuccess = self FindPath(self.origin, queryResult.data[0].origin, true, false );
		}
		if(!pathSuccess)
		{
			ArrayRemoveValue(closeTargets,closest,false);
			closest = undefined;
			{wait(.05);};
			continue;
		}
		break;
	}
	
	return closest;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_hunt_think( params )
{
	self endon ("swarm_is_dead");
	self endon("death");
	
	self.debug.hunt++;

	self util::waittill_any_timeout( 3, "near_goal");
	self clearforcedgoal();

	if(!self.fireBugCount)
	{
		self clientfield::set("firefly_state",1);
	}
	else
	{
		self clientfield::set("firefly_state",6);
	}
	
	if(GetDvarInt( "scr_firefly_swarm_debug", 0))
	{
		self thread cybercom::debug_Circle(self.origin,GetDvarInt( "scr_firefly_swarm_hunt_radius", (128*12) ),0.1,(1,1,0));
	}

	self.targetEnt = self swarm_find_good_target();
	if(isDefined(self.targetEnt))
	{
		self.targetEnt.swarm = self;
	}
	if(!isDefined(self.targetEnt) && isDefined(self.owner) )
	{//no enemies found? maybe move to a random location?
	//	self.targetEnt = self.owner;
	}
	
	self.state_machine statemachine::set_state( "main" );
	self.debug.hunt--;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function swarm_move_think( params )
{
	self endon ("swarm_is_dead");
	self endon("death");
	
	self.debug.move++;

	if(!self.fireBugCount)
	{
		self clientfield::set("firefly_state",2);
	}
	else
	{
		self clientfield::set("firefly_state",7);
	}

	wait .5;
	self.goalradius = 12;
	self.goalheight = 12;
	
	if(!self.fireBugCount)
	{
		self clientfield::set("firefly_state",3);
	}
	else
	{
		self clientfield::set("firefly_state",8);
	}
	
	self clearforcedgoal();
	if ( isDefined(self.targetEnt) )
	{
		self SetGoal( self.targetEnt.origin + (0,0,48), true, self.goalradius );
		event = self util::waittill_any_timeout( 30, "near_goal");
	}
	self.state_machine statemachine::set_state( "main" );
	self.debug.move--;
}
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function fireflyPlayerEffect(player)
{
	self endon( "disconnect" );
	
	player shellshock( "proximity_grenade", 2, false );
}
