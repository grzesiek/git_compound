# GitCompound
#
module GitCompound
  describe Lock do
    context 'lock exists and is empty' do
      before do
        FileUtils.touch(Lock::FILENAME)
        @lock = Lock.new
      end

      it '::exist? should return true' do
        expect(Lock.exist?).to be true
      end

      it 'should be empty hash' do
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
  end
end
