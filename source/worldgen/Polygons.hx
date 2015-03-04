package worldgen;
import flash.geom.Point;
import com.nodename.delaunay.Voronoi;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;

/**
 * ...
 * @author Masadow
 */
class Polygons
{

	public var voronoi(default, null) : Voronoi;
	private var nodes : Array<Point>;
	private var tinfo : ITile;
    private var config : Config;
	
	public function new(world : World)
	{
		this.tinfo = world.tinfo;
        this.config = world.config;

//		nodes = randomNodes(config);

//		voronoi = new Voronoi(nodes, null, config.layerBounds);
		
	}
    
	public function randomizeNodes()
	{
		nodes = new Array<Point>();
		switch (config.randomness)
		{
			case PSEUDORANDOM:
				for (i in 0...config.node)
				{ //Create some random points for Voronoi
					nodes.push(new Point(Math.random() * config.layerBounds.width, Math.random() * config.layerBounds.height));
				}
			case QUASIRANDOM: //Bad algorithm, need improvements
				var step : Float = config.layerBounds.height / config.node;
				for (i in 0...config.node)
				{
					nodes.push(new Point(Math.random() * config.layerBounds.width, step * i));
				}
		}
	}
    
    public function generateVoronoi() {
		voronoi = new Voronoi(nodes, null, config.layerBounds);
    }
    
    public function smoothRegions() {
//		for (i in 0...config.lloydIteration)
//		{ //Make the regions centroids smoother using lloyd algorithm
			nodes = new Array<Point>(); //Recycle nodes to hold new centroids
			//Get centroids
			for (polygon in voronoi.regions())
			{
				nodes.push(Helper.computeCentroid(polygon));
			}
			//Create the new Voronoi
			voronoi.dispose();
//			voronoi = new Voronoi(nodes, null, config.layerBounds);
//		}
    }
	
	public function draw(sprite : FlxSprite)
	{
		//Draw nodes
		for (node in nodes)
		{
			FlxSpriteUtil.drawCircle(sprite, node.x, node.y, 2, FlxColor.GREEN);
		}
		//Draw regions
		for (polygon in voronoi.regions())
		{
			var preVertice : Null<Point> = null;
			for (vertice in polygon)
			{
				if (preVertice == null)
				{
					preVertice = polygon[polygon.length - 1];
				}
				if (preVertice != null)
				{
					FlxSpriteUtil.drawLine(sprite, preVertice.x, preVertice.y, vertice.x, vertice.y, {color: FlxColor.RED, thickness: 1 } );
					preVertice = vertice;
				}
			}
		}
	}
	
	public function destroy()
	{
		voronoi.dispose();
	}
	
	public function detailedPoly() : Array<Polygon>
	{
		var polys = new Array<Polygon>();
		for (polygon in voronoi.regions())
		{
			polys.push(new Polygon(polygon, tinfo.deepOcean()));
		}
		return polys;
	}
}