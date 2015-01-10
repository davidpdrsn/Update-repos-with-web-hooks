require_relative "hash_with_quick_access"

class GitUpdater
  def initialize(json, config)
    @json = HashWithQuickAccess.new(json)
    @config = config
  end

  attr_reader :json, :config

  def update
    `cd #{dir_to_update} && git pull`

    if dir_is_ruby_app?
      restart_apache
    end
  end

  private

  def dir_is_ruby_app?
    File.exists?(restart_file)
  end

  def dir_to_update
    config.fetch(json.repository.name)
  end

  def restart_file
    "#{dir_to_update}/tmp/restart.txt"
  end

  def restart_apache
    `touch #{restart_file}`
  end
end
