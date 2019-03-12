package Classes.Jogo 
{
	
	//para testes
	import Classes.Jogo.net.hires.debug.*;
	
	import Classes.Jogo.Background.BackPart;
	import Classes.Jogo.Animacoes.AniExplosao;
	import Classes.Jogo.Pecas.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class TelaJogo extends MovieClip
	{
		
		private var background:BackPart;
		private var nave:Nave;
		private var tiro_arr:Array
		private var inimigo_arr:Array;
		private var tiroinimigo_arr:Array;
		private var explosao_arr:Array;
		
		private var _pause:Boolean;
		private var _pausegeral:Boolean = true;
		private var auxcount:uint = 0;
		private var auxanicount_i:int = 0;
		private var auxanicount_j:int = 0;
		private var vida:Vida;
		
		private const NUM_INIMIGO:uint = 5;
		private const NUM_TIRO:uint = 12;
		private const NUM_INITIRO:uint = 2;
		
		private var score:Score;
		private var vidas:uint = 4;
		
		public function TelaJogo() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			//instanciando efeito de particulas
			background = new BackPart();
			
			//instanciando elementos do jogo
			inimigo_arr = new Array;
			tiroinimigo_arr = new Array;
			tiro_arr = new Array;
			explosao_arr = new Array;
			nave = new Nave(); 
			
			score = new Score();
			vida = new Vida();
			
			//ajustando objetos 
			score.pontuacao.text = "00000000"
			score.pontuacao.x = (stage.stageWidth / 2) - 60;
			score.pontuacao.y = stage.y + 10;
			
			vida.x = stage.x + 10;
			vida.y = stage.stageHeight - 50;
			vida.gotoAndStop(this.vidas);
			
			//adicionando no palco
			this.addChild(background);
			this.addChild(nave);
			
			for (var i:int = 0; i < NUM_INIMIGO; i++) 
			{
					
				var inimigo:Inimigo = new Inimigo(nave);
				inimigo_arr[i] = inimigo;
				
				inimigo_arr[i].addEventListener("tiravida", tiravida);
				inimigo_arr[i].addEventListener("aniexp", explodir);
				
				this.addChild(inimigo_arr[i]);
			}
			
			for (var j:int = 0; j < NUM_TIRO; j++) 
			{
				
				var tiro:Tiro =  new Tiro(nave, inimigo_arr, score,NUM_INIMIGO);
				tiro_arr[j] = tiro;
				
				tiro_arr[j].addEventListener("aniexp", explodir);
				
				this.addChild(tiro_arr[j]);
			}	
			
			for (var k:int = 0; k < NUM_INITIRO; k++) 
			{
				
				var tiroinimigo:TiroInimigo = new TiroInimigo(nave,inimigo_arr);
				tiroinimigo_arr[k] = tiroinimigo;
				
				tiroinimigo_arr[k].addEventListener("tiravida", tiravida);
				
				this.addChild(tiroinimigo_arr[k]);
			}
				
			this.addChild(vida);
			this.addChild(score.pontuacao);
			
			//para testes
			this.addChild(new Stats());
			
			//eventos da nave
			nave.addEventListener("atirou", atirar);
			nave.addEventListener("restart", recomecar);
			nave.addEventListener("pause", pausar);
			nave.addEventListener("unpause", unpause);
			
			//evento para renderizar jogo
			this.addEventListener(Event.ENTER_FRAME, render);
			
			this.addEventListener(MouseEvent.CLICK, evtMouse );
			
			this._pause = true;
		
		}
		
		public function setpausegeral(value:Boolean):void 
		{
			_pausegeral = value;
		}
		
		public function getscore():String 
		{
			return score.pontuacao.text;
		}
		
		public function getvidas():uint 
		{
			return vidas;
		}
		
		private function destroy(e:Event):void 
		{
			
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			this.limparSujeira();
			
		}
		
		private function explodir(e:Event):void 
		{
			var explosao:AniExplosao = new AniExplosao(inimigo_arr);
			
			explosao_arr[auxanicount_i] = explosao;
			
			this.addChild(explosao_arr[auxanicount_i]);
			
			auxanicount_i++;
			
			if (auxanicount_i > 4 ) { auxanicount_i = 0; }
		}
		
		private function atirar(e:Event):void 
		{
			
			tiro_arr[auxcount]._atirar = true;
			
			auxcount++;
			
			if (auxcount > (NUM_TIRO - 1))
			{
				auxcount = 0;
			}
		
		}
		
		private function pausar(e:Event):void 
		{
			
			_pause = true;
			
		}
		
		private function unpause(e:Event):void 
		{
			
			_pause = false;
			
		}
		
		private function evtMouse(e:MouseEvent):void 
		{
				switch (e.type)
				{
					case MouseEvent.CLICK:
						if (!_pause)
						{
							if (!nave._nrestart)
							{
								this.recomecar(null);
							}else
							{
								nave._mouseOut = true;
								this.atirar(null);
							}
						}else
						{
							 this.unpause(null);
						}
						break;
				}
		}
		
		//funcao para iniciar jogo se jogador perdeu vida
		private function tiravida(e:Event):void 
		{
			
			nave._nrestart = false;
			
			//retirando vida do contador e movendo animacao
			nave.init();
			this.vidas -= 1;
			vida.gotoAndStop(this.vidas);
			
			for (var i:int = 0; i < NUM_TIRO; i++) 
			{
				
				tiro_arr[i]._atirar = false;
				
				if ( i < NUM_INITIRO )
				{
					tiroinimigo_arr[i]._tiro = false;
					tiroinimigo_arr[i]._atirou = false;
				}
				
				if ( i < NUM_INIMIGO )
				{
					inimigo_arr[i]._move = false;
				}
			}
			
			if (this.vidas > 0)
			{
				this.render(null);
			}
			
			this._pause = true;
			
		}
		
		//funcao para recomecar quando jogador clicar na tela ou apertar espaco
		private function recomecar(e:Event):void 
		{
			
			_pause = false;
			nave._nrestart = true;
			
			for (var i:int = 0; i < NUM_INIMIGO; i++) 
			{
				inimigo_arr[i].removeEventListener("tiravida", tiravida);
				inimigo_arr[i].addEventListener("tiravida", tiravida);
				
				if ( i < NUM_INITIRO )
				{
					tiroinimigo_arr[i].removeEventListener("tiravida", tiravida);
					tiroinimigo_arr[i].addEventListener("tiravida", tiravida);
					tiroinimigo_arr[i]._atirou = true;
				}
			}
		}

		private function render(e:Event):void
		{
			if (_pausegeral)
			{
				//limpando explosoes
				if (explosao_arr[auxanicount_j])
				{
					if (explosao_arr[auxanicount_j].currentFrame == 11)
					{
						
						this.removeChild(explosao_arr[auxanicount_j]);
						explosao_arr[auxanicount_j] = null;
						
						auxanicount_j++;
						if (auxanicount_j > 4) { auxanicount_j = 0; }
					}
				}
				
				if (this.vidas > 0)
				{
					if (!_pause)
					{
						
						background.render();
						
						nave.render();
						
						for (var i:int = 0; i < NUM_TIRO; i++) 
						{
							
							tiro_arr[i].render();
							
							if ( i < NUM_INITIRO )
							{
								tiroinimigo_arr[i].render();
							}
							
							if ( i < NUM_INIMIGO )
							{
								inimigo_arr[i].render();
							}
						}	
					}
				}else 
				{ 
					this.dispatchEvent(new Event("finalizar"));
				}
			}
		}
		
		private function limparSujeira():void
		{
			
			//game over retirando objetos para recomecar jogo
			this.removeChild(background);
			this.removeChild(vida);
			this.removeChild(score.pontuacao);
			this.removeChild(nave);
			
			this.removeEventListener(Event.ENTER_FRAME, render);
			
			stage.removeEventListener(MouseEvent.CLICK, evtMouse );
			
			nave.removeEventListener("atirou", atirar);
			nave.removeEventListener("restart", recomecar);
			nave.removeEventListener("pause", pausar);
			nave.removeEventListener("unpause", unpause);
			
			for (var i:int = 0; i < NUM_TIRO; i++) 
			{
				tiro_arr[i].removeEventListener("aniexp", explodir);
				this.removeChild(tiro_arr[i]);
				tiro_arr[i] = null;
				
				if ( i < NUM_INITIRO )
				{
					tiroinimigo_arr[i].removeEventListener("tiravida", tiravida);
					this.removeChild(tiroinimigo_arr[i]);
					tiroinimigo_arr[i] = null;
				}	
				
				if ( i < NUM_INIMIGO )
				{
					inimigo_arr[i].removeEventListener("tiravida", tiravida);
					inimigo_arr[i].removeEventListener("aniexp", explodir);
					this.removeChild(inimigo_arr[i]);
					inimigo_arr[i] = null;
				}
			}
			
			background = null;
			vida = null;
			score = null;
			nave = null; 
			inimigo_arr = null;
			tiroinimigo_arr = null;
			tiro_arr =  null;

		}
	}	
}
