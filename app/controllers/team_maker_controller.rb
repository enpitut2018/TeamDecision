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
    return "sample string"
  end

  def create_room
    @room = Room.new
    @room.Rname = "my_room"
  end

  def join
  end

  def result
  end

  def show_rooms
    @rooms = ''
    for r in Room.all do
      @rooms+='<tr><td>'
      @rooms+=r.Rname
      @rooms+='</td><td>'
      @rooms+=r.Rchar
      @rooms+='</td></tr>'
    end

  end

end
