require "json"
require "sinatra"
require_relative "git_updater"

CONFIG = {
  "Cardistrycon.com" => "/home/deployer/cardistrycon",
  "Update-repos-with-web-hooks" => "/home/deployer/update_gits",
}

post "/" do
  push = JSON.parse(request.body.read)
  GitUpdater.new(push, CONFIG).update
  ""
end

get "/" do
  "Its all good"
end
