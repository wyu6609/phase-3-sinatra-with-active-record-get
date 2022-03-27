class ApplicationController < Sinatra::Base
  # Add this line to set the Content-Type header for all responses
  set :default_content_type, 'application/json'
  get '/' do
    { message: 'Hello world' }.to_json
  end

  get '/games' do
    #get all the games from the database
    games = Game.all.order(:title).limit(10)

    # return a JSON response with an array of all the game data
    games.to_json
  end

  # use the :id syntax to create a dynamic route
  get '/games/:id' do
    # look up the game in the database using its ID
    game = Game.find(params[:id])

    # send a JSON-formatted response of the the game data
    game.to_json(
      only: %i[id title genre price],
      include: {
        reviews: {
          only: %i[comment score],
          include: {
            user: {
              only: [:name],
            },
          },
        },
      },
    )
  end
end
