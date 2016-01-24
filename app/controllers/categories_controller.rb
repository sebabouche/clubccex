class CategoriesController < ApplicationController
  layout 'logged'

  def index
    @categories = Category.order(:priority)
    form Category::Create
  end

  def create
    run Category::Create do |op|
      flash[:notice] = "Catégorie créée."
      return redirect_to categories_path
    end

    render :new
  end

  def edit
    form Category::Update
  end

  def update
    run Category::Update do |op|
      flash[:notice] = "Catégorie modifiée."
      return redirect_to categories_path
    end
  end
end
