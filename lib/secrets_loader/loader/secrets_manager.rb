# frozen_string_literal: true

require 'json'
require 'secrets_loader/loader/base'
require 'aws-sdk-secretsmanager'

module SecretsLoader
  module Loader
    class SecretsManager < Base
      attr_accessor :client, :secret_id

      def initialize(client: Aws::SecretsManager::Client.new, secret_id: ENV['SECRETS_MANAGER_SECRET_ID'])
        @client = client
        @secret_id = secret_id
      end

      def enable?
        return false unless super

        !(secret_id.nil? || secret_id.empty?)
      end

      def load
        secret_string = client.get_secret_value(secret_id: secret_id).secret_string
        JSON.parse(secret_string)
      end
    end
  end
end
