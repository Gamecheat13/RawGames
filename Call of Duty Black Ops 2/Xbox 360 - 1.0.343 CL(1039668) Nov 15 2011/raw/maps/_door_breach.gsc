/*
_DOOR_BREACH.GSC


	*======TO USE:======*
	be sure to include common_door_breach.csv in the level's csv file.

	make a call to maps/_door_breach::door_breach_init(); in your main function, after calling maps\_load::main()
	
	In Radiant:
	Right Click in the 2D window --> misc --> prefab.  
	Navigate to _prefabs/door_breach
	Select the door that you want to use
		Hinged is your standard door, bash through it with your shoulder
		Lift is a roll-top style where the player lifts the door up.
		Slide is a door you slide to one side (currently, to the left)
	Place the door where it is needed.
	If you want to replace the door model:
		First, place the prefab where you want it. 
		Stamp the prefab in
		Delete the old door and put into it's place the door you'd like to use
		take the scipt_node that was in the prefab and make sure it targets the new door
			Make sure the node is 16 units away from the new door you add.
*/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\utility;
#include animscripts\debug;

///////////////////////////////////////////////
// Needs to be called in the level script's 
//	main function
///////////////////////////////////////////////
door_breach_init(model,int_model)
{
	door_breach_load_player_anims();
	door_breach_load_door_anims();
	door_breach_load_fx();
	
	if(!IsDefined(model))
	{
		model = level.player_interactive_hands;
	}

	door_breach_set_viewmodel(model);
	
	if(!isDefined(int_model))
	{
		int_model = level.player_interactive_model;
	}
	
	door_breach_set_interactive_model(int_model);
	
	// SUMEET - Added a flag that tells the level when player is about to start the door breach animation
	flag_init("player_breaching");
	
	flag_wait("all_players_connected");
	
	door_breach_init_triggers();
	
	door_breach_init_gunnable_doors();
}


///////////////////////////////////////////////
// Load all FX used in door breach animations
///////////////////////////////////////////////
door_breach_load_fx()
{
	// Effects
	level._effect["hinge_door_bash"] 		= loadfx("destructibles/fx_feature_door_break_reg");	
	level._effect["slide_door_breach"]	= loadfx("destructibles/fx_feature_door_sliding_reg");	
	level._effect["lift_door_breach"]		= loadfx("destructibles/fx_feature_door_lift_reg");	
	
	precacherumble( "grenade_rumble" );
}



///////////////////////////////////////////////
// Grabs all triggers in the level and prepares
//	them for breaching
///////////////////////////////////////////////
door_breach_init_triggers()
{
	trigs = getentarray("trig_hinge_door", "script_noteworthy");
	array_thread(trigs, ::hinge_door_open);
	
	trigs_slide = getentarray("trig_slide_door", "script_noteworthy");
	array_thread(trigs_slide, ::slide_door_open);
	
	trigs_rolltop = getentarray("trig_rolltop_door", "script_noteworthy");	
	array_thread(trigs_rolltop, ::rolltop_door_open);	
	
	//sholmes door kick test 12.18.09
	trigs_kick =  getentarray("trig_kick_door", "script_noteworthy");	 
	array_thread(trigs_kick, ::kick_door_open);	
	
	// set the doors to be openable
	trigs = array_combine(trigs, trigs_slide);
	trigs = array_combine(trigs, trigs_rolltop);
	
	//sholmes door kick test 12.18.09
	trigs = array_combine(trigs, trigs_kick);
	
	
	for(i = 0; i < trigs.size; i++)
	{
		trigs[i] door_breach_trigger_on();
		door = trigs[i] door_breach_get_door_from_trig();
		door disconnectpaths();
		
		door.originalAngles = door.angles;
		door.originalOrigin = door.origin;
	}
}



///////////////////////////////////////////////
// Sets doors up so a player could shoot the 
// 	lock off a door, then bash through it
///////////////////////////////////////////////
door_breach_init_gunnable_doors()
{
	trigs = getentarray("doorknob_dmg_trigger", "targetname");
	
	array_thread(trigs, ::doorknob_shoot_to_open);
	
	// link the doorknob to the door.  This might be a bit long
	for(i = 0; i < trigs.size; i ++)
	{
		knob = getent(trigs[i].target, "targetname");
		bashtrig = getent(knob.target, "targetname");
		lerpstruct = getstruct(bashtrig.target, "targetname");
		door = getent(lerpstruct.target, "targetname");
		
		knob linkto(door);
	}
	
}

