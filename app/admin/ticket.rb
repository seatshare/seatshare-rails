ActiveAdmin.register Ticket do

  permit_params :event_id, :group_id, :user_id, :owner_id, :alias_id, :event, :section, :row, :seat, :cost, :note

  filter :group
  filter :user
  filter :owner
  filter :alias
  filter :event
  filter :section
  filter :row
  filter :seat
  filter :cost
  filter :note

  index do
    selectable_column
    id_column
    column :group
    column :owner
    column :user
    column :event
    column :display_name
    column :cost do |ticket|
      number_to_currency ticket.cost
    end
    actions
  end

end
