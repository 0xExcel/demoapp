require 'spec_helper'

describe 'User' do
  before { @user = User.new name: "testing", email: "foo@bar.com", password: "abcdefg", password_confirmation: "abcdefg"}
  subject { @user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password_digest }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :authenticate }
  it { should be_valid }

  describe "No username present" do
    before { @user.name = nil }
    it {should_not be_valid }
  end

  describe "Username too long" do
    before { @user.name = "a"*26 }
    it { should_not be_valid }
  end

  describe "No email present" do
    before { @user.email = nil }
    it { should_not be_valid }
  end

  describe "Email in wrong format" do
    before { @user.email = "lelelelatstuff##" }
    it {should_not be_valid }
  end

  describe "Duplicate email" do
    before do
      dup_user = @user.dup
      dup_user.email = @user.email
      dup_user.save
    end

    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
end