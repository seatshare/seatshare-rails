host "myseatshare.com"

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0
  url contact_path, last_mod: Time.now, change_freq: "weekly", priority: 0.8
  url privacy_path, last_mod: Time.now, change_freq: "weekly", priority: 0.8
  url tos_path, last_mod: Time.now, change_freq: "weekly", priority: 0.8
  url new_user_registration_path, last_mod: Time.now, change_freq: "weekly", priority: 0.8
end

sitemap_for Entity.active, name: :teams do |entity|
  url register_with_entity_id_path(nil, { :entity_slug => entity.display_name.parameterize, :entity_id => entity.id}), last_mod: entity.updated_at, change_freq: "weekly", priority: 0.7
end

ping_with "https://#{host}/sitemap.xml"