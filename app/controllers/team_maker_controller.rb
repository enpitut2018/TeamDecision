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
    @Pout = ""
    p TCPSocket.gethostbyname("www.yahoo.co.jp")
    puts params
    if session[:uid]!=nil && session[:u_rid]!=nil then
      user = User.find_by(id:session[:uid],Rid:session[:u_rid])
    else
      r = Room.find_by(Rchar:params[:join_room][:Rchar])
      if r != nil then
      else
        #部屋コードが不正な場合ここに来る
      end
      
      # メールアドレスの存在可能性検証（処理の定義）
      require 'resolv'
      extend ActiveSupport::Concern
      @MY_DOMAIN = 'sv.teammaker.gv.vc'.freeze
      @TIMEOUT = 20
      def mail_check(addr)
        domain = addr.split('@')[1]
        return { exist: false, valid: true, message: 'SMTP Server Not Found' } unless get_exchange(domain)
        begin
          addrs_exist?(get_exchange(domain), addr)
        rescue
          return { exist: false, valid: true, message: "Unknown Error.(Maybe #{@addr} Does Not Exists.)" }
        end
      end
      def get_exchange(domain)
        begin
          @mx = Resolv::DNS.new.getresource(domain, Resolv::DNS::Resource::IN::MX)
        rescue
          return nil
        end
        @mx.exchange.to_s
      end
      def addrs_exist?(domain, addr)
        @MC_status = ''
        pop = Net::Telnet.new('Host' => domain, 'Port' => 25, 'Timeout' => @TIMEOUT, 'Prompt' => /^(2\d{2}|5\d{2})/)
        pop.cmd("helo #{@MY_DOMAIN}")
        pop.cmd("mail from:<#{mail_address}>")  #mail_addressには送信元のメールアドレスを入れる
        pop.cmd("rcpt to:<#{addr}>") { |c| @MC_status << c }
        pop.cmd('String' => 'quit')
        @MC_status =~ /^250/ ? true : false
      end

      @email = params[:join_room][:email]

      # メールアドレスの存在可能性検証（確認実行）
      mail_check( @email )

      # @Pout += @email
      if @MC_status then
        # メールアドレスが正しい場合
        rid=Room.find_by(Rchar:params[:join_room][:Rchar])[:id]
        #ユーザーテーブルにinsert
        user = User.new(Rid:rid, name:params[:join_room][:name], email:@email)
        user.save
        session[:uid] = user.id;
        session[:u_rid] = user.Rid;
        @Pout += "ルームに参加しました<br>\n<br>\n"
        #@Pout += "Yourid=#{user.id}, ルームID=#{user.Rid}（ルームIDはデバッグ用であり、本来は表示するべきではない）"
      else
        @Pout += "メールアドレスの検証に失敗しました。<br>
        正しいメールアドレスを入力しているか、今一度ご確認ください。"
      end
    end
    par=Paramater.where(Rid: session[:u_rid])
    par.each {|par0|
      @Pout += "<a href='/team_maker/inputparam?pid="+par0[:id].to_s+"'>"
      @Pout += par0[:Pname].to_s
      @Pout += "</a><br>"
    }
    # 画面表示を生成
    @Pout = "<p align='center'>" + @Pout
    @Pout += "</p>"
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
