/****************************************************************************

Level: 		The Village (village_defend.bsp)
Location:	Northern Azerbaijan
Campaign: 	British SAS Woodland Scheme
Objectives:	1. Obtain new orders from Captain Price. (filler objective for the dead time at the start of the level)
			2. Take up a defensive position along the ridgeline.
			3. Defend the southern hill approach. (note: level does not progress without player participation)
			4. Fall back and defend the southwestern approaches. (note: level does not progress without player participation)
			5. Survive until the exfiltration force arrives. (Time Remaining: ~6 minutes, freeform gameplay)
			6. Destroy the enemy attack helicopter. (Appearing/Disappearing recurring objective X 4, optional but accumulates)
			7. Board the rescue helicopter before it leaves. (achievement for carrying a buddy back to the helo)

Planning Movie:
	Explosives diagramming
	
1. Hill defend
2. Minigun unlock
3. Clacker unlock 
4. Javelin objective
5. Airstrike unlock
6. Gunship support unlock
7. Get knocked out | fade in-out of consciousness | carried by Captain Price to respawn point
8. High Speed Team Deathmatch for X minutes | enemy helicopter inbound (AI hides in buildings until heli is destroyed or leaves)
	- You get two lives before you die for real ("it's just a flesh wound"); you pass out and wake up in a totally different spot
	- access to more clackers throughout the level
	- by killing N enemies you unlock:
	- access to more airstrikes (glowing spots that activate on lookat when player uses some D-pad control to activate airstrike targeting)
		"Airstrike standing by."
	- access to more helicopter gunship support
		"Helicopter gunship standing by."			
		- only suicide assault groups will actually close and chase the player to his origin.
10. Friendly helicopter arrives, make the run for it, go back for the incapacitated friendly and get in the chopper, escape.

Start:
	
	1. The Intro and the Exploding Bell Tower
	
	Russian Loudspeaker: "Foreign soldiers, surrender at once and you will be spared. I am sure you will make the right choice given your situation."
	
	Russian Loudspeaker: "Drop your weapons and surrender at once. This is your last chance..."

	Price:	"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	Redshirt: 	(radio) "Bell tower here. Two enemy squads forming up to the south."
	Price:	"Any vehicles?"
	Redshirt:	(radio) "Negative. Wait - oh shit! Harris get ouuuuutt-"(BOOM) 
	
	Bell tower explodes.
	
	sasGunner:	(radio) "Shit. Parker and Harris are dead. Sir, they're slowly coming up the hill. Just say when."
	
	Barbed wire barricade all around the top of the ridge so player can't go down to the river yet.
	
	2. The Southern Hill Ambush
	
	Price:	(radio) "Do it." (radio/live conditional on distance), arriving at the fence.
	sasGunner:	"Ka-boom."
	
	Electronic beeping from explosive devices planted on the hill.
	
	Russians:	"what the hell?" "huh?" "What was that?"
	
	Line of explosives detonates!!! 
	
	Price:	"OOOPEN FIRRRRRRE!!!!"
	
	SAW opens fire across hill, tracer madness. Sniper fire madness.
	
	Lazyboy:	(radio) "Target down."
	Lazyboy:	(radio) "Got him."
	Lazyboy:	(radio)	"Target eliminated."
	Lazyboy:	(radio)	"Goodbye."
	
	sasGunner:	(radio) "Sir, Ivan's bringin' in a recreational vehicle..."
	
	Price: (radio) "Take it out."
	
	sasGunner:	(radio) "With pleasure sir. Firing Javelin!"
	
	Javelin leaps into sky and drops onto tank at base of hill by gas station.
	
	Lazyboy: 	"Nice shot mate."
	
	sasGunner: "Blast, can't get a lock on the other one. Someone else'll have to do it."
	
	SAS3:	"Movement on the road."
	
	Price: "Squad, hold your ground, we'll make 'em think we're a larger force than we really are."
	
	Tracking player killcount and time elapsed, about two minutes and 40 kills. 
	Smoke only on right side of hill approach, enemy still trying to go left. Friendlies fight forever against these dudes.
	
	sasGunner: 	"They're putting up smokescreens. Mac - you see anything?"
	
	Mac:	"Not much movement on the road. They might be moving to our west."
	
	3. Falling Back to The Minigun
	
	Price:	"Right. Soap, get to the minigun and cover the western flank. Go." (radio/live contingent on range)
	Price:	"Soap, get to the minigun! Move! It's attached to the crashed helicopter." (radio/live contingent on range)
	Price:	"Soap, I need you to operate the minigun! Get your arse moving!" (radio/live contingent on range)
	
	Game plays endlessly until player gets onto the minigun while enemies run up the hill on the left side.
	
	Player nears the minigun where he can't see over the helicopter at the graveyard.
	
	Price:	(radio)"Soap, they're already in the graveyard! Get on that bloody gun!"
	
	Player gets on the minigun. 
	
	Price and company start moving back.
	
	Price:	(radio) "Price moving."
	
	Price moves to the smoldering building.
	
	sasGunner:	(radio) "Two, falling back."
	
	sasGunner with the SAW moves to the open hut building and sets up and starts mowing drones there.
	
	Lazyboy:(radio)"Three, on the move."
	
	Lazyboy goes to where the player is and covers his back with his own M21 sniper rifle.
	
	Lazyboy:(radio)"Lazyboy here. sasGunner's in the far eastern building. We've got the eastern road locked down."
	
	Price:	(radio)"Copy that. I'll cover the center from the smoldering building."
	
	Lazyboy:(radio)"Copy."
	
	Lazyboy:"Oi! Soap! Keep the minigun spooled up! Fire in short controlled bursts! 30 seconds max!"

	4. Minigun Action and Second Wave Defense

	Barbed wire explodes on hill so enemies can come in. 
	
	Price: (radio) "Here they come lads!"
	
	Tracking player killcount and time elapsed, about two minutes and 80 kills, otherwise no progression.
	Enemies running across at right angles to minigun axis, always trying to outflank visually.
	Player can jump off the minigun but it makes it harder.
	Drones to the east until player gets too close.
	
	Smokescreen forms across minigun field of fire.
	
	5. The Independence Day Deployment
	
	sasGunner: 	(radio) "We've got a problem here...heads up!"
	
	Music, helicopter UFOs, Independence Day moment.
	
	Lazyboy:	(radio) "Bloody hell, that's a lot of helos innit?"
	
	Price: (radio) "Spread out. Don't stay in one spot too long and don't forget about the demo charges."
	
	sasGunner:	(radio) "Yeah, use the detonators at the windows. There's at least one in each building tied to a particular killzone."
	sasGunner:	(radio) "Oh and one more thing - don't forget about the Mark-19. It's on the wall beneath the water tower."
	
	6. The Blender
	
	Helicopter drops of enemies, plus some magic spawning of enemies in convenient locations.
	Enemy breach and clear of buildings.
	Enemy magic spawn and magic grenading of building hiding spots.
	Enemy chase down player and his buddies but need a special spread-out function for goalentitying to player to avoid man-trains.
	Smokescreens with hunter-killer parties moving at right angles and flanking the player.
	
	KA-50 Hokum attack helicopter comes in periodically to kill the player with guns and rockets.
	KA-50 Hokum attack helicopter shoots and blows up chunks of buildings where the player is likely to hide.
	
	Price: (radio) "Enemy attack helo! Get to cover!!!"
	Price: (radio) "Soap! Grab a Stinger missile and take it down!!!"
	
	Stinger missiles.
	
	ZSU AA missile batteries.
	
	Window based diagrammed killzone detonators.
	Mark-19 automatic grenade launcher.
	Minigun.
	RPGs.
	
	7. The Javelin Field
	
	Before the player can reach the barn...trigger activated or time based if not triggered, for thirty seconds in.
	
	Mac:	"We have enemy tanks approaching from the north! (sounds of fighting for a second) Fuck I'm hit! Aaaa!!!! (static)"
	
	Price: "Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks!"
	
	Javelins against enemy tanks near the barn.
	
	Price is secretly deleted at this point so that he can be at the helicopter first at the end.
	
	~5 seconds after the Javelin objective, the radio comes on.
	
	8. The Countdown
	
	Friendlies stay between 800 and 1600 units of the player at all times.
	Friendlies have extra health and don't die easily. Also respawn new ones secretly.
	
	Helicopter Pilot: (radio) "Bravo Six, this is Gryphon Two-Seven. We're your ticket outta there.
	We've just crossed into Azerbaijani airspace. E.T.A. Six minutes. Be ready for pickup."
	
	Start the visible countdown.
	
	9. The Sea Knight Arrives
	
	The Sea Knight will choose the least convenient location relative to the player.
	
	Helicopter Pilot: (radio) "Bravo Six, we'll try to land in the fields at the northern end of the village. You gotta secure that LZ
	before we can touch down over."
	
	Helicopter Pilot: (radio) "Bravo Six, we'll try to land closer to the bottom of the hill to keep a low radar profile."
	
	Helicopter Pilot: (radio) "Bravo Six, we're gonna try and touch down at the eastern tip of the village."
	
	8. Get To The Choppah
	
	Helicopter Pilot: (radio) "And be advised we are low on fuel. You guys have three minutes before we have to leave without you."
	
	Music starts.
	
	New 'time to dustoff' countdown appears.
	
	Price:	(radio) "Copy Two-Seven! Everyone - head for the landing zone! It's our last chance! Move!"
	
	Helicopter Pilot: (radio) "Ninety seconds to dustoff."
	
	Helicopter Pilot: (radio) "This is Gryphon Two-Seven. We're at bingo fuel. We gotta leave in one minute."
	
	9. Leave No Man Behind?
	
	As the player gets close to the helicopter...about 1000 units away.
	
	The rest are fighting. 
	
	SAS2:	(radio) "Ah!!! I'm hit!!! Fuck!!!" 

	SAS3:	(radio) "We've got a man down! He's still alive! He's activated his transponder!"
	
	Compass objective location changes to the man's location.
	
	Price:	(radio) "Soap, go get him if you can! We'll defend the helicopter and buy you some time!"
	
	SAS2: 	(radio) "Forget about me! You won't make it back in time! Just go!"
	
	SAS2: 	"Grrrrraaaahhh!!!! Aaagh!"
	
	10. Departure
	
	The Sea Knight leaves and locks the player inside as soon as he gets far enough inside of it.
	
	Helicopter Pilot: (radio) "Ok we're outta here."
	
	It's very tightly timed. If the player rescued the fallen buddy and carried him back, the fallen buddy says,
	
	SAS2: "I owe you one mate. Thanks for comin' back for me." Achievement unlocked.
	
	Helicopter Pilot: (radio) "Baseplate this is Gryphon Two-Seven. We got 'em and we're comin' home. Out."

Moments:

	- Church tower blows up ("Parker get ouutt!!!!")
	- Ultranationalists use megaphones from helicopters to convince the player's team to surrender after 1st obj, and then...
	- Independence Day helicopter swarm dropping troops into the level all around, music
	- Enemy attack helicopter shooting buildings and breaking them where player is hiding
	- UAZ jeeps and BMPs driving in and unloading troops
	- Friendly troops emerge from back of Sea Knight and then run back on board before it leaves
	- Sea Knight lands in unpredictable location far from the player due to "it's too hot" and player has to run for it, music
	- Enemy troops heard squawking through radios before storming buildings the player is hiding inside of
	- Enemy troops flashbanging and storming buildings the player is hiding inside of
	- Man down and transponder on
	- Sea Knight leaves with rear door closing if player doesn't make it
	
	Survival Mode Extreme Edition - Surrender or Die!

	1. Features (memory is a problem)
	
		Helicopters:
		
		- unarmed enemy MI-17 transport helicopters with fastrope deployments
		- armed enemy KA-50 attack helicopters doing ground attack with rockets and machine guns against the player
			- blow holes in buildings that the player is hiding inside of, preceded by nearby enemy radio voice cues
		- shooting down KA-50 and MI-17 helicopters with RPGs and/or Stingers
		- KA-50 and MI-17 helicopters crashing outside of the level, out of sight
		- Sea Knight arrives and opens rear door to let people on board
		- Sea Knight has side door gunner(s) firing mounted guns
		
		Ground Vehicles:
		
		- BMP with soldiers unloading from them
		- BMP gets destroyed by minigun, RPG, AT/4
		- T-72 gets destroyed by Javelin
		- UAZ jeeps with soldiers unloading from them
		
		Minigun:
		
		- mounted minigun capable of shooting down helicopters and destroying ground vehicles 
			- winds up to full rotational speed with left trigger, then starts to fire bullets with right trigger
			- overheats after 30 seconds of sustained fire, so you have to control your firing, but can keep it spooled up
			- unlimited ammo
		
		Mk-19 Automatic Grenade Launcher Turret:
			- behaves like a fully automatic M203 in turret form
			- grenades fire with an arc like the M203
			- unlimited ammo
			
		Preplanned Explosive Killzones:
		
		- preplanned explosive detonator switches and marked killzones 
			- special textures showing hand drawn top down diagrams of the killzones next to each detonation station
			- players have to figure it out and learn the level by playing it
			- one detonator clacker per window+diagram combo
			- some scripted moments where AI out of player's sight report on the radio and the killzone explodes automatically
			
		Player Weapons Caches:
		
		- weapons caches (RPGs/Stingers, Machine Guns, Sniper Rifles, Submachine Guns, Novelty Weapons, Various Grenades) 
	
	2. Story integration
		- Al-Asad gets killed at the outset
		- Al-Asad must survive
	
	3. Player falling back early
		- make the battle indefinite until the player meets a participation metric like pegasusday
		- the timer doesn't start until later in the level when they receive a radio transmission from HQ
	
	4. Player not falling back at all or staying on the minigun forever
		- activate smokescreens for the enemy to run through
	
	5. Player hiding in a corner waiting for the timer to run out
		- solve this by having AI track down the player
			- manual player location volume detection for each building
				- use nearby custom spawners for known hiding locations
				- flashbang and clear rooms and kill player
				- magic grenade spam through windows where player is hiding
			- automatic player goalentitying for outdoor hiding spots
				- player execution routine for AI in both indoor and outdoor spots
				- use helicopters to flush out player in outdoor hiding places without top cover
		
Rules used in Pegasusday:
	1. The first battle would go on forever until the player satisfied a participation metric - X kills && X time elapsed.
		- didn't matter how far away he was, could snipe from far away if he wanted to
		- the player could run away but would encounter token resistance away from the main battle
			- token resistance spawned rarely to make it clear where the main battle was
	2. The fall back to the machine gun and cover the squad objective was required, or the war would go on indefinitely.
	3. The timer starts when the player is going to be attacked from all sides.
	4. Enemy threat escalates to introduce tanks which have several ways of killing the player caught in the open.
		- These are not required to win but are presented as optional objectives
		- They accumulate but do not display a count remaining on the objective text
		- The player has several options built into the level with which to destroy the tanks.
			- Fixed weapon
			- Normal anti-tank weapons
	5. There are almost no perfect hiding places where the player is safe with his back to a wall. Maybe the guard hut.

//enemy_heli_reinforcement_shoulder
//enemy_heli_reinforcement_barncenter
//enemy_heli_reinforcement_parkinglot
//enemy_heli_reinforcement_barnleft
//enemy_heli_reinforcement_cowfield

*****************************************************************************/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;

