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

anim_loop ( guy, anime, tag, ender, node, tag_entity )
{
	if (!isdefined (guy[0].loops))
		guy[0].loops = 0;

	thread printloops (guy[0], anime);

//	println (guy[0].animname, " doing animation ", anime);
	if (isdefined (ender))
	{
		self endon (ender);
		self thread looping_anim_ender(guy[0], ender);
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
			
			if ((isdefined (level.scr_face[guy[i].animname])) &&
				(isdefined (level.scr_face[guy[i].animname][anime])))
			{
				doFacialanim = true;
				facialAnim = level.scr_face[guy[i].animname][anime][idleanim];
			}
	
			if ((isdefined (level.scrsound[guy[i].animname])) && 
				(isdefined (level.scrsound[guy[i].animname][anime])))
			{
				doDialogue = true;
				dialogue = level.scrsound[guy[i].animname][anime][idleanim];
			}

			if ((isdefined (level.scr_anim[guy[i].animname])) &&
				(isdefined (level.scr_anim[guy[i].animname][anime])))
				doAnimation = true;
				
			
			if (doAnimation)
			{
				guy[i] animscripted( "looping anim", org, angles, level.scr_anim[guy[i].animname][anime][idleanim] );
				scriptedAnimationIndex = i;
	
				if (isdefined (level.scr_notetrack[guy[i].animname]))
					thread notetrack_wait (guy[i], "looping anim", tag_entity, anime);
				guy[i] thread animscriptDoNoteTracksThread("looping anim");
			}

			if ( (doFacialanim) || (doDialogue) )
			{
				if (doAnimation)
					guy[i] animscripts\face::SaySpecificDialogue(facialAnim, dialogue, 1.0);
				else
					guy[i] animscripts\face::SaySpecificDialogue(facialAnim, dialogue, 1.0, "looping anim");
					
				scriptedSoundIndex = i;
			}
		
			add_animation (guy[i].animname, anime);
		}
	
		if (scriptedAnimationIndex != -1)
			guy[scriptedAnimationIndex] waittillmatch ("looping anim", "end");
		else
		if (scriptedSoundIndex != -1)
			guy[scriptedSoundIndex] waittill ("looping anim");
	}
}

anim_single (guy, anime, tag, node, tag_entity)
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

	scriptedAnimationIndex = -1;
	scriptedSoundIndex = -1;
	for (i=0;i<guy.size;i++)
	{
		doFacialanim = false;
		doDialogue = false;
		doAnimation = false;
		
		if ((isdefined (level.scr_face[guy[i].animname])) &&
			(isdefined (level.scr_face[guy[i].animname][anime])))
		{
			doFacialanim = true;
			facialAnim = level.scr_face[guy[i].animname][anime];
		}

		if ((isdefined (level.scrsound[guy[i].animname])) && 
			(isdefined (level.scrsound[guy[i].animname][anime])))
		{
			doDialogue = true;
			dialogue = level.scrsound[guy[i].animname][anime];
		}

		if ((isdefined (level.scr_anim[guy[i].animname])) &&
			(isdefined (level.scr_anim[guy[i].animname][anime])))
			doAnimation = true;
	
		if (doAnimation)
		{
			guy[i] animscripted( "single anim", org, angles, level.scr_anim[guy[i].animname][anime] );
			scriptedAnimationIndex = i;

			if (isdefined (level.scr_notetrack[guy[i].animname]))
				thread notetrack_wait (guy[i], "single anim", tag_entity, anime);
			guy[i] thread animscriptDoNoteTracksThread("single anim");
		}
		
//		println ("^a SOUND time ", dialogue);
		if ( (doFacialanim) || (doDialogue) )
		{
			if (doAnimation)
				guy[i] animscripts\face::SaySpecificDialogue(facialAnim, dialogue, 1.0);
			else
				guy[i] animscripts\face::SaySpecificDialogue(facialAnim, dialogue, 1.0, "single anim");
				
			scriptedSoundIndex = i;
//			println ("facial sound ", dialogue);
		}
		add_animation (guy[i].animname, anime);
	}

	if (scriptedAnimationIndex != -1)
	{
		guy[scriptedAnimationIndex] endon ("death");
		thread anim_deathNotify(guy[scriptedAnimationIndex], anime);
		guy[scriptedAnimationIndex] waittillmatch ("single anim", "end");
	}
	else
	if (scriptedSoundIndex != -1)
	{
		guy[scriptedSoundIndex] endon ("death");
		thread anim_deathNotify(guy[scriptedSoundIndex], anime);
		guy[scriptedSoundIndex] waittill ("single anim");
	}
		
	self notify (anime);
	self notify (anime + "stop waiting for death");
}

