# -*- encoding: utf-8 -*-
class NewAdmin::CategoriesController < NewAdmin::ApplicationController
  
  def index
  	@categories = Category.order("id desc").page(params[:page])
  end
  

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params["category"])
    respond_to do |format|
      if @category.save
        format.html { redirect_to new_admin_categories_path, notice: '创建成功' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def edit
  	@category = Category.find params["id"]
  end

  def update
    @category = Category.find params["id"]
    respond_to do |format|
      if @category.update_attributes(params["category"])
        format.html { redirect_to new_admin_categories_path, notice: '创建成功' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end

   
  end

  def destroy
     category = Category.find params["id"]
     category.is_show=false
     redirect_to :action=>"index" if  category.save
  end

end
