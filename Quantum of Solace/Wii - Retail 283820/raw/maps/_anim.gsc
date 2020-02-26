#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include animscripts\utility;
#include animscripts\face;



init()
{
	if( !isDefined( level.scr_special_notetrack ) )
		level.scr_special_notetrack = [];
	if( !isDefined( level.scr_notetrack ) )
		level.scr_notetrack = [];
	if( !isDefined( level.scr_face ) )
		level.scr_face = [];
	if( !isDefined( level.scr_look ) )
		level.scr_look = [];
	if( !isDefined( level.scr_animSound ) )
		level.scr_animSound = [];
	if( !isDefined( level.scr_sound ) )
		level.scr_sound = [];
	if( !isDefined( level.scr_radio ) )
		level.scr_radio = [];
	if( !isDefined( level.scr_text ) )
		level.scr_text = [];
	if( !isDefined( level.scr_anim ) )
		level.scr_anim[ 0 ][ 0 ] = 0;
	if( !isDefined( level.scr_radio ) )
		level.scr_radio = [];
}

endonRemoveAnimActive( endonString, guyPackets )
{
	self endon( "newAnimActive" );
	self waittill( endonString );
	for( i=0; i < guyPackets.size; i++ )
	{
		guy = guyPackets[ i ][ "guy" ];
		if( !isdefined( guy ) )
			continue;
			
		guy._animActive--;
		guy._lastAnimTime = getTime();
		assert( guy._animactive >= 0 );
	}
}




anim_first_frame( guys, anime, tag )
{
	array = get_anim_position( tag );
	org = array[ "origin" ];
	angles = array[ "angles" ];
	
	array_levelthread( guys, ::anim_first_frame_on_guy, anime, org, angles );
}




anim_first_frame_solo( guy, anime, tag )
{
	guys = [];
	guys[ 0 ] = guy;
	anim_first_frame( guys, anime, tag );
}

anim_first_frame_on_guy( guy, anime, org, angles )
{
	assertEx( isdefined( guy.animname ), "Animating character of type " + guy.classname + " has no animname." );
	assertEx( isdefined( level.scr_anim[ guy.animname ][ anime ] ), "Guy with animname " + guy.animname + " is trying to do scene " + anime + " but level.scr_anim[ " + guy.animname + " ][ " + anime + " ] does not exist!" );
	guy.first_frame_time = gettime();
	
	guy set_start_pos( anime, org, angles );
	
	if ( isai( guy ) )
	{
		


		guy animcustom( animscripts\first_frame::main );
	}
	else
	{


		guy setanimknob( level.scr_anim[ guy.animname ][ anime ], 1, 0, 0 );
	}
	
	

}




anim_loop( guys, anime, tag, ender, entity )
{
	guyPackets = [];
	for( i=0; i < guys.size; i++ )
	{
		packet = [];
		packet[ "guy" ] = guys[ i ];
		packet[ "entity" ] = entity;
		packet[ "tag" ] = tag;
		guyPackets[ guyPackets.size ] = packet;
	}

	anim_loop_packet( guyPackets, anime, ender );
}

anim_loop_packet_solo( singleGuyPacket, anime, ender )
{
	loopPacket = [];
	loopPacket[ 0 ] = singleGuyPacket;
	anim_loop_packet( loopPacket, anime, ender );
}

anim_loop_packet( guyPackets, anime, ender )
{
	
	for( i=0; i < guyPackets.size; i++ )
	{
		guy = guyPackets[ i ][ "guy" ];
		if( !isdefined( guy ) )
			continue;
			
		if( !isdefined( guy._animActive ) )
			guy._animActive = 0; 
			
		guy._animActive++;
	}
	
	baseGuy = guyPackets[ 0 ][ "guy" ];
/#
	if( !isdefined( baseGuy.loops ) )
	{
		baseGuy.loops = 0;
	}

	thread printloops( baseGuy, anime );
#/

	if( isdefined( ender ) )
	{
		thread endonRemoveAnimActive( ender, guyPackets );
		self endon( ender );
/#
		self thread looping_anim_ender( baseGuy, ender );
#/
	}

		
	idleanim = 0;
	lastIdleanim = 0;
	while( 1 )
	{
		idleanim = anim_weight( baseGuy.animname, anime );
		while(( idleanim == lastIdleanim ) &&( idleanim != 0 ) )
			idleanim = anim_weight( baseGuy.animname, anime );
		lastIdleanim = idleanim;
			
		scriptedAnimationIndex = -1;
		scriptedSoundIndex = -1;
		for( i = 0; i < guyPackets.size; i++ )
		{
			guy = guyPackets[ i ][ "guy" ];
			pos = get_anim_position( guyPackets[ i ][ "tag" ], guyPackets[ i ][ "entity" ] );
			org = pos[ "origin" ];
			angles = pos[ "angles" ];
			entity = guyPackets[ i ][ "entity" ];
			
			doFacialanim = false;
			doDialogue = false;
			doAnimation = false;
			doText = false;
			facialAnim = undefined;
			dialogue = undefined;
			animname = guy.animname;
			
			if(( isdefined( level.scr_face[ animname ] ) ) &&
				( isdefined( level.scr_face[ animname ][ anime ] ) ) &&
				( isdefined( level.scr_face[ animname ][ anime ][ idleanim ] ) ) )
			{
				doFacialanim = true;
				facialAnim = level.scr_face[ animname ][ anime ][ idleanim ];
			}
	
			if(( isdefined( level.scr_sound[ animname ] ) ) && 
				( isdefined( level.scr_sound[ animname ][ anime ] ) ) &&
				( isdefined( level.scr_sound[ animname ][ anime ][ idleanim ] ) ) )
			{
				doDialogue = true;
				dialogue = level.scr_sound[ animname ][ anime ][ idleanim ];
			}
	
			if( isdefined( level.scr_animSound[ animname ] ) && 
				 isdefined( level.scr_animSound[ animname ][ idleanim + anime ] ) )
			{
				guy playsound( level.scr_animSound[ animname ][ idleanim + anime ] );
			}
			

			/#
			if( getdebugdvar( "animsound" ) == "on" )
			{
				guy thread animsound_start_tracker_loop( anime, idleanim );
			}

			#/

			if(( isdefined( level.scr_anim[ animname ] ) ) &&
				( isdefined( level.scr_anim[ animname ][ anime ] ) ) )
				doAnimation = true;

			/#
			if(( isdefined( level.scr_text[ animname ] ) ) &&
				( isdefined( level.scr_text[ animname ][ anime ] ) ) )
				doText = true;
			#/
				
			
			if( doAnimation )
			{
				if ( guy.classname == "script_vehicle" )
				{
					
					guy.origin = org;
					guy.angles = angles;
					guy setflaggedanimknob( "looping anim", level.scr_anim[ animname ][ anime ][ idleanim ], 1, 0.2, 1 );
				}
				else
				{
					
					guy animscripted( "looping anim", org, angles, level.scr_anim[ animname ][ anime ][ idleanim ] );
				}
				
				scriptedAnimationIndex = i;
	
				if( isdefined( level.scr_notetrack[ animname ] ) )
					thread notetrack_wait( guy, "looping anim", entity, anime );
				else
					guy notify( "stop doing _anim notetracks" );

				guy thread animscriptDoNoteTracksThread( "looping anim" );
			}

			if(( doFacialanim ) ||( doDialogue ) )
			{


				
				if( doAnimation )
					guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
				else
					guy SaySpecificDialogue( facialAnim, dialogue, 1.0, "looping anim" );
					
				scriptedSoundIndex = i;
			}
			
			/#
			if( doText && !doDialogue )
				iprintlnBold( level.scr_text[ animname ][ anime ] );
	

			#/
		}
	
		if( scriptedAnimationIndex != -1 )
			guyPackets[ scriptedAnimationIndex ][ "guy" ] waittillmatch( "looping anim", "end" );
		else
		if( scriptedSoundIndex != -1 )
			guyPackets[ scriptedSoundIndex ][ "guy" ] waittill( "looping anim" );
	}
}

