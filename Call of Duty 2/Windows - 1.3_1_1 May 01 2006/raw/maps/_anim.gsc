#include maps\_utility;
#include animscripts\shared;
#include animscripts\utility;
#include animscripts\face;

/*
ANIM_LOOP: Makes an array of actors and/or script_models do looping animations in sync on a specific node or tag.
anim_loop ( guy, anime, tag, ender, node, tag_entity )
	guy = An array containing actors or script models or both.
	anime = a string index for an animation, ie "run" in this var: level.scr_anim["gun guy"]["run"][0] = (%tigertank_runup_gunguy);
	tag = The tag to start the animation from. You'll want to link the AI if he's meant to be linked to the tag.
	ender = A string to end the looping animation. The entity that called anim_loop will received the notify.
	node = The node referenced in the animation
	tag_entity = The entity that has the tag mentioned above. Normally the entity that calls anim_loop is the tag_entity,
				but if for some reason you need to call anim_loop with a different entity, then you can override with tag_entity.

	
ANIM_SINGLE:	Makes an array of actors and/or script_models do a single animation in sync on a specific node or tag.
				The thread continues after the completion of the animation.
anim_single (guy, anime, tag, node, tag_entity)
	guy = An array containing actors or script models or both.
	anime = a string index for an animation, ie "run" in this var: level.scr_anim["gun guy"]["run"] = (%tigertank_runup_gunguy);
	tag = The tag to start the animation from. You'll want to link the AI if he's meant to be linked to the tag.
	node = The node referenced in the animation
	tag_entity = The entity that has the tag mentioned above. Normally the entity that calls anim_single is the tag_entity,
				but if for some reason you need to call anim_single with a different entity, then you can override with tag_entity.


ANIM_REACH:	Makes an array of AI all get into position to do a specific animation, after which the thread will continue.
anim_reach (guy, anime, tag, node, tag_entity)


ANIM_TELEPORT:	Forces AI and script_models to teleport to the propert starting position for an animation. Note that teleport will fail
				if the player can see the AI in question (the script_models will properly jump regardless).
anim_teleport (guy, anime, tag, node, tag_entity)

	
ANIM_SPAWNER_TELEPORT:	Meant for moving an array of spawners into position so you can then spawn the AI at the right position for
						doing their animation.
anim_teleport (guy, anime, tag, node, tag_entity)


GET_ANIMTREE:	Assigns the proper animtree to every AI/script_model in the array. Be sure to set the .animname for the entities in 
				the array.	
get_animtree ( guy )
	
*/

endonRemoveAnimActive(endonString, guy)
{
	self endon ("newAnimActive");
	self waittill (endonString);
	for (i=0;i<guy.size;i++)
	{
		if (!isdefined(guy[i]))
			continue;
		guy[i]._animActive--;
		assert (guy[i]._animactive >= 0);
	}
}

anim_loop ( guy, anime, tag, ender, node, tag_entity )
{
	// disable BCS if we're doing a scripted sequence.
	for (i=0;i<guy.size;i++)
	{
		if (!isdefined(guy[i]))
			continue;
		if (!isdefined (guy[i]._animActive))
			guy[i]._animActive = 0; // script models cant get their animactive set by init
		guy[i]._animActive++;
	}
	
/#
	if (!isdefined (guy[0].loops))
		guy[0].loops = 0;

	thread printloops (guy[0], anime);
#/

	if (isdefined (ender))
	{
		thread endonRemoveAnimActive(ender, guy);
		self endon (ender);
/#
		self thread looping_anim_ender(guy[0], ender);
#/
	}

	doTag = false;
	doTagEntity = false;
	doNode = false;

	if (isdefined (tag))
	{
		doTag = true;
		if (isdefined (tag_entity))
			doTagEntity = true;
	}
	else
	if (isdefined (node))
		doNode = true;
		
	idleanim = 0;
	lastIdleanim = 0;
	while (1)
	{
		if (doTag)
		{
			if (doTagEntity)
			{
				org = tag_entity gettagOrigin (tag);
				angles = tag_entity gettagAngles (tag);
			}
			else
			{
				org = self gettagOrigin (tag);
				angles = self gettagAngles (tag);
			}
		}
		else
		if (doNode)
		{
			org = node.origin;
			angles = node.angles;
		}
		else
		{
			org = self.origin;
			angles = self.angles;
		}

		idleanim = anim_weight (guy, anime);
		while ((idleanim == lastIdleanim) && (idleanim != 0))
			idleanim = anim_weight (guy, anime);
		lastIdleanim = idleanim;
			
		scriptedAnimationIndex = -1;
		scriptedSoundIndex = -1;
		for (i=0;i<guy.size;i++)
		{
			doFacialanim = false;
			doDialogue = false;
			doAnimation = false;
			doText = false;
			facialAnim = undefined;
			dialogue = undefined;
			
			if ((isdefined (level.scr_face[guy[i].animname])) &&
				(isdefined (level.scr_face[guy[i].animname][anime])) &&
				(isdefined (level.scr_face[guy[i].animname][anime][idleanim])))
			{
				doFacialanim = true;
				facialAnim = level.scr_face[guy[i].animname][anime][idleanim];
			}
	
			if ((isdefined (level.scrsound[guy[i].animname])) && 
				(isdefined (level.scrsound[guy[i].animname][anime])) &&
				(isdefined (level.scrsound[guy[i].animname][anime][idleanim])))
			{
				doDialogue = true;
				dialogue = level.scrsound[guy[i].animname][anime][idleanim];
			}

			if ((isdefined (level.scr_anim[guy[i].animname])) &&
				(isdefined (level.scr_anim[guy[i].animname][anime])))
				doAnimation = true;

			/#
			if ((isdefined (level.scr_text[guy[i].animname])) &&
				(isdefined (level.scr_text[guy[i].animname][anime])))
				doText = true;
			#/
				
			
			if (doAnimation)
			{
				guy[i] animscripted( "looping anim", org, angles, level.scr_anim[guy[i].animname][anime][idleanim] );
				scriptedAnimationIndex = i;
	
				if (isdefined (level.scr_notetrack[guy[i].animname]))
					thread notetrack_wait (guy[i], "looping anim", tag_entity, anime);
				else
					guy[i] notify ("stop doing _anim notetracks");
				guy[i] thread animscriptDoNoteTracksThread("looping anim");
				
			}

			if ( (doFacialanim) || (doDialogue) )
			{
//				println ("dofacialanim: ", dofacialanim, " and dodialogue: ", dodialogue);
//				println ("^3 Animname: ", guy[i].animname, " doing animation ", anime, " facial: ", facialanim, " dialogue: ", dialogue);
				
				if (doAnimation)
					guy[i] SaySpecificDialogue(facialAnim, dialogue, 1.0);
				else
					guy[i] SaySpecificDialogue(facialAnim, dialogue, 1.0, "looping anim");
					
				scriptedSoundIndex = i;
			}
			
			/#
			if (doText && !doDialogue)
				iprintlnBold(level.scr_text[guy[i].animname][anime]);
			#/
		
			add_animation (guy[i].animname, anime);
		}
	
		if (scriptedAnimationIndex != -1)
			guy[scriptedAnimationIndex] waittillmatch ("looping anim", "end");
		else
		if (scriptedSoundIndex != -1)
			guy[scriptedSoundIndex] waittill ("looping anim");
	}
}

