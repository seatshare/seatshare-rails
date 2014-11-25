ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do

    columns do

      column do

        panel 'Recent Contact Messages' do
          token = ENV['SIMPLE_FORM_API_TOKEN']
          contact_form_messages = HTTParty.get(
            "http://getsimpleform.com/messages.json?api_token=#{token}"
          ).first(5) || []

          div do
            if !contact_form_messages.nil? && contact_form_messages.count > 0
              contact_form_messages.each do |message|
                h4 mail_to(
                  message['data']['email'],
                  message['data']['name'] + ' - ' + message['data']['email']
                )
                div do
                  simple_format "#{message['data']['message']}"
                end
                div "#{message['created_at']} - #{message['request_ip']}"
                hr
              end
            else
              div 'No recent messages. '\
                'Messages sent through the contact form appear here.'
              hr
            end
          end
          div style: 'text-align: right' do
            token = ENV['SIMPLE_FORM_API_TOKEN']
            link_to(
              'Manage Messages',
              "http://getsimpleform.com/messages?api_token=#{token}",
              target: '_blank'
            )
          end
        end

        panel 'Twilio' do
          client = TwilioSMS.new

          attributes_table_for :usage do
            usage = client.sms_usage
            if usage.is_a? String
              row 'Error' do
                usage
              end
            else
              usage.each do |record|
                puts usage.inspect
                row record.description do
                  text_node "#{record.count} #{record.usage_unit} "\
                    "/ #{record.price} #{record.price_unit.upcase}"
                end
              end
            end
          end

          attributes_table_for :messages do
            usage = client.recent_messages
            if usage.is_a? String
              row 'Error' do
                usage
              end
            else
              usage[0, 5].each do |record|
                row "To: #{record.to} ; From: #{record.from} ;"\
                  " #{record.date_sent}".html_safe do
                    text_node "#{record.body}"
                  end
              end
            end
          end

        end

        panel 'System Stats' do
          attributes_table_for :stats do
            row 'Entities' do
              Entity.all.count
            end
            row 'Active Entities' do
              Entity.active.count
            end
            row 'Users' do
              User.all.count
            end
            row 'Active Users' do
              User.active.count
            end
            row 'Events' do
              Event.all.count
            end
            row 'Tickets' do
              Ticket.all.count
            end
          end
        end
      end

      column do

        panel 'Recent Users' do
          table do
            thead do
              th 'User'
              th 'Email'
              th 'Joined'
            end
            tbody do
              User.all.order('created_at DESC').first(5).map do |user|
                tr class: cycle('even', 'odd') do
                  td link_to(user.display_name, admin_user_path(user))
                  td mail_to(user.email, user.email)
                  td user.created_at.strftime('%-m/%-d/%Y')
                end
              end
            end
          end
        end

        panel 'Recent Groups' do
          table do
            thead do
              th 'Group'
              th 'Members'
              th 'Entity'
              th 'Created'
            end
            tbody do
              Group.all.order('created_at DESC').limit(5).map do |group|
                tr class: cycle('even', 'odd') do
                  td link_to(group.group_name, admin_group_path(group))
                  td group.users.count
                  td auto_link(group.entity)
                  td group.created_at.strftime('%-m/%-d/%Y')
                end
              end
            end
          end
        end

        panel 'Upcoming Events' do
          table do
            thead do
              th 'Event'
              th 'Entity'
              th 'Date & Time'
            end
            tbody do
              Event.order_by_date.where(
                "start_time > '#{Date.today}'"
              ).limit(5).map do |event|
                tr class: cycle('even', 'odd') do
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
