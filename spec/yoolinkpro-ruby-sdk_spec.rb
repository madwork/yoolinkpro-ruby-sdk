require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Yoolinkpro do

  describe ".configure" do
    [:public_key, :private_key, :admin_key].each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        Yoolinkpro.configure do |config|
          config.send("#{key}=", key)
        end
        Yoolinkpro.send(key).should == key
      end
    end
  end

end

describe Yoolinkpro::Client do

  describe ".new" do
    it "sets keys" do
      client = Yoolinkpro::Client.new('public_key', 'private_key', 'admin_key')
      client.public_key.should == 'public_key'
      client.private_key.should == 'private_key'
      client.admin_key.should == 'admin_key'
    end
  end

end

describe Yoolinkpro::Request do

  let(:client) { Yoolinkpro::Client.new('public_key', 'private_key', 'admin_key') }
  let(:request) { Yoolinkpro::Request.new client }
  let(:millitime) { request.instance_variable_get('@millitime') }
  let(:int) { request.instance_variable_get('@int') }

  describe ".new" do
    it "override default oj options" do
      client.oj_options = { :symbol_keys => false }
      request.oj_options.should == { :symbol_keys => false }
    end

    it "use default oj options" do
      request.oj_options.should == { :symbol_keys => true }
    end
  end

  context "instance" do
    describe ".get" do
      it "raise exception not found" do
        stub_request(:any, "https://api.yoolinkpro.com/foo/1.json").to_return(:status => 404)
        expect { request.get(:find, :foo, 1) }.to raise_error Yoolinkpro::ApiException, "404 Resource Not Found"
      end

      it "raise exception timeout" do
        stub_request(:any, "https://api.yoolinkpro.com/foo/1.json").to_timeout
        expect { request.get(:find, :foo, 1) }.to raise_error Yoolinkpro::ApiException, "Request Timeout"
      end

      it "raise exception invalid response" do
        stub_request(:any, "https://api.yoolinkpro.com/user/1.json").to_return{ { :body => "" } }
        expect { request.get(:find, :user, 1) }.to raise_error Yoolinkpro::ApiException, "Invalid API Response"
      end

      it "find user with symbolized keys" do
        stub_request(:any, "https://api.yoolinkpro.com/user/1.json").to_return{ { :body => { "id" => 1 }.to_json } }
        request.get(:find, :user, 1).should == { :id => 1 }
      end

      it "find user" do
        stub_request(:any, "https://api.yoolinkpro.com/user/1.json").to_return{ { :body => {}.to_json } }
        request.get(:find, :user, 1).should == {}
        request.instance_variable_get('@key').should == "get/user/1.json#{request.private_key}#{millitime}#{int}"
      end

      it "find all users" do
        stub_request(:any, "https://api.yoolinkpro.com/users.json").to_return{ { :body => {}.to_json } }
        request.get(:find_all, :users, :admin).should == {}
        request.instance_variable_get('@key').should == "get/users.json#{request.admin_key}#{millitime}#{int}"
      end
    end
  end

end
