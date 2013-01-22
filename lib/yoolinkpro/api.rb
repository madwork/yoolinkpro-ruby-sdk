require 'digest/sha1'
require 'base64'
require 'cgi'

module Yoolinkpro
  class Api < SimpleDelegator
  
    # Yoolinkpro::Api
    #
    #   client = Yoolinkpro::Client.new
    #   api = Yoolinkpro::Api.new client
    #
    # @param [Yoolinkpro::Client] client
    # @return [Yoolinkpro::Api]
    def initialize(client)
      super
      @millitime = Time.now.to_i*1000
      @int = rand(100000)
      @key_scopes = { :private => private_key, :admin => admin_key }
    end
    
    # Create an url to open a new session
    #
    #   api.open_session "vincent@yoolink.fr"
    #
    # @param [String] email of an existing YoolinkPro user
    # @return [RestClient::Response]
    def open_session(email)
      @key = "get/open_sessionemail=#{email}#{admin_key}#{@millitime}#{@int}"
      RestClient::Response.create "https://#{Yoolinkpro::API_SERVER}/open_session?email=#{CGI.escape(email)}&X-YP-AppKey=#{public_key}&X-YP-Signature=#{CGI.escape(signature)}&X-YP-MilliTime=#{@millitime}&X-YP-Int=#{@int}".to_json, nil, nil
    end
    
    # Find object such as user, team, link
    #
    #   api.find :user, 1
    #
    # @param [Symbol] obj
    # @param [Fixnum] id
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def find(obj, id, scope = :private)
      build_uri("/#{obj}/#{id}.json")
      build_key(:get, scope)
      RestClient.get @uri.to_s, http_headers
    end

    # Search object such as :user, :team, :link
    #
    #   api.search :user, :email => "vincent@yoolink.fr"
    #
    # @param [Symbol] obj
    # @param [Fixnum] params
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def search(obj, params = {}, scope = :private)
      build_uri("/#{obj}/search.json", :query => params.to_query)
      build_key(:get, scope, params)
      RestClient.get @uri.to_s, http_headers
    end

    # Create object such as :user, :team, :link
    #
    #   api.create :group, :name => "Api", :description => "Everything about Api"
    #
    # @param [Symbol] obj
    # @param [Hash] params
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def create(obj, params = {}, scope = :admin)
      build_uri("/#{obj}.json", :query => params.to_query)
      build_key(:post, scope, params)
      RestClient.post @uri.to_s, params.to_query, http_headers
    end

    # Update object such as :user, :team, :link
    #
    #   api.update :group, 1, :description => "Everything about Api and more..."
    #
    # @param [Symbol] obj
    # @param [Fixnum] id
    # @param [Hash] params
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def update(obj, id, params = {}, scope = :admin)
      build_uri("/#{obj}/#{id}.json", :query => params.to_query)
      build_key(:put, scope, params)
      RestClient.put @uri.to_s, params.to_query, http_headers
    end
    
    private
    
    def http_headers
      {
        'User-Agent' => "YoolinkPro Ruby SDK",
        'X-YP-AppKey' => public_key,
        'X-YP-Signature' => signature,
        'X-YP-MilliTime' => @millitime,
        'X-YP-Int' => @int
      }
    end
    
    def signature
      Base64.encode64(Digest::SHA1.digest(@key)).gsub(/=$/, '')
    end
    
    def build_uri(path, options = {})
      @uri = URI::HTTPS.build({ :host => Yoolinkpro::API_SERVER, :path => path }.merge(options))
    end
    
    def build_key(http_method, scope, params = {})
      @key = "#{http_method}#{@uri.path}#{params.to_key}#{@key_scopes[scope] || private_key}#{@millitime}#{@int}"
    end
    
  end
end