doorknob_shoot_to_open()
{
	self waittill("trigger");
	
	knob = getent(self.target, "targetname");
	
	trig = getent(knob.target, "targetname");
	trig.knob_shot = true;
	
	// Delete the knob as a sign that the knob was shot off
	knob delete();
}



///////////////////////////////////////////////
// Initialize the printing of text when a 
// 	player is touching a trigger
///////////////////////////////////////////////
hint_string_print()
{
	players = get_players();
	
	array_thread(players, ::hint_text_while_in_trig, self);
}



///////////////////////////////////////////////
// Print text if a player is touching the 
//	trigger
///////////////////////////////////////////////
hint_text_while_in_trig(trig)
{
	//trig endon("breach_door_opened");
	self endon("disconnect");
	
	self thread destroy_prompt_on_open(trig);
	
	while( isdefined(trig) )
	{
		if( self istouching( trig ) && isdefined(trig.safe_to_print) && trig.safe_to_print )
		{
			self give_door_open_prompt(trig);
		}
		
		wait(.1);
	}
}



///////////////////////////////////////////////
// Remove the trig once the door has been
//	opened
///////////////////////////////////////////////
destroy_prompt_on_open(trig)
{
	trig waittill("breach_door_opened");
	screen_message_delete();
}



///////////////////////////////////////////////
// Create the hudelem to prompt the player on
//	opening the door
///////////////////////////////////////////////
give_door_open_prompt( trig )
{
	//trig endon("breach_door_opened");
	self endon("disconnect");
	
	self SetScriptHintString(&"SCRIPT_HINT_DOOR");
	
	while( self istouching(trig) && isdefined(trig.safe_to_print) && trig.safe_to_print )
	{
		wait(.1);
	}
	
	self SetScriptHintString("");
}

draw_tags( model )
{
	model endon( "willcleanup" );
/#
	while( isdefined( model ) )
	{
		wait( 0.1 );
		origin = model GetTagOrigin( "tag_player" );
		angles = model GetTagAngles( "tag_player" );
		scale = 10;
		fwd = VectorScale( VectorNormalize( AnglesToForward( angles ) ), scale );
		right = VectorScale( VectorNormalize( AnglesToRight( angles ) ), scale );
		up = VectorScale( VectorNormalize( AnglesToUp( angles ) ), scale );
		thread debugLine( origin, origin + fwd, ( 1, 0, 0 ), 1 );
		thread debugLine( origin, origin + right, ( 0, 1, 0 ), 1 );
		thread debugLine( origin, origin + up, ( 0, 0, 1 ), 1 );
	}
#/	
}

///////////////////////////////////////////////
// Wait for a player to approach the hinge
//	door and hit the prompt, then open it
///////////////////////////////////////////////
hinge_door_open()
{	
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();	
	
	self notify("door_opening");
	
	// lerp the player into the proper position
	//player StartCameraTween( 0.2 );
	player lerp_player_view_to_position(lerppos.origin, lerppos.angles, .05, 1);
	
	// Create the viewmodel hands
	player_hands = Spawn_anim_model( "door_breach_player_hands" );	
	player_hands.angles = player.angles;
	player_hands.origin = player.origin;
	
	//thread draw_tags( player_hands );
	
	player PlayerLinkToAbsolute( player_hands, player.door_link);
	player_hands SetVisibleToPlayer( player );
	player HideViewModel();
	
	// door animation
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	
	// player is breaching
	flag_set("player_breaching");

	door thread anim_ents( door, "door_breach_shoulder", undefined, "hinge_door");
	
	// Door fx
	//playfx(level._effect["hinge_door_bash"], lerppos.origin, lerppos.angles );	
	
	level thread temp_play_fx_late(lerppos);
	
	// player animation and sound
	player thread play_sound_on_entity("fly_door_breach_1p");
	player playeranimscriptevent( "breach_shoulder" ); 	//start the 3rd person anim	
	player_hands animscripted( "door_opened", player_hands.origin, player_hands.angles, level.scr_anim["door_breach_player_hands"]["door_breach_shoulder"]);
	
	player playrumbleonentity("grenade_rumble");
	player_hands waittillmatch("door_opened", "end");
	player_hands notify("willcleanup");
	
	// Clean up
	player_hands Delete();
	player Unlink();
	player ShowViewModel();
	player stopdoorbreach();
	
	player notify("door_breached");
	
	door unlink();
	door connectpaths();
	// player done breaching
	flag_clear("player_breaching");
	
	self notify("breach_door_opened");
	player notify("door_breached");
	waittillframeend;
	self trigger_off();
}

