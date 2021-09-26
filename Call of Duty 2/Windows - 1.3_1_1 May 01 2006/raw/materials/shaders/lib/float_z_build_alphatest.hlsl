#include "globals.hlsl"

#define USE_DETAIL 0

struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float3 texCoordsAndDist : TEXCOORD0;
};


struct PixelOutput
{
	float4 distance : COLOR;
};


#include "transform.hlsl"
#include "shade.hlsl"
#include "texscroll.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	pixel.texCoordsAndDist.xy = TexScroll( vertex.texCoords );
	pixel.texCoordsAndDist.z = pixel.position.z;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	half alpha;

	fragment.distance.rgba = pixel.texCoordsAndDist.z;

	alpha = ColoredTexturedDiffuse( pixel.color, pixel.texCoordsAndDist.xy ).a;
	clip( alpha - (128.0f / 255.0f) );

	return fragment;
}
