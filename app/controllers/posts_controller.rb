class PostsController < LoggedController
  def show
    @post = Post.find(params[:id])

    form Comment::Create
  end

  def new
    form Post::Create
  end

  def create
    run Post::Create do |op|
      flash[:notice] = "Post créé!"
      return redirect_to category_path(op.model.category)
    end

    render :new
  end

  def edit
    form Post::Update
  end

  def update
    run Post::Update do |op|
      flash[:notice] = "Post modifié!"
      return redirect_to category_path(op.model.category)
    end

    render :edit
  end

  def create_comment
    run Comment::Create do |op|
      flash[:notice] = "Commentaire envoyé!"
      return redirect_to post_path(op.model.post)
    end

    @post= Post.find(params[:id])
    render :show
  end

  def next_comments
    @post = Post.find(params[:id])

    render js: concept("comment/cell/grid", @post, page: params[:page]).(:append)
  end
end
