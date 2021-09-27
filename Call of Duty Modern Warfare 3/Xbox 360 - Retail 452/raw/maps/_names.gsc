#include common_scripts\utility;

main()
{
}

setup_names()
{
	if ( isdefined( level.names ) )
		return;
		
	nationalities = [];
	nationalities[ nationalities.size ] = "american";
	nationalities[ nationalities.size ] = "seal";
	nationalities[ nationalities.size ] = "taskforce";
	nationalities[ nationalities.size ] = "secretservice";
	nationalities[ nationalities.size ] = "british";
	nationalities[ nationalities.size ] = "arab";
	nationalities[ nationalities.size ] = "russian";
	nationalities[ nationalities.size ] = "multilingual";
	nationalities[ nationalities.size ] = "portuguese";
	nationalities[ nationalities.size ] = "shadowcompany";
	nationalities[ nationalities.size ] = "delta";
	nationalities[ nationalities.size ] = "french";
	nationalities[ nationalities.size ] = "african";
	nationalities[ nationalities.size ] = "czech";
	nationalities[ nationalities.size ] = "czech_surnames";
	nationalities[ nationalities.size ] = "pmc";

	for ( i = 0; i < nationalities.size; i++ )
		level.names[ nationalities[ i ] ] = [];

	// American names will ideally match 1:1 with names that we've recorded, so the friendlies will more obviously talk to each other
	add_name( "american", "Abbott" ); 
	add_name( "american", "Abeles" ); 
	add_name( "american", "Ackrich" ); 
	add_name( "american", "Alvarez" ); 
	add_name( "american", "Andaya" ); 
	add_name( "american", "Andrew" ); 
	add_name( "american", "Arcovitch" ); 
	add_name( "american", "Arem" ); 
	add_name( "american", "Arya" ); 
	add_name( "american", "Audick" ); 
	add_name( "american", "Aye" ); 
	add_name( "american", "Babichenko" ); 
	add_name( "american", "Baker" ); 
	add_name( "american", "Bartolucci" ); 
	add_name( "american", "Beahm" ); 
	add_name( "american", "Bedi" ); 
	add_name( "american", "Bein" ); 
	add_name( "american", "Bell" ); 
	add_name( "american", "Benitez" ); 
	add_name( "american", "Berry" ); 
	add_name( "american", "Blizard" ); 
	add_name( "american", "Blumel" ); 
	add_name( "american", "Boon" ); 
	add_name( "american", "Bowling" ); 
	add_name( "american", "Boyd" ); 
	add_name( "american", "Bracamontes" ); 
	add_name( "american", "Brooks" ); 
	add_name( "american", "Brown" ); 
	add_name( "american", "Buchanan" ); 
	add_name( "american", "Buckles" ); 
	add_name( "american", "Capen" ); 
	add_name( "american", "Casey" ); 
	add_name( "american", "Cecot" ); 
	add_name( "american", "Centkowski" ); 
	add_name( "american", "Chan" ); 
	add_name( "american", "Chang" ); 
	add_name( "american", "Chen" ); 
	add_name( "american", "Chew" ); 
	add_name( "american", "Chu" ); 
	add_name( "american", "Chyo" ); 
	add_name( "american", "Cinquegrano" ); 
	add_name( "american", "Clark" ); 
	add_name( "american", "Condrey" ); 
	add_name( "american", "Conteras" ); 
	add_name( "american", "Cournoyer" ); 
	add_name( "american", "Curley" ); 
	add_name( "american", "Daley" ); 
	add_name( "american", "David" ); 
	add_name( "american", "Davis" ); 
	add_name( "american", "DeBolt" ); 
	add_name( "american", "DeMartini" ); 
	add_name( "american", "Denny" ); 
	add_name( "american", "Deonarine" ); 
	add_name( "american", "DeRidder" ); 
	add_name( "american", "Desmarais" ); 
	add_name( "american", "DiMeo" ); 
	add_name( "american", "Dobbie" ); 
	add_name( "american", "Dohr" ); 
	add_name( "american", "Dolan" ); 
	add_name( "american", "Drinkward" ); 
	add_name( "american", "Dye" ); 
	add_name( "american", "Eady" ); 
	add_name( "american", "Evans" ); 
	add_name( "american", "Feinberg" ); 
	add_name( "american", "Felker" ); 
	add_name( "american", "Field" ); 
	add_name( "american", "Fong" ); 
	add_name( "american", "Ganus" ); 
	add_name( "american", "Gavazza" ); 
	add_name( "american", "Gavrisheff" ); 
	add_name( "american", "Gevorkian" ); 
	add_name( "american", "Giesler" ); 
	add_name( "american", "Gil" ); 
	add_name( "american", "Glasco" ); 
	add_name( "american", "Goldsworthy" ); 
	add_name( "american", "Griffith" ); 
	add_name( "american", "Gu" ); 
	add_name( "american", "Guaman" ); 
	add_name( "american", "Gunasingam" ); 
	add_name( "american", "Hall" ); 
	add_name( "american", "Halon" ); 
	add_name( "american", "Harmer" ); 
	add_name( "american", "Harries" ); 
	add_name( "american", "Harris" ); 
	add_name( "american", "Haugen" ); 
	add_name( "american", "Haworth" ); 
	add_name( "american", "Hazelroth" ); 
	add_name( "american", "Heath" ); 
	add_name( "american", "Hirsh" ); 
	add_name( "american", "Holmes" ); 
	add_name( "american", "Hook" ); 
	add_name( "american", "Hudson" ); 
	add_name( "american", "Imai" ); 
	add_name( "american", "Jeffries" ); 
	add_name( "american", "Johnson" ); 
	add_name( "american", "Katz" ); 
	add_name( "american", "Keiser" ); 
	add_name( "american", "Kelvin" ); 
	add_name( "american", "Kinney" ); 
	add_name( "american", "Kriegler" ); 
	add_name( "american", "Kuhn" ); 
	add_name( "american", "Kuo" ); 
	add_name( "american", "Kwak" ); 
	add_name( "american", "Lai" ); 
	add_name( "american", "Lam" ); 
	add_name( "american", "Lamperski" ); 
	add_name( "american", "Lane" ); 
	add_name( "american", "Leal" ); 
	add_name( "american", "Lee" ); 
	add_name( "american", "Liang" ); 
	add_name( "american", "Lie" ); 
	add_name( "american", "Lin" ); 
	add_name( "american", "Lodato" ); 
	add_name( "american", "Longland" ); 
	add_name( "american", "Lopez" ); 
	add_name( "american", "Lor" ); 
	add_name( "american", "Louie" ); 
	add_name( "american", "Luo" ); 
	add_name( "american", "Luyties" ); 
	add_name( "american", "Madrid" ); 
	add_name( "american", "Mai" ); 
	add_name( "american", "McDonald" ); 
	add_name( "american", "McEntyre" ); 
	add_name( "american", "McGrath" ); 
	add_name( "american", "McGree" ); 
	add_name( "american", "McLeran" ); 
	add_name( "american", "Mermelstein" ); 
	add_name( "american", "Miller" ); 
	add_name( "american", "Munson" ); 
	add_name( "american", "Myers" ); 
	add_name( "american", "Naas" ); 
	add_name( "american", "Nacu" ); 
	add_name( "american", "Nahashon" ); 
	add_name( "american", "Neel" ); 
	add_name( "american", "O'Connor" ); 
	add_name( "american", "O'Hara" ); 
	add_name( "american", "Onur" ); 
	add_name( "american", "Pacheco" ); 
	add_name( "american", "Pavey" ); 
	add_name( "american", "Pavlich" ); 
	add_name( "american", "Peacher" ); 
	add_name( "american", "Peas" ); 
	add_name( "american", "Pelayo" ); 
	add_name( "american", "Pennya" ); 
	add_name( "american", "Pierce" ); 
	add_name( "american", "Pineda" ); 
	add_name( "american", "Pitts" ); 
	add_name( "american", "Porter" ); 
	add_name( "american", "Proudfoot" ); 
	add_name( "american", "Reisdorf" ); 
	add_name( "american", "Robbins" ); 
	add_name( "american", "Rowell" ); 
	add_name( "american", "Rubin" ); 
	add_name( "american", "Ruiz" ); 
	add_name( "american", "Ryu" ); 
	add_name( "american", "Sahas" ); 
	add_name( "american", "Salud" ); 
	add_name( "american", "Sanborn" ); 
	add_name( "american", "Sandler" ); 
	add_name( "american", "Sarkisyan" ); 
	add_name( "american", "Schmill" ); 
	add_name( "american", "Schofield" ); 
	add_name( "american", "Shande" ); 
	add_name( "american", "Sharp" ); 
	add_name( "american", "Shellikeri" ); 
	add_name( "american", "Shepherd" ); 
	add_name( "american", "Sheu" ); 
	add_name( "american", "Sidey" ); 
	add_name( "american", "Silvers" ); 
	add_name( "american", "Simas" ); 
	add_name( "american", "Smith" ); 
	add_name( "american", "Soucy" ); 
	add_name( "american", "Sperry" ); 
	add_name( "american", "Staples" ); 
	add_name( "american", "Stone" ); 
	add_name( "american", "Stoughton" ); 
	add_name( "american", "Strickland" ); 
	add_name( "american", "Suarez" ); 
	add_name( "american", "SullivanLee" ); 
	add_name( "american", "Swenson" ); 
	add_name( "american", "T" ); 
	add_name( "american", "Taehoon" ); 
	add_name( "american", "Tang" ); 
	add_name( "american", "Turner" ); 
	add_name( "american", "Veca" ); 
	add_name( "american", "Vitalone" ); 
	add_name( "american", "Volker" ); 
	add_name( "american", "Vuong" ); 
	add_name( "american", "Wapner" ); 
	add_name( "american", "Wasilczyk" ); 
	add_name( "american", "Webb" ); 
	add_name( "american", "West" ); 
	add_name( "american", "Whelpley" ); 
	add_name( "american", "Whitney" ); 
	add_name( "american", "Whitten" ); 
	add_name( "american", "Wrede" ); 
	add_name( "american", "Wright" ); 
	add_name( "american", "Yang" ); 
	add_name( "american", "Zaiya" ); 
	add_name( "american", "Zaring" ); 
	add_name( "american", "Zipkin" ); 


	add_name( "seal", "Angel" );
	add_name( "seal", "Apex" );
	add_name( "seal", "Bearcat" );
	add_name( "seal", "Bishop" );
	add_name( "seal", "Boomer" );
	add_name( "seal", "Boxer" );
	add_name( "seal", "Canine" );
	add_name( "seal", "Chemist" );
	add_name( "seal", "Chemo" );
	add_name( "seal", "Cherub" );
	add_name( "seal", "Chino" );
	add_name( "seal", "Coffin" );
	add_name( "seal", "Coma" );
	add_name( "seal", "Cyclops" );
	add_name( "seal", "Cypher" );
	add_name( "seal", "Doc" );
	add_name( "seal", "Druid" );
	add_name( "seal", "Exxon" );
	add_name( "seal", "Gator" );
	add_name( "seal", "Hannibal" );
	add_name( "seal", "Hazard" );
	add_name( "seal", "Hitman" );
	add_name( "seal", "Jayhawk" );
	add_name( "seal", "Jester" );
	add_name( "seal", "Justice" );
	add_name( "seal", "Klepto" );
	add_name( "seal", "Kojak" );
	add_name( "seal", "Langley" );
	add_name( "seal", "Neptune" );
	add_name( "seal", "Mamba" );
	add_name( "seal", "Midnight" );
	add_name( "seal", "Neon" );
	add_name( "seal", "Nomad" );
	add_name( "seal", "Ogre" );
	add_name( "seal", "Ozone" );
	add_name( "seal", "Patron" );
	add_name( "seal", "Pharaoh" );
	add_name( "seal", "Pieces" );
	add_name( "seal", "Poet" );
	add_name( "seal", "Preacher" );
	add_name( "seal", "Reaper" );
	add_name( "seal", "Redcell" );
	add_name( "seal", "Roadie" );
	add_name( "seal", "Robot" );
	add_name( "seal", "Rocket" );
	add_name( "seal", "Rooster" );
	add_name( "seal", "Sparrow" );
	add_name( "seal", "Taco" );
	add_name( "seal", "Thumper" );
	add_name( "seal", "Trojan" );
	add_name( "seal", "Twister" );
	add_name( "seal", "Undertone" );
	add_name( "seal", "Utah" );
	add_name( "seal", "Whiskey" );
	add_name( "seal", "Worm" );
	add_name( "seal", "Yankee" );
	add_name( "seal", "Zero" );
	
	
	// taskforce = seal, but the non-stealth version
	copy_names( "taskforce", "seal" );
	
	// delta = seal, but loud and with american voices
	copy_names( "delta", "seal" );	
	
	add_name( "secretservice", "Smith" );
	add_name( "secretservice", "Jones" );
	add_name( "secretservice", "Jackson" );
	add_name( "secretservice", "Johnson" );
	add_name( "secretservice", "Thompson" );
	add_name( "secretservice", "Ash" );
	add_name( "secretservice", "Bird" );
	add_name( "secretservice", "Finn" );
	add_name( "secretservice", "Fine" );
	add_name( "secretservice", "Brown" );
	add_name( "secretservice", "White" );
	add_name( "secretservice", "Gray" );
	add_name( "secretservice", "Black" );
	add_name( "secretservice", "Wylie" );
	add_name( "secretservice", "Rosenhaus" );
	add_name( "secretservice", "Boras" );
	add_name( "secretservice", "McKinnis" );
	add_name( "secretservice", "Duffy" );
	add_name( "secretservice", "Falk" );
	add_name( "secretservice", "Tellem" );
	add_name( "secretservice", "Goodwin" );
	add_name( "secretservice", "Condon" );
	add_name( "secretservice", "Parker" );
	add_name( "secretservice", "McGuire" );
	add_name( "secretservice", "Steinberg" );


	add_name( "british", "Abbot" );
	add_name( "british", "Adams" );
	add_name( "british", "Bartlett" );
	add_name( "british", "Boyd" );
	add_name( "british", "Boyle" );
	add_name( "british", "Bremner" );
	add_name( "british", "Carlyle" );
	add_name( "british", "Carver" );
	add_name( "british", "Cheek" );
	add_name( "british", "Clarke" );
	add_name( "british", "Collins" );
	add_name( "british", "Compton" );
	add_name( "british", "Connolly" );
	add_name( "british", "Cook" );
	add_name( "british", "Dowd" );
	add_name( "british", "Field" );
	add_name( "british", "Fleming" );
	add_name( "british", "Fletcher" );
	add_name( "british", "Flynn" );
	add_name( "british", "Grant" );
	add_name( "british", "Greaves" );
	add_name( "british", "Harris" );
	add_name( "british", "Harrison" );
	add_name( "british", "Heath" );
	add_name( "british", "Henderson" );
	add_name( "british", "Hopkins" );
	add_name( "british", "Hoyt" );
	add_name( "british", "Kent" );
	add_name( "british", "Lewis" );
	add_name( "british", "Lipton" );
	add_name( "british", "Macdonald" );
	add_name( "british", "Maxwell" );
	add_name( "british", "McQuarrie" );
	add_name( "british", "Miller" );
	add_name( "british", "Mitchell" );
	add_name( "british", "Moore" );
	add_name( "british", "Murphy" );
	add_name( "british", "Murray" );
	add_name( "british", "Pearce" );
	add_name( "british", "Plumber" );
	add_name( "british", "Pritchard" );
	add_name( "british", "Rankin" );
	add_name( "british", "Reed" );
	add_name( "british", "Ritchie" );
	add_name( "british", "Ross" );
	add_name( "british", "Roth" );
	add_name( "british", "Smith" );
	add_name( "british", "Stevenson" );
	add_name( "british", "Stuart" );
	add_name( "british", "Sullivan" );
	add_name( "british", "Thompson" );
	add_name( "british", "Veale" );
	add_name( "british", "Wallace" );
	add_name( "british", "Wells" );
	add_name( "british", "Welsh" );


	add_name( "russian", "Sasha Ivanov" );
	add_name( "russian", "Aleksei Vyshinskiy" );
	add_name( "russian", "Boris Ryzhkov" );
	add_name( "russian", "Dima Tikhonov" );
	add_name( "russian", "Oleg Kosygin" );
	add_name( "russian", "Pyotr Bulganin" );
	add_name( "russian", "Petya Malenkov" );
	add_name( "russian", "Alyosha Tarkovsky" );
	add_name( "russian", "Sergei Grombyo" );
	add_name( "russian", "Viktor Kuznetsov" );
	add_name( "russian", "Misha Podgorniy" );
	add_name( "russian", "Borya Mikoyan" );
	add_name( "russian", "Anatoly Voroshilov" );
	add_name( "russian", "Kolya Shvernik" );
	add_name( "russian", "Nikolai Kalinin" );
	add_name( "russian", "Vladimir Brezhnev" );
	add_name( "russian", "Pavel Chernenko" );
	add_name( "russian", "Volodya Andropov" );
	add_name( "russian", "Yuri Nikitin" );
	add_name( "russian", "Dmitri Petrenko" );
	add_name( "russian", "Vanya Gerasimov" );
	add_name( "russian", "Mikhail Zhuravlev" );
	add_name( "russian", "Ivan Lukin" );
	add_name( "russian", "Kostya Golubev" );
	add_name( "russian", "Konstantin Lebedev" );
	add_name( "russian", "Aleksandr Vasilev" );
	add_name( "russian", "Yakov Glushenko" );
	add_name( "russian", "Sasha Semenov" );
	add_name( "russian", "Aleksei Ulyanov" );
	add_name( "russian", "Boris Yefremov" );
	add_name( "russian", "Dima Chernyshenko" );
	add_name( "russian", "Oleg Stepanoshvili" );
	add_name( "russian", "Pyotr Demchenko" );
	add_name( "russian", "Petya Avagimov" );
	add_name( "russian", "Alyosha Murzaev" );
	add_name( "russian", "Sergei Shkuratov" );
	add_name( "russian", "Viktor Yakimenko" );
	add_name( "russian", "Misha Masijashvili" );
	add_name( "russian", "Borya Shapovalov" );
	add_name( "russian", "Anatoly Ivashenko" );
	add_name( "russian", "Kolya Dovzhenko" );
	add_name( "russian", "Nikolai Turdyev" );
	add_name( "russian", "Vladimir Sabgaida" );
	add_name( "russian", "Pavel Svirin" );
	add_name( "russian", "Volodya Sarayev" );
	add_name( "russian", "Yuri Kiselev" );
	add_name( "russian", "Dmitri Bondarenko" );
	add_name( "russian", "Vanya Chernogolov" );
	add_name( "russian", "Mikhail Voronov" );
	add_name( "russian", "Ivan Afanasyev" );
	add_name( "russian", "Kostya Gridin" );
	add_name( "russian", "Konstantin Petrov" );
	add_name( "russian", "Aleksandr Rykov" );
	add_name( "russian", "Yakov Shvedov" );


	add_name( "arab", "Abdulaziz" );
	add_name( "arab", "Abdullah" );
	add_name( "arab", "Ali" );
	add_name( "arab", "Amin" );
	add_name( "arab", "Bassam" );
	add_name( "arab", "Fahd" );
	add_name( "arab", "Faris" );
	add_name( "arab", "Fouad" );
	add_name( "arab", "Habib" );
	add_name( "arab", "Hakem" );
	add_name( "arab", "Hassan" );
	add_name( "arab", "Ibrahim" );
	add_name( "arab", "Imad" );
	add_name( "arab", "Jabbar" );
	add_name( "arab", "Kareem" );
	add_name( "arab", "Khalid" );
	add_name( "arab", "Malik" );
	add_name( "arab", "Muhammad" );
	add_name( "arab", "Nasir" );
	add_name( "arab", "Omar" );
	add_name( "arab", "Rafiq" );
	add_name( "arab", "Rami" );
	add_name( "arab", "Said" );
	add_name( "arab", "Salim" );
	add_name( "arab", "Samir" );
	add_name( "arab", "Talib" );
	add_name( "arab", "Tariq" );
	add_name( "arab", "Youssef" );
	add_name( "arab", "Ziad" );
	
	
	add_name( "portuguese", "Carlitos" );
	add_name( "portuguese", "Antonio" );
	add_name( "portuguese", "Gervasio" );
	add_name( "portuguese", "Lois" );
	add_name( "portuguese", "Xesus" );
	
	add_name( "shadowcompany", "Lestat" );
	add_name( "shadowcompany", "Nosferatu" );
	add_name( "shadowcompany", "Lecter" );

	add_name( "multilingual", "Kugelschreiber" );
	add_name( "multilingual", "Flughafen" );
	
	add_name( "french", "Astor" );
	add_name( "french", "Beliveau" );
	add_name( "french", "Chaloux" );
	add_name( "french", "Leboeuf" );
	add_name( "french", "Leblanc" );
	add_name( "french", "Navarre" );
	add_name( "french", "Perilloux" );
	add_name( "french", "Philippe" );
	add_name( "french", "Taillon" );

	add_name( "african", "Sulaiman" );
	add_name( "african", "Camara" );
	add_name( "african", "Mustapha" );
	add_name( "african", "Abubakarr" );

	add_name( "czech", "Andrej" ); 
	add_name( "czech", "Anton" ); 
	add_name( "czech", "Antonín" ); 
	add_name( "czech", "Arnost" ); 
	add_name( "czech", "Augustín" ); 
	add_name( "czech", "Bartolomej" ); 
	add_name( "czech", "Beda" ); 
	add_name( "czech", "Bedrich" ); 
	add_name( "czech", "Benes" ); 
	add_name( "czech", "Blaze" ); 
	add_name( "czech", "Bohdan" ); 
	add_name( "czech", "Bohuslav" ); 
	add_name( "czech", "Bonifác" ); 
	add_name( "czech", "Bozidar" ); 
	add_name( "czech", "Branislav" ); 
	add_name( "czech", "Cenek" ); 
	add_name( "czech", "Ctibor" ); 
	add_name( "czech", "Dalek" ); 
	add_name( "czech", "Dalibor" ); 
	add_name( "czech", "Damek" ); 
	add_name( "czech", "Danek" ); 
	add_name( "czech", "Dávid" ); 
	add_name( "czech", "Dobromil" ); 
	add_name( "czech", "Dominik" ); 
	add_name( "czech", "Drahoslav" ); 
	add_name( "czech", "Dusa" ); 
	add_name( "czech", "Edvard" ); 
	add_name( "czech", "Eliás" ); 
	add_name( "czech", "Evzen" ); 
	add_name( "czech", "Frantisek" ); 
	add_name( "czech", "Gabriel" ); 
	add_name( "czech", "Georg" ); 
	add_name( "czech", "Holic" ); 
	add_name( "czech", "Honza" ); 
	add_name( "czech", "Ignác" ); 
	add_name( "czech", "Imrich" ); 
	add_name( "czech", "Ivan" ); 
	add_name( "czech", "Jakub" ); 
	add_name( "czech", "Jan" ); 
	add_name( "czech", "Jarmil" ); 
	add_name( "czech", "Jaroslav" ); 
	add_name( "czech", "Jindrich" ); 
	add_name( "czech", "Jirí" ); 
	add_name( "czech", "Johan" ); 
	add_name( "czech", "Josef" ); 
	add_name( "czech", "Július" ); 
	add_name( "czech", "Juraj" ); 
	add_name( "czech", "Kamil" ); 
	add_name( "czech", "Konstantin" ); 
	add_name( "czech", "Kopecký" ); 
	add_name( "czech", "Kornel" ); 
	add_name( "czech", "Kristof" ); 
	add_name( "czech", "Ladislav" ); 
	add_name( "czech", "Leos" ); 
	add_name( "czech", "Libor" ); 
	add_name( "czech", "Ludvík" ); 
	add_name( "czech", "Lukás" ); 
	add_name( "czech", "Marek" ); 
	add_name( "czech", "Matej" ); 
	add_name( "czech", "Matous" ); 
	add_name( "czech", "Matus" ); 
	add_name( "czech", "Michal" ); 
	add_name( "czech", "Mikulás" ); 
	add_name( "czech", "Milan" ); 
	add_name( "czech", "Milos" ); 
	add_name( "czech", "Mirek" ); 
	add_name( "czech", "Miroslav" ); 
	add_name( "czech", "Nikola" ); 
	add_name( "czech", "Oldrich" ); 
	add_name( "czech", "Ondrej" ); 
	add_name( "czech", "Otakar" ); 
	add_name( "czech", "Patrik" ); 
	add_name( "czech", "Pavel" ); 
	add_name( "czech", "Petr" ); 
	add_name( "czech", "Premysl" ); 
	add_name( "czech", "Radek" ); 
	add_name( "czech", "Radim" ); 
	add_name( "czech", "Radoslav" ); 
	add_name( "czech", "Rehor" );
	add_name( "czech_surnames", "Blumel" ); 
	add_name( "czech_surnames", "Maly" ); 
	add_name( "czech_surnames", "Pospisil" ); 
	add_name( "czech_surnames", "Soukup" ); 
	add_name( "czech_surnames", "Blazek" ); 
	add_name( "czech_surnames", "Dolezal" ); 
	add_name( "czech_surnames", "Fiser" ); 
	add_name( "czech_surnames", "Kadlec" ); 
	add_name( "czech_surnames", "Kolar" ); 
	add_name( "czech_surnames", "Kopecky" ); 
	add_name( "czech_surnames", "Kriz" ); 
	add_name( "czech_surnames", "Mares" ); 
	add_name( "czech_surnames", "Masek" ); 
	add_name( "czech_surnames", "Polak" ); 
	add_name( "czech_surnames", "Sedlacek" ); 
	add_name( "czech_surnames", "Stastny" ); 
	add_name( "czech_surnames", "Tuma" ); 
	add_name( "czech_surnames", "Vanek" ); 
	add_name( "czech_surnames", "Blaha" ); 
	add_name( "czech_surnames", "Dusek" ); 
	add_name( "czech_surnames", "Hruska" ); 
	add_name( "czech_surnames", "Janda" ); 
	add_name( "czech_surnames", "Kohout" ); 
	add_name( "czech_surnames", "Matousek" ); 
	add_name( "czech_surnames", "Moravec" ); 
	add_name( "czech_surnames", "Mueller" ); 
	add_name( "czech_surnames", "Riha" ); 
	add_name( "czech_surnames", "Strnad" ); 
	add_name( "czech_surnames", "Sykora" ); 
	add_name( "czech_surnames", "Simek" ); 
	add_name( "czech_surnames", "Smid" ); 
	add_name( "czech_surnames", "Stepanek" ); 
	add_name( "czech_surnames", "Tichy" ); 
	add_name( "czech_surnames", "Vacek" ); 
	add_name( "czech_surnames", "Vlcek" ); 
	
	copy_names( "pmc", "czech_surnames" );
	
	init_script_friendnames();

	for ( i = 0; i < nationalities.size; i++ )
	{
		remove_script_friendnames_from_list( nationalities[ i ] );
		randomize_name_list( nationalities[ i ] );
		level.nameIndex[ nationalities[ i ] ] = 0;
	}
}

