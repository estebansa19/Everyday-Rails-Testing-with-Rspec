require 'rails_helper'

RSpec.describe Project, type: :model do

  #compact

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id) }

  before(:all) do
    @user = FactoryBot.create(:user)
    @project = @user.projects.create(name: 'Test project')
  end

  it 'does not allow duplicate project names per user' do
    new_project = @user.projects.build(name: 'Test project')
    new_project.valid?
    expect(new_project.errors[:name]).to include('has already been taken')
  end

  it 'allow two users to share a project name' do
    other_user = User.create(
      first_name: 'juan',
      last_name: 'perez',
      email: 'juan@calavera.com',
      password: 'juan-perez-123'
    )

    other_project = other_user.projects.build(name: 'Test project')
    expect(other_project).to be_valid
  end

  describe 'notes relation' do
    it 'can have many notes' do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.size).to eql(5)
    end
  end

  describe 'late status' do
    it 'returns true if due is late' do
      @project.update(due_on: Date.yesterday)
      expect(@project.late?).to eql(true)
    end

    it 'is late when due date is past today' do
      project = FactoryBot.create(:project, :due_yesterday)
      expect(project).to be_late
    end

    it 'is on time when due date is today' do
      project = FactoryBot.create(:project, :due_today)
      expect(project).to_not be_late
    end

    it 'is on time when due date is in the future' do
      project = FactoryBot.create(:project, :due_tomorrow)
      expect(project).to_not be_late
    end
  end
end
