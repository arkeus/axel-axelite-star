package net.axgl.star.display {
	import org.axgl.AxGroup;
	import org.axgl.AxSprite;

	/**
	 * A scrolling starfield that repeats itself.
	 */
	public class Starfield extends AxGroup {
		/**
		 * The top of the two sprites.
		 */
		private var topField:AxSprite;
		/**
		 * The bottom of the two sprites
		 */
		private var bottomField:AxSprite;

		/**
		 * Create a new starfield using the passed graphic. Speed indicates how fast this starfield should scroll,
		 * and alpha indicates the opacity it should have. Used to create parallax star background.
		 */
		public function Starfield(graphic:Class, speed:Number, alpha:Number) {
			super();

			// Stack two copies of the graphic on top each other
			bottomField = new AxSprite(0, 0, graphic);
			topField = new AxSprite(0, -bottomField.height, graphic);

			this.add(bottomField).add(topField);

			// Set their speed and alpha
			bottomField.velocity.y = topField.velocity.y = speed;
			bottomField.alpha = topField.alpha = alpha;
		}

		override public function update():void {
			// If they scroll too far down, move them both up, to simulate seamless repeating
			if (topField.y >= 0) {
				topField.y -= topField.height;
				bottomField.y -= topField.height;
			}

			super.update();
		}
	}
}
