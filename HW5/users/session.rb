require_relative 'user.rb'
require_relative 'admin.rb'
require_relative 'superadmin.rb'

class Session

  def initialize(login, password)
    @login = login
    @password = password
  end

  def log_in
    if is_admin?
      user = Admin.new 
    elsif  is_superadmin?
      user = Superadmin.new
    else
      user = User.new(@login, @password)
      if user.exists?(user.load_users)
        if user.correct?(user.load_users)
          p "your pet here"
        else 
          p 'incorrect user'
          return nil
        end
      else
        user.save
      end
    end
    user
  end

  private 

  def is_admin?
    @login == 'admin' && @password == 'admin1234'
  end

  def is_superadmin?
    @login == 'superadmin' && @password == 'superadmin1234'
  end
end