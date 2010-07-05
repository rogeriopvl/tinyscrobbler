require 'httparty'
require 'md5'

module Tinyscrobbler
  module Auth
    class Web
      attr_accessor :api_key, :secret

      def self.authentication_token(secret, timestamp = Time.now.to_i.to_s)
        Digest::MD5.hexdigest(secret + timestamp)
      end

      def initialize(options = {})
        @api_key     = options[:api_key]
        @secret      = options[:secret]
      end

      def get_session_key(token)
        response = Tinyscrobbler::Request.new(:api_key => api_key, :secret => secret).get("auth.getSession", :token => token)

        if response["ok"]
          response["key"]
        end
      end
    end
  end

  class Request
    include HTTParty
    base_uri "ws.audioscrobbler.com/2.0/"
      
    attr_accessor :params, :secret, :api_key, :session_key

    def initialize(options = {})
      @params = { }
      @params[:api_key] = options[:api_key]
      @secret = options[:secret]
    end

    def get(method, options = {})
      @params.merge!(options)
      @params[:method] = method

      @params[:api_sig] = api_sig

      response = self.class.get("", :query => @params)

      response["lfm"]
    end

    def api_sig
      Digest::MD5.hexdigest(@params.sort { |a,b| a[0].to_s <=> b[0].to_s }.to_s + @secret)
    end
  end
end
