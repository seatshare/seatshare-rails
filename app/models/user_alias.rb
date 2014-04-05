class UserAlias < ActiveRecord::Base
  belongs_to :users

  validates :first_name, :last_name, :user_id, :presence => true

  def self.get_by_user_id(user_id=nil)
    if user_id.class != Fixnum
      raise "InvalidUserId"
    end
    user_aliases = UserAlias.where("user_id = #{user_id}")
    return user_aliases
  end

end
