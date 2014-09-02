require "spec_helper"

describe Pet do

  # before(:each) do
  #   shelter_user.reload
  # end

  let(:pet) { Pet.new }

  describe '.generate_pet' do

    before(:all) do
      shelter_user = User.find_by(:display_name => 'Pet Shelter')
      @pet = Pet.generate_pet(shelter_user.id)
    end
    
    it 'creates a pet' do
      @pet.should be_a(Pet)
    end

    it 'populates the pet with a random gender' do
      @pet.gender.should be_a_member_of([true, false])
    end

  end

  describe '.pet_shelter_pets' do

    let(:shelter_user) { User.find_by(:display_name => 'Pet Shelter') }

    before :all do
      Pet.pet_shelter_pets
    end

    it 'generates up to 15 pets' do
      expect(Pet.where(:user_id => shelter_user.id)).to have_at_least(10).records
    end

  end

  describe '#stat' do

    it 'returns an integer' do
      pet.stamina.should be_an(Integer)
    end

    it 'updates when stat updates' do
      pet.stamina = 2
      pet.stamina.should == 2
    end

  end

  describe '#stat=' do

    it 'sets the stat attribute' do
      pet.stamina = 5
      pet.stamina.should == 5
    end

    it 'raises an error when it doesn\'t receive a numeric' do
      expect{
        pet.stamina = 'BLAH'
      }.to raise_error(TypeError)
    end

    it 'evaluate the same with a passed in float' do
      pet.stamina = 5
      first_value = pet.stamina
      pet.stamina = 5.0
      pet.stamina.should == first_value
    end

  end


  describe '#stat_training' do

    it 'returns an integer' do
      pet.stamina_training.should be_an(Integer)
    end

    it 'returns the currently set training' do
      pet.stamina = 1
      pet.stamina_training = 5
      pet.stamina_training.should == 5
    end

  end


  describe '#stat_training=' do

    it 'rounds training down to below next-level-training' do
      pet.stamina = 0
      pet.stamina_training = 11
      pet.stamina_training.should == 9
    end

    it 'raises an error when not passed a numeric' do
      expect{
        pet.stamina_training = 'BLAH'
      }.to raise_error(TypeError)
    end

  end

  describe '#stat_train' do

    it 'increases the stat training' do
      pet.stamina = 0
      pet.stamina_training = 6
      pet.stamina_train(1)
      pet.stamina_training.should == 7
    end

    it 'raises an error when not passed a numeric' do
      expect{
        pet.stamina_train 'BLAH'
      }.to raise_error(TypeError)
    end

  end


  describe '#level' do

    it 'returns an integer' do
      pet.level.should be_an(Integer)
    end

    it 'returns total of default stats values' do
      pet.level.should == 1
    end

    it 'updates when stats update' do
      pet.stamina = 1.0
      pet.level.should == 2
    end

  end


  describe '#sleep?' do

    it 'returns true or false' do
      pet.send(:sleep?).should be_a_member_of([true, false])
    end

    it 'returns false when energy is high' do
      pet.energy = 12
      pet.send(:sleep?).should be_false
    end

    it 'returns true when energy is really low' do
      pet.energy = 0
      pet.send(:sleep?).should be_true
    end

  end


  describe '#desire_to_eat' do

    it 'returns an integer' do
      pet.send(:desire_to_eat).should be_an(Integer)
    end

  end


  describe '#skill_dice' do

    it 'returns an integer' do
      pet.send(:skill_dice, :crafting).should be_an(Integer)
    end

  end

  describe '#successes' do

    it 'returns an integer' do
      pet.send(:successes, 1).should be_an(Integer)
    end

    it 'does not return a value higher than the parameter' do
      pet.send(:successes, 10).should <= 10
    end

  end

  describe '#max_energy' do

    it 'returns an integer' do
      pet.send(:max_energy).should be_an(Integer)
    end

    it 'is at least 12' do
      pet.send(:max_energy).should >= 12
    end

    it 'increases as stamina increases' do
      first_value = pet.send(:max_energy)
      pet.stamina = pet.stamina+1
      pet.send(:max_energy).should > first_value
    end

    it 'increases as strength increases' do
      first_value = pet.send(:max_energy)
      pet.strength = pet.strength+1
      pet.send(:max_energy).should > first_value
    end

    it 'increases as athletics increases' do
      first_value = pet.send(:max_energy)
      pet.athletics = pet.athletics+1
      pet.send(:max_energy).should > first_value
    end

  end

  describe '#max_food' do

    it 'returns an integer' do
      pet.send(:max_food).should be_an(Integer)
    end

    it 'is at least 12' do
      pet.send(:max_food).should >= 12
    end

    it 'increases as stamina increases' do
      first_value = pet.send(:max_food)
      pet.stamina = pet.stamina+1
      pet.send(:max_food).should > first_value
    end

    it 'increases as survival increases' do
      first_value = pet.send(:max_food)
      pet.survival = pet.survival+1
      pet.send(:max_food).should > first_value
    end

  end

end