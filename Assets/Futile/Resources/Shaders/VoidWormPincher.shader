// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

	
// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

//from http://forum.unity3d.com/threads/68402-Making-a-2D-game-for-iPhone-iPad-and-need-better-performance

Shader "Futile/VoidWormPincher" //Unlit Transparent Vertex Colored Additive 
{
Properties 
	{
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	}
	
	Category 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off
		//Alphatest Greater 0
		Blend SrcAlpha OneMinusSrcAlpha 
		Fog { Color(0,0,0,0) }
		Lighting Off
		Cull Off //we can turn backface culling off because we know nothing will be facing backwards

		BindChannels 
		{
			Bind "Vertex", vertex
			Bind "texcoord", texcoord 
			Bind "Color", color 
		}

		SubShader   
		{
				Pass 
			{
				//SetTexture [_MainTex] 
				//{
				//	Combine texture * primary
				//}
				
				
				
CGPROGRAM
#pragma target 3.0
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"

//#pragma profileoption NumTemps=64
//#pragma profileoption NumInstructionSlots=2048

//float4 _Color;
sampler2D _MainTex;
//sampler2D _LevelTex;
sampler2D _NoiseTex;
sampler2D _PalTex;

//uniform float _fogAmount;
//uniform float _waterPosition;

//sampler2D _GrabTexture : register(s0);

//uniform float _RAIN;

//uniform float4 _spriteRect;
//uniform float2 _screenSize;

struct v2f {
    float4  pos : SV_POSITION;
   float2  uv : TEXCOORD0;
    float2 scrPos : TEXCOORD1;
    float4 clr : COLOR;
};

float4 _MainTex_ST;

v2f vert (appdata_full v)
{
    v2f o;
    o.pos = UnityObjectToClipPos (v.vertex);
    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
    o.scrPos = ComputeScreenPos(o.pos);
    o.clr = v.color;
    return o;
}



half4 frag (v2f i) : COLOR
{

half h = pow(i.uv.y, 1.0 + i.uv.y) * 20;

h = frac(h);
//if(abs(h-0.5) < 0.25) return half4(1, 0.5, 0.5, 1);
//else return half4(0.5, 0.1, 0.1, 1);

half d = 1.0 - abs(0.5-i.uv.x)*2;
//d *= 1.0-jagg;
d = pow(d, 0.2);


d -= 0.2+pow(abs(h-0.5)*2, 3)*0.6;

d = lerp(d, 1, pow(i.uv.y, 3) * 0.1);

if(d < 0) return half4(0,0,0,0);

d *= lerp(pow(tex2D(_MainTex, half2(i.uv.x*0.2 + i.uv.y, i.uv.y*7.0)).x, lerp(0.75, 0.25, d)), 1, d*0.5);
d = floor(d*6.0)/6.0;

return half4(lerp(i.clr.xyz*lerp(d, 1.5, 0.5), half3(1,1,1), tex2D(_MainTex, half2(i.uv.x*0.5 + i.uv.y, i.uv.y*7.0)).z > 0.1 ? 0.65*d : 0), 1);



}
ENDCG
				
				
				
			}
		} 
	}
}











