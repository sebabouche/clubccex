class Session::Cell < ::Cell::Concept
  include ActionView::RecordIdentifier
  include SimpleForm::ActionViewExtensions::FormHelper
  include Partial

  property :contract

  private

  def sign_up_fields(f)
    render partial: "session/views/sign_up_fields", locals: { f: f }
  end

  class SignUp < self
    inherit_views Session::Cell

    def show
      render :sign_up
    end
  end

  class SignUpSleeping < self
    inherit_views Session::Cell

    def show
      render :sign_up_sleeping
    end
  end

  class SignIn < self
    inherit_views Session::Cell
    
    def show
      render :sign_in
    end
  end

  class WakeUp < self
    inherit_views Session::Cell

    def show
      render :wake_up
    end
  end
end
