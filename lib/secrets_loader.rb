# frozen_string_literal: true

require 'json'
require 'secrets_loader/config'
require 'secrets_loader/version'

module SecretsLoader
  class << self
    attr_accessor :config

    def load
      return unless enable?

      secret_values.each do |key, value|
        if ENV.has_key?(key.to_s)
          warn "WARNING: Skipping key #{key.inspect}. Already set in ENV."
        else
          ENV[key.to_s] = value.to_s
        end
      end
    end

    private

    def secret_values
      config.loader.load
    end

    def enable?
      config.loader.enable?
    end
  end

  self.config = SecretsLoader::Config.new
end
