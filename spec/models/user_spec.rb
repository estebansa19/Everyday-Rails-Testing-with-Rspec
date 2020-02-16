require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.build(:user) }

  # Compact versions

  it { is_expected.to validate_presence_of :first_name }
  it { is_expected.to validate_presence_of :last_name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to satisfy { |user| user.name == 'Pepe Calavera' } }

  it 'is valid with a first name, last name, email, and password' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a first name' do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it 'is invalid without a last name' do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it 'is invalid with a duplicate email address' do
    FactoryBot.create(:user, email: 'pepe@calavera.com')
    user = FactoryBot.build(:user, email: 'pepe@calavera.com')
    user.valid?
    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'is invalid without an email address' do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "returns a user's full name as a string" do
    user = FactoryBot.build(:user, first_name: 'pepe', last_name: 'calavera')
    expect(user.name).to eql('pepe calavera')
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it 'sends a welcome email on account creation' do
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it 'performs geocoding', vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: '161.185.207.20')

    expect {
      user.geocode
    }.to change(user, :location).from(nil).to('Brooklyn, New York, US')
  end
end