main()
{
	preCacheModel( "weapon_c4" );
	preCacheModel( "projectile_cbu97_clusterbomb" );
	preCacheItem( "c4" );
	preCacheItem( "javelin" );
	
	set_console_status();

	//add_start( "cobras", ::start_cobras );
	//add_start( "end", ::start_end );
	add_start( "southern_hill", ::start_southern_hill );
	add_start( "minigun_fallback", ::start_minigun_fallback );
	add_start( "minigun", ::start_minigun );
	add_start( "helidrop", ::start_helidrop );
	add_start( "clackers", ::start_clackers );
	add_start( "field_fallback", ::start_field_fallback );
	add_start( "javelin", ::start_javelin );
	default_start( ::start_village_defend );
	
	createthreatbiasgroup( "player" );
	
	maps\_t72::main( "vehicle_t72_tank_woodland" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_mig29::main( "vehicle_mig29_desert" );
	
	maps\village_defend_fx::main();
	maps\village_defend_anim::main();
	maps\_load::main();	
	maps\_javelin::init();
	level thread maps\village_defend_amb::main();	

	level.killzoneBigExplosion_fx = loadfx( "explosions/artilleryExp_dirt_brown" );
	level.killzoneMudExplosion_fx = loadfx( "explosions/grenadeExp_mud_1" );
	level.killzoneDirtExplosion_fx = loadfx( "explosions/grenadeExp_dirt_1" );
	level.killzoneFuelExplosion_fx = loadfx( "explosions/grenadeExp_fuel" );

	killzoneFxProgram();

	maps\createart\village_defend_art::main();	

	maps\_compass::setupMiniMap("compass_map_village_defend");
	
	level.price = getent( "price", "targetname" );
	level.price make_hero();
	level.price.animname = "price";
	
	battlechatter_off( "allies" );
	battlechatter_off( "axis" );
	
	flag_init( "intro_tank_fire_authorization" );
	flag_init( "church_tower_explodes" );
	flag_init( "stop_ambush_music" );
	
	flag_init( "objective_price_orders_southern_hill" );
	flag_init( "objective_player_on_ridgeline" );
	flag_init( "objective_price_on_ridgeline" );
	flag_init( "objective_on_ridgeline" );
	flag_init( "objective_price_orders_minigun" );
	flag_init( "objective_player_uses_minigun" );
	
	flag_init( "southern_hill_action_started" );
	flag_init( "southern_hill_killzone_detonate" );
	flag_init( "southern_mg_openfire" );
	
	flag_init( "southern_hill_smoked" );
	flag_init( "southern_hill_smoke_entry" );
	flag_init( "enemy_breached_wire" );
	
	flag_init( "ridgeline_targeted" );
	flag_init( "ridgeline_unsafe" );
	
	flag_init( "helidrop_started" );
	flag_init( "objective_minigun_baglimit_done" );
	flag_init( "divert_for_clacker" );
	
	flag_init( "objective_detonators" );
	flag_init( "detonators_activate" );
	
	flag_init( "crashsite_exploded" );
	flag_init( "cliffside_exploded" );
	flag_init( "nearslope_exploded" );
	flag_init( "farslope_exploded" );
	flag_init( "clacker_far_and_near_slope_done" );
	
	flag_init( "spawncull" );
	flag_init( "player_entered_clacker_house_top_floor" );
	
	flag_init( "fall_back_to_barn" );
	flag_init( "objective_armor_arrival" );

	flag_init( "got_the_javelin" );
	flag_init( "objective_all_tanks_destroyed" );
	
	flag_init( "start_final_battle" );
	
	level.gameSkill = getdvarint("g_gameskill");
	
	if (level.gameSkill == 0)
	{
		level.southernHillAdvanceBaglimit = 10;
		level.minigunBreachBaglimit = 18;
	}
	
	if (level.gameSkill == 1)
	{
		level.southernHillAdvanceBaglimit = 12;
		level.minigunBreachBaglimit = 24;
	}
	
	if (level.gameSkill == 2)
	{
		level.southernHillAdvanceBaglimit = 14;
		level.minigunBreachBaglimit = 30;
	}
	
	if (level.gameSkill == 3)
	{
		level.southernHillAdvanceBaglimit = 18;
		level.minigunBreachBaglimit = 34;
	}
	
	level.stopwatch = 6;	//minutes
	
	level.encroachMinWait = 3;
	level.encroachMaxWait =	5;
	assertEX( level.encroachMinWait < level.encroachMaxWait, "encroachMinWait must be less than encroachMaxWait!" );
	
	level.magicSniperTalk = true;
	level.southern_hill_magic_sniper_min_cycletime = 5;
	level.southern_hill_magic_sniper_max_cycletime = 15;
	
	level.southernMortarIntroTimer = 3.5; //this many seconds before Price mentions mortars and order the team to pull back
	level.southernMortarKillTimer = 25;	//this many seconds before player is struck by enemy mortars in the ridgeline area
	
	level.genericBaitCount = 0;	//circulates spare enemies to the clacker bait locations for the clacker objective
	
	level.irrelevantDist = 1000;
	level.irrelevantPopLimit = 8;
	
	level.divertClackerRange = 1000;	//distance beyond which enemies will break off attacking the player and move to a prearranged spot
	level.encroachRate = 0.85;			//percentage of goal reduction per encroaching iteration
	
	level.objectiveClackers = 0;
	level.tankPop = 4;
	level.tankid = 0;
	
	//Primary Zone Spawn Controllers
	
	level.maxAI = 32;
	level.reqSlots = 8;
	level.detectionCycleTime = 45;
	level.smokeBuildTime = 5;
	level.smokeSpawnSafeDist = 512;
	level.detectionRefreshTime = 3;
	level.volumeDesertionTime = 6;
	
	//Airstrike Controllers
	
	level.strikeZoneGracePeriod = 20;
	level.airstrikeCooldown = 135;
	level.dangerCloseSafeDist = 1200;
	
	level thread objectives();
	level thread magic_sniper();
	level thread southern_hill_ambush_mg();
	level thread southern_hill_vanguard_setup();
	level thread friendly_setup();
	level thread helidrop();
	level thread clacker_init();
	level thread clacker_primary_attack();
	level thread javelin_init();
	level thread tanks_init();
	level thread barn_helidrop();
	level thread field_fallback();
	level thread barn_fallback();
	
	level thread final_battle();
	
	level thread player_detection_volume_init();
	
	level thread music();
}

start_village_defend()
{
	thread intro();
	level.start_intro = true;
	
	level.player setthreatbiasgroup( "player" );
	
	setignoremegroup( "axis", "allies" );	// allies ignore axis
	setignoremegroup( "allies", "axis" ); 	// axis ignore allies
	setignoremegroup( "player", "axis" );	// axis ignore player
}

start_southern_hill()
{
	level.player setthreatbiasgroup( "player" );
	
	setignoremegroup( "axis", "allies" );	// allies ignore axis
	setignoremegroup( "allies", "axis" ); 	// axis ignore allies
	setignoremegroup( "player", "axis" );	// axis ignore player
	
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_player_on_ridgeline" );
	//flag_set( "objective_price_on_ridgeline" );
	flag_set( "objective_on_ridgeline" );
	
	playerStart = getnode( "player_southern_start", "targetname" );
	level.player setorigin (playerStart.origin);
	
	priceStart = getnode( "price_southern_start", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	
	//aRedshirtStarts = getnodearray( "redshirt_southern_start" , "script_noteworthy" );
	//aRedshirts = getentarray( "redshirt", "targetname" );
	
	/*
	assertEX( aRedshirts.size == aRedshirtStarts.size , "You're supposed to have the same number of start points as friendlies here." );
	
	for( i = 0; i < aRedshirts.size; i++ )
	{
		aRedshirts[ i ] teleport (aRedshirtStarts[ i ].origin);
	}
	*/
	
	redshirtNode1 = getnode( "redshirt_southern_start1", "targetname" );
	redshirtNode2 = getnode( "redshirt_southern_start2", "targetname" );
	
	redshirt1 = getent( "redshirtNode1" );
	redshirt2 = getent( "redshirtNode2" );
	
	introHillTrigs = getentarray( "introHillTrig", "targetname" );
	for( i = 0 ; i < introHillTrigs.size; i++ )
	{
		introHillTrigs[ i ] notify ("trigger");
	}
	
	thread intro_tankdrive();
	thread southern_hill_defense();
}

start_minigun_fallback()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	
	//Position player
	
	//playerStart = getnode( "player_start_minigun", "targetname" );
	playerStart = getnode( "player_southern_start", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Position friendlies
	
	priceStart = getnode( "price_southern_start", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	
	/*
	aRedshirtStarts = getnodearray( "redshirt_southern_start" , "script_noteworthy" );
	aRedshirts = getentarray( "redshirt", "targetname" );
	
	assertEX( aRedshirts.size == aRedshirtStarts.size , "You're supposed to have the same number of start points as friendlies here." );
	
	for( i = 0; i < aRedshirts.size; i++ )
	{
		aRedshirts[ i ] teleport (aRedshirtStarts[ i ].origin);
	}
	*/
	
	thread moveRedshirts( "redshirt_southern_start1", "redshirt_southern_start2" );
	
	//Restore game state
	
	introHillTrigs = getentarray( "introHillTrig", "targetname" );
	for( i = 0 ; i < introHillTrigs.size; i++ )
	{
		introHillTrigs[ i ] notify ("trigger");
	}
	
	thread southern_hill_smokescreens();
	
	thread saw_gunner_friendly();
}

start_minigun()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	
	//Position player
	
	playerStart = getnode( "player_start_minigun", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Position friendlies
	
	priceStart = getnode( "fallback_price", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	level.price setgoalnode( priceStart );
	
	/*
	aRedshirtStarts = [];
	aRedshirtStarts[ 0 ] = getnode( "fallback_redshirt1", "targetname" );
	aRedshirtStarts[ 1 ] = getnode( "fallback_redshirt2", "targetname" );
	
	aRedshirts = getentarray( "redshirt", "targetname" );
	
	assertEX( aRedshirts.size == aRedshirtStarts.size , "You're supposed to have the same number of start points as friendlies here." );
	
	for( i = 0; i < aRedshirts.size; i++ )
	{
		aRedshirts[ i ] teleport (aRedshirtStarts[ i ].origin);
		aRedshirts[ i ] setgoalnode( aRedshirtStarts[ i ] );
	}
	
	*/
	
	thread moveRedshirts( "fallback_redshirt1", "fallback_redshirt2" );
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_helidrop()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_minigun_baglimit_done" );
	flag_set( "divert_for_clacker" );
	
	//Position player
	
	playerStart = getnode( "player_start_minigun", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Position friendlies
	
	priceStart = getnode( "fallback_price", "targetname" );
	level.price = getent( "price", "targetname" );
	level.price teleport (priceStart.origin);
	level.price setgoalnode( priceStart );
	
	thread moveRedshirts( "fallback_redshirt1", "fallback_redshirt2" );
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_clackers()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "detonators_activate" );
	
	//Position player
	
	playerStart = getnode( "player_start_clacker", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
	
	wait 7;
	flag_set( "objective_minigun_baglimit_done" );
	flag_set( "divert_for_clacker" );
}

start_field_fallback()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "divert_for_clacker" );
	flag_set( "fall_back_to_barn" );
	flag_set( "barn_assault_begins" );
	flag_set( "objective_armor_arrival" );
	
	//Position player
	
	playerStart = getnode( "player_start_clacker", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

start_javelin()
{
	//Advance objectives, set past game states
	
	flag_set( "stop_ambush_music" );
	flag_set( "church_tower_explodes" );
	flag_set( "objective_price_orders_southern_hill" );
	flag_set( "objective_on_ridgeline" );
	flag_set( "southern_hill_killzone_detonate" );
	flag_set( "objective_price_orders_minigun" );
	flag_set( "southern_hill_smoke_entry" );
	flag_set( "objective_detonators" );
	flag_set( "divert_for_clacker" );
	flag_set( "fall_back_to_barn" );
	flag_set( "barn_assault_begins" );
	flag_set( "objective_armor_arrival" );
	
	//Position player
	
	playerStart = getnode( "player_start_clacker", "targetname" );
	level.player setorigin (playerStart.origin);
	
	//Restore game state
	
	thread southern_hill_mortars_killtimer();
	thread minigun_primary_attack();
	thread minigun_smokescreens();
	thread saw_gunner_friendly();
}

moveRedshirts( node1, node2 )
{
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	
	redshirt_node1 = getnode( node1, "targetname" );
	redshirt_node2 = getnode( node2, "targetname" );
	
	redshirt1 teleport ( redshirt_node1.origin );
	redshirt1 setgoalnode ( redshirt_node1 );
	
	redshirt2 teleport ( redshirt_node2.origin );
	redshirt2 setgoalnode ( redshirt_node2 );
}

intro()
{
	thread intro_loudspeaker();
	
	aAllies = getaiarray( "allies" );
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[ i ].dontavoidplayer = true;
		aAllies[ i ].baseaccuracy = 15;
	}
	
	aAllies = remove_heroes_from_array( aAllies );
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[i] allowedstances ("crouch");
		aAllies[i].disableArrivals = true;
	}
	
	introTrigs = getentarray( "introTrig", "targetname" );
	for( i = 0 ; i < introTrigs.size; i++ )
	{
		introTrigs[ i ] notify ("trigger");
	}
	
	for( i = 0 ; i < aAllies.size; i++ )
	{
		aAllies[i] allowedStances ("stand", "crouch", "prone");
	}
	
	wait 4.5;
	
	price_intro_route = getnode( "price_intro_route", "targetname" );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	
	//redshirt_routes = [];
	redshirt_route1 = getnode( "sas1_intro_route", "targetname" );
	redshirt_route2 = getnode( "sas2_intro_route", "targetname" );
	
	level.price thread followScriptedPath( price_intro_route, undefined, "prone" );
	
	/*
	aRedshirts = [];
	aRedshirts = getentarray( "redshirt", "targetname" );
	for( i = 0 ; i < aRedshirts.size ; i++ )
	{
		aRedshirts[ i ] thread followScriptedPath( redshirt_routes[ i ], 0.75, "prone" );
		wait 1;
	}
	*/
	
	redshirt1 thread followScriptedPath( redshirt_route1, 0.75, "prone" );
	redshirt2 thread followScriptedPath( redshirt_route2, 0.75, "prone" );
	
	thread intro_tankdrive();
	
	//TEMP DIALOGUE
	//"Ignore that load of bollocks. Their counterattack is imminent. Spread out and cover the southern approach."
	//iprintln( "Their counterattack is imminent. Spread out and cover the southern approach." );
	level.price anim_single_queue( level.price, "spreadout" );
	
	flag_set( "objective_price_orders_southern_hill" );
	
	thread intro_ridgeline_check( level.player, "player_southern_start" );
	thread intro_ridgeline_check( level.price, "price_southern_start" );
	
	//"Bell tower here. Two enemy squads forming up to the south."
	//iprintln( "Bell tower here. Two enemy squads forming up to the south." );
	radio_dialogue( "belltowerhere" );
	
	//"Any vehicles?"
	//iprintln( "Any vehicles?" );
	level.price anim_single_queue( level.price, "anyvehicles" );
	
	thread intro_church_tower_explode();
	
	//"Negative. Wait - oh shit! Harris get ouuuuutt- (BOOM)"
	//iprintln( "Negative. Wait - oh shit! Harris get ouuuuutt- (BOOM)" );
	radio_dialogue( "negativewait" );

	thread southern_hill_defense();
	
	wait 1;
	
	//"Bloody hell. Parker and Harris are dead."
	//iprintln( "Bloody hell. Parker and Harris are dead." );
	radio_dialogue( "parkerharrisdead" );
}

intro_church_tower_explode()
{
	//TEMP FX

	wait 3.25;
	flag_set( "intro_tank_fire_authorization" );
	wait 0.25;
	temp_tower_sequence = getent( "intro_tank_tower_target", "targetname" );
	//incoming tracer and explosion
	exploder( 1000 );
	wait 1.1;
	exploder( 1001 );
	temp_tower_sequence playsound( "exp_bell_tower" );	
	earthquake( 0.65, 1, temp_tower_sequence.origin, 3000 );
	
	flag_set( "church_tower_explodes" );
}

intro_ridgeline_check( guy, nodename )
{
	ridgelinePos = getnode( nodename, "targetname" );
	
	dist = length(level.player.origin - ridgelinePos.origin);
	
	//Wait for guy to reach his place on the ridgeline
	
	while(dist > 256)
	{
		dist = length(guy.origin - ridgelinePos.origin);
		wait 0.1;
	}
	
	if( guy == level.price )
		flag_set( "objective_on_ridgeline" );
		//flag_set( "objective_price_on_ridgeline" );
		
	if( guy == level.player )
	{
		//flag_set( "objective_on_ridgeline" );
		flag_set( "objective_player_on_ridgeline" );
	}
}

intro_loudspeaker()
{
	//Ultranationalist Russian commander demanding the surrender of the SAS troops
	
	aSpeakerTalk = [];
	
	//TEMP DIALOGUE
	//"Surrender at once and your lives will be spared. I am sure you will make the right choice given the circumstances."
	//aSpeakerTalk[ 0 ] = "villagedef_rul_surrenderatonce";
	
	//TEMP DIALOGUE
	//"Drop your weapons and surrender at once. You will not be harmed if you surrender."
	//aSpeakerTalk[ 1 ] = "villagedef_rul_dropyourweapons";
	
	//TEMP DIALOGUE
	//"We know you are hiding in the village. You are surrounded, there is nowhere to run. Surrender and make it easy on yourselves."
	//aSpeakerTalk[ 2 ] = "villagedef_rul_weknowyourehiding";
	
	aSpeakers = getentarray( "russian_loudspeaker", "targetname" );
	speakerCount = aSpeakers.size;
	j = 0;
	
	for( i = 0; i < aSpeakerTalk.size; i++ )
	{
		if( j >= speakerCount)
			j = 0;
			
		play_sound_in_space( aSpeakerTalk[ i ], aSpeakers[ j ].origin);
		wait randomfloatrange( 5 , 8);
		j++;
	}
}

southern_hill_defense()
{
	thread southern_hill_intro();
	thread southern_hill_javelin();
	thread southern_hill_killzone_sequence();
	thread southern_hill_ambush();
	thread southern_hill_primary_attack();
	thread southern_hill_baglimit();
}

southern_hill_primary_attack()
{
	//level endon ( "objective_player_uses_minigun" );
	level endon ( "southern_hill_smoked" );
	
	startNode = getnode( "southern_hill_waypoint", "targetname" );
	unitName = "southern_hill_assaulter";
	endonMsg = "southern_hill_attack_stop";
	
	squad1 = "spawnRock";
	squad2 = "spawnRoad";
	squad3 = "spawnGas";
	
	level endon ( endonMsg );
	
	flag_wait( "southern_hill_killzone_detonate" );
	wait 1;

	while( 1 )
	{
		thread encroach_start( startNode, unitName, endonMsg, squad1, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad3, "southern_hill" );
		
		wait randomfloat( 6, 8 );
		
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad3, "southern_hill" );
		
		wait randomfloat( 8, 10 );
		
		thread encroach_start( startNode, unitName, endonMsg, squad1, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad3, "southern_hill" );
		thread encroach_start( startNode, unitName, endonMsg, squad2, "southern_hill" );
		
		wait randomfloat( 10, 12 );
	}
}

magic_sniper()
{
	flag_wait( "southern_hill_killzone_detonate" );
	
	wait 2;
	
	n = undefined;
	j = 0;
	magic_sniper = getent( "southern_hill_magic_sniper", "targetname" );
	sniperfx = "weap_m40a3sniper_fire_plr";
	
	while( 1 )
	{
		aAxis = [];
		aValidSniperTargets = [];
		
		aAxis = getaiarray( "axis" );
		
		for( i = 0; i < aAxis.size; i++ )
		{
			guy = aAxis[ i ];
			
			if( !isdefined( guy.targetname ) && !isdefined( guy.script_noteworthy ) )
				continue;
			
			if( guy.script_noteworthy == "spawnGas" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if( guy.script_noteworthy == "spawnRoad" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if( guy.script_noteworthy == "spawnRock" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if( isdefined( guy.targetname ) && guy.targetname == "vanguard" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillFence" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillChurch" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillGraveyard" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
			else
			if ( guy.script_noteworthy == "spawnHillFlank" )
			{
				aValidSniperTargets[ aValidSniperTargets.size ] = guy;
			}
		}	
		
		if( aValidSniperTargets.size == 0 )
		{
			wait 1;
			continue;
		}
			
		n = randomint( aValidSniperTargets.size );
		sniperTarget = aValidSniperTargets[ n ];
		
		magic_sniper playsound( sniperfx );
		sniperTarget doDamage ( sniperTarget.health + 100, (0, 0, 0) );
		
		if( level.magicSniperTalk )
		{
			if( j == 0 )
			{
				//"Target down."
				radio_dialogue( "targetdown" );
				j++;
			}
			else
			if( j == 1 )
			{
				//"Got him."
				radio_dialogue( "gothim" );
				j++;
			}
			else
			if( j == 2 )
			{
				//"Target eliminated."
				radio_dialogue( "targeteliminated" );
				j++;
			}
			else
			if( j == 3 )
			{
				//"Goodbye."
				radio_dialogue( "goodbye" );
				j = 0;
			}
		}
		
		aAxis = undefined;
		aValidSniperTargets = undefined;
		
		cycleDelay = randomfloatrange( level.southern_hill_magic_sniper_min_cycletime, level.southern_hill_magic_sniper_max_cycletime );
		wait cycleDelay;
	}
}

southern_hill_vanguard_setup()
{
	vanguards = [];
	vanguards = getentarray( "vanguard", "targetname" );
	
	for( i = 0; i < vanguards.size; i++ )
	{
		vanguards[ i ].goalradius = 16;
	}
	
	flag_wait( "objective_player_on_ridgeline" );
	//flag_wait( "objective_price_on_ridgeline" );
	//flag_wait( "objective_on_ridgeline" );
	
	for( i = 0; i < vanguards.size; i++ )
	{
		//vanguards[ i ] enable_cqbwalk();
		vanguards[ i ].animname = "axis";
		vanguards[ i ] set_run_anim( "patrolwalk_" + ( randomint(5) + 1 ) );
		vanguards[ i ] thread southern_hill_vanguard_nav();
		vanguards[ i ] thread southern_hill_deathmonitor();
	}
}

southern_hill_vanguard_nav()
{
	self endon ( "death" );
	
	node = undefined;
	
	if( !isdefined( self.script_noteworthy ) )
	{
		node = getnode( "default_vanguard_dest", "targetname" );	
	}
	else
	{
		nodes = getnodearray( "vanguard_node", "targetname" );	
		for( i = 0; i < nodes.size; i++ )
		{
			assertEX( isdefined( nodes[ i ].script_noteworthy ), "vanguard_node without a script_noteworthy" );
			if( self.script_noteworthy == nodes[ i ].script_noteworthy )
			{
				node = nodes[ i ];
				break;
			}
		}
	}
	
	self setgoalnode( node );
	self.goalradius = 2048;
	//self thread southern_hill_vanguard_aim();
}

southern_hill_vanguard_aim()
{
	self endon ( "death" );
	
	aimpoints = [];
	aimpoints = getentarray( "vanguard_aimpoint", "targetname" );
	
	while( 1 )
	{
		i = randomint( aimpoints.size );
		self cqb_aim ( aimpoints[ i ] );
		wait randomfloat(1, 2);
	}
}

southern_hill_intro()
{
	flag_wait( "objective_player_on_ridgeline" );
	//flag_wait( "objective_price_on_ridgeline" );
	//flag_wait( "objective_on_ridgeline" );
		
	//"Sir, they're slowly coming up the hill. Just say when."
	iprintln( "Sir, they're slowly coming up the hill. Just say when." );
	radio_dialogue( "justsaywhen" );
	
	wait 3;
	
	if( !flag( "southern_hill_action_started" ) ) 
	{
		//"Do it."
		iprintln( "Do it." );
		radio_dialogue( "doit" );
	}
		
		//"Ka-boom."
		iprintln( "Ka-boom." );
		radio_dialogue( "kaboom" );
	
	if( !flag( "southern_hill_action_started" ) ) 
	{
		//TEMP DIALOGUE
		//RUSSIAN SURPRISE AND ACTIVATION BEEPS FROM EXPLOSIVES

		flag_set( "southern_hill_killzone_detonate" );
		
		wait 0.5;
		
		flag_set( "southern_hill_action_started" );
	}
	else
	{	
		flag_set( "southern_hill_killzone_detonate" );
	}
}

southern_hill_ambush()
{
	flag_wait( "southern_hill_action_started" );
	
	//wait 0.15;
	
	//battlechatter_on( "allies" );
	
	flag_set( "southern_mg_openfire" );
	
	//wait 0.3;
	
	setthreatbias( "axis", "allies", 1000 );	// allies fight axis
	setthreatbias( "allies", "axis", 1000 ); 	// axis fight allies
	setthreatbias( "player", "axis", 1000 );	// axis fight player
	
	//"OPEN FIIRRRRRE!!!!!"
	iprintln( "OPEN FIIRRRRRE!!!!!" );
	level.price thread anim_single_queue( level.price, "openfire" );
}

southern_hill_killzone_sequence()
{
	flag_wait( "southern_hill_killzone_detonate" );
	
	killzone1 = getent( "southern_hill_killzone_1", "targetname" );
	killzone2 = getent( "southern_hill_killzone_2", "targetname" );
	
	battlechatter_on( "axis" );

	thread killzone_detonation( killzone1 );
	wait 0.75;
	thread southern_hill_panic_screaming();
	wait 0.5;
	thread killzone_detonation( killzone2 );
	
	wait 15;
	
	flag_set( "stop_ambush_music" );
	musicStop( 15 );
}

southern_hill_panic_screaming()
{
	//level endon ( "temp_demo_stopshooting" );	//TEMP LEVEL STOP FOR DEMOING PURPOSES ONLY
	
	speakers = getentarray( "ambush_speaker", "targetname" );
	for( j = 0; j < 4; j++ )
	{
		for( i = 0; i < speakers.size; i++ )
		{
			speaker = speakers[ i ];
			play_sound_in_space( "RU_1_reaction_casualty_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_move_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_attack_infantry", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_action_coverme", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_inform_suppressed_generic", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_order_action_suppress", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_response_ack_covering", speaker.origin );	
			wait 1;
			play_sound_in_space( "RU_1_response_ack_follow", speaker.origin );	
			wait 1;	
		}
	}
}

southern_hill_ambush_mg()
{
	southern_sas_mg = getent( "southern_house_manual_mg", "targetname" );
	southern_sas_mg setmode( "manual" );
	southern_sas_mg thread southern_hill_mg_targeting();
	
	flag_wait( "southern_mg_openfire" );
	
	southern_sas_mg thread manual_mg_fire();
}

southern_hill_mg_targeting()
{
	level endon ( "sawgunner_moving" ); 
	
	targets = getentarray( self.target, "targetname" );
	n = 0;
	
	while( 1 )
	{
		target = random( targets );
		
		self settargetentity( target );
		
		wait( randomfloatrange( 1, 5 ) );
		
		n++;
		
		//Occasionally pick off a bad guy
		
		if( n > 8 )
		{
			aAxis = [];
			aAxis = getaiarray( "axis" );
			if( aAxis.size )
			{
				target = random( aAxis );
				self settargetentity( target );
				wait( randomfloatrange( 1, 2 ) );
				
				n = 0;
				aAxis = undefined;
			}
			else
			{
				break;
			}
		}
	}
}

manual_mg_fire()
{	
	level endon( "sawgunner_moving" );
	self.turret_fires = true;
	n = 0;
	for ( ;; )
	{
		timer = randomfloatrange( 0.4, 0.7 ) * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}
		
		n++;
		
		//time between bursts
		wait( randomfloat( 3.3, 6 ) );
		
		if(n >= 10)
		{
			//pretend reloading
			wait randomfloat( 6.1, 7.4 );
			n = 0;
		}
	}
}

southern_hill_javelin()
{
	flag_wait( "southern_hill_action_started" );
	
	//"Sir, Ivan's bringin' in a recreational vehicle…" REWRITE TEMP
	//iprintln( "Got a lock on the T-72." );
	//radio_dialogue( "recreationalvehicle" );
	
	//"Take it out."
	//iprintln( "Take it out." );
	//radio_dialogue( "takeitout" );
	
	//"With pleasure sir. Firing Javelin."
	//iprintln( "With pleasure sir. Firing Javelin." );
	//radio_dialogue( "firingjavelin" );
	
	tank = getent( "intro_tank", "targetname" );
	//fakeJavelin = getent( "fake_javelin_launch", "targetname" );
	//magicbullet( "javelin", fakeJavelin.origin, tank.origin );
	//wait 4;
	radiusDamage( tank.origin, 512, 100500, 100500 );
	
	//"Nice shot mate!"
	radio_dialogue( "niceshotmate" );
}

southern_hill_baglimit()
{
	i=0;
	while( i < level.southernHillAdvanceBaglimit )
	{
		level waittill ( "player_killed_southern_hill_enemy" );
		i++;
		
		if( i == level.southernHillAdvanceBaglimit / 2 )
		{
			//"Squad, hold your ground, they think we're a larger force than we really are."
			radio_dialogue_queue( "largerforce" );
				
			//"Copy."
			radio_dialogue_queue( "copy" );
		}
	}
	
	thread saw_gunner_friendly();
	
	wait 7;
	
	flag_set( "southern_hill_smoked" );
	
	wait 30;
	
	thread southern_hill_smokescreens();
}

southern_hill_deathmonitor()
{
	self waittill ( "death", nAttacker );
	if( isdefined( nAttacker ) && nAttacker == level.player )
	{
		level notify ( "player_killed_southern_hill_enemy" );
	}
}

saw_gunner_friendly()
{
	//spawn the SAW gunner
	
	sasGunner = getent( "sasGunner", "targetname" );
	level.sasGunner = sasGunner doSpawn();
	if( spawn_failed( level.sasGunner ) )
	{
			return;
	}
	sasGunnerNode = getnode( "fallback_sasGunner", "targetname" );
	level.sasGunner setgoalnode( sasGunnerNode );
	level.sasGunner thread hero();
	level.sasGunner.ignoreSuppression = true;
	//level.sasGunner.baseaccuracy = 1;
	
	flag_wait( "objective_minigun_baglimit_done" );
}

intro_tankdrive()
{
	tank = spawn_vehicle_from_targetname_and_drive( "intro_tank" );
	node = getVehicleNode( "intro_tank_church_aim", "targetname" );
	targetpoint = getent( "intro_tank_tower_target", "targetname" );

	tank setwaitnode(node);
	tank waittill ("reached_wait_node");
	tank setTurretTargetEnt( targetpoint );
	tank waittill_notify_or_timeout( "turret_rotate_stopped", 5.0 );
	
	flag_wait( "intro_tank_fire_authorization" );
	tank fireweapon();
}

southern_hill_smokescreens()
{
	//playfx(level.smokegrenade, smokeSquad.origin);
	//smokescreen_southern_hill
	
	aSmokes = getentarray( "smokescreen_southern_hill", "targetname" );
	for( i = 0; i < aSmokes.size; i++ )
	{
		playfx(level.smokegrenade, aSmokes[ i ].origin);	
	}
	
	level notify ( "sawgunner_moving" );
	
	wait 8;
	
	level.magicSniperTalk = false;
	
	wait 2;
	
	//"They're putting up smokescreens. Mac - you see anything?"
	//iprintln( "They're putting up smokescreens. Mac - you see anything?" );
	radio_dialogue_queue( "smokescreensmac" );
	
	wait 0.5;
	
	//"Not much movement on the road. They might be moving to our west."
	//iprintln( "Not much movement on the road. They might be moving to our west." );
	radio_dialogue_queue( "notmuchmovement" );
	
	thread southern_hill_mortars();
	
	while( !flag( "objective_player_uses_minigun" ) )
	{
		for( i = 0; i < aSmokes.size; i++ )
		{
			playfx(level.smokegrenade, aSmokes[ i ].origin);
			wait randomfloatrange( 1.2, 2.3 );	
		}
		
		wait 32;
	}
}

southern_hill_mortars()
{
	//mortars start hitting around on the fake points
	//Price orders everyone to fall back to the next defensive zone
	//Price tells the player to get on the minigun
	//after the friendlies are out of the killzone, mortars start hitting around the real points
	//if the player enters the killzone after the timeout, he is killed by a magic mortar
	//use level.killzoneBigExplosion_fx
	
	aHits = getentarray( "southern_hill_mortar_hit", "targetname" );
	aRealHits = getentarray( "southern_hill_mortar_hit_real", "targetname" );
	
	thread minigun_fallback();
	thread southern_hill_mortars_killtimer();
	thread southern_hill_mortars_timing( "southern_hill_mortar_hit", "ridgeline_unsafe", 192 );
	
	//start the barbed wire breach concealing smoke when the player killing mortars start happening
	
	flag_set( "southern_hill_smoke_entry" );
	
	thread minigun_smokescreens();
	
	flag_wait( "ridgeline_unsafe" );
	
	thread southern_hill_mortars_timing( "southern_hill_mortar_hit_real", "enemy_breached_wire", 0 );
	
	wait 1.5;
	
	thread minigun_primary_attack();
}

minigun_smokescreens()
{
	//level endon ( "enemy_breached_wire" );
	level endon ( "objective_detonators" );
	
	aSmokes = getentarray( "smokescreen_barbed_wire", "targetname" );
	
	//while( !flag( "enemy_breached_wire" ) )
	while( 1 )
	{
		if( flag( "southern_hill_smoke_entry" ) )
		{
			for( i = 0; i < aSmokes.size; i++ )
			{
				playfx(level.smokegrenade, aSmokes[ i ].origin);
				wait randomfloatrange( 1.2, 2.3 );	
			}
			
			wait 28;
		}
		
		wait 0.25;
	}
	
}

southern_hill_mortars_timing( mortarMsg, endonMsg, safeDist )
{
	assertEX( isdefined( mortarMsg ), "mortarMsg not defined" );
	assertEX( isdefined( endonMsg ), "endonMsg not defined" );
	assertEX( isdefined( safeDist ), "safeDist not defined" );
	
	level endon ( endonMsg );
	
	aHits = getentarray( mortarMsg, "targetname" );
	aHits = array_randomize(aHits);		
	
	while( !flag( endonMsg ) )
	{
		for( i = 0; i < aHits.size; i++ )
		{
			hit = aHits[ i ];
			dist = distance(level.player.origin, hit.origin);
			
			if( dist > safeDist )
			{	
				southern_hill_mortar_detonate( hit );
				wait randomfloatrange( 0.7, 1.4 );
			}
		}
		
		aHits = array_randomize(aHits);		
	}
}

southern_hill_mortars_killtimer()
{
	wait level.southernMortarIntroTimer;
	flag_set( "ridgeline_targeted" );
	
	wait level.southernMortarKillTimer;
	flag_set( "ridgeline_unsafe" );
	
	//wait 20;
	
	thread southern_hill_mortars_killplayer();
}

southern_hill_mortars_killplayer()
{
	//Blows up player if player is too close to the ridgeline after Price orders the team to fall back
	
	//level endon ( "objective_player_uses_minigun" );
	
	dangerZone = getent( "ridgeline_dangerarea", "targetname" );
	
	while( 1 )
	{
		if( level.player isTouching( dangerZone ) )
		{
			wait 3;
			if ( level.player isTouching( dangerZone ) )
			{
				thread southern_hill_mortar_detonate( level.player );
				level.player doDamage( level.player.health + 10000, level.player.origin );
			}
		}
		
		wait 0.5;
	}
}

minigun_fallback()
{
	flag_wait( "ridgeline_targeted" );

	autosave_by_name( "ridgeline_under_mortar_fire" );
	
	/*
	redshirts = [];
	redshirts = getentarray( "redshirt", "targetname" );
	*/
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt2 = getent( "redshirt2", "targetname" );
	
	redshirt_node1 = getnode( "fallback_redshirt1", "targetname" );
	redshirt_node2 = getnode( "fallback_redshirt2", "targetname" );
	
	//"They're targeting our position with mortars. It's time to fall back."
	//iprintln( "They're targeting our position with mortars. It's time to fall back." );
	radio_dialogue_queue( "targetingour" );
	
	thread minigun_orders();
	
	wait 2;
	
	/*
	assertEX( redshirts.size == redshirtNodes.size, "Need same number of redshirt nodes as redshirts." );
	
	for( i = 0; i < redshirts.size; i++ )
	{
		guy = redshirts[ i ];
		guy allowedstances ( "stand", "crouch", "prone" );
		guy setgoalnode( redshirtNodes[ i ] );
		wait randomfloatrange( 0.7, 1.2 );
	}
	*/
	
	//"Two, falling back."
	radio_dialogue_queue( "twofallingback" );
	
	redshirt1 allowedstances ( "stand", "crouch", "prone" );
	redshirt1 setgoalnode( redshirt_node1 );
	wait randomfloatrange( 0.7, 1.2 );
	
	//"Three, on the move."
	radio_dialogue_queue( "threeonthemove" );
	
	redshirt2 allowedstances ( "stand", "crouch", "prone" );
	redshirt2 setgoalnode( redshirt_node2 );
	
	priceNode = getnode( "fallback_price", "targetname" );
	level.price allowedstances ( "stand", "crouch", "prone" );
	level.price setgoalnode( priceNode );
	
	//"Three here. Two's in the far eastern building. We've got the eastern road locked down."
	radio_dialogue_queue( "easternroadlocked" );
	
	level.price.baseaccuracy = 1;
	level.price.ignoreSuppression = true;
	
	redshirt1.baseaccuracy = 1;
	redshirt1.ignoreSuppression = true;
	
	redshirt2.baseaccuracy = 1;
	redshirt2.ignoreSuppression = true;
}

minigun_orders()
{
	level endon ( "objective_player_uses_minigun" );
	
	//Price gives orders for the minigun.
	
	flag_set( "objective_price_orders_minigun" );
	
	//"Right. Soap, get to the minigun and cover the western flank. Go."
	//iprintln( "Right. Soap, get to the minigun and cover the western flank. Go." );
	radio_dialogue( "minigunflank" );
	
	thread minigun_use();
	thread minigun_arming_check();
	
	n = 0;
	k = 0;
	cycleTime = 15;
	
	while( 1 )
	{
		wait cycleTime;
		
		if( n == 0 )
		{
			//"Soap, get to the minigun! Move! It's attached to the crashed helicopter."
			//iprintln( "Soap, get to the minigun! Move! It's attached to the crashed helicopter." );
			radio_dialogue_queue( "miniguncrashed" );
			k = k + cycleTime;
		}
		
		if( n == 1 )
		{
			//"Soap, I need you to operate the minigun! Get your arse moving!"
			//iprintln( "Soap, I need you to operate the minigun! Get your arse moving!" );
			radio_dialogue_queue( "minigunarse" );
			if( k < cycleTime * 4 )
			{
				n = 0;
				k = k + cycleTime;
			}
		}
		
		if( n == 2 )
		{
			//"Soap, they're already in the graveyard! Get on that bloody gun!"
			//iprintln( "Soap, they're already in the graveyard! Get on that bloody gun!" );
			radio_dialogue_queue( "graveyard" );
			n = 0;
			continue;
		}

		n++;
	}
}

minigun_use()
{
	flag_wait( "objective_player_uses_minigun" );
	
	level notify ( "southern_hill_attack_stop" );	//stops southern hill attack
}

minigun_primary_attack()
{	
	//Mortar shreds the barbed wire out of the way on the southern hill
	
	barbedDets = getentarray( "barbed_wire_detonator", "targetname" );
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_1", barbedDets );
	
	wait 2;
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_2", barbedDets );
	
	wait 3;
	
	thread minigun_barbed_wire_detonate( "southern_hill_barbed_wire_wall_3", barbedDets );
	
	autosave_by_name( "southwestern_flanking_assault" );
	
	thread minigun_breach_baglimit();
	
	//startNode = getnode( "southern_hill_waypoint", "targetname" );
	//unitName = "southern_hill_assaulter";
	//endonMsg = "southern_hill_attack_stop";
	
	//squad1 = "spawnRock";
	//squad2 = "spawnRoad";
	//squad3 = "spawnGas";
	
	//thread encroach_start( startNode, unitName, endonMsg, squad1, "southern_hill" );
	
	startnode1 = getnode( "southern_hill_breach_church", "targetname" );
	startnode2 = getnode( "southern_hill_breach_graveyard", "targetname" );
	startnode3 = getnode( "southern_hill_breach_housegap", "targetname" );
	startnode4 = getnode( "southern_hill_breach_flank", "targetname" );
	
	unitName = "southern_hill_breacher";
	
	endonMsg = "halfway_through_field";	//enemy continues to attack heavily until player is in the barn and has picked up the javelin
	
	squad1 = "spawnHillChurch";
	squad2 = "spawnHillGraveyard";
	squad3 = "spawnHillFence";
	squad4 = "spawnHillFlank";
	
	deathmonitorName = "minigun_breach";
	
	level endon ( endonMsg );
	
	while( 1 )
	{	
		thread encroach_start( startNode2, unitName, endonMsg, squad1, deathmonitorName );
		thread encroach_start( startNode2, unitName, endonMsg, squad2, deathmonitorName );		
		thread encroach_start( startNode3, unitName, endonMsg, squad3, deathmonitorName );
		
		wait randomfloatrange( 6, 8 );
		
		thread encroach_start( startNode1, unitName, endonMsg, squad1, deathmonitorName );
		thread encroach_start( startNode2, unitName, endonMsg, squad2, deathmonitorName );		
		thread encroach_start( startNode1, unitName, endonMsg, squad3, deathmonitorName );	
		
		wait randomfloatrange( 9, 11 );	
		
		thread encroach_start( startNode3, unitName, endonMsg, squad1, deathmonitorName );
		thread encroach_start( startNode2, unitName, endonMsg, squad2, deathmonitorName );		
		thread encroach_start( startNode2, unitName, endonMsg, squad3, deathmonitorName );
		//thread encroach_start( startNode4, unitName, endonMsg, squad4, deathmonitorName );	
		
		wait randomfloatrange( 12, 14 );	
	}
}

minigun_breach_deathmonitor()
{
	self waittill ( "death", nAttacker );
	if( isdefined( nAttacker ) && nAttacker == level.player )
	{
		level notify ( "player_killed_minigun_breach_enemy" );
	}
}

minigun_breach_baglimit()
{
	i=0;
	while( i < level.minigunBreachBaglimit )
	{
		level waittill ( "player_killed_minigun_breach_enemy" );
		i++;
	}
	
	flag_set( "objective_minigun_baglimit_done" );
	flag_set( "divert_for_clacker" );
}

minigun_barbed_wire_detonate( barricade, detonators )
{
	obstacle = getentarray( barricade, "targetname" );
	
	for( i = 0; i < detonators.size; i++ )
	{
		det = detonators[ i ];
		if( !isdefined( det.script_noteworthy ) )
			continue;
		if( det.script_noteworthy != barricade )
			continue;
		
		playfx( level.megaExplosion, det.origin );
		det playsound( "explo_mine" );
		earthquake( 0.5, 0.5, level.player.origin, 1250 );
		radiusDamage(det.origin, 256, 1000, 500);	//radiusDamage(origin, range, maxdamage, mindamage);
	}
	
	for( i = 0; i < obstacle.size; i++ )
	{
		obstacle[ i ] delete();
	}
	
	flag_set( "enemy_breached_wire" );
	
	level.magicSniperTalk = true;
}

minigun_arming_check()
{
	//Checks to see if the player is on the minigun. 
	//Lowers enemy AI accuracy when player is on the minigun.
	
	minigun = getent( "minigun", "targetname" );
	
	while(1)
	{
		minigun waittill("turretownerchange");
		minigunUser = minigun getTurretOwner();
		
		if((isdefined(minigunUser) && level.player != minigunUser) || !isdefined(minigunUser))
		{
			aEnemy = [];
			aEnemy = getaiarray( "axis" );
			for( i = 0; i < aEnemy.size; i++ )
			{
				aEnemy[ i ].baseAccuracy = 8;
			}
		}
		
		if( (isdefined(minigunUser) && level.player == minigunUser) )
		{
			if( !flag( "objective_player_uses_minigun" ) )
			{
				flag_set( "objective_player_uses_minigun" );
				
				wait 2.5;
				
				//"Soap. Keep the minigun spooled up. Fire in bursts, 30 seconds max."
				radio_dialogue_queue( "spooledup" );
			}
			
			aEnemy = [];
			aEnemy = getaiarray( "axis" );
			for( i = 0; i < aEnemy.size; i++ )
			{
				aEnemy[ i ].baseAccuracy = 5;
			}
		}
	}
}

helidrop()
{
	flag_wait( "objective_minigun_baglimit_done" );
	flag_set( "helidrop_started" );
	
	level.magicSniperTalk = false;
	
	spawn_vehicle_from_targetname_and_drive( "helidrop_01" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_02" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_03" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_04" );
	spawn_vehicle_from_targetname_and_drive( "helidrop_05" );
	
	thread helidrop_rider_setup( "helidrop_01" );
	thread helidrop_rider_setup( "helidrop_02" );
	thread helidrop_rider_setup( "helidrop_03" );
	thread helidrop_rider_setup( "helidrop_04" );
	thread helidrop_rider_setup( "helidrop_05" );
	
	wait 20;
	
	//"We've got a problem here...heads up!"
	radio_dialogue_queue( "headsup" );

	//"Bloody hell, that's a lot of helis innit?"
	radio_dialogue_queue( "lotofhelis" );
	
	//"Soap, fall back to the tavern and man the detonators."
	iprintln( "Soap, fall back to the tavern and man the detonators." );
	radio_dialogue_queue( "tavern" );
	
	flag_set( "objective_detonators" );
	flag_set( "detonators_activate" );
	
	//"The rest of us will keep them busy from the next defensive line. Everyone move!"
	iprintln( "The rest of us will keep them busy from the next defensive line. Everyone move!" );
	radio_dialogue_queue( "nextdefensiveline" );
	
	priceNode = getnode( "clacker_fallback_price", "targetname" );
	level.price setgoalnode( priceNode );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt_node1 = getnode( "clacker_fallback_redshirt1", "targetname" );
	redshirt1 setgoalnode( redshirt_node1 );
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node2 = getnode( "clacker_fallback_redshirt2", "targetname" );
	redshirt2 setgoalnode( redshirt_node2 );
	
	sasGunnerNode = getnode( "clacker_fallback_sasGunner", "targetname" );
	level.sasGunner setgoalnode( sasGunnerNode );
}

helidrop_rider_setup( heliName )
{
	heli = getent( heliName, "targetname" );
	aRiders = heli.riders;
	
	for( i = 0; i < aRiders.size; i++ )
	{
		rider = aRiders[ i ];
		rider thread hunt_player( heli );
		rider thread helidrop_clacker_divert( heli );
	}
}

hunt_player( heli )
{
	self endon ( "death" );
	self endon ( "going_to_baitnode" );
	
	if( isdefined( heli ) )
		heli waittill ( "unloaded" );
		
	self.goalradius = 1800;	
	
	//Adjust accuracy of helidrop troops to make them more effective in the larger spaces inherent in this layout

	switch( level.gameSkill )
	{
		case 0:
			self.baseAccuracy = 1;
			break;
		case 1:
			self.baseAccuracy = 5;
			break;
		case 2:
			self.baseAccuracy = 6;
			break;
		case 3:
			self.baseAccuracy = 7;
			break;
	}
	
	//Encroach on the player and kill the player
	//When player enters the upper floor of the clacker house a flag is set
	
	self.pathenemyfightdist = 1800;
	self.pathenemylookahead = 1800;
	
	while( self.goalradius > 640 )
	{
		self setgoalpos( level.player.origin );
		
		self.goalradius = self.goalradius * level.encroachRate;	
		self waittill ( "goal" );
		wait randomintrange( 10, 15 );
	}
}

helidrop_clacker_divert( heli )
{
	self endon ( "death" );
	
	if( isdefined( heli ) )
		heli waittill ( "unloaded" );
	
	flag_wait( "player_entered_clacker_house_top_floor" );
	
	self notify ( "going_to_baitnode" );
	
	//if enemy is already within X of player, commits to pursuing player
	//outside of X enemy will maneuver to killzone
	
	baitNode = undefined;
	
	if( isdefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "helidrop_bait_grassyknoll" && !flag( "farslope_exploded" ) )
		{
			baitNode = getnode( "bait_farslope", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_grassyknoll" && flag( "farslope_exploded" ) && !flag( "nearslope_exploded") )
		{
			baitNode = getnode( "bait_nearslope", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_grassyknoll" && flag( "farslope_exploded" ) && flag( "nearslope_exploded" ) )
		{
			self thread hunt_player();
			return;
		}
		else
		if( self.script_noteworthy == "helidrop_bait_crashsite" && !flag( "crashsite_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_crashsite" && flag( "crashsite_exploded" ) && !flag( "cliffside_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );
		}
		else
		if( self.script_noteworthy == "helidrop_bait_crashsite" && flag( "crashsite_exploded" ) && flag( "cliffside_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );	//best blocking position
		}
		else
		if( self.script_noteworthy == "helidrop_bait_trees" && !flag( "cliffside_exploded" ) )
		{
			baitNode = getnode( "bait_trees", "targetname" );
		}
		if( self.script_noteworthy == "helidrop_bait_trees" && flag( "cliffside_exploded" ) && !flag( "crashsite_exploded" ) )
		{
			baitNode = getnode( "bait_crashsite", "targetname" );
		}
		else
		if( self.script_noteworthy == "spawnHillFlank" )
		{
			baitNode = getnode( "bait_nearslope", "targetname" );			
		}
		else
		{
			self.goalradius = 2400;	
			
			switch( level.genericBaitCount )
			{
				case 0:
					baitNode = getnode( "bait_nearslope", "targetname" );
					level.genericBaitCount++;
					break;
				case 1:
					baitNode = getnode( "bait_trees", "targetname" );
					level.genericBaitCount = 0;
					break;
			}
		}
	}
	else
	{
		self thread hunt_player();
		return;
	}
	
	distToPlayer = distance( level.player.origin, self.origin );
	wait 0.5;
	distToBaitNode = distance( baitNode.origin, self.origin );
	
	if( ( level.divertClackerRange < distToPlayer ) && ( distToBaitNode < distToPlayer ) )
	{
		self setgoalnode( baitNode );
	}
	
	flag_wait( "fall_back_to_barn" );
	
	wait randomfloatrange( 1.5, 2.8 );
	
	self thread hunt_player();
}

clacker_primary_attack()
{
	flag_wait( "objective_minigun_baglimit_done" );
	flag_set( "spawncull" );
	
	thread clacker_nearfarslope_check();
	
	startnode4 = getnode( "southern_hill_breach_flank", "targetname" );
	
	unitName = "southern_hill_breacher";
	
	endonMsg = "clacker_far_and_near_slope_done";
	
	squad4 = "spawnHillFlank";
	
	level endon ( endonMsg );
	
	startAttackTrig = getent( "nearfarslope_activation", "targetname" );
	startAttackTrig waittill ( "trigger" );
	
	flag_set( "player_entered_clacker_house_top_floor" );
	
	flag_wait( "helidrop_started" );
	
	while( 1 )
	{	
		aAxis = undefined;
		aAxis = [];
		aAxis = getaiarray( "axis" );
		if( aAxis.size < 27 )
		{
			thread encroach_start( startNode4, unitName, endonMsg, squad4, undefined );
			wait randomfloatrange( 2, 3 );		
		}
		
		wait 0.5;
	}
}

clacker_nearfarslope_check()
{
	//if player has detonated the near and far slope mines, then stop attacks from the southern hill left flank
	
	flag_wait( "nearslope_exploded" );
	flag_wait( "farslope_exploded" );
	
	flag_set( "clacker_far_and_near_slope_done" );
}

clacker_init()
{
	aUseTrigs = getentarray( "detonator_usetrig", "targetname" );
	aDets = [];
	detEnts = [];
	det = undefined;
	
	for( i = 0; i < aUseTrigs.size; i++ )
	{
		if( !isdefined( aUseTrigs[ i ].target ) )
			continue;
			
		detEnts = getentarray( aUseTrigs[ i ].target, "targetname" );
		
		for( j = 0; j < detEnts.size; j++ )
		{
			det = detEnts[ j ];
			
			if( !isdefined( det.script_namenumber ) )
				continue;
			
			if( det.script_namenumber == "objective_clacker" )
			{
				level.objectiveClackers++;
				aDets[ aDets.size ] = det;
				det hide();
			}
		}
		
		detEnts = [];
	}
	
	//flag_wait( "objective_detonators" );
	flag_wait( "detonators_activate" );
	
	for( i = 0; i < aDets.size; i++ )
	{
		aDets[ i ] show();
		aDets[ i ] thread clacker_standby();
	}
}

clacker_standby()
{
	while( 1 )
	{
		assertEX( isdefined( self.targetname ), "clacker use trigger should target the clacker" );
		trig = getent( self.targetname, "target" );
		
		assertEX( isdefined( self.script_noteworthy ), "useVolume should have a targetname matching the clacker script_noteworthy" );
		useVolume = getent( self.script_noteworthy, "targetname" );
		
		trigFlag = trig.script_flag_true;
		flag_set( trigFlag );
		
		trig waittill ( "trigger" );
		
		self thread clacker_enable( trig, useVolume );
		self thread clacker_notouch( trig, useVolume );
	}
}

clacker_enable( trig, useVolume )
{
	if( level.player isTouching( useVolume ) )
	{
		self hide();	//hide the prop clacker
		
		//Bring up the clacker in hand
			
		level.player maps\_c4::switch_to_detonator();
		
		//Display the marker effects
		
		level.detMarkers = [];
		markerPos = getent( self.target, "targetname" );		
		
		effect = spawnFx( getfx( "firelp_small_dl" ), markerPos.origin + (0, 0, 64) );
		
		while( 1 )
		{
			//level.detMarkers[ level.detMarkers.size ] = spawnFx( getfx( "firelp_small_dl" ), markerPos.origin + (0, 0, 64) );
			
			obj = spawn( "script_model", ( 0, 0, 0 ) );
			obj setModel( "tag_origin" );  
			obj.angles = ( -90, 0, 0 );
			obj.origin = markerPos.origin;
			
			level.detMarkers[ level.detMarkers.size ] = obj;
			
			playfxontag( getfx( "killzone_marker" ), level.detMarkers[ level.detMarkers.size - 1 ], "tag_origin" );
			
			if( isdefined( markerPos.target ) )
			{
				markerPos = getent( markerPos.target, "targetname" );
			}
			else
			{
				break;
			}
		}
		
		self thread clacker_drop( trig, useVolume );
			
		//The use trigger for this specific clacker is deactivated while player has the clacker
			
		trigFlag = trig.script_flag_true;
		flag_clear( trigFlag );
		
		self thread clacker_fire( trig );
	}
}

clacker_drop( trig, useVolume )
{
	//detects when player switches to another weapon, which automatically counts as 'clacker dropped'
	
	while( level.player isTouching ( useVolume ) )
	{
		wait 2;
		weapon = level.player getcurrentweapon();
		
		if( weapon != "c4" )
			self thread clacker_disable( trig, useVolume );
			
		wait 0.05;
	}
}

clacker_notouch(trig, useVolume )
{
	while( level.player isTouching( useVolume ) )
	{
		wait 0.05;
	}
			
	self thread clacker_disable( trig, useVolume );
}

clacker_disable( trig, useVolume )
{
	//Actively disarm the armed clacker
	
	if( isdefined( trig ) )
	{
		level notify ( "detclacker_disarm" );
		
		//If clacker has been picked up
		//and player is not in the detection volume 
		//or player switched weapons away from the clacker
		
		//Return the clacker to its rightful spot
		//Clacker reappears
		
		level.player takeweapon( "c4" );
		self show();
		
		//Remove the glowing hint effects for the killzone if they were generated previously
		
		if( isdefined( level.detMarkers ) )
		{
			assertEX( level.detMarkers.size > 0, "there are no detMarkers to delete" );
			
			count = level.detMarkers.size;
			
			for( i = 0; i < count; i++ )
			{
				level.detMarkers[ i ] delete();
			}
			
			level.detMarkers = undefined;
		}
		
		//Reenable use trigger for clacker pickup
		
		trigFlag = trig.script_flag_true;
		flag_set( trigFlag );
		
		//Switch to normal weapon	
		
		level.player switchtoweapon( level.player GetWeaponsListPrimaries()[0] );
	}
}

clacker_fire( trig )
{
	level endon ( "detclacker_disarm" );

	//Arm the clacker	
	level.player waittill( "detonate" );
	
	//Remove the glowing hint effects for the killzone if they were generated previously
	
	if( isdefined( level.detMarkers ) )
	{
		assertEX( level.detMarkers.size > 0, "there are no detMarkers to delete" );
		
		count = level.detMarkers.size;
		
		for( i = 0; i < count; i++ )
		{
			level.detMarkers[ i ] delete();
		}
		
		level.detMarkers = undefined;
	}
	
	if( self.script_noteworthy == "detonator_nearslope" )
		flag_set( "nearslope_exploded" );
	
	if( self.script_noteworthy == "detonator_farslope" )
		flag_set( "farslope_exploded" );
	
	if( self.script_noteworthy == "detonator_crashsite" )
		flag_set( "crashsite_exploded" );
	
	if( self.script_noteworthy == "detonator_cliffside" )
		flag_set( "cliffside_exploded" );
	
	//iprintln( "KABOOM on " + self.script_noteworthy );
	killzone = getent( self.target, "targetname" );
	thread killzone_detonation( killzone );
	
	level.player takeweapon( "c4" );
	level.player switchtoweapon( level.player GetWeaponsListPrimaries()[0] );
	
	//Objective position updating for clackers
	
	//Locate the clacker position that was just used
	
	targ = undefined;
	usedClackerObjectiveMarker = undefined;
	
	trigTargets = getentarray( trig.target, "targetname" );
	for( i = 0 ; i < trigTargets.size; i++ )
	{
		targ = trigTargets[ i ];
		
		if( !isdefined( targ.script_noteworthy ) )
			continue;
			
		if( !( targ.script_noteworthy == "clacker_objective_marker" ) )
			continue;
		
		usedClackerObjectiveMarker = targ;
	}
	
	//Get the clacker positions and remove the position that was just used
	
	aManualDets = getentarray( "clacker_objective_marker", "script_noteworthy" );
	
	for( i = 0; i < aManualDets.size; i++ )
	{
		det = aManualDets[ i ];
		if( det == usedClackerObjectiveMarker )
			aManualDets = maps\_utility::array_remove(aManualDets, det);
	}
	
	//Reprint the objective with the latest unused clacker positions
	
	objective_delete( 5 );
	objective_add( 5, "active", "Use the detonators in the tavern to delay the enemy attack." );
	objective_current( 5 );
	
	for( i = 0; i < aManualDets.size; i++ )
	{
		det = aManualDets[ i ];
		if( isdefined( det ) )
			objective_additionalposition( 5, i, det.origin);
	}

	trig delete();
	usedClackerObjectiveMarker delete();
	
	level.objectiveClackers--;
	
	if( !level.objectiveClackers )
	{
		flag_set( "fall_back_to_barn" );
		flag_set( "barn_assault_begins" );
	}
}

javelin_init()
{	
	flag_wait( "fall_back_to_barn" );
	
	javelin = spawn("weapon_javelin", (1021.1, 7309.2, 1006), 1); // suspended
	javelin.angles = (356.201, 346.91, -0.426635);
	
	javelin waittill ( "trigger" );
	
	flag_set( "got_the_javelin" );
}

tanks_init()
{
	flag_wait( "fall_back_to_barn" );
	
	//"We have enemy tanks approaching from the north! (sounds of fighting for a second) Bloody hell I'm hit! Arrrgh - (static)"
	radio_dialogue_queue( "enemytanksnorth" );
	
	//"Mac's in trouble! Soap! Get to the barn at the northern end of the village and stop those tanks! Use the Javelins in the barn!"
	radio_dialogue_queue( "gettothebarn" );
	
	flag_set( "objective_armor_arrival" );
	
	flag_wait( "got_the_javelin" );
	
	//wait randomfloatrange( 3, 5 );
	
	for( i = 1; i < 5; i++ )
	{
		thread tanks_deploy( "tank_backyard_0" + i );
	}
}

tanks_deploy( name )
{
	tank = spawn_vehicle_from_targetname_and_drive( name );
	
	level.tankid++;
	tanknumber = level.tankid;
	
	tank thread tank_ping( tanknumber );
	
	OFFSET = ( 0, 0, 60 );
	target_set( tank, OFFSET );
	target_setAttackMode( tank, "top" );
	target_setJavelinOnly( tank, true );
	
	tank waittill ( "death" );
	
	level.tankPop--;
	
	if( level.tankPop )
	{
		objective_delete( 7 );
		objective_add( 7, "active", "Destroy the incoming tanks. (" + level.tankPop + " remaining.)" );
		objective_current( 7 );
	}
	else
	{
		flag_set( "objective_all_tanks_destroyed" );
	}
	
	if ( isdefined( tank ) )
	{
		target_remove( tank );	//javelin targeting reticle removal
	}
}

tank_ping( tanknumber )
{
	self endon ( "death" );
	
	objective_add( 7, "active", "Destroy the incoming tanks. (" + level.tankPop + " remaining.)" );
	objective_current( 7 );
	
	while( isalive( self ) )
	{
		objective_additionalposition( 7, tanknumber, self.origin);
		objective_ring( 7 );
		wait 1.2;
	}
}

barn_helidrop()
{
	//enemy_heli_reinforcement_shoulder
	//enemy_heli_reinforcement_barncenter
	//enemy_heli_reinforcement_parkinglot
	//enemy_heli_reinforcement_barnleft
	//enemy_heli_reinforcement_cowfield
	
	flag_wait( "barn_assault_begins" );
	
	barnHelidropTrig = getent( "barn_helidrop", "targetname" );
	barnHelidropTrig waittill ( "trigger" );
	
	level notify ( "halfway_through_field" );
	
	spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_shoulder" );
	spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_barncenter" );
	spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_cowfield" );
	spawn_vehicle_from_targetname_and_drive( "enemy_heli_reinforcement_barnleft" );
}

field_fallback()
{
	flag_wait( "fall_back_to_barn" );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt_node1 = getnode( "field_fallback_redshirt1", "targetname" );
	redshirt1 setgoalnode( redshirt_node1 );
	
	wait 2;
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node2 = getnode( "field_fallback_redshirt2", "targetname" );
	redshirt2 setgoalnode( redshirt_node2 );
	
	wait 2;
	
	priceNode = getnode( "field_fallback_price", "targetname" );
	level.price setgoalnode( priceNode );
	
	wait 5;
	
	sasGunnerNode = getnode( "field_fallback_sasGunner", "targetname" );
	level.sasGunner setgoalnode( sasGunnerNode );
}

barn_fallback()
{
	flag_wait( "got_the_javelin" );
	
	redshirt1 = getent( "redshirt1", "targetname" );
	redshirt_node1 = getnode( "barn_fallback_redshirt1", "targetname" );
	redshirt1 setgoalnode( redshirt_node1 );
	
	wait 1;
	
	redshirt2 = getent( "redshirt2", "targetname" );
	redshirt_node2 = getnode( "barn_fallback_redshirt2", "targetname" );
	redshirt2 setgoalnode( redshirt_node2 );
	
	wait 2;
	
	priceNode = getnode( "barn_fallback_price", "targetname" );
	level.price setgoalnode( priceNode );
	
	wait 3;
	
	sasGunnerNode = getnode( "barn_fallback_sasGunner", "targetname" );
	level.sasGunner setgoalnode( sasGunnerNode );
}

final_battle()
{
	flag_wait( "start_final_battle" );
	
	wait 6;
	
	//"Bravo Six, this is Gryphon Two-Seven. We've just crossed into Azerbaijani airspace. E.T.A. is six minutes. Be ready for pickup."
	radio_dialogue_queue( "etasixminutes" );
	
	wait 3;
	
	thread objective_stopwatch();
	
	wait 3;
	
	thread airstrike();
}

objectives()
{
	wait 10;
	
	objective_add( 1, "active", "Obtain new orders from Captain Price.", ( level.price.origin ) );
	objective_current( 1 );
	
	flag_wait( "objective_price_orders_southern_hill" );
	
	objective_state( 1 , "done" );
	
	playerDefensePos = getnode( "player_southern_start", "targetname" );
	
	objective_add( 2, "active", "Take up a defensive position along the ridgeline.", ( playerDefensePos.origin ) );
	objective_current( 2 );
	
	flag_wait( "objective_on_ridgeline" );
	
	objective_state( 2 , "done" );
	
	objective_add( 3, "active", "Defend the southern hill approach.", ( level.price.origin ) );
	objective_current( 3 );
	
	autosave_by_name( "ready_for_ambush" );
	
	flag_wait( "objective_price_orders_minigun" );
	
	objective_state( 3 , "done" );
	
	minigun = getent( "minigun", "targetname" );
	
	objective_add( 4, "active", "Fall back and defend the southwestern approaches.", ( minigun.origin ) );
	objective_current( 4 );
	
	autosave_by_name( "minigun_defense" );
	
	flag_wait( "objective_detonators" );
	
	objective_state( 4 , "done" );
	
	aManualDets = getentarray( "clacker_objective_marker", "script_noteworthy" );
	
	objective_add( 5, "active", "Use the detonators in the tavern to delay the enemy attack.", aManualDets[ 0 ].origin );
	objective_current( 5 );
	
	autosave_by_name( "detonator_defense" );
	
	for( i = 1; i < aManualDets.size; i++ )
	{
		det = aManualDets[ i ];
		
		objective_additionalposition( 5, i, det.origin);
	}
	
	flag_wait( "objective_armor_arrival" );
	
	objective_state( 5, "done" );
	
	objective_add( 6, "active", "Get the Javelin.", ( 1021.1, 7309.2, 1006 ) );
	objective_current( 6 );
	
	flag_wait( "got_the_javelin" );
	
	objective_state( 6, "done" );
	
	autosave_by_name( "got_javelin" );
	
	flag_wait( "objective_all_tanks_destroyed" );
	
	objective_string( 7, "Destroy the incoming tanks." );
	objective_state( 7, "done" );
	
	autosave_by_name( "tanks_cleared" );
	
	objective_add( 8, "active", "Survive until the helicopter arrives." );
	objective_current( 8 ); 
	
	flag_set( "start_final_battle" );
	
	/*
	1. Obtain new orders from Captain Price.
	2. Take up a defensive position along the ridgeline. (note: level does not progress until player reaches his spot)
	3. Defend the southern hill approach. (note: level does not progress without player participation)
	4. Fall back and defend the southwestern approaches. (note: level does not progress without player participation)
	5. Fall back to the tavern.
	6. Survive until the exfiltration force arrives. (Time Remaining: ~6 minutes, freeform gameplay)
	7. Eliminate the enemy armor approaching from the north. (required to progress)
	8. Destroy the enemy attack helicopter. (Appearing/Disappearing recurring objective X 4, optional but accumulates)
	9. Board the rescue helicopter before it leaves. (achievement for carrying a buddy back to the helo)
	*/
}

objective_stopwatch()
{
	level notify ("start stopwatch");
	
	fMissionLength = level.stopwatch;							//how long until relieved (minutes)	
	iMissionTime_ms = gettime() + int(fMissionLength*60*1000);	//convert to milliseconds
	
	// Setup the HUD display of the timer.
	
	level.hudTimerIndex = 20;
	
	level.timer = newHudElem();
	level.timer.alignX = "left";
	level.timer.alignY = "middle";
	level.timer.horzAlign = "right";
    level.timer.vertAlign = "top";
    if(level.xenon)
	{
		level.timer.fontScale = 2;
		level.timer.x = -225;
	}
	else
	{
		level.timer.fontScale = 1.6;    
		level.timer.x = -180;
	}
	level.timer.y = 100;
	level.timer.label = "Helicopter extraction:";
	level.timer setTimer(level.stopwatch*60);
	
	wait(level.stopwatch*60);
	
	level.timer destroy();
}

music()
{
	flag_wait( "church_tower_explodes" );
	while( !flag( "stop_ambush_music" ) )
	{
		musicPlay( "village_defend_ambush_music" );
		wait 21;
		musicStop( 0.1 );
		wait 0.2;
	}
}

//Datatables and Utilities

killzone_detonation( ent )
{
	squibs = [];
	
	while( 1 )
	{
		squibs[ squibs.size ] = ent;
		
		if( isdefined( ent.target ) )
		{
			ent = getent( ent.target, "targetname" );
		}
		else
		{
			break;
		}
	}
	
	n = 0;
	
	for( i = 0 ; i < squibs.size; i++ )
	{
		squib = squibs[ i ];
		vfx = level.killZoneFxProgram[ n ];
		soundfx = level.killZoneSfx[ n ];
		
		playfx( vfx, squib.origin );
		squib playsound( soundfx );	
		earthquake( 0.1, 0.5, level.player.origin, 1250 );
		radiusDamage(squib.origin, 240, 100500, 100500);	//radiusDamage(origin, range, maxdamage, mindamage);
		
		n++;
		if( n >= level.killZoneFxProgram.size )
		{
			n = 0;
		}	
		
		wait randomfloatrange( 0.05 , 0.15 );
	}
}

killzoneFxProgram()
{
	level.killZoneFxProgram = [];
	
	level.killZoneFxProgram[ 0 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 1 ] = level.killzoneMudExplosion_fx;
	level.killZoneFxProgram[ 2 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 3 ] = level.killzoneFuelExplosion_fx;
	level.killZoneFxProgram[ 4 ] = level.killzoneDirtExplosion_fx;
	level.killZoneFxProgram[ 5 ] = level.killzoneMudExplosion_fx;
	level.killZoneFxProgram[ 6 ] = level.killzoneBigExplosion_fx;
	level.killZoneFxProgram[ 7 ] = level.killzoneFuelExplosion_fx;
	level.killZoneFxProgram[ 8 ] = level.killzoneDirtExplosion_fx;
	level.killZoneFxProgram[ 9 ] = level.killzoneBigExplosion_fx;
	
	level.killZoneSfx = [];
	
	level.killZoneSfx[ 0 ] = "explo_mine";
	level.killZoneSfx[ 1 ] = "explo_tree";
	level.killZoneSfx[ 2 ] = "explo_mine";
	level.killZoneSfx[ 3 ] = "explo_rock";
	level.killZoneSfx[ 4 ] = "explo_roadblock";
	level.killZoneSfx[ 5 ] = "explo_tree";
	level.killZoneSfx[ 6 ] = "explo_mine";
	level.killZoneSfx[ 7 ] = "explo_rock";
	level.killZoneSfx[ 8 ] = "explo_roadblock";
	level.killZoneSfx[ 9 ] = "explo_mine";
	
	assertEX( level.killZoneFxProgram.size == level.killZoneSfx.size, "Fx and Sfx programs should have equal number of entries." );
}

followScriptedPath( node, delayTime, stance )
{
	if( !isdefined( delayTime ) )
		delayTime = 0;
		
	wait delayTime;
	
	nodes = [];
	
	while( 1 )
	{
		nodes[ nodes.size ] = node;
		
		if( isdefined( node.target ) )
		{
			node = getnode( node.target, "targetname" );
		}
		else
		{
			break;
		}
	}
	
	self.disableArrivals = true;
	
	for( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		self setgoalnode( node );
		
		if( isdefined( node.script_stance ) )
			self allowedstances( node.script_stance );
		
		self waittill( "goal" );
		if( !isdefined( node.target ) )
			self notify ("reached_last_node_in_chain");
		if( !isdefined( node.script_noteworthy ) )
			continue;
		if( node.script_noteworthy == "tower_reaction" )
			continue;
			//iprintln( "Team reacts to bell tower explosion!" );
			//TEMP ANIM OF REACTION TO BELL TOWER EXPLOSION
		
		wait 0.1;
	}	
	
	self.disableArrivals = false;
}

friendly_setup()
{
	aAllies = getaiarray( "allies" );	
	for( i = 0; i < aAllies.size; i++ )
	{
		aAllies[ i ] thread hero();
		aAllies[ i ].grenadeammo = 0;
	}
}

hero()
{
	self thread magic_bullet_shield();
	self.IgnoreRandomBulletDamage = true;
}

//self set_run_anim( "path_slow" );
//self clear_run_anim();

encroach_start( node, groupname, msg, squadname, deathmonitorname )
{
	//node - ent - starting main node for enemy infantry attack run
	//groupname - str - targetname of enemy spawners;
	//msg - str - endon
	//squadname - str - script_noteworthy of enemy spawners' starting area on spawner; 
	
	level endon ( msg );
	
	aGroup = [];
	aSquad = [];
	guy = undefined;
	
	aGroup = getentarray( groupname, "targetname" );
	for( i = 0; i < aGroup.size; i++ )
	{
		if( isdefined( aGroup[ i ].script_noteworthy ) )
		{
			if( aGroup[ i ].script_noteworthy == squadname )
			{
				aSquad[ aSquad.size ] = aGroup[ i ];
			}
		}
	}
	
	for( i = 0; i < aSquad.size; i++ )
	{
		aSquad[ i ].count = 1;
		guy = aSquad[ i ] stalingradSpawn();
		if( spawn_failed( guy ) )
		{
			return;
		}
		
		guy thread encroach_nav( node, msg );
		
		minigun = getent( "minigun", "targetname" );
		minigunUser = minigun getTurretOwner();
		if((isdefined(minigunUser) && level.player == minigunUser))
		{
			guy.baseAccuracy = 5;
		}
		
		if( isdefined( deathmonitorname ) )
		{
			if( deathmonitorname == "southern_hill" )
				guy thread southern_hill_deathmonitor();
		}
		
		if( isdefined( deathmonitorname ) )
		{
			if( deathmonitorname == "minigun_breach" )
				guy thread minigun_breach_deathmonitor();
		}
	}
}

encroach_nav( node, msg )
{
	level endon ( msg );
	self endon ( "death" );
	
	if( !flag( "objective_minigun_baglimit_done" ) )
	{
		aRoutes = [];
		startNode = node;
		n = undefined;
		while( 1 )
		{
			aRoutes[ aRoutes.size ] = startNode;
			if( isdefined( startNode.target ) )
			{
				aBranchNodes = getnodearray( startNode.target, "targetname" );
				assertEX( aBranchNodes.size > 0, "At least one node should be targeted for encroach_nav routes" );
				
				n = randomint( aBranchNodes.size );
				startNode = aBranchNodes[ n ];
			}
			else
			{
				break;
			}
		}
		
		for( i = 0; i < aRoutes.size; i++ )
		{
			self setgoalnode( aRoutes[ i ] );
			self waittill ( "goal" );
			wait randomfloatrange( level.encroachMinWait, level.encroachMaxWait );
		}
		
		//flag_wait( "objective_minigun_baglimit_done" );
		flag_wait( "divert_for_clacker" );
	}
	
	self thread hunt_player();
	self thread helidrop_clacker_divert();
}

southern_hill_mortar_detonate( squib )
{
	//squib = origin ent
	//inFX = incoming sound
	//detFX = explosion sound
	
	vfx = level.killzoneBigExplosion_fx;
	inFX = "artillery_incoming";
	detFX = [];
	detFX[ 0 ] = "explo_mine";
	detFX[ 1 ] = "explo_rock";
	detFX[ 2 ] = "explo_tree";
	
	squib playsound( inFX );
	wait 0.25;
		
	playfx( vfx, squib.origin );
	
	j = randomintrange( 0, detFX.size );
	detSound = detFX[ j ];
	squib playsound( detSound );
	earthquake( 0.35, 0.5, level.player.origin, 1250 );
	radiusDamage(squib.origin, 256, 1000, 500);	//radiusDamage(origin, range, maxdamage, mindamage);
}

//=======================================================================

player_detection_volume_init()
{
	flag_wait( "fall_back_to_barn" );
	
	//Detect player position using isTouching volume

	aVolumes = getentarray( "player_detection_volume", "targetname" );
	
	for( i = 0; i < aVolumes.size; i++ )
	{
		thread player_detection_loop( aVolumes[ i ] );
	}
}

player_detection_loop( detectionVolume )
{
	while( 1 )
	{
		//Check AI population capacity before spawning
		
		aAxis = getaiarray( "axis" );
		aAllies = getaiarray( "allies" );
		
		//Some overspawning is ok but not too much
		
		aiPop = aAxis.size + aAllies.size;
		slotsAvailable = level.maxAI - aiPop;
		
		if( slotsAvailable >= level.reqSlots )
		{
			if( level.player isTouching( detectionVolume ) )
			{
				thread ai_spawnprocessor( detectionVolume );
			}
			
			wait level.detectionCycleTime;
		}
		
		wait 0.5;
	}
}

ai_spawnprocessor( detectionVolume )
{
	//Activate the spawn processors for this detection volume
	
	aSpawnProcs = getentarray( detectionVolume.target, "targetname" );
	
	for( i = 0; i < aSpawnProcs.size; i++ )
	{
		thread ai_spawn_control_set_create( aSpawnProcs[ i ], detectionVolume );
	}	
}

ai_spawn_control_set_create( spawnProc, detectionVolume )
{	
	//Get the spawners for this unit
	
	aProcSpawners = [];
	
	aSpawners = getspawnerarray();
	for( i = 0; i < aSpawners.size; i++ )
	{
		spawner = aSpawners[ i ];
		
		if( !isdefined( spawner.targetname ) )
			continue;
		
		if( spawner.targetname == spawnProc.target )
		{
			aProcSpawners[ aProcSpawners.size ] = spawner;
		}
	}
	
	//Check for smokescreen usage on this unit and get the smoke generator if it exists
	
	smokeEnt = undefined;
	aProcEnts = [];
	aProcEnts = getentarray( spawnProc.target, "targetname" );
	
	for( i = 0; i < aProcEnts.size; i++ )
	{			
		procEnt = aProcEnts[ i ];
	
		if( !isdefined( procEnt.script_noteworthy ) )
		{
			continue;
		}
		
		if( procEnt.script_noteworthy == "smoke_generator" )
		{
			smokeEnt = procEnt;
			break;
		}
	}
	
	//Get the flank routing node for this unit
	
	routeNode = undefined;
	assertEX( isdefined( spawnProc.script_namenumber ), "Spawn processor is missing a routing label e.g. AR15" );
	routeID = spawnProc.script_namenumber;
	
	aRouteNodes = getnodearray( "flanking_route", "targetname" );
	for( i = 0; i < aRouteNodes.size; i++ )
	{
		routeStartNode = aRouteNodes[ i ];
		
		if( !isdefined( routeStartNode.script_noteworthy ) )
			continue;
		
		if( routeStartNode.script_noteworthy == routeID )
		{
			routeNode = routeStartNode;
			break;
		}
	}
	
	thread ai_spawn_and_attack( aProcSpawners, smokeEnt, routeNode, detectionVolume );
}

ai_spawn_and_attack( spawners, smokeEnt, routeNode, detectionVolume )
{
	//If smoke is being deployed to cover the spawn:
	//1. Wait X seconds for the smoke to build to sufficient opacity and size
	//2. Confirm that the player is far enough from the smoke cloud origin
	//3. Spawn and attack along assigned routes and run the reacquisition monitor 
	
	if( isdefined( smokeEnt ) )
	{
		playfx( level.smokegrenade, smokeEnt.origin );
		wait level.smokeBuildTime;
		
		dist = length( level.player.origin - smokeEnt.origin );
		if( dist < level.smokeSpawnSafeDist )
		{
			return;
		}
	}
	
	//If smoke is not being used to cover the spawn:
	//1. Spawn and attack along assigned routes and run the reacquisition monitor 
	
	for( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[ i ];
		spawners[ i ].count = 1;
		guy = spawner stalingradSpawn();
		if( spawn_failed( guy ) )
		{
			continue;
		}
		
		guy thread ai_flank_route( routeNode );
		guy thread ai_reacquire_player( detectionVolume );
	}
}

ai_flank_route( routeNode )
{
	self endon ( "death" );
	self endon ( "reacquire_player" );
	
	while( 1 )
	{
		self setgoalnode( routeNode );
		self waittill ( "goal" );
		
		if( isdefined( routeNode.script_node_pausetime ) )
		{
			pauseTime = routeNode.script_node_pausetime + randomfloatrange( 0.5, 1.5 );
			
			wait( pauseTime );
		}
		
		if( !isdefined( routeNode.target ) )
		{
			self thread hunt_player();
			break;
		}
		
		routeNode = getnode( routeNode.target, "targetname" );
	}
}

ai_reacquire_player( detectionVolume )
{	
	//If player leaves the original detection volume substantially, the
	//1. Check to see that the player is still touching the volume.
	//2. Wait a bit, then resample to see if the player is still touching the volume.
	//3. If not, send the guy after the player using hunt_player.

	self endon ( "death" );
	
	while( 1 )
	{
		if( !level.player isTouching ( detectionVolume ) )
		{
			wait level.volumeDesertionTime;
			
			if( !level.player isTouching ( detectionVolume ) )
			{
				self notify ( "reacquire_player" );
				wait 0.5;
				self thread hunt_player();
				break;
			}
		}
		
		wait level.detectionRefreshTime;
	}
}

//=======================================================================

airstrike()
{
	level endon ( "seaknight_arrives" );
	level.warningSpeechCounter = 0;
	
	while( 1 )
	{
		//1. track player location and find out which airstrike_marker he is closest to
		
		aMarkers = getentarray( "airstrike_marker", "targetname" );
		olddist = 0;
		currentAirstrikeMarker = undefined;
		
		for( i = 0; i < aMarkers.size; i++ )
		{
			marker = aMarkers[ i ];
			
			newdist = length( level.player.origin - marker.origin );
			
			if( olddist == 0 )
				olddist = newdist;
				
			if( newdist > olddist )
				continue;
				
			olddist = newdist;
			currentAirstrikeMarker = marker;
		}
		
		//2. fly a warning pass over player location
		
		warningFlybyPlane = spawn_vehicle_from_targetname_and_drive( currentAirstrikeMarker.target );
		
		if ( !level.warningSpeechCounter )
		{
			//"Enemy MiGs flying close-air support! We've got to get clear of this area before they call an airstrike on us!"
			iprintln( "Enemy MiGs flying close-air support! We've got to get clear of this area before they call an airstrike on us!" );
			radio_dialogue_queue( "enemymigsupport" );
		
			//"Gaz is right! We're sitting ducks for those MiGs! We've got to displace, now!"
			iprintln( "Gaz is right! We're sitting ducks for those MiGs! We've got to displace, now!" );
			radio_dialogue_queue( "sittingducks" );
			
			level.warningSpeechCounter++;
		}
		else
		if( level.warningSpeechCounter == 1 )
		{
			//"Another enemy airstrike on the way! Get to cover!!!"
			iprintln( "Another enemy airstrike on the way! Get to cover!!!" );
			radio_dialogue_queue( "anotherstrike" );
			level.warningSpeechCounter++;
		}
		else
		if( level.warningSpeechCounter == 2 )
		{
			//"More MiGs! Take cover!"
			iprintln( "More MiGs! Take cover!" );
			radio_dialogue_queue( "moremigs" );
			level.warningSpeechCounter++;
		}
		else
		if( level.warningSpeechCounter == 3 )
		{
			//"Enemy airstrike is inbound. Get clear! Move!"
			iprintln( "Enemy airstrike is inbound. Get clear! Move!" );
			radio_dialogue_queue( "strikeinbound" );
			level.warningSpeechCounter = 0;
		}
		
		objective_add( 9, "active", "Break through the enemy forces before the enemy airstrike hits." );
		objective_current( 9 ); 
		
		//3. wait a bit, then deploy the real thing.
		
		wait level.strikeZoneGracePeriod;
		
		dangerCloseDist = length( level.player.origin - currentAirstrikeMarker.origin );
		if( dangerCloseDist <= level.dangerCloseSafeDist )
		{
			thread callStrike( level.player.origin + ( 128, 196, 0 ) );	//some offset
		}
		else
		{
			thread callStrike( currentAirstrikeMarker.origin + ( 256, 256, 0 ) );	//some offset
		}
		
		//4. Long cooldown period
		
		wait 3;
		objective_state( 9, "done" );
		wait 3;
		objective_delete( 9 );
		
		wait 20;
		
		iprintlnbold( "End of current level" );
		
		wait 15;
		
		missionsuccess( "ambush", false );
		
		wait level.airstrikeCooldown;
	}
}

callStrike( coord )
{	
	// Get starting and ending point for the plane
	direction = ( 0, randomint( 360 ), 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( .3, 1 );
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
}

vector_scale(vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

doPlaneStrike( bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	// Spawn the planes
	//plane = spawnplane( "script_model", pathStart );
	
	plane = spawn( "script_model", pathStart );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	plane thread playContrail();
	
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	thread callStrike_planeSound( plane, bombsite );
	
	// callStrike_bomb( bomb time, bomb location, number of bombs )
	thread callStrike_bombEffect( plane, bombTime - 1.0 );
	//thread callStrike_bomb( bombTime, bombsite, 2, owner );
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

playContrail()
{
	self endon ( "death" );
	
	if ( !isDefined( level.mapCenter ) )
		mapCenter = (0,0,0);
	else
		mapCenter = level.mapCenter;
	
	while ( isdefined( self ) )
	{
		if ( distance( self.origin , mapCenter ) <= 4000 )
		{
			playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
			playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
			return;
		}
		wait 0.05;
	}
}

callStrike_planeSound( plane, bombsite )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}

callStrike_bombEffect( plane, launchTime )
{
	wait ( launchTime );
	
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	
	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	
	wait ( 1.0 );
	newBomb = spawn( "script_model", bomb.origin );
	newBomb setModel( "tag_origin" );
	newBomb.origin = bomb.origin;
	newBomb.angles = bomb.angles;
	wait (0.05);
	
	bomb delete();
	bomb = newBomb;
	
	bombOrigin = bomb.origin;
	bombAngles = bomb.angles;
	playfxontag( level.airstrikefx, bomb, "tag_origin" );
//	bomb hide();
	
	wait ( 0.5 );
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		
		radiusDamage( traceHit + (0,0,16), 512, 200, 30); // targetpos, radius, maxdamage, mindamage
		
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "artillery_impact", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}
		
		wait ( 0.75/repeat );
	}
	wait ( 1.0 );
	bomb delete();
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}

spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "projectile_cbu97_clusterbomb" );
	
	return bomb;
}
