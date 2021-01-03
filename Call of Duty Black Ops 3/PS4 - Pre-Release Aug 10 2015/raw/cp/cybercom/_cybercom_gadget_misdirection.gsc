#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hud_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	
#using scripts\shared\system_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\lui_shared;
#using scripts\cp\_util;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_dev;


















#namespace cybercom_gadget_misdirection;

function init()
{
	clientfield::register( "toplayer", "misdirection_enable", 1, 1, "int" );
}

function main()
{
	cybercom_gadget::registerAbility(2,	(1<<5), true);
	
	level.cybercom.misdirection = spawnstruct();
	level.cybercom.misdirection._is_flickering  = &_is_flickering;
	level.cybercom.misdirection._on_flicker 	= &_on_flicker;
	level.cybercom.misdirection._on_give 		= &_on_give;
	level.cybercom.misdirection._on_take 		= &_on_take;
	level.cybercom.misdirection._on_connect 	= &_on_connect;
	level.cybercom.misdirection._on 			= &_on;
	level.cybercom.misdirection._off 			= &_off;
	level.cybercom.misdirection._is_primed 		= &_is_primed;
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
	self.cybercom.misdirection_lifetime 	= GetDvarFloat( "scr_misdirection_lifetime", 3.5 );
	self.cybercom.misdirection_decoys_count = GetDvarInt( "scr_misdirection_target_count", 3 );
	self.cybercom.misdirection_fov		   	= GetDvarFloat( "scr_misdirection_fov", .968 );
	if(self hasCyberComAbility("cybercom_misdirection")  == 2)
	{
		self.cybercom.misdirection_lifetime 	= GetDvarInt( "scr_misdirection_upgraded_lifetime", 5 );
		self.cybercom.misdirection_decoys_count  = GetDvarInt( "scr_misdirection_target_count_upgraded", 5 );
		self.cybercom.misdirection_fov			= GetDvarFloat( "scr_misdirection_upgraded_fov", .94 );
	}
	clientfield::set_to_player( "misdirection_enable", 1);
}

function _on_take( slot, weapon )
{
	clientfield::set_to_player( "misdirection_enable", 0);
	// executed when gadget is removed from the players inventory
}

//self is the player
function _on_connect()
{
	// setup up stuff on player connect	
}

function _on( slot, weapon )
{
	result = self _activate_misdirection( slot, weapon );
	if ( !result )
	{
		self GadgetDeactivate( slot, weapon, 2 );
	}
	cybercom::cybercomAbilityTurnedONNotify(weapon,result);
}

function _off( slot, weapon )
{
}


