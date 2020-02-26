#include maps\_art;

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Initialization
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
awarenessInternalInit()
{
	if( !isDefined( level.awarenessUpdateTime ) )
	{
		///////////////////////////////////
		// System tuneables
		///////////////////////////////////
		level.awarenessUpdateTime				= 0.1;


		///////////////////////////////////
		// Radius tuneables
		///////////////////////////////////
		level.awarenessPeripheryZoneRadius[0]	= -1;
		level.awarenessRadius[0]				= -1;


		///////////////////////////////////
		// Material 'None' tuneables
		///////////////////////////////////
		level.awarenessMaterialFxEnabled[1][level.awarenessMaterialNone] = false;
		level.awarenessMaterialFxEnabled[2][level.awarenessMaterialNone] = false;
		level.awarenessMaterialFxEnabled[3][level.awarenessMaterialNone] = false;

		level.awarenessMaterialMinPulseTime[1][level.awarenessMaterialNone]	= 1000;
		level.awarenessMaterialMaxPulseTime[1][level.awarenessMaterialNone]	= 1001;

		level.awarenessMaterialMinPulseTime[2][level.awarenessMaterialNone]	= 1000;
		level.awarenessMaterialMaxPulseTime[2][level.awarenessMaterialNone]	= 1001;

		level.awarenessMaterialMinPulseTime[3][level.awarenessMaterialNone]	= 1000;
		level.awarenessMaterialMaxPulseTime[3][level.awarenessMaterialNone]	= 1001;


		///////////////////////////////////
		// Common material tuneables
		///////////////////////////////////
		for( i=0; i<level.awarenessMaterialMax; i++ )
		{
			level.awarenessMaterialFxEnabled[0][i] = false;
			
			level.awarenessMaterialMinPulseTime[0][i]	= 1000;
			level.awarenessMaterialMaxPulseTime[0][i]	= 1001;

			for( j=0; j<4; j++ )
				level.awarenessMaterialAvgPulseTime[j][i] = (level.awarenessMaterialMinPulseTime[j][i] + level.awarenessMaterialMaxPulseTime[j][i]) * 0.5;
		}


		///////////////////////////////////
		// Glow/Spark FX tuneables
		///////////////////////////////////
		level.awarenessGlowFxEnabled[0] = false;
			
		level.awarenessGlowFx[0] = undefined;

		level.awarenessGlowMinPulseTime[0]	= 1000;
		level.awarenessGlowMaxPulseTime[0]	= 1001;

		for( i=0; i<4; i++ )
			level.awarenessGlowAvgPulseTime[i] = (level.awarenessGlowMinPulseTime[i] + level.awarenessGlowMaxPulseTime[i]) * 0.5;

		
		///////////////////////////////////
		// Shine FX tuneables
		///////////////////////////////////
		level.awarenessShineFxEnabled[0] = false;

		level.awarenessShineMinPulseTime[0]	= 1000;
		level.awarenessShineMaxPulseTime[0]	= 1001;

		for( i=0; i<4; i++ )
			level.awarenessShineAvgPulseTime[i] = (level.awarenessShineMinPulseTime[i] + level.awarenessShineMaxPulseTime[i]) * 0.5;
			
		level.allAwarenessObjects = [];
			
		thread updateLookatThread();
	}
}



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Internal logic
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////
// FX update functions
//////////////////////////////////////////////////////////////////////////////////
updateMaterialFX( enabled, radius_zone, periphery_zone )
{
	if( isDefined( radius_zone ) && isDefined( periphery_zone ) )
	{
		if( self.materialDelay > level.awarenessMaterialAvgPulseTime[periphery_zone][self.awarenessMaterial] )
			self.materialDelay = level.awarenessMaterialAvgPulseTime[periphery_zone][self.awarenessMaterial];

		if( self.materialDelay <= 0 )
		{
			self.materialDelay = randomfloatrange( level.awarenessMaterialMinPulseTime[periphery_zone][self.awarenessMaterial], level.awarenessMaterialMaxPulseTime[periphery_zone][self.awarenessMaterial] );

			if( enabled )
			{
				playfx( level.awarenessMaterialFx[radius_zone][self.awarenessMaterial], self.primaryEntity.origin );
				// play sound as well?
			}
		}
	}
	else
	{
	}
}

