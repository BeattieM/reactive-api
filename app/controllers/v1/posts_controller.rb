# Controller for Post specific endpoints
class V1::PostsController < ApplicationController
  before_action :authenticate_api_user, except: [:index]

  def index
    render json: Post.all.order(id: :desc), each_serializer: V1::Posts::PostSerializer
  end

  def create
    post = Post.new(comment: post_params[:comment], user: current_user, pokemon: PokemonService.search_for_pokemon)
    return unless post.save
    broadcast(post, 'create')
    head :ok
  end

  def update
    post = current_user.posts.find_by_uuid(params[:id])
    if post
      post.update_attributes(post_params)
      broadcast(post, 'update')
      head :ok
    else
      head 404
    end
  end

  def destroy
    post = current_user.posts.find_by_uuid(params[:id])
    if post
      post.destroy
      broadcast(post, 'delete')
      head :ok
    else
      head 404
    end
  end

  private

  def post_params
    params.require(:post).permit(:comment)
  end

  def broadcast(post, action)
    ActionCable.server.broadcast 'posts',
                                 data: ActiveModelSerializers::Adapter.create(V1::Posts::PostSerializer.new(post)).as_json[:data],
                                 action: action
  end
end
