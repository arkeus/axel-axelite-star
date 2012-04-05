package net.axgl.star.entity {
	import org.axgl.AxSprite;

	/**
	 * The base enetity class
	 */
	public class Entity extends AxSprite {
		public function Entity(x:Number, y:Number, graphic:Class) {
			super(x, y, graphic);
		}
	}
}
