// 
// _version.gsh
//
// Contains version #defines for the clientfield system.
//
// To Blame : Dan Laufer.
// 
// Format :
// 
// Add FFOTD updates, as needed in the format of :
// #define <SIGNIFICANT_VERSION>_FFOTD_MMDDYY_VER  <LAST VERSION IN GROUP> + 1
//
// i.e.
//
// #define	VERSION_TU1					1000
// #define	VERSION_TU1_FFOTD_010113_0	1001
// #define	VERSION_TU1_FFOTD_010713_0	1002
//
// #define	VERSION_TU2					2000

// #define	VERSION_TU2_FFOTD_031813_0	2001
// #define	VERSION_TU2_FFOTD_031813_1	2002
// #define	VERSION_TU2_FFOTD_031813_2	2003
// #define	VERSION_TU2_FFOTD_031913_0	2004
//
// The MMDDYY specified is the date you make the change - not the day that the FFOTD is to be posted.
// _VER is just incremented based on additional changes made same day - or be smart, and just use what's already there for the same day - as long as no FFOTD has already
// been posted, using that data.

// VERSION_SHIP is 1, rather than 0 - so that I can use 0 as a 'wait - we've not recieved anything from the server yet' debug clue.



//--------------------------------------










	// XBox DLC1 ship





	// Xbox DLC2 ship





	// Xbox DLC3 ship











// .... expand as needed.

// DLC Versions should be set to match the current in progress _TU define, and updated to the shipping XBOX TU number at ship.

//--------------------------------------










	



// These are used to pinpoint when a ClientField became obsolete. We use a negative version to signify obsolesence,
// and the absolute value is the version at which obsolesence occurred. This allows us to reenable the ClientField at a
// later date if need be using a new standard (i.e. positive valued) version number

//--------------------------------------

