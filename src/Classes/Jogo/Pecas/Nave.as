package Classes.Jogo.Pecas 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class Nave extends MovieClip
	{
		private const SPEED:Number = 9;
		private var _rmove, _lmove, _umove, _dmove:Boolean = false;
		
		public  var _mouseOut:Boolean = false;
		public  var _npause, _nrestart:Boolean = false;
		public  var nave_bitmapdata:BitmapData;
		
		public function Nave() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, iniciar);
			
			//criando mapa para colisao pixel a pixel
			var nave_rect:Rectangle = this.getBounds(stage);
			
			this.nave_bitmapdata = new BitmapData(nave_rect.width, nave_rect.height, true, 0);
			
			this.nave_bitmapdata.draw(this);
			
		}
		
		private function iniciar(e:Event):void 
		{
			this.init();
			
			this.removeEventListener(Event.ADDED_TO_STAGE, iniciar);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			//eventos de teclado
			stage.addEventListener(KeyboardEvent.KEY_DOWN, evtKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, evtKeyUP);
		}
		
		private function removed(e:Event):void 
		{
			
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removed);
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, evtKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, evtKeyUP);
			
		}
		
		public function init():void
		{
			this.x = (stage.stageWidth / 2) - (this.width / 2) ;
			this.y = stage.stageHeight - 80;
		}
		
		private function evtKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				//abilitando teclado e desabilitando movimento de pelo mouse
				case Keyboard.LEFT:
					this._lmove = true;
					this._mouseOut = false;
					break;
				
				case Keyboard.RIGHT:
					this._rmove = true;
					this._mouseOut = false;
					break;
				
				case Keyboard.UP:
					this._umove = true;
					this._mouseOut = false;
					break;
				
				case Keyboard.DOWN:
					this._dmove = true;
					this._mouseOut = false;
					break;
				
				//tiro
				case Keyboard.SPACE:	
					if (!this._nrestart) 
					{
						this.dispatchEvent(new Event("restart"));
					}else
					{
						this.dispatchEvent(new Event("atirou"));
					}
				    break;
					
				//pause	
				case Keyboard.CONTROL:
					if (this._npause)
					{
						this._npause = false;
						this.dispatchEvent(new Event("pause"));
					}else 
					{
						this._npause = true;
						this.dispatchEvent(new Event("unpause"));
					}
					break;
			}
		}
			
		private function evtKeyUP(e:KeyboardEvent):void
		{
			//parada do movimento
			switch(e.keyCode)
			{
				case Keyboard.LEFT:
					this._lmove = false;
					break;
				
				case Keyboard.RIGHT:
					this._rmove = false;
					break;
				
				case Keyboard.UP:
					this._umove = false;
					break;
				
				case Keyboard.DOWN:
					this._dmove = false;
					break;
			}
		}
		
		
		public function render():void
		{
			
			//teste para nave nao sair da tela 
			if (this.x < stage.x)
			{
				this.x = 0;
				
			}else if (this.x  > stage.stageWidth - this.width)
			{
				this.x = stage.stageWidth - this.width;
			}
			
			if (this.y < stage.y)
			{
				this.y = 0;
				
			}else if (this.y  > stage.stageHeight - this.height)
			{
				this.y = stage.stageHeight - this.height;
			}
			
			//movimento via teclado para esquerda e direita
			if (_lmove) 
			{
				this.x -= this.SPEED;
				
			}else if (_rmove)	
			{
				this.x += this.SPEED;
			}
			
			if (_umove)
			{
				this.y -= this.SPEED;
				
			}else if (_dmove)
			{
				this.y += this.SPEED;
			}
			
			if (_mouseOut)
			{
				//movimento via mouse
				this.x += ((parent.mouseX - (this.width / 2)) - this.x) * 0.14;
				this.y += ((parent.mouseY - (this.height / 2)) - this.y) * 0.14;
			}
		}	
	}
}