anim_single_failsafeOnGuy(owner, anime)
{
	/#
	if (getdebugcvar("debug_grenadehand") != "on")
		return;

	owner endon (anime);
	owner endon ("death");
	self endon ("death");
	name = self.classname;
	num = self getentnum();
	wait (60);
	println ("Guy had classname " + name + " and entnum " + num);
	waittillframeend;
	assertEx(0, "Animation '" + anime + "' did not finish after 60 seconds. See note above");
	#/
	
}

anim_single_failsafe(guy, anime)
{
//	/#
//	self endon (anime);
//	self endon ("death");
	for (i=0;i<guy.size;i++)
		guy[i] thread anim_single_failsafeOnGuy(self, anime);
	/*
	guyName = [];
	guyNum = [];
	for (i=0;i<guy.size;i++)
	{
		guyName[i] = guy[i].classname;
		guyNum[i] = guy[i] getentnum();
	}
	
	wait (60);
	println ("============ solo ran > 60 seconds from anim: ", anime);
	for (i=0;i<guy.size;i++)
	{
		println ("Guy with classname " + guyName[i] + " and entnum " + guyNum[i]);
	}
	assertEx(0, "Animation '" + anime + "' did not finish after 60 seconds. See note above");
	#/
	*/
}

anim_single (guy, anime, tag, node, tag_entity)
{
	/#
	thread anim_single_failsafe(guy, anime);
	#/
	// disable BCS if we're doing a scripted sequence.
	for (i=0;i<guy.size;i++)
	{
		if (!isdefined(guy[i]))
			continue;
		if (!isdefined (guy[i]._animActive))
			guy[i]._animActive = 0; // script models cant get their animactive set by init
		guy[i]._animActive++;
	}

	if (isdefined (tag))
	{
		if (isdefined (tag_entity))
		{
			org = tag_entity gettagOrigin (tag);
			angles = tag_entity gettagAngles (tag);
		}
		else
		{
			org = self gettagOrigin (tag);
			angles = self gettagAngles (tag);
		}
	}
	else
	if (isdefined (node))
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	if (isdefined (self.anim_node))
	{
		org = self.anim_node.origin;
		angles = self.anim_node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}

	scriptedAnimationIndex = -1;
	scriptedSoundIndex = -1;
	scriptedFaceIndex = -1;
	for (i=0;i<guy.size;i++)
	{
		doFacialanim = false;
		doDialogue = false;
		doAnimation = false;
		doText = false;
		doLook = false;

		dialogue = undefined;
		facialAnim = undefined;
		
		if ((isdefined (level.scr_face[guy[i].animname])) &&
			(isdefined (level.scr_face[guy[i].animname][anime])))
		{
			doFacialanim = true;
			facialAnim = level.scr_face[guy[i].animname][anime];
		}
/*			
		if (guy[i].animname == "sniper")
			println ("anime ", anime, " facial: ", level.scr_face[guy[i].animname][anime]); 
		println (facialanim);
*/

		if ((isdefined (level.scrsound[guy[i].animname])) && 
			(isdefined (level.scrsound[guy[i].animname][anime])))
		{
			doDialogue = true;
			dialogue = level.scrsound[guy[i].animname][anime];
		}

		if ((isdefined (level.scr_anim[guy[i].animname])) &&
			(isdefined (level.scr_anim[guy[i].animname][anime])))
			doAnimation = true;

		if ((isdefined (level.scr_look[guy[i].animname])) &&
			(isdefined (level.scr_look[guy[i].animname][anime])))
			doLook = true;

		/#
		if ((isdefined (level.scr_text[guy[i].animname])) &&
			(isdefined (level.scr_text[guy[i].animname][anime])))
			doText = true;
		#/
	
		if (doAnimation)
		{
			if (isdefined (guy[i].anim_node))
				guy[i] animscripted( "single anim", guy[i].anim_node.origin, guy[i].anim_node.angles, level.scr_anim[guy[i].animname][anime] );
			else
				guy[i] animscripted( "single anim", org, angles, level.scr_anim[guy[i].animname][anime] );
			scriptedAnimationIndex = i;

			if (isdefined (level.scr_notetrack[guy[i].animname]))
				thread notetrack_wait (guy[i], "single anim", tag_entity, anime);
			else
				guy[i] notify ("stop doing _anim notetracks");
			guy[i] thread animscriptDoNoteTracksThread("single anim");
		}
		if (doLook)
		{
			assertEx (doAnimation, "Look animation " + anime + " for animname " + guy[i].animname + " does not have a base animation");
			// blend 2 animations so the guy can look at the player
			thread anim_look( guy[i], anime, level.scr_look[guy[i].animname][anime] );
		}

		
//		println ("^a SOUND time ", dialogue);
		if ( (doFacialanim) || (doDialogue) )
		{
//			println (guy[i].animname , " facialanim ", facialanim);
			if (doFacialAnim)
			{
				if (doDialogue)
					guy[i] thread delayedDialogue(anime, doFacialanim, dialogue, level.scr_face[guy[i].animname][anime]);
				assertEx (!doanimation, "Can't play a facial anim and fullbody anim at the same time. The facial anim should be in the full body anim. Occurred on animation " + anime);
				thread anim_facialAnim( guy[i], anime, level.scr_face[guy[i].animname][anime] );
				scriptedFaceIndex = i;
			}
			else
			if (doAnimation)
				guy[i] SaySpecificDialogue(facialAnim, dialogue, 1.0);
			else
			{
				guy[i] thread anim_facialFiller( "single dialogue");
				guy[i] SaySpecificDialogue(facialAnim, dialogue, 1.0, "single dialogue");
			}
			
			scriptedSoundIndex = i;
//			println ("facial sound ", dialogue);
		}

		add_animation (guy[i].animname, anime);

		/#
		if (doText && !doDialogue)
		{
			iprintlnBold(level.scr_text[guy[i].animname][anime]);
			wait (level.scr_text[guy[i].animname][anime].size * 0.075);
		}
		#/
	}


	if (scriptedAnimationIndex != -1)
	{
//		guy[scriptedAnimationIndex] endon ("death");	
		ent = spawnstruct();
		ent thread anim_deathNotify(guy[scriptedAnimationIndex], anime);
		ent thread anim_animationEndNotify(guy[scriptedAnimationIndex], anime);
		ent waittill (anime);
//		guy[scriptedAnimationIndex] waittillmatch ("single anim", "end");
	}
	else
	if (scriptedFaceIndex != -1)
	{
		ent = spawnstruct();
		ent thread anim_deathNotify(guy[scriptedFaceIndex], anime);
		ent thread anim_facialEndNotify(guy[scriptedFaceIndex], anime);
		ent waittill (anime);
	}
	else
	if (scriptedSoundIndex != -1)
	{
//		guy[scriptedSoundIndex] endon ("death");
		ent = spawnstruct();
		ent thread anim_deathNotify(guy[scriptedSoundIndex], anime);
		ent thread anim_dialogueEndNotify(guy[scriptedSoundIndex], anime);
		ent waittill (anime);
//		guy[scriptedSoundIndex] waittill ("single dialogue");
	}
		
	for (i=0;i<guy.size;i++)
	{
		if (!isdefined(guy[i]))
			continue;
		guy[i]._animActive--;
		assert (guy[i]._animactive >= 0);
	}
	self notify (anime);
}

