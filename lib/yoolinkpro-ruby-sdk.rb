require 'rest_client'
require 'oj'
require 'active_support/core_ext'
require 'hash_ext'
require 'yoolinkpro/exceptions'

module Yoolinkpro
  extend self
  
  API_SERVER  = "api.yoolinkpro.com"
  API_VERSION = 1
  
  attr_accessor :public_key, :private_key, :admin_key
  
  # config/initializers/load_yoolinkpro.rb (for rails)
  #
  #   Yoolinkpro.configure do |config|
  #     config.public_key  = 'public_key'
  #     config.private_key = 'private_key'
  #     config.admin_key   = 'admin_key'
  #   end
  def configure
    yield self
  end
  
  autoload :Client,  'yoolinkpro/client'
  autoload :Request, 'yoolinkpro/request'
  autoload :Api,     'yoolinkpro/api'
end
