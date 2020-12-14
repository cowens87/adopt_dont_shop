require 'rails_helper'

RSpec.describe Application, type: :model do
  before(:each) do
    @shelter1    = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2    = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
    @shelter3    = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
    @pet1        = @shelter1.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
    @pet2        = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
    @pet3        = @shelter1.pets.create!(image:"", name: "Zeus", description: "dog", approximate_age: 4, sex: "male")
    @ms_jenkins  = Application.create!({name: 'Buttercup Jenkins', street: "101 Puppy Love Lane", city: 'Aurora', state: 'CO', zip: 80017, 
                                        description: 'I love dogs', status: 'In Progress'})
    ApplicationPet.create!(application: @ms_jenkins, pet: @pet1)
    ApplicationPet.create!(application: @ms_jenkins, pet: @pet3)
  end

  describe 'validations' do
    it { should validate_presence_of :name}
    it { should validate_presence_of :street}
    it { should validate_presence_of :city}
    it { should validate_presence_of :state}
    it { should validate_presence_of :zip}
    it { should validate_presence_of :description}
  end

  describe 'relationships' do
    it {should have_many(:pets).through(:application_pets)}
  end

  describe 'Pet Names on Application' do
    it 'knows the names of pets on the application' do
      expect(@ms_jenkins.pet_names).to eq([@pet1.name, @pet3.name])
    end
  end
end