anim_deathNotify ( guy, anime )
{
	self endon (anime);
	guy waittill ("death");
	self notify (anime);
}


anim_facialEndNotify ( guy, anime )
{
	self endon (anime);
	guy waittillmatch ("face_done_" + anime, "end");
	self notify (anime);
}

anim_dialogueEndNotify ( guy, anime )
{
	self endon (anime);
	guy waittill ("single dialogue");
	self notify (anime);
}

anim_animationEndNotify ( guy, anime )
{
	self endon (anime);
	guy waittillmatch ("single anim", "end");
	self notify (anime);
}

animscriptDoNoteTracksThread(animstring)
{
	self endon ("stop doing _anim notetracks");
	self endon ("death");
	DoNoteTracks(animstring);
}

notetrack_wait (guy, msg, tag_entity, anime)
{
	guy notify ("stop doing _anim notetracks");
	guy endon ("stop doing _anim notetracks");
	
//	self endon (ender);
	if (isdefined (tag_entity))
		tag_owner = tag_entity;
	else
		tag_owner = self;
		
	while (1)
	{
		guy waittill (msg, notetrack);
		dialogueNotetrack = false;
		if (notetrack == "end")
			return;

		for (i=0;i<level.scr_notetrack[guy.animname].size;i++)
		{
			if (notetrack == level.scr_notetrack[guy.animname][i]["notetrack"])
			{
				if (isdefined (level.scr_notetrack[guy.animname][i]["anime"]))
				{
					if (level.scr_notetrack[guy.animname][i]["anime"] != anime)
						continue;
				}
			
				if (isdefined (level.scr_notetrack[guy.animname][i]["function"]))
					self thread [[level.scr_notetrack[guy.animname][i]["function"]]](guy);
			
				if (isdefined (level.scr_notetrack[guy.animname][i]["attach gun left"]))
				{
					guy gun_pickup_left();
					continue;
				}
	
				if (isdefined (level.scr_notetrack[guy.animname][i]["attach gun right"]))
				{
					guy gun_pickup_right();
					continue;
				}
				
				if (isdefined (level.scr_notetrack[guy.animname][i]["detach gun"]))
				{
					self gun_leave_behind (guy, level.scr_notetrack[guy.animname][i]);
					continue;
				}

				if (isdefined (level.scr_notetrack[guy.animname][i]["swap from"]))
				{
					guy detach(guy.swapWeapon, level.scr_notetrack[guy.animname][i]["swap from"]);
					guy attach(guy.swapWeapon, level.scr_notetrack[guy.animname][i]["self tag"]);
					continue;
				}

				if (isdefined (level.scr_notetrack[guy.animname][i]["attach model"]))
				{
					if (isdefined (level.scr_notetrack[guy.animname][i]["selftag"]))
						guy attach(level.scr_notetrack[guy.animname][i]["attach model"], level.scr_notetrack[guy.animname][i]["selftag"]);
					else
						tag_owner attach(level.scr_notetrack[guy.animname][i]["attach model"], level.scr_notetrack[guy.animname][i]["tag"]);

					continue;
				}

				if (isdefined (level.scr_notetrack[guy.animname][i]["detach model"]))
				{
					waittillframeend; // because this should come after any attachs that happen on the same frame
					if (isdefined (level.scr_notetrack[guy.animname][i]["selftag"]))
						guy detach(level.scr_notetrack[guy.animname][i]["detach model"], level.scr_notetrack[guy.animname][i]["selftag"]);
					else
						tag_owner detach(level.scr_notetrack[guy.animname][i]["detach model"], level.scr_notetrack[guy.animname][i]["tag"]);
				}

				if (isdefined (level.scr_notetrack[guy.animname][i]["sound"]))
					guy thread playSoundOnTag (level.scr_notetrack[guy.animname][i]["sound"]);

				if (!dialogueNotetrack)
				{
					if (isdefined (level.scr_notetrack[guy.animname][i]["dialogue"]))
					{
						anim_facial (guy, i, "dialogue");
						dialogueNotetrack = true;
					}
	
					if (isdefined (level.scr_notetrack[guy.animname][i]["dialog"]))
					{
						anim_facial (guy, i, "dialog");
						dialogueNotetrack = true;
					}
				}

				if (isdefined (level.scr_notetrack[guy.animname][i]["create model"]))
					anim_addModel (guy, level.scr_notetrack[guy.animname][i]);
				else
				if (isdefined (level.scr_notetrack[guy.animname][i]["delete model"]))
					anim_removeModel (guy, level.scr_notetrack[guy.animname][i]);

				if ((isdefined (level.scr_notetrack[guy.animname][i]["selftag"])) &&
				(isdefined (level.scr_notetrack[guy.animname][i]["effect"])))
				{
					playfxOnTag ( 
					level._effect[level.scr_notetrack[guy.animname][i]["effect"]], guy, 
					level.scr_notetrack[guy.animname][i]["selftag"] );
				}

				if ((isdefined (level.scr_notetrack[guy.animname][i]["tag"])) &&
				(isdefined (level.scr_notetrack[guy.animname][i]["effect"])))
				{
					playfxOnTag ( 
					level._effect[level.scr_notetrack[guy.animname][i]["effect"]], tag_owner, 
					level.scr_notetrack[guy.animname][i]["tag"] );
				}
				
				if (isdefined (level.scr_special_notetrack[guy.animname]))
				{
					tag = random (level.scr_special_notetrack[guy.animname]);
					if (isdefined (tag["tag"]))
						playfxOnTag ( level._effect[tag["effect"]], tag_owner, tag["tag"]);
					else
					if (isdefined (tag["selftag"]))
						playfxOnTag ( level._effect[tag["effect"]], self,	tag["tag"]);
				}				
			}
			/*
			else
			if (notetrack == "anim_gunhand = \"left\"")
				guy putGunInHand ("left");
			else
			if (notetrack == "anim_gunhand = \"right\"")
				guy putGunInHand ("right");
			*/
			else
			if (notetrack == "lookat = \"on\"")
				guy lookat (level.player);
			else
			if (notetrack == "lookat = \"off\"")
				guy lookat (guy, 0);

		}
	}
}

