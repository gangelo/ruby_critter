# frozen_string_literal: true

RSpec.describe RubyCritter::Sprites::SpriteBase do
  subject(:sprite_base) do
    described_class.new(sprite_id: sprite_id, options: options, **sprite_data)
  end

  let(:sprite_id) { generated_sprite_id }
  let(:options) { {} }
  let(:sprite_data) do
    described_class::DEFAULT_ATTRIBUTES.merge(
      {
        state: described_class::INITIAL_STATE,
        sprite_name: "Sprite #{sprite_id}"
      }
    )
  end

  describe '#initialize' do
    context 'when the options are provided' do
      it_behaves_like 'no error is raised'
    end

    context 'when the options are not provided' do
      let(:options) { nil }

      it_behaves_like 'no error is raised'
    end

    context 'when the sprite_id is not provided' do
      let(:sprite_id) { nil }

      it 'generates a sprite_id' do
        expect(sprite_base.sprite_id).to_not be_nil
      end
    end

    context 'when the sprite exists' do
      before do
        create(:sprite_base, sprite_id: sprite_id, sprite_data: sprite_data)
      end

      it 'loads the sprite' do
        sprite = described_class.new(sprite_id: sprite_id, options: options, **sprite_data)

        expect(sprite_base).to eq(sprite)
        expect(sprite_base.sprite_id).to eq(sprite.sprite_id)
      end
    end

    context 'when the sprite exists but new attributes are passed' do
      before do
        create(:sprite_base, sprite_id: sprite_id, sprite_data: sprite_data)
      end

      let(:new_state) { :alive }

      it 'loads the sprite but retains the new attributes' do
        sprite_base_changed = described_class.new(sprite_id: sprite_base.sprite_id, options: options, state: new_state)

        expect(sprite_base).to_not eq(sprite_base_changed)
        expect(sprite_base.unborn?).to be true
        expect(sprite_base_changed.alive?).to be true
        expect(sprite_base.sprite_id).to eq(sprite_base_changed.sprite_id)
      end
    end
  end

  describe '#==' do
    it 'ignores the sprite_id in the equality check' do
      different_sprite_id_sprite = described_class.new(sprite_id: "1#{sprite_id}", options: options, **sprite_data)

      expect(sprite_base.sprite_id == different_sprite_id_sprite.sprite_id).to be(false)
      expect(sprite_base == different_sprite_id_sprite).to be(true)
    end

    context 'when the sprites are equal' do
      it 'returns true' do
        same_sprite = described_class.new(sprite_id: sprite_id, options: options, **sprite_data)
        expect(sprite_base == same_sprite).to be(true)
      end
    end

    context 'when the sprites are not equal' do
      it 'returns false' do
        different_sprite = described_class.new(sprite_id: sprite_base.sprite_id, options: options, **sprite_data)
        different_sprite.birth!
        expect(sprite_base == different_sprite).to be(false)
      end
    end
  end

  describe '#hash' do
    it 'returns the hash of the sprite' do
      expected_hash = sprite_data.values.map(&:hash).hash
      expect(sprite_base.hash).to eq(expected_hash)
    end
  end

  describe '#sprite_id' do
    it 'returns the sprite name' do
      expect(sprite_base.sprite_id).to eq(sprite_id)
    end
  end

  describe '#state' do
    it 'returns the sprite state' do
      expect(sprite_base.state).to eq(sprite_data[:state])
    end
  end

  describe '#state=' do
    it 'sets the sprite state and aasm current_state' do
      expect(sprite_base.state).to be :unborn
      expect(sprite_base.unborn?).to be true
      sprite_base.state = :alive
      expect(sprite_base.state).to be :alive
      expect(sprite_base.alive?).to be true
    end
  end

  describe '#to_h' do
    it 'returns a hash of the sprite' do
      expect(sprite_base.to_h).to eq(sprite_data)
    end
  end

  describe 'class methods' do
    describe '.find' do
      subject(:sprite_base_find) do
        described_class.find(sprite_id: sprite_id, options: options)
      end

      context 'when the sprite is found' do
        it 'returns the sprite' do
          sprite = create(:sprite_base, sprite_id: sprite_id, sprite_data: sprite_data)
          expect(sprite_base_find).to eq(sprite)
        end
      end

      context 'when the sprite is not found' do
        let(:expected_error) { RubyCritter::Errors::SpriteNotFound }

        it_behaves_like 'an error is raised'
      end
    end
  end

  describe 'state machines' do
    describe 'state' do
      describe 'states' do
        it 'has an initial state of :unborn' do
          expect(described_class::INITIAL_STATE).to eq(:unborn)
          expect(sprite_base.unborn?).to be true
        end

        it 'has three states' do
          expect(described_class.aasm(:state).states.map(&:name)).to eq(%i[unborn alive dead])
        end

        describe 'birth event' do
          it 'transitions from :unborn to :alive' do
            expect(sprite_base).to transition_from(:unborn).to(:alive).on_event(:birth).on(:state)
          end
        end

        describe 'die event' do
          subject(:sprite_base) do
            build(:sprite_base, :alive, sprite_id: sprite_id, options: options, **sprite_data)
          end

          it 'transitions from :alive to :dead' do
            expect(sprite_base).to transition_from(:alive).to(:dead).on_event(:die).on(:state)
          end
        end

        describe 'resurrect event' do
          subject(:sprite_base) do
            build(:sprite_base, :dead, sprite_id: sprite_id, options: options, **sprite_data)
          end

          it 'transitions from :dead to :alive' do
            expect(sprite_base).to transition_from(:dead).to(:alive).on_event(:resurrect).on(:state)
          end
        end
      end
    end

    describe 'level' do
      it 'has an initial state of :one' do
        expect(described_class::INITIAL_LEVEL).to eq(:one)
        expect(sprite_base.one?).to be true
      end

      it 'has 10 states' do
        expect(described_class.aasm(:level).states.map(&:name)).to eq(%i[one two three four five six seven eight nine ten])
      end

      describe 'level predicate methods' do
        it "has a 'level_<level>?' predicate method for each level" do
          described_class::LEVEL_RANGES.each_key do |level|
            expect(sprite_base).to respond_to(:"level_#{level}?")
          end
        end
      end

      describe 'level_up event' do
        context 'when the #experience_points are not enough to level up' do
          before do
            sprite_base.birth!
          end

          it 'is alive' do
            expect(sprite_base.alive?).to be true
          end

          it 'does not allow level up' do
            described_class.aasm(:level).states.map(&:name).each do |level|
              sprite_base.level = level
              sprite_base.experience_points = described_class::LEVEL_RANGES[level].first
              expect(sprite_base).to_not allow_event(:level_up).on(:level)
            end
          end
        end

        context 'when the #experience_points are enough to level up' do
          before do
            sprite_base.birth!
          end

          it 'is alive' do
            expect(sprite_base.alive?).to be true
          end

          it 'allows level up from level :one to :two' do
            sprite_base.level = :one
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
            sprite_base.level_up!
            expect(sprite_base.two?).to be true
          end

          it 'allows level up from level :two to :three' do
            sprite_base.level = :two
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :three to :four' do
            sprite_base.level = :three
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :four to :five' do
            sprite_base.level = :four
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :five to :six' do
            sprite_base.level = :five
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :six to :seven' do
            sprite_base.level = :six
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :seven to :eight' do
            sprite_base.level = :seven
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :eight to :nine' do
            sprite_base.level = :eight
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'allows level up from level :nine to :ten' do
            sprite_base.level = :nine
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to allow_event(:level_up).on(:level)
          end

          it 'does not allows level up past level :ten' do
            sprite_base.level = :ten
            sprite_base.experience_points = described_class::LEVEL_RANGES[sprite_base.level].last + 1
            expect(sprite_base).to_not allow_event(:level_up).on(:level)
          end
        end
      end
    end
  end
end
