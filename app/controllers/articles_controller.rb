class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    @category = Category.find(params[:category_id])
    @articles = @category.articles
  end

  def show
    @category = Category.find(params[:category_id])
    @article = @category.articles.find(params[:id])
  end

  def new
    @category = Category.find(params[:category_id])
    @article = @category.articles.build
  end

  def create
    @category = Category.find(params[:article][:category_id])
    @article = @category.articles.build(article_params)
    @article.user = current_user

    # Handling different button submissions
    case params[:commit]
    when 'Save as Draft'
      @article.status = :draft
    when 'Request for Publication'
      @article.status = :pending
    when 'Publish'
      @article.status = :published
    end

    if @article.save
      redirect_to category_path(@category), notice: 'Article was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:category_id])
    @article = @category.articles.find(params[:id])
  end

  def update
    @category = Category.find(params[:category_id])
    @article = @category.articles.find(params[:id])

    # Handling different button submissions
    case params[:commit]
    when 'Save as Draft'
      @article.status = :draft
    when 'Request for Publication'
      @article.status = :pending
    when 'Publish'
      @article.status = :published
    end

    if @article.update(article_params)
      new_category = Category.find(@article.category_id)
      redirect_to category_path(new_category), notice: 'Article was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:category_id])
    @article = @category.articles.find(params[:id])
    @article.destroy

    redirect_to category_path(@category), notice: "Article was successfully destroyed."
  end

  def publish
    @article = Article.find(params[:id])
    authorize! :publish, @article
    
    if @article.update(status: :published)
      redirect_to category_path(@article.category), notice: 'Article was successfully published.'
    else
      redirect_to category_path(@article.category), alert: 'Article could not be published.'
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :status, :visitors, :category_id, :photo, :video, images: [])
  end
  
end
