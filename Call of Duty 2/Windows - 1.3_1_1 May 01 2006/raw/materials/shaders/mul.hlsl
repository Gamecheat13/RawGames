#include "lib/globals.hlsl"

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
	float2 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"
#include "lib/shade.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;
	pixel.color = vertex.color;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	half4		diffuseColor;

	diffuseColor.rgb = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );
	fragment.color.rgb = (1 - pixel.color.a) + diffuseColor.rgb * pixel.color.a;
	fragment.color.a = 1;

	return fragment;
}
