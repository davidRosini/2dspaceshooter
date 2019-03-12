package 
{
	import Classes.Jogo.TelaJogo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class Main extends MovieClip
	{
		private var jogo:TelaJogo; 
		
		public function Main():void 
		{
			
			jogo = new TelaJogo();
			 
			jogo.addEventListener("finalizar", finalizou);
			addChild(jogo);
			 
		}
		
		private function finalizou(e:Event):void 
		{
			
			jogo.removeEventListener("finalizar", finalizou);
			removeChild(jogo);
			jogo = null;
			
			jogo = new TelaJogo();
			
			jogo.addEventListener("finalizar", finalizou);
			addChild(jogo);
		}
	}	
}