///////////////////////////////////////////////
// sholmes kick door test 12.18.09
// Wait for a player to approach the hinge
//	door and hit the prompt, then kick it open
///////////////////////////////////////////////
kick_door_open()
{	
	
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();	
	
	//get players current weapon
	currentweapon = player getcurrentweapon();
	//get model of that weapon
	weaponModel = GetWeaponModel(currentweapon); 
	
	self notify("door_opening");
	
	player StartCameraTween( 0.2 );
	player lerp_player_view_to_position(lerppos.origin, lerppos.angles, .05, 1);
	
	// Create the viewmodel hands
	
	//make sure the old way still works
	
	
	player_hands = spawn_anim_model("door_breach_player_body",(0,0,0));
		
	player_hands hide();
	player_hands.angles = player.angles;
	player_hands.origin = player.origin;
	
	//attach current weapon model to right hand of viewmodel hands
	player_hands Attach(weaponModel, "tag_weapon" ); 
	//hide tags to reflect current weapon state
	player_hands useweaponhidetags( currentweapon);

	//link player to body 
	player PlayerLinkTo( player_hands, "tag_player");
	player_hands SetVisibleToPlayer( player );
	
	//hide default hands/gun
	player HideViewModel();
	
	// door animation
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	

	// player is breaching
	flag_set("player_breaching");
	
	door thread anim_ents( door, "door_breach_kick", undefined, "kick_door");
	
	//sound and FX here	
	level thread door_kick_sound_and_fx(lerppos, player);
		
	//player playeranimscriptevent( "door_breach_kick" ); 	//start the 3rd person anim	
	player_hands animscripted( "door_opened", player_hands.origin, player_hands.angles, level.scr_anim["door_breach_player_hands"]["door_breach_kick"]);
	
	//need this wait to hide minor pop-in of body model.
	wait(.05);
	
	//show model now
	player_hands show();
	
	player thread rumble_delay(0.4, "grenade_rumble");

	player_hands waittillmatch("door_opened", "end");
	
	player_hands notify("willcleanup");
	
	// Clean up
	player_hands Delete();
	player Unlink();
	player ShowViewModel();
	player stopdoorbreach();
	
	door unlink();
	door connectpaths();
		
	// player done breaching
	flag_clear("player_breaching");
	
	self notify("kick_door_opened");
	player notify("door_breached");
	waittillframeend;
	self trigger_off();
}


///////////////////////////////////////////////
// Wait for a player to approach the sliding
//	door and hit the prompt, then open it
///////////////////////////////////////////////
slide_door_open()
{
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();		
	
	self notify("door_opening");
	
	// lerp the player into the proper position
	lerppos = getstruct(self.target, "targetname");
	
	org = GetStartOrigin( lerppos.origin, lerppos.angles, level.scr_anim["door_breach_player_hands"]["door_breach_slide"] );
	angles = GetStartAngles( lerppos.origin, lerppos.angles, level.scr_anim["door_breach_player_hands"]["door_breach_slide"] );	
	
	player lerp_player_view_to_position(org, angles, .05, 1);
	
	// Create the viewmodel hands
	player_hands = Spawn_anim_model( "door_breach_player_hands" );	
	
	player_hands.origin = org;
	player_hands.angles = angles; 	
	
	player PlayerLinkToAbsolute( player_hands, player.door_link);
	player_hands SetVisibleToPlayer( player );
	player HideViewModel();
	
	// door animation 
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	
		
	// player done breaching
	flag_set("player_breaching");
	
	door thread anim_ents( door, "door_breach_slide", undefined, "slide_door");

	// Door fx
	playfx(level._effect["slide_door_breach"], lerppos.origin, lerppos.angles );	

	// player animation and sound
	player thread play_sound_on_entity("fly_door_slide_3p");
	player playeranimscriptevent( "breach_slide" ); 	//start the 3rd person anim	
	player_hands animscripted( "door_opened", lerppos.origin, lerppos.angles, level.scr_anim["door_breach_player_hands"]["door_breach_slide"]);
	
	player_hands waittillmatch("door_opened", "end");	
	
	// Clean up
	player_hands Delete();
	player Unlink();
	player ShowViewModel();
	player stopdoorbreach();
		
	door unlink();
	door connectpaths();	
	// player done breaching
	player notify("door_breached");
	flag_clear("player_breaching");
		
	self trigger_off();	
	self notify("breach_door_opened");
}



