using HoloToolkit.Unity.InputModule;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;

public class Screenshot : MonoBehaviour{
    GameObject[] all_Objs;

    // Use this for initialization
    void Start () {

	}

	public void takeScreenshot () {     
		//Debug.Log("screenshot clicked");

		all_Objs = SceneManager.GetActiveScene().GetRootGameObjects();

		foreach (GameObject g in all_Objs){
			if (g.name != "brush (Clone)" && g.name != "Directional Light"){
				g.SetActive(false);        
			}
			else{
				g.SetActive(true);
			}
		}

		ScreenCapture.CaptureScreenshot("shottest.png");

		foreach (GameObject g in all_Objs){
			g.SetActive(true);
		}
	}
}