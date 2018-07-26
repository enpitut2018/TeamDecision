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
    redirect_to "/team_maker/room"
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
    @room.Rname = ""
  end

  def input_Rchar
    if session[:uid]!=nil && session[:u_rid]!=nil then
      join
      render :action => "join"
    else
      @room = Join_room.new
    end
  end

  def join
    
    puts params
    if session[:uid]!=nil && session[:u_rid]!=nil then
      user = User.find_by(id:session[:uid],Rid:session[:u_rid])
    else
      r = Room.find_by(Rchar:params[:join_room][:Rchar])
      if r != nil then 
        rid = r[:id]
      else
        #部屋コードが不正な場合ここに来る
      end
      user = User.new(Rid:rid, name:params[:join_room][:name], email:params[:join_room][:email])
      user.save
      session[:uid] = user.id;
      session[:u_rid] = user.Rid;
      
    end
  
    #ユーザーテーブルにinsert
    @Pout = "" # brank
    @Pout += "ユーザを登録しました。 Yourid=#{user.id}, ルームID=#{user.Rid}（ルームIDはデバッグ用であり、本来は表示するべきではない）"

    
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
    redirect_to "/team_maker/room"
  end

  def make_team
    # 分けたいチームの数（分割数）
    teamNum = 2
    for i in User.all.each_slice(User.all.length / teamNum) do
      team = Team.create(Rid:1)
      i.each {|u|
        u.Tid = team.id
        u.save
      }
    end
  end

  def divideIntoTeams
    make_team
    redirect_to "/team_maker/result"
  end


end
