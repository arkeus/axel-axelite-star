package net.axgl.star.entity.enemy {
	import net.axgl.star.entity.Enemy;
	import net.axgl.star.util.Registry;
	import net.axgl.star.util.Resource;
	
	import org.axgl.AxU;
	
	public class Meteor extends Enemy {
		public function Meteor() {
			super(0, -30, Resource.METEOR);
			
			// Simply move straight down, and do not fire
			velocity.y = AxU.rand(10, 30) + Registry.game.level * 6;
			life = 1 + Math.ceil(Registry.game.level);
		}
		
		override public function update():void {
			super.update();
		}
	}
}
