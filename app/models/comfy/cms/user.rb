class Comfy::Cms::User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  has_many :revisions, class_name: 'Comfy::Cms::Revision', foreign_key: 'author_id'
end
