class ArticlesController < ApplicationController
  include Filterable

  PER_PAGE = 10

  def index
    @articles = apply_filters(Article.all, params)
    paginate json: @articles, per_page: PER_PAGE
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

  def filters
    { filter_ids: Array, filter_title_contains: String }
  end

  def article_params
    params.require(:article).permit(
      :title, :abstract, :content, :url, :image_url, :publish_date
    )
  end
end