anim_addModel (guy, array)
{
	if (!isdefined (guy.ScriptModel))
		guy.ScriptModel = [];
		
	index = guy.ScriptModel.size;
	guy.ScriptModel[index] = spawn ("script_model",(0,0,0));
	guy.ScriptModel[index] setmodel (array["create model"]);
	guy.ScriptModel[index].origin = guy gettagOrigin (array["selftag"]);
	guy.ScriptModel[index].angles = guy gettagAngles (array["selftag"]);
}	

anim_removeModel (guy, array)
{
/#
	if (!isdefined (guy.ScriptModel))
		assertMsg ("Tried to remove a model with delete model before it was create model'd on guy: " + guy.animname);
#/

	for (i=0;i<guy.ScriptModel.size;i++)
	{
		if (isdefined (array["explosion"]))
		{
			forward = anglesToForward(guy.scriptModel[i].angles);
			forward = vectorScale (forward, 120);
			forward += guy.scriptModel[i].origin;
			playfx ( level._effect[array["explosion"]], guy.scriptModel[i].origin); //, guy.scriptModel.origin, forward );
			radiusDamage (guy.scriptModel[i].origin, 350, 700, 50);
		}
		guy.scriptModel[i] delete();
	}
}

anim_facial (guy, i, dialogueString)
{
	facialAnim = undefined;
	if (isdefined (level.scr_notetrack[guy.animname][i]["facial"]))
		facialAnim = level.scr_notetrack[guy.animname][i]["facial"];

	dialogue = level.scr_notetrack[guy.animname][i][dialogueString];
//	if (guy.animname == "foley")
//		println ("facial animation ", facialanim, " dialogue ", dialogue);
		
	guy SaySpecificDialogue(facialAnim, dialogue, 1.0);
//	level.scr_notetrack[guy.animname][i][dialogueString] = undefined;
}

gun_pickup_left ()
{
	if (!isdefined (self.gun_on_ground))
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;
//	println ("dropweapon is ", self.dropweapon);

	self putGunInHand ("left");
}

gun_pickup_right ()
{
	if (!isdefined (self.gun_on_ground))
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;
//	println ("dropweapon is ", self.dropweapon);
	
	self putGunInHand ("right");
}

gun_leave_behind (guy, scr_notetrack)
{
	if (isdefined (guy.gun_on_ground))
		return;

	link = true;

	if (self == guy)
		link = false;

	gun = spawn ("weapon_" + guy.weapon, (0,0,0));
	
	guy.gun_on_ground = gun;
	gun.origin = self gettagOrigin (scr_notetrack["tag"]);
	gun.angles = self gettagAngles (scr_notetrack["tag"]);

	if (link)
		gun linkto (self, scr_notetrack["tag"], (0,0,0),(0,0,0));
	else
	{
		org = spawn ("script_origin",(0,0,0));
		org.origin = gun.origin;
		org.angles = gun.angles;
		level thread gun_killOrigin ( gun, org );
	}
	
	guy putGunInHand ("none");
	guy.dropWeapon = false;
}

