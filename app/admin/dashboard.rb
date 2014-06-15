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

      # column do
      #   panel "Recent Posts" do
      #     ul do
      #       Post.recent(5).map do |post|
      #         li link_to(post.title, admin_post_path(post))
      #       end
      #     end
      #   end
      # end

      column do
        panel "Welcome to SeatShare Admin!" do
          para "Use this tool to manage Events and Entities, as well as users and group."
        end
      end

      column do
        panel "About Dashboard Modules" do
          para "These can be configured in the codebase to show more information. See `app/admin/dashboard.rb`."
        end
      end

    end
  end # content
end
