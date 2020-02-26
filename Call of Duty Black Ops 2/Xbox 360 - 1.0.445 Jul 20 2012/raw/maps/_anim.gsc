#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include animscripts\utility;
#include animscripts\face;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;
#insert raw\maps\_utility.gsh;

////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
_anim.gsc - Utility functions for handling scripted animations in level scripts and other system animations
See utility docs for more information.
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////
/@
"Name: anim_reach( <ents>, <scene>, <animname_override> )"
"Summary: Makes an AI move to the position to start an animation."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> AI that will move."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: node anim_reach( guy, "jump" );"
"SPMP: singleplayer"
@/
anim_reach( ents, scene, animname_override )
{
	ents = build_ent_array(ents);	
	do_anim_reach( ents, scene, undefined, animname_override, false );
}

/@
"Name: anim_reach_aligned( <ents>, <scene>, <tag>, <animname_override> )"
"Summary: Makes an AI move to the position to start an animation."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> AI that will move."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: node anim_reach( guy, "jump" );"
"SPMP: singleplayer"
@/
anim_reach_aligned( ents, scene, tag, animname_override )
{
	ents = build_ent_array(ents);
	do_anim_reach( ents, scene, tag, animname_override, true );
}

/@
"Name: anim_generic_reach( <ents>, <scene> )"
"Summary: Makes an AI move to the position to start an animation. The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"Example: node anim_generic_reach( guy, "jump" );"
"SPMP: singleplayer"
@/

anim_generic_reach( ents, scene )
{
	anim_reach( ents, scene, "generic" );
}

/@
"Name: anim_generic_reach_aligned( <ents>, <scene>, <tag> )"
"Summary: Makes an AI move to the position to start an animation. The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc.  This entity will get the notify when the scene is complete."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"Example: car anim_generic_reach_aligned( guy, "drive_enter", "tag_driver" );"
"SPMP: singleplayer"
@/

anim_generic_reach_aligned( ents, scene, tag )
{
	anim_reach_aligned( ents, scene, tag, "generic" );
}

anim_reach_idle( guys, scene, idle )
{
	guys = build_ent_array(guys);

	ent = SpawnStruct();
	ent.count = guys.size;

	for (i = 0; i < guys.size; i++)
	{
		thread reach_idle(guys[i], scene, idle, ent);
	}

	while (ent.count)
	{
		ent waittill("reach_idle_goal");
	}
}

/@
"Name: anim_teleport( <ents>, <scene>, <tag>, <animname_override> )"
"Summary: Makes an AI move to the position to start an animation."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> entities that will move."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: node anim_teleport( boat, "float_by_the_dock" );"
"SPMP: singleplayer"
@/
anim_teleport( ents, scene, tag, animname_override )
{
	ents = build_ent_array(ents);

	pos = get_anim_position(tag);
	org = pos["origin"];
	angles = pos["angles"];

	for (i = 0; i < ents.size; i++)
	{
		ent = ents[i];

		startorg = GetStartOrigin(org, angles, ent get_anim(scene, animname_override));

		if (IsSentient(ent))
		{
			ent Teleport(startorg);
		}
		else
		{
			ent.origin = startorg;
		}
	}
}

/@
"Name: anim_single( <ents>, <scene>, <animname_override>)"
"Summary: Makes an array of entities play an animation.  The animation must be specified in the level.scr_anim array with the animname of the entities to animate (level.scr_anim["generic"][<scene_name>]). The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: Should be called level or any other entity.  This entity will get the notify when the scene is complete."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: level anim_single( guys, "jump" );"
"SPMP: singleplayer"
@/
anim_single( ents, scene, animname_override )
{
	ents = build_ent_array(ents);	
	do_anim_single( ents, scene, undefined, animname_override, false );
}

/@
"Name: anim_single_aligned( <ents>, <scene>, <tag>, <animname_override>, <n_lerp_time> )"
"Summary: Makes an array of entities play an animation.  The animation must be specified in the level.scr_anim array with the animname of the entities to animate (level.scr_anim["generic"][<scene_name>]). The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: Should be called level or any other entity.  This entity will get the notify when the scene is complete."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: node anim_single_aligned( guys, "jump" );"
"SPMP: singleplayer"
@/
anim_single_aligned( ents, scene, tag, animname_override, n_lerp_time )
{
	ents = build_ent_array(ents);	
	do_anim_single( ents, scene, tag, animname_override, true, n_lerp_time );
}

/@
"Name: anim_first_frame( <ents>, <scene>, [tag], [animname_override] )"
"Summary: Puts the animating models or AI or vehicles into the first frame of the animated scene. The animation is played relative to the entity that calls the scene"
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: [tag] The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: [animname_override] Animname to use instead of ent.animname"
"Example: node anim_first_frame( guys, "rappel_sequence" );"
"SPMP: singleplayer"
@/
anim_first_frame( ents, scene, tag, animname_override )
{
	pos_array = get_anim_position( tag );
	org = pos_array[ "origin" ];
	angles = pos_array[ "angles" ];

	ents = build_ent_array(ents);
	level array_ent_thread( ents, ::anim_first_frame_on_guy, scene, org, angles, animname_override );
}

/@
"Name: anim_generic( <ents>, <scene> )"
"Summary: Makes an array of entities play a generic anim.  The animation must be specified in the level.scr_anim array with "generic" as the animname (level.scr_anim["generic"][<scene_name>]). The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: Should be called level or any other entity.  This entity will get the notify when the scene is complete."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"Example: level anim_generic( guys, "jump" );"
"SPMP: singleplayer"
@/
anim_generic( ents, scene )
{
	anim_single( ents, scene, "generic" );
}

/@
"Name: anim_generic_aligned( <ents>, <scene>, <tag>, <n_lerp_time> )"
"Summary: Makes an AI play a generic anim.  The animation must be specified in the level.scr_anim array with "generic" as the animname (level.scr_anim["generic"][<scene_name>]). The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc.  This entity will get the notify when the scene is complete."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"Example: car anim_generic_aligned( guy, "drive", "tag_driver" );"
"SPMP: singleplayer"
@/

anim_generic_aligned( ents, scene, tag, n_lerp_time )
{
	anim_single_aligned( ents, scene, tag, "generic", n_lerp_time );
}

/@
"Name: anim_loop( <ents>, <scene>, <ender>, <animname_override> )"
"Summary: Plays a looping anim. The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <ender> The string that will end the looping animation when notified to the calling entity.  This may also be notified to entity that is animating."
"Example: node anim_generic_loop( guy, "jumping_jacks" );"
"SPMP: singleplayer"
@/
anim_loop( ents, scene, ender, animname_override )
{
	ents = build_ent_array(ents);

	/#
		if (!debug_check(ents, scene, animname_override))
		{
			return;
		}
	#/

	guyPackets = [];
	for( i=0; i < ents.size; i++ )
	{
		packet = [];
		packet[ "guy" ] = ents[ i ];
		packet[ "entity" ] = packet[ "guy" ];
		guyPackets[ guyPackets.size ] = packet;
	}

	anim_loop_packet( guyPackets, scene, ender, animname_override );
}

/@
"Name: anim_generic_loop( <ents>, <scene>, <ender> )"
"Summary: Plays a generic looping anim. The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <ender> The string that will end the looping animation when notified to the calling entity.  This may also be notified to entity that is animating."
"Example: node anim_generic_loop( guy, "jumping_jacks" );"
"SPMP: singleplayer"
@/
anim_generic_loop( ents, scene, ender )
{
	anim_loop( ents, scene, ender, "generic" );
}

/@
"Name: anim_loop_aligned( <ents>, <scene>, <tag>, <ender>, <animname_override>, <n_lerp_time> )"
"Summary: Plays a looping anim. The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <ender> The string that will end the looping animation when notified to the calling entity.  This may also be notified to entity that is animating."
"Example: node anim_generic_loop( guy, "jumping_jacks" );"
"SPMP: singleplayer"
@/
anim_loop_aligned( ents, scene, tag, ender, animname_override, n_lerp_time )
{
	ents = build_ent_array(ents);

	/#
		if (!debug_check(ents, scene, animname_override))
		{
			return;
		}
	#/

	guyPackets = [];
	for( i=0; i < ents.size; i++ )
	{
		packet = [];
		packet[ "guy" ] = ents[ i ];
		packet[ "entity" ] = self;
		packet[ "tag" ] = tag;
		guyPackets[ guyPackets.size ] = packet;
	}

	assert( IsDefined( self.angles ), "Alignment node does not have angles specified." );

	anim_loop_packet( guyPackets, scene, ender, animname_override, n_lerp_time );
}

/@
"Name: anim_generic_loop_aligned( <ents>, <scene>, <tag>, <ender>, <n_lerp_time> )"
"Summary: Plays a generic looping anim. The calling ent notifies itself the name of the animation scene when it completes."
"Module: Animation"
"CallOn: The root entity that is the point of relativity for the scene, be it node, ai, vehicle, etc."
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <ender> The string that will end the looping animation when notified to the calling entity.  This may also be notified to entity that is animating."
"Example: node anim_generic_loop( guy, "jumping_jacks" );"
"SPMP: singleplayer"
@/
anim_generic_loop_aligned( ents, scene, tag, ender, n_lerp_time )
{
	anim_loop_aligned( ents, scene, tag, ender, "generic", n_lerp_time );
}

/@
"Name: anim_custom_animmode( <ents>, <animmode>, <scene>, <tag>, <animname_override> )"
"Summary: Makes an array of AI play an animation using a specific animmode."
"Module: Animation"
"CallOn: The AI to be animated"
"MandatoryArg: <ents> Array of entities that will animate."
"MandatoryArg: <animmode> The animmode"
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"OptionalArg: <animname_override> Animname to use instead of ent.animname"
"Example: node anim_custom_animmode( guys, "gravity", "rappel_sequence" );"
"SPMP: singleplayer"
@/ 

anim_custom_animmode( ents, custom_animmode, scene, tag, animname_override )
{
	ents = build_ent_array(ents);

	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	for ( i = 0; i < ents.size; i++ )
	{
		thread anim_custom_animmode_on_guy( ents[ i ], custom_animmode, scene, org, angles, animname_override );
	}
	
	assert( IsDefined( ents[ 0 ] ), "anim_custom_animmode called without a guy in the array" );
	ents[ 0 ] wait_until_anim_finishes( scene );
	
	self notify( scene );
}

/@
"Name: anim_generic_custom_animmode( <guy>, <animmode>, <scene>, <tag> )"
"Summary: Makes an AI play an animation using a specific animmode."
"Module: Animation"
"CallOn: The entity to be animated"
"MandatoryArg: <guy> The guy that animates"
"MandatoryArg: <animmode> The animmode"
"MandatoryArg: <scene> The animation scene name."
"OptionalArg: <tag> The tag to animate relative to (must exist in the entity this function is called on)."
"Example: anim_generic_custom_animmode( guy, custom_animmode, scene, tag );"
"SPMP: singleplayer"
@/

anim_generic_custom_animmode( ents, custom_animmode, scene, tag )
{
	anim_custom_animmode( ents, custom_animmode, scene, tag, "generic" );
}

/@
"Name: anim_set_time( <guys> , <scene> , <time> )"
"Summary: Sets the current time of an anim, but should be done at least 0.05 seconds after the anim is calle"
"Module: Animation"
"CallOn: Array of guys animating"
"MandatoryArg: <guys> Guys animating"
"MandatoryArg: <amime> Scene name"
"MandatoryArg: <time> Time to set to"
"Example: anim_set_time( guy, "fire_3", .5 );"
"SPMP: singleplayer"
@/

