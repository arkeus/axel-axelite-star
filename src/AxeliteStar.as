package {
	import net.axgl.star.state.TitleState;

	import org.axgl.Ax;

	[SWF(width = "400", height = "600", backgroundColor = "#000000")]

	public class AxeliteStar extends Ax {
		public function AxeliteStar() {
			// Game is 400x600 and we'll start in TitleState with a zoom of 1
			super(400, 600, new TitleState, 1);
			// Enable the debugger even in release mode
			Ax.debuggerEnabled = true;
		}
	}
}
