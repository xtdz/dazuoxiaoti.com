require 'spec_helper'

describe "NewAdmin::HomeNotices" do
  describe "GET /new_admin_home_notices" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get new_admin_home_notices_path
      response.status.should be(200)
    end
  end
end
