# GitCompound
#
module GitCompound
  describe Task::TaskSingle do
    before { create_all_components! }
    let(:manifest) { manifest! }

    subject do
      Task::TaskSingle.new(:task_base_manifest, manifest) do |dir, manifest|
        $stderr.puts "dir: #{dir}"
        $stderr.puts "manifest name: #{manifest.name}"
      end
    end

    it 'should execute task for manifest' do
      expect { subject.execute }.to output(
        "dir: #{@dir}\nmanifest name: base_component\n"
      ).to_stderr
    end
  end
end
