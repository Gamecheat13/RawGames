#include maps\_utility;
#include maps\_anim;

/* Supports multiple lines in facial animation tagged with "dialogue_line" */
multiple_dialogue_queue( scene )
{
	bcs_scripted_dialogue_start();

	AssertEx( IsDefined( scene ), "Tried to do multiple_dialogue_queue without passing a scene name" );

	if ( IsDefined( self.last_queue_time ) )
	{
		wait_for_buffer_time_to_pass( self.last_queue_time, 0.5 );
	}
	
	guys = [];
	guys[0] = [ self, 0 ];

	function_stack( maps\_shg_anim::anim_single_end_early, guys, scene );

	if ( IsAlive( self ) )
		self.last_queue_time = GetTime();
}

/*
	This version of anim_single allows animations of different entities to end at different times.  It will only
	  return when all animations are finished playing.  It will also notify each entity of "anim_ended" when their 
	  animation has completed.

	guys_structs - pass in an array of pairs.  The pair's first item is the entity to animate, the second item is how much time
	                 to end the entity's animation early by.  0 being to play the animation fully.
	anime - animation scene name
	tag - the tag on self to play the animation relative to
*/
anim_single_end_early( guys_structs, anime, tag )
{
	entity = self;

	guys = [];
	foreach ( i, guy_struct in guys_structs )
	{
		guys[ i ] = guy_struct[0];
	}

	/#
	thread anim_single_failsafe( guys, anime );
	#/
	// disable BCS if we're doing a scripted sequence.
	foreach ( guy in guys )
	{
		if ( !isdefined( guy ) )
			continue;
		if ( !isdefined( guy._animActive ) )
			guy._animActive = 0;// script models cant get their animactive set by init
		guy._animActive++;
	}

	pos = get_anim_position( tag );
	org = pos[ "origin" ];
	angles = pos[ "angles" ];

	anim_string = "single anim";

	ent = SpawnStruct();
	waittills = 0;
	foreach ( i, guy in guys )
	{
		doFacialanim = false;
		doDialogue = false;
		doAnimation = false;
		doText = false;

		dialogue = undefined;
		facialAnim = undefined;

		animname = guy.animname;

		/#
		guy assert_existance_of_anim( anime, animname );
		#/

		if ( ( IsDefined( level.scr_face[ animname ] ) ) &&
			( IsDefined( level.scr_face[ animname ][ anime ] ) ) )
		{
			doFacialanim = true;
			facialAnim = level.scr_face[ animname ][ anime ];
		}

		if ( ( IsDefined( level.scr_sound[ animname ] ) ) &&
			( IsDefined( level.scr_sound[ animname ][ anime ] ) ) )
		{
			doDialogue = true;
			dialogue = level.scr_sound[ animname ][ anime ];
		}

		if ( ( IsDefined( level.scr_anim[ animname ] ) ) &&
			( IsDefined( level.scr_anim[ animname ][ anime ] ) ) &&
			( !isAI( guy ) || !guy doingLongDeath() ) )
			doAnimation = true;

		if ( IsDefined( level.scr_animSound[ animname ] ) &&
			 IsDefined( level.scr_animSound[ animname ][ anime ] ) )
		{
			guy PlaySound( level.scr_animSound[ animname ][ anime ] );
		}

		/#
		if ( GetDebugDvar( "animsound" ) == "on" )
		{
			guy thread animsound_start_tracker( anime, animname );
		}
		#/


		/#
		if ( ( IsDefined( level.scr_text[ animname ] ) ) &&
			( IsDefined( level.scr_text[ animname ][ anime ] ) ) )
			doText = true;
		#/

		if ( doAnimation )
		{
			guy last_anim_time_check();
			if ( isPlayer( guy ) )
			{
//				guy ForceTeleport( org, angles );

				root_animation = level.scr_anim[ animname ][ "root" ];
				guy SetAnim( root_animation, 0, 0.2 );

				animation = level.scr_anim[ animname ][ anime ];
				guy SetFlaggedAnim( anim_string, animation, 1, 0.2 );
				
			}
			else
			if ( guy.code_classname == "misc_turret" )
			{
				animation = level.scr_anim[ animname ][ anime ];
				guy SetFlaggedAnim( anim_string, animation, 1, 0.2 );
			}
			else
			{
				// ai and models use animscripted
				guy AnimScripted( anim_string, org, angles, level.scr_anim[ animname ][ anime ] );
			}
			
			thread start_notetrack_wait( guy, anim_string, anime, animname );
			thread animscriptDoNoteTracksThread( guy, anim_string, anime );
		}


		if ( ( doFacialanim ) || ( doDialogue ) )
		{
			if ( doFacialAnim )
			{
				if ( doDialogue )
					guy thread doFacialDialogue( anime, doFacialanim, dialogue, level.scr_face[ animname ][ anime ] );
				AssertEx( !doanimation, "Can't play a facial anim and fullbody anim at the same time. The facial anim should be in the full body anim. Occurred on animation " + anime );
				thread anim_facialAnim( guy, anime, level.scr_face[ animname ][ anime ] );
			}
			else
			{
				/#
				println("**dialog alias playing locally: " + dialogue );
				#/
			
				if ( IsAI( guy ) )
				{
					if ( doAnimation )
						guy animscripts\face::SaySpecificDialogue( facialAnim, dialogue, 1.0 );
					else
					{
						guy thread anim_facialFiller( "single dialogue" );
						guy animscripts\face::SaySpecificDialogue( facialAnim, dialogue, 1.0, "single dialogue" );
					}
				}
				else
				{
					guy thread play_sound_on_entity( dialogue, "single dialogue" );
				}
			}
		}
		AssertEx( doAnimation || doFacialanim || doDialogue || doText, "Tried to do anim scene " + anime + " on guy with animname " + animname + ", but he didn't have that anim scene." );

		/#
		if ( doText && !doDialogue )
		{
			IPrintLnBold( level.scr_text[ animname ][ anime ] );
			wait 1.5;
		}
		#/
		
		if ( doAnimation )
		{
			animtime = GetAnimLength( level.scr_anim[ animname ][ anime ] );
			ent thread anim_end_early_deathNotify( guy, anime );
			ent thread anim_end_early_animationEndNotify( guy, anime, animtime, guys_structs[ i ][ 1 ] );
			waittills++;
		}
		else if ( doFacialAnim )
		{
			ent thread anim_end_early_deathNotify( guy, anime );
			ent thread anim_end_early_facialEndNotify( guy, anime, facialAnim );
			waittills++;
		}
		else if ( doDialogue )
		{
			ent thread anim_end_early_deathNotify( guy, anime );
			ent thread anim_end_early_dialogueEndNotify( guy, anime );
			waittills++;
		}
	}

	while ( waittills > 0 )
	{
		ent waittill( anime, guy );
		waittills--;
		
		if ( !isdefined( guy ) )
			continue;
		
		if ( isPlayer( guy ) )
		{	
			animname = guy.animname;

			// is there an animation?
			if ( isdefined( level.scr_anim[ animname ][ anime ] ) )
			{
				root_animation = level.scr_anim[ animname ][ "root" ];
				guy setanim( root_animation, 1, 0.2 );

				animation = level.scr_anim[ animname ][ anime ];
				guy ClearAnim( animation, 0.2 );
			}
		}

		guy._animActive--;
		guy._lastAnimTime = GetTime();
		Assert( guy._animactive >= 0 );
	}

	self notify( anime );
}

