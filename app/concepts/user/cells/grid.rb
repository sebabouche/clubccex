class User::Cell
  class Grid < ::Cell::Concept
    def show
      "<div class='row'>
      #{concept('user/cell/card', collection: users, user: options[:user])}
      </div>"
    end

    private

    def admin?
      options[:user].admin?
    end

    def users
      if admin?
        User.all
      else
        User.confirmed
      end
    end

    class Unconfirmed < Grid
      def show
        "<div class='row'>
        #{concept('user/cell/card/admin', collection: User.unconfirmed)}
        </div>"
      end
    end
  end
end  
