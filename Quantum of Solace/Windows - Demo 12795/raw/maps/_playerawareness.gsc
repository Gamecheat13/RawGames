#include common_scripts\utility;
#include maps\_playerawareness_internal;

/*////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Data documentation
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

	//////////////////////////////////////////////////////////////////////////////
	// All variables are read-only, and should not be set manually.
	// (*) - May be undefined, if not used.
	//////////////////////////////////////////////////////////////////////////////
	awarenessObject.primaryEntity	- The entity the awareness is attached to
	awarenessObject.triggerEntities	- (*)Multiple triggers assigned to the object
	awarenessObject.useObject		- (*)The useable object

	awarenessObject.triggeredDamage	- Set to true if triggered by damage
	awarenessObject.damageAmount	- Amount of damage that was applied
	awarenessObject.damageAttacker	- Attacker that applied the damage
	awarenessObject.damageDirection - Direction of the damage
	awarenessObject.damagePoint		- Point the damage hit
	awarenessObject.damageType		- Type of damage
	awarenessObject.damageModelName - Model name
	awarenessObject.damageTagName	- Tag name
	
	awarenessObject.triggeredUse	- Set to true if triggered by useage
	awarenessObject.useEntity		- Entity that used the trigger
	
////////////////////////////////////////////////////////////////////////////////*/

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Initialization
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
init()
{
	///////////////////////////////////
	// Zone mixing
	///////////////////////////////////
	level.awarenessZoneMix = 0; // 0 = individual
								// 1 = worst
								// 2 = best
								// 3 = avg
								// 4 = swap
								// 5 = radius only
								// 6 = periphery only
								
	///////////////////////////////////
	// Radius tuneables
	///////////////////////////////////
	level.awarenessPeripheryZoneRadius[1]	= 100;
	level.awarenessPeripheryZoneRadius[2]	= 250; //200 previous
	level.awarenessPeripheryZoneRadius[3]	= -1;
	
	level.awarenessRadius[1]	= 500;
	level.awarenessRadius[2]	= 1000;
	level.awarenessRadius[3]	= 1500;
	
	
	///////////////////////////////////
	// Material constants
	///////////////////////////////////
	level.awarenessMaterialNone		= 0; // Do not change!
	
	level.awarenessMaterialWood		= 1;
	level.awarenessMaterialMetal	= 2;
	level.awarenessMaterialElectric = 3;
	level.awarenessMaterialStone	= 4;
	
	level.awarenessMaterialMax		= 5; // Must be updated!
	
	
	///////////////////////////////////
	// Material 'Wood' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[1][level.awarenessMaterialWood] = true;
	level.awarenessMaterialFxEnabled[2][level.awarenessMaterialWood] = true;
	level.awarenessMaterialFxEnabled[3][level.awarenessMaterialWood] = true;
	
	level.awarenessMaterialFx[1][level.awarenessMaterialWood] = loadfx( "misc/surface_aware_wood" );
	level.awarenessMaterialFx[2][level.awarenessMaterialWood] = loadfx( "misc/surface_aware_wood" );
	level.awarenessMaterialFx[3][level.awarenessMaterialWood] = loadfx( "misc/surface_aware_wood" );
	
	level.awarenessMaterialMinPulseTime[1][level.awarenessMaterialWood]	= 5.1;
	level.awarenessMaterialMaxPulseTime[1][level.awarenessMaterialWood]	= 15;

	level.awarenessMaterialMinPulseTime[2][level.awarenessMaterialWood]	= 3.1;
	level.awarenessMaterialMaxPulseTime[2][level.awarenessMaterialWood]	= 5;

	level.awarenessMaterialMinPulseTime[3][level.awarenessMaterialWood]	= 1;
	level.awarenessMaterialMaxPulseTime[3][level.awarenessMaterialWood]	= 3;


	///////////////////////////////////
	// Material 'Metal' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[1][level.awarenessMaterialMetal] = true;
	level.awarenessMaterialFxEnabled[2][level.awarenessMaterialMetal] = true;
	level.awarenessMaterialFxEnabled[3][level.awarenessMaterialMetal] = true;
	
	level.awarenessMaterialFx[1][level.awarenessMaterialMetal] = loadfx( "misc/surface_aware_metal" );
	level.awarenessMaterialFx[2][level.awarenessMaterialMetal] = loadfx( "misc/surface_aware_metal" );
	level.awarenessMaterialFx[3][level.awarenessMaterialMetal] = loadfx( "misc/surface_aware_metal" );
	
	level.awarenessMaterialMinPulseTime[1][level.awarenessMaterialMetal]	= 5.1;
	level.awarenessMaterialMaxPulseTime[1][level.awarenessMaterialMetal]	= 15;

	level.awarenessMaterialMinPulseTime[2][level.awarenessMaterialMetal]	= 3.1;
	level.awarenessMaterialMaxPulseTime[2][level.awarenessMaterialMetal]	= 5;

	level.awarenessMaterialMinPulseTime[3][level.awarenessMaterialMetal]	= 1;
	level.awarenessMaterialMaxPulseTime[3][level.awarenessMaterialMetal]	= 3;


	///////////////////////////////////
	// Material 'Electric' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[1][level.awarenessMaterialElectric] = true;
	level.awarenessMaterialFxEnabled[2][level.awarenessMaterialElectric] = true;
	level.awarenessMaterialFxEnabled[3][level.awarenessMaterialElectric] = true;
	
	level.awarenessMaterialFx[1][level.awarenessMaterialElectric] = loadfx( "misc/surface_aware_metal" );
	level.awarenessMaterialFx[2][level.awarenessMaterialElectric] = loadfx( "misc/surface_aware_metal" );
	level.awarenessMaterialFx[3][level.awarenessMaterialElectric] = loadfx( "misc/surface_aware_metal" );
	
	level.awarenessMaterialMinPulseTime[1][level.awarenessMaterialElectric]	= 5.1;
	level.awarenessMaterialMaxPulseTime[1][level.awarenessMaterialElectric]	= 15;

	level.awarenessMaterialMinPulseTime[2][level.awarenessMaterialElectric]	= 3.1;
	level.awarenessMaterialMaxPulseTime[2][level.awarenessMaterialElectric]	= 5;

	level.awarenessMaterialMinPulseTime[3][level.awarenessMaterialElectric]	= 1;
	level.awarenessMaterialMaxPulseTime[3][level.awarenessMaterialElectric]	= 3;


	///////////////////////////////////
	// Material 'Stone' tuneables
	///////////////////////////////////
	level.awarenessMaterialFxEnabled[1][level.awarenessMaterialStone] = true;
	level.awarenessMaterialFxEnabled[2][level.awarenessMaterialStone] = true;
	level.awarenessMaterialFxEnabled[3][level.awarenessMaterialStone] = true;
	
	level.awarenessMaterialFx[1][level.awarenessMaterialStone] = loadfx( "misc/surface_aware_stone" );
	level.awarenessMaterialFx[2][level.awarenessMaterialStone] = loadfx( "misc/surface_aware_stone" );
	level.awarenessMaterialFx[3][level.awarenessMaterialStone] = loadfx( "misc/surface_aware_stone" );

	level.awarenessMaterialMinPulseTime[1][level.awarenessMaterialStone]	= 5.1;
	level.awarenessMaterialMaxPulseTime[1][level.awarenessMaterialStone]	= 15;

	level.awarenessMaterialMinPulseTime[2][level.awarenessMaterialStone]	= 3.1;
	level.awarenessMaterialMaxPulseTime[2][level.awarenessMaterialStone]	= 5;

	level.awarenessMaterialMinPulseTime[3][level.awarenessMaterialStone]	= 1;
	level.awarenessMaterialMaxPulseTime[3][level.awarenessMaterialStone]	= 3;


	///////////////////////////////////
	// Glow/Spark FX tuneables
	///////////////////////////////////
	level.awarenessGlowFxEnabled[1] = false;
	level.awarenessGlowFxEnabled[2] = false;
	level.awarenessGlowFxEnabled[3] = false;
		
	level.awarenessGlowFx[1] = loadfx( "misc/action_awareness" );
	level.awarenessGlowFx[2] = loadfx( "misc/action_awareness" );
	level.awarenessGlowFx[3] = loadfx( "misc/action_awareness" );

	level.awarenessGlowMinPulseTime[1]	= 5.1;
	level.awarenessGlowMaxPulseTime[1]	= 15.1;

	level.awarenessGlowMinPulseTime[2]	= 3;
	level.awarenessGlowMaxPulseTime[2]	= 5;

	level.awarenessGlowMinPulseTime[3]	= 0.4;
	level.awarenessGlowMaxPulseTime[3]	= 0.5;


	///////////////////////////////////
	// Shine FX tuneables
	///////////////////////////////////
	level.awarenessShineFxEnabled[1] = true;
	level.awarenessShineFxEnabled[2] = true;
	level.awarenessShineFxEnabled[3] = true;

	level.awarenessShineMinPulseTime[1]	= 5.1;
	level.awarenessShineMaxPulseTime[1]	= 15;

	level.awarenessShineMinPulseTime[2]	= 3.1;
	level.awarenessShineMaxPulseTime[2]	= 5;

	level.awarenessShineMinPulseTime[3]	= 1;
	level.awarenessShineMaxPulseTime[3]	= 3;


	///////////////////////////////////
	// Internal initialization
	///////////////////////////////////
	awarenessInternalInit();

		
	///////////////////////////////////
	// Common Bond awareness objects
	///////////////////////////////////
}


