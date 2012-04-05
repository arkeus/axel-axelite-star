package net.axgl.star.util {
	import net.axgl.star.entity.Player;
	import net.axgl.star.state.GameState;

	/**
	 * A very simple registry to get the game state and player, without having to constantly
	 * cast the state.
	 */
	public class Registry {
		public static var game:GameState;
		public static var player:Player;
	}
}
