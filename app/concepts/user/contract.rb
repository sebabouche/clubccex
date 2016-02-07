module User::Contract
  class ThisIsMe < Reform::Form
    model User
    feature Disposable::Twin::Persisted
    
    property :gender
    property :firstname
    property :lastname
    property :maidenname
    property :nickname
    property :email
    property :company
    property :occupation
    property :phone
    property :city

    property :facebook
    property :linkedin
    property :twitter

    property :file, virtual: true
    validates :file, 
      file_size: { less_than_or_equal_to: 3.megabytes },
      file_content_type: { allow: ['image/jpeg', 'image/png'] }
    extend Paperdragon::Model::Writer
    processable_writer :image
    property :image_meta_data, deserializer: { writeable: false }

    collection :events,
    prepopulator:      :prepopulate_events!,
    populate_if_empty: :populate_events!,
    skip_if:           :all_blank do
      property :number

      validates :number, presence: true
    end
      
    validates :firstname, :lastname, :email, presence: true
    validates :email, email: true

    private

    def prepopulate_events!(options)
      (3 - events.size).times { events.append(Event.new) }
    end

    def populate_events!(fragment:, **)
      Event.find_by(number: fragment["number"]) or Event.new
    end
  end
end
