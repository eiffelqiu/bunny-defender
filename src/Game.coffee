BunnyDefender.Game = (game) ->
  @totalBunnies = null; @bunnyGroup = null; @totalSpacerocks = null; @spacerockgroup = null;
  @burst = null; @gameover = null; @countdown = null
  @overmessage = null; @secondsElapsed = null; @timer = null;
  @music = null; @ouch = null; @boom = null; @ding = null
  return

BunnyDefender.Game:: =
  create: ->
    @gameover = no
    @secondsElapsed = 0
    @timer = @time.create(false)
    @timer.loop(1000,@updateSeconds, this)
    @totalBunnies = 20
    @totalSpacerocks = 13

    @music = @add.audio('game_audio')
    @music.play('',0,0.3,true)
    @ouch = @add.audio('hurt_audio')
    @boom = @add.audio('explosion_audio')
    @ding = @add.audio('select_audio')
    @buildWorld(); return

  updateSeconds: -> @secondsElapsed++

  buildWorld: ->
    @add.image(0,0,'sky')
    @add.image(0,800,'hill')
    @buildBunnies()
    @buildSpaceRocks()
    @buildEmitter()
    @countdown = @add.bitmapText(10,10,'eightbitwonder',"Bunnies Left #{@totalBunnies}",20)
    @timer.start()
    return

  buildEmitter: ->
    @burst = @add.emitter(0,0,80)
    @burst.minParticleScale = 0.3
    @burst.maxParticleScale = 1.2
    @burst.minParticleSpeed.setTo(-30,30)
    @burst.maxParticleSpeed.setTo(30,-30)
    @burst.makeParticles('explosion')
    @input.onDown.add(@fireBurst, this)
    return

  fireBurst: (p) ->
    unless @gameover
      @boom.play()
      @boom.volume = 0.2
      @burst.emitX = p.x
      @burst.emitY = p.y
      @burst.start(true,2000,null,20)
    return

  buildBunnies: ->
    @bunnyGroup = @add.group()
    @bunnyGroup.enableBody = yes
    for o in [0...@totalBunnies]
      b = @bunnyGroup.create(@rnd.integerInRange(-10,@world.width-50),@rnd.integerInRange(@world.height-180,@world.height-60),'bunny','Bunny0000')
      b.anchor.setTo(0.5,0.5)
      b.body.moves = no
      b.animations.add('Rest',@game.math.numberArray(1,58))
      b.animations.add('Walk',@game.math.numberArray(68,107))
      b.animations.play('Rest',24,true)
      @assignBunnyMovement(b)
    return

  assignBunnyMovement: (b) ->
    bposition = Math.floor(@rnd.realInRange(50,@world.width-50))
    bdelay = @rnd.integerInRange(2000, 6000)
    if bposition < b.x then b.scale.x = 1 else b.scale.x = -1
    t = @add.tween(b).to({x: bposition}, 3500, Phaser.Easing.Quadratic.InOut,true,bdelay)
    t.onStart.add(@startBunny, this)
    t.onComplete.add(@stopBunny, this)
    return

  startBunny: (b) ->
    b.animations.stop('Rest')
    b.animations.play('Walk',24, true)
    return

  stopBunny: (b) ->
    b.animations.stop('Walk')
    b.animations.play('Rest',24, true)
    @assignBunnyMovement(b)
    return

  buildSpaceRocks: ->
    @spacerockgroup = @add.group()
    for o in [0...@totalSpacerocks]
      r = @spacerockgroup.create(@rnd.integerInRange(0,@world.width),@rnd.realInRange(-1500,0),'spacerock','SpaceRock0000')
      scale = @rnd.realInRange(0.3,1.0)
      r.scale.x = scale; r.scale.y = scale
      @physics.enable(r, Phaser.Physics.ARCADE)
      r.enableBody = yes
      r.body.velocity.y = @rnd.realInRange(200,400)
      r.animations.add('Fall')
      r.animations.play('Fall',24,true)
      r.checkWorldBounds = yes
      r.events.onOutOfBounds.add(@resetRock, this)
    return

  resetRock: (r) ->
    if r.y > @world.height then @respawnRock(r)

  respawnRock: (r) ->
    unless @gameover
      r.reset(@rnd.integerInRange(0,@world.width),@rnd.realInRange(-1500,0))
      r.body.velocity.y = @rnd.realInRange(200,400)

  burstCollision: (r,b) ->
    @respawnRock(r)

  bunnyCollision: (r,b) ->
    if b.exists
      @ouch.play()
      @resetRock(r)
      @makeGhost(b)
      b.kill()
      @totalBunnies--
      @checkBunniesLeft()
    return

  checkBunniesLeft: ->
    if @totalBunnies <= 0
      @music.stop()
      console.log ""
      @gameover = yes
      @countdown.setText("Bunnies Left 0")
      @overmessage = @add.bitmapText(@world.centerX-180, @world.centerY-40, 'eightbitwonder', "Game Over\n\n #{@secondsElapsed}", 42)
      @overmessage.align = 'center'
      @overmessage.inputEnabled = yes
      @overmessage.events.onInputDown.addOnce(@quitGame,this)
    else
      @countdown.setText("Bunnies Left #{@totalBunnies}")
    return

  quitGame: -> @ding.play(); @state.start('StartMenu'); return

  friendlyFire: (b,e) ->
    if b.exists
      @ouch.play()
      b.kill()
      @makeGhost(b)
      @totalBunnies--
      @checkBunniesLeft()
    return

  makeGhost: (b) ->
    bunnyGhost = @add.sprite(b.x-20,b.y-180,'ghost')
    bunnyGhost.anchor.setTo(0.5,0.5)
    bunnyGhost.scale.x = b.scale.x
    @physics.enable(bunnyGhost,Phaser.Physics.ARCADE)
    bunnyGhost.enableBody = yes
    bunnyGhost.checkWorldBounds = yes
    bunnyGhost.body.velocity.y = -800
    return


  update: ->
    @physics.arcade.overlap(@spacerockgroup,@burst,@burstCollision, null, this)
    @physics.arcade.overlap(@spacerockgroup,@bunnyGroup,@bunnyCollision, null, this)
    @physics.arcade.overlap(@bunnyGroup,@burst,@friendlyFire, null, this)