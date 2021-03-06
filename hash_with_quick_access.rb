require "active_support/all"

class HashWithQuickAccess
  def initialize(hash)
    @hash = ActiveSupport::HashWithIndifferentAccess.new(hash)
  end

  def method_missing(key)
    if has_key(key)
      fetch_possibly_decorated_value(key)
    else
      raise KeyError.new("key :#{key} was not found")
    end
  end

  def respond_to?(method_name, include_private = false)
    has_key(method_name) || super
  end

  def keys
    @hash.keys.map(&:to_sym)
  end

  private

  def fetch_possibly_decorated_value(key)
    obj = @hash.fetch(key)

    if should_be_decorated(obj)
      decorate(obj)
    else
      obj
    end
  end

  def should_be_decorated(obj)
    (obj.is_a?(Array) && obj[0].is_a?(Hash)) || obj.is_a?(Hash)
  end

  def decorate(obj)
    if obj.is_a?(Array)
      obj.map { |o| HashWithQuickAccess.new(o) }
    elsif obj.is_a?(Hash)
      HashWithQuickAccess.new(obj)
    end
  end

  def has_key(key)
    all_keys.include?(key)
  end

  def all_keys
    @hash.keys.flat_map do |key|
      [key, key.to_sym]
    end
  end
end
