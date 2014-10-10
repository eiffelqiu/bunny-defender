BunnyDefender = {}

BunnyDefender.Boot = (game) ->

BunnyDefender.Boot:: =
  preload: ->
    @load.image('preloaderBar', 'images/loader_bar.png')
    @load.image('titleimage', 'images/TitleImage.png')
    return

  create: ->
    @input.maxPointers = 1
    @stage.disableVisibilityChange = no
    @scale.scaleMode = Phaser.ScaleManager.SHOW_ALL
    @scale.minWidth = 270
    @scale.minHeight = 480
    @scale.pageAlignHorizontally = yes
    @scale.pageAlignVertically = yes
    @stage.forcePortrait = yes
    @scale.setScreenSize(yes)

    @input.addPointer()
    @stage.backgroundColor = '#171642'
    @state.start('Preloader')

    return

