class TagsController < ApplicationController

  def index
    @tags = Tag.all
    render json: @tags
  end

  def create
    @tag = Tag.create(tag_params)
    render json: @tag, status: :created, location: tag_path(@tag)
  end

  def update
    @tag = Tag.find_by(id: params[:id])
    if @tag
      @tag.update(tag_params)
      render status: :no_content
    else
      render status: :not_found
    end
  end

  def destroy
    @tag = Tag.find_by(id: params[:id])
    if @tag
      @tag.destroy
      render status: :no_content
    else
      render status: :not_found
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:title, :slug)
  end
end
