namespace :seatshare do
  desc "Create an AdminUser"
  task :create_admin_user, [:email, :password] => [:environment] do |t, args|
    args.with_defaults(:email => "admin@example.com", :password => "changeme")

    AdminUser.create([
      {
        email: args.email,
        password: args.password,
        password_confirmation: args.password
      }
    ])

    puts "Account created:"
    puts ""
    puts "  Email: #{args.email}"
    puts "  Password: #{args.password}"
    puts ""
  end
end
