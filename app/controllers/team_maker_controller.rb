class TeamMakerController < ApplicationController
  def home
  end

  def make
  end

  def join
    #ユーザーテーブルにinsert
    user = User.new(Rid:1, name:"ABC", email:"test@test.com")
    user.save
  end

  def result
  end
end
