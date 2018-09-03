# frozen_string_literal: true

require 'aws-sdk-secretsmanager'

module SecretsLoader
  class Config
    attr_writer :loader

    def loader
      @loader ||= default_loader
    end

    private

    def default_loader
      SecretsLoader::Loader::SecretsManager.new
    end
  end
end
