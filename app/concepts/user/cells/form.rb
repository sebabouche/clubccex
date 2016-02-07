class User::Cell
  class Form < ::Cell::Concept
    include ActionView::RecordIdentifier
    include SimpleForm::ActionViewExtensions::FormHelper

    inherit_views User::Cell

    property :contract
    property :policy

    def user
      @model.model
    end

    def show
      render :form
    end

    private

    def f_input(f, field, required = false)
      star = "* " if(required == true)
      f.input(field, label: false) # , placeholder: "#{self.placeholder}#{star}")
    end
  end
end  
