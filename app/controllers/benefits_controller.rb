class BenefitsController < ApplicationController
  before_filter :require_admin, :only => [:edit, :update]
  
  def new
    @benefit = Benefit.new
  end
  
  def create
    @benefit = Benefit.new(params[:benefit])
    @benefit.save
    redirect_to edit_benefit_path(@benefit) 
  end
  
  def edit
    @benefit = Benefit.find(params[:id])
  end
  
  def update
    @benefit = Benefit.find(params[:id])
    respond_to do |format|
      if @benefit.update_attributes(params[:benefit])
        format.html  { redirect_to(edit_benefit_path(@benefit),:notice => 'Benefit was successfully updated.') }
      end
    end
  end
  
end
