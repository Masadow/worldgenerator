package worldgen;

import com.nodename.delaunay.Voronoi;
import com.nodename.geom.Polygon;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.tile.FlxBaseTilemap;
import flixel.FlxBasic;
import flixel.FlxObject;

/**
 * ...
 * @author Masadow
 */
class World extends FlxGroup
{
	public var tilemap(default, null) : FlxTilemap;
	public var created(default, null) : Bool;
	
	private var polygons : Polygons;
	private var land : Land;
    public var villages : FlxTypedGroup<Village>;
    public var tinfo : ITile;
    
    public var random : FlxRandom;
	
	public var debugSprite(default, null) : FlxSprite;
    
	/**
	 * Config generator
	 */
	public var config(default, null) : Config;

	public function new(tileInfo : ITile) 
	{
        super();
        random = new FlxRandom();
		tilemap = new FlxTilemap();
		created = false;
        tinfo = tileInfo;
		config = new Config();
		debugSprite = new FlxSprite();
        villages = new FlxTypedGroup<Village>();
        
        add(debugSprite);
        add(tilemap);
        add(villages);
	}
	
	public function create(width : Int, height : Int)
	{
		if (created)
			destroy();

		debugSprite.makeGraphic(Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));
			
		var mapData : Array<Int> = new Array<Int>();

		polygons = new Polygons(config, tinfo);
		land = new Land(polygons.detailedPoly(), polygons.voronoi, config, tinfo, width, height);

        tilemap.loadMapFromArray(land.mapData, width, height, tinfo.tileset(), tinfo.width(), tinfo.height(), OFF, 0, 0, 0);

        Village.spawn(this);
            
        created = true;
	}

	override public function destroy()
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
}