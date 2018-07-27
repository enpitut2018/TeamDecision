Rails.application.routes.draw do
  get 'team_maker/home' to:"team_maker#redirectToRoot"

  get 'team_maker/home' to:"team_maker#redirectToRoot"

  post 'team_maker/create_room', to:"team_maker#make"

  post 'team_maker/newparam', to:"team_maker#newparam"

  get 'team_maker/create_room'

  get 'team_maker/join', to:"team_maker#input_Rchar"

  post 'team_maker/inputparam', to:"team_maker#SetParam"

  get 'team_maker/inputparam', to:"team_maker#InputParam"

  post 'team_maker/join', to:"team_maker#join"

  get 'team_maker/result'

  root 'team_maker#home'

  get 'team_maker/AddParams',to:"team_maker#AddParams"

  get 'team_maker/show_rooms'

  get 'team_maker/room'

  post 'team_maker/divideIntoTeams', to:"team_maker#divideIntoTeams"

  post 'team_maker/roomAdminJoin', to:"team_maker#roomAdminJoin"

end