//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Creation functions
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
	
//////////////////////////////////////////////////////////////////////////////////
// Single entity linked to an event/callback.
//////////////////////////////////////////////////////////////////////////////////
setupSingle(	awareness_entity_name, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine, 
				wait_until_finished )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupSingleDamageOnly(	awareness_entity_name, 
						damage_event_to_call, 
						allow_aim_assist, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupSingleUseOnly( awareness_entity_name, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine, 
					wait_until_finished )
{
	return setupEntSingle( getent( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupSingleNoWait(	awareness_entity_name, 
					damage_event_to_call, 
					allow_aim_assist, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupSingleDamageOnlyNoWait(	awareness_entity_name, 
								damage_event_to_call, 
								allow_aim_assist, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupSingleUseOnlyNoWait(	awareness_entity_name, 
							use_event_to_call, 
							hint_string, 
							use_time, 
							use_text, 
							single_use, 
							require_lookat, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntSingle(	getent( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntSingle( awareness_entity, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine, 
				wait_until_finished )
{
	assertEX (isdefined (awareness_entity), "setupEntSingle: awareness_entity is undefined");

	awareness_object = createAwarenessObject( awareness_entity, undefined, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
	
	if( isDefined( wait_until_finished ) && wait_until_finished )
		awareness_object waitForAwarenessCompletion();
		
	return awareness_object;
}



setupEntSingleDamageOnly(	awareness_entity, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine, 
							wait_until_finished )
{
	return setupEntSingle( awareness_entity, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntSingleUseOnly(	awareness_entity, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntSingle( awareness_entity, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntSingleNoWait(	awareness_entity, 
						damage_event_to_call, 
						allow_aim_assist, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	return setupEntSingle( awareness_entity, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntSingleDamageOnlyNoWait( awareness_entity, 
								damage_event_to_call, 
								allow_aim_assist, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntSingle( awareness_entity, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntSingleUseOnlyNoWait(	awareness_entity, 
								use_event_to_call, 
								hint_string, 
								use_time, 
								use_text, 
								single_use, 
								require_lookat, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntSingle( awareness_entity, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
// Array of individual entities, each linked to it's own event/callback.
//////////////////////////////////////////////////////////////////////////////////
setupArray( awareness_entity_name, 
			damage_event_to_call, 
			allow_aim_assist, 
			use_event_to_call, 
			hint_string, 
			use_time, 
			use_text, 
			single_use, 
			require_lookat, 
			filter_to_call, 
			awareness_material, 
			awareness_glow, 
			awareness_shine )
{
	setupEntArray( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
}



setupArrayDamageOnly(	awareness_entity_name, 
						damage_event_to_call, 
						allow_aim_assist, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	setupEntArray( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine );
}



setupArrayUseOnly(	awareness_entity_name, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine )
{
	setupEntArray( getentarray( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
}



setupEntArray(	awareness_entities, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine )
{
	for( i=0; i<awareness_entities.size; i++ )
	{
		setupEntSingle( awareness_entities[i], damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
	}
}



setupEntArrayDamageOnly(	awareness_entities, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	setupEntArray( awareness_entities, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntArrayUseOnly(	awareness_entities, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	setupEntArray( awareness_entities, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
// Multiple damage triggers linked to a single event/callback.
//////////////////////////////////////////////////////////////////////////////////
setupMulti( awareness_entity_name, 
			damage_event_to_call, 
			allow_aim_assist, 
			use_event_to_call, 
			hint_string, 
			use_time, 
			use_text, 
			single_use, 
			require_lookat, 
			filter_to_call, 
			awareness_material, 
			awareness_glow, 
			awareness_shine, 
			wait_until_finished )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupMultiDamageOnly(	awareness_entity_name, 
						damage_event_to_call, 
						allow_aim_assist, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupMultiUseOnly(	awareness_entity_name, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine, 
					wait_until_finished )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupMultiNoWait(	awareness_entity_name, 
					damage_event_to_call, 
					allow_aim_assist, 
					use_event_to_call, 
					hint_string, 
					use_time, 
					use_text, 
					single_use, 
					require_lookat, 
					filter_to_call, 
					awareness_material, 
					awareness_glow, 
					awareness_shine )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupMultiDamageOnlyNoWait( awareness_entity_name, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupMultiUseOnlyNoWait(	awareness_entity_name, 
							use_event_to_call, 
							hint_string, 
							use_time, 
							use_text, 
							single_use, 
							require_lookat, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntMulti( getentarray( awareness_entity_name, "targetname" ), undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntMulti(	awareness_entities, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine, 
				wait_until_finished )
{
	awareness_object = createAwarenessObject( awareness_entities[0], awareness_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );
	
	if( isDefined( wait_until_finished ) && wait_until_finished )
		awareness_object waitForAwarenessCompletion();
		
	return awareness_object;
}



setupEntMultiDamageOnly(	awareness_entities, 
							damage_event_to_call, 
							allow_aim_assist, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine, 
							wait_until_finished )
{
	return setupEntMulti( awareness_entities, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntMultiUseOnly(	awareness_entities, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine, 
						wait_until_finished )
{
	return setupEntMulti( awareness_entities, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}



setupEntMultiNoWait(	awareness_entities, 
						damage_event_to_call, 
						allow_aim_assist, 
						use_event_to_call, 
						hint_string, 
						use_time, 
						use_text, 
						single_use, 
						require_lookat, 
						filter_to_call, 
						awareness_material, 
						awareness_glow, 
						awareness_shine )
{
	return setupEntMulti( awareness_entities, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntMultiDamageOnlyNoWait(	awareness_entities, 
								damage_event_to_call, 
								allow_aim_assist, 
								filter_to_call, 
								awareness_material, 
								awareness_glow, 
								awareness_shine )
{
	return setupEntMulti( awareness_entities, damage_event_to_call, allow_aim_assist, undefined, undefined, undefined, undefined, undefined, undefined, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



setupEntMultiUseOnlyNoWait( awareness_entities, 
							use_event_to_call, 
							hint_string, 
							use_time, 
							use_text, 
							single_use, 
							require_lookat, 
							filter_to_call, 
							awareness_material, 
							awareness_glow, 
							awareness_shine )
{
	return setupEntMulti( awareness_entities, undefined, undefined, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
// Used for backwards compatibility only.
//////////////////////////////////////////////////////////////////////////////////
setup(	awareness_entity_name, 
		damage_event_to_call, 
		allow_aim_assist, 
		use_event_to_call, 
		hint_string, 
		use_time, 
		use_text, 
		single_use, 
		require_lookat, 
		filter_to_call, 
		awareness_material, 
		awareness_glow, 
		awareness_shine, 
		wait_until_finished )
{
	return setupMulti( awareness_entity_name, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
}

setupNoWait(	awareness_entity_name, 
				damage_event_to_call, 
				allow_aim_assist, 
				use_event_to_call, 
				hint_string, 
				use_time, 
				use_text, 
				single_use, 
				require_lookat, 
				filter_to_call, 
				awareness_material, 
				awareness_glow, 
				awareness_shine )
{
	return setupMulti( awareness_entity_name, damage_event_to_call, allow_aim_assist, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, false );
}



//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Post creation alteration functions
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
setDamageCallback( damage_event_to_call, allow_aim_assist )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setDamageCallback( damage_event_to_call, allow_aim_assist );
	}
	else
	{
		self awarenessInternalSetDamageCallback( damage_event_to_call, allow_aim_assist );
	}
}



clearDamageCallback()
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject clearDamageCallback();
	}
	else
	{
		self setDamageCallback( undefined );
	}
}



setUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat );
	}
	else
	{
		self awarenessInternalSetUseCallback( use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat );
	}
}



clearUseCallback()
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject clearUseCallback();
	}
	else
	{
		self setUseCallback( undefined );
	}
}



setFilterCallback( filter_to_call )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setFilterCallback( filter_to_call );
	}
	else
	{
		if( self.active )
		{
			if( isDefined( filter_to_call ) )
				self.filterToCall = filter_to_call;
			else
				self.filterToCall = undefined;
		}
	}
}



clearFilterCallback()
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject clearFilterCallback();
	}
	else
	{
		self setFilterCallback( undefined );
	}
}



setAwarenessEnabled( enabled )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessEnabled( enabled );
	}
	else
	{
		if( isDefined( enabled ) )
			self.enabled = enabled;
		else
			self.enabled = true;

		setDamageCallback( self.damageEventToCall, self.allowAimAssist );
		
		if( isDefined( self.useObject ) )
			setUseCallback( self.useEventToCall, self.useObject.hint_string, self.useObject.use_time, self.useObject.use_text, self.useObject.single_use, self.useObject.require_lookat );
		else	
			setUseCallback( self.useEventToCall );
	}
}



setAwarenessFXEnabled( fx_enabled )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessFXEnabled( fx_enabled );
	}
	else
	{
		if( isDefined( fx_enabled ) )
			self.enableFX = fx_enabled;
		else
			self.enableFX = true;
	}
}



setAwarenessMaterial( awareness_material )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessMaterial( awareness_material );
	}
	else
	{
		if( isDefined( awareness_material ) && awareness_material >= level.awarenessMaterialNone && awareness_material < level.awarenessMaterialMax )
			self.awarenessMaterial = awareness_material;
		else
			self.awarenessMaterial = level.awarenessMaterialNone;
	}
}



setAwarenessGlowEnabled( awareness_glow )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessGlowEnabled( awareness_glow );
	}
	else
	{
		if( isDefined( awareness_glow ) )
			self.awarenessGlow = awareness_glow;
		else
			self.awarenessGlow = false;
	}
}
	
	
	
setAwarenessShineEnabled( awareness_shine )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessShineEnabled( awareness_shine );
	}
	else
	{
		if( isDefined( awareness_shine ) )
			self.awarenessShine = awareness_shine;
		else
			self.awarenessShine = true;
	}
}
	
	
	
waitForAwarenessCompletion()
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject waitForAwarenessCompletion();
	}
	else
	{
		self.primaryEntity waittill( "awarenessfinished" );
	}
}



setAwarenessExternalCamera( externalFile, externalName )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessExternalCamera( externalFile, externalName );
	}
	else
	{
		self.externalCameraFile = externalFile;
		self.externalCameraName = externalName;
	}
}



enableAwarenessLookat( enable, priority, passback_time )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject enableAwarenessLookat( enable, priority, passback_time );
	}
	else
	{
		if( isDefined( enable ) )
			self.enableLookat = enable;
		else
			self.enableLookat = true;
			
		if( self.enableLookat )
		{
			if( isDefined( priority ) )
				self.priority = priority;
			else
				self.priority = 0;

			if( isDefined( passback_time ) )
				self.passback_time = passback_time;
			else
				self.passback_time = -1;
		}
	}
}

awarenessLookAtLock( player, awareness_object )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == player )
		{
			if( isDefined( level.awarenessCurrentLookatInfo ) && i < level.awarenessCurrentLookatInfo.size && isDefined( level.awarenessCurrentLookatInfo[i] ) )
			{
				if( level.awarenessCurrentLookatInfo[i].awareness_index >= 0 && level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index] == awareness_object )
				{
					level.awarenessCurrentLookatInfo[i].locked = true;
				}
			}
		}
	}
}

awarenessLookAtUnlock( player, awareness_object )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] == player )
		{
			if( isDefined( level.awarenessCurrentLookatInfo ) && i < level.awarenessCurrentLookatInfo.size && isDefined( level.awarenessCurrentLookatInfo[i] ) )
			{
				if( level.awarenessCurrentLookatInfo[i].awareness_index >= 0 && level.allAwarenessObjects[level.awarenessCurrentLookatInfo[i].awareness_index] == awareness_object )
				{
					level.awarenessCurrentLookatInfo[i].locked = false;
				}
			}
		}
	}
}



setAwarenessCameraTriggersArray( trigger_entities )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessCameraTriggersArray( trigger_entities );
	}
	else
	{
		if( isDefined( trigger_entities ) && trigger_entities.size > 0 )
		{
			self.cameraTriggers = trigger_entities;
			self.inCameraTrigger = [];
			self.inCameraTrigger[self.inCameraTrigger.size] = self.primaryEntity;
		}
		else if( isDefined( self.cameraTriggers ) && self.cameraTriggers.size > 0 )
			self.cameraTriggers[0] = self.primaryEntity;
			
		thread resetAwarenessCameraThread();
	}
}

setAwarenessCameraTriggersAdv( value, key )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessCameraTriggersAdv( value, key );
	}
	else
	{
		self setAwarenessCameraTriggersArray( getentarray( value, key ) );
	}
}
	
setAwarenessCameraTriggers( value )
{
	if( isDefined( self.awarenessObject ) )
	{
		self.awarenessObject setAwarenessCameraTriggers( value );
	}
	else
	{
		self setAwarenessCameraTriggersAdv( value, "targetname" );
	}
}
	
	
	

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Common Filter callbacks
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
awarenessFilter_NoMeleeDamage( awareness_object )
{
	retval = true;
	
	if( awareness_object.triggeredDamage )
	{
		if( IsSubStr( ToLower( awareness_object.damageType ), "melee" ) )
			retval = false;
	}
	
	return retval;
}



awarenessFilter_PlayerOnlyDamage( awareness_object )
{
	retval = true;
	
	if( awareness_object.triggeredDamage )
	{
		if( awareness_object.damageAttacker != level.player )
			retval = false;
	}
	
	return retval;
}
