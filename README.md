Bunny-Defender
==============

'Bunny Defender' game written with Coffee Script + Phaser framework(phaser.io)

This game was based on Lynda.com's tutorial (http://www.lynda.com/Phaser-tutorials/HTML5-Game-Development-Phaser/163641-2.html), but it was rewritten with coffee script and add Cakefile with minification build process for mobile app.

![Screen Shot](screenshot.png "Screen Shot")

## Prerequisite

    install nodejs/npm from http://www.nodejs.org/

    $ npm install -g coffee-script  # install coffee-script

## Development

    $ coffee --bare -o js/ -cw src/

## Deployment

    $ cake                      # list task
    $ cake bam                  # build and minify

## Run

    $ open index.html           # open index.html with Safari, it seemed Google Chrome has some issues to run.