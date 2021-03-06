class TeamMakerController < ApplicationController

  protect_from_forgery except: [:roomAdminJoin,:newparam]

  def home
  end

  def redirectToRoot
    redirect_to '/'
  end

  def make
    @room = Room.new
    @room.Rname = params[:room][:Rname]
    @room.Rchar = make_Rchar
    @room.RadminKey = make_RadminKey

    if @room.save
      @result = true
    else
      @result = false
    end
    session[:rid]=@room.id
    session[:Rname]=@room.Rname
    session[:Rchar]=@room.Rchar
    session[:RadminKey]=@room.RadminKey
    redirect_to "/team_maker/room"
  end

  def make_RadminKey
    def make_RadminKeySt
      return (0...13).map{ ('a'..'z').to_a[rand(26)] }.join;
    end
    tmp = make_RadminKeySt
    flg = Room.find_by(RadminKey:tmp)
    while flg!=nil do
      tmp = make_RadminKeySt
      flg = Room.find_by(RadminKey:tmp)
    end
    return tmp
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
    flg0 = true
    @Pout = ''
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
      require 'net/smtp'
      extend ActiveSupport::Concern
      @MY_DOMAIN = 'sv.teammaker.gv.vc'.freeze
      @PORT = 25 #SMTPサーバーのポート番号、通常は「25」を指定。一般的なインターネット回線では25番あては使えないため、検証環境に注意。
      def mail_check(addr)
        domain = addr.split('@').last
        return { email: addr, domain: false, message: 'domain does not found.' } unless get_exchange(domain)
        addrs_exist?(get_exchange(domain), addr)
      rescue # 送信先メールアドレスが存在しない場合、例外処理へ
        { email: addr, domain: false, result: "#{addr} does not exist." }
      end
      def get_exchange(domain)
        mx = Resolv::DNS.new.getresource(domain, Resolv::DNS::Resource::IN::MX)
        mx.exchange.to_s
      rescue
        nil
      end
      def addrs_exist?(domain, addr)
        Net::SMTP.start(domain, @PORT, @MY_DOMAIN) do |smtp|
          smtp.mailfrom("service@sv.teammaker.gv.vc")
          res = smtp.rcptto(addr).string.chomp
          { email: addr, domain: true, result: res }
        end
      end #メールアドレス検証関数ここまで
      @email = params[:join_room][:email]
      @JnRemote_ip = request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
      if @JnRemote_ip=="127.0.0.1" then
        @JnMCb = true
        @Pout += "【警告！】メールアドレスの検証はローカル環境では無効化されました<br />
        <br />
        "
      else
        @JnMCb = mail_check(@email)[:domain]
      end
      if @JnMCb then #メールアドレスを検証
        # メールアドレスが正しい場合
        r=Room.find_by(Rchar:params[:join_room][:Rchar])
        if r==nil then
          @Pout += "入室コードの検証に失敗しました。<br>
          正しい入室コードを入力しているか、今一度ご確認ください。"
          flg0 = false
        else
          rid = r[:id]
          #ユーザーテーブルにinsert
          user = User.new(Rid:rid, name:params[:join_room][:name], email:@email)
          user.save
          session[:uid] = user.id;
          session[:u_rid] = user.Rid;
          @Pout += "ルームに参加しました<br>\n<br>\n"
        end
        
      else
        @Pout += "メールアドレスの検証に失敗しました。<br>
        正しいメールアドレスを入力しているか、今一度ご確認ください。"
          flg0 = false
      end
    end
    if flg0 then
      @a2s = {
        2=>"そう思う",
        1=>"どちらかというとそう思う",
        0=>"どちらとも言えない",
        -1=>"あまり思わない",
        -2=>"そう思わない",
        -3=>"未回答"
      }
      par=Paramater.where(Rid: session[:u_rid])
      @Pout += '<table class="table table-hover" align="center">
      <tr>
          <th>質問</th>
          <th>回答の状況</th>
          <th>回答</th>
      </tr>
      '
      par.each {|par0|
        @tmp = Answer.find_by(Pid:par0[:id],Uid:session[:uid])
        if @tmp!=nil then
          out = "<font color='green'>回答済み</font>"
          out2 = @a2s[@tmp.answer]
        else
          out = "<font color='red'>未回答</font>"
          out2 = "ー"
        end
        @Pout += '<tr><td>'
        @Pout += "<a href='/team_maker/inputparam?pid="+par0[:id].to_s+"'>"
        @Pout += ERB::Util.html_escape(par0[:Pname].to_s)
        @Pout += "</a></td><td>"+out+"</td><td>"+out2.to_s+"</td></tr>"

      }
      @Pout += '</table>'
    end
    # 画面表示を生成

  end

  def result
    @a2s = {
      2=>"そう思う",
      1=>"どちらかというとそう思う",
      0=>"どちらとも言えない",
      -1=>"あまり思わない",
      -2=>"そう思わない",
      -3=>"未回答"
    }
    if session[:flg] then
      @id = session[:rid]
    else
      @id = session[:u_rid]
    end

    @paramaters = Paramater.where(Rid: @id).map{|p| {id:p[:id], Pname:p[:Pname]}}
  end
    
  def room
    if session[:rid]==nil then
      redirect_to "/team_maker/create_room"
    end
  end
    
  def show_rooms
    @rooms = []
    for r in Room.all do
      @rooms.append([r.Rname,r.Rchar])
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
    require 'make_team_solver'

    ans = Answer.where(Pid: Paramater.find_by(Rid:rid).id)
    teams = []
    teamNum.times {
      teams << Team.create(Rid:rid)
    }
    (MakeTeamSolver.new ans.map(&:answer), teamNum).solve.each_with_index {|i,j|
      u = User.find ans[j].Uid
      u.Tid = teams[i].id
      u.save
    }
  end

  def roomAdminJoin
    @RadminKeyFromHttpRequest = params[:RadminKey]
    @DBreturn=Room.find_by(RadminKey:@RadminKeyFromHttpRequest)
    if @DBreturn!=nil then
      session[:rid]=@DBreturn.id
      session[:RadminKey]=@DBreturn.RadminKey
      session[:Rname]=@DBreturn.Rname
      session[:Rchar]=@DBreturn.Rchar
    else
      # redirect_to "/team_maker/result"
    end
    redirect_to "/team_maker/room"
  end

  def divideIntoTeams
    if params[:teamNum].to_i<=User.where(Rid: session[:rid]).length && params[:teamNum].to_i>=0 then
      make_team params[:teamNum].to_i, session[:rid]
      session[:flg]=true
      redirect_to "/team_maker/result"
    else
      render html: "teamNumちゃんとやれ"
    end
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
