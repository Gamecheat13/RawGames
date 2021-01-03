#using scripts\shared\math_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

// face.gsc
// Supposed to handle all facial and dialogue animations from regular scripts.
//#using_animtree ("generic_human"); - This file doesn't call animations directly.


function SayGenericDialogue(typeString)
{

	if (level.disableGenericDialog)
	{
		return;
	}
	
	switch (typeString)
	{
	case "attack":
		importance = 0.5;
		break;
	case "swing":
		importance = 0.5;
		typeString = "attack";
		break;
	case "flashbang":
		importance = 0.7;
		break;
	case "pain_small":
		importance = 0.4;
		break;
	case "pain_bullet":
		wait(.01); //make sure dialog system has had a chance to deal with death before we play another line.
		importance = 0.4;
		break;
	default:
		/#println ("Unexpected generic dialog string: "+typeString);#/
		importance = 0.3;
		break;
	}

	SayGenericDialogueWithImportance(typeString, importance);

}

// Makes a character say the specified line in his voice, if he's not already saying something more 
// important.  
function SayGenericDialogueWithImportance(typeString, importance)
{
	soundAlias = "dds_";

	if( isdefined( self.dds_characterID ) )
	{
		soundAlias += self.dds_characterID;
	}
	else
	{
		/#printLn( "this AI does not have a dds_characterID" );#/
		return;
	}

	soundAlias += "_" + typeString;

	if(SoundExists(soundAlias))
	{
		self thread PlayFaceThread (undefined, soundAlias, importance);
	}
}

function SetIdleFaceDelayed(facialAnimationArray)
{
	self.a.idleFace = facialAnimationArray;
}

// Sets the facial expression to return to when not saying dialogue.
// The array is animation1, weight1, animation2, weight2, etc.  The animations will play in turn - each time 
// one finishes a new one will be chosen randomly based on weight.
function SetIdleFace(facialAnimationArray)
{
	if (!anim.useFacialAnims)
	{
		return;
	}

	self.a.idleFace = facialAnimationArray;
	self PlayIdleFace();
}

// Makes the character play the specified sound and animation.  The anim and the sound are optional - you 
// can just defined one if you don't have both.
// Generally, importance should be in the range of 0.6-0.8 for scripted dialogue.
// Importance is a float, from 0 to 1.  
// 0.0 - Idle expressions
// 0.1-0.5 - most generic dialogue
// 0.6-0.8 - most scripted dialogue 
// 0.9 - pain
// 1.0 - death
// Importance can also be one of these strings: "any", "pain" or "death", which specfies what sounds can 
// interrupt this one.
function SaySpecificDialogue(facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait, toplayer)
{
	///("SaySpecificDialog, facial: ",facialanim,", sound: ",soundAlias,", importance: "+importance+", notify: ",notifyString, ", WaitOrNot: ", waitOrNot, ", timeToWait: ", timeToWait);#/
	self thread PlayFaceThread(facialanim, soundAlias, importance, notifyString, waitOrNot, timeToWait, toplayer);
}

// DEAD CODE REMOVAL 
// Takes an array with a set of "anim" entries and a corresponding set of "weight" entries.
//ChooseAnimFromSet( animSet )
//{
//	return;	// Facial animations are now part of full body aniamtions
/*
	if (!anim.useFacialAnims)
		return;
	// First, normalize the weights.
	totalWeight = 0;
	numAnims = animSet["anim"].size;
	for ( i=0 ; i<numAnims ; i++ )
	{
		totalWeight += animSet["weight"][i];
	}
	for ( i=0 ; i<numAnims ; i++ )
	{
		animSet["weight"][i] = animSet["weight"][i] / totalWeight;
	}

	// Now choose an animation.
	rand = RandomFloat(1);
	runningTotal = 0;
	chosenAnim = undefined;
	for ( i=0 ; i<numAnims ; i++ )
	{
		runningTotal += animSet["weight"][i];
		if (runningTotal >= rand)
		{
			chosenAnim = i;
			break;
		}
	}
	assert(isdefined(chosenAnim), "Logic error in ChooseAnimFromSet.  Rand is " + rand + ".");
	return animSet["anim"][chosenAnim];
*/
//}



