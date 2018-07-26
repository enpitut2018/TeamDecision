class TeamMakerController < ApplicationController
  protect_from_forgery except: :newparam
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
    session[:rid]=@room.id
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
  def AddParams
    logger.debug("AddParamsの中に入りました")
  end

  def create_room
    @room = Room.new
    @room.Rname = "ルーム名"
  end

  def join
    #ユーザーテーブルにinsert
    @Pout = "" # brank
    @Rid = params[:Rid]
    if @Rid =~ /^[0-9]+$/ then
      # @Pout += "int"
      user = User.new(Rid:@Rid, name:"ABC", email:"test@test.com")
      user.save
      @Pout += "ユーザを登録しました Your id = #{user.id}, Rid=#{user.Rid}"
    else
      @Pout += "URLパラメータが不正です。JOINにはRidの指定が必要で、これはURL”!URL!”に対して、”!URL!?Rid=xx”（XXはint）とすることで与えることができます。"
    end
    # render html: @Pout
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

  def newparam
    @param = Paramater.new
    @param.Pname = params[:name]
    @param.format = params[:format]
    @param.Rid = session[:rid]
    if @param.save
      @result = true
    else
      @result = false
    end
  end

  def make_team
    teamNum = 4
    for i in users.each_slice(users.length / teamNum) do
      team = Team.create(Rid:1)
      i.each {|t|
        t.Tid = team.id
      }
    end
  end

  
end
