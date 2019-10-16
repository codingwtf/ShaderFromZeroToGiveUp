using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Analytics;

[RequireComponent(typeof(Camera))]
public class Scanner : MonoBehaviour
{
    public Material mat;
    private float distance;
    private bool isScanner = false;
    private float volecity = 5;
    
    void Start()
    {
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    void Update()
    {
        if (isScanner)
        {
            distance += Time.deltaTime * volecity;
        }

        if (Input.GetKeyDown(KeyCode.S))
        {
            isScanner = true;
            distance = 0;
        }
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        mat.SetFloat("_ScanDistance", distance);
        Graphics.Blit(src, dest, mat);
    }
}
