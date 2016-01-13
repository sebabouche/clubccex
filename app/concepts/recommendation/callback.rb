module Recommendation::Callback
  class Default < Disposable::Callback::Group
    on_create :confirm_user!

    private

    def confirm_user!
    end
  end
end
