class User::Cell::Decorator < Cell::Concept
  extend Paperdragon::Model::Reader
  processable_reader :image
  property :image_meta_data

  def thumb
    image_tag image[:thumb].url if image.exists?
  end
end