updateShineFX( enabled, radius_zone, periphery_zone )
{
	if( isDefined( radius_zone ) && isDefined( periphery_zone ) )
	{
		if( self.shineDelay > level.awarenessShineAvgPulseTime[periphery_zone] )
			self.shineDelay = level.awarenessShineAvgPulseTime[periphery_zone];

		if( self.shineDelay <= 0 )
		{
			self.shineDelay = randomfloatrange( level.awarenessShineMinPulseTime[periphery_zone], level.awarenessShineMaxPulseTime[periphery_zone] );

			if( enabled )
			{
				// kick off shine
			}
		}
	}
	else
	{
	}
}

updateGlowFX( enabled, radius_zone, periphery_zone )
{
	if( isDefined( radius_zone ) && isDefined( periphery_zone ) )
	{
		if( self.glowDelay > level.awarenessGlowAvgPulseTime[periphery_zone] )
			self.glowDelay = level.awarenessGlowAvgPulseTime[periphery_zone];

		if( self.glowDelay <= 0 )
		{
			self.glowDelay = randomfloatrange( level.awarenessGlowMinPulseTime[periphery_zone], level.awarenessGlowMaxPulseTime[periphery_zone] );

			if( enabled )
			{
				playfx( level.awarenessGlowFx[radius_zone], self.primaryEntity.origin );
			}
		}
	}
	else
	{
	}
}

	
//////////////////////////////////////////////////////////////////////////////////
// Zone calculation functions
//////////////////////////////////////////////////////////////////////////////////
checkRadiusZone()
{
	for ( zone = 1; zone <= 3; zone++ )
	{
		if( level.awarenessRadius[zone] < 0 )
			return zone;
			
		if( distance( level.player.origin, self.primaryEntity.origin ) < level.awarenessRadius[zone] )
			return zone;
	}
	
	return 0;
}

checkPeripheryZone()
{
	for ( zone = 1; zone <= 3; zone++ )
	{
		if( level.awarenessPeripheryZoneRadius[zone] < 0 )
			return zone;
			
		if( target_isincircle( self.primaryEntity, level.player, int(getdvar( "cg_fov" )), level.awarenessPeripheryZoneRadius[zone] ) )
			return zone;
	}
	
	return 0;
}

