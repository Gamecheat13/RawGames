#include maps\_anim;
#using_animtree("generic_human");

main()
{	
	dialogue();
	run_anims();
}

dialogue()
{
	// ************************************************************************************
	// CHARACTER SPEECH
	// ************************************************************************************

	//"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	level.scr_sound[ "price" ][ "spreadout" ]			= "villagedef_pri_counterattackimminent";
	
	//"Any vehicles?"
	level.scr_sound[ "price" ][ "anyvehicles" ]		= "villagedef_pri_anyvehicles";

	//"OOOPEN FIRRRRRRE!!!!"
	level.scr_sound[ "price" ][ "openfire" ]			= "villagedef_pri_openfire";
	
	//"Grrrrraaaahhh!!!! Aaagh!"
	level.scr_sound[ "woundedguy" ][ "painscreams" ]	= "javelin_clu_aquiring_lock";
	
	//"I owe you one mate. Thanks for comin' back for me."
	level.scr_sound[ "woundedguy" ][ "oweyouone" ]	= "javelin_clu_aquiring_lock";
	
	// ************************************************************************************
	// RADIO SPEECH
	// ************************************************************************************

	//"Bell tower here. Two enemy squads forming up to the south."
	level.scr_radio[ "belltowerhere" ]					= "villagedef_sas1_belltowerhere";
	
	//"Negative. Wait - oh shit! Harris get ouuuuutt- (BOOM)"
	level.scr_radio[ "negativewait" ]						= "villagedef_sas1_negativewait";
	
	//"Shite! Parker and Harris are dead."
	level.scr_radio[ "parkerharrisdead" ]					= "villagedef_sas2_parkerandharrisdead";
	
	//"Sir, they're slowly coming up the hill. Just say when."
	level.scr_radio[ "justsaywhen" ]					= "javelin_clu_aquiring_lock";
	
	//"Do it."
	level.scr_radio[ "doit" ]							= "villagedef_pri_doit";
	
	//"Ka-boom."
	level.scr_radio[ "kaboom" ]						= "villagedef_sas2_kaboom";
	
	//"Target down."
	level.scr_radio[ "targetdown" ]					= "javelin_clu_aquiring_lock";
	
	//"Got him."
	level.scr_radio[ "gothim" ]						= "javelin_clu_aquiring_lock";
	
	//"Target eliminated."
	level.scr_radio[ "targeteliminated" ]				= "javelin_clu_aquiring_lock";
	
	//"Goodbye."
	level.scr_radio[ "goodbye" ]						= "javelin_clu_aquiring_lock";
	
	//"Sir, Ivan's bringin' in a recreational vehicle…"
	level.scr_radio[ "recreationalvehicle" ]			= "javelin_clu_aquiring_lock";
	
	//"Take it out."
	level.scr_radio[ "takeitout" ]					= "javelin_clu_aquiring_lock";
	
	//"With pleasure sir. Firing Javelin."
	level.scr_radio[ "firingjavelin" ]				= "javelin_clu_aquiring_lock";
	
	//"Nice shot mate."
	level.scr_radio[ "niceshotmate" ]					= "javelin_clu_aquiring_lock";
	
	//"Blast, I can't get a lock on the other one. Someone else'll have to do it."
	level.scr_radio[ "blastnolock" ]					= "javelin_clu_aquiring_lock";
	
	//"They're putting up smokescreens. Mac - you see anything?"
	level.scr_radio[ "smokescreensmac" ]				= "javelin_clu_aquiring_lock";
	
	//"Not much movement on the road. They might be moving to our west."
	level.scr_radio[ "notmuchmovement" ]				= "javelin_clu_aquiring_lock";
	
	//"Squad, hold your ground, they think we're a larger force than we really are."
	level.scr_radio[ "largerforce" ]					= "javelin_clu_aquiring_lock";
	
	//"Right. Soap, get to the minigun and cover the western flank. Go."
	level.scr_radio[ "minigunflank" ]					= "javelin_clu_aquiring_lock";
	
	//"Soap, get to the minigun! Move! It's attached to the crashed helicopter."
	level.scr_radio[ "miniguncrashed" ]				= "javelin_clu_aquiring_lock";
	
	//"Soap, I need you to operate the minigun! Get your arse moving!"
	level.scr_radio[ "minigunarse" ]					= "javelin_clu_aquiring_lock";
	
	//"Soap, they're already in the graveyard! Get on that bloody gun!"
	level.scr_radio[ "graveyard" ]					= "javelin_clu_aquiring_lock";
	
	//"Price moving."
	level.scr_radio[ "pricemoving" ]					= "javelin_clu_aquiring_lock";
	
	//"Two, falling back."
	level.scr_radio[ "twofallingback" ]				= "javelin_clu_aquiring_lock";
	
	//"Three, on the move."
	level.scr_radio[ "threeonthemove" ]				= "javelin_clu_aquiring_lock";
	
	//"Three here. Two's in the far eastern building. We've got the eastern road locked down."
	level.scr_radio[ "easternroadlocked" ]			= "javelin_clu_aquiring_lock";
	
	//"Copy that. I'll cover the center from the smoldering building."
	level.scr_radio[ "smoldering" ]					= "javelin_clu_aquiring_lock";
	
	//"Copy."	
	level.scr_radio[ "copy" ]							= "javelin_clu_aquiring_lock";
	
	//"Soap. Keep the minigun spooled up. Fire in bursts, 30 seconds max."
	level.scr_radio[ "spooledup" ]					= "javelin_clu_aquiring_lock";
	
	//"Here they come lads!"
	level.scr_radio[ "heretheycome" ]					= "javelin_clu_aquiring_lock";
	
	//"We've got a problem here...heads up!"
	level.scr_radio[ "headsup" ]						= "javelin_clu_aquiring_lock";
	
	//"Bloody hell, that's a lot of helis innit?"
	level.scr_radio[ "lotofhelis" ]					= "javelin_clu_aquiring_lock";
	
	//"Spread out. Don't stay in one spot too long and don't forget about the detonators at the windows. There's at least one in each building tied to a specific killzone."
	level.scr_radio[ "detonators" ]					= "javelin_clu_aquiring_lock";
	
	//"And one more thing - don't forget about the Mark-19. It's on the wall beneath the water tower."
	level.scr_radio[ "mark19" ]						= "javelin_clu_aquiring_lock";
	
	//"Enemy attack helicopter! Get to cover!!!"
	level.scr_radio[ "enemyattackhelo" ]				= "javelin_clu_aquiring_lock";
	
	//"Soap! Grab a Stinger missile and take it down!!!"
	level.scr_radio[ "grabstinger" ]					= "javelin_clu_aquiring_lock";
	
	//"Attack helicopter moving in!!! Take cover!!!"
	level.scr_radio[ "attackhelomoving" ]				= "javelin_clu_aquiring_lock";
	
	//"I've got him. Taking the shot!"
	level.scr_radio[ "takingtheshot" ]				= "javelin_clu_aquiring_lock";
	
	//"Enemy helicopter inbound! Take it out!"
	level.scr_radio[ "heloinbound" ]					= "javelin_clu_aquiring_lock";
	
	//"We have enemy tanks approaching from the north! (sounds of fighting for a second) Bloody hell I'm hit! Arrrgh - (static)"
	level.scr_radio[ "enemytanksnorth" ]				= "javelin_clu_aquiring_lock";
	
	//"Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks! Use the Javelins in the barn!"
	level.scr_radio[ "gettothebarn" ]					= "javelin_clu_aquiring_lock";
	
	//"Bravo Six, this is Gryphon Two-Seven. We've just crossed into Azerbaijani airspace. E.T.A. is six minutes. Be ready for pickup."
	level.scr_radio[ "etasixminutes" ]				= "javelin_clu_aquiring_lock";
	
	//"Bravo Six, we'll try to land in the fields at the northern end of the village."
	level.scr_radio[ "lzfields" ]						= "javelin_clu_aquiring_lock";
	
	//"Bravo Six, we're getting' a lot of enemy radar signatures, we'll try to land closer to the bottom of the hill to avoid a lock-on."
	level.scr_radio[ "lzbottomhill" ]					= "javelin_clu_aquiring_lock";
	
	//"Bravo Six, we're gonna try and touch down at the eastern tip of the village."
	level.scr_radio[ "lzeast" ]						= "javelin_clu_aquiring_lock";
	
	//"Bravo Six, be advised we are low on fuel. You guys have three minutes before we have to leave without you."
	level.scr_radio[ "threeminutesleft" ]				= "javelin_clu_aquiring_lock";
	
	//"Copy Two-Seven! Everyone - head for the landing zone! It's our last chance! Move!"
	level.scr_radio[ "headlandingzone" ]				= "javelin_clu_aquiring_lock";
	
	//"Two minutes people! We're already takin' some fire."
	level.scr_radio[ "twominutesleft" ]				= "javelin_clu_aquiring_lock";
	
	//"Ninety seconds to dustoff."
	level.scr_radio[ "ninetysecondsleft" ]			= "javelin_clu_aquiring_lock";
	
	//"This is Gryphon Two-Seven. We're at bingo fuel. We gotta leave in one minute."
	level.scr_radio[ "bingofueloneminute" ]			= "javelin_clu_aquiring_lock";
	
	//"Ah!!!! I'm hit!!! Bloody hell I'm hit!"
	level.scr_radio[ "bloodyhellimhit" ]				= "javelin_clu_aquiring_lock";
	
	//"We've got a man down! He's still alive! He's activated his transponder!"
	level.scr_radio[ "transponder" ]					= "javelin_clu_aquiring_lock";
	
	//"Soap, go get him if you can! We'll defend the helicopter and buy you some time!"
	level.scr_radio[ "buyyoutime" ]					= "javelin_clu_aquiring_lock";
	
	//"Forget about me! You won't make it back in time! Just go!"
	level.scr_radio[ "forgetaboutme" ]				= "javelin_clu_aquiring_lock";
	
	//"Ok we're outta here."
	level.scr_radio[ "outtahere" ]					= "javelin_clu_aquiring_lock";
	
	//"Baseplate this is Gryphon Two-Seven. We got 'em and we're comin' home. Out."
	level.scr_radio[ "cominhome" ]					= "javelin_clu_aquiring_lock";
}

run_anims()
{
	level.scr_anim[ "axis" ][ "patrolwalk_1" ] =			%active_patrolwalk_v1;
	level.scr_anim[ "axis" ][ "patrolwalk_2" ] =			%active_patrolwalk_v2;
	level.scr_anim[ "axis" ][ "patrolwalk_3" ] =			%active_patrolwalk_v3;
	level.scr_anim[ "axis" ][ "patrolwalk_4" ] =			%active_patrolwalk_v4;
	level.scr_anim[ "axis" ][ "patrolwalk_5" ] =			%active_patrolwalk_v5;
	level.scr_anim[ "axis" ][ "patrolwalk_pause" ] =		%active_patrolwalk_pause;
}
