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
        
      else
        #部屋コードが不正な場合ここに来る
      end
      rid=Room.find_by(Rchar:params[:join_room][:Rchar])[:id]
      user = User.new(Rid:rid, name:params[:join_room][:name], email:params[:join_room][:email])
      user.save
      session[:uid] = user.id;
      session[:u_rid] = user.Rid;
      
    end
  
    #ユーザーテーブルにinsert
    @Pout = "" # brank
    #@Pout += "Yourid=#{user.id}, ルームID=#{user.Rid}（ルームIDはデバッグ用であり、本来は表示するべきではない）"
    par=Paramater.where(Rid: session[:u_rid])
    par.each {|par0|
      @Pout += "<a href='/team_maker/inputparam?pid="+par0[:id].to_s+"'>"
      @Pout += par0[:Pname].to_s
      @Pout += "</a><br>"
    }
   
    
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
    redirect_to "/team_maker/room"
  end


  #teamNum: 分けたいチームの数（分割数）
  #rid: ルームid
  def make_team(teamNum, rid)
    us = User.where(Rid: session[:rid])
    for i in us.each_slice((us.length + us.length.modulo(teamNum)) / teamNum) do
      team = Team.create(Rid:rid)
      i.each {|u|
        u.Tid = team.id
        u.save
      }
    end
  end

  def divideIntoTeams
    make_team params[:teamNum].to_i, session[:rid]
    redirect_to "/team_maker/result"
  end


  def InputParam
    
    @answer = Answer.new
    @param = params
    render("inputparam")
  end

  def SetParam
    if Answer.find_by(Pid:params[:answer][:pid],Uid:session[:uid])!=nil then 
      Answer.find_by(Pid:params[:answer][:pid],Uid:session[:uid]).delete
    end
    @answer = Answer.new
    @answer.answer = params[:answer][:answer]
    @answer.Pid = params[:answer][:pid]
    @answer.Uid = session[:uid]
    @answer.save
    redirect_to "/team_maker/join"
  end

end