awarenessUpdate( awareness_object )
{
	self endon( "stopeffect" );
	
	while( 1 )
	{
		wait level.awarenessUpdateTime;
		
		if( awareness_object.enabled )
		{
			awareness_object.glowDelay -= level.awarenessUpdateTime;
			awareness_object.materialDelay -= level.awarenessUpdateTime;
			awareness_object.shineDelay -= level.awarenessUpdateTime;
			
			radius_zone = awareness_object checkRadiusZone();
			if( radius_zone > 0 || level.awarenessZoneMix != 0 )
			{
				periphery_zone = awareness_object checkPeripheryZone();
				
				if( level.awarenessZoneMix == 1 ) // worst
				{
					if( radius_zone > 0 && (periphery_zone > radius_zone || periphery_zone == 0) )
						radius_zone = periphery_zone;
					else 
						periphery_zone = radius_zone;
				}
				else if( level.awarenessZoneMix == 2 ) // best
				{
					if( periphery_zone < radius_zone && periphery_zone > 0)
						radius_zone = periphery_zone;
					else 
						periphery_zone = radius_zone;
				}
				else if( level.awarenessZoneMix == 3 ) // avg
				{
					if( periphery_zone == 0 )
						periphery_zone = 4;
						
					if( radius_zone == 0 )
						radius_zone = 4;
						
					avg_zone = int( ( (periphery_zone + radius_zone) * 0.5 ) + 0.5 );
					
					if( avg_zone > 3 )
						avg_zone = 0;
					
					periphery_zone = avg_zone;
					radius_zone = avg_zone;
				}
				else if( level.awarenessZoneMix == 4 ) // swap
				{
					swap_zone = periphery_zone;
					periphery_zone = radius_zone;
					radius_zone = swap_zone;
				}
				else if( level.awarenessZoneMix == 5 ) // radius only
				{
					periphery_zone = radius_zone;
				}
				else if( level.awarenessZoneMix == 6 ) // periphery only
				{
					radius_zone = periphery_zone;
				}
				
				if( awareness_object.enableFX )
				{
					shine_enabled = awareness_object.awarenessShine;
					if( shine_enabled )
						shine_enabled = level.awarenessShineFxEnabled[radius_zone];
					awareness_object updateShineFX( shine_enabled, radius_zone, periphery_zone );
					
					material_enabled = level.awarenessMaterialFxEnabled[radius_zone][awareness_object.awarenessMaterial];
					if( material_enabled && awareness_object.awarenessMaterial == level.awarenessMaterialNone )
						material_enabled = false;
					awareness_object updateMaterialFX( material_enabled, radius_zone, periphery_zone );
					
					glow_enabled = awareness_object.awarenessGlow;
					if( glow_enabled )
						glow_enabled = level.awarenessGlowFxEnabled[radius_zone];
					awareness_object updateGlowFX( glow_enabled, radius_zone, periphery_zone );
				}
				else
				{
					awareness_object updateMaterialFX( false );
					awareness_object updateShineFX( false );
					awareness_object updateGlowFX( false );
				}
			}
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////
// Callback utility functions
//////////////////////////////////////////////////////////////////////////////////
awarenessInternalSetDamageCallback( damage_event_to_call, allow_aim_assist )
{
	if( self.active )
	{
		if( isDefined( damage_event_to_call ) )
		{
			if( !isDefined(allow_aim_assist) || allow_aim_assist)
				self.allowAimAssist = true;
			else
				self.allowAimAssist = false;

			self.damageEventToCall = damage_event_to_call;
		}
		else
		{
			self.allowAimAssist = false;
			
			self.damageEventToCall = undefined;
		}


		if( isDefined( self.triggerEntities ) )
		{
			for( i=0; i<self.triggerEntities.size; i++ )
			{
				if( self.triggerEntities[i] != self.primaryEntity )
				{
					if( self.triggerEntities[i].classname != "script_model" )
					{
						if( self.allowAimAssist && self.enabled )
							self.triggerEntities[i] enableAimAssist();
						else
							self.triggerEntities[i] disableAimAssist();
					}
					
					self.triggerEntities[i] setCanDamage( isDefined( damage_event_to_call ) && self.enabled );
				}
			}
		}
		
		if( self.primaryEntity.classname != "script_model" )
		{
			if( self.allowAimAssist && self.enabled )
				self.primaryEntity enableAimAssist();
			else
				self.primaryEntity disableAimAssist();
		}
		
		self.primaryEntity setCanDamage( isDefined( damage_event_to_call ) && self.enabled );
	}
}

awarenessInternalSetUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat )
{
	if( self.active )
	{
		if( isDefined( use_event_to_call ) )
		{
			if( self.enabled )
			{
				if( !isDefined( self.useObject ) )
				{
					self.useObject = maps\_useableobjects::create_useable_object( self.primaryEntity, undefined, hint_string, use_time, use_text, single_use, require_lookat, true );
				}
				else
				{
					self.useObject maps\_useableobjects::set_on_use_function( undefined );
					self.useObject maps\_useableobjects::set_hint_string( hint_string );
					self.useObject maps\_useableobjects::set_use_time( use_time );
					self.useObject maps\_useableobjects::set_use_text( use_text );
					self.useObject maps\_useableobjects::set_single_use( false );
					self.useObject maps\_useableobjects::set_require_lookat( require_lookat );
					self.useObject maps\_useableobjects::set_active( true );
				}
			}
			else 
			{
				if( isDefined( self.useObject ) )
					self.useObject maps\_useableobjects::set_active( false );
			}

			self.useEventToCall  = use_event_to_call;
		}
		else
		{
			self.useEventToCall = undefined;
			
			if( isDefined( self.useObject ) )
				self.useObject maps\_useableobjects::set_active( false );
		}
	}
}

awarenessDamageCallbackUpdateThread( awareness_object )
{
	awareness_object.primaryEntity endon( "awarenesstriggered" );
	
	while( awareness_object.active )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );

		if( awareness_object.enabled )
		{
			awareness_object.triggeredDamage = true;
			awareness_object.triggeredUse = false;
			
			awareness_object.damageAmount = damage;
			awareness_object.damageAttacker = attacker;
			awareness_object.damageDirection = direction_vec;
			awareness_object.damagePoint = point;
			awareness_object.damageType = type;
			awareness_object.damageModelName = modelName;
			awareness_object.damageTagName = tagName;
			
			awarenessSuccess = true;
			if( isdefined( awareness_object.filterToCall ) )
				awarenessSuccess = [[ awareness_object.filterToCall ]]( awareness_object );
				
			if( awarenessSuccess )
				awareness_object thread awarenessCallback( awareness_object.damageEventToCall );

//			self setBondAwareness( false );
		}
	}
}