anim_single_failsafeOnGuy( owner, anime )
{
	/#
	if( getdebugdvar( "debug_grenadehand" ) != "on" )
		return;

	owner endon( anime );
	owner endon( "death" );
	self endon( "death" );
	name = self.classname;
	num = self getentnum();
	wait( 60 );
	println( "Guy had classname " + name + " and entnum " + num );
	waittillframeend;
	assertEx( 0, "Animation '" + anime + "' did not finish after 60 seconds. See note above" );
	#/
	
}

anim_single_failsafe( guy, anime )
{



	for( i=0;i<guy.size;i++ )
		guy[ i ] thread anim_single_failsafeOnGuy( self, anime );
	
}


anim_single( guys, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	
	/#
	thread anim_single_failsafe( guys, anime );
	#/
	
	for( i=0;i<guys.size;i++ )
	{
		if( !isdefined( guys[ i ] ) )
			continue;
		if( !isdefined( guys[ i ]._animActive ) )
			guys[ i ]._animActive = 0; 
		guys[ i ]._animActive++;
	}

	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	scriptedAnimationIndex = -1;
	scriptedSoundIndex = -1;
	scriptedFaceIndex = -1;
	for( i=0;i<guys.size;i++ )
	{
		guy = guys[ i ];
		doFacialanim = false;
		doDialogue = false;
		doAnimation = false;
		doText = false;
		doLook = false;

		dialogue = undefined;
		facialAnim = undefined;
		animname = guy.animname;
		
		assertEx( isdefined( animname ), "Animname is not defined on an actor in a scene" );
		if(( isdefined( level.scr_face[ animname ] ) ) &&
			( isdefined( level.scr_face[ animname ][ anime ] ) ) )
		{
			doFacialanim = true;
			facialAnim = level.scr_face[ animname ][ anime ];
		}


		if(( isdefined( level.scr_sound[ animname ] ) ) && 
			( isdefined( level.scr_sound[ animname ][ anime ] ) ) )
		{
			doDialogue = true;
			dialogue = level.scr_sound[ animname ][ anime ];
		}

		if(( isdefined( level.scr_anim[ animname ] ) ) &&
			( isdefined( level.scr_anim[ animname ][ anime ] ) ) )
			doAnimation = true;

		if(( isdefined( level.scr_look[ animname ] ) ) &&
			( isdefined( level.scr_look[ animname ][ anime ] ) ) )
			doLook = true;

		if( isdefined( level.scr_animSound[ animname ] ) && 
			 isdefined( level.scr_animSound[ animname ][ anime ] ) )
		{
			guy playsound( level.scr_animSound[ animname ][ anime ] );
		}

		/#
		if( getdebugdvar( "animsound" ) == "on" )
		{
			guy thread animsound_start_tracker( anime );
		}
		#/
		

		/#
		if(( isdefined( level.scr_text[ animname ] ) ) &&
			( isdefined( level.scr_text[ animname ][ anime ] ) ) )
			doText = true;
		#/
	
		if( doAnimation )
		{
			if ( guy.classname == "script_vehicle" )
			{
				veh_org = getstartorigin( org, angles, level.scr_anim[ animname ][ anime ] );
				veh_ang = getstartangles( org, angles, level.scr_anim[ animname ][ anime ] );
				
				guy.origin = veh_org;
				guy.angles = veh_ang;
				guy setflaggedanimknob( "single anim", level.scr_anim[ animname ][ anime ], 1, 0.2, 1 );
			}
			else
			{
				
				guy animscripted( "single anim", org, angles, level.scr_anim[ animname ][ anime ] );
			}
			
			scriptedAnimationIndex = i;

			if( isdefined( level.scr_notetrack[ animname ] ) )
				thread notetrack_wait( guy, "single anim", entity, anime );
			else
				guy notify( "stop doing _anim notetracks" );
			guy thread animscriptDoNoteTracksThread( "single anim" );
		}
		if( doLook )
		{
			assertEx( doAnimation, "Look animation " + anime + " for animname " +  animname  + " does not have a base animation" );
			
			thread anim_look( guy, anime, level.scr_look[ animname ][ anime ] );
		}

		

		if(( doFacialanim ) ||( doDialogue ) )
		{

			if( doFacialAnim )
			{
				if( doDialogue )
					guy thread delayedDialogue( anime, doFacialanim, dialogue, level.scr_face[ animname ][ anime ] );
				assertEx( !doanimation, "Can't play a facial anim and fullbody anim at the same time. The facial anim should be in the full body anim. Occurred on animation " + anime );
				thread anim_facialAnim( guy, anime, level.scr_face[ animname ][ anime ] );
				scriptedFaceIndex = i;
			}
			else
			if( doAnimation )
				guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );
			else
			{
				guy thread anim_facialFiller( "single dialogue" );
				guy SaySpecificDialogue( facialAnim, dialogue, 1.0, "single dialogue" );
			}
			
			scriptedSoundIndex = i;

		}
		assertEx( doAnimation || doLook || doFacialanim || doDialogue, "Tried to do anim scene " + anime + " on guy with animname " + animname + ", but he didn't have that anim scene." );



		/#
		if( doText && !doDialogue )
		{
			iprintlnBold( level.scr_text[ animname ][ anime ] );
			wait 1.5;
		}
		#/
	}


	if( scriptedAnimationIndex != -1 )
	{

		ent = spawnstruct();
		ent thread anim_deathNotify( guys[ scriptedAnimationIndex ], anime );
		ent thread anim_animationEndNotify( guys[ scriptedAnimationIndex ], anime );
		ent waittill( anime );

	}
	else
	if( scriptedFaceIndex != -1 )
	{
		ent = spawnstruct();
		ent thread anim_deathNotify( guys[ scriptedFaceIndex ], anime );
		ent thread anim_facialEndNotify( guys[ scriptedFaceIndex ], anime );
		ent waittill( anime );
	}
	else
	if( scriptedSoundIndex != -1 )
	{

		ent = spawnstruct();
		ent thread anim_deathNotify( guys[ scriptedSoundIndex ], anime );
		ent thread anim_dialogueEndNotify( guys[ scriptedSoundIndex ], anime );
		ent waittill( anime );

	}
		
	for( i=0;i<guys.size;i++ )
	{
		if( !isdefined( guys[ i ] ) )
			continue;
		guys[ i ]._animActive--;
		guys[ i ]._lastAnimTime = getTime();
		assert( guys[ i ]._animactive >= 0 );
	}
	self notify( anime );
}