anim_deathNotify ( guy, anime )
{
	self endon (anime + "stop waiting for death");
	guy waittill ("death");
	self notify (anime);
}

animscriptDoNoteTracksThread(animstring)
{
	self endon ("stop doing _anim notetracks");
	self endon ("death");
	animscripts\shared::DoNoteTracks(animstring);
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
		
//	if (guy.animname == "moody")
//		println ("MOODY ------------------------------");
	while (1)
	{
		guy waittill (msg, notetrack);
//		println (guy.animname, " received notetrack ", notetrack, " at ", gettime());
		dialogueNotetrack = false;
		if (notetrack == "end")
			return;
/*
		for (i=0;i<level.scr_notetrack[guy.animname].size;i++)
		{
			if (guy.animname != "moody")
				continue;

			println ("scanning notetrack ", level.scr_notetrack[guy.animname][i]["notetrack"], " but found notetrack #", i, ":", notetrack);
//			println (level.scr_notetrack[guy.animname][i]["dialogue"]);
		}
*/

		for (i=0;i<level.scr_notetrack[guy.animname].size;i++)
		{
//				println ("-------------\n^bscanning for notetrack ", level.scr_notetrack[guy.animname][i]["notetrack"], " but found notetrack #", i, ":", notetrack);
//			if (guy.animname == "foley")
//				println ("0000000000000000000000000000000000000000000000");

			if (notetrack == level.scr_notetrack[guy.animname][i]["notetrack"])
			{
				if (isdefined (level.scr_notetrack[guy.animname][i]["anime"]))
				{
					if (level.scr_notetrack[guy.animname][i]["anime"] != anime)
						continue;
				}

			
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

//				if (guy.animname == "moody")
//					println ("^bMatched Notetrack: ", notetrack);
					
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
					if (isdefined (level.scr_notetrack[guy.animname][i]["selftag"]))
						guy detach(level.scr_notetrack[guy.animname][i]["detach model"], level.scr_notetrack[guy.animname][i]["selftag"]);
					else
						tag_owner detach(level.scr_notetrack[guy.animname][i]["detach model"], level.scr_notetrack[guy.animname][i]["tag"]);
				}

//				playfxOnTag (level._effect["pistol"], guy, "TAG_WEAPON_RIGHT");
//				playfxOnTag (level._effect["pistol"], guy, "tag_flash");
				if (isdefined (level.scr_notetrack[guy.animname][i]["sound"]))
				{
					guy thread maps\_utility::playSoundOnTag (level.scr_notetrack[guy.animname][i]["sound"]);
//					println ("played sound ", level.scr_notetrack[guy.animname][i]["sound"]);
				}

				if (!dialogueNotetrack)
				{
//					if (guy.animname == "foley")
//						println ("doing dialogue.. ", level.scr_notetrack[guy.animname][i]["dialogue"]);
					
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
					
//					if (guy.animname == "foley")
//						println (level.scr_notetrack[guy.animname][i]["dialogue"]);
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
//					println ("played effect ", level._effect[level.scr_notetrack[guy.animname][i]["effect"]],
//					" on tag ", level.scr_notetrack[guy.animname][i]["selftag"]);
				}

				if ((isdefined (level.scr_notetrack[guy.animname][i]["tag"])) &&
				(isdefined (level.scr_notetrack[guy.animname][i]["effect"])))
				{
					playfxOnTag ( 
					level._effect[level.scr_notetrack[guy.animname][i]["effect"]], tag_owner, 
					level.scr_notetrack[guy.animname][i]["tag"] );
//					println ("played effect ", level._effect[level.scr_notetrack[guy.animname][i]["effect"]],
//					" on tag ", level.scr_notetrack[guy.animname][i]["tag"]);
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
			else
			if (notetrack == "anim_gunhand = \"left\"")
				guy animscripts\shared::putGunInHand ("left");
			else
			if (notetrack == "anim_gunhand = \"right\"")
				guy animscripts\shared::putGunInHand ("right");
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
	if (!isdefined (guy.ScriptModel))
		maps\_utility::Error ("Tried to remove a model with delete model before it was create model'd on guy: " + guy.animname);

	for (i=0;i<guy.ScriptModel.size;i++)
	{
		if (isdefined (array["explosion"]))
		{
			forward = anglesToForward(guy.scriptModel[i].angles);
			forward = maps\_utility::vectorScale (forward, 120);
			forward += guy.scriptModel[i].origin;
			playfx ( level._effect[array["explosion"]], guy.scriptModel[i].origin); //, guy.scriptModel.origin, forward );
		}
		guy.scriptModel[i] delete();
	}
}

anim_facial (guy, i, dialogueString)
{
	if (isdefined (level.scr_notetrack[guy.animname][i]["facial"]))
		facialAnim = level.scr_notetrack[guy.animname][i]["facial"];

	dialogue = level.scr_notetrack[guy.animname][i][dialogueString];
//	if (guy.animname == "foley")
//		println ("facial animation ", facialanim, " dialogue ", dialogue);
		
	guy animscripts\face::SaySpecificDialogue(facialAnim, dialogue, 1.0);
	level.scr_notetrack[guy.animname][i][dialogueString] = undefined;
}

gun_pickup_left ()
{
	if (!isdefined (self.gun_on_ground))
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;
//	println ("dropweapon is ", self.dropweapon);

	self animscripts\shared::putGunInHand ("left");
}

gun_pickup_right ()
{
	if (!isdefined (self.gun_on_ground))
		return;

	self.gun_on_ground delete();
	self.dropWeapon = true;
//	println ("dropweapon is ", self.dropweapon);
	
	self animscripts\shared::putGunInHand ("right");
}

gun_leave_behind (guy, scr_notetrack)
{
	if (isdefined (guy.gun_on_ground))
		return;

	link = true;

	if (self == guy)
		link = false;

	gun = spawn (getWeaponClassname (guy.weapon), (0,0,0));
	
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
	
	guy animscripts\shared::putGunInHand ("none");
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

	threads = 0;
	for (i=0;i<guy.size;i++)
	{
//		println ("guy is ", guy[0].animname, " anime is ", anime, " tag is ", tag);
		startorg = getstartOrigin (org, angles, level.scr_anim[guy[i].animname][anime]);
			
		guy[i] setgoalpos (startorg);
		threads++;
		guy[i] thread reach_goal_notify (ent);
	}
	
	while (threads)
	{
		ent waittill ("reach notify");
		threads--;
	}
	
	for (i=0;i<guy.size;i++)
		guy[i].goalradius = guy[i].oldgoalradius;
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

reach_death_notify (guy, ent)
{
	guy endon ("goal");
	guy waittill ("death");
	ent notify ("reach notify");
}

reach_goal_notify (ent)
{
	level thread reach_death_notify (self, ent);
	self.oldgoalradius = self.goalradius;
	self.goalradius = 0;
	self waittill ("goal");
//	self.goalradius = self.oldgoalradius;
	ent notify ("reach notify");
}

random (array)
{
	return array [randomint (array.size)];
}

printloops (guy, anime)
{
	wait (0.05);
	guy.loops++;
	if (guy.loops > 1)
		maps\_utility::error ("guy with name "+ guy.animname+ " has "+ guy.loops+ " looping animations played, anime: "+ anime);
}

looping_anim_ender (guy, ender)
{
	guy endon ("death");
	self waittill (ender);
	guy.loops--;
}

get_animtree ( guy )
{
	for (i=0;i<guy.size;i++)
		guy[i] UseAnimTree(level.scr_animtree[guy[i].animname]);
}

anim_single_solo (guy, anime, tag, node, tag_entity)
{
	newguy[0] = guy;
	anim_single (newguy, anime, tag, node, tag_entity);
}

anim_loop_solo ( guy, anime, tag, ender, node, tag_entity )
{
	newguy[0] = guy;
	anim_loop ( newguy, anime, tag, ender, node, tag_entity );
}

anim_single_solo_debug (guy, anime, tag, node, tag_entity)
{
	newguy[0] = guy;
	anim_single_debug (newguy, anime, tag, node, tag_entity);
}

anim_loop_solo_debug ( guy, anime, tag, ender, node, tag_entity )
{
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

lookat (ent, timer)
{
	if (!isdefined (timer))
		timer = 10000;
		
	self animscripts\shared::lookatentity(ent, timer, "alert");
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
	maps\_anim::anim_single (newguy, anime, tag, node, tag_entity);
	self._anim_solo_queue = undefined;
	self notify ("finished anim solo");
}