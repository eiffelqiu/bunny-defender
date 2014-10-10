BunnyDefender.Preloader = (game) ->
  @preloadBar =  @titleText = null; @ready = no; return

BunnyDefender.Preloader:: =
  preload: ->
    @preloadBar = @add.sprite(@world.centerX, @world.centerY, 'preloaderBar')
    @preloadBar.anchor.setTo(0.5,0.5)
    @load.setPreloadSprite(@preloadBar)
    @titleText = @add.image(@world.centerX,@world.centerY-220, 'titleimage')
    @titleText.anchor.setTo(0.5,0.5)
    @load.image('titlescreen', 'images/TitleBG.png')
    @load.bitmapFont('eightbitwonder', 'fonts/eightbitwonder.png', 'fonts/eightbitwonder.fnt')
    @load.image('sky', 'images/sky.png')
    @load.image('hill', 'images/hill.png')
    @load.atlasXML('bunny','images/spritesheets/bunny.png','images/spritesheets/bunny.xml')
    @load.atlasXML('spacerock','images/spritesheets/SpaceRock.png','images/spritesheets/SpaceRock.xml')
    @load.image('explosion','images/explosion.png')
    @load.image('ghost', 'images/ghost.png')
    @load.audio('explosion_audio','audio/explosion.mp3')
    @load.audio('hurt_audio','audio/hurt.mp3')
    @load.audio('select_audio','audio/select.mp3')
    @load.audio('game_audio','audio/bgm.mp3')
    return

  create: ->
    @preloadBar.cropEnabled = no; return

  update: ->
    if @cache.isSoundDecoded('game_audio') and not @ready
      @ready = yes;
      @state.start('StartMenu')
    return
