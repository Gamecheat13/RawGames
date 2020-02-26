#include common_scripts\utility;
#include maps\_utility;

#define PERK_ICON_SIZE 		28
#define PERK_X_START		200
#define PERK_Y_START		186
#define PERK_DEFAULT_SLOTS	3
perks_preload()
{
//	precacheShader( "waypoint_bombsquad" );

	precacheShader( "perk_lightweight" );
	precacheShader( "perk_hacker" );
	precacheShader( "perk_ghost" );
	precacheShader( "perk_marathon" );
	precacheShader( "perk_marathon_pro" );
	precacheShader( "perk_flak_jacket" );
	precacheShader( "perk_deep_impact" );
	precacheShader( "perk_sleight_of_hand" );
	precacheShader( "perk_ninja" );
	
}

perk_init(ref,iconref)
{
	foreach (player in GetPlayers())
	{
		perk = spawnstruct();
		perk.ref 		= ref;
		perk.iconref 	= iconref;	
		player.perk_refs[player.perk_refs.size] = perk;
	}
}

perks_init(useHud)
{
	if(isDefined(level.sp_perks_initialized) )
		return;
		
	level.sp_perks_initialized 	= true;
	level.use_perk_hud 			= useHud;
	if (!isDefined(useHud))
	{
		level.use_perk_hud 		= false;
	}

	level.armorpiercing_data 	= 0.4;	// increased bullet damage by this %
	level.bulletdamage_data 	= 1.35;	// multipy damage by this	
	level.armorvest_data 		= .8;	// multipy damage by this	
	level.explosivedamage_data 	= 25;	// increased explosive damage by this %
	level.flakjacket_data 		= 35;// explosive damage is this % of original
	level.blink_warning			= 5000; //when perk is about to expire, blink
	level.icon_fullbright_alpha = 0.85;
	level.icon_halfbright_alpha = 0.20;
	
	if ( !isDefined(level.player_perk_slots) )
	{
		level.player_perk_slots	= PERK_DEFAULT_SLOTS;
	}
	
	foreach (player in GetPlayers())
	{
		player.perk_slots = [];
		player.perk_refs  = [];
		for (i=0;i<level.player_perk_slots;i++)
		{
			player.perk_slots[i] 			= spawnstruct();
			player.perk_slots[i].ref		= "";
			player.perk_slots[i].expire		= -1;
		}

		player thread maps\_perks_sp::perk_HUD();
		pos_x		= PERK_X_START - (level.player_perk_slots * PERK_ICON_SIZE) ;
		pos_y		= PERK_Y_START;
		for (i=0;i<level.player_perk_slots;i++)
		{
			player.perk_slots[i].pos_x		= pos_x;
			player.perk_slots[i].pos_y		= pos_y;
			player.perk_slots[i].icon_size	= PERK_ICON_SIZE;			// Width & height
			player.perk_slots[i].icon 		= undefined;//player special_item_hudelem( pos_x, pos_y );
			pos_x += PERK_ICON_SIZE + 2;
		}
	}
	
	
	perk_init("specialty_brutestrength",	"perk_lightweight");
	perk_init("specialty_intruder",			"perk_hacker");
	perk_init("specialty_trespasser",		"perk_ghost");
	perk_init("specialty_longersprint",		"perk_marathon");
	perk_init("specialty_unlimitedsprint",	"perk_marathon_pro");
	perk_init("specialty_endurance",		"perk_lightweight");
	perk_init("specialty_flakjacket",		"perk_flak_jacket");
	perk_init("specialty_deadshot",			"perk_deep_impact");
	perk_init("specialty_fastads",			"perk_deep_impact");
	perk_init("specialty_rof",				"perk_deep_impact");
	perk_init("specialty_fastreload",		"perk_sleight_of_hand");
	perk_init("specialty_fastweaponswitch",	"perk_ninja");
	perk_init("specialty_fastmeleerecovery","perk_ninja");
	perk_init("specialty_bulletdamage",		"perk_deep_impact");
	perk_init("specialty_armorvest",		"perk_flak_jacket");
	perk_init("specialty_detectexplosive",	"perk_hacker");
	perk_init("specialty_holdbreath",		"perk_hacker");

		
}

find_perk(ref)
{
	foreach (perk in self.perk_refs)
	{
		if ( perk.ref == ref )
			return perk;
	}
	
	return undefined;
}

find_free_slot()
{
	for(i=0;i<level.player_perk_slots;i++)
	{
		if ( self.perk_slots[i].ref == "" )
		{
			return i;
		}
	}
	return undefined;
}

find_slot_by_ref(ref)
{
	assert(isDefined(ref),"Invalid perk ref passed into find_slot_by_ref" + ref);
	
	for(i=0;i<level.player_perk_slots;i++)
	{
		if ( self.perk_slots[i].ref == ref )
		{
			return i;
		}
	}
	return undefined;
}


has_perk(ref)
{
	return (isDefined(find_slot_by_ref(ref)));
}

