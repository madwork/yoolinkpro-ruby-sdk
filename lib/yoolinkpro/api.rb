require 'digest/sha1'
require 'base64'
require 'cgi'

module Yoolinkpro
  class Api < SimpleDelegator
  
    def initialize(client)
      super
      @millitime = Time.now.to_i*1000
      @int = rand(100000)
    end
    
    def open_session(email)
      @key = "get/open_sessionemail=#{email}#{admin_key}#{@millitime}#{@int}"
      RestClient::Response.create "https://#{Yoolinkpro::API_SERVER}/open_session?email=#{CGI.escape(email)}&X-YP-AppKey=#{public_key}&X-YP-Signature=#{CGI.escape(signature)}&X-YP-MilliTime=#{@millitime}&X-YP-Int=#{@int}".to_json, nil, nil
    end
    
    def user(id)
      build_uri("/user/#{id}.json")
      build_key("get")
      RestClient.get @uri.to_s, http_headers
    end
    
    def users
      build_uri("/users.json")
      build_key("get")
      RestClient.get @uri.to_s, http_headers
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
    
    def build_uri(path)
      @uri = URI::HTTP.build({ :host => Yoolinkpro::API_SERVER, :path => path })
    end
    
    def build_key(http_method)
      @key = "#{http_method}#{@uri.path}#{private_key}#{@millitime}#{@int}"
    end
    
  end
end
