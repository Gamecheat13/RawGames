// _constants.gsc

main()
{
	level.CONTENTS_SOLID =				(1 << 0);
	level.CONTENTS_FOLIAGE =			(1 << 1);
	level.CONTENTS_AI_AVOID =			(1 << 2);
	level.CONTENTS_VEHICLETRIGGER = 	(1 << 3);
	level.CONTENTS_GLASS =				(1 << 4);
	level.CONTENTS_WATER =				(1 << 5);
	level.CONTENTS_CANSHOOTCLIP =		(1 << 6);
	level.CONTENTS_MISSILECLIP =		(1 << 7);
	level.CONTENTS_ITEM =				(1 << 8);
	level.CONTENTS_VEHICLECLIP =		(1 << 9);
	level.CONTENTS_ITEMCLIP =			(1 << 10);
	level.CONTENTS_SKY =				(1 << 11);
	level.CONTENTS_AI_NOSIGHT =			(1 << 12);	// AI cannot see through this
	level.CONTENTS_CLIPSHOT =			(1 << 13);	// bullets hit this
	level.CONTENTS_CORPSE_CLIPSHOT =	(1 << 14);	// to get bullets to hit corpses, but not grenade radius damage; should never be on a brush, only in game
	level.CONTENTS_ACTOR =				0;
	level.CONTENTS_FAKE_ACTOR =			0;
	level.CONTENTS_PLAYERCLIP =			(1 << 16);
	level.CONTENTS_MONSTERCLIP =		(1 << 17);
	level.CONTENTS_AXISTRIGGER =		(1 << 18);
	level.CONTENTS_ALLIESTRIGGER =		(1 << 19);
	level.CONTENTS_NEUTRALTRIGGER =		(1 << 20);
	level.CONTENTS_USE =				(1 << 21);
	level.CONTENTS_NONSENTIENTTRIGGER = (1 << 22);
	level.CONTENTS_VEHICLE =			(1 << 23);
	level.CONTENTS_TRAVERSAL =			(1 << 24);	// used for mantle / ladder / ledge / pipe traversals
	level.CONTENTS_PLAYER =				(1 << 25);
	level.CONTENTS_CORPSE =				(1 << 26);
	level.CONTENTS_PLAYER_COVER =		(1 << 28);
	level.CONTENTS_LOOKAT =				(1 << 29);
	level.CONTENTS_PLAYERTRIGGER =		(1 << 30);
	level.CONTENTS_DARKNESS =			(1 << 31);
}
