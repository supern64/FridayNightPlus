package;

import lime.utils.Assets;
import Controls.Control;
import extype.OrderedMap;

using StringTools;

class CoolUtil
{
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	public static function parseControlString(str:String): Control
	{
		var controlMap:Map<String, Control> = [
			"UP" => Control.UP, 
			"DOWN" => Control.DOWN,
			"LEFT" => Control.LEFT,
			"RIGHT" => Control.RIGHT,
			"ACCEPT" => Control.ACCEPT,
			"BACK" => Control.BACK,
			"PAUSE" => Control.PAUSE,
			"RESET" => Control.RESET,
			"CHEAT" => Control.CHEAT
		];
		return controlMap[str];
	}

	public static function cStringFromMap(map:OrderedMap<String, String>):String
	{
		var finalSt:String = "";
		for (ctrl => bind in map) {
			finalSt = finalSt + "set" + ctrl + "\n" + bind + "\n";
		}
		return finalSt;
	}

	public static function cMapFromSArray(str:Array<String>):OrderedMap<String,String>
	{
		var map:OrderedMap<String, String> = new OrderedMap<String, String>();
		for (i in 0...str.length)
		{
			if (str[i].indexOf('set') != -1)
			{
				var ctrl:String = str[i].substring(3);
				var bind:String = str[i + 1];
				map.set(ctrl, bind);
			}
		}
		return map;
	}

	public static function loadGameFlag():Map<String, String>
	{
		var map:Map<String, String> = [];
		var stringA:Array<String> = Assets.getText("assets/data/gameFlag.txt").trim().split('\n');
		for (i in stringA) {
			var fSplit = i.split(":");
			map[fSplit[0]] = fSplit[1];
		}
		return map;
	}
}
