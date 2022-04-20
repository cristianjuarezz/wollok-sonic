import wollok.game.*

const velocidad = 10

object juego{

	method configurar(){
		game.width(12)
		game.title("- Sonic de la salada :D -")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(coin)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(score)
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.colisiona()})
	}
	
	method iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
	}
	
	method jugar(){
		if (dino.activo())
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
	}
	
	method terminar(){
		game.removeTickEvent("moverCactus")
		game.removeTickEvent("tiempo")
		score.Reset()
		game.addVisual(gameOver)
		dino.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object score {
	var score = 0
	var maxScore = 0
	method text() = "POINTS: "+score.toString()+"       HS: "+maxScore.toString()
	method position() = game.at(1, game.height()-1)
	
	method AddScore(a){
		score += a
		if(score > maxScore){
			maxScore = score
		}
		if(score%5==0){
			game.say(self, "EPIC!")
		}
	}
	method Reset(){
		score = 0
	}
}

object reloj {
	var tiempo = 0
	
	//method text() = "TICK: "+tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo + 1
		if(tiempo%30 == 0){
			
		}
	}
	method iniciar(){
		tiempo = 0
		game.onTick(velocidad,"tiempo",{self.pasarTiempo()})
	}
}

object coin {
	var position = self.initPos()
	
	method image() = "ring.png"
	method position() = position
	
	method colisiona(){
		score.AddScore(1)
		self.Reset()
	}
	method initPos(){
		return game.at(game.width()+[-1,0,1,2,3,4].anyOne(),3)
	}
	method Reset(){
		position = self.initPos()
	}
	method mover(){
		position = position.left(1)
		
		if (position.x() == -2){
			self.Reset()
		}
		if(position.x() == 2 and cactus.position().x() != 2){
			dino.saltar()
		}
	}
}

object cactus {
	const posicionInicial = game.at(game.width()-1,1)
	const imgs = ["1.png", "fire.png", "fire.png", "cactus.png"]
	const scripts = ["Veni gilasoo", "Te mataré", "Fuistee"]
	var position = posicionInicial
	var img = "1.png"

	method image() = img
	method position() = position
	method width() = 12
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method newImg(){
		img = imgs.anyOne()
	}
	
	method colisiona(){
		if(img != "fire.png"){
			juego.terminar()
		}
		else{
			score.Reset()
			game.say(dino, "Auch!")
		}
	}
	
	method mover(){
		position = position.left(1)
		coin.mover()
		dino.altSprite()
		if(position.x() == 2){
			dino.saltar()
		}
		if (position.x() == -2){
			self.newImg()
			position = posicionInicial
		}
		if(position.x() == 3){
			//game.say(self, scripts.anyOne())
		}
	}

}

object suelo{
	
	method position() = game.origin().up(1)
	method image() = "suelo.png"
}


object dino {
	var activo = true
	var position = game.at(1,1)
	var sprite = "walk1.jpg"
	
	method image() = sprite
	method position() = position
	
	method altSprite(){
		if(sprite == "w1.png"){
			sprite = "w2.png"
		}
		else{
			sprite = "w1.png"
		}
	}
	
	method position(nueva){
		position = nueva
	}
	
	method iniciar(){
		activo = true
	}
	method saltar(){
		//game.say(self, "ndeaaah")
		if(position.y() == 1) {
			self.subir()
			game.schedule(velocidad*1,{self.subir()})
			game.schedule(velocidad*3,{self.bajar()})
			game.schedule(velocidad*4,{self.bajar()})
		}
		
	}
	
	method subir(){
		position = position.up(1)
	}
	method bajar(){
		position = position.down(1)
	}
	method detener(){
		activo = false
	}
	method activo() = activo
}