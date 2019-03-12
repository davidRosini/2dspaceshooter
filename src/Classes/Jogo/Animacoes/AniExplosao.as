package Classes.Jogo.Animacoes 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class AniExplosao extends MovieClip
	{
		
		public function AniExplosao(tempini_arr:Array) 
		{
			
			this.init(tempini_arr);
			
		}
		
		private function init(tempini_arr:Array):void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				if (tempini_arr[i]._explodir)
				{
					
					this.x = tempini_arr[i].x + tempini_arr[i].width / 2;
					this.y = tempini_arr[i].y + tempini_arr[i].height / 2;
					
					tempini_arr[i]._explodir = false;
				}
			}
		}
	}

}