anim_end_early_deathNotify( guy, anime )
{
	guy endon( "kill_anim_end_notify_" + anime );
	guy waittill( "death" );
	self notify( anime, guy );
	guy notify( "kill_anim_end_notify_" + anime );
}

anim_end_early_facialEndNotify( guy, anime, scriptedFaceAnim )
{
	guy endon( "kill_anim_end_notify_" + anime );
	time = getanimlength( scriptedFaceAnim );
	wait( time );
//	guy waittillmatch( "face_done_" + anime, "end" );
	self notify( anime, guy );
	guy notify( "kill_anim_end_notify_" + anime );
}

anim_end_early_dialogueEndNotify( guy, anime )
{
	guy endon( "kill_anim_end_notify_" + anime );
	guy waittill( "single dialogue" );
	self notify( anime, guy );
	guy notify( "kill_anim_end_notify_" + anime );
}

anim_end_early_animationEndNotify( guy, anime, animationTime, anim_end_time )
{
	guy endon( "kill_anim_end_notify_" + anime );
	animationTime -= anim_end_time;
	if ( anim_end_time > 0 && animationTime > 0 )
	{
		guy waittill_match_or_timeout( "single anim", "end", animationTime );
		guy StopAnimScripted();
	}
	else
	{
		guy waittillmatch( "single anim", "end" );
	}
	
	guy notify( "anim_ended" );
	self notify( anime, guy );
	guy notify( "kill_anim_end_notify_" + anime );
}

doFacialDialogue( anime, doAnimation, dialogue, animationName )
{
	if ( doAnimation )
	{
		AssertEx( AnimHasNotetrack( animationName, "dialogue_line" ), "animation is missing expected dialogue_line notetrack" );
		
		self thread notify_facial_anim_end( anime );
		self thread warn_facial_dialogue_unspoken( anime );
		self thread warn_facial_dialogue_too_many( anime );
		
		dialogue_lines = [];
		if ( !IsArray( dialogue ) )
		{
			dialogue_lines[0] = dialogue;
		}
		else
		{
			dialogue_lines = dialogue;
		}

		foreach ( dialogue_line in dialogue_lines )
		{
			// not using priming.  just add VO line to RAM in order to sync to anim
			//self thread aud_prime_stream( dialogue_line );
			self waittillmatch( "face_done_" + anime, "dialogue_line" );
			//AssertEx( self aud_is_stream_primed( dialogue_line ), "dialogue line was not primed!" );
			/#
			println("**dialog alias playing locally: " + dialogue_line );
			#/
			self animscripts\face::SaySpecificDialogue( undefined, dialogue_line, 1.0 );
		}
		
		self notify( "all_facial_lines_done" );
	}
	else
	{
		self animscripts\face::SaySpecificDialogue( undefined, dialogue, 1.0, "single dialogue" );
	}
}

notify_facial_anim_end( anime )
{
	self endon( "death" );
	self waittillmatch( "face_done_" + anime, "end" );
	self notify( "facial_anim_end_" + anime );
}

warn_facial_dialogue_unspoken( anime )
{
	self endon( "death" );
	self endon( "all_facial_lines_done" );
	self waittill( "facial_anim_end_" + anime );
	AssertEx( false, "Lines did not finish playing. Not enough notetracks in facial animation or too many lines in dialogue array." );
}

warn_facial_dialogue_too_many( anime )
{
	self endon( "death" );
	self endon( "facial_anim_end_" + anime );
	self waittill( "all_facial_lines_done" );
	self waittillmatch( "face_done_" + anime, "dialogue_line" );
	AssertEx( false, "Too many notetracks in facial animation or not enough lines in dialogue array." );
}
