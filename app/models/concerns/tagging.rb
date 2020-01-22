module Tagging
  extend ActiveSupport::Concern

  included do
    tagging_on :tags
  end

  module ClassMethods

    def tagging_on(field_name)
      tag_names = TagService.sanitize_tag_name(field_name)
      tag_name = tag_names.singularize

      before_save :"uniq_#{tag_names}"

      attr_accessor :"#{tag_name}_list" # virtual attribute

      class_eval %Q{
        def #{tag_name}_list
          self.tags.try(:join, ', ')
        end

        def #{tag_name}_list=(tag_list)
          self.tags = TagService.parse(tag_list)
        end
      }
    end
  end

    private

      def uniq_tags # before_save
        self.tags.try(:uniq!)
      end
end
