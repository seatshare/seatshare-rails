ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do

      column do
        panel "Upcoming's Events" do
          ul do
            Event.where("start_time > '#{Date.today}'").first(5).map do |event|
              li link_to(event.display_name, admin_event_path(event))
            end
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
      end

    end
  end # content
end
