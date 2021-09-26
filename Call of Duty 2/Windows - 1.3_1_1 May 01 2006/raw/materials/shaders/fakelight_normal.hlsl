#include "lib/globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
	float3 normal : NORMAL;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


#include "lib/transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;
	float lighting;
	float3 absNormal;

	pixel.position = Transform_ObjectToClip( vertex.position );

	absNormal = abs( vertex.normal );
	lighting = dot( absNormal, float3( 0.6, 0.8, 1.0 ) ) / dot( absNormal, float3( 1, 1, 1 ) );

	pixel.color.rgb = vertex.color.rgb * lighting;
	pixel.color.a = vertex.color.a;
	pixel.texCoords = vertex.texCoords;

	return pixel;
}
