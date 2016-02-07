class User::Cell
  class Grid < ::Cell::Concept
    include Kaminari::Cells
    include ActionView::Helpers::JavaScriptHelper

    inherit_views User::Cell

    def show
      render :grid
    end

    private

    def current_user
      options[:current_user]
    end

    def admin?
      current_user.admin?
    end

    def append
      %{ $('#next-users').replaceWith("#{j(show)}") }
    end

    def page
      options[:page] or 1
    end

    def next_path
      return unconfirmed_users_path(page: model.next_page) if options[:unconfirmed]
      users_path(page: model.next_page)
    end
  end

end  
