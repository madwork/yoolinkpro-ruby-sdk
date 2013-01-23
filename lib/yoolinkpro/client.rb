module Yoolinkpro
  class Client
    
    attr_reader :public_key, :private_key, :admin_key

    # Options for Optimized JSON (aka Oj)
    # @!attribute oj_options
    # * :indent [Fixnum] - number of spaces to indent each element in an JSON document
    # * :circular [Boolean] - support circular references while dumping
    # * :auto_define [Boolean] - automatically define classes if they do not exist
    # * :symbol_keys [Boolean] - convert hash keys to symbols
    # * :ascii_only [Boolean] - encode all high-bit characters as escaped sequences if true
    # * :load [Symbol] (:object|:strict|:compat|:null) - and dump mode to use for JSON :strict raises an exception when a non-supported Object is encountered. :compat attempts to extract variable values from an Object using to_json() or to_hash() then it walks the Object's variables if neither is found. The :object mode ignores to_hash() and to_json() methods and encodes variables using code internal to the Oj gem. The :null mode ignores non-supported Objects and replaces them with a null.
    # * :time [Symbol] (:unix|:xmlschema|:ruby) - format when dumping in :compat mode :unix decimal number denoting the number of seconds since 1/1/1970 :xmlschema date-time format taken from XML Schema as a String, :ruby Time.to_s formatted String
    # * :create_id [String] - create id for json compatible object encoding
    # * :max_stack [Fixnum] - maximum size to allocate on the stack for a JSON String
    # * :second_precision [Fixnum] - number of digits after the decimal when dumping the seconds portion of time
    attr_accessor :oj_options
    
    # Yoolinkpro::Client
    #
    #   client = Yoolinkpro::Client.new 'public_key', 'private_key', 'admin_key'
    #
    # @param [String] public_key
    # @param [String] private_key
    # @param [String] admin_key
    # @return [Yoolinkpro::Client]
    def initialize(public_key = Yoolinkpro.public_key, private_key = Yoolinkpro.private_key, admin_key = Yoolinkpro.admin_key)
      @public_key, @private_key, @admin_key = public_key, private_key, admin_key
    end
    
    def method_missing(method, *args)
      request = Yoolinkpro::Request.new(self)
      request.get(method, *args)
    end
    
  end
end
