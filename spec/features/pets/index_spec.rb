require 'rails_helper'

RSpec.describe 'Pets index page' do
  before :each do
    @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
    @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Longmont", state: "CO", zip: 80012)
    @shelter3 = Shelter.create!(name: "Shell Shelter", address: "102 Shelter Dr.", city: "Commerce City", state: "CO", zip: 80022)
    @pet1 = @shelter1.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
    @pet2 = @shelter2.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
    @pet3 = @shelter1.pets.create!(image:"", name: "Zeus", description: "dog", approximate_age: 4, sex: "male")
    @ms_jenkins    = Application.create!({name: 'Buttercup Jenkins', street: "101 Puppy Love Lane", city: 'Aurora', state: 'CO', zip: 80017, 
                                          description: 'I love dogs', status: 'In Progress'})
    @ms_sandpaper  = Application.create!({name: 'Sandy Sandpaper', street: "55 E Labradoodle St", city: 'Denver', state: 'CO', zip: 80237, 
                                          description: 'I have always wanted a dog', status: 'In Progress'})
    
    ApplicationPet.create!(application: @ms_jenkins, pet: @pet1)
    ApplicationPet.create!(application: @ms_jenkins, pet: @pet3)
  end

  it "displays each pet in the system with attributes" do
    visit "/pets"

    expect(page).to have_content(@pet1.image)
    expect(page).to have_content(@pet1.name)
    expect(page).to have_content(@pet1.approximate_age)
    expect(page).to have_content(@pet1.sex)
    expect(page).to have_content(@shelter1.name)

    expect(page).to have_content(@pet2.image)
    expect(page).to have_content(@pet2.name)
    expect(page).to have_content(@pet2.approximate_age)
    expect(page).to have_content(@pet2.sex)
    expect(page).to have_content(@shelter2.name)

    expect(page).to_not have_content(@shelter3.name)
  end

  it "can delete a pet from pet index page" do
    visit "/pets"

    within "#pet-#{@pet1.id}" do
      expect(page).to have_content("Thor")
      click_link "Delete Pet"
    end

    expect(current_path).to eq("/pets")
    expect(page).to_not have_content("Thor")
  end

  it "can edit a pet from pets index page" do
    visit '/pets'

    within "#pet-#{@pet1.id}" do
      expect(page).to have_content("Thor")
      click_link "Update Pet"
    end

    fill_in "name", with: "Calvin"

    click_button "Update Pet"

    expect(current_path).to eq("/pets/#{@pet1.id}")

    expect(page).to have_content("Calvin")
    expect(page).to_not have_content("Thor")
  end

  # User Story 2
  it 'I see/click a link Start an Application. Im taken to a new app page where I see/fill in a form with my info' do
    visit '/pets'

    expect(page).to have_link('Start an Application')
    
    click_on 'Start an Application'
    
    expect(current_path).to eq('/applications/new')

    fill_in 'Name:', with: "#{@ms_sandpaper.name}"
    fill_in 'Street Address:', with: "#{@ms_sandpaper.street}"
    fill_in 'City:', with: "#{@ms_sandpaper.city}"
    fill_in 'State:', with: "#{@ms_sandpaper.state}"
    fill_in 'Zip:', with: "#{@ms_sandpaper.zip}"
    fill_in 'Why are you a good fit?', with: "#{@ms_sandpaper.description}"

    click_on 'Submit'

    app_1 = Application.last

    # expect(current_path).to eq("/applications/#{app_1.id}")
    expect(current_path).to eq("/applications/#{app_1.id}")
    expect(@ms_sandpaper.status).to eq('In Progress')
    expect(page).to have_content(@ms_sandpaper.name)
    expect(page).to have_content(@ms_sandpaper.street)
    expect(page).to have_content(@ms_sandpaper.city)
    expect(page).to have_content(@ms_sandpaper.state)
    expect(page).to have_content(@ms_sandpaper.zip)
    expect(page).to have_content(@ms_sandpaper.description)
  end
end
