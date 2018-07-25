class TeamMakerController < ApplicationController
  def home
  end

  def make
    @room = Room.new
    @room.Rname = params[:room][:Rname]
    @room.Rchar = make_Rchar
    if @room.save
      @result = true
    else
      @result = false
    end

  end

  def make_Rchar
    tmp = (0...8).map{ ('A'..'Z').to_a[rand(26)] }.join;
    flg = Room.find_by(Rchar:tmp)
    while flg!=nil do
      tmp = (0...8).map{ ('A'..'Z').to_a[rand(26)] }.join
      flg = Room.find_by(Rchar:tmp)
    end
    return tmp
  end

  def create_room
    @room = Room.new
    @room.Rname = "my_room"
  end

  def join
  end

  def result
  end
end