///////////////////////////////////////////////
// Wait for a player to approach the roll top
//	door and hit the prompt, then open it
///////////////////////////////////////////////
rolltop_door_open()
{	
	lerppos = getstruct(self.target, "targetname");
	
	self thread hint_string_print();
	player = self door_breach_wait_for_button_pressed( lerppos );
	
	player startdoorbreach();		
	
	self notify("door_opening");
	
	// lerp the player into the proper position
	player lerp_player_view_to_position(lerppos.origin, lerppos.angles, .05, 1);
	
	// Create the viewmodel hands
	player_hands = Spawn_anim_model( "door_breach_player_hands" );	
	player_hands.angles = lerppos.angles;
	player_hands.origin = lerppos.origin;
	
	player PlayerLinkToAbsolute( player_hands, player.door_link);// , 1, 0, 0, 0, 0);
	player_hands SetVisibleToPlayer( player );
	player HideViewModel();
	
	// door animation
	door = getent(lerppos.target, "targetname");
	door.script_linkto = "origin_animate_jnt";
	
	
		
	// player done breaching
	flag_set("player_breaching");
		
	door thread anim_ents( door, "door_breach_rolltop", undefined, "rolltop_door");

	// Door fx
	playfx(level._effect["lift_door_breach"], lerppos.origin, lerppos.angles );	
	
	// player animation and sound
	player thread play_sound_on_entity("fly_roll_up_door_3p");
	player playeranimscriptevent( "breach_lift" ); 	//start the 3rd person anim	
	player_hands animscripted( "door_opened", player_hands.origin, player_hands.angles, level.scr_anim["door_breach_player_hands"]["door_breach_rolltop"]);
	
	player_hands waittillmatch("door_opened", "end");
	
	// Clean up
	player_hands Delete();
	player Unlink();
	player ShowViewmodel();
	player stopdoorbreach();

		
	door unlink();	
	door connectpaths();
	player notify("door_breached");
	// player done breaching
	flag_clear("player_breaching");
			
	self trigger_off();
	self notify("breach_door_opened");
}



///////////////////////////////////////////////
// Does a check to see if a player in the
//	trigger presses a button
///////////////////////////////////////////////
door_breach_wait_for_button_pressed( lerpstruct )
{
	waiting = true;
	player = undefined;
	
	while( waiting )
	{
		self waittill("trigger");
		
		wait(.05);
		players = get_players();
		
		if( isdefined( self.can_open ) && self.can_open == true )
		{
			for( i = 0; i < players.size; i++)
			{
				if( players[i] istouching(self) )
				{
					if( isdefined( self.knob_shot ) && self.knob_shot )
					{
						player = players[i];
						waiting = false;
					}
					else
					{
						// see if the player is looking towards the door
						dot = door_breach_get_player_struct_dot(players[i], lerpstruct);
						
						if( dot > 0)
						{
							self.safe_to_print = true;
							if( isdefined( self.shot_opened ) && self.shot_opened )
							{
								player = players[i];
								waiting = false;						
							}
							else if( players[i] use_button_held() )
							{
								player = players[i];
								player.door_link = "tag_origin";
								waiting = false;
							}
//removing this for now..there is potential to see some animation popping if the player is in the act of jumping while he presses the use button
//							else if( players[i] jumpbuttonpressed() )
//							{
//								player = players[i];
//								player.door_link = "tag_origin";
//								waiting = false;
//							}
						}
						else
						{
							self.safe_to_print = false;
						}
					}
				}
			}
		}
	}	
	
	return player;
}

