class User::Cell < ::Cell::Concept
  property :firstname
  property :lastname

  property :confirmed_at

  def show
    render
  end
  
  private

  def fullname
    firstname + " " + lastname
  end

  class Card < self
    inherit_views User::Cell

    def show
      render :card
    end

    private

    def css_classes
      "col-md-4 col-sm-6"
    end

    class Admin < Card
      def show
        render :admin_card
      end
    end
  end

  class Grid < ::Cell::Concept
    def show
      "<div class='row'>
      #{concept('user/cell/card', collection: users)}
      </div>"
    end

    private

    def users
      if options[:admin]
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
