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

  describe Yoolinkpro::Client do
    it "set the keys" do
      client = Yoolinkpro::Client.new('public_key', 'private_key', 'admin_key')
      client.public_key.should == 'public_key'
      client.private_key.should == 'private_key'
      client.admin_key.should == 'admin_key'
    end
  end

end