awarenessUseCallbackUpdateThread( awareness_object )
{
	awareness_object.primaryEntity endon( "awarenesstriggered" );
	
	while( awareness_object.active )
	{
		awareness_object.primaryEntity waittill ( "useable_activated", player );

		if( awareness_object.enabled )
		{
			awareness_object.triggeredDamage = false;
			awareness_object.triggeredUse = true;
			
			awareness_object.useEntity = player;
			
			awarenessSuccess = true;
			if( isdefined( awareness_object.filterToCall ) )
				awarenessSuccess = [[ awareness_object.filterToCall ]]( awareness_object );
				
			if( awarenessSuccess )
				awareness_object thread awarenessCallback( awareness_object.useEventToCall );
		}

//		self setBondAwareness( false );
	}
}

awarenessCallback( event_to_call )
{
	if( isDefined( event_to_call ) && self.active )
	{
		self.active = false;
		
		if( isdefined( self.useObject ) )
			self.useObject maps\_useableobjects::set_active( false );
		
		self.primaryEntity notify( "awarenesstriggered" );
		self.primaryEntity notify( "stopeffect" );
		
		if( isDefined( self.triggerEntities ) )
		{
			for( i=0; i<self.triggerEntities.size; i++ )
			{
				if( self.triggerEntities[i] != self.primaryEntity )
				{
					if( self.triggerEntities[i].classname != "script_model" )
						self.triggerEntities[i] disableAimAssist();
				}
			}
		}
		
		if( self.primaryEntity.classname != "script_model" )
			self.primaryEntity disableAimAssist();
		
		
		self updateMaterialFX( false );
		self updateShineFX( false );
		self updateGlowFX( false );

		//Now trigger the passed in script function if it is valid
		if( isdefined( event_to_call ) )
			[[ event_to_call ]]( self );

		if ( IsDefined( self.primaryEntity ) )
		{
			self.primaryEntity notify( "awarenessfinished" );
//			self.primaryEntity setBondAwareness( false );
		}
	}
}

awarenessSetupCallbacks( trigger_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call )
{
	self.damageEventToCall = undefined;
	self.useEventToCall = undefined;
	self.triggerEntities = trigger_entities;
	
	//Setup filter
	self maps\_playerawareness::setFilterCallback( filter_to_call );
	
	//Setup for damage
	self maps\_playerawareness::setDamageCallback( damage_event_to_call, allow_aim_assist );
	self.primaryEntity thread awarenessDamageCallbackUpdateThread( self );
	if( isDefined( self.triggerEntities ) )
	{
		for( i=0; i<self.triggerEntities.size; i++ )
		{
			if( self.triggerEntities[i] != self.primaryEntity )
				self.triggerEntities[i] thread awarenessDamageCallbackUpdateThread( self );
		}
	}

	//Setup for use
	self maps\_playerawareness::setUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat );
	self.primaryEntity thread awarenessUseCallbackUpdateThread( self );
}


