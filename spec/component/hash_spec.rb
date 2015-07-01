# GitCompound
#
module GitCompound
  describe Component do
    describe '#to_hash' do
      before do
        git_create_component_2

        component_dir = @component_2_dir
        @component = Component.new(:component_2) do
          version '=1.2'
          source component_dir
          destination '/component_2_test_destination'
        end
      end

      it 'should return valid hash' do
        hash = @component.to_hash
        expect(hash).to eq(
          component_2: {
            sha: @component_2_commit_tag_v1_2_sha,
            source: @component_2_dir,
            destination: 'component_2_test_destination/'
          }
        )
      end
    end
  end
end
