#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	

function autoexec main()
{
	clientfield::register(
		"actor",
		"destructible_character_state",
		1,
		21,
		"int",
		&DestructClientUtils::_DestructHandler,
		!true,
		!true);

	destructibles = struct::get_script_bundles( "destructiblecharacterdef" );
	
	// Process each destructible bundle to allow quick access to information in the future.
	foreach ( destructible in destructibles )
	{
		// This is extremely hardcoded because scriptbundles return structs which can't be
		// indexed by a string.
		destructible.pieces = [];

		for ( index = 0; index < 20; index++ )
		{
			destructible.pieces[ destructible.pieces.size ] = SpawnStruct();
		}

		pieceIndex = 0;
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;

		piece.gibmodel = destructible.piece1_gibmodel;    destructible.piece1_gibmodel = undefined;;
		piece.gibtag = destructible.piece1_gibtag;    destructible.piece1_gibtag = undefined;;
		piece.gibfx = destructible.piece1_gibfx;    destructible.piece1_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece1_gibfxunderwater;    destructible.piece1_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece1_gibeffecttag;    destructible.piece1_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece1_gibdynentfx;    destructible.piece1_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece1_gibdynentfxunderwater;    destructible.piece1_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece1_gibsound;    destructible.piece1_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece1_gibsoundunderwater;    destructible.piece1_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece1_hitlocation;    destructible.piece1_hitlocation = undefined;;
		piece.hidetag = destructible.piece1_hidetag;    destructible.piece1_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece2_gibmodel;    destructible.piece2_gibmodel = undefined;;
		piece.gibtag = destructible.piece2_gibtag;    destructible.piece2_gibtag = undefined;;
		piece.gibfx = destructible.piece2_gibfx;    destructible.piece2_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece2_gibfxunderwater;    destructible.piece2_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece2_gibeffecttag;    destructible.piece2_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece2_gibdynentfx;    destructible.piece2_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece2_gibdynentfxunderwater;    destructible.piece2_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece2_gibsound;    destructible.piece2_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece2_gibsoundunderwater;    destructible.piece2_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece2_hitlocation;    destructible.piece2_hitlocation = undefined;;
		piece.hidetag = destructible.piece2_hidetag;    destructible.piece2_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece3_gibmodel;    destructible.piece3_gibmodel = undefined;;
		piece.gibtag = destructible.piece3_gibtag;    destructible.piece3_gibtag = undefined;;
		piece.gibfx = destructible.piece3_gibfx;    destructible.piece3_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece3_gibfxunderwater;    destructible.piece3_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece3_gibeffecttag;    destructible.piece3_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece3_gibdynentfx;    destructible.piece3_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece3_gibdynentfxunderwater;    destructible.piece3_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece3_gibsound;    destructible.piece3_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece3_gibsoundunderwater;    destructible.piece3_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece3_hitlocation;    destructible.piece3_hitlocation = undefined;;
		piece.hidetag = destructible.piece3_hidetag;    destructible.piece3_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece4_gibmodel;    destructible.piece4_gibmodel = undefined;;
		piece.gibtag = destructible.piece4_gibtag;    destructible.piece4_gibtag = undefined;;
		piece.gibfx = destructible.piece4_gibfx;    destructible.piece4_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece4_gibfxunderwater;    destructible.piece4_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece4_gibeffecttag;    destructible.piece4_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece4_gibdynentfx;    destructible.piece4_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece4_gibdynentfxunderwater;    destructible.piece4_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece4_gibsound;    destructible.piece4_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece4_gibsoundunderwater;    destructible.piece4_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece4_hitlocation;    destructible.piece4_hitlocation = undefined;;
		piece.hidetag = destructible.piece4_hidetag;    destructible.piece4_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece5_gibmodel;    destructible.piece5_gibmodel = undefined;;
		piece.gibtag = destructible.piece5_gibtag;    destructible.piece5_gibtag = undefined;;
		piece.gibfx = destructible.piece5_gibfx;    destructible.piece5_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece5_gibfxunderwater;    destructible.piece5_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece5_gibeffecttag;    destructible.piece5_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece5_gibdynentfx;    destructible.piece5_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece5_gibdynentfxunderwater;    destructible.piece5_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece5_gibsound;    destructible.piece5_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece5_gibsoundunderwater;    destructible.piece5_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece5_hitlocation;    destructible.piece5_hitlocation = undefined;;
		piece.hidetag = destructible.piece5_hidetag;    destructible.piece5_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece6_gibmodel;    destructible.piece6_gibmodel = undefined;;
		piece.gibtag = destructible.piece6_gibtag;    destructible.piece6_gibtag = undefined;;
		piece.gibfx = destructible.piece6_gibfx;    destructible.piece6_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece6_gibfxunderwater;    destructible.piece6_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece6_gibeffecttag;    destructible.piece6_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece6_gibdynentfx;    destructible.piece6_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece6_gibdynentfxunderwater;    destructible.piece6_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece6_gibsound;    destructible.piece6_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece6_gibsoundunderwater;    destructible.piece6_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece6_hitlocation;    destructible.piece6_hitlocation = undefined;;
		piece.hidetag = destructible.piece6_hidetag;    destructible.piece6_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece7_gibmodel;    destructible.piece7_gibmodel = undefined;;
		piece.gibtag = destructible.piece7_gibtag;    destructible.piece7_gibtag = undefined;;
		piece.gibfx = destructible.piece7_gibfx;    destructible.piece7_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece7_gibfxunderwater;    destructible.piece7_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece7_gibeffecttag;    destructible.piece7_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece7_gibdynentfx;    destructible.piece7_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece7_gibdynentfxunderwater;    destructible.piece7_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece7_gibsound;    destructible.piece7_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece7_gibsoundunderwater;    destructible.piece7_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece7_hitlocation;    destructible.piece7_hitlocation = undefined;;
		piece.hidetag = destructible.piece7_hidetag;    destructible.piece7_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece8_gibmodel;    destructible.piece8_gibmodel = undefined;;
		piece.gibtag = destructible.piece8_gibtag;    destructible.piece8_gibtag = undefined;;
		piece.gibfx = destructible.piece8_gibfx;    destructible.piece8_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece8_gibfxunderwater;    destructible.piece8_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece8_gibeffecttag;    destructible.piece8_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece8_gibdynentfx;    destructible.piece8_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece8_gibdynentfxunderwater;    destructible.piece8_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece8_gibsound;    destructible.piece8_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece8_gibsoundunderwater;    destructible.piece8_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece8_hitlocation;    destructible.piece8_hitlocation = undefined;;
		piece.hidetag = destructible.piece8_hidetag;    destructible.piece8_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece9_gibmodel;    destructible.piece9_gibmodel = undefined;;
		piece.gibtag = destructible.piece9_gibtag;    destructible.piece9_gibtag = undefined;;
		piece.gibfx = destructible.piece9_gibfx;    destructible.piece9_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece9_gibfxunderwater;    destructible.piece9_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece9_gibeffecttag;    destructible.piece9_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece9_gibdynentfx;    destructible.piece9_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece9_gibdynentfxunderwater;    destructible.piece9_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece9_gibsound;    destructible.piece9_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece9_gibsoundunderwater;    destructible.piece9_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece9_hitlocation;    destructible.piece9_hitlocation = undefined;;
		piece.hidetag = destructible.piece9_hidetag;    destructible.piece9_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece10_gibmodel;    destructible.piece10_gibmodel = undefined;;
		piece.gibtag = destructible.piece10_gibtag;    destructible.piece10_gibtag = undefined;;
		piece.gibfx = destructible.piece10_gibfx;    destructible.piece10_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece10_gibfxunderwater;    destructible.piece10_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece10_gibeffecttag;    destructible.piece10_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece10_gibdynentfx;    destructible.piece10_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece10_gibdynentfxunderwater;    destructible.piece10_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece10_gibsound;    destructible.piece10_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece10_gibsoundunderwater;    destructible.piece10_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece10_hitlocation;    destructible.piece10_hitlocation = undefined;;
		piece.hidetag = destructible.piece10_hidetag;    destructible.piece10_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece11_gibmodel;    destructible.piece11_gibmodel = undefined;;
		piece.gibtag = destructible.piece11_gibtag;    destructible.piece11_gibtag = undefined;;
		piece.gibfx = destructible.piece11_gibfx;    destructible.piece11_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece11_gibfxunderwater;    destructible.piece11_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece11_gibeffecttag;    destructible.piece11_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece11_gibdynentfx;    destructible.piece11_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece11_gibdynentfxunderwater;    destructible.piece11_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece11_gibsound;    destructible.piece11_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece11_gibsoundunderwater;    destructible.piece11_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece11_hitlocation;    destructible.piece11_hitlocation = undefined;;
		piece.hidetag = destructible.piece11_hidetag;    destructible.piece11_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece12_gibmodel;    destructible.piece12_gibmodel = undefined;;
		piece.gibtag = destructible.piece12_gibtag;    destructible.piece12_gibtag = undefined;;
		piece.gibfx = destructible.piece12_gibfx;    destructible.piece12_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece12_gibfxunderwater;    destructible.piece12_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece12_gibeffecttag;    destructible.piece12_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece12_gibdynentfx;    destructible.piece12_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece12_gibdynentfxunderwater;    destructible.piece12_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece12_gibsound;    destructible.piece12_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece12_gibsoundunderwater;    destructible.piece12_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece12_hitlocation;    destructible.piece12_hitlocation = undefined;;
		piece.hidetag = destructible.piece12_hidetag;    destructible.piece12_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece13_gibmodel;    destructible.piece13_gibmodel = undefined;;
		piece.gibtag = destructible.piece13_gibtag;    destructible.piece13_gibtag = undefined;;
		piece.gibfx = destructible.piece13_gibfx;    destructible.piece13_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece13_gibfxunderwater;    destructible.piece13_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece13_gibeffecttag;    destructible.piece13_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece13_gibdynentfx;    destructible.piece13_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece13_gibdynentfxunderwater;    destructible.piece13_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece13_gibsound;    destructible.piece13_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece13_gibsoundunderwater;    destructible.piece13_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece13_hitlocation;    destructible.piece13_hitlocation = undefined;;
		piece.hidetag = destructible.piece13_hidetag;    destructible.piece13_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece14_gibmodel;    destructible.piece14_gibmodel = undefined;;
		piece.gibtag = destructible.piece14_gibtag;    destructible.piece14_gibtag = undefined;;
		piece.gibfx = destructible.piece14_gibfx;    destructible.piece14_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece14_gibfxunderwater;    destructible.piece14_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece14_gibeffecttag;    destructible.piece14_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece14_gibdynentfx;    destructible.piece14_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece14_gibdynentfxunderwater;    destructible.piece14_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece14_gibsound;    destructible.piece14_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece14_gibsoundunderwater;    destructible.piece14_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece14_hitlocation;    destructible.piece14_hitlocation = undefined;;
		piece.hidetag = destructible.piece14_hidetag;    destructible.piece14_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece15_gibmodel;    destructible.piece15_gibmodel = undefined;;
		piece.gibtag = destructible.piece15_gibtag;    destructible.piece15_gibtag = undefined;;
		piece.gibfx = destructible.piece15_gibfx;    destructible.piece15_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece15_gibfxunderwater;    destructible.piece15_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece15_gibeffecttag;    destructible.piece15_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece15_gibdynentfx;    destructible.piece15_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece15_gibdynentfxunderwater;    destructible.piece15_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece15_gibsound;    destructible.piece15_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece15_gibsoundunderwater;    destructible.piece15_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece15_hitlocation;    destructible.piece15_hitlocation = undefined;;
		piece.hidetag = destructible.piece15_hidetag;    destructible.piece15_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece16_gibmodel;    destructible.piece16_gibmodel = undefined;;
		piece.gibtag = destructible.piece16_gibtag;    destructible.piece16_gibtag = undefined;;
		piece.gibfx = destructible.piece16_gibfx;    destructible.piece16_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece16_gibfxunderwater;    destructible.piece16_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece16_gibeffecttag;    destructible.piece16_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece16_gibdynentfx;    destructible.piece16_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece16_gibdynentfxunderwater;    destructible.piece16_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece16_gibsound;    destructible.piece16_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece16_gibsoundunderwater;    destructible.piece16_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece16_hitlocation;    destructible.piece16_hitlocation = undefined;;
		piece.hidetag = destructible.piece16_hidetag;    destructible.piece16_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece17_gibmodel;    destructible.piece17_gibmodel = undefined;;
		piece.gibtag = destructible.piece17_gibtag;    destructible.piece17_gibtag = undefined;;
		piece.gibfx = destructible.piece17_gibfx;    destructible.piece17_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece17_gibfxunderwater;    destructible.piece17_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece17_gibeffecttag;    destructible.piece17_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece17_gibdynentfx;    destructible.piece17_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece17_gibdynentfxunderwater;    destructible.piece17_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece17_gibsound;    destructible.piece17_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece17_gibsoundunderwater;    destructible.piece17_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece17_hitlocation;    destructible.piece17_hitlocation = undefined;;
		piece.hidetag = destructible.piece17_hidetag;    destructible.piece17_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece18_gibmodel;    destructible.piece18_gibmodel = undefined;;
		piece.gibtag = destructible.piece18_gibtag;    destructible.piece18_gibtag = undefined;;
		piece.gibfx = destructible.piece18_gibfx;    destructible.piece18_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece18_gibfxunderwater;    destructible.piece18_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece18_gibeffecttag;    destructible.piece18_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece18_gibdynentfx;    destructible.piece18_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece18_gibdynentfxunderwater;    destructible.piece18_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece18_gibsound;    destructible.piece18_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece18_gibsoundunderwater;    destructible.piece18_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece18_hitlocation;    destructible.piece18_hitlocation = undefined;;
		piece.hidetag = destructible.piece18_hidetag;    destructible.piece18_hidetag = undefined;;
		
		piece = destructible.pieces[ pieceIndex ];
		pieceIndex++;
		
		piece.gibmodel = destructible.piece19_gibmodel;    destructible.piece19_gibmodel = undefined;;
		piece.gibtag = destructible.piece19_gibtag;    destructible.piece19_gibtag = undefined;;
		piece.gibfx = destructible.piece19_gibfx;    destructible.piece19_gibfx = undefined;;
		piece.gibfxunderwater = destructible.piece19_gibfxunderwater;    destructible.piece19_gibfxunderwater = undefined;;
		piece.gibfxtag = destructible.piece19_gibeffecttag;    destructible.piece19_gibeffecttag = undefined;;
		piece.gibdynentfx = destructible.piece19_gibdynentfx;    destructible.piece19_gibdynentfx = undefined;;
		piece.gibdynentfxunderwater = destructible.piece19_gibdynentfxunderwater;    destructible.piece19_gibdynentfxunderwater = undefined;;
		piece.gibsound = destructible.piece19_gibsound;    destructible.piece19_gibsound = undefined;;
		piece.gibsoundunderwater = destructible.piece19_gibsoundunderwater;    destructible.piece19_gibsoundunderwater = undefined;;
		piece.hitlocation = destructible.piece19_hitlocation;    destructible.piece19_hitlocation = undefined;;
		piece.hidetag = destructible.piece19_hidetag;    destructible.piece19_hidetag = undefined;;
	}
}

