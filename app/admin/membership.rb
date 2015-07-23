ActiveAdmin.register Membership do

  belongs_to :member, class_name: 'User'
  belongs_to :group

end
