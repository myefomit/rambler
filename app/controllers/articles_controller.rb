class ArticlesController < ApplicationController

  def index
    @articles = Article.all
    render json: @articles
  end

  def create
    @article = Article.create(article_params)
    render json: @article, status: :created, location: article_path(@article)
  end

  def show
    @article = Article.find_by(id: params[:id])
    if @article
      render json: @article, status: :ok
    else
      render status: :not_found
    end
  end

  def update
    @article = Article.find_by(id: params[:id])
    if @article
      @article.update(article_params)
      render status: :no_content
    else
      render status: :not_found
    end
  end

  def destroy
    @article = Article.find_by(id: params[:id])
    if @article
      @article.destroy
      render status: :no_content
    else
      render status: :not_found
    end
  end

  private

  def article_params
    params.require(:article).permit(
      :title, :abstract, :content, :url, :image_url, :publish_date
    )
  end
end
