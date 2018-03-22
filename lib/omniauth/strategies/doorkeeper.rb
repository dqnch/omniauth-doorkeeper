require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :client_options,
             site: ENV['DOORKEEPER_SITE'] || 'http://localhost:3001',
             authorize_url: 'oauth/authorize' # token_url: 'oauth/token'

      uid { raw_info['uid'] }

      info do
        {
          email: raw_info['email'],
          name: raw_info['name'],
          nickname: raw_info['nickname']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me').parsed
      end

      # https://github.com/intridea/omniauth-oauth2/issues/81
      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end
