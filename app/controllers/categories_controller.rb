class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource
  
  def index
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to root_path, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

    def edit
      @category = Category.find(params[:id])
    end

    def update 
      @category = Category.find(params[:id])
      
      if @category.update(category_params)
        redirect_to @category, notice: "Category was successfully updated."
      else
        render :new, status: :unprocessable_entity
      end
    end

      def destroy
        @category = Category.find(params[:id])
        @category.destroy

        redirect_to root_path, status: :see_other
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
      
end