gun_killOrigin ( gun, org )
{
	gun waittill ("death");
	org delete();
}

anim_weight (guy, anime)
{
	total_anims = level.scr_anim[guy[0].animname][anime].size;
	idleanim = randomint (total_anims);
	if (total_anims > 1)
	{
		weights = 0;
		anim_weight = 0;
		
		for (i=0;i<total_anims;i++)
		{
			if (isdefined (level.scr_anim[guy[0].animname][anime + "weight"]))
			{
				if (isdefined (level.scr_anim[guy[0].animname][anime + "weight"][i]))
				{
					weights++;
					anim_weight += level.scr_anim[guy[0].animname][anime + "weight"][i];
				}
			}
		}
		
		if (weights == total_anims)
		{
			anim_play = randomfloat (anim_weight);
			anim_weight	= 0;
			
			for (i=0;i<total_anims;i++)
			{
				anim_weight += level.scr_anim[guy[0].animname][anime + "weight"][i];
				if (anim_play < anim_weight)
				{
					idleanim = i;
					break;
				}
			}
		}
	}
	
	return idleanim;
}		

anim_reach (guy, anime, tag, node, tag_entity)
{
//	println (guy[0].animname, " doing animation ", anime);
	if (isdefined (tag))
	{
		if (isdefined (tag_entity))
		{
			org = tag_entity gettagOrigin (tag);
			angles = tag_entity gettagAngles (tag);
		}
		else
		{
			org = self gettagOrigin (tag);
			angles = self gettagAngles (tag);
		}
	}
	else
	if (isdefined (node))
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}

	ent = spawnstruct();
	debugStartpos = false;
	/#
	debugStartpos = getdebugcvar("debug_animreach") ==  "on";
	#/
	threads = 0;
	for (i=0;i<guy.size;i++)
	{
//		println ("guy is ", guy[0].animname, " anime is ", anime, " tag is ", tag);
		
		if (isdefined (guy[i].anim_node))
			startorg = getstartOrigin (guy[i].anim_node.origin, guy[i].anim_node.angles, level.scr_anim[guy[i].animname][anime]);
		else
			startorg = getstartOrigin (org, angles, level.scr_anim[guy[i].animname][anime]);
			
		/#
		if (debugStartpos)
			thread debug_message_clear ("x", startorg, 1000, "clearAnimDebug");
		#/
		guy[i] setgoalpos (startorg);
		threads++;
		guy[i] thread reach_goal_notify (ent);
	}
	
	while (threads)
	{
		ent waittill ("reach notify");
		threads--;
	}
	/#
	if (debugStartpos)
		level notify ("x" + "clearAnimDebug");
	#/
	
	for (i=0;i<guy.size;i++)
	{
		if (isalive(guy[i]))
			guy[i].goalradius = guy[i].oldgoalradius;
	}
}

anim_teleport (guy, anime, tag, node, tag_entity)
{
//	println (guy[0].animname, " doing animation ", anime);
	if (isdefined (tag))
	{
		if (isdefined (tag_entity))
		{
			org = tag_entity gettagOrigin (tag);
			angles = tag_entity gettagAngles (tag);
		}
		else
		{
			org = self gettagOrigin (tag);
			angles = self gettagAngles (tag);
		}
	}
	else
	if (isdefined (node))
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}

	ent = spawnstruct();

	for (i=0;i<guy.size;i++)
	{
		startorg = getstartOrigin (org, angles, level.scr_anim[guy[i].animname][anime]);
		if (isSentient (guy[i]))
			guy[i] teleport (startorg);
		else
			guy[i].origin = (startorg);
	}
}

anim_spawner_teleport (guy, anime, tag, node, tag_entity)
{
//	println (guy[0].animname, " doing animation ", anime);
	if (isdefined (tag))
	{
		if (isdefined (tag_entity))
		{
			org = tag_entity gettagOrigin (tag);
			angles = tag_entity gettagAngles (tag);
		}
		else
		{
			org = self gettagOrigin (tag);
			angles = self gettagAngles (tag);
		}
	}
	else
	if (isdefined (node))
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}

	ent = spawnstruct();

	for (i=0;i<guy.size;i++)
	{
		startorg = getstartOrigin (org, angles, level.scr_anim[guy[i].animname][anime]);
		guy[i].origin = (startorg);
	}
}

reach_death_notify (ent)
{
	self endon ("goal");
	self waittill ("death");
	ent notify ("reach notify");
}

reach_goal_notify (ent)
{
	self endon ("death");
	thread reach_death_notify (ent);
	self.oldgoalradius = self.goalradius;
	self.goalradius = 0;
	self.oldpathenemyFightdist = self.pathenemyFightdist;
	self.oldpathenemyLookahead = self.pathenemyLookahead;
	self.pathenemyFightdist = 0;
	self.pathenemyLookahead = 0;
	self waittill ("goal");
//	self.goalradius = self.oldgoalradius;
	ent notify ("reach notify");
	self.pathenemyFightdist = self.oldpathenemyFightdist;
	self.pathenemyLookahead = self.oldpathenemyLookahead;
}

/#
printloops (guy, anime)
{
//	wait (0.05);
	if (!isdefined(guy))
		return;

	guy endon ("death"); // could die during the frame
	waittillframeend; // delay a frame so if you end a loop with a notify then start a new loop, this guarentees that 
	                  // the 2nd loop doesnt start before the loop decrementer receives the same notify that ended the first loop
	guy.loops++;
	if (guy.loops > 1)
		assertMsg ("guy with name "+ guy.animname+ " has "+ guy.loops+ " looping animations played, anime: "+ anime);
}

looping_anim_ender (guy, ender)
{
	guy endon ("death");
	self waittill (ender);
	guy.loops--;
}
#/

