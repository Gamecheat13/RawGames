#include "lib/globals.hlsl"

struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	float4 diffuseColor = tex2D( colorMapSampler, pixel.texCoords );

	fragment.color.r = diffuseColor.r * materialColor.r + diffuseColor.a * materialColor.a;
	fragment.color.g = diffuseColor.g * materialColor.g + diffuseColor.a * materialColor.a;
	fragment.color.b = diffuseColor.b * materialColor.b + diffuseColor.a * materialColor.a;
	fragment.color.a = diffuseColor.a;

	return fragment;
}
