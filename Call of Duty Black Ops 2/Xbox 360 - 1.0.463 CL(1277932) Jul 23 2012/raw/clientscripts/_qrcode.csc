//this file is intended as a central repository for all qrcode setup 
//doing it in this single place enables a simple update via ffotd to update all of the qr codes defined in the game

//12 slots are defined and should be used in the following way only:

// slot 0 :  element for scene use - can be reused in a level as long as scripter controls locality
// slot 1 :  element for scene use - can be reused in a level as long as scripter controls locality
// slot 2 :  element for scene use - can be reused in a level as long as scripter controls locality
// slot 3 :  element for scene use - can be reused in a level as long as scripter controls locality
// slot 4 :  lui use only
// slot 5 :  element that may pop up dynamically - i.e. location specific callout
// slot 6 :  element that may pop up dynamically - i.e. location specific callout
// slot 7 :  element for collectible 1
// slot 8 :  element for collectible 2
// slot 9 :  element for collectible 3
// slot 10:  element for menu where menu or code will dynamically set when menu needed
// slot 11:  element for developer commentary

init()
{
	level.music_tracks_qr=array("http://itunes/sales");
}

//use the userrequest to provide a way to select from multiple options
//e.g. setup_qr_code("karma",0,"elevator");
//or setup_qr_code("karma",0,"pool");
// which would reuse a slot in 2 locations
//code that by creating a switch on the userrequest var
setup_qr_code(mapname, slot, userrequest)
{
	if (isdefined(mapname))
	{
		switch(mapname)
		{
		case "blackout":
			CreateQRCode("http://treyarch.com",0);
			break;
		case "haiti":
			break;
		case "karma":
			CreateQRCode("http://treyarch.com",0);
			break;
		case "karma_2":
			break;
		case "la_1":
		case "la_1b":
		case "la_2":
		case "monsoon":
		case "pakistan":
		case "pakistan_2":
		case "pakistan_3":
		case "yemen":
			break;
		case "frontend":
			switch(slot)
			{
			case 0:
			case 1:
			case 2:
				break;
			case 3://using only for music track info 
				CreateQRCode(level.music_tracks_qr[userrequest],3);	
				break;
			}
		}
	}
}