//////////////////////////////////////////////////////////////////////////////////
// Creation function
//////////////////////////////////////////////////////////////////////////////////
createAwarenessObject( primary_entity, trigger_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine )
{
	awareness_object = spawnStruct();
	
	awareness_object.active = true;
	awareness_object.enabled = true;
	awareness_object.primaryEntity = primary_entity;
	awareness_object.primaryEntity.awarenessObject = awareness_object;

	awareness_object.enableFX = true;

	awareness_object maps\_playerawareness::setAwarenessMaterial( awareness_material );
	awareness_object maps\_playerawareness::setAwarenessGlowEnabled( awareness_glow );
	awareness_object maps\_playerawareness::setAwarenessShineEnabled( awareness_shine );
		
	awareness_object.glowDelay = level.awarenessGlowMaxPulseTime[0];
	awareness_object.materialDelay = level.awarenessMaterialMaxPulseTime[0][awareness_object.awarenessMaterial];
	awareness_object.shineDelay = level.awarenessShineMaxPulseTime[0];
	
	awareness_object awarenessSetupCallbacks( trigger_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call );
	
	awareness_object.primaryEntity thread awarenessUpdate( awareness_object );
	
	level.allAwarenessObjects[ level.allAwarenessObjects.size ] = awareness_object;

//	awareness_object.primaryEntity setBondAwareness( true );
	
	return awareness_object;
}











///////////////////////////////////////////////////////
// Technically this is *not* multiplayer safe. 
// It is written like it could be, so that it 
// can be easily copied and fixed for MP later.
///////////////////////////////////////////////////////
resetAwarenessCameraThread()
{
	self.primaryEntity notify( "awarenesschangecameratriggers" );
	wait 0.05;
	self thread awarenessCameraTriggerUpdate();
}

awarenessCameraTriggerUpdate()
{
	self.primaryEntity endon( "awarenesstriggered" );
	self.primaryEntity endon( "awarenesschangecameratriggers" );
	
	if( isDefined( self.cameraTriggers ) && self.cameraTriggers.size > 0 && self.cameraTriggers[0] != self.primaryEntity )
	{
		for( i=0; i<self.cameraTriggers.size; i++ )
			self thread awarenessCameraTrigger( self.cameraTriggers[i] );
			
		self.inCameraTrigger[0] = self.primaryEntity;
			
		while( 1 )
		{
			self.primaryEntity waittill( "awarenesscameratriggered" );
			
			wait 0.001;
			
			for( i=0; i<self.inCameraTrigger.size; i++ )
				self.inCameraTrigger[i] = self.primaryEntity;
		}
	}
}

awarenessCameraTrigger( trigger_ent )
{
	self.primaryEntity endon( "awarenesstriggered" );
	self.primaryEntity endon( "awarenesschangecameratriggers" );
	
	while( 1 )
	{
		trigger_ent waittill( "trigger", entered_trigger );

		players = getEntArray( "player", "classname" );
		for( i = 0; i < players.size; i++ )
		{
			if( entered_trigger == players[i] )
			{
				found_index = false;
				
				for( j=0; j<self.inCameraTrigger.size && !found_index; j++ )
				{
					if( self.inCameraTrigger[j] == entered_trigger )
						found_index = true;
				}
				
				if( !found_index )
				{
					for( j=0; j<self.inCameraTrigger.size && !found_index; j++ )
					{
						if( self.inCameraTrigger[j] == self.primaryEntity )
						{
							self.inCameraTrigger[j] = entered_trigger;
							found_index = true;
						}
					}
					
					if( !found_index )
						self.inCameraTrigger[self.inCameraTrigger.size] = entered_trigger;
				}
				
				self.primaryEntity notify( "awarenesscameratriggered" );
				i = players.size;
			}
		}
	}
}


