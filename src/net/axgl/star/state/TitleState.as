package net.axgl.star.state {
	import net.axgl.star.display.Starfield;
	import net.axgl.star.util.Resource;
	
	import org.axgl.Ax;
	import org.axgl.AxButton;
	import org.axgl.AxSprite;
	import org.axgl.AxState;
	import org.axgl.AxU;
	import org.axgl.input.AxKey;
	import org.axgl.render.AxColor;
	import org.axgl.text.AxText;

	/**
	 * Our title screen state.
	 */
	public class TitleState extends AxState {
		/** The title image */
		private var background:AxSprite;
		/** The button that links to the website */
		private var websiteButton:AxButton;

		override public function create():void {
			// Set the background to black
			Ax.background = new AxColor(0, 0, 0);

			// Add the starfields, to make the title screen more interesting
			this.add(new Starfield(Resource.STARFIELD_A, 180, 0.5));
			this.add(new Starfield(Resource.STARFIELD_B, 140, 0.4));
			this.add(new Starfield(Resource.STARFIELD_C, 100, 0.3));
			this.add(new Starfield(Resource.STARFIELD_D, 60, 0.15));

			// Add our title text
			background = new AxSprite(0, 0, Resource.TITLE);
			this.add(background);

			// Add our website button
			websiteButton = new AxButton(24, 224);
			websiteButton.text("axgl.org");
			websiteButton.onClick(function():void {
				AxU.openURL("http://axgl.org");
			});
			websiteButton.alpha = 0.8;
			this.add(websiteButton);

			// Don't draw or update this state if we're not at the title screen
			persistantUpdate = false;
			persistantDraw = false;
		}

		override public function update():void {
			// Start the game when you press space
			if (Ax.keys.pressed(AxKey.SPACE)) {
				Ax.pushState(new GameState);
			}

			super.update();
		}
	}
}
