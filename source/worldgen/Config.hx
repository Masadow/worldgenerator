package worldgen;

import flash.geom.Rectangle;
import flash.utils.CompressionAlgorithm;
import worldgen.noise.PerlinNoise;
import worldgen.noise.INoise;

/**
 * ...
 * @author Masadow
 */
class Config
{

	public var node : Int; //Number of nodes. More node mean
	public var layerBounds(default, null) : Rectangle;
	public var lloydIteration : Int;
	public var randomness : RandomAlgorithm;
	public var noise : INoise;
	public var noiseOctave : Int;
	public var waterLevel : Float; //between 0 and 1
	public var mountainLevel : Float;
	
	public function new() 
	{		
		//Default config
		node = 2000;
		layerBounds = new Rectangle(0, 0, 2048, 2048);
		lloydIteration = 2;
		randomness = QUASIRANDOM;
		noise = new PerlinNoise();
		waterLevel = 0.4;
		mountainLevel = 0.8;
	}
}

enum RandomAlgorithm {
	PSEUDORANDOM;
	QUASIRANDOM;
}

