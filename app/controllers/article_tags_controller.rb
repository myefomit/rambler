class ArticleTagsController < ApplicationController

  def index
    article_tags = ArticleTag.all
    render json: article_tags
  end

  def create
    article_tag = ArticleTag.create(article_tag_params)
    if article_tag.persisted?
      render json: article_tag, status: :created
    else
      render plain: 'Cannot find article or tag', status: :unprocessable_entity
    end
  end

  def destroy
    article_tag = ArticleTag.find_by(id: params[:id])
    if article_tag
      article_tag.destroy
      render status: :no_content
    else
      render status: :not_found
    end
  end

  private

  def article_tag_params
    params.require(:article_tag).permit(:article_id, :tag_id)
  end
end
