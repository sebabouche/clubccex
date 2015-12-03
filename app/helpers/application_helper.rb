module ApplicationHelper

  ### Titre de la page
  def title(page_title = '')
    default_title = "#{ENV['APP_NAME_HUMAN']}"
    if page_title.empty?
      default_title
    else
      "#{page_title} - #{base_title}"
    end
  end

  ### Description de la page
  def description(page_description = '')
    base_description = "Appcustom Description"
    if page_description.empty?
      base_description
    else
      "#{page_description}"
    end
  end
  
  ### Image de la page ou default
  def image(page_image = '')
    default_image = asset_url "/images/main/main.jpg"
    if page_image.empty?
      default_image
    else
      asset_url "#{page_image}"
    end
  end

  ### Flash Message translation
  def alert_class_for(flash_type)
    {
      :success => 'alert-success',
      :error => 'alert-danger',
      :alert => 'alert-warning',
      :notice => 'alert-info'
    } [flash_type.to_sym] || flash_type.to_s
  end

end
