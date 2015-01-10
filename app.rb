require "sinatra"
require "pp"
require_relative "git_updater"
require "json"

CONFIG = {
  "Cardistrycon.com" => "/Users/davidpdrsn/dotfiles",
}

post "/" do
  push = JSON.parse(request.body.read)
  GitUpdater.new(push, CONFIG).update
  ""
end

get "/" do
  "Its all good"
end
