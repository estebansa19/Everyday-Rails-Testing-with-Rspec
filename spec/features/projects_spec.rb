require 'rails_helper'

RSpec.feature 'Projects', type: :feature, new: true do
  include LoginSupport
  let(:user) { FactoryBot.create(:user) }

  scenario 'user creates a new project' do
    sign_in user
    visit root_path

    expect {
      click_link 'New Project'
      fill_in 'Name',	with: 'Test Project'
      fill_in 'Description',	with: 'Trying out Capybara'
      click_button 'Create Project'
    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end

  scenario 'user edits a project' do
    project = FactoryBot.create(:project, owner: user, name: 'Project 1')
    sign_in user
    visit root_path

    expect {
      click_link 'Project 1'
      click_link 'Edit'
      fill_in 'Name', with: 'Project 123'
      fill_in 'Description', with: 'Some description'
      click_button 'Update Project'
      expect(page).to have_content 'Project 123'
      expect(project.reload.name).to eql('Project 123')
    }
  end

  scenario 'user completes a project' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    sign_in user

    visit project_path(project)
    expect(page).to_not have_content('Completed')
    click_button 'Complete'

    expect(project.reload.completed?).to be(true)
    expect(page).to have_content('Congratulations, this project is complete!')
    expect(page).to have_content('Completed')
    expect(page).to_not have_button('Complete')
  end
end
