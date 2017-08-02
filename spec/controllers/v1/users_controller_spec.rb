require 'rails_helper'

describe V1::UsersController do
  let(:user) { authenticate_a_user }
  let(:unauthed_user) { FactoryGirl.create(:user) }
  let(:user_params) do
    {
      user: {
        email: 'test@test.test',
        password: 'testpass',
        password_confirmation: 'testpass'
      }
    }
  end
  let(:token) do
    double(
      revoked?: false,
      expired?: false,
      accessible: true,
      acceptable: true,
      scopes: [:show, :create],
      resource_owner_id: user.id
    )
  end

  describe 'POST #create' do
    let(:good_user) { double(save: true) }
    let(:bad_user) { double(save: false, errors: 'errors') }

    describe 'user saves successfully' do
      it 'creates user tokens' do
        expect(controller).to receive(:create_doorkeeper_access_token)
        allow(controller).to receive(:slice_token)
        post :create, params: user_params
      end

      it 'returns access tokens' do
        allow(controller).to receive(:create_doorkeeper_access_token) { 'access token' }
        expect(controller).to receive(:slice_token).with('access token') { 'sliced token' }
        post :create, params: user_params
        expect(response.code).to eq '201'
      end
    end

    it 'returns error if user fails save' do
      bad_params = user_params
      bad_params['password_confirmation'] = nil
      post :create, params: bad_params
      expect(response.code).to eq '201'
    end
  end

  describe 'POST #sign_in' do
    it 'can not find the user' do
      post :sign_in, params: json_params(email: 'bad@email.com')
      expect(response.code).to eq '401'
      expect(json['errors'][0]).to eq 'title' => 'Credentials', 'detail' => 'are invalid'
    end

    it 'gets the wrong password' do
      post :sign_in, params: json_params(email: user.email, password: 'bad')
      expect(response.code).to eq '401'
      expect(json['errors'][0]).to eq 'title' => 'Credentials', 'detail' => 'are invalid'
    end

    it 'successfully ' do
      post :sign_in, params: json_params(email: user.email, password: user.password)
      expect(response.code).to eq '200'
      expect(json['data'].keys).to eq %w(access_token refresh_token user_id)
    end
  end

  describe 'POST #sign_out' do
    describe 'authenticated' do
      before(:each) do
        allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      end

      it 'revokes the doorkeeper token' do
        allow(controller).to receive(:find_most_recent_doorkeeper_access_token).at_least(:once) { token }
        expect(token).to receive(:revoke)
        post :sign_out
        expect(response.code).to eq '204'
      end
    end
  end
end
