package worldgen.noise;
import worldgen.Config;

/**
 * ...
 * @author Masadow
 */
interface INoise
{
	public function compute(config : Config) : Array<Array<Float>>;
}