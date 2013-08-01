BaseView = require '../lib/base_view'
Uploader = require './uploader'
TrackList = require './tracklist'
Player = require './player/player'
app = require 'application'

module.exports = class AppView extends BaseView

    el: 'body.application'
    template: require('./templates/home')

    player: null

    afterRender: ->
        # header used as uploader
        @uploader = new Uploader
        @$('#uploader').append @uploader.$el
        @uploader.render()

        # list of all tracks available
        @trackList = new TrackList
            collection: app.tracks
        @$('#tracks-display').append @trackList.$el
        @trackList.render()

        # soundManager is ready to be called here (cf. application.coffee)
        @player = new Player()
        @$('#player').append @player.$el
        @player.render()

