# GitCompound
#
module GitCompound
  describe Lock do
    context 'lock does not exist' do
      before { @lock = Lock.new }

      it '::exist? should return false' do
        expect(Lock.exist?).to be false
      end

      it 'should initialize empty hash' do
        expect(@lock.contents).to be_empty
        expect(@lock.contents).to be_instance_of Hash
      end

      it 'should return nil manifest' do
        expect(@lock.manifest).to eq nil
      end

      it 'should return empty array of components' do
        expect(@lock.components).to be_empty
        expect(@lock.components).to be_instance_of Array
      end
    end

    after do
      FileUtils.rm(Lock::FILENAME) if
        Lock.exist?
    end
  end
end