// gives perk to player, replace perk is optional
give_perk( give_ref )
{
	perk = self find_perk(give_ref);
	assert(isDefined(perk),"Undefined/unsupported perk. " + give_ref);
	
	if ( has_perk(give_ref) )//already have perk
		return true;

	if (!isDefined(self find_free_slot()))//no empty slots
		return false;
	
	slot = self find_free_slot();
	assert(isDefined(slot));

	self.perk_slots[slot].ref 		= give_ref;
	self.perk_slots[slot].expire 	= -1;

	if ( level.use_perk_hud )
	{
		if (!isDefined(self.perk_slots[slot].icon) )
		{
			self.perk_slots[slot].icon 		= self icon_hudelem( self.perk_slots[slot].pos_x, self.perk_slots[slot].pos_y );
			self.perk_slots[slot].icon.color	= ( 1, 1, 1 ); //( 1, 0.9, 0.65 );
		}
	
		self.perk_slots[slot].icon setShader( perk.iconref, self.perk_slots[slot].icon_size, self.perk_slots[slot].icon_size );
		self.perk_slots[slot].icon.alpha	= level.icon_fullbright_alpha;
		self.perk_slots[slot].icon.blink	= 0;
	}
	
	
	self SetPerk(give_ref);

	self notify( "give_perk", give_ref );
	self notify( "perk_update", give_ref );
	return true;
}

give_perk_for_a_time(give_ref, timeInSec)
{
	if ( self give_perk(give_ref) )
	{
		slot = find_slot_by_ref(give_ref);
		self.perk_slots[slot].expire = GetTime() + (timeInSec*1000);
		self thread perk_expire_watcher();
	}
}

perk_expire_watcher()
{
	self endon("death");
	self notify("perk_watcher");
	self endon("perk_watcher");
	
	done = false;
	waitdelay = 1;
	while(!done)
	{
		done = true;
		
		for(i=0;i<level.player_perk_slots;i++)
		{
			if (self.perk_slots[i].expire != -1 )
			{
				current_time = GetTime();

				if (isDefined(self.perk_slots[i].icon) )
				{
					time_left = self.perk_slots[i].expire - current_time;
					if ( time_left > level.blink_warning )
					{
						self.perk_slots[i].icon.alpha	= level.icon_fullbright_alpha;
					}
					else
					{
						self.perk_slots[i].icon.blink = !self.perk_slots[i].icon.blink;
						if ( self.perk_slots[i].icon.blink )
						{
							 self.perk_slots[i].icon.alpha = level.icon_fullbright_alpha;
						}
						else
						{
							 self.perk_slots[i].icon.alpha = level.icon_halfbright_alpha;
						}
						waitDelay = 0.5;
					}
				}
				
				done = false;
				if ( current_time > self.perk_slots[i].expire )
				{
					take_perk_by_slot(i);
				}
			}
		}
		wait (waitdelay);
	}
}

// if replacing perk, use give_perk( give, replace ) instead, dont call take_perk() then give_perk() immediately
take_perk( take_ref )
{
	assert(isDefined(self find_perk(take_ref)),"Undefined/unsupported perk." + take_ref);

	if ( !has_perk(take_ref) )//dont have perk
		return;

	slot = self find_slot_by_ref(take_ref);
	
	self.perk_slots[slot].ref = "";
	self.perk_slots[slot].expire = -1;
	if (isDefined(self.perk_slots[slot].icon) )
	{
		self.perk_slots[slot].icon maps\_hud_util::destroyElem();
		self.perk_slots[slot].icon = undefined;
	}
	
	
	self UnSetPerk( take_ref );
	
	self notify( "take_perk", take_ref );
	self notify( "perk_update", take_ref );
	wait 0.05;
}


take_perk_by_slot( slot )
{
	if ( self.perk_slots[slot].ref !="" )
		take_perk(self.perk_slots[slot].ref);
}

take_all_perks()
{
	foreach (perk in self.perk_refs)
	{
		self UnSetPerk( perk.ref );
	}
	for (i=0;i<level.player_perk_slots;i++ )
	{
		take_perk_by_slot(i);
	}
}

show_perks()
{
	for (i=0;i<level.player_perk_slots;i++ )
	{
		if ( isDefined(self.perk_slots[i].icon))
		    self.perk_slots[i].icon maps\_hud_util::showElem();
	}
	
}
hide_perks()
{
	for (i=0;i<level.player_perk_slots;i++ )
	{
		if ( isDefined(self.perk_slots[i].icon))
		    self.perk_slots[i].icon maps\_hud_util::hideElem();
	}
}

// ======================================================================
// HUD
// ======================================================================
update_on_give_perk()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "give_perk", ref );
		
		self flag_set( "HUD_giving_perk" );
		while ( self flag( "HUD_taking_perk" ) )
			wait 0.05;
		
		// play give perk animation on HUD
		
		
		wait 1;
		self flag_clear( "HUD_giving_perk" );
	}
}



update_on_take_perk()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "take_perk", ref );

		self flag_set( "HUD_taking_perk" );
		while ( self flag( "HUD_giving_perk" ) )
			wait 0.05;
					
		// remove perk animation on HUD
		
		
		wait 1;
		self flag_clear( "HUD_taking_perk" );
	}
}


perk_HUD()
{
	self endon( "death" );

	// self is player
	self flag_init( "HUD_giving_perk" );
	self flag_init( "HUD_taking_perk" );
	
	self thread update_on_give_perk();
	self thread update_on_take_perk();
		

	while ( 1 )
	{
		self waittill( "perk_update", ref );
		
		slot = self find_slot_by_ref(ref);
		if ( isDefined(slot) )
		{
		}
		else
		{
		}
	}
}

icon_hudelem( pos_x, pos_y )
{
	elem 				= NewClientHudElem( self );
	elem.hidden 		= false;
	elem.elemType 		= "icon";
	elem.hideWhenInMenu = true;
	elem.hidewheninscope= true;
	elem.archived 		= false;
	elem.x 				= pos_x;
	elem.y 				= pos_y;
	elem.alignx 		= "center";
	elem.aligny 		= "middle";
	elem.horzAlign 		= "center";
	elem.vertAlign 		= "middle";
	
	return elem;
}
