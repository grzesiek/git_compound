# GitCompound
#
module GitCompound
  describe Lock do
    context 'lock does not exist' do
      it '::exist? should return false' do
        expect(Lock.exist?).to be false
      end

      it 'should initialize hash' do
        expect(subject.contents).to eq manifest: '', components: []
      end

      it 'should return empty manifest md5sum' do
        expect(subject.manifest).to be_empty
      end

      it 'should return empty array of components' do
        expect(subject.components).to be_empty
        expect(subject.components).to be_instance_of Array
      end
    end

    after do
      FileUtils.rm(Lock::FILENAME) if
        Lock.exist?
    end
  end
end
