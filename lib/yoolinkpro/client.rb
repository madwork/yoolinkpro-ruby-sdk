module Yoolinkpro
  class Client
    
    attr_reader :public_key, :private_key, :admin_key
    
    def initialize(public_key = Yoolinkpro.public_key, private_key = Yoolinkpro.private_key, admin_key = Yoolinkpro.admin_key)
      @public_key, @private_key, @admin_key = public_key, private_key, admin_key
    end
    
    def method_missing(method, *args)
      api = Api.new(self)
      response = api.send(method, *args)
      Oj.load(response.body, :symbol_keys => true)
    rescue RestClient::Exception => ex
      raise ApiException, ex.message
    end
    
  end
end