anim_set_time( guys, scene, time )
{
	array_thread( guys, ::anim_self_set_time, scene, time );
}

/@
"Name: addNotetrack_dialogue( <animname> , <notetrack> , <scene> , <soundalias>, <pg_soundalias> )"
"Summary: Makes a dialogue sound play on a certain notetrack. If you put multiple dialogue notetracks in an anim, it will play them in the order you do addNotetrack."
"Module: Animation"
"MandatoryArg: <animname> The animname of the character, or generic. "
"MandatoryArg: <notetrack> The notetrack in the anim, usual dialog. "
"MandatoryArg: <scene> The scene the sound plays in. "
"MandatoryArg: <soundalias> The soundalias. "
"Example: addNotetrack_dialogue( "price", "dialog", "wounded_begins", "sniperescape_mcm_choppergetback" );"
"SPMP: singleplayer"
@/
addNotetrack_dialogue( animname, notetrack, scene, soundalias, pg_soundalias )
{
	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		num = level.scr_notetrack[ animname ].size;
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "dialog" ]			= soundalias;
	level.scr_notetrack[ animname ][ num ][ "pg_dialog" ]		= pg_soundalias;
	level.scr_notetrack[ animname ][ num ][ "scene" ]			= scene;
}

removeNotetrack_dialogue( animname, notetrack, scene, soundalias )
{
	assert( IsDefined( level.scr_notetrack[ animname ] ), "Animname not found in scr_notetrack." );

	tmp_array = [];

	for( i=0; i < level.scr_notetrack[ animname ].size; i++ )
	{
		if( level.scr_notetrack[ animname ][ i ][ "notetrack" ] == notetrack )
		{
			dialog = level.scr_notetrack[ animname ][ i ][ "dialog" ];
			if( !IsDefined( dialog ) )
			{
				dialog = level.scr_notetrack[ animname ][ i ][ "dialogue" ];
			}

			if( IsDefined( dialog ) && dialog == soundalias )
			{
				if( IsDefined( scene ) && IsDefined( level.scr_notetrack[ animname ][ i ][ "scene" ] ) )
				{
					if( level.scr_notetrack[ animname ][ i ][ "scene" ] == scene )
					{
						continue;
					}
				}
				else
				{
					continue;
				}
			}
		}

		num = tmp_array.size;
		tmp_array[ num ] = level.scr_notetrack[ animname ][ i ];
	}

	assert( tmp_array.size < level.scr_notetrack[ animname ].size, "Notetrack not found." );

	level.scr_notetrack[ animname ] = tmp_array;
}

addNotetrack_sound( animname, notetrack = "start", scene = "any", soundalias )
{
	array = [];
	array[ "notetrack" ]		 = notetrack;
	array[ "sound" ]			 = soundalias;
	array[ "scene" ]			 = scene;

	if ( !IsDefined( level.scr_notetrack ) )
	{
		level.scr_notetrack = [];
		level.scr_notetrack[ animname ] = [];
	}
	else
	{
		if ( !IsDefined( level.scr_notetrack[ animname ] ) )
		{
			level.scr_notetrack[ animname ] = [];
		}
	}

	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = array;
}

addOnStart_animSound( animname, scene, soundalias )
{
	// only sounds generated by animSound should call this
	if( !IsDefined( level.scr_animSound[ animname ] ) )
	{
		level.scr_animSound[ animname ] = [];
	}

	level.scr_animSound[ animname ][ scene ] = soundalias;
}

addNotetrack_animSound( animname, scene, notetrack, soundalias )
{
	// only sounds generated by animSound should call this
	if( !IsDefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[ animname ] = [];
	}

	array = [];	
	array[ "notetrack" ] = notetrack;
	array[ "sound" ] = soundalias;
	array[ "created_by_animSound" ] = true;
	array[ "scene" ] = scene;

	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = array;
}

addNotetrack_attach( animname, notetrack = "start", model, tag, scene = "any" )
{
	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		num = level.scr_notetrack[ animname ].size;
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "attach model" ]	= model;
	level.scr_notetrack[ animname ][ num ][ "selftag" ]			= tag;
	level.scr_notetrack[ animname ][ num ][ "scene" ]			= scene;
}

addNotetrack_detach( animname, notetrack = "start", model, tag, scene = "any" )
{
	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		num = level.scr_notetrack[ animname ].size;
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "detach model" ]	= model;
	level.scr_notetrack[ animname ][ num ][ "selftag" ]			= tag;
	level.scr_notetrack[ animname ][ num ][ "scene" ]			= scene;
}

/@
"Name: addNotetrack_fov( <animname>, <notetrack>, <scene> )"
"Summary: Switches to Fov based on notetrack"
"Module: Animation"
"MandatoryArg: <animname> Animname of the scene "
"MandatoryArg: <notetrack> Duh"
"OptionalArg: <scene> The scene. If left blank, will occur on all scenes."
"Example: 	addNotetrack_fov( "animation", "fov_reset", "scene" ); "
"SPMP: singleplayer"
@/
addNotetrack_fov( animname, notetrack = "start", scene = "any" )
{
	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		num = level.scr_notetrack[ animname ].size;
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]	= notetrack;
	level.scr_notetrack[ animname ][ num ][ "change fov" ]  = notetrack;
	level.scr_notetrack[ animname ][ num ][ "scene" ]		= scene;
}

addNotetrack_fov_new( animname, notetrack = "start", n_fov, n_time, scene = "any" )
{
	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		num = level.scr_notetrack[ animname ].size;
	}
	
	if ( n_fov == -1 )
	{
		n_fov = GetDvarFloat( "cg_fov_default" );
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]	= notetrack;
	level.scr_notetrack[ animname ][ num ][ "fov" ]			= n_fov;
	level.scr_notetrack[ animname ][ num ][ "time" ]		= n_time;
	level.scr_notetrack[ animname ][ num ][ "scene" ]		= scene;
}

/@
"Name: addNotetrack_level_notify( <animname>, <notetrack>, <str_notify>, <scene> )"
"Summary: sends a level notify based on notetrack"
"Module: Animation"
"MandatoryArg: <animname> Animname of the scene "
"MandatoryArg: <notetrack> Duh"
"MandatoryArg: <str_notify> the level notify to send when the notetrack is hit"
"OptionalArg: <scene> The scene. If left blank, will occur on all scenes."
"Example: 	addNotetrack_level_notify( "animation", "fov_reset", "fxanim_start", "scene" ); "
"SPMP: singleplayer"
@/
addNotetrack_level_notify( animname, notetrack = "start", str_notify, scene = "any" )
{
	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		num = level.scr_notetrack[ animname ].size;
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "level notify" ]	= str_notify;
	level.scr_notetrack[ animname ][ num ][ "scene" ]			= scene;
}


/@
"Name: addNotetrack_customFunction( <animname>, <notetrack> , <function> , <scene> )"
"Summary: Makes the function run when this notetrack is hit. The SELF of the function is the scene base, the PARM of the function is the guy that hit the notetrack."
"Module: Animation"
"MandatoryArg: <animname> Animname of the scene "
"MandatoryArg: <notetrack> Duh"
"MandatoryArg: <function> Duh part 2 "
"OptionalArg: <scene> The scene. If left blank, will occur on all scenes."
"Example: 	addNotetrack_customFunction( \"zpu_gun\", \"fire_1\", ::zpu_shoot1 ); "
"SPMP: singleplayer"
@/
addNotetrack_customFunction( animname, str_notetrack = "start", function, scene = "any", passNoteBack = false )
{
	if (!IsDefined(level.scr_notetrack))
	{
		level.scr_notetrack[animname] = [];
	}

	num = 0;
	if( IsDefined( level.scr_notetrack[ animname ] ) )
	{
		foreach ( notetrack in level.scr_notetrack[ animname ] )
		{
			if ( ( notetrack[ "scene" ] == scene ) && ( notetrack[ "notetrack" ] == str_notetrack )
			    && ( IsDefined( notetrack[ "function" ] ) && ( notetrack[ "function" ] == function ) ) )
			{
				return;	// function already added for notetrack and scene
			}
		}
		
		num = level.scr_notetrack[ animname ].size;
	}

	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= str_notetrack;
	level.scr_notetrack[ animname ][ num ][ "function" ]		= function;
	level.scr_notetrack[ animname ][ num ][ "scene" ]			= scene;
	level.scr_notetrack[ animname ][ num ][ "noteback" ]		= passNoteBack;
}

// MikeD: checks if a custom function exists for a given notetrack, function, and scene
// 	- do we want to add this to addNotetrack_customFunction(), as a failsafe?
notetrack_customfunction_exists( animname, notetrack, function, scene )
{
	if( IsDefined( level.scr_notetrack ) && IsDefined( level.scr_notetrack[animname] ) )
	{
		keys = GetArrayKeys( level.scr_notetrack[animname] );
		for( i = 0; i < keys.size; i++ )
		{
			if( IsDefined( level.scr_notetrack[animname][keys[i]] ) 
				&& IsDefined( level.scr_notetrack[animname][keys[i]]["notetrack"] )
				&& IsDefined( level.scr_notetrack[animname][keys[i]]["scene"] )
				&& IsDefined( level.scr_notetrack[animname][keys[i]]["function"] )
				&& level.scr_notetrack[animname][keys[i]]["notetrack"] == notetrack
				&& level.scr_notetrack[animname][keys[i]]["scene"] == scene
				&& level.scr_notetrack[animname][keys[i]]["function"] == function )
			{
				return true;
			}
		}
	}

	return false;
}

