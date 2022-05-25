class ArticlesController < ApplicationController

  def index
    @articles = Article.all
    render json: @articles
  end

  def create
    @article = Article.create(article_params)
    render json: @article, status: :created, location: article_path(@article)
  end

  private

  def article_params
    params.require(:article).permit(
      :title, :abstract, :content, :url, :image_url, :publish_date
    )
  end
end
