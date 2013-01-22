require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Hash do

  describe ".to_key" do
    it "generate valid api key" do
      { :a => 1, :b => 2 }.to_key.should == "a=1b=2"
    end
    
    it "sort keys alphabeticaly" do
      { :c => 0, :a => 1, :b => 2 }.to_key.should == "a=1b=2c=0"
    end
  end

end
