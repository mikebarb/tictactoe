App.game = App.cable.subscriptions.create "GameChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    
    # This IF statment caters for the received frame being recived before the connected frame
    # Most times, the first received frame has already been received thus starting the game
    # When this happens, we just want the game to continue without interference.
    #if typeof App.gamePlay == "undefined"
    #  $('#status').html("*** Waiting for another player ***")

  disconnected: ->
    # Called when the subscription has been terminated by the server
    if typeof App.gamePlay == "undefined"
      App.gamePlay = undefined
    #console.log("game :: disconnected")

  received: (data) ->
    #console.log("game :: received")
    #console.log(data)
    # Called when there's incoming data on the websocket for this channel
    switch data.action
      when "game_wait"
        #console.log("switch->game_wait: just called - updating html with waiting for player.")
        $('#status').html("*** Waiting for another player ***")

      when "game_start"
        #console.log("switch->game_start: just called - updating html with player found.")
        #elestatus = $('#status')
        $('#status').html("Player found")
        App.gamePlay = new Game('#game-container', data.msg)
        
      when "take_turn"
        #console.log("switch->take_turn: just called.")
        App.gamePlay.move data.move
        #App.gamePlay.getTurn()    # already called at end of move!!!

      when "new_game"
        #console.log("switch->new_game: just called.")
        App.gamePlay.newGame()

      when "opponent_withdraw"
        #console.log("switch->opponent_withdraw: just called.")
        $('#status').html("Opponent withdraw, You win!")
        $('#new-match').removeClass('hidden');

  take_turn: (move) ->
    #console.log("game.coffee take_turn called - move: " + move)
    @perform 'take_turn', data: move
    
  for_info: (info) ->
    @perform 'for_info', data: info

  new_game: () ->
    #console.log("game.coffee new_game called")
    @perform 'new_game'