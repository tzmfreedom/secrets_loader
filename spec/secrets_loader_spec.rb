# frozen_string_literal: true

require 'json'
require 'ostruct'
require 'secrets_loader/config'

RSpec.describe SecretsLoader do
  describe '.load' do
    before do
      @before_env_value = ENV['ENABLE_SECRETS_LOADER']
      ENV['ENABLE_SECRETS_LOADER'] = '1'

      config = SecretsLoader::Config.new.tap do |cfg|
        cfg.client = instance_double(Aws::SecretsManager::Client)
        cfg.secret_id = '123'
      end
      allow(SecretsLoader).to receive(:config).and_return(config)
      allow(config.client).to receive(:get_secret_value).with(secret_id: config.secret_id).and_return(secret_value)
    end

    after do
      ENV['ENABLE_SECRETS_LOADER'] = @before_env_value
    end

    let(:secret_value) { OpenStruct.new(secret_string: secret_string) }
    let(:secret_string) {
      JSON.dump({
        a: 'abc',
        b: 123,
        c: true,
      })
    }

    it 'load to environment variables' do
      SecretsLoader.load

      expect(ENV['a']).to eq('abc')
      expect(ENV['b']).to eq('123')
      expect(ENV['c']).to eq('true')
    end
  end

  describe '.enable_secrets_loader?' do
    before do
      config = SecretsLoader::Config.new.tap do |cfg|
        cfg.secret_id = secret_id
      end
      allow(SecretsLoader).to receive(:config).and_return(config)
    end

    subject { SecretsLoader.enable_secrets_loader? }

    context 'when secret_id is nil' do
      before do
        @before_env_value = ENV['ENABLE_SECRETS_LOADER']
        ENV['ENABLE_SECRETS_LOADER'] = '1'
      end

      after do
        ENV['ENABLE_SECRETS_LOADER'] = @before_env_value
      end

      let(:secret_id) { nil }

      it { is_expected.to eq(false) }
    end

    context 'when secret_id is not nil' do
      let(:secret_id) { 'x' }

      context 'when ENABLE_SECRETS_LOADER is set' do
        before do
          @before_env_value = ENV['ENABLE_SECRETS_LOADER']
          ENV['ENABLE_SECRETS_LOADER'] = '1'
        end

        after do
          ENV['ENABLE_SECRETS_LOADER'] = @before_env_value
        end

        it { is_expected.to eq(true) }
      end

      context 'when ENABLE_SECRETS_LOADER is nil' do
        before do
          @before_env_value = ENV['ENABLE_SECRETS_LOADER']
          ENV['ENABLE_SECRETS_LOADER'] = nil
        end

        after do
          ENV['ENABLE_SECRETS_LOADER'] = @before_env_value
        end

        it { is_expected.to eq(false) }
      end

      context 'when ENABLE_SECRETS_LOADER is blank' do
        before do
          @before_env_value = ENV['ENABLE_SECRETS_LOADER']
          ENV['ENABLE_SECRETS_LOADER'] = ''
        end

        after do
          ENV['ENABLE_SECRETS_LOADER'] = @before_env_value
        end

        it { is_expected.to eq(false) }
      end
    end
  end

  describe '.load_secret_values' do
    let(:secret_value) { OpenStruct.new(secret_string: secret_string) }
    let(:secret_string) {
      JSON.dump({
        a: 'abc',
        b: 123,
        c: true,
      })
    }

    before do
      config = SecretsLoader::Config.new.tap do |cfg|
        cfg.client = instance_double(Aws::SecretsManager::Client)
        cfg.secret_id
      end
      allow(SecretsLoader).to receive(:config).and_return(config)
      allow(config.client).to receive(:get_secret_value).with(secret_id: config.secret_id).and_return(secret_value)
    end

    it 'loaded secret values' do
      result = SecretsLoader.load_secret_values
      expect(result).to eq({
        'a' => 'abc',
        'b' => 123,
        'c' => true,
      })
    end
  end
end
