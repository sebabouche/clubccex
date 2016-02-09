class Post < ActiveRecord::Base
  class Update < Create
    model Post, :update
    policy Clubccex::Policy, :this_is_mine?

    contract do
      property :closed
      property :category, writeable: false
      property :user_id, writeable: false
    end
  end
end
