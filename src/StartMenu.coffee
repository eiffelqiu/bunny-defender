BunnyDefender.StartMenu = (game) ->
  @startBG = @startPrompt = @ding = null
  return

BunnyDefender.StartMenu:: =
  create: ->
    @ding = @add.audio('select_audio')
    @startBG = @add.image(0,0,'titlescreen')
    @startBG.inputEnabled = yes
    @startBG.events.onInputDown.addOnce(@startGame,@)
    @startPrompt = @add.bitmapText(@world.centerX-155, @world.centerY, 'eightbitwonder', 'Touch to Start!', 24)
    return
  startGame: (pointer) ->
    @ding.play()
    @state.start('Game');
    return