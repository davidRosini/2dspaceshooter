package Classes.Jogo.Pecas 
{
	
	import Classes.Jogo.Som.EfeitosSX;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class Tiro extends MovieClip
	{
		private	var SPEED:Number =  18;
		private var nave:Nave;
		private var inimigo_arr:Array;
		private var score:Score;
		private var num_inimigo:uint;
		
		public var _tiro, _atirar:Boolean = false;
		
		public function Tiro(nave:Nave,inimigo_arr:Array,score:Score,num_inimigo:uint)
		{
			this.nave = nave;
			this.inimigo_arr = inimigo_arr;
			this.score = score;
			this.num_inimigo = num_inimigo;
			
			this.addEventListener(Event.ADDED_TO_STAGE, iniciar);
			
		}
		
		private function iniciar(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, iniciar);
			this.init();
		}
		
		private function init()
		{
			this.x = stage.stageWidth + 1000;
			this.y = stage.stageHeight + 1000;
		}
		
		public function render():void 
		{
			if (this._atirar)
			{
				if (!this._tiro)
				{
					//posicao inicial do tiro em nave
					this._tiro = true;
					this.x = (nave.width / 2 - (this.width / 2)) + nave.x;
					this.y = nave.y;
					
					//som do tiro
					EfeitosSX.somTiro();
				}
				else
				{
					//velocidade do tiro
					this.y -= SPEED; 
					
					//testes se tiro saio da tela ou acertou o inimigo
					if (this.y <= stage.y - (this.height * 2)) 
					{ 
						this.init();
						this._atirar = false;
						this._tiro = false;
						
					}else
					{ 
						for (var i:int = 0; i < num_inimigo ; i++) 
						{
							if (this.hitTestObject(inimigo_arr[i])) 
							{
								this.init();
								inimigo_arr[i]._move = false;
								inimigo_arr[i]._explodir = true;
								this._atirar = false;
								this._tiro = false;
								
								this.dispatchEvent(new Event("aniexp"));
								
								//tratamento de pontuacao
								var string_aux:String = new String("00000000");
								var string_aux2:String = new String();
								var aux:int = int(score.pontuacao.text);
								
								if (aux >= 99999500) 
								{ 
									aux = 0; 
								}
								
								string_aux2 = String(500 + aux);
								string_aux = string_aux.slice(0, (8 - string_aux2.length));
								
								score.pontuacao.text =  string_aux + string_aux2;
							}
						}
					}
				}
			}
			else
			{
				//caso jogador perca vida o tiro ira para posicao inicial
				this.init();
				this._tiro = false;
			}
		}
	}
}