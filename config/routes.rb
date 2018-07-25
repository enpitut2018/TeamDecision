Rails.application.routes.draw do
  get 'team_maker/home'

  post 'team_maker/create_room', to:"team_maker#make"

  get 'team_maker/create_room'

  get 'team_maker/join'

  get 'team_maker/result'

  get 'team_maker/show_rooms'

  root 'application#hello'
end
