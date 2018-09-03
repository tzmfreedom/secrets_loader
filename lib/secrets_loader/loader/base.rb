# frozen_string_literal: true

module SecretsLoader
  module Loader
    class Base
      def enable?
        !(ENV['ENABLE_SECRETS_LOADER'].nil? || ENV['ENABLE_SECRETS_LOADER'].empty?)
      end
    end
  end
end
