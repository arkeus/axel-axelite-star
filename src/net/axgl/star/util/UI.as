package net.axgl.star.util {
	import mx.utils.StringUtil;
	
	import org.axgl.Ax;
	import org.axgl.AxGroup;
	import org.axgl.text.AxText;

	public class UI extends AxGroup {
		/** Text object to display speed level */
		private var speed:AxText;
		/** Text object to display spread level */
		private var spread:AxText;
		/** Text object to display fire rate level */
		private var fire:AxText;

		public function UI() {
			// Add our 3 texts to this group
			this.add(speed = new AxText(0, Ax.height - 15, null, "SPEED @[255,255,0]II@[128,0,0]IIIIIIII", 133, "center"));
			this.add(spread = new AxText(133, Ax.height - 15, null, "SPREAD @[255,255,0]II@[128,0,0]III", 133, "center"));
			this.add(fire = new AxText(266, Ax.height - 15, null, "FIRE RATE @[255,255,0]II@[128,0,0]IIIIIIII", 133, "center"));
		}

		override public function update():void {
			// Update the texts with the correct level each frame
			speed.text = "SPEED @[255,255,0]" + StringUtil.repeat("I", Registry.player.speedLevel) + "@[128,0,0]" + StringUtil.repeat("I", 10 - Registry.player.speedLevel);
			spread.text = "SPREAD @[255,255,0]" + StringUtil.repeat("I", Registry.player.spreadLevel) + "@[128,0,0]" + StringUtil.repeat("I", 5 - Registry.player.spreadLevel);
			fire.text = "FIRE RATE @[255,255,0]" + StringUtil.repeat("I", Registry.player.fireLevel) + "@[128,0,0]" + StringUtil.repeat("I", 10 - Registry.player.fireLevel);
		}
	}
}
