host "myseatshare.com"

# Default public routes
sitemap :site do
  url "https://#{host}#{root_url}", last_mod: Time.now, change_freq: "daily", priority: 1.0
  url "https://#{host}#{contact_path}", last_mod: Time.now, change_freq: "weekly", priority: 0.8
  url "https://#{host}#{privacy_path}", last_mod: Time.now, change_freq: "weekly", priority: 0.8
  url "https://#{host}#{tos_path}", last_mod: Time.now, change_freq: "weekly", priority: 0.8
  url "https://#{host}#{new_user_registration_path}", last_mod: Time.now, change_freq: "weekly", priority: 0.8
end

# League / team routes
for entity_type in EntityType.all
  sitemap_for Entity.where("entity_type_id = #{entity_type.id}").active, name: "#{entity_type.entity_type_name.parameterize}".to_sym do |entity|
    url "https://#{host}#{register_with_entity_id_path(nil, { :entity_slug => entity.display_name.parameterize, :entity_id => entity.id})}", last_mod: entity.updated_at, change_freq: "weekly", priority: 0.7
  end
end

# Notify the search engine(s)
ping_with "https://#{host}/sitemap.xml"