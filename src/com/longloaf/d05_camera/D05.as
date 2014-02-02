package com.longloaf.d05_camera 
{
	import com.longloaf.DemoHelp;
	import com.longloaf.DemoPrompt;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author Maksim Soldatov
	 */
	public class D05 extends FlxState
	{
		[Embed(source = "tiles_8x8_2.png")]
		private static const Tiles:Class;
		
		[Embed(source = "map.png")]
		private static const Map:Class;
		
		private const TILE_SIZE:int = 8;
		private const HALF_TILE:Number = TILE_SIZE * 0.5;
		
		private var help:DemoHelp;
		
		private var tileMap:FlxTilemap;
		private var spikeGroup:FlxGroup;
		
		private var player:D05_Player;
		private var point:FlxPoint;
		
		private var cam1:FlxCamera;
		private var cam2:FlxCamera;
		
		override public function create():void 
		{
			help = new DemoHelp();
			help.addText("[ARROWS] - move");
			
			tileMap = new FlxTilemap();
			tileMap.loadMap(FlxTilemap.imageToCSV(Map), Tiles, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 0);
			tileMap.x = (FlxG.width - tileMap.width) / 2;
			tileMap.y = 104 - tileMap.height;
			
			spikeGroup = new FlxGroup();
			
			player = new D05_Player();
			player.x = tileMap.x + 4 * TILE_SIZE;
			player.y = tileMap.y + 3 * TILE_SIZE;
			moveSprite(player, 1, 0);
			point = new FlxPoint();
			
			cam1 = new FlxCamera(40, 236, 80, 80, 4);
			cam1.follow(player);
			tileMap.follow(cam1);
			FlxG.addCamera(cam1);
			
			cam2 = new FlxCamera(440, 236, 80, 80, 4);
			FlxG.addCamera(cam2);
			
			add(tileMap);
			add(spikeGroup);
			add(player);
			add(help);
			add(new DemoPrompt("Camera"));
			
			makeSpikes(2, 8, 6);
			makeSpikes(11, 8, 6);
		}
		
		override public function update():void 
		{
			if (FlxG.keys.justPressed("Z")) {
				cam1.shake();
				cam2.shake();
			} else if (FlxG.keys.justPressed("X")) {
				cam1.flash();
				cam2.flash();
			} else if (FlxG.keys.justPressed("C")) {
				cam1.fade(0xff000000, 1, cam1.stopFX);
				cam2.fade(0xff000000, 1, cam2.stopFX);
			}
			super.update();
			FlxG.collide(player, tileMap);
			FlxG.overlap(player, spikeGroup, ovPlayerSpikes);
			
			var roomWidth:Number = cam2.width - TILE_SIZE;
			var x0:Number = tileMap.x + HALF_TILE;
			player.getMidpoint(point);
			point.x -= x0;
			point.x = x0 + (int(point.x / roomWidth) + 0.5) * roomWidth;
			point.y = tileMap.y + cam2.height * 0.5;
			cam2.focusOn(point);
		}
		
		private function ovPlayerSpikes(o1:FlxObject, o2:FlxObject):void
		{
			player.kill();
		}
		
		private function moveSprite(s:FlxSprite, tx:int, ty:int):void
		{
			s.last.x = s.x = tileMap.x + tx * TILE_SIZE + (TILE_SIZE - s.width) * 0.5;
			s.last.y = s.y = tileMap.y + (ty + 1) * TILE_SIZE - s.height;
		}
		
		private function makeSpikes(tx:int, ty:int, num:int):void
		{
			for (var i:int = 0; i < num; ++i) {
				var s:D05_Spikes = new D05_Spikes();
				moveSprite(s, tx, ty);
				spikeGroup.add(s);
				++tx;
			}
		}
		
	}

}