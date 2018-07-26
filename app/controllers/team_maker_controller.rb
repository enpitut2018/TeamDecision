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
    session[:Rname]=@room.Rname
    session[:Rchar]=@room.Rchar
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

  def input_Rchar
    @room = Join_room.new
  end

  def join
    #ユーザーテーブルにinsert
    @Pout = "" # brank
    room = Room.find_by(Rchar:params[:join_room][:Rchar])
    if room != nil then
      user = User.new(Rid:room[:id], name:params[:join_room][:name], email:params[:join_room][:email])
      user.save
      @Pout += "ユーザを登録しました Your id = #{user.id}, Rid=#{user.Rid}, Rname=#{room.Rname}"
    else
      @Pout+="入室コードが間違っています<br/><a href='join'>再入力</a>"#"URLパラメータが不正です。JOINにはRidの指定が必要で、これはURL”!URL!”に対して、”!URL!?Rid=xx”（XXはint）とすることで与えることができます。"
    end
    # render html: @Pout
  end

  def result
    make_team
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
    decide_num_of_members = false
    # 分けたいチームの数（分割数）/1チームあたりの人数
    teamNum = 3

    #チーム分け対象
    users = User.all

    if decide_num_of_members
      teamNum = users.length/teamNum
    end

    slice = users.length.to_f / teamNum
    for i in 0..(teamNum-1) do
      team = Team.create(Rid:1)
      index = slice*i
      users[index.to_i..(index+slice-1).to_i].each {|u|
        u.Tid = team.id
        u.save
      }
    end
  end


end
