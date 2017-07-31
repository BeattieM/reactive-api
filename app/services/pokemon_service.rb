# Object for interacting with the Pokemon API
module PokemonService
  class << self

    # Search for and return a random Pokemon
    #
    # @return [Pokemon] already existing in the database or newly created from the Pokemon API
    def search_for_pokemon
      random = random_pokemon
      @pokemon = Pokemon.find_by_name(random['name'])
      attempt_catch_pokemon(random['url']) if @pokemon.nil?
      @pokemon
    end

    private

    # Query the Pokemon API for a random Pokemon
    #
    # @return [Hash] containing the random Pokemon detail endpoint
    def random_pokemon
      HTTParty.get("http://pokeapi.co/api/v2/pokemon/?offset=#{random_offset}&limit=1").parsed_response['results'].first
    end

    # Query the Pokemon API for details on a specific Pokemon
    # If the current Pokemon doesn't have a front_default sprite find another Pokemon
    #
    # @param url [String] the detail endpoint for a Pokemon
    # @return [Hash] containing the pokedex details of a Pokemon
    def attempt_catch_pokemon(url)
      pokedex_entry = HTTParty.get(url).parsed_response
      pokedex_entry['sprites']['front_default'].nil? ? search_for_pokemon : store_pokemon(pokedex_entry)
    end

    # Save a Pokemon to the database
    #
    # @param pokedex_entry [Hash] the pokedex details of a Pokemon
    # @return [Pokemon] containing the newly saved Pokemon
    def store_pokemon(pokedex_entry)
      @pokemon = Pokemon.create(pokedex_id: pokedex_entry['id'],
                                name: pokedex_entry['name'],
                                sprite: pokedex_entry['sprites']['front_default'])
    end

    # Generates a random number in the offset range available to the Pokemon API
    #
    # @return [Integer] of the offset to query against
    def random_offset
      rand(0..810)
    end
  end
end
