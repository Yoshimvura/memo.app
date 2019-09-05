# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable

  def index
    @book = Book.find(params[:id])
    @comments = Book.find(params[:id]).comments.all
    @comment = Book.find(params[:id]).comments.new
  end

  def new; end

  def show; end

  def edit
    @comment = @commentable.comments.find(params[:id])
  end

  def create
    @comment = @commentable.comments.new(comment_params)

    if @comment.save
      redirect_to @commentable
    else
      render :new
    end
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy
    redirect_to @commentable
  end

  def update
    if @commentable.comments.find(params[:id]).update(comment_params)
      redirect_to @commentable
    else
      render :new
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:commentable, :comment)
    end

    def set_commentable
      resource, id = request.path.split("/")[1, 2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end
end
