require 'rails_helper'

RSpec.describe V1::PostsController, type: :controller do
  let(:user) { authenticate_a_user }
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

  describe 'GET #index' do
    it 'responds successfully with an HTTP 200 status code' do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create without being logged in' do
    it 'should not have a current_user' do
      expect(subject.current_user).to eq(nil)
    end

    it 'fails to create a new Post object and responds with an HTTP 401 status code' do
      comment = Faker::Lorem.sentence
      allow(PokemonService).to receive(:search_for_pokemon).and_return(FactoryGirl.create(:pokemon))
      post :create, params: { post: { comment: comment } }

      expect(response).to have_http_status(401)
      expect(Post.first).to eq(nil)
    end
  end

  describe 'POST #create while being logged in' do
    it 'creates a new Post object and responds successfully with an HTTP 200 status code' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }

      comment = Faker::Lorem.sentence
      allow(PokemonService).to receive(:search_for_pokemon).and_return(FactoryGirl.create(:pokemon))
      post :create, params: { post: { comment: comment } }

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(Post.first.comment).to eq(comment)
      expect(Post.first.user).to eq(subject.current_user)
    end
  end

  describe 'PATCH #update an existing Post' do
    it 'successfully updates the Post' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      post1 = FactoryGirl.create(:post, user: user)
      patch :update, params: { id: post1.uuid, post: { comment: 'updated' } }

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(Post.first.comment).to eq('updated')
    end
  end

  describe 'PATCH #update another users Post' do
    it 'fails to update the Post' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      post1 = FactoryGirl.create(:post)
      patch :update, params: { id: post1.uuid, post: { comment: 'updated' } }

      expect(response).not_to be_success
      expect(response).to have_http_status(404)
    end
  end

  describe 'PATCH #update a nonexistent Post' do
    it 'fails to update the Post' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      patch :update, params: { id: 'bad_uuid', post: { comment: 'updated' } }

      expect(response).not_to be_success
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE #destroy an existing Post' do
    it 'successfully flags the Post as deleted' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      post1 = FactoryGirl.create(:post, user: user)
      delete :destroy, params: { id: post1.uuid }

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(Post.count).to eq(0)
      expect(Post.with_deleted.count).to eq(1)
    end
  end

  describe 'DELETE #destroy another users Post' do
    it 'fails to delete the Post' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      post1 = FactoryGirl.create(:post)
      delete :destroy, params: { id: post1.uuid }

      expect(response).not_to be_success
      expect(response).to have_http_status(404)
    end
  end

  describe 'DELETE #destroy a nonexistent Post' do
    it 'fails to delete the Post' do
      allow(controller).to receive(:doorkeeper_token).at_least(:once) { token }
      delete :destroy, params: { id: 'bad_uuid' }

      expect(response).not_to be_success
      expect(response).to have_http_status(404)
    end
  end
end
