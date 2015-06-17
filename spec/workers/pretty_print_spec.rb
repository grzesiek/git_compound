# Git compound
#
module GitCompound
  describe Worker::PrettyPrint do
    before do
      git_build_test_environment!

      manifest_contents = File.read("#{@base_component_dir}/Compoundfile")
      @manifest = Manifest.new(manifest_contents)
    end

    it 'should pretty-print dependency tree' do
      expect { @manifest.process(described_class.new) }
        .to output(
          "`component_1` component, gem version: ~>1.1\n" \
          "  `leaf_component_1` component, gem version: 1.0\n"      \
          "  `leaf_component_2` component, gem version: 1.0\n"      \
          "`component_2` component, gem version: 1.1\n"   \
          "  `leaf_component_3` component, gem version: ~>1.0\n"      \
        ).to_stdout
    end
  end
end