function _is_primed( slot, weapon )
{
	if(!( isdefined( self.cybercom.is_primed ) && self.cybercom.is_primed ))
	{
		self.cybercom.is_primed = true;
	}
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private _get_valid_targets(weapon)
{
	playerForward = AnglesToForward(self GetPlayerAngles());
	enemies		  = ArrayCombine(GetAITeamArray( "axis"),GetAITeamArray( "team3"),false,false);
	enemies 	  = ArraySort( enemies, self.origin, true );
	valid		  = [];
	
	foreach(guy in enemies)
	{
		if(isVehicle(guy))
			continue;
		if(!isActor(guy))
			continue;
		if(!isDefined(guy.archetype) || guy.archetype == "direwolf" || guy.archetype == "zombie")
			continue;
		   
		distSQ = distancesquared(self.origin,guy.origin);
		if ( distSQ < GetDvarInt( "scr_misdirection_min_distance", ( (GetDvarInt( "scr_misdirection_min_distance", 200 )) * (GetDvarInt( "scr_misdirection_min_distance", 200 )) ) ) )
			continue;
		if ( distSQ > GetDvarInt( "scr_misdirection_max_distance", ( (GetDvarInt( "scr_misdirection_max_distance", 1750 )) * (GetDvarInt( "scr_misdirection_max_distance", 1750 )) ) ) )
			continue;

		dot = VectorDot(playerForward,VectorNormalize(guy.origin-self.origin));
		if ( dot < self.cybercom.misdirection_fov )
			continue;
	
		valid[valid.size] = guy;
	}
	return valid;	
}

function private _activate_misdirection( slot, weapon )
{
	targets	= _get_valid_targets(weapon);		//list of potentials
	
	self.cybercom.misdirection_decoys = [];
	for(i=0;i<self.cybercom.misdirection_decoys_count;i++)
	{
		self.cybercom.misdirection_decoys[self.cybercom.misdirection_decoys.size] = self _createDecoy(targets);
	}
	foreach(decoy in self.cybercom.misdirection_decoys)
	{
		if( !isDefined(decoy.primaryThreat))	//if this isn't defined then there weren't enough valid targets
		{
			self _decoyMoveToSuitableLoc(decoy,targets);
		}
		
		decoy thread decoyThink(self.cybercom.misdirection_lifetime,self);
	}
	
	return true;
}

function _isPointValid(point)
{
	foreach( existingDecoy in self.cybercom.misdirection_decoys) //check to see if this will be too close to existing decoys
	{
		distSQ = distancesquared(point,existingDecoy.origin);
		if(distSQ < GetDvarInt( "scr_misdirection_upgraded_lifetime",( (GetDvarInt( "scr_misdirection_upgraded_lifetime",200 )) * (GetDvarInt( "scr_misdirection_upgraded_lifetime",200 )) ) ) )
		{
			return false;
		}
	}
	return true;
}

function _decoyMoveToSuitableLoc(decoy, &potentialTargets)	//self == player
{
	mins = (1000000, 1000000, 1000000);
	maxs = (-1000000, -1000000, -1000000);
	
	playerForward = AnglesToForward(self GetPlayerAngles());
	playerForward = (playerForward[0],playerForward[1],0);
	playerRight   = AnglesToRight(self GetPlayerAngles());
	playerRight   = (playerRight[0],playerRight[1],0);
	foreach (target in potentialTargets) 
	{
		origin = target.origin;
		mins = add_point_to_mins( origin, mins );
		maxs = add_point_to_maxs( origin, maxs );
	}
	rangeMax = self.origin + playerForward*GetDvarInt( "scr_misdirection_max_distance", 1750 );
	maxs = add_point_to_maxs( rangeMax, maxs );
	rangeMin = self.origin + playerForward*GetDvarInt( "scr_misdirection_min_distance", 200 );
	mins = add_point_to_mins( rangeMin, mins );
	center = ((maxs + mins)*.5);
	
	avgDistRange = distance (center,self.origin);
	avgDir		 = VectorNormalize(center-self.origin);		
	
	bestSpot	 = self.origin + avgDir*avgDistRange;
	anchorSpot	 = bestSpot;
	maxTries	 = 6;	
	curAngVariant= 0;
	step 		 = playerRight * GetDvarInt( "scr_misdirection_upgraded_lifetime",200 );
	
	while(maxTries>0)
	{
		left  = anchorSpot + ((6-maxTries) * step);
  		v_ground 		= BulletTrace( left + (0,0,72), left + ( 0, 0, -2048 ), false, undefined, true )[ "position" ];//find the ground
  		left = (left[0],left[1],v_ground[2]);
		v_trace 	= BulletTrace( self.origin + (0,0,24),  left + (0,0,24), true, self )[ "position" ];
		dir 		= VectorNormalize(v_trace-self.origin);
		v_trace		= v_trace + (-48*dir);//bring the spot back towards the player
		v_ground 	= BulletTrace( v_trace, v_trace + ( 0, 0, -2048 ), false, undefined, true )[ "position" ];//find the ground
  		
		if( self _isPointValid(v_ground))
		{
			bestSpot = v_ground;
			break;
		}
	
		right = anchorSpot - ((6-maxTries) * step);
  		v_ground 		= BulletTrace( right + (0,0,72), right + ( 0, 0, -2048 ), false, undefined, true )[ "position" ];//find the ground
  		right = (right[0],right[1],v_ground[2]);
		v_trace 	= BulletTrace( self.origin + (0,0,24),  right + (0,0,24), true, self )[ "position" ];
		dir 		= VectorNormalize(v_trace-self.origin);
		v_trace		= v_trace + (-48*dir);//bring the spot back towards the player
		v_ground 	= BulletTrace( v_trace, v_trace + ( 0, 0, -2048 ), false, undefined, true )[ "position" ];//find the ground
  		
		if( self _isPointValid(v_ground))
		{
			bestSpot = v_ground;
			break;
		}
		
		maxTries--;
	}
	decoy.origin = bestSpot + (0,0,32);
}


function _createDecoy(&potentialTargets)	//self == player
{
	decoy = spawn("script_model",self.origin);
	decoy SetModel("tag_origin");
	decoy MakeSentient();
	decoy.team = self.team;
	decoy.threatbias = int(gameskill::get_player_threat_bias());
	
	//find a location
	foreach(target in potentialTargets)
	{
		v_trace 	= BulletTrace( self.origin + (0,0,24),  target.origin + (0,0,24), true, self )[ "position" ];
		dir 		= VectorNormalize(v_trace-self.origin);
		v_trace		= v_trace + (-48*dir);//bring the spot back towards the player
		v_ground 	= BulletTrace( v_trace, v_trace + ( 0, 0, -2048 ), false, target, true )[ "position" ];//find the ground
		
		if( self _isPointValid(v_ground) == false)
			continue;
		
		decoy.origin = v_ground + (0,0,32);
		decoy.primaryThreat = target;
		break;
	}
	
	return decoy;	
}


function decoyThink(lifetime,player)
{
	self playsoundtoplayer( "gdt_cybercore_misdirection_fake_grenade", player );	

	self clientfield::set("makedecoy",1);

	waitTime = lifetime + RandomFloatRange(1,3);
	if( GetDvarInt( "scr_misdirection_debug", 0 ) )
	{
		level thread cybercom_dev::debugpoint(self.origin,waitTime,20,(1,0,0));
	}
	wait waitTime;
	self clientfield::set("makedecoy",0);
	util::wait_network_frame();
	self delete();
}


function add_point_to_mins( vec, mins )
{
	if ( vec[0] < mins[0] )
		mins = ( vec[0], mins[1], mins[2] );
	
	if ( vec[1] < mins[1] )
		mins = ( mins[0], vec[1], mins[2] );
	
	if ( vec[2] < mins[2] )
		mins = ( mins[0], mins[1], vec[2] );

	return mins;
}


function add_point_to_maxs( vec, maxs )
{
	if ( vec[0] > maxs[0] )
		maxs = ( vec[0], maxs[1], maxs[2] );

	if ( vec[1] > maxs[1] )
		maxs = ( maxs[0], vec[1], maxs[2] );

	if ( vec[2] > maxs[2] )
		maxs = ( maxs[0], maxs[1], vec[2] );
	
	return maxs;
}