///////////////////////////////////////////////
// Used to determine if the player is looking
// 	in the general direction of the door or not
///////////////////////////////////////////////
door_breach_get_player_struct_dot(player, struct)
{
	structforward = AnglestoForward(struct.angles);
	structnormalized = vectornormalize( structforward );
	playerforward = AnglestoForward( player getplayerangles() );
	playernormalized = VectorNormalize( playerforward);
	
	dot = vectordot( playernormalized, structnormalized );	
	
	return dot;
}

///////////////////////////////////////////////
// Used for a notetrack to play fx when door
//	is bashed open
///////////////////////////////////////////////
fx_play_slinters()
{
	// Door fx
	playfx(level._effect["hinge_door_bash"], self.origin, self.angles );	
}


///////////////////////////////////////////////
// Used in leiu of a notetrack to play fx when 
//	door is bashed open, temporary
///////////////////////////////////////////////
temp_play_fx_late(lerppos)
{
	wait(.3);
	
	playfx(level._effect["hinge_door_bash"], lerppos.origin, lerppos.angles );
}

//sholmes door kick test 12.21.09
door_kick_sound_and_fx(lerppos, player)
{
	wait(.6);
	
	player playsound ("fly_dtp_launch_plr");
	
	wait(.5);
	
	playfx(level._effect["hinge_door_bash"], lerppos.origin, lerppos.angles );
	player  playsound ("fly_wmd_door_breach");
	
}



/////////////////////////////////////////////////////////////////////////////////////////////////////
//	Handy Functions
/////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////
// returns if the door is set to be openable
// 	or not.  should be called on the trigger
///////////////////////////////////////////////
door_breach_can_open()
{
	if( isdefined(self.can_open) )
	{
		return self.can_open;
	}
	else
	{
		assertmsg("Door Breach Trigger Not Initialized.  Does it have the proper script_noteworthy?");
	}
}



///////////////////////////////////////////////
// allows the door to be breached
///////////////////////////////////////////////
door_breach_trigger_on()
{
	self.can_open = true;
	self trigger_on();
}

///////////////////////////////////////////////
// Turns off breaching functionality
///////////////////////////////////////////////
door_breach_trigger_off()
{
	self.can_open = false;
	self trigger_off();
}


// door_breach_door_reset marked for deletion 4/6/2011 by TravisJ; not used in any map but causes code crash. If we keep this functionality, this will need to be fixed
///////////////////////////////////////////////
// Turns off breaching functionality
///////////////////////////////////////////////
door_breach_door_reset()
{
	self.can_open = true;
	self trigger_on();
	
	door = self door_breach_get_door_from_trig();
	door.script_linkto = "origin_animate_jnt";
	
	switch( self.script_noteworthy )
	{
		case "trig_hinge_door":
			{
				door anim_ents( door, "door_breach_shoulder_close", undefined, "hinge_door");
				self thread hinge_door_open();
				break;
			}
			
		case "trig_slide_door":
			{
				door anim_ents( door, "door_breach_slide_close", undefined, "slide_door");
				self thread slide_door_open();
				break;
			}
		case "trig_rolltop_door":
			{
		
			door anim_ents( door, "door_breach_rolltop_close", undefined, "rolltop_door");
			self thread rolltop_door_open();
			break;

			}
	}	
	
	door unlink();
	
	door.angles = door.originalAngles;
	door.origin = door.originalOrigin;		
	
	// iprintlnbold("Resetting Door");
}


// door_breach_open_all_doors marked for deletion 4/6/2011 by TravisJ; not used in any map but causes code crash. If we keep this functionality, this will need to be fixed
///////////////////////////////////////////////
// Turns off breaching functionality
///////////////////////////////////////////////
door_breach_open_all_doors()
{
	trigs = getentarray("trig_hinge_door", "script_noteworthy");	
	trigs_slide = getentarray("trig_slide_door", "script_noteworthy");	
	trigs_rolltop = getentarray("trig_rolltop_door", "script_noteworthy");
	

 
	for(i = 0; i < trigs.size; i++)
	{
		if(trigs[i].can_open)
		{
			door = trigs[i] door_breach_get_door_from_trig();
			door.script_linkto = "origin_animate_jnt";
			level thread anim_ents( door, "door_breach_shoulder", undefined, "hinge_door");
			
			trigs[i] door_breach_trigger_off();
		}
	}
	for(i = 0; i < trigs_slide.size; i++)
	{
		if(trigs_slide[i].can_open)
		{		
			door = trigs_slide[i] door_breach_get_door_from_trig();
			door.script_linkto = "origin_animate_jnt";
			level thread anim_ents( door, "door_breach_slide", undefined, "slide_door");
			
			trigs_slide[i] door_breach_trigger_off();
		}
	}
	for(i = 0; i < trigs_rolltop.size; i++)
	{
		if(trigs_rolltop[i].can_open)
		{
			door = trigs_rolltop[i] door_breach_get_door_from_trig();
			door.script_linkto = "origin_animate_jnt";
			level thread anim_ents( door, "door_breach_rolltop", undefined, "rolltop_door");
			
			trigs_rolltop[i] door_breach_trigger_off();
		}
	}		
}



