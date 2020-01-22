module Tagger
  extend ActiveSupport::Concern

  included do
    tagging_on :tags
  end

  module ClassMethods
    def tagging_on(field_name)
      tag_names = TagService.sanitize_tag_name(field_name)
      class_eval %Q{
        # Convenient methods
        def #{tag_names}
          self.bits.select("unnest('bits.#{tag_names}')").pluck(:#{tag_names}).flatten.uniq.compact
        end
      }
    end
  end
end