#namespace DestructClientUtils;

function private _DestructHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	destructFlags = (oldValue ^ newValue);
	shouldSpawnGibs = (newValue & 1);
	
	// Don't use the old clientfield value for new entities.
	if ( bNewEnt )
	{
		destructFlags = (0 ^ newValue);
	}
	
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	// Only look at destructible pieces, skip toggle bit.
	currentDestructFlag = (1 << 1);
	pieceNumber = 1;
	
	underWater = entity UnderWater();
	
	// Handles any number of simultaneous gibbings.
	while ( destructFlags >= currentDestructFlag )
	{
		if ( destructFlags & currentDestructFlag )
		{
			_DestructPiece( localClientNum, entity, pieceNumber, shouldSpawnGibs, underWater );
		}
		
		currentDestructFlag = currentDestructFlag << 1;
		pieceNumber++;
	}
	
	entity._destruct_state = newValue;
}

function private _DestructPiece( localClientNum, entity, pieceNumber, shouldSpawnGibs, underWater )
{
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	piece = destructBundle.pieces[ pieceNumber - 1 ];
	
	if ( IsDefined( piece ) )
	{
		if ( shouldSpawnGibs )
		{
			if ( !( isdefined( underWater ) && underWater ) )
			{
				GibClientUtils::_PlayGibFX( localClientNum, entity, piece.gibfx, piece.gibfxtag );
				GibClientUtils::_PlayGibSound( localClientNum, entity, piece.gibsound );
				
				entity thread GibClientUtils::_GibPiece(
					localClientNum, entity, piece.gibmodel, piece.gibtag, piece.gibdynentfx );
			}
			else
			{
				GibClientUtils::_PlayGibFX( localClientNum, entity, piece.gibfxunderwater, piece.gibfxtag );
				GibClientUtils::_PlayGibSound( localClientNum, entity, piece.gibsoundunderwater );
				
				entity thread GibClientUtils::_GibPiece(
					localClientNum, entity, piece.gibmodel, piece.gibtag, piece.gibdynentfxunderwater );
			}
		}
		
		_HandleDestructCallbacks( localClientNum, entity, pieceNumber );
	}
}

