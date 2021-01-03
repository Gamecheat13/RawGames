#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\ai\behavior_zombie_dog;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\util_shared;

                                                                                                             	   	
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                           

#namespace ArchetypeDirewolf;

function autoexec main()
{
	// INIT BLACKBOARD
	spawner::add_archetype_spawn_function( "direwolf", &ZombieDogBehavior::ArchetypeZombieDogBlackboardInit );
	spawner::add_archetype_spawn_function( "direwolf", &direwolfSpawnSetup );

	// REGISTER AI INTERFACE ATTRIBUTES
	ai::RegisterMatchedInterface( "direwolf", "sprint", false, array( true, false ) );
	ai::RegisterMatchedInterface( "direwolf", "howl_chance", 0.3 );	// 30% chance to howl when we spot our target
	ai::RegisterMatchedInterface( "direwolf", "can_initiateaivsaimelee", true, array( true, false ) );
	ai::RegisterMatchedInterface( "direwolf", "spacing_near_dist", 120 );
	ai::RegisterMatchedInterface( "direwolf", "spacing_far_dist", 480 );
	ai::RegisterMatchedInterface( "direwolf", "spacing_horz_dist", 144 );
	ai::RegisterMatchedInterface( "direwolf", "spacing_value", 0 );	// between -1 and 1
	
	clientfield::register(
		"actor",
		"direwolf_eye_glow_fx",
		1,
		1,
		"int" );
}

function private direwolfSpawnSetup()
{
	// init the entity
	self SetTeam( "team3" );
	self AllowPitchAngle( 1 );
	self setPitchOrient();
	self setAvoidanceMask( "avoid all" );
	self PushActors( true );
	self ai::set_behavior_attribute( "spacing_value", RandomFloatRange( -1.0, 1.0 ) );

	// enable eye glow
	self clientfield::set( "direwolf_eye_glow_fx", 1 );
}

// end #namespace ArchetypeDirewolf;
