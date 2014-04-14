require 'test_helper'

class UserAliasTest < ActiveSupport::TestCase
  test "new user alias has attributes" do
    user_alias = UserAlias.new({
      user_id: 1,
      first_name: 'Amanda',
      last_name: 'Goodlaw'
    })

    assert user_alias.first_name === 'Amanda', 'new user alias first name matches'
    assert user_alias.last_name === 'Goodlaw', 'new user alias last name matches'
    assert user_alias.full_name === 'Amanda Goodlaw', 'new user alias full name matches'
    assert user_alias.user_id === 1, 'new user alias user ID matches'
  end

  test "fixture user alias has attributes" do
    user_alias = UserAlias.find(1)

    assert user_alias.first_name === 'Kevin', 'fixture user alias first name matches'
    assert user_alias.last_name === 'Jones', 'fixture user alias last name matches'
    assert user_alias.full_name === 'Kevin Jones', 'new user alias full name matches'
    assert user_alias.user_id === 4, 'fixture user alias user ID matches'
  end

end
