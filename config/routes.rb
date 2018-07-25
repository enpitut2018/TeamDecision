Rails.application.routes.draw do
  get 'team_maker/home'

  get 'team_maker/make'

  get 'team_maker/join'

  get 'team_maker/result'

  root 'team_maker#home'
end
