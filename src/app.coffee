game = new  Phaser.Game(540, 960, Phaser.AUTO,'gameContainer')
game.state.add('Boot', BunnyDefender.Boot);
game.state.add('Preloader', BunnyDefender.Preloader);
game.state.add('StartMenu', BunnyDefender.StartMenu);
game.state.add('Game',BunnyDefender.Game);
game.state.start('Boot');