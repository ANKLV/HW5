require 'yaml'

class User
  
  attr_accessor :login, :password

  def initialize(login, password)
    @login = login
    @password = password
  end

  def commands
     %w[feed play water toilet sleep status observe exit]
  end

  def exists?(users_array)
    users_array.any? { |h| h[:login] == @login }
  end

  def correct?(users_array)
    users_array.any? { |h| h[:login] == @login && h[:password] == @password }    
  end

  def save
    user = {
      login: @login,
      password: @password,
      role: self.class.to_s
    }
    users_array = load_users

    if !exists?(users_array)
      users_array << user
      File.open('./data/users.yml', 'w') { |file| file.puts(users_array.to_yaml) }
    end  
  end

  def load_users
    YAML.load(File.read('./data/users.yml')) || []
  rescue
    []
  end
end