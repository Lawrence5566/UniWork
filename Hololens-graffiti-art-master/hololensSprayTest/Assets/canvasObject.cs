using HoloToolkit.Unity.InputModule;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class canvasObject : MonoBehaviour, IInputHandler, ISourceStateHandler, ISourcePositionHandler { //handler for inputdown&up, source for source deteded and lost
    public GameObject hololensCursor;
    //RenderTexture renderTexture;
    public Material baseMaterial;
    public GameObject brush;
	private bool isSpraying;
	private Color brushColor;

	public Vector3 handPosition;
    public Quaternion clickerOrientation;
    private bool handInFOV;
    public uint handSourceId; 

	public void OnInputDown(InputEventData eventData){
		Debug.Log("wall action down");
        isSpraying = true;
    }

	public void OnInputUp(InputEventData eventData){
		Debug.Log("wall action up");
		isSpraying = false;
	}

    public void OnSourceDetected(SourceStateEventData eventData) {  //when source is detected (ie hand moves in view)
        Debug.Log("hand in view");
        handInFOV = true;
    }

    public void OnSourceLost(SourceStateEventData eventData) {  //when source is lost (ie hand moves out of view)
        Debug.Log("hand out of view");
        handInFOV = false;
    }

    public void OnPositionChanged(SourcePositionEventData eventData) //when source changes position (ie hand moves)
    {
        Debug.Log("position changed.");
        eventData.InputSource.TryGetGripPosition(eventData.SourceId, out handPosition);
        eventData.InputSource.TryGetGripRotation(eventData.SourceId, out clickerOrientation);
        Debug.Log("hand pos: " + handPosition + "clicker pos: " + clickerOrientation);
    }

    public void setBrushColor(Color newColor){
        brushColor = newColor;
	}

    public void spraying() {
        //create raycast from hand to wall, that should be position of where to throw brush, not cursor

        Vector3 pointToSpray;
        Quaternion pointHitRotation;
        float distanceDifference = 1;

        RaycastHit hit; // create raycast

        if (Physics.Raycast(handPosition, Camera.main.transform.forward, out hit, 50) ) //&& handInFov
        {
            pointToSpray = hit.point;
            Debug.Log(hit.point);
            pointHitRotation = clickerOrientation;

            distanceDifference = Vector3.Distance(handPosition, hit.point);
            distanceDifference *= 0.1f;

        }
        else {
            pointToSpray = hololensCursor.transform.position;
            pointHitRotation = hololensCursor.transform.rotation;
        }


        GameObject brushObj;
		brushObj = Instantiate(brush); //Paint a brush
		brushObj.GetComponent<SpriteRenderer>().color = brushColor;             //Set the brush color
        //brushObj.transform.localPosition = hololensCursor.transform.position; 	//The position of the brush          
        //brushObj.transform.localRotation = hololensCursor.transform.rotation; 	//Rotation of brush
        brushObj.transform.localPosition = pointToSpray;
        brushObj.transform.localRotation = pointHitRotation;
        brushObj.transform.localScale = new Vector3(0.1f, 0.1f, 0.1f);
        //brushObj.transform.localScale = new Vector3(distanceDifference, distanceDifference, distanceDifference);								//The size of the brush

    }


    // Use this for initialization
    void Start () {
		isSpraying = false;
		brushColor = Color.red;

        handInFOV = false;
    
        Quaternion clickerOrientation = hololensCursor.transform.rotation; //start orientation

        //brush = Resources.Load("brush") as GameObject;              //load brush from file
        //baseMaterial = Resources.Load("baseMaterial", typeof(Material)) as Material;    //load base material from file
        //hololensCursor = GameObject.Find("DefaultCursor");

        //renderTexture = new RenderTexture(256, 256, 16, RenderTextureFormat.ARGB32);
    }
	
	// Update is called once per frame
	void Update () {
        if (isSpraying && handInFOV) {
			spraying ();
		}
	}
}
