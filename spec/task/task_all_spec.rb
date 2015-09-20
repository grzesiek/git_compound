# GitCompound
#
module GitCompound
  describe Task::TaskAll do
    before { create_all_components! }
    let(:manifest) { manifest! }

    subject do
      Task::TaskAll.new(:task_for_all_components, manifest) do |dir, component|
        $stderr.puts "dir: #{dir}"
        $stderr.puts "component name: #{component.name}"
      end
    end

    it 'should reach all components' do
      pattern =
        'dir: /[^ ]+/component_1_destination\n'                               \
        'component name: component_1\n'                                       \
        'dir: /[^ ]+/leaf_component_1_destination\n'                          \
        'component name: leaf_component_1\n'                                  \
        'dir: /[^ ]+/component_1_destination/leaf_component_2_destination\n'  \
        'component name: leaf_component_2\n'                                  \
        'dir: /[^ ]+/component_2_destination\n'                               \
        'component name: component_2\n'                                       \
        'dir: /[^ ]+/leaf_component_3_destination\n'                          \
        'component name: leaf_component_3'

      expect { subject.execute }.to output(/#{pattern}/).to_stderr
    end
  end
end
