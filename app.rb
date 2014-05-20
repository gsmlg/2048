require 'bundler/setup'
Bundler.require :app
require File.expand_path('../lib/ws/sinatra-websocket', __FILE__)

class App < Sinatra::Base
    Bundler.require environment
    require 'sinatra/cookies'

    configure do
        use Rack::Session::Pool

        set :root, File.dirname(__FILE__)
        set :sprockets, Sprockets::Environment.new(root)

        set :assets_prefix, 'assets'
        set :assets_path, -> { File.join(public_folder, assets_prefix) }
        set :assets_manifest_path, -> { File.join(assets_path, 'manifest.json') }
        set :assets_compile, %w(*.png modernizr.js application.js application.css)

        Sprockets::Helpers.configure do |config|
            config.environment = sprockets
            config.prefix = "/#{assets_prefix}"
            config.digest = false
            config.public_path = public_folder
        end

        %w(javascript stylesheet image font).each do |type|
            sprockets.append_path root + "/app/#{type}"
            sprockets.append_path root + "/vendor/#{type}"
            sprockets.append_path root + "/lib/#{type}"
        end

        %w(compass blueprint).each do |name|
            sprockets.append_path Compass.base_directory + "/framworks/#{name}/stylesheets"
            sprockets.append_path Compass.base_directory + "/framworks/#{name}/stylesheets"
        end

        Compass.configuration.images_path = root + '/app/image'
    end

    configure :development do
        register Sinatra::Reloader

        use BetterErrors::Middleware
        BetterErrors.application_root = root
    end

    configure :test do

    end

    configure :production do

    end

    helpers do
        include Sprockets::Helpers
    end

    before do
        session[:uid] ||= rand(99999999).to_s
    end

    get '/' do
        erb :index
    end

    set :sockets, {}
    set :pubs, {}
    set :games, {}

    get '/pub' do
        if request.websocket?
            request.websocket do |ws|
                uid = session[:uid]
                puts uid
                ws.onopen do
                    ws.send("Game start!")
                    settings.pubs[uid] = ws
                end
                ws.onmessage do |msg|
                    msg = JSON.parse(msg)
                    # event = msg["event"]
                    game = settings.games[uid]
                    game.generate
                    EM.next_tick do
                        sub = settings.sockets[uid]
                        sub.send(game.to_json)
                    end
                end
                ws.onclose do
                    warn("Game control disconnect!")
                    settings.sockets.delete(ws)
                end
            end
        else
            halt 400
        end
    end

    get '/sub' do
        if request.websocket?
            request.websocket do |ws|
                uid = session[:uid]
                puts uid
                ws.onopen do
                    game = Game.new
                    ws.send(game.to_json)
                    settings.sockets[uid] = ws
                    settings.games[uid] = game
                end
                ws.onclose do
                    warn("Game View disconnect!")
                    settings.sockets.delete(ws)
                end
            end
        else
            halt 400
        end
    end

end


class Game
    def initialize
        @matrix = [
                   [ 0, 0, 0, 0 ],
                   [ 0, 0, 0, 0 ],
                   [ 0, 0, 0, 0 ],
                   [ 0, 0, 0, 0 ]
                  ]
        generate
        generate
    end

    def generate
        nullGrid = []
        @matrix.each_with_index do |row, rowIndex|
            row.each_with_index do |value, columnIndex|
                nullGrid.push(x: columnIndex, y: rowIndex) if value == 0
            end
        end
        raise if nullGrid.length == 0
        fill = nullGrid.shuffle.first
        x, y = fill[:x], fill[:y]
        @matrix[y][x] = rand(20) > 17 ? 4 : 2
    end

    def to_json
        JSON.generate(@matrix)
    end

end
