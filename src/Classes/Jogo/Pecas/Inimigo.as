package Classes.Jogo.Pecas 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class Inimigo extends MovieClip
	{
		private var speed:Number;
		private var nave:Nave;
		private var inimigo_bitmapdata:BitmapData;
		
		public var _move:Boolean = true;
		public var _explodir:Boolean = false;
		public var _atirei:Boolean = false;

		public function Inimigo(nave:Nave) 
		{
			this.nave = nave;
			
			this.addEventListener(Event.ADDED_TO_STAGE, iniciar);
		}
		
		private function iniciar(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, iniciar);
			
			//criando mapa para colisao pixel a pixel
			var inimigo_rect:Rectangle = this.getBounds(stage);
			
			this.inimigo_bitmapdata = new BitmapData(inimigo_rect.width, inimigo_rect.height, true, 0);
			
			this.inimigo_bitmapdata.draw(this);
			
			this.reposicao();
			
		}
		
		private function reposicao():void 
		{
			
			this.x =  Math.round(Math.random() * (stage.stageWidth - (this.width * 2))) + (this.width) ;
			this.y = -(Math.round(Math.random() *  32) + 16);
			this.speed =  Math.round(Math.random() * 4) + 2;
			
			this._atirei = false;
			
		}
		
		public function render():void
		{
			//inicia movimento do inimigo
			if (this._move)
			{
				//velocidade do inimigo
				this.y += this.speed;
				
				//testa se inimigo saio da tela ou acertou nave
				if (this.y > stage.stageHeight + 32)
				{
					
					this._move = false;
					
				}else if (inimigo_bitmapdata.hitTest(new Point(this.x, this.y), 255,
						            nave.nave_bitmapdata,new Point(nave.x, nave.y), 255 ))
					{
						this._move = false;
						this._explodir = true;
						this.dispatchEvent(new Event("aniexp"));
						this.dispatchEvent(new Event("tiravida"));
					}
				
			}else
			{
				this.reposicao();
				this._move = true;
			}
			
			if (this.y > stage.stageHeight - 120) { this._atirei = true; }
		}
	}
}