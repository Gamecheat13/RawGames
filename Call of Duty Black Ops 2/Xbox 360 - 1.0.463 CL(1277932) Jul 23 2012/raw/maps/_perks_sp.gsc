#include common_scripts\utility;
#include maps\_utility;

#define PERK_ICON_SIZE		28
#define PERK_X_START		200
#define PERK_Y_START		186
#define PERK_DEFAULT_SLOTS	3

perk_init( ref )
{
	foreach (player in GetPlayers())
	{
		perk = spawnstruct();
		perk.ref 		= ref;
		player.perk_refs[player.perk_refs.size] = perk;
	}
}

// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

initPerkDvars()
{
	level.cac_armorpiercing_data = cac_get_dvar_int( "perk_armorpiercing", "40" ) / 100;// increased bullet damage by this %
	level.cac_bulletdamage_data = cac_get_dvar_int( "perk_bulletDamage", "35" );		// increased bullet damage by this %
	level.cac_fireproof_data = cac_get_dvar_int( "perk_fireproof", "95" );				// reduced flame damage by this %
	level.cac_armorvest_data = cac_get_dvar_int( "perk_armorVest", "80" );				// multipy damage by this %	
	level.cac_explosivedamage_data = cac_get_dvar_int( "perk_explosiveDamage", "25" );	// increased explosive damage by this %
	level.cac_flakjacket_data = cac_get_dvar_int( "perk_flakJacket", "35" );			// explosive damage is this % of original
	level.cac_flakjacket_hardcore_data = cac_get_dvar_int( "perk_flakJacket_hardcore", "9" );	// explosive damage is this % of original for hardcore
}

perks_init(useHud)
{
	if(isDefined(level.sp_perks_initialized) )
		return;
		
	level.sp_perks_initialized 	= true;

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
		const pos_y		= PERK_Y_START;
		for (i=0;i<level.player_perk_slots;i++)
		{
			player.perk_slots[i].pos_x		= pos_x;
			player.perk_slots[i].pos_y		= pos_y;
			player.perk_slots[i].icon_size	= PERK_ICON_SIZE;			// Width & height
			player.perk_slots[i].icon 		= undefined;//player special_item_hudelem( pos_x, pos_y );
			pos_x += PERK_ICON_SIZE + 2;
		}
	}
	
	//perk_blind_eye   cross hair
	//perk_Fast_hands  gun
	//perk_hacker  laptop
	//perk_sp_bruteforce
	//perk_sp_fastreload
	//perk_sp_intruder
	//perk_sp_lockpick
	//perk_sp_steadyaim  crosshair on guy
	//
	perk_init( "specialty_brutestrength" );
	perk_init( "specialty_intruder" );
	perk_init( "specialty_trespasser" );
	perk_init( "specialty_longersprint" );
	perk_init( "specialty_unlimitedsprint" );
	perk_init( "specialty_endurance" );
	perk_init( "specialty_flakjacket" );
	perk_init( "specialty_deadshot" );
	perk_init( "specialty_fastads" );
	perk_init( "specialty_rof" );
	perk_init( "specialty_fastreload" );
	perk_init( "specialty_fastweaponswitch" );
	perk_init( "specialty_fastmeleerecovery" );
	perk_init( "specialty_bulletdamage" );
	perk_init( "specialty_armorvest" );
	perk_init( "specialty_detectexplosive" );
	perk_init( "specialty_holdbreath" );
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
	const waitdelay = 1;
	while(!done)
	{
		done = true;
		
		for(i=0;i<level.player_perk_slots;i++)
		{
			if (self.perk_slots[i].expire != -1 )
			{
				current_time = GetTime();

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
}
hide_perks()
{
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
