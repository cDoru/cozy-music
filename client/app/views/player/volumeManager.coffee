BaseView = require '../../lib/base_view'

module.exports = class VolumeManager extends BaseView

    className: "volume"
    tagName: "div"
    template: require('../templates/player/volumeManager')

    events:
        "mousedown .slider": "onMouseDownSlider"
        "click .volume-switch": "onClickToggleMute"

    afterRender: ->
        @volumeValue = 50 # default value
        @isMuted = false
        @slidableZone = $(document) # slidableZone is the zone where the user can slide
        @volumeSwitch = @$(".volume-switch")
        @slider = @$(".slider")
        @sliderContainer = @$(".slider-container")
        @sliderFiller = @$(".slider-filler")
        @sliderFiller.width "#{@volumeValue}%"
        @sliderInfo = @$(".slider-info")

    onMouseDownSlider: (event) ->
        event.preventDefault()
        @setValue(event)
        @slidableZone.mousemove @onMouseMoveSlider
        @slidableZone.mouseup @onMouseUpSlider

    onMouseMoveSlider: (event) =>
        event.preventDefault()
        @setValue(event)

    onMouseUpSlider: (event) =>
        event.preventDefault()
        @slidableZone.off "mousemove"
        @slidableZone.off "mouseup"

    onClickToggleMute: (event) ->
        event.preventDefault()
        @toggleMute()

    setValue: (event) ->
        handlePositionPx = event.clientX - @sliderContainer.offset().left
        handlePositionPercent = handlePositionPx/@sliderContainer.width() * 100
        @volumeValue = handlePositionPercent.toFixed(0)
        @volumeValue = 100 if @volumeValue > 100
        if @volumeValue < 0
            @volumeValue = 0
            @toggleMute() unless @isMuted
        @toggleMute() if @volumeValue > 0 and @isMuted
        @updateDisplay()

    updateDisplay: ->
        newWidth = if @isMuted then 0 else @volumeValue
        @sliderInfo.html "done : #{newWidth}"
        @sliderFiller.width "#{newWidth}%"

    toggleMute: ->
        if @isMuted
            @volumeSwitch.removeClass "mute"
        else
            @volumeSwitch.addClass "mute"
        @isMuted = not @isMuted
        @updateDisplay()