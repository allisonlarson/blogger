class ArticlesController < ApplicationController
  include ArticlesHelper

  before_filter :require_login, only: [:new, :create, :edit, :update, :destroy]

  def index
    @articles = Article.all
    @most_popular = Article.most_popular[0..2]
  end

  def article
    @cached_article ||= if params[:id]
      Article.find(params[:id])
    else
      Article.new
    end
  end

  def comment
    @cached_comment ||= if params[:article_id]
      Comment.find(params[:article_id])
    else
      Comment.new
    end
  end

  helper_method :article, :comment

  def show
    article.view_count
    comment.article_id = article.id
  end

  def create
    article.save

    flash.notice = "Article '#{article.title}' Was Created!"

    redirect_to article_path(article)
  end

  def destroy
    article.destroy

    flash.notice = "Article '#{article.title}' Was Deleted!"

    redirect_to articles_path
  end


  def update
    article.update(article_params)

    flash.notice = "Article '#{article.title}' Updated!"

    redirect_to article_path(article)
  end
end
