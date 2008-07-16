class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :c_mail
      t.string :c_password
      t.string :identity_url

      t.timestamps
    end

    account_yml = ENV['HOME'] + '/.nicovideo/account.yml'
    if File.exists?(account_yml)
      require 'yaml'
      yml = YAML.load_file(account_yml)
      account = Account.create(:mail => yml['mail'], :password => yml['password'])
      puts "account created: #{account.inspect}"
    end
  end

  def self.down
    drop_table :accounts
  end
end
