# frozen_string_literal: true

require 'aws-sdk-secretsmanager'

module SecretsLoader
  class Config
    attr_accessor :secret_id
    attr_writer :client

    def initialize
      @secret_id = ENV['SECRETS_MANAGER_SECRET_ID']
    end

    def client
      @client ||= Aws::SecretsManager::Client.new
    end
  end
end
