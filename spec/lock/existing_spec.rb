require 'lock/shared_context/lock_file'

# GitCompound
#
module GitCompound
  describe Lock do
    context 'lock exists and is valid' do
      include_context 'existing lockfile'

      it 'should return valid lock content' do
        expect(@lock.contents).to be_instance_of Hash
        expect(@lock.contents.count).to eq 2
        expect(@lock.contents).to include :manifest, :components
        expect(@lock.contents[:components].first)
          .to include :name, :sha, :source, :destination
      end

      it 'should lock manifest with valid md5sum' do
        expect(@lock.manifest).to eq '123123123123'
      end

      it 'should instantiate components' do
        expect(@lock.components.first).to be_instance_of Component
        expect(@lock.components.first == @lock.components.last).to be true
      end

      it 'should instantiate valid component' do
        component = @lock.components.first
        expect(component.name).to eq :component_2
        expect(component.version.to_s)
          .to eq "sha: #{@component_2_commit_tag_v1_2_sha[0..7]}"
        expect(component.destination_path)
          .to eq 'component_2_test/destination_1/'
      end

      it 'should find locked component' do
        component_dir = @component_2_dir
        component = Component.new(:component_2) do
          branch 'master'
          source component_dir
          destination 'component_2_test/destination_2/'
        end

        found = @lock.find(component) { |locked| locked.origin == component.origin }
        expect(found).to be_an_instance_of Component
      end

      context 'locking new component' do
        before do
          component_dir = @component_2_dir
          @new_component = Component.new(:component_2) do
            version '=1.2'
            source component_dir
            destination '/some/component_2_new_test_destination'
          end
        end

        it 'should be able to lock new components properly' do
          @lock.lock_component(@new_component)
          expect(@lock.components.count).to eq 3
        end

        it 'should be able to append newly locked component' do
          @lock.lock_component(@new_component)
          @lock.write
          new_contents = File.read(Lock::FILENAME)
          expect(new_contents).to eq \
            "---\n" \
            ":manifest: '123123123123'\n" \
            ":components:\n" \
            "- :name: :component_2\n" \
            "  :sha: #{@component_2_commit_tag_v1_2_sha}\n" \
            "  :source: \"#{@component_2_dir}\"\n" \
            "  :destination: component_2_test/destination_1/\n" \
            "- :name: :component_2\n" \
            "  :sha: #{@component_2_commit_tag_v1_2_sha}\n" \
            "  :source: \"#{@component_2_dir}\"\n" \
            "  :destination: component_2_test/destination_2/\n" \
            "- :name: :component_2\n" \
            "  :sha: #{@component_2_commit_tag_v1_2_sha}\n" \
            "  :source: \"#{@component_2_dir}\"\n" \
            "  :destination: some/component_2_new_test_destination/\n"
        end
      end
    end
  end
end
