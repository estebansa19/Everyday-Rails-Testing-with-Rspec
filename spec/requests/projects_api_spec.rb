require 'rails_helper'

RSpec.describe 'ProjectsApis', type: :request do
  it 'loads a project' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'Test name')
    FactoryBot.create(:project, name: 'Second project', owner: user)

    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    payload = JSON.parse(response.body)
    expect(response).to have_http_status(:success)
    expect(payload.length).to eql(1)

    project_id = payload.first['name']

    get api_projects_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    payload = JSON.parse(response.body)
    expect(response).to have_http_status(:success)
    expect(payload.first['name']).to eql('Second project')
  end

  it 'creates a project' do
    user = FactoryBot.create(:user)
    project_attributes = FactoryBot.attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status(:success)
  end

  it 'gets the last project' do
    user = FactoryBot.create(:user)
    FactoryBot.create_list(:project, 3, owner: user)

    get last_api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    payload = JSON.parse(response.body)
    expect(payload['id']).to eql(user.projects.last.id)
  end
end