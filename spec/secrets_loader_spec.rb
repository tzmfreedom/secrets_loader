# frozen_string_literal: true

require 'secrets_loader/config'

RSpec.describe SecretsLoader do
  describe '.load' do
    before do
      config = SecretsLoader::Config.new
      allow(config.loader).to receive(:enable?).and_return(true)
      allow(config.loader).to receive(:load).and_return(secret_values)
      allow(SecretsLoader).to receive(:config).and_return(config)
    end

    let(:secret_values) {
      {
        a: 'abc',
        b: 123,
        c: true,
      }
    }

    it 'load to environment variables' do
      SecretsLoader.load

      expect(ENV['a']).to eq('abc')
      expect(ENV['b']).to eq('123')
      expect(ENV['c']).to eq('true')
    end
  end
end
