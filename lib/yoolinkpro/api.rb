require 'digest/sha1'
require 'base64'
require 'cgi'

module Yoolinkpro
  class Api < SimpleDelegator
  
    def initialize(client)
      super
      @millitime = Time.now.to_i*1000
      @int = rand(100000)
      @key_scopes = { :private => private_key, :admin => admin_key }
    end
    
    def open_session(email)
      @key = "get/open_sessionemail=#{email}#{admin_key}#{@millitime}#{@int}"
      RestClient::Response.create "https://#{Yoolinkpro::API_SERVER}/open_session?email=#{CGI.escape(email)}&X-YP-AppKey=#{public_key}&X-YP-Signature=#{CGI.escape(signature)}&X-YP-MilliTime=#{@millitime}&X-YP-Int=#{@int}".to_json, nil, nil
    end
    
    def method_missing(method, *args)
      case method.to_s
      when /^get_(\w+)_by_id$/
        build_uri("/#{$1}/#{args.first}.json")
        build_key(:get, args.last[:as])
        RestClient.get @uri.to_s, http_headers
      when /^get_(\w+)$/
        build_uri("/#{$1}.json")
        build_key(:get, args.last[:as])
        RestClient.get @uri.to_s, http_headers
      when /^create_(\w+)$/
        build_uri("/#{$1}.json", :query => args.first.to_query)
        build_key(:post, args.last[:as], args.first)
        RestClient.post @uri.to_s, args.first.to_query, http_headers
      else
        super
      end
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
      @uri = URI::HTTP.build({ :host => Yoolinkpro::API_SERVER, :path => path }.merge(options))
    end
    
    def build_key(http_method, scope, params = {})
      @key = "#{http_method}#{@uri.path}#{params.to_key}#{@key_scopes[scope] || private_key}#{@millitime}#{@int}"
    end
    
  end
end