get_animtree ( guy )
{
	for (i=0;i<guy.size;i++)
		guy[i] UseAnimTree(level.scr_animtree[guy[i].animname]);
}

anim_single_solo (guy, anime, tag, node, tag_entity)
{
	self endon("death");

	newguy[0] = guy;
	anim_single (newguy, anime, tag, node, tag_entity);
}

anim_reach_solo (guy, anime, tag, node, tag_entity)
{
	self endon("death");

	newguy[0] = guy;
	anim_reach (newguy, anime, tag, node, tag_entity);
}

anim_loop_solo ( guy, anime, tag, ender, node, tag_entity )
{
	self endon("death");

	newguy[0] = guy;
	anim_loop ( newguy, anime, tag, ender, node, tag_entity );
}

anim_teleport_solo (guy, anime, tag, node, tag_entity)
{
	self endon ("death");
	
	newguy[0] = guy;
	anim_teleport ( newguy, anime, tag, node, tag_entity);
}

anim_single_solo_debug (guy, anime, tag, node, tag_entity)
{
	self endon("death");

	newguy[0] = guy;
	anim_single_debug (newguy, anime, tag, node, tag_entity);
}

anim_loop_solo_debug ( guy, anime, tag, ender, node, tag_entity )
{
	self endon("death");

	newguy[0] = guy;
	anim_loop_debug ( newguy, anime, tag, ender, node, tag_entity );
}

anim_loop_debug ( guy, anime, tag, ender, node, tag_entity )
{
	println ("^cDebugging looping animation ", anime, ":");
	println ("Tag: ", tag);
	println ("Ender: ", ender);
	println ("Node: ", node);
	println ("Tag_entity: ", tag_entity);
	println ("Entity calling loop: ", self, ", classname: ", self.classname);
	
	for (i=0;i<guy.size;i++)
	{
		if (isdefined(guy[i]))
			continue;
			
		println ("Array entree ", i, " was undefined, can't completel looping animation");
	}
	
	if (isdefined (tag))
	{
		if (isdefined (tag_entity))
		{
			org = tag_entity gettagOrigin (tag);
			angles = tag_entity gettagAngles (tag);
		}
		else
		{
			org = self gettagOrigin (tag);
			angles = self gettagAngles (tag);
		}
	}
	else
	if (isdefined (node))
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	if (!isdefined (angles))
		println ("No ANGLES, means you probably have the world calling this thread, meaning you probably misspelled your node.");
	anim_loop ( guy, anime, tag, ender, node, tag_entity );
}

anim_single_debug ( guy, anime, tag, node, tag_entity )
{
	println ("^cDebugging single animation ", anime, ":");
	println ("Tag: ", tag);
	println ("Node: ", node);
	println ("Tag_entity: ", tag_entity);
	println ("Entity calling loop: ", self, ", classname: ", self.classname);
	
	for (i=0;i<guy.size;i++)
	{
		if (isdefined(guy[i]))
			continue;
			
		println ("Array entree ", i, " was undefined, can't completel looping animation");
	}
	
	if (isdefined (tag))
	{
		if (isdefined (tag_entity))
		{
			org = tag_entity gettagOrigin (tag);
			angles = tag_entity gettagAngles (tag);
		}
		else
		{
			org = self gettagOrigin (tag);
			angles = self gettagAngles (tag);
		}
	}
	else
	if (isdefined (node))
	{
		org = node.origin;
		angles = node.angles;
	}
	else
	{
		org = self.origin;
		angles = self.angles;
	}
	
	if (!isdefined (angles))
		println ("No ANGLES, means you probably have the world calling this thread, meaning you probably misspelled your node.");
	anim_single ( guy, anime, tag, node, tag_entity );
}

add_animation (animname, anime)
{
	if (!isdefined (level.completedAnims))
		level.completedAnims[animname][0] = anime;
	else
	{
		if (!isdefined (level.completedAnims[animname]))
			level.completedAnims[animname][0] = anime;
		else
		{
			for (i=0;i<level.completedAnims[animname].size;i++)
			{
				if (level.completedAnims[animname][i] == anime)
					return;
			}
			
			level.completedAnims[animname][level.completedAnims[animname].size] = anime;
		}
	}
}

anim_single_queue (guy, anime, tag, node, tag_entity)
{
	queueTime = gettime();
	while (1)
	{
		if (!isdefined (self._anim_solo_queue))
			break;
			
		self waittill ("finished anim solo");
		if (gettime() > queueTime + 5000)
			return;
	}

	self._anim_solo_queue = true;	
	newguy[0] = guy;
	anim_single (newguy, anime, tag, node, tag_entity);
	self._anim_solo_queue = undefined;
	self notify ("finished anim solo");
}

anim_dontPushPlayer (guy)
{
	for (i=0;i<guy.size;i++)
	{
		guy[i] pushPlayer (false);
	}
}

anim_pushPlayer (guy)
{
	for (i=0;i<guy.size;i++)
	{
		guy[i] pushPlayer (true);
	}
}

addNotetrack_dialogue(animname, notetrack, anime, soundalias)
{
	num = 0;
	if (isdefined (level.scr_notetrack[animname]))
		num = level.scr_notetrack[animname].size;
	
	level.scr_notetrack[animname][num]["notetrack"]		= notetrack;
	level.scr_notetrack[animname][num]["dialog"]		= soundalias;
	
	if (isdefined (anime))
		level.scr_notetrack[animname][num]["anime"]		= anime;
}

