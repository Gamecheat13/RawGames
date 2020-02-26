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
	level.scr_sound[ "woundedguy" ][ "painscreams" ]	= "villagedef_sas2_agh";
	
	//"I owe you one mate. Thanks for comin' back for me."
	level.scr_sound[ "woundedguy" ][ "oweyouone" ]	= "villagedef_sas2_oweyouone";
	
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
	level.scr_radio[ "targetdown" ]					= "villagedef_sas3_targetdown";
	
	//"Got him."
	level.scr_radio[ "gothim" ]						= "villagedef_sas3_gothim";
	
	//"Target eliminated."
	level.scr_radio[ "targeteliminated" ]				= "villagedef_sas3_targeteliminated";
	
	//"Goodbye."
	level.scr_radio[ "goodbye" ]						= "villagedef_sas3_goodbye";
	
	//"Sir, Ivan's bringin' in a recreational vehicle…"
	level.scr_radio[ "recreationalvehicle" ]			= "villagedef_sas2_rv";
	
	//"Take it out."
	level.scr_radio[ "takeitout" ]					= "villagedef_pri_takeitout";
	
	//"With pleasure sir. Firing Javelin."
	level.scr_radio[ "firingjavelin" ]				= "villagedef_sas2_firingjavelin";
	
	//"Nice shot mate."
	level.scr_radio[ "niceshotmate" ]					= "villagedef_sas3_niceshot";
	
	//"Blast, I can't get a lock on the other one. Someone else'll have to do it."
	level.scr_radio[ "blastnolock" ]					= "villagedef_sas2_cantgetlock";
	
	//"Squad, hold your ground, they think we're a larger force than we really are."
	level.scr_radio[ "largerforce" ]					= "villagedef_pri_holdground";
	
	//"Copy."	
	level.scr_radio[ "copy" ]							= "villagedef_sas3_copy";
	
	//"They're putting up smokescreens. Mac - you see anything?"
	level.scr_radio[ "smokescreensmac" ]				= "villagedef_sas2_smokescreens";
	
	//"Not much movement on the road. They might be moving to our west."
	level.scr_radio[ "notmuchmovement" ]				= "villagedef_sas4_toourwest";

	//"They're targeting our position with mortars. It's time to fall back."
	level.scr_radio[ "targetingour" ]				= "villagedef_gaz_fallback";
	
	//"Right. Soap, get to the minigun and cover the western flank. Go."
	level.scr_radio[ "minigunflank" ]					= "villagedef_pri_coverwestflank";
	
	//"Soap, get to the minigun! Move! It's attached to the crashed helicopter."
	level.scr_radio[ "miniguncrashed" ]				= "villagedef_pri_gettominigun";
	
	//"Soap, I need you to operate the minigun! Get your arse moving!"
	level.scr_radio[ "minigunarse" ]					= "villagedef_pri_arsemoving";
	
	//"Two, falling back."
	level.scr_radio[ "twofallingback" ]				= "villagedef_sas2_fallingback";
	
	//"Three, on the move."
	level.scr_radio[ "threeonthemove" ]				= "villagedef_sas3_onmove";
	
	//"Three here. Two's in the far eastern building. We've got the eastern road locked down."
	level.scr_radio[ "easternroadlocked" ]			= "villagedef_sas3_roadlocked";
	
	//"Soap, they're already in the graveyard! Get on that bloody gun!"
	level.scr_radio[ "graveyard" ]					= "villagedef_pri_ingraveyard";
	
	//"Soap. Keep the minigun spooled up. Fire in bursts, 30 seconds max."
	level.scr_radio[ "spooledup" ]					= "villagedef_pri_fireinbursts";
	
	//"Here they come lads!"
	level.scr_radio[ "heretheycome" ]					= "villagedef_pri_heretheycome";
	
	//"We've got a problem here...heads up!"
	level.scr_radio[ "headsup" ]						= "villagedef_sas2_headsup";
	
	//"Bloody hell, that's a lot of helis innit?"
	level.scr_radio[ "lotofhelis" ]					= "villagedef_sas3_lotofhelis";
	
	//"Soap, fall back to the tavern and man the detonators. Move."
	level.scr_radio[ "tavern" ]					= "javelin_clu_lock";
	
	//"The rest of us will keep them busy from the next defensive line. Everyone move!"
	level.scr_radio[ "nextdefensiveline" ] 		= "javelin_clu_lock";
	
	//"Spread out. Don't stay in one spot too long and don't forget about the detonators at the windows. There's at least one in each building tied to a specific killzone."
	level.scr_radio[ "detonators" ]					= "villagedef_pri_spreadout";
	
	//"And one more thing - don't forget about the Mark-19. It's on the wall beneath the water tower."
	level.scr_radio[ "mark19" ]						= "villagedef_pri_onthewall";
	
	//"Enemy attack helicopter! Get to cover!!!"
	level.scr_radio[ "enemyattackhelo" ]				= "villagedef_pri_attackheli";
	
	//"Soap! Grab a Stinger missile and take it down!!!"
	level.scr_radio[ "grabstinger" ]					= "villagedef_pri_takeitdown";
	
	//"Attack helicopter moving in!!! Take cover!!!"
	level.scr_radio[ "attackhelomoving" ]				= "villagedef_pri_takecover";
	
	//"I've got him. Taking the shot!"
	level.scr_radio[ "takingtheshot" ]				= "villagedef_sas2_ivegothim";
	
	//"Enemy helicopter inbound! Take it out!"
	level.scr_radio[ "heloinbound" ]					= "villagedef_pri_heliinbound";
	
	//"We have enemy tanks approaching from the north! (sounds of fighting for a second) Bloody hell I'm hit! Arrrgh - (static)"
	level.scr_radio[ "enemytanksnorth" ]				= "villagedef_sas4_imhit";
	
	//"Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks! Use the Javelins in the barn!"
	level.scr_radio[ "gettothebarn" ]					= "villagedef_pri_stoptanks";
	
	//"Enemy MiGs flying close-air support! We've got to get clear of this area before they call an airstrike on us!"
	level.scr_radio[ "enemymigsupport" ]					= "javelin_clu_lock";
	
	//"Gaz is right! We're sitting ducks for those MiGs! We've got to break out to the south, now!"
	level.scr_radio[ "sittingducks" ]					= "javelin_clu_lock";
	
	//"Another enemy airstrike on the way! Get to cover!!!"
	level.scr_radio[ "anotherstrike" ]					= "javelin_clu_lock";
	
	//"More MiGs! Take cover!"
	level.scr_radio[ "moremigs" ]					= "javelin_clu_lock";
	
	//"The MiGs are gonna come back to make another pass! Get to cover!"
	level.scr_radio[ "gonnacomeback" ]					= "javelin_clu_lock";
	
	//"Enemy airstrike is inbound. Get clear! Move!"
	level.scr_radio[ "strikeinbound" ]					= "javelin_clu_lock";
	
	//"Bravo Six, this is Gryphon Two-Seven. We've just crossed into Azerbaijani airspace. E.T.A. is six minutes. Be ready for pickup."
	level.scr_radio[ "etasixminutes" ]				= "villagedef_hp2_etasixmins";
	
	//"Bravo Six, we'll try to land in the fields at the northern end of the village."
	level.scr_radio[ "lzfields" ]						= "villagedef_hp2_landinfields";
	
	//"Bravo Six, we're getting' a lot of enemy radar signatures, we'll try to land closer to the bottom of the hill to avoid a lock-on."
	level.scr_radio[ "lzbottomhill" ]					= "villagedef_hp2_enemyradar";
	
	//"Bravo Six, we're gonna try and touch down at the eastern tip of the village."
	level.scr_radio[ "lzeast" ]						= "villagedef_hp2_touchdown";
	
	//"Bravo Six, be advised we are low on fuel. You guys have three minutes before we have to leave without you."
	level.scr_radio[ "threeminutesleft" ]				= "villagedef_hp2_lowonfuel";
	
	//"Copy Two-Seven! Everyone - head for the landing zone! It's our last chance! Move!"
	level.scr_radio[ "headlandingzone" ]				= "villagedef_pri_lastchance";
	
	//"Two minutes people! We're already takin' some fire."
	level.scr_radio[ "twominutesleft" ]				= "villagedef_hp2_twomins";
	
	//"Ninety seconds to dustoff."
	level.scr_radio[ "ninetysecondsleft" ]			= "villagedef_hp2_ninetysecs";
	
	//"This is Gryphon Two-Seven. We're at bingo fuel. We gotta leave in one minute."
	level.scr_radio[ "bingofueloneminute" ]			= "villagedef_hp2_bingofuel";
	
	//"Ah!!!! I'm hit!!! Bloody hell I'm hit!"
	level.scr_radio[ "bloodyhellimhit" ]				= "villagedef_sas2_imhim";
	
	//"We've got a man down! He's still alive! He's activated his transponder!"
	level.scr_radio[ "transponder" ]					= "villagedef_sas3_mandown";
	
	//"Soap, go get him if you can! We'll defend the helicopter and buy you some time!"
	level.scr_radio[ "buyyoutime" ]					= "villagedef_pri_gettohim";
	
	//"Forget about me! You won't make it back in time! Just go!"
	level.scr_radio[ "forgetaboutme" ]				= "villagedef_sas2_justgo";
	
	//"Ok we're outta here."
	level.scr_radio[ "outtahere" ]					= "villagedef_hp2_outtahere";
	
	//"Baseplate this is Gryphon Two-Seven. We got 'em and we're comin' home. Out."
	level.scr_radio[ "cominhome" ]					= "villagedef_hp2_cominhome";
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