///////////////////////////////////////////////
// Find the struct used by this trig
///////////////////////////////////////////////
door_breach_get_struct_from_trig()
{
	struct = getstruct(self.target, "targetname");
	return struct;
}

///////////////////////////////////////////////
// Find the door used by this trig
///////////////////////////////////////////////
door_breach_get_door_from_trig()
{
	struct = self door_breach_get_struct_from_trig();
	door = getent(struct.target, "targetname");
	
	return door;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////
//	ANIMS
/////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////
// Load all the anims needed for the player
///////////////////////////////////////////////
#using_animtree("player");
door_breach_load_player_anims()
{
	level.scr_animtree[ "door_breach_player_hands" ] 	= #animtree;		
	level.scr_anim["door_breach_player_hands"]["door_breach_shoulder"]			= %int_breach_shoulder;
	level.scr_anim["door_breach_player_hands"]["door_breach_slide"]					= %int_breach_slide;
	level.scr_anim["door_breach_player_hands"]["door_breach_rolltop"]				= %int_breach_lift;
	
	//SHOLMES DOOR KICK TEST 12.18.09
	level.scr_anim["door_breach_player_hands"] ["door_breach_kick"] = %ch_wmd_b01_kickbreach_player;
	
	// CPIERRO - add support for full body models...leave the old one for compatibility
	level.scr_animtree[ "door_breach_player_body" ] 	= #animtree;		
	level.scr_anim["door_breach_player_body"] ["door_breach_kick"] = %ch_wmd_b01_kickbreach_player;
}

door_breach_set_viewmodel(model)
{
	level.scr_model[ "door_breach_player_hands" ] = model;

}

door_breach_set_interactive_model(model)
{
	level.scr_model[ "door_breach_player_body" ] = model;
}

///////////////////////////////////////////////
// Load all the anims needed for the door
///////////////////////////////////////////////
#using_animtree("door_breach");
door_breach_load_door_anims()
{
	level.scr_animtree["hinge_door"] 											= #animtree;
	level.scr_model["hinge_door"] 												= "tag_origin_animate";
	level.scr_anim["hinge_door"]["door_breach_shoulder"] 	= %o_breach_shoulder;
	level.scr_anim["hinge_door"]["door_breach_shoulder_close"] 	= %o_breach_shoulder_close;
	//addNotetrack_customFunction("hinge_door", "splinter", ::fx_play_slinters, "door_breach_shoulder");
	
	level.scr_animtree["slide_door"]											= #animtree;
	level.scr_model["slide_door"]													= "tag_origin_animate";
	level.scr_anim["slide_door"]["door_breach_slide"]			= %o_breach_slide;
	level.scr_anim["slide_door"]["door_breach_slide_close"]			= %o_breach_slide_close;
	
	level.scr_animtree["rolltop_door"]										= #animtree;
	level.scr_model["rolltop_door"]												= "tag_origin_animate";
	level.scr_anim["rolltop_door"]["door_breach_rolltop"]	= %o_breach_lift;
	level.scr_anim["rolltop_door"]["door_breach_rolltop_close"]	= %o_breach_lift_close;
	
	//sholmes door kick test 12.18.09
	level.scr_animtree["kick_door"]											= #animtree;
	level.scr_model["kick_door"]												= "tag_origin_animate";
	level.scr_anim["kick_door"]["door_breach_kick"]			= %ch_wmd_b01_kickbreach_door;

}




