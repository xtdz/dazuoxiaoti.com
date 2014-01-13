class OrganizationsController < ApplicationController
  before_filter :require_admin, :only => [:edit, :update]
  
  def new
    @organization = Organization.new
  end
  
  def create
    @organization = Organization.new(params[:organization])
    @organization.save
    redirect_to edit_organization_path(@organization)
  end
  
  def edit
    @organization = Organization.find(params[:id])
  end
  
  def update
    @organization = Organization.find(params[:id])
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html  { redirect_to(edit_organization_path(@organization),:notice => 'Organization was successfully updated.') }
      end
    end
  end
  
end