//-----------------------------------------------------
// Housekeeping functions - these are for internal use
//-----------------------------------------------------

// PlayIdleFace doesn't force an idle animation to play - it will interrupt a current idle animation, but it 
// won't play over a more important animation, like dialogue.
function PlayIdleFace()
{
	return;	// Idle facial animations are now in the full-body animations.
}

// PlayFaceThread is the workhorse of the system - it checks the importance, and if it's high enough, it
// plays the animation and/or sound specified.
// The waitOrNot parameter specifies what to do if another animation/sound is already playing.
// Options: "wait" or undefined.  TimeToWait is an optional timeout time for waiting.
// Waiting faces are queued.
function PlayFaceThread( facialanim, str_script_alias, importance, notifyString, waitOrNot, timeToWait, toplayer )
{
	//NOTE most of the described functionality was removed in COD2 (!)
	//Talk about misleading comments...
	//This must be called in it's own thread.
	//
	//The behavior has been simplifed greatly
	//  lines never wait
	//  a line stops the current line if at equal or higher priority
	//  a line doesn't play if at lower priority
	//SBM 8/3/08
	
	self endon( "death" );
		
	if ( !isdefined( str_script_alias ) )
	{
		wait 1;
		self notify( notifyString );
		return; //no sound, don't do anything facials are now included into the main anims
	}
	
	str_notify_alias = str_script_alias; // Save this off because the script alias gets changed for females
	
	if(!isdefined(level.NumberOfImportantPeopleTalking))level.NumberOfImportantPeopleTalking=0;
	if(!isdefined(level.TalkNotifySeed))level.TalkNotifySeed=0;
	if(!isdefined(notifyString))notifyString="PlayFaceThread " + str_script_alias;
	if(!isdefined(self.a))self.a=SpawnStruct();
	if(!isdefined(self.a.facialSoundDone))self.a.facialSoundDone=true;
	if(!isdefined(self.isTalking))self.isTalking=false;

	if ( self.isTalking ) //currently talking
	{
		//TUEY added equal to, so that the system won't spam the same notifies
		if ( IsDefined( self.a.currentDialogImportance ) )
		{
			if ( importance < self.a.currentDialogImportance )
			{
				wait 1;
				self notify( notifyString );
				return; //skip it cause its not important
			}
			else if ( importance == self.a.currentDialogImportance )
			{
				if ( self.a.facialSoundAlias == str_script_alias )
				{
					return; //playing same alias twice? probably a script error somewhere
				}
	
				/# println( "WARNING: delaying alias " + self.a.facialSoundAlias + " to play " + str_script_alias ); #/
	
				while ( self.isTalking ) //while is to fix a race condition
				{
					self waittill( "done speaking" ); //wait currently playing thread to finish
				}
			}
		}
		else
		{
			/# PrintLn("WARNING: interrupting alias "+self.a.facialSoundAlias+" to play "+str_script_alias); #/
			
			self StopSound( self.a.facialSoundAlias );
			self notify("cancel speaking");

			while ( self.isTalking ) //while is to fix a race condition
			{
				self waittill( "done speaking" ); //wait currently playing thread to finish
			}
		}
	}

	assert( self.a.facialSoundDone );
	assert( self.a.facialSoundAlias == undefined );
	assert( self.a.facialSoundNotify == undefined );
	assert( self.a.currentDialogImportance == undefined );
	assert( !self.isTalking );

	self.isTalking = true;
	self.a.facialSoundDone = false;
	self.a.facialSoundNotify = notifyString;
	self.a.facialSoundAlias = str_script_alias;
	self.a.currentDialogImportance = importance;

	if ( importance == 1.0 )
	{
		level.NumberOfImportantPeopleTalking += 1;
	}

	/#
		
	if ( level.NumberOfImportantPeopleTalking > 1 )
	{
		println( "WARNING: multiple high priority dialogs are happening at once " + str_script_alias );
	}
	
	#/
		
	uniqueNotify = notifyString + " " + level.TalkNotifySeed;

	level.TalkNotifySeed += 1;
	
	if ( isdefined( level.scr_sound ) && isdefined( level.scr_sound[ "generic" ] ) )
	{
		str_vox_file = level.scr_sound[ "generic" ][ str_script_alias ];
	}

	if ( isdefined( str_vox_file ) )
	{
		if ( SoundExists( str_vox_file ) )
		{
			if ( IsPlayer( toplayer ) )
			{
				self thread _play_sound_to_player_with_notify( str_vox_file, toplayer, uniqueNotify );
			}
			else if ( isdefined( self.type ) && self.type == "human" )
			{
				self PlaySoundWithNotify( str_vox_file, uniqueNotify, "J_Head" );
			}
			else
			{
				self PlaySoundWithNotify( str_vox_file, uniqueNotify );
			}
		}
		else
		{
			/#
				println( "Warning: " + str_script_alias + " does not exist" );
			#/
		}
	}
	else
	{
		self thread _temp_dialog( str_script_alias, uniqueNotify );
	}

	self util::waittill_any( "death", "cancel speaking", uniqueNotify );

	if ( importance == 1.0 )
	{
		level.NumberOfImportantPeopleTalking -= 1;
		level.ImportantPeopleTalkingTime = GetTime();
	}

	if ( isdefined( self ) )
	{
		self.isTalking = false;
		self.a.facialSoundDone = true;
		self.a.facialSoundNotify = undefined;
		self.a.facialSoundAlias = undefined;
		self.a.currentDialogImportance = undefined;
		self.lastSayTime = GetTime();
	}

	self notify( "done speaking", str_notify_alias );
	self notify( notifyString );
}