copy_names( copyTo, copyFrom )
{
	ASSERT( IsDefined( level.names[ copyFrom ] ) && level.names[ copyFrom ].size );
	
	level.names[ copyTo ] = level.names[ copyFrom ];
}

add_name( nationality, thename )
{
	level.names[ nationality ][ level.names[ nationality ].size ] = thename;
}

remove_name( nationality, thename )
{
	level.names[ nationality ] = array_remove( level.names[ nationality ], thename );
}

init_script_friendnames()
{
	script_friendnames = [];
	spawners = GetSpawnerArray();
	ais = GetAiArray();
	
	foreach( spawner in spawners )
	{
		if( IsDefined( spawner.script_friendname ) && spawner.script_friendname != "none" )
		{
			name = normalize_script_friendname( spawner.script_friendname );
			script_friendnames[ script_friendnames.size ] = name;
		}
	}
	
	foreach( ai in ais )
	{
		if( IsDefined( ai.script_friendname ) && ai.script_friendname != "none" )
		{
			name = normalize_script_friendname( ai.script_friendname );
			script_friendnames[ script_friendnames.size ] = name;
		}
	}
	
	level.script_friendnames = script_friendnames;
}

normalize_script_friendname( name )
{
	tokens = StrTok( name, " " );
	if( tokens.size > 1 )
	{
		name = tokens[ 1 ];
	}
	
	return name;
}

