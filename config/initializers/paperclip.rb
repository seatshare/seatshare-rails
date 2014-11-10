# Group
Paperclip.interpolates(:placeholder_group) do |attachment, style|
  ActionController::Base.helpers.asset_path("group-#{style}-missing.png")
end