class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets
  validates_presence_of :name, :street, :city, :state, :zip, :description
  enum status: ['In Progress', 'Pending', 'Approved', 'Rejected']

  def pet_names
    pets.pluck(:name)
  end
end 