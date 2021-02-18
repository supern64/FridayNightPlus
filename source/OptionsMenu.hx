package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import sys.io.File;
import extype.OrderedMap;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var past:Float = 0;

	var controlMap:OrderedMap<String, String> = new OrderedMap<String, String>();
	var controlOrder:Array<String> = [];

	var selected:Bool = false;
	var options:Array<String>;

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		options = ["controls", "video", "go back"];

		var y:Int = 0;
		for (i in options) {
			var controlLabel:Alphabet = new Alphabet(0, (70 * y) + 30, i, true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = y;
			grpControls.add(controlLabel);
			y++;
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		past += elapsed;

		if (!selected) {
			if (controls.ACCEPT) {
				FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
				var daChoice:String = options[curSelected];
				switch (daChoice)
				{
					case 'controls':
						FlxG.switchState(new ControlsMenu());
					case 'video':
						FlxG.switchState(new VideoMenu());
					case 'go back':
						FlxG.switchState(new MainMenuState());
				}
			}
				
			if (controls.BACK) {
				FlxG.switchState(new MainMenuState());
			}	
			if (controls.UP_P) {
				changeSelection(-1);
			}
			if (controls.DOWN_P) {
				changeSelection(1);
			}
		}
	}
	
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}
