ActiveAdmin.register_page 'Dashboard' do

  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        
        panel 'Groups Without Upcoming Events' do
          table do
            thead do
              th 'Group'
              th 'Entity'
              th 'Provider'
            end
            tbody do
              Group.active.by_name.each do |g|
                events = g.events.where('start_time > ?', Time.zone.now)
                if events.count == 0
                  tr class: cycle('even', 'odd') do
                    td link_to(g.display_name, admin_group_path(g))
                    td link_to(g.entity.display_name, admin_entity_path(g.entity))
                    td do
                      if g.entity.seatgeek?
                        link_to('SeatGeek', seatgeek_import_admin_entity_path(g.entity))
                      end                     
                    end
                  end
                end
              end
            end
          end
        end
        
        panel 'Twilio' do
          client = TwilioSMS.new
          h3 'Account Summary'
          usage = client.sms_usage
          if usage.is_a? String
            h4 usage
          else
            attributes_table_for :usage do
              usage.each do |record|
                next if record.price == '0'
                row record.description do
                  if record.description != 'Total Price'
                    text_node "#{record.count} #{record.usage_unit} / "
                  end
                  text_node "#{record.price.to_f} #{record.price_unit.upcase}"
                end
              end
            end
          end
          h3 'Recent Messages'
          usage = client.recent_messages
          if usage.is_a? String
            h4 usage
          else
            table_for usage[0, 5] do
              column 'Sender' do |message|
                "#{message.from} via #{message.direction}"
              end
              column 'Recipient' do |message|
                message.to
              end
              column 'Sent' do |message|
                Time.parse(message.date_sent).strftime(
                  '%B %-d, %Y %-I:%M %P %Z'
                )
              end
              column 'Message' do |message|
                message.body
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
            row 'Entity Types' do
              EntityType.all.count
            end
            row 'Users' do
              User.all.count
            end
            row 'Active Users' do
              User.active.count
            end
            row 'Groups' do
              Group.all.count
            end
            row 'Group Invitations' do
              GroupInvitation.all.count
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
              th 'Groups'
              th 'Joined'
            end
            tbody do
              User.all.order('created_at DESC').first(5).map do |user|
                tr class: cycle('even', 'odd') do
                  td link_to(user.display_name, admin_user_path(user))
                  td mail_to(user.email, user.email)
                  td user.groups.count
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
                  td group.members.count
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
              Event.future.by_date.limit(5).map do |event|
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
