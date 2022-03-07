using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;
using System.IO;
using System;

[CustomEditor(typeof(SpriteSheetToAnim))]
public class SpriteSheetToAnimEditor : Editor
{
    SpriteSheetToAnim mySelf = null;
    void OnEnable()
    {
        mySelf = target as SpriteSheetToAnim;
    }

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        GUILayout.BeginHorizontal();
        if (GUILayout.Button("Add Eight"))
        {
            mySelf.dirs.Clear();
            for (int i = 0; i < 8; i++)
            {
                mySelf.dirs.Add((SpriteSheetToAnim.Dirs)i);
            }
            EditorUtility.SetDirty(mySelf);

        }
        if (GUILayout.Button("Add Four"))
        {
            mySelf.dirs.Clear();
            for (int i = 0; i < 4; i++)
            {
                mySelf.dirs.Add((SpriteSheetToAnim.Dirs)i);
            }
            EditorUtility.SetDirty(mySelf);
        }
        if (GUILayout.Button("Add Two"))
        {
            mySelf.dirs.Clear();
            mySelf.dirs.Add(SpriteSheetToAnim.Dirs.Right);
            mySelf.dirs.Add(SpriteSheetToAnim.Dirs.Left);
            EditorUtility.SetDirty(mySelf);
        }
        if (GUILayout.Button("Add One"))
        {
            mySelf.dirs.Clear();
            mySelf.dirs.Add(SpriteSheetToAnim.Dirs.Right);
            EditorUtility.SetDirty(mySelf);
        }
        if (GUILayout.Button("Set None"))
        {
            mySelf.dirs.Clear();
            mySelf.dirs.Add(SpriteSheetToAnim.Dirs.None);
            EditorUtility.SetDirty(mySelf);
        }
        EditorGUILayout.EndHorizontal();

        if (GUILayout.Button("Create Animations"))
        {
            foreach (var tex in mySelf.texes)
            {
                List<Sprite> sprites = GetAllSprites(tex);

                for (int i = 0; i < mySelf.dirs.Count; i++)
                {
                    AnimationClip animClip = GetAnimClip();
                    EditorCurveBinding spriteBinding = GetSpriteBinding();
                    List<Sprite> slicedSprites = GetDirSprites(sprites, i);
                    ObjectReferenceKeyframe[] spriteKeyFrames = GetKeyFrames(slicedSprites);

                    AnimationUtility.SetObjectReferenceCurve(animClip, spriteBinding, spriteKeyFrames);
                    string animClipPath = GetAnimClipFileName(tex, i);

                    AssetDatabase.CreateAsset(animClip, animClipPath + ".anim");
                    AssetDatabase.SaveAssets();
                    AssetDatabase.Refresh();
                }

            }
        }
    }

    private string GetAnimClipFileName(Texture2D tex, int i)
    {
        CharaSheetNameParser.ParseName(tex.name, out string charaName, out string animName, out Vector2 cellSizeV, out Vector2 pivotV, out string cellSize, out string pivot);
        string animClipPath = Path.Combine(mySelf.animSavePath, charaName + "_" + animName);

        if (i != (int)SpriteSheetToAnim.Dirs.None)
        {
            animClipPath = animClipPath + "_" + (SpriteSheetToAnim.Dirs)i;
        }

        while (mySelf.replaceExistingAnims && File.Exists(animClipPath + ".anim"))
        {
            animClipPath = animClipPath + "1";
        }

        return animClipPath;
    }

    private ObjectReferenceKeyframe[] GetKeyFrames(List<Sprite> slicedSprites)
    {
        ObjectReferenceKeyframe[] spriteKeyFrames = new ObjectReferenceKeyframe[slicedSprites.Count];
        for (int j = 0; j < slicedSprites.Count; j++)
        {
            spriteKeyFrames[j] = new ObjectReferenceKeyframe();
            spriteKeyFrames[j].time = (float)j / (float)mySelf.fps;
            spriteKeyFrames[j].value = slicedSprites[j]; 
        }

        return spriteKeyFrames;
    }

    private List<Sprite> GetDirSprites(List<Sprite> sprites, int index)
    {
        List<Sprite> dirSprites = new List<Sprite>();
        int ySpritesCount = (mySelf.dirs.Count);
        //x count of sprites
        int spritesCountPerDir = Mathf.CeilToInt(sprites.Count/ySpritesCount);
        //Debug.Log("---------------"+sprites.Count + " ------------------- " + spritesCountPerDir);
        for (int i = 0; i < spritesCountPerDir; i++)
        {
            int dirSpriteIndex = index*spritesCountPerDir + i;
            //Debug.Log("index " + index + " :: i :: " + i + " :: dirSpriteIndex " + dirSpriteIndex);
            Sprite s = sprites[dirSpriteIndex];
            dirSprites.Add(s);
        }
        return dirSprites;
    }

    private static List<Sprite> GetAllSprites(Texture2D tex)
    {
        string texPath = AssetDatabase.GetAssetPath(tex);
        UnityEngine.Object[] objs = UnityEditor.AssetDatabase.LoadAllAssetsAtPath(texPath);
        List<Sprite> sprites = objs.Where(q => q is Sprite).Cast<Sprite>().ToList();
        return sprites;
    }

    private AnimationClip GetAnimClip()
    {
        AnimationClip animClip = new AnimationClip();
        animClip.frameRate = mySelf.fps;
        if (mySelf.doLoop)
        {
            var settings = AnimationUtility.GetAnimationClipSettings(animClip);
            settings.loopTime = mySelf.doLoop;
            AnimationUtility.SetAnimationClipSettings(animClip, settings);
        }

        return animClip;
    }

    private EditorCurveBinding GetSpriteBinding()
    {
        EditorCurveBinding spriteBinding = new EditorCurveBinding();
        spriteBinding.type = typeof(SpriteRenderer);
        spriteBinding.path = mySelf.spritePropPath;
        spriteBinding.propertyName = mySelf.propName;
        return spriteBinding;
    }
}