// HACK: there is no way to get a notify from a sound on a specific client.
// Even though SoundGetPlaybackTime isn't 100% and won't be accurate with locs,
// it's our best bet for now.
function _play_sound_to_player_with_notify( soundAlias, toplayer, uniqueNotify )
{
	self endon( "death" );
	toplayer endon( "death" );
	
	self PlaySoundToPlayer( soundAlias, toplayer );
	n_playbackTime = SoundGetPlaybackTime( soundAlias );
	
	if ( n_playbackTime > 0 )
	{
		wait n_playbackTime * .001;
	}
	else
	{
		wait 1.0;
	}
	
	self notify( uniqueNotify );
}

function private _temp_dialog( str_line, uniqueNotify )
{
	if ( isdefined( self.propername ) )
	{
		str_line = self.propername + ": " + str_line;
	}
	
	foreach	( player in level.players )
	{
		if ( !isdefined( player GetLUIMenu( "TempDialog" ) ) )
		{
			player OpenLuiMenu( "TempDialog" );
		}
		
		player SetLuiMenuData( player GetLUIMenu( "TempDialog" ), "dialogText", str_line );
	}
	
	// wait time based on average words spoken (2 per second) and capped at 5 seconds total, -1 for propername
	n_wait_time = ( StrTok( str_line, " ").size - 1 ) / 2;
	n_wait_time = math::clamp( n_wait_time, 2, 5);
	util::waittill_any_timeout( n_wait_time, "death", "cancel speaking" );
	
	foreach	( player in level.players )
	{
		if ( isdefined( player GetLUIMenu( "TempDialog" ) ) )
		{
			player CloseLUIMenu( player GetLUIMenu( "TempDialog" ) );
		}
	}
	
	self notify( uniqueNotify );
}

function PlayFace_WaitForNotify(waitForString, notifyString, killmeString)
{
	self endon ("death");
	self endon (killmeString);
	self waittill (waitForString);
	self.a.faceWaitForResult = "notify";
	self notify (notifyString);
}

function PlayFace_WaitForTime(time, notifyString, killmeString)
{
	self endon ("death");
	self endon (killmeString);
	wait (time);
	self.a.faceWaitForResult = "time";
	self notify (notifyString);
}