awarenessHasExternalCamera( awareness_object )
{
	external_cam = 0;
	
	if(    isDefined( awareness_object.externalCameraFile ) 
		&& isDefined( awareness_object.externalCameraName ) 
		&& awareness_object.externalCameraFile != "" 
		&& awareness_object.externalCameraName != "" 
	  )
	{
		external_cam = 1;
	}
	
	return external_cam;
}

awarenessHasCameraTriggers( awareness_object )
{
	cam_triggers = 0;
	
	if( isDefined( awareness_object.inCameraTrigger )
		&& isDefined( awareness_object.cameraTriggers ) 
		&& awareness_object.cameraTriggers.size > 0 
		&& awareness_object.cameraTriggers[0] != awareness_object.primaryEntity 
	  )
	{
		cam_triggers = 1;
	}
	
	return cam_triggers;
}
	  

awarenessCalcScore( player, awareness_object, view_origin, view_angles, view_forward, max_dist, allow_behind, require_los )
{
	score = -1.0;
	
	if( isDefined( awareness_object.enableLookat ) && awareness_object.enableLookat != 0 )
	{
		delta = awareness_object.primaryEntity.origin - view_origin;
		dist = length( delta );

		if( dist < max_dist )
		{
			if( dist > 0.001 )
				norm_delta = vectorNormalize( delta );
			else
				norm_delta = view_forward;
			
			dotp = vectorDot( norm_delta, view_forward );
			
			if( allow_behind )
				dotp = (dotp + 1.0) * 0.5;
			
			if( dotp > 1.0 )
				dotp = 1.0;
			if( dotp < -1.0 )
				dotp = -1.0;
				
			if( dotp >= 0.0 )
			{
				has_los = 1;
				
				if( require_los )
				{
					has_los = sightTracePassed(view_origin, awareness_object.primaryEntity.origin, false, awareness_object.primaryEntity );
				}
			
				if( has_los )
				{
					if( isDefined( awareness_object.priority ) )
						score = awareness_object.priority;
					else
						score = 0.0;
				}
			}
		}

/*
		if( dist < 0.001 )
		{
			score = 1.0;
		}
		else if( dist < max_dist )
		{
			norm_delta = vectorNormalize( delta );
			
			dotp = vectorDot( norm_delta, view_forward );
			
			if( allow_behind )
				dotp = (dotp + 1.0) * 0.5;
			
			if( dotp > 1.0 )
				dotp = 1.0;
			if( dotp < -1.0 )
				dotp = -1.0;
				
			if( dotp >= 0.0 )
			{
				has_los = 1;
				
				if( require_los )
				{
					has_los = sightTracePassed(view_origin, awareness_object.primaryEntity.origin, false, awareness_object.primaryEntity );
				}
			
				if( has_los )
				{
					dist_score = 1.0 - (dist / max_dist);
					dot_score = dotp;
				
//					dot_score = dot_score * dot_score * dot_score * dot_score * dot_score * dot_score * dot_score * dot_score;
				
					score = (dist_score * dot_score);
				}
			}
		}
*/
	}
		
	return score;
}

findBestAwarenessEntity( player, prev_awareness_indices )
{
	available_awareness_indices = [];
	awareness_index_use_trigger = [];

	view_origin = player getViewOrigin();
	view_angles = player getViewAngles();
	view_forward = vectorNormalize( anglesToForward(view_angles) );
	allow_behind = getDvarInt( "custom_camera_awareness_allow_behind" );
	max_dist = getDvarFloat( "custom_camera_awareness_max_range" );
	require_los = getDvarInt( "custom_camera_awareness_require_los" );

	for( i=0; i<level.allAwarenessObjects.size; i++ )
	{
		if( level.allAwarenessObjects[i].active && level.allAwarenessObjects[i].enabled )
		{
			available = true;
			use_trigger = false;
			
			for( j=0; j<prev_awareness_indices.size && available; j++ )
			{ 
				if( prev_awareness_indices[j] == i )
					available = false;
			}
			
			if( available && awarenessHasCameraTriggers( level.allAwarenessObjects[i] ) )
			{
				available = false;
				
				for( j=0; j<level.allAwarenessObjects[i].inCameraTrigger.size && !available; j++ )
				{
					if( level.allAwarenessObjects[i].inCameraTrigger[j] == player )
					{
						available = true;
						use_trigger = true;
					}
				}
			}
			
			
			if( available )
			{
				available_awareness_indices[available_awareness_indices.size] = i;
				awareness_index_use_trigger[awareness_index_use_trigger.size] = use_trigger;
			}
		}
	}
	
	best_index = -1;
	best_score = -0.001;
	for( i=0; i<available_awareness_indices.size; i++ )
	{
		score = awarenessCalcScore( player, level.allAwarenessObjects[available_awareness_indices[i]], view_origin, view_angles, view_forward, max_dist, allow_behind, (require_los && !awareness_index_use_trigger[i]) );
		if( score > best_score )
		{
			best_score = score;
			best_index = available_awareness_indices[i];
		}
	}
	
	return best_index;
}


