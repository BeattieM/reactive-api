# Controller for Post specific endpoints
class V1::PostsController < ApplicationController
  before_action :authenticate_api_user, except: [:index]

  def index
    render json: Post.all.order(id: :desc), each_serializer: V1::Posts::PostSerializer
  end

  def create
    post = Post.new(comment: post_params[:comment], user: current_user, pokemon: retrieve_pokemon)
    return render_model_errors(post.errors, :unprocessable_entity) unless post.save
    broadcast(post, 'create')
    head :ok
  end

  def update
    post = current_user.posts.find_by_uuid(params[:id])
    return render_item_not_found('Post') unless post
    post.update_attributes(post_params)
    broadcast(post, 'update')
    head :ok
  end

  def destroy
    post = current_user.posts.find_by_uuid(params[:id])
    return render_item_not_found('Post') unless post
    post.destroy
    broadcast(post, 'delete')
    head :ok
  end

  private

  def post_params
    params.require(:post).permit(:comment)
  end

  def retrieve_pokemon
    PokemonService.search_for_pokemon
  end

  def broadcast(post, action)
    ActionCable.server.broadcast 'posts',
                                 data: format_for_action_cable(post),
                                 action: action
  end

  def format_for_action_cable(post)
    ActiveModelSerializers::Adapter.create(V1::Posts::PostSerializer.new(post)).as_json[:data]
  end
end
