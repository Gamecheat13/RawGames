#include "globals.hlsl"

#define FOGVAR fog


struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
	float3 tangent : TEXCOORD2;
	float3 binormal : TEXCOORD3;
	float3 normal : NORMAL;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR0;
	float2 texCoords : TEXCOORD0;
	float3 eyeVector : TEXCOORD1;
#if USE_FOG
	float fog : FOG_SEMANTIC;
#endif
};

struct PixelOutput
{
	float4 color : COLOR;
};


float4 waterColor;

static const float lacunarity = 3.7;
static const float scaleRate = 0.6;


#include "transform.hlsl"
#include "fog.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;
	float3 worldVertPos;

	worldVertPos = Transform_ObjectToWorld( vertex.position );

	pixel = (PixelInput) 0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	pixel.texCoords = vertex.texCoords;
	pixel.eyeVector = worldVertPos - eyePosition;

	Fog_VertexCalc( vertex, pixel );

	return pixel;
}


float turbulance( const float2 texCoords )
{
	int loopIndex;
	float t;
	float scale;
	int iteration;
	float2 localCoords;

	t = 0;
	scale = 1;
	localCoords = texCoords;
	for ( iteration = 0; iteration < 3; iteration++ )
	{
		t += tex2D( normalMapSampler, localCoords ).r * scale;
		localCoords *= lacunarity;
		scale *= scaleRate;
	}
	return t;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput	fragment;
	half3 diffuseColor;
	half4 envMapColor;
	half4 litColor;
	half3 localNormal;
	half3 eyeDir;
	half3 cubeMapReflectVector;

	half h00;
	half h10;
	half h01;
	float specularDot;

	float h;
	float error;
	float2 texCoords;
	int loop;

	eyeDir = normalize( pixel.eyeVector );

	texCoords = pixel.texCoords;
	h = 0.5;
	for ( loop = 0; loop < 1; loop++ )
	{
		error = h - tex2D( normalMapSampler, texCoords * 0.5 ).x;
		h -= error;
		texCoords = texCoords + error * eyeDir.xy * (1.5 / 64);
	}

	h00 = turbulance( texCoords );
	h10 = turbulance( texCoords + float2( 0.5 / 128, 0 ) );
	h01 = turbulance( texCoords + float2( 0, 0.5 / 128 ) );
	localNormal = normalize( float3( h10 - h00, h01 - h00, 1 ) );

	cubeMapReflectVector = reflect( eyeDir, localNormal );
	specularDot = max( 0, dot( cubeMapReflectVector, lightPosition0 ) );
	cubeMapReflectVector.z = abs( cubeMapReflectVector.z );

	envMapColor = texCUBE( cubeMapSampler, cubeMapReflectVector );
	diffuseColor.rgb = waterColor.rgb * localNormal.z;
	litColor.rgb = lerp( diffuseColor.rgb, envMapColor.rgb, envMapColor.a );
	litColor.rgb += pow( specularDot, 64 ) * lightColor0;

	fragment.color.rgb = litColor.rgb;
	fragment.color.a = pixel.color.a;

	Fog_PixelCalc( pixel, fragment );

	return fragment;
}