remove_script_friendnames_from_list( nationality )
{
	foreach( scriptedName in level.script_friendnames )
	{
		foreach( staticName in level.names[ nationality ] )
		{
			if( scriptedName == staticName )
			{
				remove_name( nationality, staticName );
			}
		}
	}
}

randomize_name_list( nationality )
{
	size = level.names[ nationality ].size;
	for ( i = 0; i < size; i++ )
	{
		switchwith = randomint( size );
		temp = level.names[ nationality ][ i ];
		level.names[ nationality ][ i ] = level.names[ nationality ][ switchwith ];
		level.names[ nationality ][ switchwith ] = temp;
	}
}

get_name( override )
{
	if ( ( isdefined( self.team ) ) && ( self.team == "neutral" ) )
	{
		return;
	}
		
	if ( !isdefined( override ) && level.script == "credits" )
	{
		self.airank = "private";
		return;
	}

	if ( isdefined( self.script_friendname ) )
	{
		if ( self.script_friendname == "none" )
			return;
		self.name = self.script_friendname;
		getRankFromName( self.name );
		self notify( "set name and rank" );
		return;
	}

	assert( isdefined( level.names ) );

	get_name_for_nationality( self.voice );

	self notify( "set name and rank" );
}

get_name_for_nationality( nationality )
{
	assertex( isdefined( level.nameIndex[ nationality ] ), nationality );

	level.nameIndex[ nationality ] = ( level.nameIndex[ nationality ] + 1 ) % level.names[ nationality ].size;
	name = level.names[ nationality ][ level.nameIndex[ nationality ] ];
	
	rank = randomint( 10 );
	
	if ( nationalityUsesSurnames( nationality ) )
	{
		// I guess lastname should really be firstname now... ~Carlos
		nationality_surname = nationality + "_surnames";
		level.nameIndex[ nationality_surname ] = ( level.nameIndex[ nationality_surname ] + 1 ) % level.names[ nationality_surname ].size;
		name = name + " " + level.names[ nationality_surname ][ level.nameIndex[ nationality_surname ] ];
	}
	
	if( nationalityUsesCallsigns( nationality ) )
	{
		fullname = name;  // TF141 soldiers just get a callsign
		self.airank = "private";
	}
	else if( nationality == "secretservice" )
	{
		fullname = "Agent " + name;  // Secret Service guys are all "Agents"
		self.airank = "private";
	}
	else if ( rank > 5 )
	{
		fullname = "Pvt. " + name;
		self.airank = "private";
	}
	else if ( rank > 2 )
	{
		fullname = "Cpl. " + name;
		self.airank = "private";
	}
	else
	{
		fullname = "Sgt. " + name;
		self.airank = "sergeant";
	}

	if ( ( isAi( self ) ) && ( self isBadGuy() ) )
	{
		self.ainame = fullname;
	}
	else
	{
		self.name = fullname;
	}
}

