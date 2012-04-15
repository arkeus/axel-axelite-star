package {
	import net.axgl.star.state.TitleState;

	import org.axgl.Ax;

	[SWF(width = "400", height = "600", backgroundColor = "#000000")]

	public class AxeliteStar extends Ax {
		public function AxeliteStar() {
			super(TitleState);
		}
		
		override public function create():void {
			// Enable the debugger even in release mode
			Ax.debuggerEnabled = true;
		}
	}
}
