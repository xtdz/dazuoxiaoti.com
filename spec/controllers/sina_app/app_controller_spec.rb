require 'spec_helper'
require 'base64'

describe SinaApp::AppController do
  context "decoding signed request from sina" do
    it "decodes base64 strings from sina correctly" do
      controller.base64_decode("-a_").should == Base64.decode64('+a/=')
      controller.base64_decode("-_-_abc").should == Base64.decode64('+/+/abc=')
    end

    it "decodes parameters correctly" do
      signed_request = "1_6ECEjl1bUeYuO2OnrevF8tdvrxVgjw6z2hYe8672U.eyJ1c2VyIjp7ImNvdW50cnkiOiJjbiIsImxvY2FsZSI6IiJ9LCJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTMzNjMzMzU4NiwicmVmZXJlciI6bnVsbH0"
      expected = {"user"=>{"country"=>"cn", "locale"=>""}, "algorithm"=>"HMAC-SHA256", "issued_at"=>1336333586, "referer"=>nil}
      controller.decode_request(signed_request).should == expected
    end

    it "returns nil when parameters does not match the signature" do
      signed_request = "0_6ECEjl1bUeYuO2OnrevF8tdvrxVgjw6z2hYe8672U.eyJ1c2VyIjp7ImNvdW50cnkiOiJjbiIsImxvY2FsZSI6IiJ9LCJhbGdvcml0aG0iOiJITUFDLVNIQTI1NiIsImlzc3VlZF9hdCI6MTMzNjMzMzU4NiwicmVmZXJlciI6bnVsbH0"
      controller.decode_request(signed_request).should == nil
    end
  end
end
