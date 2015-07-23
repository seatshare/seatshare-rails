# Group
Paperclip.interpolates :placeholder_group do |attachment, style|
  eta = attachment.instance.entity.entity_type.entity_type_abbreviation.downcase
  image_path = File.join 'entity_types', "#{eta}-group-#{style}-missing.png"
  if File.exists?(File.join(Rails.root, 'app', 'assets', 'images', image_path))
    ActionController::Base.helpers.asset_path image_path
  else
    ActionController::Base.helpers.asset_path("group-#{style}-missing.png")
  end
end
