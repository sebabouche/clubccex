class User::Cell < ::Cell::Concept
  property :email
  property :firstname
  property :lastname
  property :maidenname
  property :nickname
  property :company
  property :occupation
  property :phone
  property :city

  include ActionView::Helpers::DateHelper
  property :created_at

  def show
    render
  end
  
  private

  def fullname
    firstname + " " + lastname
  end
  
  def created_at
    "Membre du Club depuis " + time_ago_in_words(super)
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
