class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  # default_scope :includes => :user_rights

  validates_presence_of :display_name, :username
  validates_uniqueness_of :display_name, :username

  belongs_to :avatar, polymorphic: true
 
  has_one :house, dependent: :destroy
  has_many :pets
  has_many :items, dependent: :destroy
  has_many :store_transactions, dependent: :destroy
  
  has_many :posts  
  has_many :topics
  has_many :internal_mails, dependent: :destroy, foreign_key: :to_user_id

  has_many :sent_item_trades, foreign_key: :user_1_id
  has_many :recieved_item_trades, foreign_key: :user_2_id

  has_many :favor_transactions

  has_one :pattern_user

  has_one :user_statistic

  has_one :user_badge

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :generate_data
  before_destroy :shelter_pets

  self.per_page = 25

  def earn_interest

  end

  def generate_data
    Pet.generate_pet(id)
    self.house = House.create({user_id: id, last_hour_run: Time.now - 25.hours})
    self.user_badge = UserBadge.create({user_id: id})
    self.last_active = self.created_at
    self.save
  end

  def shelter_pets
    Pet.update_all({user_id: User.shelter_user_id},{user_id: id})
  end

  def self.shelter_user_id
    @@_shelter_user_id ||= User.find_by(username: 'petshelter').id
  end

  def has_incoming
    self.items.to_a.count { |item| item.location == 2 } > 0
  end

  def has_notification
    self.has_incoming || self.has_unseen_mail || self.city_hall_notice || self.has_new_sales || self.has_new_stars
  end

  def update_last_active
    if self.last_active.to_i != Time.now.to_i
      self.last_active = Time.now
      save
    end
  end

  def user_stats
    UserStatistic.find_by(user_id: id) || UserStatistic.new(user_id: id)
  end

end
