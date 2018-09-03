# frozen_string_literal: true

require 'secrets_loader/config'
require 'secrets_loader/loader/secrets_manager'

RSpec.describe SecretsLoader::Loader::SecretsManager do
  describe '#enable?' do
    subject { loader.enable? }

    let(:loader) { SecretsLoader::Loader::SecretsManager.new(client: client, secret_id: secret_id) }
    let(:client) { instance_double(Aws::SecretsManager::Client) }

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

  describe '#load' do
    before do
      allow(client).to receive(:get_secret_value).with(secret_id: secret_id).and_return(secret_value)
    end

    let(:secret_id) { 'x' }
    let(:client) { instance_double(Aws::SecretsManager::Client) }
    let(:secret_value) { OpenStruct.new(secret_string: secret_string) }
    let(:secret_string) {
      JSON.dump({
        a: 'abc',
        b: 123,
        c: true,
      })
    }

    it 'loaded secret values' do
      result = SecretsLoader::Loader::SecretsManager.new(client: client, secret_id: secret_id).load
      expect(result).to eq({
        'a' => 'abc',
        'b' => 123,
        'c' => true,
      })
    end
  end
end
