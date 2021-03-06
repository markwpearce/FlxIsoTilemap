package ;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import iso.FlxIsoTilemap;
import iso.MapUtils;
import openfl.Assets;

class TiledState extends FlxState
{
	static inline var VIEWPORT_WIDTH:Float = 800;
	static inline var VIEWPORT_HEIGHT:Float = 480;

	//Max size tested = 1200x1200 (~850MB mem, no optimization)
	static inline var MAP_WIDTH:Float = 20;
	static inline var MAP_HEIGHT:Float = 20;

	static inline var TILE_WIDTH:Float = 64;
	static inline var TILE_HEIGHT:Float = 96;
	static inline var TILE_HEIGHT_OFFSET:Float = 64;
  
	var map:FlxIsoTilemap;
	
	var player:FlxSprite;
	
	override public function create():Void
	{
		super.create();
		
		//Tiled loader supports TMX files in both XML and JSON encodings
		//Json encoding 
		var mapData:String = Assets.getText('assets/data/test_tiled_json.tmx'); 
		//Xml encoding
		//var mapData:String = Assets.getText('assets/data/test_tiled_xml.tmx'); 
		
		map = MapUtils.getMapFromTiled(mapData, new FlxPoint(VIEWPORT_WIDTH, VIEWPORT_HEIGHT), new FlxPoint(TILE_WIDTH, TILE_HEIGHT), TILE_HEIGHT_OFFSET);
		add(map);
		
		
		trace('Map Size : ${map.map_w},${map.map_h}');
		
		trace('Map layers : ${map.layers.length}');
		
		//Sprite with animations
		player = new FlxSprite(0, 0);
		player.loadGraphic(map.getTilesetGraphic(0), true, TILE_WIDTH, TILE_HEIGHT);
		player.animation.add('Idle_NE', [62], 8, true);
		player.animation.add('Walk_NE', [62, 63, 64, 65, 66], 8, true);
		player.animation.add('Idle_SE', [67], 8, true);
		player.animation.add('Walk_SE', [67, 68, 69, 70, 71], 8, true);
		player.animation.play('Idle_NE');
		player.pixelPerfectPosition = player.pixelPerfectRender = false;
		
		map.addSpriteAtTilePos(player, 1, 14, 14);
		
		//map.follow(FlxG.camera);
		
		//FlxG.camera.follow(player);
		//FlxG.camera.follow(player, FlxCameraFollowStyle.TOPDOWN, 0.5);
	}

	override public function update(elapsed:Float):Void
	{
		handleKeyboardInput(elapsed);

		super.update(elapsed);
	}
  
	function handleKeyboardInput(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MenuState());
		}
		
		if (FlxG.keys.pressed.DOWN) {
			FlxG.camera.scroll.y -= 200 * elapsed;
		} 
		
		if (FlxG.keys.pressed.LEFT) {
			FlxG.camera.scroll.x += 200 * elapsed;
		}
		
		if (FlxG.keys.pressed.RIGHT) {
			FlxG.camera.scroll.x -= 200 * elapsed;
		}
		
		if (FlxG.keys.pressed.UP) {
			FlxG.camera.scroll.y += 200 * elapsed;
		}
		
		if (FlxG.keys.justReleased.PLUS) {
			map.scale.x += 0.2;
			map.scale.y += 0.2;
		}
		if (FlxG.keys.justReleased.MINUS) {
			map.scale.x -= 0.2;
			map.scale.y -= 0.2;
		}
		
		if (FlxG.keys.pressed.W) {
			player.x += 200 * elapsed;
			player.y -= 100 * elapsed;
			
			FlxG.camera.scroll.x -= 200 * elapsed;
			FlxG.camera.scroll.y += 100 * elapsed;
			
			//player.y -= 100 * elapsed;
		}
		
		if (FlxG.keys.pressed.S) {
			player.x -= 200 * elapsed;
			player.y += 100 * elapsed;
			
			FlxG.camera.scroll.x += 200 * elapsed;
			FlxG.camera.scroll.y -= 100 * elapsed;
			
			//player.y += 100 * elapsed;
		} 
		
		if (FlxG.keys.pressed.A) {
			player.x -= 200 * elapsed;
			player.y -= 100 * elapsed;
			
			FlxG.camera.scroll.x += 200 * elapsed;
			FlxG.camera.scroll.y += 100 * elapsed;
			
			//player.x -= 200 * elapsed;
		}
		
		if (FlxG.keys.pressed.D) {
			player.x += 200 * elapsed;
			player.y += 100 * elapsed;
			
			FlxG.camera.scroll.x -= 200 * elapsed;
			FlxG.camera.scroll.y -= 100 * elapsed;
			
			//player.x += 200 * elapsed;
		}
		
		handlePlayerAnimation();
	}
	
	function handlePlayerAnimation()
	{
		if (FlxG.keys.justPressed.S) {
			//SW
			player.animation.play('Walk_SE');
			player.flipX = true;
		}
		else if (FlxG.keys.justPressed.A) {
			//NW
			player.animation.play('Walk_NE');
			player.flipX = true;
		}
		else if (FlxG.keys.justPressed.D) {
			//SE
			player.animation.play('Walk_SE');
			player.flipX = false;
		}
		else if (FlxG.keys.justPressed.W) {
			//NE
			player.animation.play('Walk_NE');
			player.flipX = false;
		}
		
		//Stop Walking
		if (FlxG.keys.justReleased.S) {
			//SW
			player.animation.play('Idle_SE');
		}
		
		if (FlxG.keys.justReleased.A) {
			//NE
			player.animation.play('Idle_NE');
		}
		
		if (FlxG.keys.justReleased.D) {
			//SE
			player.animation.play('Idle_SE');
		}
		
		if (FlxG.keys.justReleased.W) {
			//NW
			player.animation.play('Idle_NE');
		}
	}
}
