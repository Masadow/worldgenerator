package ;
import worldgen.noise.PerlinNoise;
import worldgen.World;
import worldgen.Config;

/**
 * ...
 * @author Masadow
 */
class Controls
{
	public static var world : World<Tile>;
	public static var perlin : PerlinNoise;
	
	public static function changeNode(dir : Int) : String
	{
		if (dir > 0)
			world.config.node += 25;
		else if (dir < 0)
			world.config.node -= 25;
		return world.config.node + "";
	}	

	public static function changeLloyd(dir : Int) : String
	{
		if (dir > 0)
			world.config.lloydIteration += 1;
		else if (dir < 0)
			world.config.lloydIteration -= 1;
		return world.config.lloydIteration + "";
	}
	
	public static function changeRandomness(dir : Int) : String
	{
		if (dir != 0)
			world.config.randomness = world.config.randomness == PSEUDORANDOM ? QUASIRANDOM : PSEUDORANDOM;
		return world.config.randomness == PSEUDORANDOM ? "Pseudorandom" : "Quasirandom";
	}
	
	public static function changePersistance(dir : Int) : String
	{
		if (dir > 0)
			perlin.persistance += 0.05;
		else if (dir < 0)
			perlin.persistance -= 0.05;
		perlin.persistance = Math.fround(perlin.persistance * 100) / 100;
		return perlin.persistance + "";
	}

	public static function changeOctave(dir : Int) : String
	{
		if (dir > 0)
			perlin.octave += 1;
		else if (dir < 0)
			perlin.octave -= 1;
		return perlin.octave + "";
	}

	public static function changeAmplitude(dir : Int) : String
	{
		if (dir > 0)
			perlin.amplitude += 0.5;
		else if (dir < 0)
			perlin.amplitude -= 0.5;
		perlin.amplitude = Math.fround(perlin.amplitude * 10) / 10;
		return perlin.amplitude + "";
	}

	public static function changeInterpolation(dir : Int) : String
	{
		if (dir != 0)
			perlin.interpolation = perlin.interpolation == LINEAR ? CUBIC : LINEAR;
		return perlin.interpolation == LINEAR ? "Linear" : "Cubic";
	}

	public static function changeWaterLevel(dir : Int) : String
	{
		if (dir > 0)
			world.config.waterLevel += 0.02;
		else if (dir < 0)
			world.config.waterLevel -= 0.02;
		world.config.waterLevel = Math.fround(world.config.waterLevel * 100) / 100;
		return world.config.waterLevel + "";
	}

	public static function changeMountainLevel(dir : Int) : String
	{
		if (dir > 0)
			world.config.mountainLevel += 0.02;
		else if (dir < 0)
			world.config.mountainLevel -= 0.02;
		world.config.mountainLevel = Math.fround(world.config.mountainLevel * 100) / 100;
		return world.config.mountainLevel + "";
	}
}
