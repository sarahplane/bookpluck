module ApplicationHelper
  def show_errors(object, field_name)
    if object.errors.any?
      if !object.errors.messages[field_name].blank?
       object.errors.messages[field_name].join(", ")
     end
   end
 end

 def organize_themes(theme_collection, matcher)
   theme_collection.select{ |theme| theme.name[0] == matcher }.sort_by{ |theme| theme.name.downcase }
 end
end
