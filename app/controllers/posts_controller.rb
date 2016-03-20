class PostsController < ApplicationController
  def index
    @posts = Post.all.order("votes desc").page params[:page]
    @posts_count = Post.count
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new
    @post.title = params[:post][:title]
    @post.content = params[:post][:content]
    if @post.save
      flash[:notice] = "Post successfully created"
      (redirect_to posts_path)
    else
      flash[:alert] = "There was a problem creating your post."
      (render :new)
    end
  end

  def create_comment
    @post = Post.find_by id: params[:id]
    @comment = Comment.new
    @comment.comment_content = params[:comment][:comment_content]
    @comment.post_id = @post.id

    if @comment.save
      flash[:notice] = "Comment successfully created"
      (redirect_to post_path(id: @post.id))
    else
      flash[:alert] = "There was a problem creating your comment."
      render :show
    end
  end

  def show
    @post = Post.find_by id: params[:id]
    @post.views = @post.views + 1
    @post.save
    @comment = Comment.new
    @comment.post = @post
  end

  def edit
    @post = Post.find_by id: params[:id]
  end

  def update
    @post = Post.find_by id: params[:id]
    @post.title = params[:post][:title]
    @post.content = params[:post][:content]
    @post.save ? (redirect_to posts_path) : (render :edit)
  end

  def delete
    @post = Post.find_by id: params[:id]
    @post.destroy ? (redirect_to posts_path) : (render :edit)
  end

  def upcount
    @post = Post.find_by id: params[:id]
    @post.votes += 1
    @post.save
    redirect_to(:back)
  end

  def downcount
    @post = Post.find_by id: params[:id]
    @post.votes > 0 ? (@post.votes -= 1) : (@post.votes)
    @post.save
    redirect_to(:back)
  end
end
