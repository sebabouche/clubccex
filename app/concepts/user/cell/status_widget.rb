class User::Cell::StatusWidget < User::Cell
  inherit_views User::Cell

  def show
    if profile_empty?
      render :status_profile_empty
    elsif !profile_completed?
      render :status_profile_almost_done
    elsif posts.count == 0
      render :status_no_post
    else
      ""
    end
  end
end
