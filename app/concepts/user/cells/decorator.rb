class User::Cell::Decorator < User::Cell
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

  def linkname
    name_link = link_to fullname, path
    name_link += link_to " (éditer)", edit_user_path(model), class: "small" if this_is_me?
    name_link
  end

  def path
    user_path(model)
  end

  def fullname
    if nickname.present?
      firstname + "\"" + nickname + "\"" + lastname
    else
      firstname + " " + lastname
    end

  end

  def megafullname
    if maidenname.present? 
      mfn = fullname + "<em>(" + maidenname + ")</em>"
    else
      mfn = fullname
    end
    mfn += link_to " (éditer)", edit_user_path(model), class: "small" if this_is_me?
    mfn
  end

  def phone_email
    pe = ""
    if phone.present?
      pe << "<i class='glyphicon glyphicon-phone'></i> #{phone} | "
    end
    pe << "<i class='glyphicon glyphicon-envelope'></i> #{email}"
    pe
  end

  def work
    work = occupation if occupation.present?
    work << " @ #{company}" if company.present?
    work
  end

  def sum_up
    su = ""
    su << event_list if events?
    su << " <i class='fa fa-anchor text-danger'></i> " if work? and events?
    su << work if work?
  end

  def event_list
    event_list = ""
    events.each_with_index do |e, i|
      event_list << e.number.to_s
      event_list << " | " if i+1 < events.size
    end
    event_list
  end

  def work?
    occupation.present? or company.present?
  end

  def events?
    events.present?
  end
  
  def created_at
    "Membre du Club depuis " + time_ago_in_words(super)
  end

  def unconfirmed?
    @model.confirmed == 0
  end

  def confirm_button
    link_to "Confirmer cet utilisateur", 
      confirm_user_path(@model), 
      class: "btn btn-success btn-xs" if unconfirmed?
  end
end
