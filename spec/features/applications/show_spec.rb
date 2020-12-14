require 'rails_helper'

RSpec.describe 'As a visitor', type: :feature do
  describe 'when I visit the application show page' do
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

    # User story 1
    it 'I can see the name, address, reason for application, name of all the pets on application, and the status' do
      visit "/applications/#{@ms_jenkins.id}"

      expect(page).to have_content(@ms_jenkins.name)
      expect(page).to have_content(@ms_jenkins.street)
      expect(page).to have_content(@ms_jenkins.city)
      expect(page).to have_content(@ms_jenkins.state)
      expect(page).to have_content(@ms_jenkins.zip)
      expect(page).to have_content(@ms_jenkins.description)
      expect(page).to have_content(@ms_jenkins.status)
      expect(page).to have_link('Thor')
      expect(page).to have_link('Zeus')
    end

    # User story 4 
    describe 'And that application has not been submitted' do
      it 'Then I see a section on the page to Add a Pet where I can search for Pets by 
        name and after under the search bar I see any Pet whose name matches my search' do
        
        visit "/applications/#{@ms_jenkins.id}"

        expect(page).to have_content('Add a Pet!')
        expect(page).to have_content('Search for Pet by Name')
        
        fill_in 'Search for Pet by Name', with: "#{@pet1.name}"
        click_on 'Search'

        expect(current_path).to eq("/applications/#{@ms_jenkins.id}")
        expect(page).to have_content("#{@pet1.name}")
      end
    end
  end
end