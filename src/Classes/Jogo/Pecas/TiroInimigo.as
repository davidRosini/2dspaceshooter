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
	
	public class TiroInimigo extends MovieClip
	{
		
		private	var speed:Number; 
		private var nave:Nave;
		private var inimigo_arr:Array;
		private var initiro_bitmapdata:BitmapData;
		private var aux_indice:uint;
		
		public var _tiro:Boolean = false;
		public var _atirou:Boolean = true;
		
		public function TiroInimigo(nave:Nave,inimigo_arr:Array) 
		{
			this.nave = nave;
			this.inimigo_arr = inimigo_arr;
			
			this.addEventListener(Event.ADDED_TO_STAGE, iniciar);
		}
		
		private function iniciar(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, iniciar);
			
			var initiro_rect:Rectangle = this.getBounds(stage);
			
			this.initiro_bitmapdata = new BitmapData(initiro_rect.width, initiro_rect.height, true, 0);
			
			this.initiro_bitmapdata.draw(this);
						
			this.init();
		}
		
		private function init():void
		{
			this.x = stage.x - 1000;
			this.y = stage.y - 1000;
		}
		
		public function render():void 
		{
			if (this._atirou)
			{
				if (!this._tiro)
				{
			
					this.aux_indice = Math.round(Math.random() * 4);
	
					if (!this.inimigo_arr[aux_indice]._atirei)
					{
						
						this.inimigo_arr[aux_indice]._atirei = true;
						
						this.speed = Math.round(Math.random() * 5) + 7;
						
						this.x = (this.inimigo_arr[aux_indice].width / 2 - (this.width / 2)) + this.inimigo_arr[aux_indice].x;
						this.y = this.inimigo_arr[aux_indice].height + this.inimigo_arr[aux_indice].y;
						
						this._tiro = true;
						
					}
					
				}
				else
				{
					
					//velocidade do tiro
					this.y += this.speed; 
					
					//testes se tiro inimigo saio da tela ou acertou a nave
					if (this.y >= stage.stageHeight + (this.height * 2)) 
					{ 
						this.init();
						this._tiro = false;
						
						this.inimigo_arr[aux_indice]._atirei = false;
						
					}
					else if (this.initiro_bitmapdata.hitTest(new Point(this.x, this.y), 255,
						     this.nave.nave_bitmapdata,new Point(this.nave.x, this.nave.y), 255 ))
					{
						this.init();
						this.dispatchEvent(new Event("tiravida"));
						
						this._atirou = true;
						this._tiro = false;
						
						this.inimigo_arr[aux_indice]._atirei = false;
					}
				}
			}else 
			{
				//caso jogador perca vida o tiro ira para posicao inicial
				this.init();
			}
		
		}
	}
}