addNotetrack_flag( animname, notetrack = "start", flag, scene = "any" )
{
	if( !IsDefined(level.scr_notetrack) || !IsDefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[ animname ] = [];
	}

	add_note = [];
	add_note[ "notetrack" ] = notetrack;
	add_note[ "flag" ] = flag;
	add_note[ "scene" ] = scene;

	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = add_note;

	if( !IsDefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
}

addNotetrack_FXOnTag( animname, scene = "any", notetrack = "start", effect, tag, on_threader )
{
	if( !IsDefined(level.scr_notetrack) || !IsDefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[animname] = [];
	}

	add_note = [];	
	add_note["notetrack"] = notetrack;
	add_note["scene"] = scene;
	add_note["effect"] = effect;

	if( IsDefined( on_threader ) && on_threader )
	{
		add_note["tag"] = tag;
	}
	else
	{
		// Default behavior, is play the FX on the ent playing the anim, not the ent that is threading the anim call
		add_note["selftag"] = tag;		
	}

	level.scr_notetrack[animname][level.scr_notetrack[animname].size] = add_note;
}

addNotetrack_exploder( animname, notetrack = "start", exploder, scene )
{
	if( !IsDefined(level.scr_notetrack) || !IsDefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[ animname ] = [];
	}

	add_note = [];
	add_note[ "notetrack" ] = notetrack;
	add_note[ "exploder" ] = exploder;
	if( !IsDefined( scene ) )
	{
		scene = "any";
	}
	add_note[ "scene" ] = scene;

	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = add_note;
}

addNotetrack_stop_exploder( animname, notetrack = "start", exploder, scene )
{
	if( !IsDefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[ animname ] = [];
	}

	add_note = [];
	add_note[ "notetrack" ] = notetrack;
	add_note[ "stop_exploder" ] = exploder;
	if( !IsDefined( scene ) )
	{
		scene = "any";
	}
	add_note[ "scene" ] = scene;

	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = add_note;
}

set_animname( ents, animname )
{
	for( i = 0; i < ents.size; i++ )
	{
		ents[i].animname = animname;
	}
}

anim_set_blend_in_time(time)
{
	self._anim_blend_in_time = time;
}

anim_set_blend_out_time(time)
{
	self._anim_blend_out_time = time;
}

get_anim( scene, animname )
{
	if ( !IsDefined( animname ) )
	{
		animname = self.animname;
	}

	if ( IsDefined( level.scr_anim[animname] ) )
	{
		if ( IsArray( level.scr_anim[animname][scene] ) )
		{
			return random( level.scr_anim[animname][scene] );
		}
		
		return level.scr_anim[animname][scene];
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
//
//
//
//
//
/*
//	Internal System Functions - Should not be called from level or system scripts
*/
//
//
//
//
//
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

init()
{
	if( !isDefined( level.scr_special_notetrack ) )
	{
		level.scr_special_notetrack = [];
	}
	if( !isDefined( level.scr_notetrack ) )
	{
		level.scr_notetrack = [];
	}
	if( !isDefined( level.scr_face ) )
	{
		level.scr_face = [];
	}
	if( !isDefined( level.scr_look ) )
	{
		level.scr_look = [];
	}
	if( !isDefined( level.scr_animSound ) )
	{
		level.scr_animSound = [];
	}
	if( !isDefined( level.scr_sound ) )
	{
		level.scr_sound = [];
	}
	if( !isDefined( level.scr_radio ) )
	{
		level.scr_radio = [];
	}
	if( !isDefined( level.scr_text ) )
	{
		level.scr_text = [];
	}
	if( !isDefined( level.scr_anim ) )
	{
		level.scr_anim[ 0 ][ 0 ] = 0;
	}
	if( !isDefined( level.scr_radio ) )
	{
		level.scr_radio = [];
	}
}

build_ent_array(ents)
{
	ent_array = [];
	if (IsArray(ents))
	{
		ent_array = ents;
	}
	else
	{
		ent_array[0] = ents;
	}

	return ent_array;
}

wait_until_anim_finishes( scene )
{
	self endon( "finished_custom_animmode" + scene );
	self waittill( "death" );
}

debug_check(ents, scene, animname_override)
{
	/#

	if (!IsDefined(scene))
	{
		assertmsg("maps/_anim: undefined scene for animation.");
		return false;
	}

	for (i = 0; i < ents.size; i++)
	{
		if(!ents[i] assert_existance_of_anim(scene, animname_override))
		{
			return false;
		}
	}

	return true;

	#/
}

is_a_sound_only_scene(scene, animname)
{
	if( !IsDefined( animname ) )
	{
		animname = self.animname;
	}
	
	if( !IsDefined( animname ))
	{
		assertmsg("Animating character of type " + self.classname + " has no animname." );
		return false;
	}
	
	has_anim = false;
	has_sound = true;
	
	if(IsDefined( level.scr_anim[ animname ] ))
	{
		if( IsDefined( level.scr_anim[ animname ][ scene ] ) )
		{
			has_anim = true;
		}
	}
	
	if(IsDefined( level.scr_sound[ animname ] ))
	{	
		if( IsDefined( level.scr_sound[ animname ][ scene ] ) )
		{
			has_sound = true;
		}
	}
	
	if(has_anim)
	{
		return(false);
	}
	
	return(has_sound);
}

assert_existance_of_anim( scene, animname )
{
	/#

	if ( !IsDefined( animname ) )
	{
		animname = self.animname;
	}

	if (!IsDefined( animname ))
	{
		assertmsg("Animating character of type " + self.classname + " has no animname." );
		return false;
	}

	has_anim = false;
	if ( IsDefined( level.scr_anim[ animname ] ) )
	{
		has_anim = true;
		if ( IsDefined( level.scr_anim[ animname ][ scene ] ) )
		{
			return true;
		}
	}
	
	has_sound = false;
	if ( IsDefined( level.scr_sound[ animname ] ) )
	{
		has_sound = true;
		if( is_mature() || !pg_sound_exists( animname, scene ) )
		{
			if( IsDefined( level.scr_sound[ animname ][ scene ] ) )
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}

	if ( has_anim || has_sound )
	{	
		if ( has_anim )
		{
			array = GetArrayKeys( level.scr_anim[ animname ] );
			PrintLn( "Legal scene scenes for " + animname + ":" );
			for ( i = 0; i < array.size; i++ )
			{
				PrintLn( array[ i ] );
			}
		}

		if ( has_sound )
		{
			array = GetArrayKeys( level.scr_sound[ animname ] );
			PrintLn( "Legal scr_sound scenes for " + animname + ":" );
			for ( i = 0; i < array.size; i++ )
			{
				PrintLn( array[ i ] );
			}
		}

		assertmsg( "Guy with animname \"" + animname + "\" is trying to do scene \"" + scene + "\" there is no level.scr_anim or level.scr_sound for that animname" );
		return false;	
	}
	
	keys = GetArrayKeys( level.scr_anim );
	keys = ArrayCombine( keys, GetArrayKeys( level.scr_sound ), true, false );
	for ( i = 0; i < keys.size; i++ )
	{
		PrintLn( keys[ i ] );
	}

	assertmsg( "Animname " + animname + " is not setup to do animations. See above for list of legal animnames." );
	return false;
	#/	
}

anim_first_frame_on_guy( guy, scene, org, angles, animname_override )
{
	anim_ent = guy get_anim_ent();

	if ( IsDefined( animname_override ) )
	{
		animname = animname_override;
	}
	else
	{
		animname = anim_ent.animname;
	}

	/#
	anim_ent assert_existance_of_anim( scene, animname );
	self thread anim_info_render_thread( guy, scene, org, angles, animname, scene, false, true );
	#/

	animation = anim_ent get_anim(scene, animname);
	anim_ent AnimScripted("anim_first_frame", org, angles, animation, "normal", anim_ent.root_anim, 0, 0);
}

anim_custom_animmode_on_guy( guy, custom_animmode, scene, org, angles, animname_override )
{
	animname = undefined;
	if ( IsDefined( animname_override ) )
	{
		animname = animname_override;
	}
	else
	{
		animname = guy.animname;
	}

	/#	
	guy assert_existance_of_anim( scene, animname );
	#/

	assert( IsAI( guy ), "Tried to do custom_animmode on a non ai" );

	guy set_start_pos( scene, org, angles, animname_override );
	guy._animmode = custom_animmode;
	guy._custom_anim = scene;
	guy._tag_entity = self;
	guy._scene = scene;
	guy._animname = animname;
	guy AnimCustom( animscripts\animmode::main );
}

anim_loop_packet( guyPackets, scene, ender, animname_override, n_lerp_time )
{
	if ( !IsDefined( ender ) )
	{
		ender = "stop_loop";
	}
	
	baseGuy = undefined;

	// disable BCS if we're doing a scripted sequence.
	for( i = 0; i < guyPackets.size; i++ )
	{
		guy = guyPackets[ i ][ "guy" ];
		if( !IsDefined( guy ) )
		{
			continue;
		}

		guy = guy get_anim_ent();

		if (i == 0)
		{
			baseGuy = guy;

			/#
				self thread looping_anim_ender( baseGuy, ender );
			#/
		}
			
		if( !IsDefined( guy._animActive ) )
		{
			// script models cant get their animactive set by init
			guy._animActive = 0;
		}

		guy _stop_anim_threads();

		guy.anim_loop_ender = ender;

		guy endon( ender );
		guy endon( "death" );
		guy._animActive++;
		
	}

	self endon( ender );

/#
	if( !IsDefined( baseGuy.loops ) )
	{
		baseGuy.loops = 0;
	}

	thread printloops( baseGuy, scene );
#/
	
	anim_string = "looping anim";

	base_animname = undefined;
	if ( IsDefined( animname_override ) )
	{
		base_animname = animname_override;
	}
	else
	{
		base_animname = baseGuy.animname;
	}
	
	// JAS Aug 5, 2010 - If this isn't an array, script will error out with an infinite loop in some of the functions below
	assert( isarray(level.scr_anim[base_animname][scene]), "Looping anims must have an array entry in level.scr_anim! i.e. [animname][scene][0]" );
	
	idleanim = 0;
	lastIdleanim = 0;
	while( 1 )
	{
		idleanim = anim_weight( base_animname, scene );
		while(( idleanim == lastIdleanim ) &&( idleanim != 0 ) )
		{
			idleanim = anim_weight( base_animname, scene );
		}

		lastIdleanim = idleanim;
			
		scriptedAnimationIndex = -1;
		scriptedAnimationTime = 999999;
		
		scriptedSoundIndex = -1;
		for( i = 0; i < guyPackets.size; i++ )
		{
			guy = guyPackets[ i ][ "guy" ];
			
			if (!IsDefined(guy))
			{
				// we are ending on death, but still getting asserts when deleting guys
				// in the middle of a looping animation, so this fixes that
				//wait(0.05);
				/#
				IPrintLnBold( "I am dead YEAH!!!!!" );
				#/
				return;
			}

			guy = guy get_anim_ent();

			pos = get_anim_position( guyPackets[ i ][ "tag" ] );
			org = pos[ "origin" ];
			angles = pos[ "angles" ];
			entity = guyPackets[ i ][ "entity" ];
			
			if (!IsDefined(org))
			{
				org = guy.origin;
			}
			if (!IsDefined(angles))
			{
				angles = guy.angles;
			}
			
			doFacialanim = false;
			doDialogue = false;
			doAnimation = false;
			doText = false;

			facialAnim = undefined;
			dialogue = undefined;
			animname = undefined;

			if ( IsDefined( animname_override ) )
			{
				animname = animname_override;
			}
			else
			{
				animname = guy.animname;
			}
			
			if(( IsDefined( level.scr_face[ animname ] ) ) &&
				( IsDefined( level.scr_face[ animname ][ scene ] ) ) &&
				( IsDefined( level.scr_face[ animname ][ scene ][ idleanim ] ) ) )
			{
				doFacialanim = true;
				facialAnim = level.scr_face[ animname ][ scene ][ idleanim ];
			}
	
			if( is_mature() || !pg_loopanim_sound_exists( animname, scene, idleanim ) )
			{
				if( loopanim_sound_exists( animname, scene, idleanim ) )
				{
					doDialogue = true;
					dialogue = level.scr_sound[ animname ][ scene ][ idleanim ];
				}
			}
			else if( pg_loopanim_sound_exists( animname, scene, idleanim ) )
			{
				doDialogue = true;
				dialogue = level.scr_sound[ animname ][ scene + "_pg" ][ idleanim ];
			}
	
			if( IsDefined( level.scr_animSound[ animname ] ) && 
				 IsDefined( level.scr_animSound[ animname ][ idleanim + scene ] ) )
			{
				guy PlaySound( level.scr_animSound[ animname ][ idleanim + scene ] );
			}
			/*
			/#
			if( getdebugdvar( "animsound" ) == "on" )
			{
				guy thread animsound_start_tracker( scene );
			}
			#/
			*/

			/#
			if( getdebugdvar( "animsound" ) == "on" )
			{
				guy thread animsound_start_tracker_loop( scene, idleanim, animname );
			}
//			guy thread animsound_start_tracker( scene );
			#/

			if(( IsDefined( level.scr_anim[ animname ] ) ) &&
				( IsDefined( level.scr_anim[ animname ][ scene ] ) ) )
			{
				doAnimation = true;
			}

			/#
			if(( IsDefined( level.scr_text[ animname ] ) ) &&
				( IsDefined( level.scr_text[ animname ][ scene ] ) ) )
			{
				doText = true;
			}
			#/
				
			
			if( doAnimation )
			{
				/#
				self thread anim_origin_render( org, angles );
				self thread anim_info_render_thread( guy, scene, org, angles, animname, ender, false );
				#/

				if ( guy.classname == "script_vehicle" && !IS_TRUE( guy.supportsAnimScripted ) )
				{
					// vehicles use generic anim commands
					guy.origin = org;
					guy.angles = angles;
					guy SetFlaggedAnimKnobRestart( anim_string, level.scr_anim[ animname ][ scene ][ idleanim ], 1, 0.2, 1 );
				}
				else
				{
					// ai and models use animscripted
					guy last_anim_time_check();
					guy AnimScripted( anim_string, org, angles, level.scr_anim[ animname ][ scene ][ idleanim ], "normal", undefined, undefined, n_lerp_time );
				}

				guy notify("_anim_playing");
				
				animtime = GetAnimLength( level.scr_anim[ animname ][ scene ][ idleanim ] );
				if ( animtime < scriptedAnimationTime )
				{
					scriptedAnimationTime = animtime;
					scriptedAnimationIndex = i;
				}
	
				thread notetrack_wait( guy, anim_string, scene, animname );

				thread animscriptDoNoteTracksThread( guy, anim_string/*, scene*/ );
			}

			if(( doFacialanim ) ||( doDialogue ) )
			{
//				println( "dofacialanim: ", dofacialanim, " and dodialogue: ", dodialogue );
//				println( "^3 Animname: ", guy[ i ].animname, " doing animation ", scene, " facial: ", facialanim, " dialogue: ", dialogue );
				
				if( doAnimation )
				{
					guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
				}
				else
				{
					guy SaySpecificDialogue( facialAnim, dialogue, 1.0, anim_string );
				}
					
				scriptedSoundIndex = i;
			}
			
			/#
			if( doText && !doDialogue )
			{
				IPrintLnBold( level.scr_text[ animname ][ scene ] );
			}
	
//			add_animation( animname , scene );
			#/
		}
	
		if( scriptedAnimationIndex != -1 )
		{
			guyPackets[ scriptedAnimationIndex ][ "guy" ] get_anim_ent() waittillmatch( anim_string, "end" );
		}
		else if( scriptedSoundIndex != -1 )
		{
			guyPackets[ scriptedSoundIndex ][ "guy" ] get_anim_ent() waittill( anim_string );
		}
	}
}

anim_single_failsafeOnGuy( owner, scene )
{
	/#
	if( GetDebugDvar( "debug_animfailsafe" ) != "on" )
	{
		return;
	}

	owner endon( scene );
	owner endon( "death" );
	self endon( "death" );
	name = self.classname;
	num = self GetEntNum();
	wait( 60 );
	PrintLn( "Guy had classname " + name + " and entnum " + num );
	waittillframeend;
	assert( 0, "Animation \"" + scene + "\" did not finish after 60 seconds. See note above" );
	#/
	
}

anim_single_failsafe( guy, scene )
{
	for( i=0;i<guy.size;i++ )
	{
		guy[ i ] thread anim_single_failsafeOnGuy( self, scene );
	}
}

do_anim_single( guys, scene, tag, animname_override, aligned, n_lerp_time )
{
/#
	thread anim_single_failsafe( guys, scene );
#/

	pos = get_anim_position( tag );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	tracker = SpawnStruct();

	tracker.scriptedAnimationTime = 999999;
	tracker.scriptedAnimationIndex = -1;

	tracker.scriptedSoundIndex = -1;
	tracker.scriptedFaceIndex = -1;

	/#
	if( aligned )
	{
		self thread anim_origin_render( org, angles );
	}
	#/

	for( i = 0; i < guys.size; i++ )
	{
		if (!IsDefined(guys[i]))
		{
			AssertMsg("_anim::do_anim_single - trying to play animation on undefined ent.");
			return;
		}

		thread anim_single_thread(guys, i, scene, org, angles, animname_override, aligned, n_lerp_time, tracker);
	}

	if( tracker.scriptedAnimationIndex != -1 )
	{
//		guy[ scriptedAnimationIndex ] endon( "death" );	
		ent = SpawnStruct();
		ent thread anim_deathNotify( guys[ tracker.scriptedAnimationIndex ], scene );
		ent thread anim_animationEndNotify( guys[ tracker.scriptedAnimationIndex ], scene );
		ent waittill( scene );
//		guy[ scriptedAnimationIndex ] waittillmatch( "single anim", "end" );
	}
	else if( tracker.scriptedFaceIndex != -1 )
	{
		ent = SpawnStruct();
		ent thread anim_deathNotify( guys[ tracker.scriptedFaceIndex ], scene );
		ent thread anim_facialEndNotify( guys[tracker. scriptedFaceIndex ], scene );
		ent waittill( scene );
	}
	else if( tracker.scriptedSoundIndex != -1 )
	{
//		guy[ scriptedSoundIndex ] endon( "death" );
		ent = SpawnStruct();
		ent thread anim_deathNotify( guys[ tracker.scriptedSoundIndex ], scene );
		ent thread anim_dialogueEndNotify( guys[ tracker.scriptedSoundIndex ], scene );
		ent waittill( scene );
//		guy[ scriptedSoundIndex ] waittill( "single dialogue" );
	}

	for( i = 0; i < guys.size; i++ )
	{
		if( !IsDefined( guys[ i ] ) )
		{
			continue;
		}

		guys[ i ]._animActive--;
		guys[ i ]._lastAnimTime = GetTime();
		assert( guys[ i ]._animactive >= 0 );
	}

	self notify( scene );
}

_stop_anim_threads()
{
	if ( IsDefined( self.anim_loop_ender ) )
	{
		self notify( self.anim_loop_ender );
	}
	
	self notify( "stop_single" );
	self notify( "stop_sequencing_notetracks" );
}

anim_single_thread(guys, index, scene, org, angles, animname_override, aligned, n_lerp_time, tracker)
{
	guy = guys[index];
	guy endon("death");
	
	if(guy is_a_sound_only_scene(scene, animname_override))
	{
		//-- DO NOT STOP the currently running animation
	}
	else
	{
		guy _stop_anim_threads();
	}

	blend_in = guy._anim_blend_in_time;
	blend_out = guy._anim_blend_out_time;
	
	n_rate = 1;
	if ( IsDefined( guy._anim_rate ) )
	{
		n_rate = guy._anim_rate;
	}

	// disable BCS if we're doing a scripted sequence.
	if (!IsDefined(guy._animActive))
	{
		guy._animActive = 0; // script models cant get their _animActive set by init
	}

	guy._animActive++;

	doFacialanim = false;
	doDialogue = false;
	const doAnimation = false;
	doText = false;
	doLook = false;

	dialogue = undefined;
	facialAnim = undefined;

	anim_string = "single anim";

	guy = guy get_anim_ent();
	
	animname = undefined;
	if ( IsDefined( animname_override ) )
	{
		animname = animname_override;
	}
	else
	{
		animname = guy.animname;
	}

/#
	guy assert_existance_of_anim( scene, animname );
#/

	if(( IsDefined( level.scr_face[ animname ] ) ) &&
		( IsDefined( level.scr_face[ animname ][ scene ] ) ) )
	{
		doFacialanim = true;
		facialAnim = level.scr_face[ animname ][ scene ];
	}

	if( is_mature() || !pg_sound_exists( animname, scene ) )
	{
		if( sound_exists( animname, scene ) )
		{
			doDialogue = true;
			dialogue = level.scr_sound[ animname ][ scene ];
		}
	}
	else if( pg_sound_exists( animname, scene ) )
	{
		doDialogue = true;
		dialogue = level.scr_sound[ animname ][ scene + "_pg" ];
	}

	if(( IsDefined( level.scr_look[ animname ] ) ) &&
		( IsDefined( level.scr_look[ animname ][ scene ] ) ) )
	{
		doLook = true;
	}

	if( IsDefined( level.scr_animSound[ animname ] ) && IsDefined( level.scr_animSound[ animname ][ scene ] ) )
	{
		if (IsDefined(guy.type) && guy.type == "human")
		{
			guy PlaySoundOnTag( level.scr_animSound[ animname ][ scene ], "J_Head" );	
		}
		else
		{
			guy playsound( level.scr_animSound[ animname ][ scene ] );
		}
	}
/#
	if( getdebugdvar( "animsound" ) == "on" )
	{
		guy thread animsound_start_tracker( scene, animname );
	}

	if(( IsDefined( level.scr_text[ animname ] ) ) &&
	   ( IsDefined( level.scr_text[ animname ][ scene ] ) ) )
	{
		doText = true;
	}
#/

	animation = guy get_anim(scene, animname_override);

	if (IsDefined(animation))
	{
		/#
		self thread anim_info_render_thread(guy, scene, org, angles, animname, scene, true);
		#/

		if (IsDefined(guy.a))
		{
			guy.a.coverIdleOnly = false;
		}

		animtime = GetAnimLength( animation );
		if ( animtime < tracker.scriptedAnimationTime )
		{
			tracker.scriptedAnimationTime = animtime;
			tracker.scriptedAnimationIndex = index;
		}

		if ( guy.classname == "script_vehicle" && !IS_TRUE( guy.supportsAnimScripted ) )
		{
			veh_org = GetStartOrigin( org, angles, animation );
			veh_ang = GetStartAngles( org, angles, animation );
			// vehicles use generic anim commands
			guy.origin = veh_org;
			guy.angles = veh_ang;
			guy SetFlaggedAnimKnobRestart( anim_string, animation, 1, 0.2, 1 );
		}
		else	// ai and models use animscripted
		{
			if ( IS_TRUE( aligned ) )
			{
				Assert( IsDefined( angles ), "Alignment node does not have angles specified." );
				guy AnimScripted( anim_string, org, angles, animation, "normal", undefined, n_rate, blend_in, n_lerp_time );
			}
			else
			{
				if ( IsDefined( guy.a ) && ( IS_EQUAL( guy.a.script, "move" ) ) )
				{
					// if the AI is running, wait for left foot notetrack before playing the animation for better blending
					guy wait_for_foot_sync();
				}

				guy AnimScripted( anim_string, guy.origin, guy.angles, animation, "normal", undefined, n_rate, blend_in );
			}

			guy last_anim_time_check();

			cut_time = 0.0; // default time to cut the anim short for blending out the animation
			if (IsDefined(blend_out))
			{
				cut_time = blend_out;
			}

			guy thread earlyout_animscripted( animation, cut_time );
		}

		guy notify("_anim_playing");

		thread notetrack_wait( guy, anim_string, scene, animname );
		thread animscriptDoNoteTracksThread( guy, anim_string/*, scene*/ );
	}

	if( doLook )
	{
		assert( IsDefined(animation), "Look animation \"" + scene + "\" for animname \"" +  animname  + "\" does not have a base animation" );
		// blend 2 animations so the guy can look at the player
		thread anim_look( guy, scene, level.scr_look[ animname ][ scene ] );
	}


//	println( "^a SOUND time ", dialogue );
	if(( doFacialanim ) ||( doDialogue ) )
	{
//		println( animname  , " facialanim ", facialanim );
		if( doFacialAnim )
		{
			if( doDialogue )
			{
				guy thread delayedDialogue( scene, doFacialanim, dialogue, level.scr_face[ animname ][ scene ] );
			}
			assert( !doanimation, "Can't play a facial anim and fullbody anim at the same time. The facial anim should be in the full body anim. Occurred on animation \"" + scene + "\"" );
			thread anim_facialAnim( guy, scene, level.scr_face[ animname ][ scene ] );
			tracker.scriptedFaceIndex = index;
		}
		else
		{
			if( IsDefined(animation) )
			{
				guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
			}
			else
			{
				if (IsAI(guy))
				{
					guy thread anim_facialFiller( "single dialogue" );
				}

				guy SaySpecificDialogue( facialAnim, dialogue, 1.0, "single dialogue" );
			}
		}

		tracker.scriptedSoundIndex = index;
//		println( "facial sound ", dialogue );
	}
	
	assert( IsDefined(animation) || doLook || doFacialanim || doDialogue || doText, "Tried to do anim scene " + scene + " on guy with animname " + animname + ", but he didn't have that anim scene." );

//	add_animation( animname , scene );

/#
	if( doText && !doDialogue )
	{
		IPrintLnBold( level.scr_text[ animname ][ scene ] );
		wait 1.5;
	}
#/
}

wait_for_foot_sync()
{
	self endon("death");
	self endon("foot_sync_timeout");
	
	self thread wait_for_foot_sync_timeout();
	self waittillmatch("runanim", "footstep_left_large");
	self notify("foot_sync");

	/#
		PrintLn("foot sync");
		Record3DText("foot sync", self.origin, (1, 0, 0), "ScriptedAnim", self);
	#/
}

// failsafe for being in move state but done running
wait_for_foot_sync_timeout()
{
	self endon("foot_sync");
	self endon("death");
	
	while (self.a.script == "move")
	{
		wait .05;
	}

	self notify("foot_sync_timeout");

	/#
		PrintLn("foot sync failed");
		Record3DText("foot sync failed", self.origin, (1, 0, 0), "ScriptedAnim", self);
	#/
}

anim_deathNotify( guy, scene )
{
	self endon( scene );
	guy waittill( "death" );
	self notify( scene );
}

anim_facialEndNotify( guy, scene )
{
	self endon( scene );
	guy waittillmatch( "face_done_" + scene, "end" );
	self notify( scene );
}

anim_dialogueEndNotify( guy, scene )
{
	self endon( scene );
	guy waittill( "single dialogue" );
	self notify( scene );
}

anim_animationEndNotify( guy, scene )
{
	self endon( scene );
	guy waittillmatch( "single anim", "end" );
	self notify( scene );
}

//PARAMETER CLEANUP
animscriptDoNoteTracksThread( guy, animstring/*, scene*/ )
{
	guy endon( "stop_sequencing_notetracks" );
	guy endon( "death" );
	guy DoNoteTracks( animstring );
}

add_animsound( newSound )
{
	// find a vacant slot in the array
	for( i=0; i < level.animsound_hudlimit; i++ )
	{
		if( IsDefined( self.animsounds[ i ] ) )
		{
			continue;
		}
		self.animSounds[ i ] = newSound;
		return;
	}

	// replace the oldest one
	keys = GetArrayKeys( self.animsounds );
	index = keys[ 0 ];
	timer = self.animsounds[ index ].end_time;
	for( i=1; i < keys.size; i++ )
	{
		key = keys[ i ];
		
		if( self.animsounds[ key ].end_time < timer )
		{
			timer = self.animsounds[ key ].end_time;
			index = key;
		}
	}
	
	self.animSounds[ index ] = newSound;
}

animSound_exists( scene, notetrack )
{
	keys = GetArrayKeys( self.animSounds );
	for( i=0; i < keys.size; i++ )
	{
		key = keys[ i ];
		if( self.animSounds[ key ].scene != scene )
		{
			continue;
		}
		if( self.animSounds[ key ].notetrack != notetrack )
		{
			continue;
		}
		// up its time since it was hit again
		self.animSounds[ key ].end_time = GetTime() + 60000;
		return true;
	}
	return false;
}

animsound_tracker( scene, notetrack, animname )
{
	add_to_animsound();
		
	if( notetrack == "end" )
	{
		return;
	}
	
	if( animSound_exists( scene, notetrack ) )
	{
		return;
	}
	
	newTrack = SpawnStruct();
	newTrack.scene = scene;
	newTrack.notetrack = notetrack;
	newTrack.animname = animname;
	newTrack.end_time = GetTime() + 60000;
	
	add_animsound( newTrack );
}

animsound_start_tracker( scene, animname )
{
	// tracks the start of every animation or sound call
	// so sound can attach a sound at that time

	add_to_animsound();
	
	newSound = SpawnStruct();
	newSound.scene = scene;
	newSound.notetrack = "#" + scene;
	newSound.animname = animname;
	newSound.end_time = GetTime() + 60000;

	if( animSound_exists( scene, newSound.notetrack ) )
	{
		return;
	}
	
	add_animsound( newSound );
}

animsound_start_tracker_loop( scene, loop, animname )
{
	// tracks the start of every animation or sound call
	// so sound can attach a sound at that time

	add_to_animsound();

	scene = loop + scene;
	newSound = spawnStruct();
	newSound.scene = scene;
	newSound.notetrack = "#" + scene;
	newSound.animname = animname;
	newSound.end_time = GetTime() + 60000;

	if( animSound_exists( scene, newSound.notetrack ) )
	{
		return;
	}
	
	add_animsound( newSound );
}

notetrack_wait( guy, msg, scene, animname_override )
{
	guy endon( "death" );
	
	guy notify( "stop_sequencing_notetracks" );
	guy endon( "stop_sequencing_notetracks" );
	
	tag_owner = self;
	animname = undefined;

	if ( IsDefined( animname_override ) )
	{
		animname = animname_override;
	}
	else
	{
		animname = guy.animname;
	}

	dialogue_array = [];
	has_scripted_notetracks = IsDefined( level.scr_notetrack[ animname ] );
	if ( has_scripted_notetracks )
	{
		for( i=0; i<level.scr_notetrack[ animname ].size; i++ )
		{
			scr_notetrack = level.scr_notetrack[ animname ][ i ];
			if( IsDefined( scr_notetrack[ "dialog" ] ) )
			{
				dialogue_array[ scr_notetrack[ "dialog" ] ] = true;
			}
		}
	}
	
	notetrack = "start";

	while( 1 )
	{
		dialogueNotetrack = false;
		
		/#
		if( getdebugdvar( "animsound" ) == "on" )
		{
			guy thread animsound_tracker( scene, notetrack, animname );
		}
		#/
				
		guy do_vehicle_notetracks( notetrack );

		if ( has_scripted_notetracks )
		{
			for( i = 0; i < level.scr_notetrack[ animname ].size; i++ )
			{
				scr_notetrack = level.scr_notetrack[ animname ][ i ];
				// SRS 6/13/2008: since code always returns notetracks as lowercase, we should compare against lowercase
				if( notetrack == ToLower( scr_notetrack[ "notetrack" ] )  || ToLower( scr_notetrack[ "notetrack" ] )=="any" )
				{
					if( scr_notetrack[ "scene" ] != "any" && scr_notetrack[ "scene" ] != scene )
					{
						// only play the sound if the notetrack is the same or if its "any"
						continue;
					}
				
					if( IsDefined( scr_notetrack[ "function" ] ) )
					{
						if( IsDefined( scr_notetrack[ "noteback" ] ) && IS_TRUE( scr_notetrack[ "noteback" ] ) )
						{
							self thread [ [ scr_notetrack[ "function" ] ] ]( guy, notetrack );
						}
						else
						{
							self thread [ [ scr_notetrack[ "function" ] ] ]( guy );
						}
					}
				
					if( IsDefined( level.scr_notetrack[  animname  ][ i ][ "flag" ] ) )
					{
						flag_set( level.scr_notetrack[  animname  ][ i ][ "flag" ] );
					}
					
					if( IsDefined( level.scr_notetrack[  animname  ][ i ][ "exploder" ] ) )
					{
						exploder( level.scr_notetrack[  animname  ][ i ][ "exploder" ] );
					}
					
					if( IsDefined( level.scr_notetrack[  animname  ][ i ][ "stop_exploder" ] ) )
					{
						stop_exploder( level.scr_notetrack[  animname  ][ i ][ "stop_exploder" ] );
					}
				
					if( IsDefined( scr_notetrack[ "attach gun left" ] ) )
					{
						guy gun_pickup_left();
						continue;
					}
		
					if( IsDefined( scr_notetrack[ "attach gun right" ] ) )
					{
						guy gun_pickup_right();
						continue;
					}
					
					if( IsDefined( scr_notetrack[ "detach gun" ] ) )
					{
						guy gun_leave_behind( scr_notetrack );
						continue;
					}
	
					if( IsDefined( scr_notetrack[ "swap from" ] ) )
					{
						guy Detach( guy.swapWeapon, scr_notetrack[ "swap from" ] );
						guy Attach( guy.swapWeapon, scr_notetrack[ "self tag" ] );
						continue;
					}
	
					if( IsDefined( scr_notetrack[ "attach model" ] ) )
					{
						if( IsDefined( scr_notetrack[ "selftag" ] ) )
						{
							guy Attach( scr_notetrack[ "attach model" ], scr_notetrack[ "selftag" ] );
						}
						else if ( IsDefined( scr_notetrack[ "tag" ] ) )
						{
							tag_owner Attach( scr_notetrack[ "attach model" ], scr_notetrack[ "tag" ] );
						}
						else
						{
							guy Attach( scr_notetrack[ "attach model" ] );
						}
	
						continue;
					}
	
					if( IsDefined( scr_notetrack[ "detach model" ] ) )
					{
						waittillframeend; // because this should come after any attachs that happen on the same frame
						if( IsDefined( scr_notetrack[ "selftag" ] ) )
						{
							guy Detach( scr_notetrack[ "detach model" ], scr_notetrack[ "selftag" ] );
						}
						else if ( IsDefined( scr_notetrack[ "tag" ] ) )
						{
							tag_owner Detach( scr_notetrack[ "detach model" ], scr_notetrack[ "tag" ] );
						}
						else
						{
							guy Detach( scr_notetrack[ "attach model" ] );
						}
					}
					
					if( IsDefined( scr_notetrack[ "level notify" ] ) )
					{
						level notify( scr_notetrack[ "level notify" ] );
					}

					if( IsDefined( scr_notetrack[ "change fov" ] ) )
					{
						// parse the notetrack to read fov values
						tokens = StrTok( scr_notetrack[ "change fov" ], "_" );
			
						Assert( ToLower( tokens[0] ) == "fov" );
						
						if( tokens[1] != "reset" )
						{
							new_fov = Int( Int( tokens[1] ) * 1.27 );
							
							if( tokens.size > 2 )
							{	
								lerp_time = Int( tokens[2] );
								get_players()[0] thread lerp_fov_overtime( lerp_time, new_fov, 1 );
							}
							else
							{							
								get_players()[0] SetClientDvar( "cg_fov", new_fov );								
							}
						}
						else
						{
							Assert( ToLower( tokens[1] ) == "reset" );
						
							if( tokens.size > 2 )
							{	
								lerp_time = Int( tokens[2] );
								get_players()[0] thread lerp_fov_overtime( lerp_time, 65, 1 );
							}
							else
							{	
								get_players()[0] SetClientDvar( "cg_fov", 65 );															
							}
						}
					}
					
					if ( IsDefined( scr_notetrack[ "fov" ] ) )
					{
						get_players()[0] thread lerp_fov_overtime( scr_notetrack[ "time" ], scr_notetrack[ "fov" ], 1 );
					}
	
					if( IsDefined( scr_notetrack[ "sound" ] ) )
					{
						guy thread play_sound_on_tag( scr_notetrack[ "sound" ], undefined, true );
					}
	
					// dialogueNotetrack keeps it from playing more then one dialogue on a "dialog" notetrack at the same time.
					// it will play the next dialogue on the next "dialog" notetrack if there are more then one in the animation.
					if( !dialogueNotetrack )
					{
						if( IsDefined( scr_notetrack[ "dialog" ] ) &&  IsDefined( dialogue_array[ scr_notetrack[ "dialog" ] ] ) )
						{
							anim_facial( guy, i, "dialog", animname );
							dialogue_array[ scr_notetrack[ "dialog" ] ] = undefined;
							dialogueNotetrack = true;
						}
					}
	
	/*				if( !dialogueNotetrack )
					{
						if( IsDefined( scr_notetrack[ "dialog" ] ) )
						{
								anim_facial( guy, i, "dialog", animname );
							dialogueNotetrack = true;
						}
					}
	*/
					if( IsDefined( scr_notetrack[ "create model" ] ) )
					{
						anim_addModel( guy, scr_notetrack );
					}
					else if( IsDefined( scr_notetrack[ "delete model" ] ) )
					{
						anim_removeModel( guy, scr_notetrack );
					}
	
					if(( IsDefined( scr_notetrack[ "selftag" ] ) ) &&
					( IsDefined( scr_notetrack[ "effect" ] ) ) )
					{
						playfxOnTag( 
						level._effect[ scr_notetrack[ "effect" ] ], guy, 
						scr_notetrack[ "selftag" ] );
					}
	
					if( IsDefined( scr_notetrack[ "tag" ] ) && IsDefined( scr_notetrack[ "effect" ] ) )
					{
						playfxOnTag( level._effect[ scr_notetrack[ "effect" ] ], tag_owner, scr_notetrack[ "tag" ] );
					}
					
					if( IsDefined( level.scr_special_notetrack[ animname ] ) )
					{
						tag = random( level.scr_special_notetrack[ animname ] );
						if( IsDefined( tag[ "tag" ] ) )
						{
							playfxOnTag( level._effect[ tag[ "effect" ] ], tag_owner, tag[ "tag" ] );
						}
						else if( IsDefined( tag[ "selftag" ] ) )
						{
							playfxOnTag( level._effect[ tag[ "effect" ] ], self, 	tag[ "tag" ] );
						}
					}				
				}
			}
		}

		prefix = GetSubStr( notetrack, 0, 3 );
	
		if ( prefix == "ps_" )
		{
			alias = GetSubStr( notetrack, 3 );

			guy thread play_sound_on_tag( alias, undefined, true );
		}
		
		if( notetrack == "end" )
		{
			return;
		}
		
		guy waittill( msg, notetrack );
	}
}

do_vehicle_notetracks( notetrack )
{
	n_weapon_index = 0;
	
	if ( IS_VEHICLE( self ) )
	{
		if ( GetSubStr( notetrack, 0, 4 ) == "fire" )
		{
			if ( GetSubStr( notetrack, 4, 9 ) == "start" )
			{
				if ( ( notetrack.size > 9 ) && IsDefined( notetrack[9] ) )
				{
					n_weapon_index = Int( notetrack[9] );
				}
				
				self thread maps\_turret::fire_turret_for_time( -1,  n_weapon_index );				
			}
			else if ( GetSubStr( notetrack, 4, 8 ) == "stop" )
			{
				if ( ( notetrack.size > 8 ) && IsDefined( notetrack[8] ) )
				{
					n_weapon_index = Int( notetrack[8] );
				}
				
				maps\_turret::stop_turret( n_weapon_index, false );
			}
			else
			{
				if ( ( notetrack.size > 4 ) && IsDefined( notetrack[4] ) )
				{
					n_weapon_index = Int( notetrack[4] );
				}
				
				maps\_turret::fire_turret( n_weapon_index );
			}
		}
	}
}

anim_addModel( guy, array )
{
	if( !IsDefined( guy.ScriptModel ) )
	{
		guy.ScriptModel = [];
	}
		
	index = guy.ScriptModel.size;
	guy.ScriptModel[ index ] = Spawn( "script_model", ( 0, 0, 0 ) );
	guy.ScriptModel[ index ] SetModel( array[ "create model" ] );
	guy.ScriptModel[ index ].origin = guy GetTagOrigin( array[ "selftag" ] );
	guy.ScriptModel[ index ].angles = guy GetTagAngles( array[ "selftag" ] );
}	

anim_removeModel( guy, array )
{
/#
	if( !IsDefined( guy.ScriptModel ) )
	{
		assertMsg( "Tried to remove a model with delete model before it was create model'd on guy: " + guy.animname );
	}
#/

	for( i=0;i<guy.ScriptModel.size;i++ )
	{
		if( IsDefined( array[ "explosion" ] ) )
		{
			forward = AnglesToForward( guy.scriptModel[ i ].angles );
			forward = VectorScale( forward, 120 );
			forward += guy.scriptModel[ i ].origin;
			playfx( level._effect[ array[ "explosion" ] ], guy.scriptModel[ i ].origin ); //, guy.scriptModel.origin, forward );
			RadiusDamage( guy.scriptModel[ i ].origin, 350, 700, 50 );
		}

		guy.scriptModel[ i ] delete();
	}
}

anim_facial( guy, i, dialogueString, animname )
{
	facialAnim = undefined;
	if ( IsDefined( level.scr_notetrack[ animname ][ i ][ "facial" ] ) )
	{
		facialAnim = level.scr_notetrack[ animname ][ i ][ "facial" ];
	}

	dialogue = undefined;
	if( is_mature() || !IsDefined( level.scr_notetrack[ animname ][ i ][ "pg_" + dialogueString ] ) )
	{
		dialogue = level.scr_notetrack[ animname ][ i ][ dialogueString ];
	}
	else if( IsDefined( level.scr_notetrack[ animname ][ i ][ "pg_" + dialogueString ] ) )
	{
		dialogue = level.scr_notetrack[ animname ][ i ][ "pg_" + dialogueString ];
	}
		
	guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
}

gun_pickup_left()
{
	if( !IsDefined( self.gun_on_ground ) )
	{
		return;
	}

	self.gun_on_ground delete();
	self.dropWeapon = true;
//	println( "dropweapon is ", self.dropweapon );

	self animscripts\shared::placeWeaponOn( self.weapon, "left" );
}

gun_pickup_right()
{
	if( !IsDefined( self.gun_on_ground ) )
	{
		return;
	}

	self.gun_on_ground delete();
	self.dropWeapon = true;
//	println( "dropweapon is ", self.dropweapon );
	
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

gun_leave_behind( scr_notetrack )
{
	if( IsDefined( self.gun_on_ground ) )
	{
		return;
	}

	gun = Spawn( "script_model", ( 0, 0, 0 ) );

	gun SetModel( self.weaponmodel );
	
	self.gun_on_ground = gun;
	gun.origin = self GetTagOrigin( scr_notetrack[ "tag" ] );
	gun.angles = self GetTagAngles( scr_notetrack[ "tag" ] );

	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	self.dropWeapon = false;
}

anim_weight( animname, scene )
{
	total_anims = level.scr_anim[ animname ][ scene ].size;
	idleanim = RandomInt( total_anims );
	if( total_anims > 1 )
	{
		weights = 0;
		anim_weight = 0;
		
		for( i = 0; i < total_anims; i++ )
		{
			if( IsDefined( level.scr_anim[ animname ][ scene + "weight" ] ) )
			{
				if( IsDefined( level.scr_anim[ animname ][ scene + "weight" ][ i ] ) )
				{
					weights++;
					anim_weight += level.scr_anim[ animname ][ scene + "weight" ][ i ];
				}
			}
		}
		
		if( weights == total_anims )
		{
			anim_play = randomfloat( anim_weight );
			anim_weight	= 0;
			
			for( i=0;i<total_anims;i++ )
			{
				anim_weight += level.scr_anim[ animname ][ scene + "weight" ][ i ];
				if( anim_play < anim_weight )
				{
					idleanim = i;
					break;
				}
			}
		}
	}
	
	return idleanim;
}		

get_anim_position( tag )
{
	org = undefined;
	angles = undefined;

	if( IsDefined( tag ) )
	{
		org = self GetTagOrigin( tag );
		angles = self GetTagAngles( tag );
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	array = [];
	array[ "angles" ] = angles;
	array[ "origin" ] = org;
	return array;
}

do_anim_reach( guys, scene, tag, animname_override, aligned )
{
	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];

	debugStartpos = false;

	/#
	debugStartpos = GetDebugDvar( "debug_animreach" ) ==  "on";
	#/

	threads = 0;
	tracker = SpawnStruct();

	if (!IsArray(guys))
	{
		// if not an array, make it one
		ARRAY_ADD(newguys, guys);
		guys=newguys;
	}

	for( i = 0; i < guys.size; i++ )
	{
		// If there is an animation with this scene then reach the starting spot for that animation
		// otherwise run to the node
		
		guy = guys[ i ];
		animation = guy get_anim(scene, animname_override);
		
		if ( IsDefined(animation) )
		{
			startorg = GetStartOrigin(org, angles, animation);
		}
		else
		{
			startorg = org;
		}
			
		/#
		if( debugStartpos )
		{
			thread debug_message_clear( "x", startorg, 1000, "clearAnimDebug" );
		}
		#/

		threads++;

		// handle arrivals based on notetracks in the animation we are reaching for

		disablearrivals = true;	// default disable arrivals to true
		if (!IS_TRUE(guy.disablearrivals)) // if set by level script, don't override
		{
			notetracks = GetNotetracksInDelta(animation, 0, 1);
			if (notetracks.size)
			{
				if ((notetracks[0][1] == "anim_movement = \"stop\"") && (notetracks[0][2] == 0))
				{
					disablearrivals = false;
				}
			}
		}

		self thread begin_anim_reach(guy, tracker, startorg, disablearrivals, aligned);
	}
	
	while( threads )
	{
		tracker waittill( "reach_notify" );
		threads--;
	}

	/#
	if( debugStartpos )
	{
		level notify( "x" + "clearAnimDebug" );
	}
	#/
}

anim_spawner_teleport( guy, scene, tag )
{
	pos = get_anim_position( tag );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	for( i=0; i < guy.size; i++ )
	{
		animation = guy[ i ] get_anim(scene);
		startorg = GetStartOrigin( org, angles, animation );
		guy[ i ].origin = startorg;
	}
}

reach_death_notify( guy )
{
	self endon( "reach_notify" );
	self waittill_any( "death", "_anim_reach", "_anim_playing", "_anim_stopped" );
	self notify( "reach_notify" );
}

begin_anim_reach(guy, tracker, startorg, disablearrivals, aligned)
{
	guy endon( "death" );

	guy notify( "stop_going_to_node" );

	guy notify( "_anim_reach" );
	guy endon( "_anim_reach" );
	
	waittillframeend; // allow end_anim_reach to clear variables before setting new ones if called on the same frame

	tracker thread reach_death_notify( guy );
	
	guy._anim_old_disablearrivals = guy.disablearrivals;
	guy._anim_old_fixednode = guy.fixednode;
	
	goal = startorg;
	
	// If reaching to a cover node, always handle it like it's aligned and make the guy do only idle animations on the cover node
	if (vector_compare(self.origin, startorg)
		&& IsDefined(self.type)	&& GetSubStr(self.type, 0, 5) == "Cover")
	{
		guy.a.coverIdleOnly = true;
		
		// always use arrivals when reaching to cover nodes
		disablearrivals = false;
		
		goal = self;
		aligned = true;

		guy.fixednode = true;
	}
	else
	{
		guy.fixednode = false;
	}

	if (disablearrivals)
	{
		guy.stopanimdistsq = 0.0001; // turns off deceleration
	}
	else
	{
		guy.stopanimdistsq = 0;	// turns on deceleration
	}

	guy.disablearrivals = disablearrivals;

	goal_radius = 50;
	if (aligned)
	{
		goal_radius = 0;
	}

	guy thread force_goal(goal, goal_radius, true, "anim_reach_done");
	guy thread end_anim_reach();
	
	guy waittill( "goal" );
	tracker notify("reach_notify");
}

end_anim_reach()
{
	self endon("death");

	self waittill_any( "_anim_reach", "_anim_playing", "_anim_stopped" );
	self notify( "anim_reach_done" );
		
	self.disablearrivals = self._anim_old_disablearrivals;
	self.fixednode = self._anim_old_fixednode;

	self.stopanimdistsq = 0;	// reset to zero (turns on deceleration)
	
	self._anim_old_fixednode = undefined;
	self._anim_old_disablearrivals = undefined;
}

/#
printloops( guy, scene )
{
//	wait( 0.05 );
	if( !IsDefined( guy ) )
	{
		return;
	}

	guy endon( "death" ); // could die during the frame
	waittillframeend; // delay a frame so if you end a loop with a notify then start a new loop, this guarentees that 
	                  // the 2nd loop doesnt start before the loop decrementer receives the same notify that ended the first loop
	guy.loops++;
	if( guy.loops > 1 )
	{
		assertMsg( "guy with name "+ guy.animname+ " has "+ guy.loops+ " looping animations played, scene: "+ scene );
	}
}

looping_anim_ender( guy, ender )
{
	guy endon( "death" );
	waittill_any_ents_two(self, ender, guy, ender);
	guy.loops--;
}
#/

get_animtree( guy )
{
	for( i = 0; i < guy.size; i++ )
	{
		guy[ i ] UseAnimTree( level.scr_animtree[ guy[ i ].animname ] );
	}
}

SetAnimTree()
{
	self UseAnimTree( level.scr_animtree[ self.animname ] );
}

anim_single_queue( guy, scene, tag )
{
	assert( IsDefined( scene ), "Tried to do anim_single_queue without passing a scene name (scene)" );
	
	if ( IsDefined( guy.last_queue_time ) )
	{
		wait_for_buffer_time_to_pass( guy.last_queue_time, 0.5 );
	}
	
	function_stack( ::anim_single_aligned, guy, scene, tag );
	guy.last_queue_time = GetTime();
}

anim_pushPlayer( guy )
{
	for( i=0;i<guy.size;i++ )
	{
		guy[ i ] PushPlayer( true );
	}
}

// MikeD (3/27/2008): Handles some of the "_anim.gsc" builtin notetracks
// ie:
// addNotetrack_custom( "dude", "intro", "attach_shotgun", "attach gun right", true, "tag", "tag_weapon_right" );
// "attach gun right" is in notetrackwait
//
// BrianB: not sure what this is for.  should be documented and moved to top of file
//
addNotetrack_custom( animname, scene, notetrack, index1_str, index1_val, index2_str, index2_val )
{
	if( !IsDefined( level.scr_notetrack[animname] ) )
	{
		level.scr_notetrack[animname] = [];
	}

	num = level.scr_notetrack[animname].size;

	add_note = [];
	add_note["notetrack"] = notetrack;
	add_note["scene"] = scene;
	add_note[index1_str] = index1_val;

	if( IsDefined( index2_str ) && IsDefined( index2_val ) )
	{
		add_note[index2_str] = index2_val;
	}

	level.scr_notetrack[animname][num] = add_note;
}

anim_ents( ents, scene, tag, animname )
{
	ents = build_ent_array(ents);
	pos = get_anim_position( tag );	

	origin = pos["origin"];
	angles = pos["angles"];

	parent_model = undefined;

	if( !IsDefined( animname ) && IsDefined( ents[0].animname ) )
	{
		animname = ents[0].animname;		
	}

	assert( IsDefined( animname ), "_anim::anim_ents() - Animname is not defined" );

	if( IsDefined( level.scr_model[animname] ) )
	{
		parent_model = Spawn( "script_model", origin );
		parent_model.angles = angles;

		parent_model.animname = animname;
		parent_model SetAnimTree();

		parent_model SetModel( level.scr_model[animname] );
	}

	for( i = 0; i < ents.size; i++ )
	{
		if( IsDefined( parent_model ) )
		{
			assert( IsDefined( ents[i].script_linkto ), "_anim::anim_ents() - Entity at " + ents[i].origin + " does not have a script_linkto Key/Value" );
			ents[i] LinkTo( parent_model, ents[i].script_linkto );
		}
		else
		{
			ents[i] SetAnimTree();

			// Animate the ents individually
			ents[i] SetFlaggedAnimKnob( "ent_anim", get_anim(scene, animname), 1.0, 0.2, 1.0 );
			thread notetrack_wait( ents[i], "ent_anim", scene, animname );
		}

		ents[i] notify("_anim_playing");
	}

	if( IsDefined( parent_model ) )
	{
		parent_model SetFlaggedAnimKnob( "ent_anim", get_anim(scene, animname), 1.0, 0.2, 1.0 );
		thread notetrack_wait( parent_model, "ent_anim", scene, animname );

		parent_model waittillmatch( "ent_anim", "end" );
		self notify( scene );
	}
}

#using_animtree( "generic_human" );

anim_look( guy, scene, array )
{
	guy endon( "death" );
	self endon( scene );
	const changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
	wait( 0.05 );
	
	guy setflaggedanimknobrestart( "face_done_" + scene, array[ "left" ], 1, 0.2, 1 );
	thread clearFaceAnimOnAnimdone( guy, "face_done_" + scene, scene );
	guy SetAnimKnobRestart( array[ "right" ], 1, 0.2, 1 );
	guy SetAnim( %scripted, 0.01, 0.3, 1 );
//	guy SetAnim( %scripted_look_straight, 	0, 	changeTime );

	const closeToZero = 0.01;
	for( ;; )
	{
		destYaw = guy GetYawToOrigin( level.player.origin );
		if( destYaw<=array[ "left_angle" ] )
		{
			animWeights[ "left" ] = 1;
			animWeights[ "right" ] = closeToZero;
		}
		else if( destYaw<array[ "right_angle" ] )
		{
			middleFraction =( array[ "right_angle" ] - destYaw ) /( array[ "right_angle" ] - array[ "left_angle" ] );
			if( middleFraction < closeToZero )
			{	
				middleFraction = closeToZero;
			}
			if( middleFraction > 1-closeToZero )
			{
				middleFraction = 1-closeToZero;
			}
			animWeights[ "left" ] = middleFraction;
			animWeights[ "right" ] =( 1 - middleFraction );
		}
		else
		{
			animWeights[ "left" ] = closeToZero;
			animWeights[ "right" ] = 1;
		}
		//these anims no longer exist asof 2/28/07
		//guy SetAnim( %scripted_look_left, 		animWeights[ "left" ], 	changeTime );	// anim, weight, blend-time
		//guy SetAnim( %scripted_look_right, 		animWeights[ "right" ], 	changeTime );
		wait( changeTime );
	}	
}

anim_facialAnim( guy, scene, faceanim )
{

	guy endon( "death" );
	self endon( scene );
	const changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
//	guy SetAnim( %scripted, 0.01, 0.3, 1 );
	
	guy notify( "newLookTarget" );		

	waittillframeend; // in case another facial animation just ended, so its clear doesnt overwrite us
	const closeToZero = 0.3;
	//guy ClearAnim( %scripted_look_left, 		changeTime );	// anim, weight, blend-time
	//guy ClearAnim( %scripted_look_right, 	changeTime );
	guy SetAnim( %scripted_look_straight, 	0, 0 );
	guy SetAnim( %scripted_look_straight, 	1, 0.5 );
	guy setflaggedanimknobrestart( "face_done_" + scene, faceanim, 1, 0, 1 );
	thread clearFaceAnimOnAnimdone( guy, "face_done_" + scene, scene );
}

anim_facialFiller( msg, lookTarget )
{
	self endon( "death" );
	
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
//	guy SetAnim( %scripted, 0.01, 0.3, 1 );

	self notify( "newLookTarget" );		
	self endon( "newLookTarget" );		
	
	waittillframeend; // in case another facial animation just ended, so its clear doesnt overwrite us
	const closeToZero = 0.3;
	//self ClearAnim( %scripted_look_left, 		changeTime );	// anim, weight, blend-time
	//self ClearAnim( %scripted_look_right, 		changeTime );
	
	/*
	quick = false;
	if( !IsDefined( looktarget ) )
	{
		guy[ 0 ] = self;
		lookTarget = get_closest_ai_exclude( self.origin, self.team, guy );
		if( IsDefined( looktarget ) )
			quick = true;
	}
	*/
	if( !IsDefined( looktarget ) && IsDefined( self.looktarget ) )
	{
		looktarget = self.looktarget;
	}

	if( IsDefined( looktarget ) )
	{
//		self SetAnim( %scripted_look_straight, 	0, 0 );
//		self SetAnim( %scripted_look_straight, 	1, 1 );
		thread chatAtTarget( msg, lookTarget );
		return;
	}

//	self SetAnim( %scripted_look_straight, 	0, 0 );
//	self SetAnim( %scripted_look_straight, 	1, 0.5 );
	self set_talker_until_msg( msg );

	changeTime = 0.3;
	//self ClearAnim( %scripted_talking, 0.1 );
	//self ClearAnim( %scripted_look_left, 		changeTime );
	//self ClearAnim( %scripted_look_right, 		changeTime );
	self ClearAnim( %scripted_look_straight, 	changeTime );
}

set_talker_until_msg( msg, talkanim )
{
	self endon( msg );
	for ( ;; )
	{
		self SendFaceEvent( "face_talk" );
		wait( 0.05 );
	}
}

talk_for_time( timer )
{
	self endon( "death" );
	talkAnim = %generic_talker_allies;
	if ( self.team == "axis" )
	{
		talkAnim = %generic_talker_axis;
	}

	self SetAnimKnobRestart( talkAnim, 1, 0, 1 );
	self SetAnim( %scripted_talking, 1, 0.1 );

	wait( timer );
	const changeTime = 0.3;
	self ClearAnim( %scripted_talking, 0.1 );
	self ClearAnim( %scripted_look_straight, 	changeTime );
}

GetYawAngles( angles1, angles2 )
{
	yaw = angles1[ 1 ] - angles2[ 1 ];
	yaw = AngleClamp180( yaw );
	return yaw;
}

chatAtTarget( msg, lookTarget )
{
	self endon( msg );
	self endon( "death" );


	self thread lookRecenter( msg );
	
	array[ "right" ] = %generic_lookupright;
	array[ "left" ] = %generic_lookupleft;
	
	array[ "left_angle" ] = -65;
	array[ "right_angle" ] = 65;
	

	const closeToZero = 0.01;
	org = looktarget.origin;

	moveRange = 2.0;
	const changeTime = 0.3;

	for( ;; )
	{
		if( isalive( looktarget ) )
		{
			org = looktarget.origin;
		}
		/#
		if( getdebugdvar( "debug_chatlook" ) == "on" )
		{
			thread lookLine( org, msg );
		}
		#/
//		destYaw = self GetEyeYawToOrigin( org );
//		destYaw = self GetYawToOrigin( org );
		angles = AnglesToRight( self GetTagAngles( "J_Spine4" ) );
		angles = VectorScale( angles, 10 );
		angles = VectorToAngles(( 0, 0, 0 ) - angles );
//		destYaw = self GetYawToTag( "J_Spine4", org );
	
		yaw = angles[ 1 ] - GET_YAW( self, org );
		destyaw = AngleClamp180( yaw );

		
		moveRange = abs( destYaw - self.a.lookAngle ) * 1;
		
		if( destYaw > self.a.lookangle + moveRange )
		{
			self.a.lookangle += moveRange;
		}
		else if( destYaw < self.a.lookangle - moveRange )
		{
			self.a.lookangle -= moveRange;
		}
		else
		{
			self.a.lookangle = destYaw;
		}
			
		destYaw = self.a.lookangle;
			
		if( destYaw <= array[ "left_angle" ] )
		{
			animWeights[ "left" ] = 1;
			animWeights[ "right" ] = closeToZero;
		}
		else if( destYaw < array[ "right_angle" ] )
		{
			middleFraction =( array[ "right_angle" ] - destYaw ) /( array[ "right_angle" ] - array[ "left_angle" ] );
			if( middleFraction < closeToZero )
			{
				middleFraction = closeToZero;
			}
			if( middleFraction > 1-closeToZero )
			{
				middleFraction = 1-closeToZero;
			}
			animWeights[ "left" ] = middleFraction;
			animWeights[ "right" ] = ( 1 - middleFraction );
		}
		else
		{
			animWeights[ "left" ] = closeToZero;
			animWeights[ "right" ] = 1;
		}
		
		self SetAnim( array[ "left" ], 		animWeights[ "left" ], 	changeTime );	// anim, weight, blend-time
		self SetAnim( array[ "right" ], 	animWeights[ "right" ], changeTime );
		wait( changeTime );
	}
}

lookRecenter( msg )
{
	// recenter the look angle so the head doesnt jerk back to where he used to be looking
	self endon( "newLookTarget" );	
	self endon( "death" );
	self waittill( msg );
	self ClearAnim( %scripted_talking, 0.1 );

	self SetAnim( %generic_lookupright, 		1, 		0.3 );	// anim, weight, blend-time
	self SetAnim( %generic_lookupleft, 		1, 		0.3 );
	self SetAnim( %scripted_look_straight, 	0.2, 	0.1 );
	wait( 0.2 );
	self ClearAnim( %scripted_look_straight, 0.2 );
}

/#
lookLine( org, msg )
{
	self notify( "lookline" );
	self endon( "lookline" );
	self endon( msg );
	self endon( "death" );
	for( ;; )
	{
		line( self GetEye(), org +( 0, 0, 60 ), ( 1, 1, 0 ), 1 );
		wait( 0.05 );
	}
}
#/
	
// used by anim_reach_idle
reach_idle( guy, scene, idle, ent )
{
	anim_reach_aligned( guy, scene );
	ent.count--;
	ent notify( "reach_idle_goal" );
	anim_loop( guy, idle );
}

delayedDialogue( scene, doAnimation, dialogue, animationName )
{
	assert( animhasnotetrack( animationName, "dialog" ), "Animation " + scene + " does not have a dialog notetrack." );
	
	self waittillmatch( "face_done_" + scene, "dialog" );
	if( doAnimation )
	{
		self SaySpecificDialogue( undefined, dialogue, 1.0 );
	}
	else
	{
		self SaySpecificDialogue( undefined, dialogue, 1.0, "single dialogue" );
	}
}

clearFaceAnimOnAnimdone( guy, msg, scene )
{
	guy endon( "death" );
//	self waittill( scene );
	guy waittillmatch( msg, "end" );
	const changeTime = 0.3;
//	guy ClearAnim( %scripted_look_left, 			changeTime );
//	guy ClearAnim( %scripted_look_right, 		changeTime );
	guy ClearAnim( %scripted_look_straight, 		changeTime );
}

anim_start_pos( ents, scene, tag )
{
	ents = build_ent_array(ents);

	pos = get_anim_position( tag );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];
	
	array_thread( ents, ::set_start_pos, scene, org, angles );
}

set_start_pos( scene, origin, angles, animname_override )
{
	animation = get_anim( scene, animname_override );
	
	origin = GetStartOrigin( origin, angles, animation );
	angles = GetStartAngles( origin, angles, animation );
		
	if ( IsSentient( self ) )
	{
		self ForceTeleport( origin, angles );
	}
	else
	{
		self.origin = origin;
		self.angles = angles;
	}
}

add_to_animsound()
{
	if( !IsDefined( self.animSounds ) )
	{
		self.animSounds = [];
	}

	isInArray = false;
	for( i=0; i < level.animSounds.size; i++ )
	{
		if( self == level.animSounds[ i ] )
		{
			isInArray = true;
			break;
		}
	}
	if( !isInArray )
	{
		level.animSounds[ level.animSounds.size ] = self;
	}
}

// used by anim_set_time
anim_self_set_time( scene, time )
{
	self SetAnimTime( self getanim( scene ), time );
}

last_anim_time_check()
{
	
	if ( !IsDefined( self.last_anim_time ) )
	{
		self.last_anim_time	= GetTime();
		return;
	}
	
	time = GetTime();
//	assert( self.last_anim_time != time, "Tried to do animscripted twice in one frame. This is not supported." );
	if ( self.last_anim_time == time )
	{
		// can't call 2 animscripteds on one frame
		// check this in after e3 build
		wait( 0.05 );
	}
	self.last_anim_time = time;
}

loopanim_sound_exists( animname, scene, idleanim )
{
	if( IsDefined( level.scr_sound[ animname ] ) && IsDefined( level.scr_sound[ animname ][ scene ] ) && IsDefined( level.scr_sound[ animname ][ scene ][ idleanim ] ) )
	{
		return true;
	}

	return false;
}

pg_loopanim_sound_exists( animname, scene, idleanim )
{
	if( IsDefined( level.scr_sound[ animname ] ) && IsDefined( level.scr_sound[ animname ][ scene + "_pg" ] ) && IsDefined( level.scr_sound[ animname ][ scene + "_pg" ][ idleanim ] ) )
	{
		return true;
	}

	return false;
}

sound_exists( animname, scene )
{
	if( IsDefined( level.scr_sound[ animname ] ) && IsDefined( level.scr_sound[ animname ][ scene ] ) )
	{
		return true;
	}

	return false;
}

animation_exists( animname, scene )
{
	if( IsDefined( level.scr_anim[ animname ] ) && IsDefined( level.scr_anim[ animname ][ scene ] ) )
	{
		return true;
	}

	return false;
}

pg_sound_exists( animname, scene )
{
	if( IsDefined( level.scr_sound[ animname ] ) && IsDefined( level.scr_sound[ animname ][ scene + "_pg" ] ) )
	{
		return true;
	}

	return false;
}

// ends the scripted animation early so it can blend out
earlyout_animscripted(animation, cut_time, blend_time)
{
	const DEFAULT_CUT_TIME = 0.3; // Most animscript blend in with a blend time of 0.2

	self endon("death");
	self endon("stop_single");

	if (!IsDefined(cut_time))
	{
		cut_time = DEFAULT_CUT_TIME;
	}

	if (!IsDefined(blend_time))
	{
		blend_time = cut_time;
	}
	
	if (cut_time <= 0)
	{
		return;
	}

	anim_time = GetAnimLength(animation);
	wait (anim_time - cut_time);
	
	self anim_stopanimscripted(blend_time);
}

/#
anim_origin_render( org, angles )
{
	if( !GetDvarInt( "recorder_enableRec" ) )
		return;
	
	if( IsDefined(org) && IsDefined(angles) )
	{
		originEndPoint = org + VectorScale(anglesToForward(angles), 10);
		originRightPoint = org + VectorScale(anglesToRight(angles), -10);
		originUpPoint = org + VectorScale(anglesToUp(angles), 10);

		recordLine( org, originEndPoint, (1,0,0), "ScriptedAnim" );
		recordLine( org, originRightPoint, (0,1,0), "ScriptedAnim" );
		recordLine( org, originUpPoint, (0,0,1), "ScriptedAnim" );
	}
}

// render useful info on each animating ent
anim_info_render_thread( guy, scene, org, angles, animname, ender, showBlends, b_first_frame )
{
	if( !GetDvarInt( "recorder_enableRec" ) )
		return;
	
	if( IsDefined( guy.script_recordent ) && !guy.script_recordent )
		return;
	
	guy notify("anim_info_render_thread");
	guy endon("anim_info_render_thread");
	
	self endon(ender);
	guy endon( ender );
	guy endon("death");
	
	RecordEnt( guy );

	// render the align node first
	if( IsDefined(org) )
	{
		recordLine( guy.origin, org, (1,1,0), "ScriptedAnim", guy );
	}

	if( IS_TRUE(showBlends) )
	{
		blendInTime = 0;
		if( IsDefined(guy._anim_blend_in_time) )
		{
			blendInTime = guy._anim_blend_in_time;
		}

		recordEntText( "blend-in time: " + blendInTime, guy, (1,1,0), "ScriptedAnim" );	

		blendOutTime = 0;
		if( IsDefined(guy._anim_blend_out_time) )
		{
			blendOutTime = guy._anim_blend_out_time;
		}

		recordEntText( "blend-out time: " + blendOutTime, guy, (1,1,0), "ScriptedAnim" );	
	}
	
	str_extra_info = "";
	color = (1,1,0);
	
	if ( IS_TRUE( b_first_frame ) )
	{
		str_extra_info += "(first frame)";
	}

	if ( !IsAssetLoaded( "xanim", string( get_anim( scene, animname ) ) ) )
	{
		str_extra_info += "(missing)";
		color = (1,0,0);
	}

	while(1)
	{
		originEndPoint = guy.origin + VectorScale(anglesToForward(guy.angles), 10);

		// render origin
		anim_origin_render( guy.origin, guy.angles );

		// render anim info
		recordEntText( "name: " + animname, guy, color, "ScriptedAnim" );
		recordEntText( "scene: " + scene + str_extra_info, guy, color, "ScriptedAnim" );

		// render tag info if it's the player
		if( !IsAi(guy) )
		{
			tagPlayerOrigin = guy GetTagOrigin("tag_player");
			if( IsDefined( tagPlayerOrigin ) )
			{
				tagPlayerAngles = guy GetTagAngles("tag_player");

				anim_origin_render( tagPlayerOrigin, tagPlayerAngles );
				Record3DText( "plr", tagPlayerOrigin, (1,1,0), "ScriptedAnim" );		
			}

			tagCameraOrigin = guy GetTagOrigin("tag_camera");
			if( IsDefined( tagCameraOrigin ) )
			{
				tagCameraAngles = guy GetTagAngles("tag_camera");

				anim_origin_render( tagCameraOrigin, tagCameraAngles );
				Record3DText( "cam", tagCameraOrigin, (1,1,0), "ScriptedAnim" );	
			}
		}

		wait(0.05);
	}
}
#/
