class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #devise :database_authenticatable,:registerable,
         #:recoverable, :rememberable, :validatable

  devise :database_authenticatable,
         :jwt_authenticatable,
        :registerable,
        jwt_revocation_strategy: JwtDenylist

end
