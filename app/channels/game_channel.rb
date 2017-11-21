class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
    Match.create(uuid)
    sleep 1.0
  end

  def unsubscribed
    Game.withdraw(uuid)
    Match.remove(uuid)
  end

  def take_turn(data)
    Game.take_turn(uuid, data)
  end
  
  def for_info(data)
    logger.debug("for_info: " + uuid + "->" + data.inspect)
  end

  def new_game()
    Game.new_game(uuid)
  end
end
