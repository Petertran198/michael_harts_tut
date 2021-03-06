class User < ApplicationRecord
  #create  accessible attributes
  attr_accessor :remember_token, :activation_token
  #dependent: :destroy arranges for the dependent microposts to be destroyed when the user itself is destroyed
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy

  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy                                
  has_many :following, through: :active_relationships, source: :followed
  
  has_many :followers, through: :passive_relationships
                              
  before_save   :downcase_email
  before_create :create_activation_digest
  #create an accessible attribute

  before_save { email.downcase! }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                                   format: {with: VALID_EMAIL_REGEX },
                                   uniqueness: { case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true



  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  # Returns a random token for remembering a user via cookies.
  #uses the built-in  SecureRandom.urlsafe_base64 provided by ruby 
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  #.digest is a built-in ruby method that crytopgraphically secure the remember_token
  #remeber_digest is an attribute we stored in the schema
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest. 
  #remember_token in this context is just a local variable not the same as the ones above
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end


  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end



end
