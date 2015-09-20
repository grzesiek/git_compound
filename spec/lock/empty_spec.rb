# GitCompound
#
module GitCompound
  describe Lock do
    context 'lock exists and is empty' do
      before { FileUtils.touch(Lock::FILENAME) }

      it '::exist? should return true' do
        expect(Lock.exist?).to be true
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
  end
end