function private _GetDestructState( localClientNum, entity )
{
	if ( IsDefined( entity._destruct_state ) )
	{
		return entity._destruct_state;
	}
	
	return 0;
}

function private _HandleDestructCallbacks( localClientNum, entity, pieceNumber )
{
	if ( IsDefined( entity._destructCallbacks ) &&
		IsDefined( entity._destructCallbacks[ pieceNumber ] ) )
	{
		foreach ( callback in entity._destructCallbacks[ pieceNumber ] )
		{
			[[callback]]( localClientNum, entity, pieceNumber );
		}
	}
}

function AddDestructPieceCallback( localClientNum, entity, pieceNumber, callbackFunction )
{
	assert( IsFunctionPtr( callbackFunction ) );

	if ( !IsDefined( entity._destructCallbacks ) )
	{
		entity._destructCallbacks = [];
	}

	if ( !IsDefined( entity._destructCallbacks[ pieceNumber ] ) )
	{
		entity._destructCallbacks[ pieceNumber ] = [];
	}
	
	destructCallbacks = entity._destructCallbacks[ pieceNumber ];
	destructCallbacks[ destructCallbacks.size ] = callbackFunction;
	entity._destructCallbacks[ pieceNumber ] = destructCallbacks;
}

function IsPieceDestructed( localClientNum, entity, pieceNumber )
{
	return (_GetDestructState( localClientNum, entity ) & (1 << pieceNumber));
}

// end #namespace DestructClientUtils;
