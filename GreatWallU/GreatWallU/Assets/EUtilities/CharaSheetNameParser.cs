using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharaSheetNameParser : MonoBehaviour
{
    public string s = "Ch_Igor_Walk_(200M200)_(50M50)";
    
    public string charaName,animName,cellSize,pivot;
    public string parsed;
    public Vector2 cellSizeV,pivotV;

    void Start()
    {
        ParseName(s,out charaName,out animName,out cellSizeV,out pivotV,out cellSize,out pivot);
    }

    public static void ParseName(string fileName,out string charaName,out string animName, out Vector2 cellSizeV,out Vector2 pivotV,out string cellSize,out string pivot)
    {
        string parsed = fileName;
        parsed = parsed.Replace("Ch_","");
        
        int sep = parsed.IndexOf("_");
        charaName = parsed.Substring(0,sep);
        parsed = parsed.Replace(charaName+"_","");
        
        sep = parsed.IndexOf("_");
        animName = parsed.Substring(0,sep);
        parsed = parsed.Replace(animName+"_","");

        sep = parsed.IndexOf("_");
        cellSize = parsed.Substring(0,sep);
        parsed = parsed.Replace(cellSize+"_","");

        sep = parsed.IndexOf("_");
        pivot = parsed;
        parsed = "";
        
        
        int x =0;
        int y =0;
        parsed = cellSize;
        parsed = parsed.Replace("(","");
        sep = parsed.IndexOf("M");
        x = int.Parse(parsed.Substring(0,sep));

        parsed = parsed.Replace(parsed.Substring(0,sep+1),"");
        parsed = parsed.Replace(")","");
        y = int.Parse(parsed);
        cellSizeV = new Vector2(x,y);

        parsed = pivot;
        parsed = parsed.Replace("(","");
        sep = parsed.IndexOf("M");
        x = int.Parse(parsed.Substring(0,sep));
        //clean string until from start to seprator
        parsed = parsed.Replace(parsed.Substring(0,sep+1),"");
        int endStartIndex = parsed.IndexOf(")");
        int deltaSize = parsed.Length - endStartIndex;
        string ending = parsed.Substring(endStartIndex,deltaSize);
        
        parsed = parsed.Replace(ending,"");
        pivot = parsed;
        y = int.Parse(parsed);
        pivotV = new Vector2(x,y)/100.0f;
    }
}