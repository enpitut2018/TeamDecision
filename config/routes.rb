Rails.application.routes.draw do
  get 'team_maker/home'

  post 'team_maker/create_room', to:"team_maker#make"

  post 'team_maker/newparam', to:"team_maker#newparam"

  get 'team_maker/create_room'

  get 'team_maker/join', to:"team_maker#join"

  get 'team_maker/result'

  root 'team_maker#home'

  get 'team_maker/AddParams',to:"team_maker#AddParams"

  get 'team_maker/show_rooms'


end
