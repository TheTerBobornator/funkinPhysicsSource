package;

import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import haxe.Json;
import haxe.format.JsonParser;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import openfl.utils.Assets;

using StringTools;

class StaticImageEndingSubstate extends MusicBeatSubstate
{
    private var theImages:FlxTypedGroup<FlxSprite>;
    private var fadingBox:FlxSprite;
    private var images:Array<String> = [];
    private var fading:Bool = true;
    private var tomfooleryEnding:Bool = false;
    private var canProceed:Bool = false;
    var cam:FlxCamera;

    public function new(images:Array<String>, cam:FlxCamera, ?fading:Bool = true)
    {
        super();
        this.images = images;
        this.fading = fading;
        this.cam = cam;
    }

    override function create()
    {
        trace (images);
        tomfooleryEnding = images.contains('End1'); //tried to check for the entire array but it didn't work for some reason? this works fine tho ig
        trace (tomfooleryEnding);

        if (!tomfooleryEnding)
            FlxG.mouse.visible = true;

        images.reverse();
        
        theImages = new FlxTypedGroup<FlxSprite>();
		add(theImages);

        for (i in 0...images.length)
        {
            var daBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('endings/' + images[i]));
            daBG.antialiasing = ClientPrefs.globalAntialiasing;
            daBG.screenCenter();
            daBG.ID = i;
            daBG.cameras = [cam];
            theImages.add(daBG);
        }

        fadingBox = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
        fadingBox.screenCenter();
        fadingBox.cameras = [cam];
        if (fading)
            add(fadingBox);

        FlxTween.tween(fadingBox, {alpha: 0}, 1, {ease: FlxEase.quadInOut, onComplete: function(tween:FlxTween){
            canProceed = true;
        }});
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        var mouseIsBottomLeft:Bool = FlxG.mouse.getScreenPosition().x <= FlxG.width / 2 && FlxG.mouse.getScreenPosition().y >= FlxG.height / 2;
        var mouseIsBottomRight:Bool = FlxG.mouse.getScreenPosition().x >= FlxG.width / 2 && FlxG.mouse.getScreenPosition().y >= FlxG.height / 2;

		if ((FlxG.mouse.justPressed && mouseIsBottomLeft && !tomfooleryEnding || controls.ACCEPT) && canProceed)
        {
            if (theImages.members.length == 1)
            {
                if (tomfooleryEnding)
                    toMainMenu();
                else
                {
                    MusicBeatState.resetState();
                    PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
                }
                FlxG.mouse.visible = false;
            }
            else if (fading)
            {
                canProceed = false;
                FlxTween.tween(fadingBox, {alpha: 1}, 1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
                    theImages.members.pop().alpha = 0;
                    FlxTween.tween(fadingBox, {alpha: 0}, 1, {ease: FlxEase.quadInOut, onComplete: function(tween:FlxTween){
                        canProceed = true;
                    }});
                }});
            }
            else
                theImages.members.pop().alpha = 0;
        }
        if ((FlxG.mouse.justPressed && mouseIsBottomRight || controls.BACK) && canProceed && theImages.members.length == 1 && !tomfooleryEnding)
		{
            toMainMenu();
            FlxG.mouse.visible = false;
        }
    }

    function toMainMenu()
    {
        FlxG.sound.music.stop();
        PlayState.deathCounter = 0;
        PlayState.seenCutscene = false;
        PlayState.chartingMode = false;

        WeekData.loadTheFirstEnabledMod();

        if (PlayState.isStoryMode) 
            MusicBeatState.switchState(new MainMenuState());
        else
            MusicBeatState.switchState(new FreeplayState(PlayState.songCategory));

        FlxG.sound.playMusic(Paths.music('freakyMenu'));
        PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
    }

    function daFadingTween(?out:Bool = true)
    {
        FlxTween.tween(fadingBox, {alpha: (out ? 0 : 1)}, 1, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){canProceed = true;}});
    }
}