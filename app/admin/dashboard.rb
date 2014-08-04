ActiveAdmin.register_page "Dashboard" do

  contact_form_messages = HTTParty.get("http://getsimpleform.com/messages.json?api_token=#{ENV['SIMPLE_FORM_API_TOKEN']}").first(5) || []

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    columns do

      column do

        panel "Recent Contact Messages" do
          div do
            if !contact_form_messages.nil? && contact_form_messages.count > 0
              for message in contact_form_messages
                h4 mail_to(message["data"]["email"], message["data"]["name"] + " - " + message["data"]["email"])
                div do
                  simple_format "#{message["data"]["message"]}"
                end
                div "#{message["created_at"]} - #{message["request_ip"]}"
                hr
              end
            else
              div "No messages available."
              hr
            end
          end
          div :style => "text-align: right" do
            link_to("Manage Messages", "http://getsimpleform.com/messages?api_token=#{ENV['SIMPLE_FORM_API_TOKEN']}", :target => "_blank")
          end
        end

      end

      column do

        panel "Recent Users" do
          ul do
            User.last(5).map do |user|
              li link_to(user.full_name, admin_user_path(user))
            end
          end
        end

        panel "Recent Groups" do
          ul do
            Group.last(5).map do |group|
              li link_to(group.group_name, admin_group_path(group))
            end
          end
        end

        panel "Upcoming's Events" do
          ul do
            Event.where("start_time > '#{Date.today}'").first(5).map do |event|
              li link_to(event.display_name, admin_event_path(event))
            end
          end
        end

      end

    end
  end # content
end
