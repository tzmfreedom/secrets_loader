# frozen_string_literal: true

require 'secrets_loader/version'
require 'json'

module SecretsLoader
  class << self
    attr_accessor :config

    def load
      return unless enable_secrets_loader?

      load_secret_values.each do |key, value|
        if ENV.has_key?(key)
          warn "WARNING: Skipping key #{key.inspect}. Already set in ENV."
        else
          ENV[key] = value.to_s
        end
      end
    end

    def load_secret_values
      secrets_manager = config.client
      secret_string = secrets_manager.get_secret_value(secret_id: config.secret_id).secret_string
      JSON.parse(secret_string)
    end

    def enable_secrets_loader?
      return false if ENV['ENABLE_SECRETS_LOADER'].nil? || ENV['ENABLE_SECRETS_LOADER'].empty?
      !(config.secret_id.nil? || config.secret_id.empty?)
    end
  end
end
