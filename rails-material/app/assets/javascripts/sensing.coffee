# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require moment
#= require paper
#= require jquery-ui/core
#= require jquery-ui/widget
#= require jquery-ui/position
#= require jquery-ui/widgets/mouse
#= require jquery-ui/widgets/draggable
#= require jquery-ui/widgets/resizable
#= require viz
#= require arr-stat
#= require ui_manager
#= require plot_manager
#= require profile
#= require ontology



		
Object.defineProperty HTMLMediaElement.prototype, 'playing', get: ->
  ! !(@currentTime > 0 and !@paused and !@ended and @readyState > 2)

window.cues = null



window.handlers = (callback)->
	SPACE_BAR = " "
	$("body").keypress (e)->
		if e.key == SPACE_BAR #
			_.each $('video'), (v)-> 
				if v.playing then v.pause() else v.play()
			e.preventDefault()

	$('.plottitle').click ()->
		$(this).toggleClass('timeupdate')
	

	$('video').on 'timeupdate', (e)->
		if _.isNaN(this.duration) then return
		event = jQuery.Event("scrubupdate")
		event.p = this.currentTime / this.duration
		$('.timeupdate').siblings(".paper-plot").trigger(event)
		# $(".paper-plot").trigger(event)

	$("video").on "loadstart", ()->
		video = $(this)
		stage = $(this).parent()
		segment = $(this).parents(".segment")
		aspectRatio = parseFloat(segment.find('.aspect').attr('name'))
		video.height(video.width()/aspectRatio)
		h = video.height()
		w = video.width()
		stage.height(h)
		segment.height((w+30)/aspectRatio)
	.on 'play', ()->
		$('.tplay').trigger('play')
	.on 'pause', ()->
		$('.tplay').trigger('play')
		
	$('track').on "load", (e)->
		track = this.track
		track.mode = 'hidden'
		window.cues = _.map track.cues, (cue)->
			if !cue.data
				cue.data = JSON.parse(cue.text)
				cue.text = cue.data.code
			return cue.data
		callback()

	$('#codebook-select').on 'change', (e)->
		$('track').attr('src', $(this).val().replaceAll('111', activeUser))
		$(this).parents(".segment").find('.paper-plot').trigger('load')

	$(".video-display select").on 'change', (e)->
			container = $(this).parents(".segment")
			container.find("video").attr('src', this.value)
			aspect = container.find(".aspect").attr('name')

	$("#notes-display select").on 'change', (e)->
		$.get this.value, (data)->
			lines = data.split('\n')
			markdown = _.map lines, (l)->
				l = l.trim()
				prefix = l.slice(0, 3)
				if l.slice(0, 3) == "###"
					l = "<h3>"+l.slice(4)+"</h3>"
				else if l.slice(0, 2) == "##"
					l = "<h2>"+l.slice(3)+"</h2>"
				else if l.slice(0, 1) == "#"
					l = "<h1>"+l.slice(1)+"</h1>"
				else
					l = "<p>"+l+"</p>"
				
				return l
			$("#notes").html(markdown.join('\n'))
















	






# trackConfig = ()->
	# textTrack.oncuechange = ->
	# 	myCues = @activeCues
	# 	_.each myCues, (cue) ->
	# 		$('#captions').html(cue.data.code).css 'background', cue.data.color
	# 		return
	# 	return

	# a = undefined
	# a = JSON.parse($('#data').attr('data'))
	# $('.qual').remove()
	# _.each a, (item, i) ->
	# 	start = item[0]
	# 	end = item[1]
	# 	play_button = $('<button>').addClass('qual').html(i + ' Segment').attr(
	# 		start: start
	# 		end: end).click((e) ->
	# 		`var e`
	# 		s = parseFloat($(this).attr('start'))
	# 		e = parseFloat($(this).attr('end'))
	# 		vid = $('video')[0]
	# 		console.log 'Setting time to ', s
	# 		vid.currentTime = s
	# 		vid.play()
	# 		return
	# 	)
	# 	$('video').parent().append play_button
	# 	console.log()
	# 	return

