package Classes.Jogo.Background 
{
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author David Rosini
	 */

	public class Stars extends MovieClip
	{
		private var profundidade:Number;
		private var speed:Number;
		
		public function Stars()
		{
			//inicia particula
			this.init();
		}

		private function init():void
		{
			//sorteia distancia, velocidade e alpha da particula
			this.profundidade = Math.random() * 1;
			this.speed = Math.random() * 7;
			this.alpha = this.profundidade + 0.3; 

			//desenha na tela a particula
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawCircle(0, 0, this.profundidade);
		}
		
		public function render():void
		{
			//velocidade da particula
			this.y += (2 + this.speed);
			
			//caso saia da tela particula e recolocada e reiniciada
			if (this.y > stage.stageHeight + 10)
			{
				this.y = stage.y - 10;
				this.init();
			}
		}		
	}
}