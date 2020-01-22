module Taggable
  extend ActiveSupport::Concern

  included do
    include TagSearchable
    taggable_on :tags
  end

  module ClassMethods
    def taggable_on(field_name)
      tag_searchable_on(field_name)
      tag_names = TagService.sanitize_tag_name(field_name)
      tag_name = tag_names.singularize

      default_search_methods(tag_name, tag_names).each do |search_method|
        scope search_method, -> (tags) { send("search_#{search_method}".to_sym, tags) }
      end

      class_eval %Q{
        # Convenient methods
        def #{tag_names}(user:)
          o = user.ownerships.find_by(bit: self)
          o.present? ? (o.#{tag_names} || []) : nil
        end

        def #{tag_name}_list(user:)
          #{tag_names}(user: user).try(:join, ', ')
        end
      }
    end
  end
end
