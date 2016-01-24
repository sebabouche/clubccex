class InfiniteScrollTest < Trailblazer::Test::Integration
  feature "infinite-scrolling" do
    scenario "it scrolls", js: true do
      skip "61 users won't show on user page!"
      sign_in_as_admin!
      60.times { create_user! }
      puts "users: #{User.confirmed.count}"
      visit ("/users")
      page.must_have_css "profile-card", count: 25
      page.execute_script "window.scrollBy(0,10000)"
      page.must_have_css "profile-card", count: 50
    end
  end
end
