class User::Cell
  class Grid < ::Cell::Concept
    include Kaminari::Cells
    include ActionView::Helpers::JavaScriptHelper

    inherit_views User::Cell

    def show
      render :grid
    end

    private

    def admin?
      options[:user].admin?
    end

    def users
      if admin?
        @model
      else
        @model.confirmed
      end
    end

    def append
      %{ $('#next').replaceWith("#{j(show)}") }
    end

    def page
      options[:page] or 1
    end

    class Unconfirmed < Grid
      def users
        User.unconfirmed
      end
    end
  end
end  
