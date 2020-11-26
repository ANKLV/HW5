require 'rubygems'
require 'bundler'
require_relative 'pet'
require_relative 'panda'
require_relative 'tiger'
require_relative '../users/session'
require 'gem_html'

class Ui
  def start
    init_user
    @pet = user_pet
    html = PetHtml.new(@pet)
    html.open_html
   while true      
      if @pet.is_dead? 
        @pet.response << "Your pet is dead. "
        @img = '&#128561;'
        break
      end   
      command = enter_command
      @pet.response = []
      case command
      when 'feed'
        @pet.feed
        update_html
      when 'water'
        @pet.water       
        update_html
      when 'toilet'
        @pet.toilet
        update_html
      when 'sleep'
        @pet.sleep
        update_html
      when 'play'
        @pet.play
        update_html
      when 'status'
        p @pet
      when 'observe'
        @pet.random
        update_html
      when 'load_user_pet'
        @pet = load_somebodys_pet(@user.login)
        update_html
      when 'change_name'
        @pet.change_name(@user.login)
        update_html
      when 'change_type'
        pet = @pet.change_type(@user.login) 
        @pet = pet if pet
        @pet.save
        update_html
      when 'change_owner_login'
        @pet.change_user_login(@user.login)
        update_html
      when 'reset'
        pet = @pet.reset(@user.login) 
        @pet = pet if pet
        @pet.save
        update_html
      when 'change_life_states'
        @pet.change_life_states(@user.login)
        update_html
      when 'kill'
        @pet.kill(@user.login)
        update_html
      when 'exit'
        break
      else
        p "unknown command: #{command}"
      end 
    end
  end
  
  def init_pet
    puts 'Please, enter you`r pet`s name? '
    name = gets.chomp
    puts 'Choose panda or tiger, please'
    type = gets.chomp.downcase
    if type == 'panda'
      pet = Panda.new(name, @user.login)
    elsif type == 'tiger'
      pet = Tiger.new(name, @user.login)
    else
      puts 'Don`t know this pet'
    end
    puts "Hi i'm your #{pet.class}. My name is #{pet.name}."
    pet
  end

  def init_user
    puts 'Please, enter you`r login: '
    login = gets.chomp.downcase
    puts 'Please, enter you`r password: '
    password = gets.chomp.downcase
    @user = Session.new(login, password).log_in  
    init_user unless @user
  end

  def has_pet?
    File.exists?("./data/#{@user.login}.yml")
  end

  def load_pet
    YAML.load(File.read("./data/#{@user.login}.yml"))
  end

  def user_pet
    has_pet? ? load_pet : init_pet
  end

  def enter_command
    puts 'choose a command, please: '
    puts @user.commands.join(', ')    
    command = gets.strip.downcase
  end

  def update_html
    PetHtml.new(@pet).make_html
  end

  def load_somebodys_pet(user_login)
    return puts("not_allowed".red) unless @pet.is_user_admin?(user_login)
    puts 'Enter login of user, which pet to load, please: '
    login = gets.strip.downcase
    YAML.load(File.read("./data/#{login}.yml"))
  end
end

Ui.new.start