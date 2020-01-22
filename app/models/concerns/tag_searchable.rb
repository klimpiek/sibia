module TagSearchable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def tag_searchable_on(field_name)
      tag_names = TagService.sanitize_tag_name(field_name)
      tag_name = tag_names.singularize

      # Do not override by class
      scope :"search_with_any_#{tag_name}", ->(tags){ where("#{tag_names} && ARRAY[?]", TagService.parse(tags)) }
      scope :"search_with_all_#{tag_names}", ->(tags){ where("#{tag_names} @> ARRAY[?]", TagService.parse(tags)) }
      scope :"search_without_any_#{tag_name}", ->(tags){ where.not("#{tag_names} && ARRAY[?]", TagService.parse(tags)) }
      scope :"search_without_all_#{tag_names}", ->(tags){ where.not("#{tag_names} @> ARRAY[?]", TagService.parse(tags)) }
      scope :"search_all_#{tag_names}", -> { select("unnest('#{tag_names}')").uniq.pluck(tag_names).compact }
  
      # Can be override by class to include **joins** and other SQL command
      default_search_methods(tag_name, tag_names).each do |search_method|
        scope search_method, -> (tags) { send("search_#{search_method}".to_sym, tags) } 
      end
    end

    # return default search methods with singluar and plural forms
    def default_search_methods(tag_name, tag_names)
      [ "with_any_#{tag_name}",
        "with_all_#{tag_names}",
        "without_any_#{tag_name}",
        "without_all_#{tag_names}",
        "all_#{tag_names}" ]
    end
  end
end
