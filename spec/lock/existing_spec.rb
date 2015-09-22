require 'lock/shared_context/lock_file'

# GitCompound
#
module GitCompound
  describe Lock do
    context 'lock exists and is valid' do
      include_context 'existing lockfile'

      it 'should return valid lock content' do
        expect(subject.contents).to be_instance_of Hash
        expect(subject.contents.count).to eq 2
        expect(subject.contents).to include :manifest, :components
        expect(subject.contents[:components].first)
          .to include :name, :sha, :source, :destination
      end

      it 'should lock manifest with valid md5sum' do
        expect(subject.manifest).to eq '123123123123'
      end

      it 'should instantiate components' do
        expect(subject.components.first).to be_instance_of Component
        expect(subject.components.first == subject.components.last).to be true
      end

      it 'should instantiate valid component' do
        locked_component = subject.components.first
        expect(locked_component.name).to eq :component_2
        expect(locked_component.version.to_s)
          .to eq "sha: #{component.metadata[:tag_v1_2_sha][0..7]}"
        expect(locked_component.path)
          .to eq 'component_2_test/destination_1/'
      end

      it 'should find locked component' do
        component_dir = component.origin
        test_component = Component.new(:component_2) do
          branch 'master'
          source component_dir
          destination 'component_2_test/destination_2/'
        end

        found = subject.components.find(test_component) do |locked|
          locked.origin == test_component.origin
        end

        expect(found).to be_an_instance_of Component
      end

      context 'locking new component' do
        let(:new_component) do
          component_dir = component.origin
          Component.new(:component_2) do
            version '=1.2'
            source component_dir
            destination '/some/component_2_new_test_destination'
          end
        end

        it 'should be able to lock new components properly' do
          subject.lock_component(new_component)
          expect(subject.components.count).to eq 3
        end

        it 'should be able to append newly locked component' do
          subject.lock_component(new_component)
          subject.write
          new_contents = File.read(Lock::FILENAME)
          expect(new_contents).to eq \
            "---\n" \
            ":manifest: '123123123123'\n" \
            ":components:\n" \
            "- :name: :component_2\n" \
            "  :sha: #{component.metadata[:tag_v1_2_sha]}\n" \
            "  :source: \"#{component.origin}\"\n" \
            "  :destination: component_2_test/destination_1/\n" \
            "- :name: :component_2\n" \
            "  :sha: #{component.metadata[:tag_v1_2_sha]}\n" \
            "  :source: \"#{component.origin}\"\n" \
            "  :destination: component_2_test/destination_2/\n" \
            "- :name: :component_2\n" \
            "  :sha: #{component.metadata[:tag_v1_2_sha]}\n" \
            "  :source: \"#{component.origin}\"\n" \
            "  :destination: some/component_2_new_test_destination/\n"
        end
      end
    end
  end
end
