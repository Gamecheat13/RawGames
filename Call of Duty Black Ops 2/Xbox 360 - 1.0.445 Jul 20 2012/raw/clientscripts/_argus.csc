

#define ARGUS_UI_WIDTH				200
#define ARGUS_UI_SMALL_HEIGHT		33

#define ARGUS_SMALL_PAD				2.5
#define ARGUS_SMALL_IMAGE_X			ARGUS_SMALL_PAD
#define ARGUS_SMALL_IMAGE_Y			ARGUS_SMALL_PAD
#define ARGUS_SMALL_IMAGE_W			20
#define ARGUS_SMALL_IMAGE_H			20
#define ARGUS_SMALL_TEXT_X			(ARGUS_SMALL_IMAGE_X+ARGUS_SMALL_IMAGE_W+ARGUS_SMALL_PAD)
#define ARGUS_SMALL_TEXT_Y			ARGUS_SMALL_PAD
#define ARGUS_SMALL_TEXT_W			(ARGUS_UI_WIDTH-(ARGUS_SMALL_TEXT_X+ARGUS_SMALL_IMAGE_W+ARGUS_SMALL_PAD))
#define ARGUS_SMALL_TEXT_H			ARGUS_SMALL_IMAGE_W

#define ARGUS_UI_LARGE_HEIGHT		50

#define ARGUS_LARGE_PAD				2.5
#define ARGUS_LARGE_IMAGE_X			ARGUS_LARGE_PAD
#define ARGUS_LARGE_IMAGE_Y			ARGUS_LARGE_PAD
#define ARGUS_LARGE_IMAGE_W			45
#define ARGUS_LARGE_IMAGE_H			45
#define ARGUS_LARGE_TEXT_X			(ARGUS_LARGE_IMAGE_X+ARGUS_LARGE_IMAGE_W+ARGUS_LARGE_PAD)
#define ARGUS_LARGE_TEXT1_Y			ARGUS_LARGE_PAD
#define ARGUS_LARGE_TEXT2_Y			(2*ARGUS_LARGE_PAD+10)
#define ARGUS_LARGE_TEXT_W			(ARGUS_UI_WIDTH-(ARGUS_LARGE_TEXT_X+ARGUS_LARGE_PAD))
#define ARGUS_LARGE_TEXT1_H			10
#define ARGUS_LARGE_TEXT2_H			35

//the text only UI is just text with a simple wrapped text presentation
argusTextOnlyUI(localClientNum,text)
{
	root=NewMaterialElem(localClientNum,undefined,0,0,ARGUS_UI_WIDTH,ARGUS_UI_SMALL_HEIGHT,"white");
	SetColorElem(root,1,1,1,0.1,0);
	elem=NewTextElem(localClientNum,root,ARGUS_SMALL_PAD,ARGUS_SMALL_PAD,ARGUS_UI_WIDTH-2*ARGUS_SMALL_PAD,ARGUS_UI_SMALL_HEIGHT-2*ARGUS_SMALL_PAD,text,"small",0.5);
	elem.presentation="teletype";
	elem.font_style="shadowed";
	elem.rate=3;
	return root;
}

argusImageAndTextUI(localClientNum,image,text)
{
	root=NewMaterialElem(localClientNum,undefined,0,0,ARGUS_UI_WIDTH,ARGUS_UI_SMALL_HEIGHT,"white");
	SetColorElem(root,1,1,1,0.1,0);
	elem1=NewMaterialElem(localClientNum,root,ARGUS_SMALL_IMAGE_X,ARGUS_SMALL_IMAGE_Y,ARGUS_SMALL_IMAGE_W,ARGUS_SMALL_IMAGE_H,image);
	elem2=NewTextElem(localClientNum,root,ARGUS_SMALL_TEXT_X,ARGUS_SMALL_TEXT_Y,ARGUS_SMALL_TEXT_W,ARGUS_SMALL_TEXT_H,text,"small",0.5);
	elem2.presentation="teletype";
	elem2.font_style="shadowed";
	elem2.rate=3;

	return root;
}

argusImageAndText2UI(localClientNum,image,text1,text2)
{
	root=NewMaterialElem(localClientNum,undefined,0,0,ARGUS_UI_WIDTH,ARGUS_UI_LARGE_HEIGHT,"white");
	SetColorElem(root,1,1,1,0.1,0);
	elem1=NewMaterialElem(localClientNum,root,ARGUS_LARGE_IMAGE_X,ARGUS_LARGE_IMAGE_Y,ARGUS_LARGE_IMAGE_W,ARGUS_LARGE_IMAGE_H,image);
	elem2=NewTextElem(localClientNum,root,ARGUS_LARGE_TEXT_X,ARGUS_LARGE_TEXT1_Y,ARGUS_LARGE_TEXT_W,ARGUS_LARGE_TEXT1_H,text1,"small",1);
	elem2.x_alignment="center";
	elem2.font_style="shadowed";
	elem3=NewTextElem(localClientNum,root,ARGUS_LARGE_TEXT_X,ARGUS_LARGE_TEXT2_Y,ARGUS_LARGE_TEXT_W,ARGUS_LARGE_TEXT2_H,text2,"small",0.6);
	elem3.presentation="teletype";
	elem3.font_style="shadowed";
	elem3.rate=3;

	return root;
}