getRankFromName( name )
{
	if ( !isdefined( name ) )
		self.airank = ( "private" );

	tokens = strtok( name, " " );
	assert( tokens.size );
	shortRank = tokens[ 0 ];

	switch( shortRank )
	{
	case "Pvt.":
		self.airank = "private";
		break;
	case "Pfc.":
		self.airank = "private";
		break;
	case "Agent":
		self.airank = "private";
		break;
	case "Cpl.":
		self.airank = "corporal";
		break;
	case "Sgt.":
		self.airank = "sergeant";
		break;
	case "Lt.":
		self.airank = "lieutenant";
		break;
	case "Cpt.":
		self.airank = "captain";
		break;
	default:
		// SRS 02/01/09: this is more annoying than useful now that we have lots of friendlies
		//  whose names are callsigns. we may want to ditch rank references altogether in the scripts.
		//println( "sentient has invalid rank " + shortRank + "!" );
		self.airank = "private";
		break;
	}
}

nationalityUsesCallsigns( nationality )
{
	switch( nationality )
	{
		case "seal":
		case "delta":
		case "taskforce":
		case "czech": // they don't technically use callsigns, but they are on a first-name basis
			return true;
	}
	return false;
}

nationalityUsesSurnames( nationality )
{
	return ( isdefined( level.names[ nationality + "_surnames" ] ) );
}