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
        users = User.unconfirmed
        if users.present?
          "<div class='row'>
          #{concept('user/cell/card', collection: User.unconfirmed)}
          </div>"
        else
          " <br />
            <br />
            <div class='text-center'>
              <h1>Chouette !</h1>
              <h2>Aucun utilisateur à confirmer ;-)</h1>
            </div>"
        end
      end
    end
  end
end  