removeNotetrack_dialogue(animname, notetrack, anime, soundalias)
{
	assertex(isdefined (level.scr_notetrack[animname]), "Animname not found in scr_notetrack.");

	tmp_array = [];

	for (i=0; i < level.scr_notetrack[animname].size; i++)
	{
		if (level.scr_notetrack[animname][i]["notetrack"] == notetrack)
		{
			dialog = level.scr_notetrack[animname][i]["dialog"];
			if (!isdefined(dialog))
				dialog = level.scr_notetrack[animname][i]["dialogue"];

			if (isdefined(dialog) && dialog == soundalias)
			{
				if (isdefined (anime) && isdefined(level.scr_notetrack[animname][i]["anime"]))
				{
					if (level.scr_notetrack[animname][i]["anime"] == anime)
						continue;
				}
				else
					continue;
			}
		}

		num = tmp_array.size;
		tmp_array[num] = level.scr_notetrack[animname][i];
	}

	assertex(tmp_array.size < level.scr_notetrack[animname].size, "Notetrack not found.");

	level.scr_notetrack[animname] = tmp_array;
}

addNotetrack_sound(animname, notetrack, anime, soundalias)
{
	num = 0;
	if (isdefined (level.scr_notetrack[animname]))
		num = level.scr_notetrack[animname].size;
	
	level.scr_notetrack[animname][num]["notetrack"]		= notetrack;
	level.scr_notetrack[animname][num]["sound"]			= soundalias;
	
	if (isdefined (anime))
		level.scr_notetrack[animname][num]["anime"]		= anime;
}

addNotetrack_attach(animname, notetrack, model, tag, anime)
{
	num = 0;
	if (isdefined (level.scr_notetrack[animname]))
		num = level.scr_notetrack[animname].size;
	
	level.scr_notetrack[animname][num]["notetrack"]		= notetrack;
	level.scr_notetrack[animname][num]["attach model"]	= model;
	level.scr_notetrack[animname][num]["selftag"]		= tag;
	
	if (isdefined (anime))
		level.scr_notetrack[animname][num]["anime"]		= anime;
}

addNotetrack_detach(animname, notetrack, model, tag, anime)
{
	num = 0;
	if (isdefined (level.scr_notetrack[animname]))
		num = level.scr_notetrack[animname].size;
	
	level.scr_notetrack[animname][num]["notetrack"]		= notetrack;
	level.scr_notetrack[animname][num]["detach model"]	= model;
	level.scr_notetrack[animname][num]["selftag"]		= tag;
	
	if (isdefined (anime))
		level.scr_notetrack[animname][num]["anime"]		= anime;
}

addNotetrack_customFunction(animname, notetrack, function, anime)
{
	num = 0;
	if (isdefined (level.scr_notetrack[animname]))
		num = level.scr_notetrack[animname].size;
	
	level.scr_notetrack[animname][num]["notetrack"]		= notetrack;
	level.scr_notetrack[animname][num]["function"]		= function;
	
	if (isdefined (anime))
		level.scr_notetrack[animname][num]["anime"]		= anime;
}

#using_animtree ("generic_human");

anim_look( guy, anime, array )
{
	guy endon ("death");
	self endon (anime);
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
	wait (0.05);
	
	guy setflaggedanimknobrestart("face_done_" + anime, array["left"], 1, 0.2, 1);
	thread clearFaceAnimOnAnimdone(guy, "face_done_" + anime, anime);
	guy setanimknobrestart(array["right"], 1, 0.2, 1);
	guy setanim( %scripted, 0.01, 0.3, 1 );
//	guy setanim( %scripted_look_straight,	0,	changeTime );

	closeToZero = 0.01;
	for (;;)
	{
		destYaw = guy GetYawToOrigin(level.player.origin);
		if (destYaw<=array["left_angle"])
		{
			animWeights["left"] = 1;
			animWeights["right"] = closeToZero;
		}
		else 
		if (destYaw<array["right_angle"])
		{
			middleFraction = ( array["right_angle"] - destYaw ) / ( array["right_angle"] - array["left_angle"] );
			if (middleFraction < closeToZero)	middleFraction = closeToZero;
			if (middleFraction > 1-closeToZero)	middleFraction = 1-closeToZero;
			animWeights["left"] = middleFraction;
			animWeights["right"] = (1 - middleFraction);
		}
		else
		{
			animWeights["left"] = closeToZero;
			animWeights["right"] = 1;
		}

		guy setanim( %scripted_look_left,		animWeights["left"],	changeTime );	// anim, weight, blend-time
		guy setanim( %scripted_look_right,		animWeights["right"],	changeTime );
		wait (changeTime);
	}	
}

anim_facialAnim( guy, anime, faceanim )
{

	guy endon ("death");
	self endon (anime);
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
//	guy setanim(%scripted, 0.01, 0.3, 1);
	
	guy notify ("newLookTarget");		

	waittillframeend; // in case another facial animation just ended, so its clear doesnt overwrite us
	closeToZero = 0.3;
	guy clearanim( %scripted_look_left,		changeTime );	// anim, weight, blend-time
	guy clearanim( %scripted_look_right,	changeTime );
	guy setanim( %scripted_look_straight,	0, 0);
	guy setanim( %scripted_look_straight,	1, 0.5);
	guy setflaggedanimknobrestart("face_done_" + anime, faceanim, 1, 0, 1);
	thread clearFaceAnimOnAnimdone(guy, "face_done_" + anime, anime);
}

anim_facialFiller( msg, lookTarget )
{
	self endon ("death");
	
	changeTime = 0.05;
	// must wait because animscripted starts the main animation and we have to wait until its started
//	guy setanim(%scripted, 0.01, 0.3, 1);

	self notify ("newLookTarget");		
	self endon ("newLookTarget");		
	
	waittillframeend; // in case another facial animation just ended, so its clear doesnt overwrite us
	closeToZero = 0.3;
	self clearanim( %scripted_look_left,		changeTime );	// anim, weight, blend-time
	self clearanim( %scripted_look_right,		changeTime );
	
	/*
	quick = false;
	if (!isdefined (looktarget))
	{
		guy[0] = self;
		lookTarget = getclosestaiexclude(self.origin, self.team, guy);
		if (isdefined (looktarget))
			quick = true;
	}
	*/
	if (!isdefined(looktarget) && isdefined(self.looktarget))
		looktarget = self.looktarget;

	talkAnim = %generic_talker_allies;
	if (self.team == "axis")
		talkAnim = %generic_talker_axis;

	self setanimknobrestart( talkAnim, 1, 0, 1);
	self setanim( %scripted_talking, 5, 0.1);
	
	if (isdefined (looktarget))
	{
//		self setanim( %scripted_look_straight,	0, 0);
//		self setanim( %scripted_look_straight,	1, 1);
		thread chatAtTarget(msg, lookTarget);
		return;
	}

//	self setanim( %scripted_look_straight,	0, 0);
//	self setanim( %scripted_look_straight,	1, 0.5);
	self waittill (msg);
	changeTime = 0.3;
	self clearanim( %scripted_talking, 0.1);
	self clearanim( %scripted_look_left,		changeTime );
	self clearanim( %scripted_look_right,		changeTime );
	self clearanim( %scripted_look_straight,	changeTime );
}

