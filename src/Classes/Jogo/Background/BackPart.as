package Classes.Jogo.Background 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Rosini
	 */

	public class BackPart extends MovieClip
	{
		//vetor de estrelas
		private var stars_arr:Array = new Array;
		//numero de particulas
		private const Num_star:uint = 300;
		
		public function BackPart()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			
			//iniciando classe e adicionando particulas
			for (var i:int = 0; i < Num_star; i++) 
			{
				var s:Stars = new Stars();
				
				stars_arr[i] = s;
				
				stars_arr[i].x = Math.random() * stage.stageWidth;
				stars_arr[i].y = Math.random() * stage.stageHeight;
				
				this.addChild(stars_arr[i]);
			}
			
		}
		
		private function destroy(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			for (var i:int = 0; i < Num_star; i++) 
			{
				removeChild(stars_arr[i]);
				stars_arr[i] = null;
			}
		}
		
		public function render():void
		{
			for (var i:int = 0; i < Num_star; i++) 
			{
				stars_arr[i].render();
			}
		}
	}
}