updateLookatThread()
{
	level.awarenessCurrentLookatInfo = [];
	level.awarenessShowIcon = false;
	
	wait_time = 0.05;
	lerp_to_time = getDvarFloat( "custom_camera_awareness_lerp_to_time" );
	lerp_back_time = getDvarFloat( "custom_camera_awareness_lerp_back_time" );
	
	
	while(1)
	{
		wait wait_time;
		
		players = getEntArray( "player", "classname" );
		
		cover_only = getDvarInt("custom_camera_awareness_cover_only");
		
		if( getDvarInt("custom_camera_awareness_enable") != 0 )
		{
			for( i = 0; i < players.size; i++ )
			{
				if ( !isDefined( level.awarenessCurrentLookatInfo[i] ) )
				{
					level.awarenessCurrentLookatInfo[i] = spawnStruct();
					level.awarenessCurrentLookatInfo[i].custom_camera_id = 0;
					level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = 0.0;
					level.awarenessCurrentLookatInfo[i].prev_awareness_indices = [];
					level.awarenessCurrentLookatInfo[i].awareness_index = -1;
					level.awarenessCurrentLookatInfo[i].wait_for_release = false;
					level.awarenessCurrentLookatInfo[i].locked = false;
				}

				if( level.awarenessCurrentLookatInfo[i].locked )
				{
					level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = wait_time;
				}
				else if( level.awarenessCurrentLookatInfo[i].custom_camera_switch_time <= 999 )
				{
					level.awarenessCurrentLookatInfo[i].custom_camera_switch_time -= wait_time;
					if( level.awarenessCurrentLookatInfo[i].custom_camera_switch_time < 0.0 )
						level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = 0.0;
				}
				
				if( (players[i] buttonPressed("DPAD_LEFT")) && (!cover_only || (players[i] isInCover())) )
				{
					if( !level.awarenessCurrentLookatInfo[i].wait_for_release )
					{
						if( level.awarenessCurrentLookatInfo[i].custom_camera_switch_time <= 0 )
						{
							found_prev_index = false;
							for( j=0; j<level.awarenessCurrentLookatInfo[i].prev_awareness_indices.size && !found_prev_index; j++ )
							{
								if( level.awarenessCurrentLookatInfo[i].prev_awareness_indices[j] < 0 )
								{
									level.awarenessCurrentLookatInfo[i].prev_awareness_indices[j] = level.awarenessCurrentLookatInfo[i].awareness_index;
									found_prev_index = true;
								}
							}
							
							if( !found_prev_index )
								level.awarenessCurrentLookatInfo[i].prev_awareness_indices[level.awarenessCurrentLookatInfo[i].prev_awareness_indices.size] = level.awarenessCurrentLookatInfo[i].awareness_index;
							
							if( level.awarenessCurrentLookatInfo[i].prev_awareness_indices[0] == -1 || getDvarInt("custom_camera_awareness_show_all") != 0 )
								level.awarenessCurrentLookatInfo[i].awareness_index = findBestAwarenessEntity( players[i], level.awarenessCurrentLookatInfo[i].prev_awareness_indices );
							else
								level.awarenessCurrentLookatInfo[i].awareness_index = -1;
								
							if( level.awarenessCurrentLookatInfo[i].awareness_index >= 0 )
							{
								if( awarenessHasExternalCamera( level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index] ) )
								{
									if( level.awarenessCurrentLookatInfo[i].custom_camera_id == 0 )
										level.awarenessCurrentLookatInfo[i].custom_camera_id = players[i] customcamera_push("external", level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].externalCameraFile, level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].externalCameraName );
									else
										players[i] customcamera_change(level.awarenessCurrentLookatInfo[i].custom_camera_id, "external", level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].externalCameraFile, level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].externalCameraName );
								}
								else
								{
									if( level.awarenessCurrentLookatInfo[i].custom_camera_id == 0 )
										level.awarenessCurrentLookatInfo[i].custom_camera_id = players[i] customcamera_push("offset", level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].primaryEntity, lerp_to_time );
									else
										players[i] customcamera_change(level.awarenessCurrentLookatInfo[i].custom_camera_id, "offset", level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].primaryEntity, lerp_to_time );
										
									dist = distance( players[i] getViewOrigin(), level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].primaryEntity.origin );
									players[i] customcamera_setDoF( level.awarenessCurrentLookatInfo[i].custom_camera_id, 0.0, dist - 24.0, dist + 24.0, dist + 24.0 + dist, 5.0, 5.0 );
									players[i] customcamera_setFov( level.awarenessCurrentLookatInfo[i].custom_camera_id, 45.0 );
								}

								if( isDefined( level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].passback_time ) )
								{
									level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index].passback_time;
									if( level.awarenessCurrentLookatInfo[i].custom_camera_switch_time < 0 )
										level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = 1000;
								}
								else
									level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = 1000;
								
								players[i] freezeControls( true );
								players[i] notify( "awareness_lookat", level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index] );
							}
							else
								level.awarenessCurrentLookatInfo[i].wait_for_release = true;
						}
					}
				}
				else if ( !level.awarenessCurrentLookatInfo[i].locked )
				{
					level.awarenessCurrentLookatInfo[i].awareness_index = -1;
					level.awarenessCurrentLookatInfo[i].wait_for_release = false;
				}

				if( isDefined( level.awarenessCurrentLookatInfo[i] ) && level.awarenessCurrentLookatInfo[i].awareness_index < 0 )
				{
					if( level.awarenessCurrentLookatInfo[i].custom_camera_id != 0 )
					{
						players[i] customcamera_pop( level.awarenessCurrentLookatInfo[i].custom_camera_id, lerp_back_time );
						players[i] freezeControls( false );
					}
					
					level.awarenessCurrentLookatInfo[i].custom_camera_id = 0;
					level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = 0.0;
					level.awarenessCurrentLookatInfo[i].awareness_index = -1;
					
					for( j=0; j<level.awarenessCurrentLookatInfo[i].prev_awareness_indices.size; j++ )
						level.awarenessCurrentLookatInfo[i].prev_awareness_indices[j] = -1;
				}					
			}
		}
		else
		{
			for( i = 0; i < players.size; i++ )
			{
				if( isDefined( level.awarenessCurrentLookatInfo[i] ) )
				{
					if( level.awarenessCurrentLookatInfo[i].custom_camera_id != 0 )
					{
						players[i] customcamera_pop( level.awarenessCurrentLookatInfo[i].custom_camera_id, lerp_back_time );
						players[i] freezeControls( false );
					}
						
					level.awarenessCurrentLookatInfo[i].custom_camera_id = 0;
					level.awarenessCurrentLookatInfo[i].custom_camera_switch_time = 0.0;
					level.awarenessCurrentLookatInfo[i].awareness_index = -1;
				
					for( j=0; j<level.awarenessCurrentLookatInfo[i].prev_awareness_indices.size; j++ )
						level.awarenessCurrentLookatInfo[i].prev_awareness_indices[j] = -1;
				}
			}
		}
		
		if( level.awarenessShowIcon )
		{
		}
		else
		{
		}
	}
}
