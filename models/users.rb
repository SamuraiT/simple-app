require 'pry'
require "csv"

class User
  attr_accessor :name, :email, :profile, :tel
  FILENAME = "db/db.csv"
  
  def initialize(name, email, profile="", tel="")
    @name = name
    @email = email
    @profile = profile
    @tel = tel
  end

  def self.all(filename=User::FILENAME)
    UserCollection.from_csv(filename) 
  end

  def self.find(name, filename=User::FILENAME)
    self.all(filename).find(name)
  end

  def detail
    <<-DETAIL
    -----------
    name: #{@name} 
    email: #{@email} 
    profile: #{@profile} 
    tel: #{@tel}
    -----------
    DETAIL
  end

  def save(filename=User::FILENAME)
    CSV.open(filename,"a") do |row|
      row << attributes
    end
  end

  def attributes
    [@name, @email, @tel]
  end

  def inspect
    "name: #{@name} email: #{@email}"
  end

  def to_s
    "name: #{@name} email: #{@email}"
  end
end

class UserCollection
  attr_accessor :users
  def initialize(users=[])
    @users = users
  end

  def self.from_csv(filename)
    users = []
    CSV.foreach(filename) do |name, email, tel|
      users << User.new(name, email, "", tel)
    end
    UserCollection.new(users)
  end

  def puts_users
    @users.each do |user|
      puts user.detail
    end
  end

  def append(user)
    @users << user 
  end

  def find(name)
    found_users = []
    @users.each do |user|
      return user if user.name == name
    end

    raise "Not Found"
  end

  def where(name)
    found_users = []
    @users.each do |user|
      if user.name.include?(name)
        found_users << user
      end
    end

    return puts("Not found") if found_users.empty?
    
    found_users.each do |user|
      puts user.detail
    end
  end

  def [](i)
    @users
  end
  
  def first
    @users[0]
  end

  def last
    @users[-1]
  end
end
