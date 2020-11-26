class Superadmin < Admin
  def initialize
    @login = 'superadmin'
  end

  def commands
    super + %w[load_user_pet kill reset change_owner_login change_life_states]
  end
end 