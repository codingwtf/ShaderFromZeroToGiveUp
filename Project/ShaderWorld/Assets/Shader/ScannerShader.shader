Shader "Custom/ScannerShader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ScanWidth("Scan Width", float) = 10
        _ScanColor("Scan Color", Color) = (1,1,1,0)
        _ScanDistance("Scan Distance", float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        pass{
           CGPROGRAM
               #pragma vertex vert
               #pragma fragment frag
               
               #include "UnityCG.cginc"
               
               struct a2v{
                   float4 vertex : POSITION;
                   float2 uv : TEXCOORD0;
               };
               
               struct v2f{
                   float4 vertex : SV_POSITION;
                   float2 uv : TEXCOORD0;
                   float2 uv_depth : TEXCOORD1;
               };
               
               v2f vert(a2v v){
                   v2f o;
                   o.vertex = UnityObjectToClipPos(v.vertex);
                   o.uv = v.uv.xy;
                   o.uv_depth = v.uv.xy;
                   
                   return o;
               };
               
               sampler2D _MainTex;
               sampler2D _CameraDepthTexture;
               float _ScanDistance;
               float _ScanWidth;
               float4 _ScanColor;
               
               half4 frag(v2f i) : SV_Target{
                   half4 col = tex2D(_MainTex, i.uv);
                   
                   //获取深度信息
                   float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth);
                   float linear01Depth = Linear01Depth(depth);
                   
                   if (linear01Depth < _ScanDistance && linear01Depth > _ScanDistance - _ScanWidth && linear01Depth < 1)
                   {
                       float diff = 1 - (_ScanDistance - linear01Depth) / (_ScanWidth);
                       _ScanColor *= diff;
                       return col + _ScanColor;
                   }
    
                   return col;
               };
                
           ENDCG
        }
    }
    
    //FallBack "Diffuse"
}
