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

        panel "System Stats" do
          h4 "Records"
          ul do
            li "#{Entity.all.count} entities, #{Entity.active.count} active"
            li "#{User.all.count} users, #{User.active.count} active"
            li "#{Event.all.count} events"
            li "#{Ticket.all.count} tickets"
          end
          para "Running from #{Rails.root}"
          para %(#{`git status | sed -n 1p`} - #{link_to(`git rev-parse --short HEAD`, "https://github.com/stephenyeargin/seatshare-rails/commit/#{`git rev-parse HEAD`}")}).html_safe
        end

      end

      column do

        panel "Recent Users" do
          table do
            thead do
              th "User"
              th "Joined"
            end
            tbody do
              User.last(5).map do |user|
                tr :class => cycle('even', 'odd') do
                  td link_to(user.display_name, admin_user_path(user))
                  td user.created_at.strftime('%-m/%-d/%Y')
                end
              end
            end
          end
        end

        panel "Recent Groups" do
          table do
            thead do
              th "Group"
              th "Members"
              th "Entity"
              th "Created"
            end
            tbody do
              Group.last(5).map do |group|
                tr :class => cycle('even', 'odd') do
                  td link_to(group.group_name, admin_group_path(group))
                  td group.users.count
                  td auto_link(group.entity)
                  td group.created_at.strftime('%-m/%-d/%Y')
                end
              end
            end
          end
        end

        panel "Upcoming's Events" do
          table do
            thead do
              th "Group"
              th "Entity"
              th "Time"
            end
            tbody do
              Event.order_by_date.where("start_time > '#{Date.today}'").first(5).map do |event|
                tr :class => cycle('even', 'odd') do
                  td link_to(event.event_name, admin_event_path(event))
                  td auto_link(event.entity)
                  td event.date_time
                end
              end
            end
          end
        end

      end

    end
  end # content
end
