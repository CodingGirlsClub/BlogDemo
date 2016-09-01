class ArticlesController < ApplicationController
  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.where(is_public: true).order('created_at DESC')
  end

  def show
    @categories = Category.all
  end

  def edit
    
  end

  def update
    build_article
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_path, notice: "更新成功"}
      else
        format.html { render :edit }
      end
    end
  end

  def new
    @article = Article.new
  end

  def create
    build_article
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "创建成功"}
      else
        format.html { render action: :index, error: "创建失败" }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: '删除成功' }
    end
  end
  private 

  # 根据url中的id查找对应article
  def load_article
    @article ||= Article.find(params[:id])
  end

  def build_article
    @article ||= Article.new(article_params)
    @article.attributes = article_params.merge(user_id: current_user.id)
  end

  # strong parameters 检查
  def article_params
    params.require(:article).permit(:title, :content, :is_public, :category_id, :user_id)
  end
end