anim_deathNotify( guy, anime )
{
	self endon( anime );
	guy waittill( "death" );
	self notify( anime );
}


anim_facialEndNotify( guy, anime )
{
	self endon( anime );
	guy waittillmatch( "face_done_" + anime, "end" );
	self notify( anime );
}

anim_dialogueEndNotify( guy, anime )
{
	self endon( anime );
	guy waittill( "single dialogue" );
	self notify( anime );
}

anim_animationEndNotify( guy, anime )
{
	self endon( anime );
	guy waittillmatch( "single anim", "end" );
	self notify( anime );
}

animscriptDoNoteTracksThread( animstring )
{
	self endon( "stop doing _anim notetracks" );
	self endon( "death" );
	DoNoteTracks( animstring );
}

add_animsound( newSound )
{
	
	for( i=0; i < level.animsound_hudlimit; i++ )
	{
		if( isdefined( self.animsounds[ i ] ) )
		{
			continue;
		}
		self.animSounds[ i ] = newSound;
		return;
	}

	
	keys = getarraykeys( self.animsounds );
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

animSound_exists( anime, notetrack )
{
	keys = getarraykeys( self.animSounds );
	for( i=0; i < keys.size; i++ )
	{
		key = keys[ i ];
		if( self.animSounds[ key ].anime != anime )
			continue;
		if( self.animSounds[ key ].notetrack != notetrack )
			continue;
		
		self.animSounds[ key ].end_time = gettime() + 60000;
		return true;
	}
	return false;
}


animsound_tracker( anime, notetrack )
{
	add_to_animsound();
		
	if( notetrack == "end" )
		return;
	
	if( animSound_exists( anime, notetrack ) )
		return;
	
	newTrack = spawnStruct();
	newTrack.anime = anime;
	newTrack.notetrack = notetrack;
	newTrack.animname = self.animname;
	newTrack.end_time = gettime() + 60000;
	
	add_animsound( newTrack );
}

animsound_start_tracker( anime )
{
	
	

	add_to_animsound();
	
	newSound = spawnStruct();
	newSound.anime = anime;
	newSound.notetrack = "#" + anime;
	newSound.animname = self.animname;
	newSound.end_time = gettime() + 60000;

	if( animSound_exists( anime, newSound.notetrack ) )
		return;
	
	add_animsound( newSound );
}

animsound_start_tracker_loop( anime, loop )
{
	
	

	add_to_animsound();

	anime = loop + anime;
	newSound = spawnStruct();
	newSound.anime = anime;
	newSound.notetrack = "#" + anime;
	newSound.animname = self.animname;
	newSound.end_time = gettime() + 60000;

	if( animSound_exists( anime, newSound.notetrack ) )
		return;
	
	add_animsound( newSound );
}

notetrack_wait( guy, msg, tag_entity, anime )
{
	guy notify( "stop doing _anim notetracks" );
	guy endon( "stop doing _anim notetracks" );
	guy endon( "death" );
	

	if( isdefined( tag_entity ) )
		tag_owner = tag_entity;
	else
		tag_owner = self;

	animname = guy.animname;

	dialogue_array = [];
	for( i=0; i<level.scr_notetrack[ animname ].size; i++ )
	{
		scr_notetrack = level.scr_notetrack[ animname ][ i ];
		if( isdefined( scr_notetrack[ "dialog" ] ) )
			dialogue_array[ scr_notetrack[ "dialog" ] ] = true;
	}

	while( 1 )
	{
		dialogueNotetrack = false;

		guy waittill( msg, notetrack );
		
		/#
		if( getdebugdvar( "animsound" ) == "on" )
		{
			guy thread animsound_tracker( anime, notetrack );
		}
		#/
		
		if( notetrack == "end" )
			return;

		for( i=0;i<level.scr_notetrack[ animname ].size;i++ )
		{
			scr_notetrack = level.scr_notetrack[ animname ][ i ];
			if( notetrack == scr_notetrack[ "notetrack" ] )
			{
				if( scr_notetrack[ "anime" ] != "any" && scr_notetrack[ "anime" ] != anime )
				{
					
					continue;
				}
			
				if( isdefined( scr_notetrack[ "function" ] ) )
					self thread [ [ scr_notetrack[ "function" ] ] ]( guy );
			
				if( isdefined( level.scr_notetrack[  animname  ][ i ][ "flag" ] ) )
				{
					flag_set( level.scr_notetrack[  animname  ][ i ][ "flag" ] );
				}
			
				if( isdefined( scr_notetrack[ "attach gun left" ] ) )
				{
					guy gun_pickup_left();
					continue;
				}
	
				if( isdefined( scr_notetrack[ "attach gun right" ] ) )
				{
					guy gun_pickup_right();
					continue;
				}
				
				if( isdefined( scr_notetrack[ "detach gun" ] ) )
				{
					self gun_leave_behind( guy, scr_notetrack );
					continue;
				}

				if( isdefined( scr_notetrack[ "swap from" ] ) )
				{
					guy detach( guy.swapWeapon, scr_notetrack[ "swap from" ] );
					guy attach( guy.swapWeapon, scr_notetrack[ "self tag" ] );
					continue;
				}

				if( isdefined( scr_notetrack[ "attach model" ] ) )
				{
					if( isdefined( scr_notetrack[ "selftag" ] ) )
						guy attach( scr_notetrack[ "attach model" ], scr_notetrack[ "selftag" ] );
					else
						tag_owner attach( scr_notetrack[ "attach model" ], scr_notetrack[ "tag" ] );

					continue;
				}

				if( isdefined( scr_notetrack[ "detach model" ] ) )
				{
					waittillframeend; 
					if( isdefined( scr_notetrack[ "selftag" ] ) )
						guy detach( scr_notetrack[ "detach model" ], scr_notetrack[ "selftag" ] );
					else
						tag_owner detach( scr_notetrack[ "detach model" ], scr_notetrack[ "tag" ] );
				}

				if( isdefined( scr_notetrack[ "sound" ] ) )
					guy thread play_sound_on_tag( scr_notetrack[ "sound" ] );

				
				
				if( !dialogueNotetrack )
				{
					if( isdefined( scr_notetrack[ "dialog" ] ) &&  isdefined( dialogue_array[ scr_notetrack[ "dialog" ] ] ) )
					{
						anim_facial( guy, i, "dialog" );
						dialogue_array[ scr_notetrack[ "dialog" ] ] = undefined;
						dialogueNotetrack = true;
					}
				}


				if( isdefined( scr_notetrack[ "create model" ] ) )
					anim_addModel( guy, scr_notetrack );
				else
				if( isdefined( scr_notetrack[ "delete model" ] ) )
					anim_removeModel( guy, scr_notetrack );

				if(( isdefined( scr_notetrack[ "selftag" ] ) ) &&
				( isdefined( scr_notetrack[ "effect" ] ) ) )
				{
					playfxOnTag( 
					level._effect[ scr_notetrack[ "effect" ] ], guy, 
					scr_notetrack[ "selftag" ] );
				}

				if( isdefined( scr_notetrack[ "tag" ] ) && isdefined( scr_notetrack[ "effect" ] ) )
				{
					playfxOnTag( level._effect[ scr_notetrack[ "effect" ] ], tag_owner, scr_notetrack[ "tag" ] );
				}
				
				if( isdefined( level.scr_special_notetrack[ animname ] ) )
				{
					tag = random( level.scr_special_notetrack[ animname ] );
					if( isdefined( tag[ "tag" ] ) )
						playfxOnTag( level._effect[ tag[ "effect" ] ], tag_owner, tag[ "tag" ] );
					else
					if( isdefined( tag[ "selftag" ] ) )
						playfxOnTag( level._effect[ tag[ "effect" ] ], self, 	tag[ "tag" ] );
				}				
			}
			else
			if( notetrack == "lookat = \"on\"" )
				guy lookat( level.player );
			else
			if( notetrack == "lookat = \"off\"" )
				guy lookat( guy, 0 );

		}
	}
}

anim_addModel( guy, array )
{
	if( !isdefined( guy.ScriptModel ) )
		guy.ScriptModel = [];
		
	index = guy.ScriptModel.size;
	guy.ScriptModel[ index ] = spawn( "script_model", ( 0, 0, 0 ) );
	guy.ScriptModel[ index ] setmodel( array[ "create model" ] );
	guy.ScriptModel[ index ].origin = guy gettagOrigin( array[ "selftag" ] );
	guy.ScriptModel[ index ].angles = guy gettagAngles( array[ "selftag" ] );
}	

anim_removeModel( guy, array )
{
/#
	if( !isdefined( guy.ScriptModel ) )
		assertMsg( "Tried to remove a model with delete model before it was create model'd on guy: " + guy.animname );
#/

	for( i=0;i<guy.ScriptModel.size;i++ )
	{
		if( isdefined( array[ "explosion" ] ) )
		{
			forward = anglesToForward( guy.scriptModel[ i ].angles );
			forward = vectorScale( forward, 120 );
			forward += guy.scriptModel[ i ].origin;
			playfx( level._effect[ array[ "explosion" ] ], guy.scriptModel[ i ].origin ); 
			radiusDamage( guy.scriptModel[ i ].origin, 350, 700, 50 );
		}
		guy.scriptModel[ i ] delete();
	}
}

anim_facial( guy, i, dialogueString )
{
	facialAnim = undefined;
	if( isdefined( level.scr_notetrack[ guy.animname ][ i ][ "facial" ] ) )
		facialAnim = level.scr_notetrack[ guy.animname ][ i ][ "facial" ];

	dialogue = level.scr_notetrack[ guy.animname ][ i ][ dialogueString ];


		
	guy SaySpecificDialogue( facialAnim, dialogue, 1.0 );

}

gun_pickup_left()
{
	if( !isdefined( self.gun_on_ground ) )
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;


	self animscripts\shared::placeWeaponOn( self.weapon, "left" );
}

gun_pickup_right()
{
	if( !isdefined( self.gun_on_ground ) )
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;

	
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

gun_leave_behind( guy, scr_notetrack )
{
	if( isdefined( guy.gun_on_ground ) )
		return;

	link = true;

	if( self == guy )
		link = false;

	gun = spawn( "weapon_" + guy.weapon, ( 0, 0, 0 ) );
	
	guy.gun_on_ground = gun;
	gun.origin = self gettagOrigin( scr_notetrack[ "tag" ] );
	gun.angles = self gettagAngles( scr_notetrack[ "tag" ] );

	if( link )
		gun linkto( self, scr_notetrack[ "tag" ], ( 0, 0, 0 ), ( 0, 0, 0 ) );
	else
	{
		org = spawn( "script_origin", ( 0, 0, 0 ) );
		org.origin = gun.origin;
		org.angles = gun.angles;
		level thread gun_killOrigin( gun, org );
	}
	
	guy animscripts\shared::placeWeaponOn( self.weapon, "none" );
	guy.dropWeapon = false;
}

gun_killOrigin( gun, org )
{
	gun waittill( "death" );
	org delete();
}



anim_weight( animname, anime )
{
	total_anims = level.scr_anim[ animname ][ anime ].size;
	idleanim = randomint( total_anims );
	if( total_anims > 1 )
	{
		weights = 0;
		anim_weight = 0;
		
		for( i=0;i<total_anims;i++ )
		{
			if( isdefined( level.scr_anim[ animname ][ anime + "weight" ] ) )
			{
				if( isdefined( level.scr_anim[ animname ][ anime + "weight" ][ i ] ) )
				{
					weights++;
					anim_weight += level.scr_anim[ animname ][ anime + "weight" ][ i ];
				}
			}
		}
		
		if( weights == total_anims )
		{
			anim_play = randomfloat( anim_weight );
			anim_weight	= 0;
			
			for( i=0;i<total_anims;i++ )
			{
				anim_weight += level.scr_anim[ animname ][ anime + "weight" ][ i ];
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

convert_tagent_to_ent( node, tag_entity )
{
	if( isdefined( tag_entity ) )
	{
		return tag_entity;
	}
	return node;
}

anim_reach_and_idle( guy, anime, anime_idle, ender, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	thread anim_reach( guy, anime, tag, entity );
	
	ent = spawnstruct();
	ent.reachers = 0;
	for( i=0; i < guy.size; i++ )
	{
		ent.reachers++;
		thread idle_on_reach( guy[ i ], anime_idle, ender, tag, entity, ent );
	}
	
	for( ;; )
	{
		ent waittill( "reached_position" );
		if( ent.reachers <= 0 )
			return;
	}
}

wait_for_guy_to_die_or_get_in_position()
{
	self endon( "death" );
	self waittill( "anim_reach_complete" );
}

idle_on_reach( guy, anime_idle, ender, tag, entity, ent )
{
	guy wait_for_guy_to_die_or_get_in_position();
	ent.reachers--;
	ent notify( "reached_position" );

	if( isalive( guy ) )	
		anim_loop_solo( guy, anime_idle, tag, ender, entity );
}

get_anim_position( tag, entity )
{
	org = undefined;
	angles = undefined;
	if( isdefined( tag ) )
	{
		if( isdefined( entity ) )
		{
			org = entity gettagOrigin( tag );
			angles = entity gettagAngles( tag );
		}
		else
		{
			org = self gettagOrigin( tag );
			angles = self gettagAngles( tag );
		}
	}
	else
	if( isdefined( entity ) )
	{
		org = entity.origin;
		angles = entity.angles;
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
	
anim_reach( guys, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );

	array = get_anim_position( tag, entity );
	org = array[ "origin" ];
	angles = array[ "angles" ];

	ent = spawnstruct();
	debugStartpos = false;
	/#
	debugStartpos = getdebugdvar( "debug_animreach" ) ==  "on";
	#/
	threads = 0;
	for( i=0; i < guys.size; i++ )
	{
		
		
		guy = guys[ i ];
		if( isdefined( level.scr_anim[ guy.animname ][ anime ] ) )
		{
			startorg = getstartOrigin( org, angles, level.scr_anim[ guy.animname ][ anime ] );
		}
		else
		{
			startorg = org;
		}
			
		/#
		if( debugStartpos )
			thread debug_message_clear( "x", startorg, 1000, "clearAnimDebug" );
		#/
		guy setgoalpos( startorg );
		threads++;
		guy thread begin_anim_reach( ent );
	}
	
	while( threads )
	{
		ent waittill( "reach_notify" );
		threads--;
	}
	/#
	if( debugStartpos )
		level notify( "x" + "clearAnimDebug" );
	#/
	
	for( i=0;i<guys.size;i++ )
	{
		if( isalive( guys[ i ] ) )
			guys[ i ].goalradius = guys[ i ].oldgoalradius;
	}
}

anim_teleport( guy, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	ent = spawnstruct();

	for( i=0;i<guy.size;i++ )
	{
		startorg = getstartOrigin( org, angles, level.scr_anim[ guy[ i ].animname ][ anime ] );
		if( isSentient( guy[ i ] ) )
			guy[ i ] teleport( startorg );
		else
			guy[ i ].origin = startorg;
	}
}

anim_spawner_teleport( guy, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	ent = spawnstruct();

	for( i=0; i < guy.size; i++ )
	{
		startorg = getstartOrigin( org, angles, level.scr_anim[ guy[ i ].animname ][ anime ] );
		guy[ i ].origin = startorg;
	}
}

reach_death_notify( ent )
{
	self endon( "goal" );
	self waittill( "death" );
	ent notify( "reach_notify" );
}

begin_anim_reach( ent )
{
	self endon( "death" );
	thread reach_death_notify( ent );
	self.oldgoalradius = self.goalradius;
	self.oldpathenemyFightdist = self.pathenemyFightdist;
	self.oldpathenemyLookahead = self.pathenemyLookahead;
	self.pathenemyFightdist = 128;
	self.pathenemyLookahead = 128;
	self.disableArrivals = true;
	disable_ai_color();
	self pushPlayer( true );
	fixedNodeWasOn = self.fixedNode;
	self.fixedNode = false;
	
	
	
	self.goalradius = 0;
	self waittill( "goal" );
	self.disableArrivals = undefined;
	self pushPlayer( false );
	self.fixedNode = fixedNodeWasOn;


	ent notify( "reach_notify" );
	self notify( "anim_reach_complete" );
	self.pathenemyFightdist = self.oldpathenemyFightdist;
	self.pathenemyLookahead = self.oldpathenemyLookahead;
}

/#
printloops( guy, anime )
{

	if( !isdefined( guy ) )
		return;

	guy endon( "death" ); 
	waittillframeend; 
	                  
	guy.loops++;
	if( guy.loops > 1 )
		assertMsg( "guy with name "+ guy.animname+ " has "+ guy.loops+ " looping animations played, anime: "+ anime );
}

looping_anim_ender( guy, ender )
{
	guy endon( "death" );
	self waittill( ender );
	guy.loops--;
}
#/

get_animtree( guy )
{
	for( i=0;i<guy.size;i++ )
		guy[ i ] UseAnimTree( level.scr_animtree[ guy[ i ].animname ] );
}

SetAnimTree()
{
	self UseAnimTree( level.scr_animtree[ self.animname ] );
}

anim_single_solo( guy, anime, tag, entity, tag_entity )
{
	if( isdefined( tag_entity ) )
	{
		entity = tag_entity;
	}
	
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_single( newguy, anime, tag, entity );
}

anim_reach_and_idle_solo( guy, anime, anime_idle, ender, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_reach_and_idle( newguy, anime, anime_idle, ender, tag, node, tag_entity );
}

anim_reach_solo( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_reach( newguy, anime, tag, node, tag_entity );
}

anim_reach_and_approach_solo( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	newguy[ 0 ] thread enable_arrivals();
	anim_reach( newguy, anime, tag, node, tag_entity );
}

anim_reach_and_approach( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	array_thread( guy, ::enable_arrivals );
	anim_reach( guy, anime, tag, node, tag_entity );
}

enable_arrivals()
{
	self endon( "death" );
	
	waittillframeend;
	self.disableArrivals = undefined;
}


anim_loop_solo( guy, anime, tag, ender, entity )
{
	self endon( "death" );
	guy endon( "death" );

	newguy[ 0 ] = guy;
	anim_loop( newguy, anime, tag, ender, entity );
}

anim_teleport_solo( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );
	
	newguy[ 0 ] = guy;
	anim_teleport( newguy, anime, tag, node, tag_entity );
}

anim_single_solo_debug( guy, anime, tag, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_single_debug( newguy, anime, tag, node, tag_entity );
}

anim_loop_solo_debug( guy, anime, tag, ender, node, tag_entity )
{
	self endon( "death" );

	newguy[ 0 ] = guy;
	anim_loop_debug( newguy, anime, tag, ender, node, tag_entity );
}

anim_loop_debug( guy, anime, tag, ender, node, tag_entity )
{
	
	
	
	
	
	
	
	for( i=0;i<guy.size;i++ )
	{
		if( isdefined( guy[ i ] ) )
			continue;
			
	
	}
	
	if( isdefined( tag ) )
	{
		if( isdefined( tag_entity ) )
		{
			org = tag_entity gettagOrigin( tag );
			angles = tag_entity gettagAngles( tag );
		}
		else
		{
			org = self gettagOrigin( tag );
			angles = self gettagAngles( tag );
		}
	}
	else
	if( isdefined( node ) )
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	if( !isdefined( angles ) )
		println( "No ANGLES, misspelled node?" );
	anim_loop( guy, anime, tag, ender, node, tag_entity );
}

anim_single_debug( guy, anime, tag, node, tag_entity )
{
	
	
	
	
	
	
	for( i=0;i<guy.size;i++ )
	{
		if( isdefined( guy[ i ] ) )
			continue;
			
	
	}
	
	if( isdefined( tag ) )
	{
		if( isdefined( tag_entity ) )
		{
			org = tag_entity gettagOrigin( tag );
			angles = tag_entity gettagAngles( tag );
		}
		else
		{
			org = self gettagOrigin( tag );
			angles = self gettagAngles( tag );
		}
	}
	else
	if( isdefined( node ) )
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	if( !isdefined( angles ) )
		println( "No ANGLES, misspelled node?" );
	anim_single( guy, anime, tag, node, tag_entity );
}

add_animation( animname, anime )
{
	if( !isdefined( level.completedAnims ) )
		level.completedAnims[ animname ][ 0 ] = anime;
	else
	{
		if( !isdefined( level.completedAnims[ animname ] ) )
			level.completedAnims[ animname ][ 0 ] = anime;
		else
		{
			for( i=0;i<level.completedAnims[ animname ].size;i++ )
			{
				if( level.completedAnims[ animname ][ i ] == anime )
					return;
			}
			
			level.completedAnims[ animname ][ level.completedAnims[ animname ].size ] = anime;
		}
	}
}

anim_single_queue( guy, anime, tag, node, tag_entity )
{
	
	thread anim_single_queue_thread( guy, anime, tag, node, tag_entity );

	for( ;; )
	{
		if( !isdefined( self._anim_solo_queue ) )
			break;
			
		self waittill( "finished anim solo" );
	}
}



anim_single_queue_thread( guy, anime, tag, node, tag_entity )
{
	queueTime = gettime();
	while( 1 )
	{
		if( !isdefined( self._anim_solo_queue ) )
			break;
			
		self waittill( "finished anim solo" );
		if( gettime() > queueTime + 5000 )
			return;
	}

	self._anim_solo_queue = true;	
	newguy[ 0 ] = guy;
	anim_single( newguy, anime, tag, node, tag_entity );
	self._anim_solo_queue = undefined;
	self notify( "finished anim solo" );
}

anim_dontPushPlayer( guy )
{
	for( i=0;i<guy.size;i++ )
	{
		guy[ i ] pushPlayer( false );
	}
}

anim_pushPlayer( guy )
{
	for( i=0;i<guy.size;i++ )
	{
		guy[ i ] pushPlayer( true );
	}
}

addNotetrack_dialogue( animname, notetrack, anime, soundalias )
{
	num = 0;
	if( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "dialog" ]		= soundalias;
	level.scr_notetrack[ animname ][ num ][ "anime" ]			= anime;
}

removeNotetrack_dialogue( animname, notetrack, anime, soundalias )
{
	assertex( isdefined( level.scr_notetrack[ animname ] ), "Animname not found in scr_notetrack." );

	tmp_array = [];

	for( i=0; i < level.scr_notetrack[ animname ].size; i++ )
	{
		if( level.scr_notetrack[ animname ][ i ][ "notetrack" ] == notetrack )
		{
			dialog = level.scr_notetrack[ animname ][ i ][ "dialog" ];
			if( !isdefined( dialog ) )
				dialog = level.scr_notetrack[ animname ][ i ][ "dialogue" ];

			if( isdefined( dialog ) && dialog == soundalias )
			{
				if( isdefined( anime ) && isdefined( level.scr_notetrack[ animname ][ i ][ "anime" ] ) )
				{
					if( level.scr_notetrack[ animname ][ i ][ "anime" ] == anime )
						continue;
				}
				else
					continue;
			}
		}

		num = tmp_array.size;
		tmp_array[ num ] = level.scr_notetrack[ animname ][ i ];
	}

	assertex( tmp_array.size < level.scr_notetrack[ animname ].size, "Notetrack not found." );

	level.scr_notetrack[ animname ] = tmp_array;
}

addNotetrack_sound( animname, notetrack, anime, soundalias )
{
	num = 0;
	if( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "sound" ]			= soundalias;

	if( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	= anime;
	
	
}

addOnStart_animSound( animname, anime, soundalias )
{
	
	if( !isdefined( level.scr_animSound[ animname ] ) )
		level.scr_animSound[ animname ] = [];

	level.scr_animSound[ animname ][ anime ] = soundalias;
}

addNotetrack_animSound( animname, anime, notetrack, soundalias )
{
	
	if( !isdefined( level.scr_notetrack[ animname ] ) )
		level.scr_notetrack[ animname ] = [];

	array = [];	
	array[ "notetrack" ] = notetrack;
	array[ "sound" ] = soundalias;
	array[ "created_by_animSound" ] = true;
	array[ "anime" ] = anime;
	
	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = array;
}

addNotetrack_attach( animname, notetrack, model, tag, anime )
{
	num = 0;
	if( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "attach model" ]	= model;
	level.scr_notetrack[ animname ][ num ][ "selftag" ]		= tag;
	
	if( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	= anime;
}

addNotetrack_detach( animname, notetrack, model, tag, anime )
{
	num = 0;
	if( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "detach model" ]	= model;
	level.scr_notetrack[ animname ][ num ][ "selftag" ]		= tag;
	
	if( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	= anime;
}

addNotetrack_customFunction( animname, notetrack, function, anime )
{
	num = 0;
	if( isdefined( level.scr_notetrack[ animname ] ) )
		num = level.scr_notetrack[ animname ].size;
	
	level.scr_notetrack[ animname ][ num ][ "notetrack" ]		= notetrack;
	level.scr_notetrack[ animname ][ num ][ "function" ]		= function;
	
	if( !isdefined( anime ) )
	{
		anime = "any";
	}
	
	level.scr_notetrack[ animname ][ num ][ "anime" ]	= anime;
}

addNotetrack_flag( animname, notetrack, flag, anime )
{
	if( !isdefined( level.scr_notetrack[ animname ] ) )
	{
		level.scr_notetrack[ animname ] = [];
	}
	
	addNote = [];
	addNote[ "notetrack" ] = notetrack;
	addNote[ "flag" ] = flag;
	if( !isdefined( anime ) )
	{
		anime = "any";
	}
	addNote[ "anime" ] = anime;
		
	level.scr_notetrack[ animname ][ level.scr_notetrack[ animname ].size ] = addNote;
	
	if( !isdefined( level.flag[ flag ] ) )
	{
		flag_init( flag );
	}
}

#using_animtree( "generic_human" );

anim_look( guy, anime, array )
{








































}

anim_facialAnim( guy, anime, faceanim )
{
















}

anim_facialFiller( msg, lookTarget )
{


















































}

GetYawAngles( angles1, angles2 )
{
	yaw = angles1[ 1 ] - angles2[ 1 ];
	yaw = AngleClamp180( yaw );
	return yaw;
}

chatAtTarget( msg, lookTarget )
{










































































}

lookRecenter( msg )
{
	










}

lookLine( org, msg )
{
	self notify( "lookline" );
	self endon( "lookline" );
	self endon( msg );
	self endon( "death" );
	for( ;; )
	{
		line( self geteye(), org +( 0, 0, 60 ), ( 1, 1, 0 ), 1 );
		wait( 0.05 );
	}
}

anim_reach_idle( guy, anime, idle )
{
	
	
	ent = spawnstruct();
	ent.count = guy.size;
	for( i=0;i<guy.size;i++ )
		thread reachIdle( guy[ i ], anime, idle, ent );
	while( ent.count )
		ent waittill( "reached_goal" );

	self notify( "stopReachIdle" );
}

reachIdle( guy, anime, idle, ent )
{
	anim_reach_solo( guy, anime );
	ent.count--;
	ent notify( "reached_goal" );
	if( ent.count > 0 )
		anim_loop_solo( guy, idle, undefined, "stopReachIdle" );
}

delayedDialogue( anime, doAnimation, dialogue, animationName )
{
	assertEx( animhasnotetrack( animationName, "dialog" ), "Animation " + anime + " does not have a dialog notetrack." );
	
	self waittillmatch( "face_done_" + anime, "dialog" );
	if( doAnimation )
		self SaySpecificDialogue( undefined, dialogue, 1.0 );
	else
		self SaySpecificDialogue( undefined, dialogue, 1.0, "single dialogue" );
}

clearFaceAnimOnAnimdone( guy, msg, anime )
{







}

anim_single_solo_delayed( delay, guy, anime, tag, node, tag_entity )
{
	wait( delay );
	anim_single_solo( guy, anime, tag, node, tag_entity );
}

queue_anim( anime, node, tag, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );
	if( isdefined( tag ) || isdefined( entity ) )
	{
		queue_anim_single_solo_with_reach( self, anime, tag, entity );
		return;
	}
	
	
	queue_anim_single_solo( self, anime );
}

queue_anim_single_solo_with_reach( guy, anime, tag, node, tag_entity )
{
	entity = convert_tagent_to_ent( node, tag_entity );

	animePacket = spawnstruct();
	animePacket.reach = true;
	animePacket process_queue_packet( guy, anime, tag, entity );
}

queue_anim_single_solo( guy, anime )
{
	animePacket = spawnstruct();
	animePacket.reach = false;
	animePacket process_queue_packet( guy, anime );
}

process_queue_packet( guy, anime, tag, entity )
{
	guy endon( "death" );
	self.guy = guy;
	self.anime = anime;
	self.tag = tag;
	self.entity = entity;
	self.anime_base = self.guy;
	
	
	
	if( isdefined( entity ) )
		self.anime_base = entity;
		
	
	if( !isdefined( guy.anime_queue ) )
		guy.anime_queue = [];

	guy.anime_queue[ guy.anime_queue.size ] = self;
	
	for( ;; )
	{
		if( guy.anime_queue[ 0 ] != self )
		{
			guy waittill( "finished_queued_animation" );
			continue;
		}
		
		packet = guy.anime_queue[ 0 ];

		lastBattleChatter = packet.guy.battlechatter;
		packet.guy set_battleChatter( false );
		if( packet.reach )
			packet.anime_base anim_reach_solo( packet.guy, packet.anime, packet.tag, packet.entity );
	
		packet.anime_base anim_single_solo( packet.guy, packet.anime, packet.tag, packet.entity );

		packet.guy set_battleChatter( lastBattleChatter );


		
		newQueue = [];
		for( i=1; i < guy.anime_queue.size; i++ )
		{
			newQueue[ newQueue.size ] = guy.anime_queue[ i ];
		}
		
		guy.anime_queue = newQueue;

		if( guy.anime_queue.size <= 0 )
		{
			guy notify( "finished_queued_animation" );
			guy.anime_queue = undefined;
			return;
		}

		wait( 1 ); 
		guy notify( "finished_queued_animation" );
		break;
	}
}

waittill_empty_queue()
{
	self endon( "death" );
	if( !isdefined( self.anim_queue ) )
		return;
		
	for( ;; )
	{
		if( self.anime_queue.size <= 0 )
			return;
			
		self waittill( "finished_queued_animation" );
	}
}

anim_start_pos( guyArray, anime, tag, entity )
{
	pos = get_anim_position( tag, entity );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];
	
	array_thread( guyArray, ::set_start_pos, anime, org, angles );
}

anim_start_pos_solo( guy, anime, tag, entity )
{
	newguy[ 0 ] = guy;
	anim_start_pos( newguy, anime, tag, entity );
}

set_start_pos( anime, org, angles )
{
	if( isSentient( self ) )
	{
		neworg = getstartOrigin( org, angles, level.scr_anim[ self.animname ][ anime ] );
		newangles = getstartAngles( org, angles, level.scr_anim[ self.animname ][ anime ] );
		self teleport( neworg, newangles );
	}
	else
	{
		self.origin = getstartOrigin( org, angles, level.scr_anim[ self.animname ][ anime ] );
		self.angles = getstartAngles( org, angles, level.scr_anim[ self.animname ][ anime ] );
	}
}


anim_at_self( entity, tag )
{
	packet = [];
	packet[ "guy" ] = self;
	packet[ "entity" ] = self;
	return packet;
}

anim_at_entity( entity, tag )
{
	packet = [];
	packet[ "guy" ] = self;
	packet[ "entity" ] = entity;
	packet[ "tag" ] = tag;
	return packet;
}

add_to_animsound()
{
	if( !isdefined( self.animSounds ) )
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
