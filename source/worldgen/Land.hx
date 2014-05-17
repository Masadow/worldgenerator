package worldgen;
import com.nodename.delaunay.Voronoi;
import flixel.FlxSprite;

/**
 * ...
 * @author Masadow
 */
class Land
{
	private var polygons : Array<Polygon>;
	private var tinfo : ITile;

	public function new(polygons : Array<Polygon>, voronoi : Voronoi, config : Config, tinfo : ITile)
	{
		this.polygons = polygons;
		this.tinfo = tinfo;

		var noise : Array<Array<Float>> = config.noise.compute(config);

		for (polygon in polygons)
		{
			if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.mountainLevel)
				polygon.kind = tinfo.mountain();
			else if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.waterLevel)
				polygon.kind = tinfo.grass();
		}
	}

	public function draw(sprite : FlxSprite)
	{
		for (polygon in polygons)
		{
			polygon.draw(sprite, tinfo);
		}
	}
}