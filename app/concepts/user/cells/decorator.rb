class User::Cell::Decorator < Cell::Concept
  extend Paperdragon::Model::Reader
  processable_reader :image
  property :image_meta_data

  include Sprockets::Rails::Helper
  self.assets_prefix = Rails.application.config.assets.prefix
  self.assets_environment = Rails.application.assets
  self.digest_assets = Rails.application.config.assets[:digest]

  def thumb
    # TODO missing image
    if image.exists?
      image_tag image[:thumb].url, class: "img-circle"
    else
      "<div class='img-missing missing-thumb'></div>"
    end
  end

  def medium
    # TODO missing image
    if image.exists?
      image_tag image[:medium].url, class: "img-circle"
    else
      "<div class='img-missing missing-medium'></div>"
    end
  end
end
