class Admin < User
  
  def initialize
    @login = 'admin'
  end

  def commands
    super + %w[load_user_pet change_type change_name]
  end

end