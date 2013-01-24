require 'digest/sha1'
require 'base64'
require 'cgi'

module Yoolinkpro
  class Request < SimpleDelegator
    include Yoolinkpro::Api

    # Yoolinkpro::Request
    #
    #   client = Yoolinkpro::Client.new
    #   request = Yoolinkpro::Request.new client
    #
    # @param [Yoolinkpro::Client] client
    # @return [Yoolinkpro::Request]
    def initialize(client)
      super
      @millitime = Time.now.to_i*1000
      @int = rand(100000)
      @key_scopes = { :private => private_key, :admin => admin_key }

      self.oj_options ||= { :symbol_keys => true }  # set key as symbol by default, symbol are so cool!
    end

    def get(method, *args)
      @response ||= begin
        http_response = send(method, *args)
        Oj.load(http_response.body, oj_options)
      end
    rescue RestClient::Exception => ex
      raise ApiException, ex.message
    rescue Oj::ParseError
      raise ApiException, "Invalid API Response"
    end
    
    private
    
    # Set HTTP headers for every request
    def http_headers
      {
        'User-Agent' => "YoolinkPro Ruby SDK",
        'X-YP-AppKey' => public_key,
        'X-YP-Signature' => signature,
        'X-YP-MilliTime' => @millitime,
        'X-YP-Int' => @int
      }
    end
    
    # Compute signature required into http headers (X-YP-Signature)
    # A validate signature is required to authorize request
    def signature
      Base64.strict_encode64(Digest::SHA1.digest(@key)).gsub(/=$/, '')
    end
    
    def build_uri(path, options = {})
      @uri = URI::HTTPS.build({ :host => Yoolinkpro::API_SERVER, :path => path }.merge(options))
    end
    
    def build_key(http_method, scope, params = {})
      @key = "#{http_method}#{@uri.path}#{params.to_key}#{@key_scopes[scope] || private_key}#{@millitime}#{@int}"
    end

    def crypted_password(password)
      cipher = OpenSSL::Cipher::Cipher.new('bf-ecb').encrypt
      cipher.key = Digest::SHA256.digest(private_key)
      cipher.update(password) << cipher.final
    end
    
  end
end
