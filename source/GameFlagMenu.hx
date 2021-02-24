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

class GameFlagMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var past:Float = 0;

	var flags:OrderedMap<String, String>;

	private var flagSettings:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		flags = CoolUtil.loadGameFlagOrdered();
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		flagSettings = new FlxTypedGroup<Alphabet>();
		add(flagSettings);

		var y:Int = 0;
		for (flag => setting in flags)
		{
			var flagLabel:Alphabet = new Alphabet(0, (70 * y) + 30, flag + ': ' + setting, true, false);
			flagLabel.isMenuItem = true;
			flagLabel.targetY = y;
			flagSettings.add(flagLabel);
			y++;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		past += elapsed;

		if (controls.ACCEPT && past > 0.2) {
			past = 0;
			toggleFlag();
		}
		if (controls.BACK) {
			File.saveContent("assets/data/gameFlag.txt", CoolUtil.exportGameFlag(flags));
			FlxG.switchState(new OptionsMenu());
		}	
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
	}

	function getToggleType(flag:String):String
	{
		var toggleType:Map<String, String> = [
			"noHurt" => "boolean",
			"useGitarooPause" => "boolean",
			"despawnGF" => "boolean",
			"despawnDad" => "boolean",
			"despawnBF" => "boolean",
			"hideCombo" => "combo",
			"hidePlayerIcon" => "boolean",
			"hideHealthBar" => "boolean",
			"showAccuracy" => "boolean",
			"accuracyPercentType" => "accType"
		];
		return toggleType[flag];
	}

	function toggleFlag():Void
	{
		for (a in flagSettings.iterator()) {
			if (a.targetY == 0) {
				var funnyArray:Array<String> = a.text.split(": ");
				var flag:String = funnyArray[0];
				var setting:String = funnyArray[1];

				var booleanFlag:Array<String> = ["true", "false"];
				var comboFlag:Array<String> = ["true", "false", "bar"];
				var accTypeFlag:Array<String> = ["hit", "score"];

				var newFlagIndex:Int = 0;
				var type:String = getToggleType(flag);
				var flagOptions:Array<String> = [];

				switch (type)
				{
					case "boolean":
						flagOptions = booleanFlag;
					case "combo":
						flagOptions = comboFlag;
					case "accType":
						flagOptions = accTypeFlag;
				}

				newFlagIndex = flagOptions.indexOf(setting) + 1;
				if (newFlagIndex >= flagOptions.length)
					newFlagIndex = 0;

				flags.set(flag, flagOptions[newFlagIndex]);
				var flagLabel:Alphabet = new Alphabet(0, 0, flag + ': ' + flagOptions[newFlagIndex], true, false);
				flagLabel.isMenuItem = true;
				flagLabel.targetY = 0;
				flagSettings.replace(a, flagLabel);
				break;
			}	
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = flagSettings.length - 1;
		if (curSelected >= flagSettings.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in flagSettings.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
