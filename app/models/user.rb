# == Schema Information
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  first_name           :string(50)
#  last_name            :string(50)
#  email                :string(100)     default(""), not null
#  created_at           :datetime
#  updated_at           :datetime
#  encrypted_password   :string(128)     default(""), not null
#  reset_password_token :string(255)
#  remember_created_at  :datetime
#  date_of_birth        :datetime
#  about                :text
#  gender               :string(1)       default("N")
#  homepage             :string(100)
#  country              :string(50)
#

class User < ActiveRecord::Base
  extend  Timeline::User
  include Timeline::User::Followers
  include Timeline::User::Recommandations
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable
  
  SERIALIZABLE = { :except  => [:first_name, :last_name, :encrypted_password, :remember_created_at, :reset_password_token],
                   :methods => [:id, :name, :age, :score] }
  
  attr_accessible :name, :login, :email, :date_of_birth, :about, :gender, :country, :homepage,
                  :remember_me, :password, :password_confirmation
                  
  has_many :recipes, :dependent => :destroy
  
  has_many :likes, :dependent => :destroy 
  has_many :liked_recipes,    :through => :likes,     :source => :recipe
  
  has_many :favorites, :dependent => :destroy 
  has_many :favorite_recipes, :through => :favorites, :source => :recipe
  
  has_many :histories, :dependent => :destroy 
  has_many :cooked_recipes,   :through => :histories, :source => :recipe
  
  acts_as_tagger
  
  NAME_REGEX   = /^[\p{Word}.\-]{2,50}[\s]*[\p{Word}.\-]{,50}$/ui
  EMAIL_REGEXP = /^[\p{Word}.%+\-]+@[\p{Word}.\-]+\.[\w]{2,}$/i
  validates :email, :presence   => { :message => "Veuillez remplir l'adresse de courriel" },
                    :uniqueness => { :message => "Cette adresse mail est prise", :case_sensitive => false, :allow_blank => true },
                    :format     => { :message => "L'adresse mail n'est pas valide", :with => EMAIL_REGEXP, :allow_blank => true }
  validates :password, :presence     => { :message => "Le mot de passe est absent" },
                       :confirmation => { :message => "La confirmation du mot de passe ne correspond pas au mot de passe" }
  validates :name, :format => { :with => NAME_REGEX, :message => "Le nom est invalide" }
  
  def to_param
    "#{id}-#{name.parameterize}"
  end
  
  timeline :my_feed, :self
  timeline :following_feed, :followers_ids
  timeline :general_feed, :all
  
  def to_s
    name
  end
  
  def name
    @name ||= [self.first_name, self.last_name].compact.join(" ")
  end

  def name=(name)
    self.first_name, self.last_name = name.split(/\s/, 2)
  end
  
  def score=(score)
    @score ||= score.to_i
  end
  
  def score
    @score
  end
  
  def age
    (Time.now.to_date - date_of_birth.to_date).to_i / 365 rescue nil
  end
  
  def likes?(recipe)
    self.likes.for(recipe).all.present?
  end
  
  def favorite?(recipe)
    self.favorites.for(recipe).all.present?
  end

  def serializable_hash(options={})
    #options = SERIALIZABLE.merge(options) unless options.nil?
    super(SERIALIZABLE)
  end
  
end
