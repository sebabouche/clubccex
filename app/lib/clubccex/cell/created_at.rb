module Clubccex::Cell
  module CreatedAt
    def self.included(base)
      base.send :include, ActionView::Helpers::DateHelper
    end

    private

    def created_at
      time_ago_in_words(super)
    end

    def has_posted_at
      content_tag :em do
        content_tag(:span, "a posté il y a ") +
        created_at
      end
    end

    def was_created_at
      content_tag :em do
        content_tag(:span, "créé il y a ") +
        created_at
      end
    end

    def has_answered_at
      content_tag :em do
        content_tag(:span, "a répondu il y a ") +
        created_at
      end
    end
  end
end
