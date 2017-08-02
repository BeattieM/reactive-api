require 'rails_helper'

RSpec.describe PokemonService do
  describe 'Search for a Pokemon' do
    let(:service) { PokemonService }
    it 'finds an existing Pokemon' do
      pokemon = FactoryGirl.create(:pokemon)
      expect(service).to receive(:random_pokemon).and_return('name' => pokemon.name, 'url' => 'http://www.example.com')
      expect(service).to_not receive(:attempt_catch_pokemon)

      expect(service.search_for_pokemon).to eq(pokemon)
    end

    it 'catches a new Pokemon' do
      pokemon_name = Faker::Pokemon.name
      pokedex_entry = { 'id' => 1, 'name' => pokemon_name, 'sprites' => { 'front_default' => 'http://www.example_2.com' } }
      httparty_response = double 'response'
      expect(service).to receive(:random_pokemon).and_return('name' => pokemon_name, 'url' => 'http://www.example.com')
      expect(HTTParty).to receive(:get).with('http://www.example.com').and_return(httparty_response)
      expect(httparty_response).to receive(:parsed_response).and_return(pokedex_entry)

      pokemon = service.search_for_pokemon
      expect(pokemon.name).to eq(pokemon_name)
      expect(pokemon.sprite).to eq('http://www.example_2.com')
      expect(Pokemon.count).to eq(1)
    end
  end
end
