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
    assert user_alias.user_id === 1, 'new user alias user ID matches'
  end

  test "fixture user alias has attributes" do
    user_alias = UserAlias.find(1)

    assert user_alias.first_name === 'Kevin', 'fixture user alias first name matches'
    assert user_alias.last_name === 'Jones', 'fixture user alias last name matches'
    assert user_alias.user_id === 4, 'fixture user alias user ID matches'
  end

  test "get user aliases by user ID" do
    user_aliases = UserAlias.get_by_user_id(2)

    assert user_aliases[0].class.to_s === 'UserAlias', 'object class matches'
    assert user_aliases.count === 2, 'user alias count matches'
  end

end
