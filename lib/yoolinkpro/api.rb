module Yoolinkpro
  module Api
    # User authentication
    #
    #   api.authenticate "vincent@yoolink.fr", "password"
    #
    # @param [String] email
    # @param [String] password
    # @return [RestClient::Response]
    def authenticate(email, password)
      params = { :email => email, :password => Base64.strict_encode64(crypted_password(password)) }
      build_uri("/user/authenticate.json", :query => params.to_query)
      build_key(:post, private_key, params)
      RestClient.post @uri.to_s, params.to_query, http_headers
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
    #   api.find :team, 1234
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

    # Find all object such as users, teams, groups
    #
    #   api.find_all :users
    #   api.find_all :groups
    #
    # @param [Symbol] obj pluralize
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def find_all(obj, scope = :admin)
      build_uri("/#{obj}.json")
      build_key(:get, scope)
      RestClient.get @uri.to_s, http_headers
    end

    # Search object such as :user
    #
    #   api.search :user, :email => "vincent@yoolink.fr"
    #
    # @param [Symbol] obj
    # @param [Hash] params
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def search(obj, params = {}, scope = :private)
      build_uri("/#{obj}/search.json", :query => params.to_query)
      build_key(:get, scope, params)
      RestClient.get @uri.to_s, http_headers
    end

    # Create object such as :user, :team, :link, :comment
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

    # Update object such as :user, :link
    #
    #   api.update :user, 1, :firstname => "Vincent"
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

    # Delete object
    #
    #   api.delete :comment, 1, { :identity_token => auth[:identity_token] }, :private
    #
    # @param [Symbol] obj
    # @param [Fixnum] id
    # @param [Hash] params
    # @param [Symbol] scope for this request
    # @return [RestClient::Response]
    def delete(obj, id, params = {}, scope = :admin)
      build_uri("/#{obj}/#{id}.json", :query => params.to_query)
      build_key(:delete, scope, params)
      RestClient.delete @uri.to_s, http_headers
    end
  end
end