GetYawAngles(angles1, angles2)
{
	yaw = angles1[1] - angles2[1];
	yaw = AngleClamp(yaw, "-180 to 180");
	return yaw;
}

chatAtTarget(msg, lookTarget)
{
	self endon (msg);
	self endon ("death");


	self thread lookRecenter(msg);
	
	array["right"] = %generic_lookupright;
	array["left"] = %generic_lookupleft;
	
	array["left_angle"] = -65;
	array["right_angle"] = 65;
	

	closeToZero = 0.01;
	org = looktarget.origin;

	moveRange = 2.0;
	changeTime = 0.3;

	for (;;)
	{
		if (isalive(looktarget))
			org = looktarget.origin;
		/#
		if (getdebugcvar("debug_chatlook") == "on")
			thread lookLine(org, msg);
		#/
//		destYaw = self GetEyeYawToOrigin(org);
//		destYaw = self GetYawToOrigin(org);
		angles = anglestoright(self gettagangles("J_Spine4"));
		angles = vectorscale(angles, 10);
		angles = vectortoangles((0,0,0) - angles);
//		destYaw = self GetYawToTag("J_Spine4", org);
	
		yaw = angles[1] - GetYaw(org);
		destyaw = AngleClamp(yaw, "-180 to 180");

		
		moveRange = abs(destYaw - self.anim_lookAngle) * 1;
		
		if (destYaw > self.anim_lookangle + moveRange)
			self.anim_lookangle += moveRange;
		else
		if (destYaw < self.anim_lookangle - moveRange)
			self.anim_lookangle -= moveRange;
		else
			self.anim_lookangle = destYaw;
			
		destYaw = self.anim_lookangle;
			
		if (destYaw<=array["left_angle"])
		{
			animWeights["left"] = 1;
			animWeights["right"] = closeToZero;
		}
		else 
		if (destYaw<array["right_angle"])
		{
			middleFraction = ( array["right_angle"] - destYaw ) / ( array["right_angle"] - array["left_angle"] );
			if (middleFraction < closeToZero)	middleFraction = closeToZero;
			if (middleFraction > 1-closeToZero)	middleFraction = 1-closeToZero;
			animWeights["left"] = middleFraction;
			animWeights["right"] = (1 - middleFraction);
		}
		else
		{
			animWeights["left"] = closeToZero;
			animWeights["right"] = 1;
		}
		
		self setanim( array["left"],		animWeights["left"],	changeTime );	// anim, weight, blend-time
		self setanim( array["right"],		animWeights["right"],	changeTime );
		wait (changeTime);
	}
}

lookRecenter(msg)
{
	// recenter the look angle so the head doesnt jerk back to where he used to be looking
	self endon ("newLookTarget");	
	self endon ("death");
	self waittill (msg);
	self clearanim(%scripted_talking, 0.1);

	self setanim( %generic_lookupright,		1,		0.3 );	// anim, weight, blend-time
	self setanim( %generic_lookupleft,		1,		0.3 );
	self setanim( %scripted_look_straight,	0.2,	0.1 );
	wait (0.2);
	self clearanim(%scripted_look_straight, 0.2);
}

lookLine(org, msg)
{
	self notify ("lookline");
	self endon ("lookline");
	self endon (msg);
	self endon ("death");
	for (;;)
	{
		line (self geteye(), org + (0,0,60), (1,1,0), 1);
		wait (0.05);
	}
}

anim_reach_idle( guy, anime, idle )
{
	// Makes an array of guys go to the right spot relative to an animation
	// all but the last guy will idle there, so you do anim_reach_idle then anim_loop
	ent = spawnstruct();
	ent.count = guy.size;
	for (i=0;i<guy.size;i++)
		thread reachIdle(guy[i], anime, idle, ent);
	while (ent.count)
		ent waittill ("reached_goal");

	self notify ("stopReachIdle");
}

reachIdle(guy, anime, idle, ent)
{
	anim_reach_solo (guy, anime);
	ent.count--;
	ent notify ("reached_goal");
	if (ent.count > 0)
		anim_loop_solo (guy, idle, undefined, "stopReachIdle");
}

delayedDialogue(anime, doAnimation, dialogue, animationName)
{
	assertEx (animhasnotetrack(animationName, "dialog"), "Animation " + anime + " does not have a dialog notetrack.");
	
	self waittillmatch ("face_done_" + anime, "dialog");
	if (doAnimation)
		self SaySpecificDialogue(undefined, dialogue, 1.0);
	else
		self SaySpecificDialogue(undefined, dialogue, 1.0, "single dialogue");
}

clearFaceAnimOnAnimdone(guy, msg, anime)
{
	guy endon ("death");
//	self waittill (anime);
	guy waittillmatch (msg, "end");
	changeTime = 0.3;
	guy clearanim( %scripted_look_left,			changeTime );
	guy clearanim( %scripted_look_right,		changeTime );
	guy clearanim( %scripted_look_straight,		changeTime );
}

anim_single_solo_delayed (delay, guy, anime, tag, node, tag_entity)
{
	wait (delay);
	anim_single_solo (guy, anime, tag, node, tag_entity);
}
