package worldgen;

import com.nodename.delaunay.Voronoi;
import com.nodename.geom.Polygon;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.tile.FlxBaseTilemap;

/**
 * ...
 * @author Masadow
 */
@:generic
class World < TileInfo : (ITile, { function new():Void; } ) >
{
	public var tilemap(default, null) : FlxTilemap;
	public var created(default, null) : Bool;
	
	private var tinfo : TileInfo;
	private var polygons : Polygons;
	private var land : Land;
	
	public var debugSprite(default, null) : FlxSprite;
	
	/**
	 * Config generator
	 */
	public var config(default, null) : Config;

	public function new() 
	{
		tilemap = new FlxTilemap();
		created = false;
		tinfo = new TileInfo();
		config = new Config();
		debugSprite = new FlxSprite();
	}
	
	public function create(width : Int, height : Int)
	{
		if (created)
			destroy();

		debugSprite.makeGraphic(Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));
			
		var mapData : Array<Int> = new Array<Int>();

		polygons = new Polygons(config, tinfo);
		land = new Land(polygons.detailedPoly(), polygons.voronoi, config, tinfo);

        //Generate the tilemap
		for (i in 0...width * height)
		{ //Fill the map with ocean
            
			mapData.push(tinfo.deepOcean());
		}
        
        tilemap.loadMapFromArray(mapData, width, height, tinfo.tileset(), tinfo.width(), tinfo.height(), OFF, 0, 0, 0);
		created = true;
	}

	public function destroy()
	{
//		tilemap.destroy();
		polygons.destroy();
		created = false;
	}

	public function beginDraw()
	{
		if (created)
		{
			//Fill with white
			FlxSpriteUtil.fill(debugSprite, FlxColor.WHITE);
		}
	}
	
	public function drawVoronoi()
	{
		if (created)
		{
			polygons.draw(debugSprite);
		}
	}
	
	public function drawNoise()
	{
		if (created)
		{
			land.draw(debugSprite);
		}
	}
    
    public function drawTilemap()
    {
        if (created)
        {
            tilemap.draw();
        }
    }
}