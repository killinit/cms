RSpec.describe RevisionData do
  describe '.load' do
    let(:revision) { double }
    let(:loader) { double }

    it 'parses the revision and transform to a hash' do
      allow(::RevisionData::Loader).to receive(:new).with(revision).and_return(loader)
      expect(loader).to receive(:to_hash).and_return(id: 42)

      expect(RevisionData.load(revision)).to eq(id: 42)
    end
  end

  describe ::RevisionData::Loader do
    let(:revision) { double(data: revision_data) }
    subject(:loader) { described_class.new(revision) }

    describe '#author_name' do
      context 'when revision has author' do
        let(:revision) { double(author: double(name: 'Luke')) }

        it 'returns author name' do
          expect(loader.author_name).to eq('Luke')
        end
      end

      context 'when revision does not have author' do
        let(:revision) { double(author: nil) }

        it 'returns nil' do
          expect(loader.author_name).to be_nil
        end
      end
    end

    describe '#type' do
      context 'when event' do
        let(:revision_data) do
          {
            event: 'published'
          }
        end

        it 'returns "event"' do
          expect(loader.type).to eq('event')
        end
      end

      context 'when note' do
        let(:revision_data) do
          {
            note: 'Some note'
          }
        end

        it 'returns "note"' do
          expect(loader.type).to eq('note')
        end
      end

      context 'when blocks attributes' do
        let(:revision_data) do
          {
            blocks_attributes: [{
              identifier: 'content'
            }]
          }
        end

        it 'returns array' do
          expect(loader.type).to eq('blocks_attributes')
        end
      end
    end

    describe '#text' do
      context 'when event' do
        let(:revision_data) do
          {
            event: 'published'
          }
        end

        it 'returns the event status' do
          expect(loader.text).to eq('published')
        end
      end

      context 'when note' do
        let(:revision_data) do
          {
            note: 'Some note'
          }
        end

        it 'returns the content of the note' do
          expect(loader.text).to eq('Some note')
        end
      end

      context 'when blocks attributes' do
        let(:revision_data) do
          {
            blocks_attributes: [{
              identifier: 'content'
            }]
          }
        end

        it 'returns array' do
          expect(loader.text).to eq([{ identifier: 'content' }])
        end
      end
    end
  end
end
