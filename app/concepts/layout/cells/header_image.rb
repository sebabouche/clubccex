class Layout::Cell::HeaderImage < Cell::Concept
  inherit_views Layout::Cell

  def show
    render :header_image
  end

  private

  def image_url
    model
  end

  def headline
    options[:headline]
  end
end

