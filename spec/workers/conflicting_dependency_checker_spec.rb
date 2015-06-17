# GitCompound
#
module GitCompound
  describe Worker::ConflictingDependencyChecker do
    before do
      git_build_test_environment!

      component_dir = @base_component_dir
      @component = Component.new(:base_component) do
        branch 'master'
        source component_dir
        destination '/some/destinaton'
      end
    end

    context 'conflicting depenendecy does not exist' do
      it 'should not raise error' do
        expect { @component.process(described_class) }
          .to_not raise_error
      end
    end

    context 'conflicting dependency exists' do
      before do
        git() do
          git_commit('Compoundfile with conflicting dependency')
          git_tag('1.1', '1.1 version tag')
        end
      end

      it 'should raise error when conflicting depenendecy is found' do
        expect { @component.process(described_class) }
          .to raise_error ConflictingDependencyError
      end
    end
  end
end
