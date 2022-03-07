using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpriteSheetToAnim : MonoBehaviour
{
    public string animSavePath = "Assets/00_JG/CharaAnims";
    public Texture2D[] texes = new Texture2D[0];
    public int fps = 12;
    public string spritePropPath = "Model";
    public string propName = "m_Sprite";
    public bool doLoop = false;
    public bool replaceExistingAnims = false;
    public enum Dirs { Down, Left, Right, Up, DownLeft, UpLeft, DownRight, UpRight, None }
    public List<Dirs> dirs = new List<Dirs>() { Dirs.None };
}