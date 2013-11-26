require "spec_helper"

describe NewAdmin::HomeNoticesController do
  describe "routing" do

    it "routes to #index" do
      get("/new_admin/home_notices").should route_to("new_admin/home_notices#index")
    end

    it "routes to #new" do
      get("/new_admin/home_notices/new").should route_to("new_admin/home_notices#new")
    end

    it "routes to #show" do
      get("/new_admin/home_notices/1").should route_to("new_admin/home_notices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/new_admin/home_notices/1/edit").should route_to("new_admin/home_notices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/new_admin/home_notices").should route_to("new_admin/home_notices#create")
    end

    it "routes to #update" do
      put("/new_admin/home_notices/1").should route_to("new_admin/home_notices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/new_admin/home_notices/1").should route_to("new_admin/home_notices#destroy", :id => "1")
    end

  end
end
