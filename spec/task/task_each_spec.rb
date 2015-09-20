# GitCompound
#
module GitCompound
  describe Task::TaskEach do
    before { create_all_components! }
    let(:manifest) { manifest! }

    subject do
      Task::TaskEach.new(:task_for_manifest_components, manifest) do |dir, component|
        $stderr.puts "dir: #{dir}"
        $stderr.puts "component name: #{component.name}"
      end
    end

    it 'should reach all components' do
      pattern =
        'dir: /[^ ]+/component_1_destination\n'     \
        'component name: component_1\n'             \
        'dir: /[^ ]+/component_2_destination\n'     \
        'component name: component_2\n'

      expect { subject.execute }.to output(/#{pattern}/).to_stderr
    end
  end
end
